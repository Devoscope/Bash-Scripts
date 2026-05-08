
# Google Authenticator MFA for Users in a Specific Group on Ubuntu

This guide explains how to set up **Google Authenticator Multi-Factor Authentication (MFA)** for only a specific group of users (e.g., `mfausers`) when accessing an Ubuntu server over SSH.

---

## ✅ Step-by-Step Instructions

### 🔸 Step 1: Install Google Authenticator PAM Module

```bash
sudo apt update
sudo apt install libpam-google-authenticator
```

---

### 🔸 Step 2: Create an MFA Group

```bash
sudo groupadd mfausers
```

This group will contain users required to use 2FA.

---

### 🔸 Step 3: Add Users to the Group

```bash
sudo usermod -aG mfausers user1
sudo usermod -aG mfausers user2
```

Replace `user1`, `user2`, etc. with actual usernames.

---

### 🔸 Step 4: Create the Conditional Check Script

```bash
sudo nano /usr/local/bin/checkuser
```

Paste the following:

```bash
#!/bin/bash

# Trigger MFA if user is in 'mfausers' group
if id -nG "$PAM_USER" | grep -qw "mfausers"; then
    exit 1
fi

exit 0
```

Make it executable:

```bash
sudo chmod +x /usr/local/bin/checkuser
```

---

### 🔸 Step 5: Configure PAM for SSH

```bash
sudo nano /etc/pam.d/sshd
```

Add the following near the top:

```pam
auth [success=1 default=ignore] pam_exec.so quiet /usr/local/bin/checkuser
auth required pam_google_authenticator.so
```

---

### 🔸 Step 6: Configure SSH for Challenge-Response

```bash
sudo nano /etc/ssh/sshd_config
```

Ensure the following are set (and not commented out):

```
ChallengeResponseAuthentication yes
UsePAM yes
```

For New Ubuntu versions ChallengeResponseAuthentication is not available:

```
KbdInteractiveAuthentication yes
UsePAM yes
```

Then restart SSH:

```bash
sudo systemctl restart sshd
```

---

### 🔸 Step 7: Configure MFA for Each User

Login as each user in the `mfausers` group and run:

```bash
google-authenticator
```

Answer the prompts:
- Time-based tokens: **Y**
- Multiple use of same token: **N**
- Rate limiting: **Y**
- Update config file: **Y**

Scan the QR code using a TOTP app (like Google Authenticator or Authy).

---

### 🔸 Step 8: Test

- ✅ Login as user in `mfausers`: You should be prompted for a TOTP code.
- ✅ Login as user not in `mfausers`: You should not be prompted for MFA.

---

## ✅ Summary

| Task                         | Result                          |
|-----------------------------|----------------------------------|
| Users in `mfausers` group   | Prompted for Google Authenticator |
| Other users                 | No MFA prompt                    |
| SSH config preserved        | ✅ Works for all users normally  |

---

## 🔐 Optional

- Combine SSH Key + MFA
- Log MFA attempts
- Enforce MFA for `sudo` commands

Let us know if you need advanced setups.
