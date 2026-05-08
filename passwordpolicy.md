# Ubuntu Password Policy Hardening Guide

## Overview

This guide explains how to implement a strong password policy on an Ubuntu server using:

- PAM (Pluggable Authentication Modules)
- pwquality
- login.defs
- password aging policies
- account lockout protection

This setup helps improve Linux server security and compliance.

---

# 1. Update the Server

```bash
sudo apt update && sudo apt upgrade -y
```

---

# 2. Install Required Packages

Install PAM password quality modules:

```bash
sudo apt install libpam-pwquality -y
```

---

# 3. Configure Password Complexity Policy

Edit:

```bash
sudo nano /etc/security/pwquality.conf
```

Add or modify the following settings:

```ini
minlen = 12
minclass = 4
maxrepeat = 3
maxclassrepeat = 3
difok = 4
ucredit = -1
lcredit = -1
dcredit = -1
ocredit = -1
retry = 3
enforce_for_root
```

## Explanation

| Setting | Description |
|---|---|
| minlen = 12 | Minimum password length |
| minclass = 4 | Requires uppercase, lowercase, digit, special character |
| maxrepeat = 3 | Limits repeated characters |
| difok = 4 | Requires password difference from previous password |
| ucredit = -1 | Requires at least one uppercase letter |
| lcredit = -1 | Requires at least one lowercase letter |
| dcredit = -1 | Requires at least one number |
| ocredit = -1 | Requires at least one special character |
| retry = 3 | Maximum retry attempts |
| enforce_for_root | Applies policy to root user |

---

# 4. Configure PAM Password Enforcement

Edit:

```bash
sudo nano /etc/pam.d/common-password
```

Find the line containing:

```text
pam_pwquality.so
```

Example:

```text
password requisite pam_pwquality.so retry=3
```

Ensure this line exists before:

```text
pam_unix.so
```

Example final configuration:

```text
password requisite pam_pwquality.so retry=3
password [success=1 default=ignore] pam_unix.so obscure use_authtok try_first_pass yescrypt
```

---

# 5. Configure Password Expiry Policy

Edit:

```bash
sudo nano /etc/login.defs
```

Modify:

```ini
PASS_MAX_DAYS   90
PASS_MIN_DAYS   1
PASS_WARN_AGE   7
```

## Explanation

| Setting | Description |
|---|---|
| PASS_MAX_DAYS 90 | Password expires after 90 days |
| PASS_MIN_DAYS 1 | User must wait 1 day before changing password again |
| PASS_WARN_AGE 7 | Warn user 7 days before password expiry |

---

# 6. Apply Password Aging to Existing Users

Check current settings:

```bash
sudo chage -l username
```

Apply policy:

```bash
sudo chage -M 90 -m 1 -W 7 username
```

Example:

```bash
sudo chage -M 90 -m 1 -W 7 altius
```

---

# 7. Configure Account Lockout Policy

Ubuntu 22.04+ uses pam_faillock.

Edit:

```bash
sudo nano /etc/pam.d/common-auth
```

Add these lines near the top:

```text
auth required pam_faillock.so preauth silent deny=5 unlock_time=900
auth [success=1 default=bad] pam_unix.so
auth [default=die] pam_faillock.so authfail deny=5 unlock_time=900
auth sufficient pam_faillock.so authsucc deny=5 unlock_time=900
```

## Explanation

| Setting | Description |
|---|---|
| deny=5 | Lock account after 5 failed attempts |
| unlock_time=900 | Unlock after 900 seconds (15 minutes) |

---

# 8. Verify Password Policy

Test password change:

```bash
passwd
```

Try weak passwords such as:

```text
password123
admin
12345678
```

They should be rejected.

---

# 9. Check Password Expiry Status

```bash
sudo chage -l username
```

Example output:

```text
Maximum number of days between password change : 90
Minimum number of days between password change : 1
Number of days of warning before password expires : 7
```

---

# 10. Force Password Change on Next Login

```bash
sudo chage -d 0 username
```

Example:

```bash
sudo chage -d 0 altius
```

---

# 11. Unlock Locked Accounts

Check failed login attempts:

```bash
sudo faillock
```

Reset failed attempts:

```bash
sudo faillock --user username --reset
```

Example:

```bash
sudo faillock --user altius --reset
```

---

# 12. Recommended Enterprise Password Policy

## Recommended Settings

| Policy | Recommended Value |
|---|---|
| Minimum length | 12–16 characters |
| Password expiry | 90 days |
| Failed attempts | 5 |
| Lock duration | 15 minutes |
| Password history | 5 previous passwords |
| MFA | Enabled |

---

# 13. Enable Password History

Prevent reuse of old passwords.

Edit:

```bash
sudo nano /etc/pam.d/common-password
```

Modify:

```text
password requisite pam_pwhistory.so remember=5 retry=3
```

Example final section:

```text
password requisite pam_pwhistory.so remember=5 retry=3
password requisite pam_pwquality.so retry=3
password [success=1 default=ignore] pam_unix.so obscure use_authtok try_first_pass yescrypt
```

---

# 14. Verify PAM Configuration

Check PAM files:

```bash
sudo pam-auth-update
```

Validate configuration syntax:

```bash
sudo pwck
```

---

# 15. Monitor Authentication Logs

Ubuntu authentication logs:

```bash
sudo tail -f /var/log/auth.log
```

Search failed logins:

```bash
sudo grep "Failed password" /var/log/auth.log
```

---

# 16. Security Best Practices

Recommended:

- Disable root SSH login
- Use SSH keys instead of passwords
- Enable MFA
- Install Fail2Ban
- Enable UFW firewall
- Use password manager
- Rotate passwords regularly
- Monitor authentication logs

---

# 17. Rollback Changes

## Remove pwquality

```bash
sudo apt remove libpam-pwquality -y
```

## Restore PAM files

Restore backups if available:

```bash
sudo cp /etc/pam.d/common-password.bak /etc/pam.d/common-password
sudo cp /etc/pam.d/common-auth.bak /etc/pam.d/common-auth
```

---

# 18. Backup PAM Configuration Before Changes

Recommended before modifying PAM:

```bash
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.bak
sudo cp /etc/pam.d/common-auth /etc/pam.d/c
