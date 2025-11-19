# Windows Server Inventory & Event Log Commands (PowerShell)

This document lists single-line PowerShell commands to get Windows Server hardware, OS, network, software inventory, and event log errors.

---

## 🖥️ 1. Operating System Information

```powershell
Get-CimInstance Win32_OperatingSystem | Select Caption, Version, BuildNumber, OSArchitecture, LastBootUpTime
```

---

## 🧠 2. Processor (CPU)

```powershell
Get-CimInstance Win32_Processor | Select Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
```

---

## 💾 3. Total RAM

```powershell
Get-CimInstance Win32_ComputerSystem | Select @{n="RAM_GB";e={[math]::Round($_.TotalPhysicalMemory/1GB,2)}}
```

---

## 🔌 4. RAM Modules (Slots)

```powershell
Get-CimInstance Win32_PhysicalMemory | Select Manufacturer, Capacity, Speed, PartNumber
```

---

## 📀 5. Disk Information

```powershell
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
Select DeviceID, VolumeName,
@{n="SizeGB";e={[math]::Round($_.Size/1GB,2)}},
@{n="FreeGB";e={[math]::Round($_.FreeSpace/1GB,2)}}
```

---

## 🌐 6. Network Adapters

```powershell
Get-NetAdapter | Select Name, Status, LinkSpeed, MacAddress
```

---

## 🌍 7. IP Addresses

```powershell
Get-NetIPAddress | Select IPAddress, InterfaceAlias, PrefixLength, AddressFamily
```

---

## 🏭 8. System Manufacturer / Model

```powershell
Get-CimInstance Win32_ComputerSystem | Select Manufacturer, Model
```

---

## 🔏 9. BIOS / Serial Number

```powershell
Get-CimInstance Win32_BIOS | Select SerialNumber
```

---

## 🧱 10. Installed Roles & Features

```powershell
Get-WindowsFeature | Where InstallState -eq Installed | Select DisplayName, Name
```

---

## 📦 11. Installed Software (Programs & Features)

```powershell
Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' |
Select DisplayName, DisplayVersion, Publisher
```

---

## 🚨 12. System Event Log Errors (Last 24 Hours)

```powershell
Get-WinEvent -FilterHashtable @{
    LogName="System";
    Level=1,2,3;
    StartTime=(Get-Date).AddDays(-1)
} | Select TimeCreated, LevelDisplayName, ProviderName, Message
```

---

## 🚨 13. Application Event Log Errors (Last 24 Hours)

```powershell
Get-WinEvent -FilterHashtable @{
    LogName="Application";
    Level=1,2,3;
    StartTime=(Get-Date).AddDays(-1)
} | Select TimeCreated, LevelDisplayName, ProviderName, Message
```

---

## ❗ 14. Only Critical + Error Events

```powershell
Get-WinEvent -FilterHashtable @{Level=1,2} |
Select TimeCreated, ProviderName, Id, Message
```

---

## ⏱️ 15. Server Uptime (Last Boot Time)

```powershell
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime
```

---
