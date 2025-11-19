# ✅ Windows Server Health Check – Command Reference Guide

## 1. Basic System Information

### OS Version
```powershell
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
```

### Hostname
```cmd
hostname
```

### System Uptime
```powershell
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime
```

## 2. Hardware Information

### CPU Information
```powershell
Get-CimInstance Win32_Processor | select Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
```

### RAM Installed
```powershell
(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
```

### RAM Detailed Info
```powershell
Get-CimInstance Win32_PhysicalMemory | select Manufacturer, PartNumber, Capacity
```

### Disk Information
```powershell
Get-PSDrive -PSProvider FileSystem
```

**Or detailed:**
```powershell
Get-CimInstance Win32_LogicalDisk | select DeviceID, VolumeName, Size, FreeSpace
```

## 3. Disk & Filesystem Health

### Check disk status (SMART)
```cmd
wmic diskdrive get status
```

### Check volume health
```cmd
chkdsk C:
```

## 4. Network & Connectivity

### IP Configuration
```cmd
ipconfig /all
```

### Ping Test
```cmd
ping google.com
```

### DNS Resolution
```cmd
nslookup google.com
```

### Firewall Rules
```powershell
Get-NetFirewallProfile
```

## 5. Service Health

### List all running services
```powershell
Get-Service | Where-Object {$_.Status -eq "Running"}
```

### Check a specific service
```powershell
Get-Service -Name Spooler
```

## 6. Event Viewer – Error Check

### Check critical errors from System log (last 24 hours)
```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; Level=1; StartTime=(Get-Date).AddDays(-1)}
```

### Check errors from Application log
```powershell
Get-WinEvent -FilterHashtable @{LogName='Application'; Level=2} | select TimeCreated, Id, Message
```

### List the last 20 errors
```powershell
Get-EventLog -LogName System -EntryType Error -Newest 20
```

## 7. Installed Updates / Patch Status

### List installed Windows updates
```cmd
wmic qfe list
```

### Latest updates only
```powershell
Get-HotFix | sort InstalledOn -Descending
```

## 8. Performance / Load Issues

### CPU Usage
```powershell
Get-WmiObject win32_processor | select LoadPercentage
```

### Memory Usage
```powershell
Get-Counter -Counter "\Memory\Available MBytes"
```

### Top 10 high CPU processes
```powershell
Get-Process | Sort CPU -Descending | Select -First 10
```

## 9. Network Ports & Listening Services

### Open/listening ports
```cmd
netstat -ano
```

### Match PID to process
```powershell
Get-Process -Id <PID>
```

## 10. Windows Activation Status

```cmd
slmgr /xpr
```

## 11. Domain & User Information

### Check if server is domain-joined
```cmd
systeminfo | findstr /C:"Domain"
```

### Logged-in users
```cmd
query user
```

## 12. Scheduled Tasks Status

### List tasks
```cmd
schtasks /query /v /fo list
```

## 13. Check Windows Defender Status

```powershell
Get-MpComputerStatus
```
