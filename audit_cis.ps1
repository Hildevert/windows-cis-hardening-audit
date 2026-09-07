# CIS Benchmark Compliance Check Script for Windows
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       WINDOWS SECURITY AUDIT REPORT      " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Guest Account Status
$guest = Get-LocalUser -Name "Guest" | Select-Object -ExpandProperty Enabled
if ($guest -eq $false) {
    Write-Host "[PASS] Guest Account is Disabled" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Guest Account is Enabled" -ForegroundColor Red
}

# 2. Firewall Status
$firewall = Get-NetFirewallProfile | Select-Object Name, Enabled
foreach ($profile in $firewall) {
    if ($profile.Enabled -eq $true) {
        Write-Host "[PASS] Firewall Profile $($profile.Name): Active" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Firewall Profile $($profile.Name): Inactive" -ForegroundColor Red
    }
}

# 3. Account Lockout Threshold
$lockout = net accounts | Select-String "Lockout threshold"
Write-Host "[INFO] $lockout" -ForegroundColor Yellow

# 4. SMBv1 Protocol Status
$smbv1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
if ($smbv1.State -eq "Disabled") {
    Write-Host "[PASS] SMBv1 Legacy Protocol is Disabled" -ForegroundColor Green
} else {
    Write-Host "[FAIL] SMBv1 Legacy Protocol is Enabled" -ForegroundColor Red
}