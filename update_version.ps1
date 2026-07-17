# Update version.json version number and timestamp
# Run this script on each release; client detects update and shows mandatory backup modal
$path = "version.json"
if (Test-Path $path) {
    $json = Get-Content $path | ConvertFrom-Json
    $oldVer = $json.version

    # Auto-increment patch version (e.g. 3.0.0 -> 3.0.1)
    $parts = $oldVer -split '\.'
    if ($parts.Length -eq 3) {
        $parts[2] = [int]$parts[2] + 1
        $newVer = $parts -join '.'
    } else {
        $newVer = "3.0.1"
    }

    $json.version = $newVer
    $json.timestamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $json | ConvertTo-Json | Set-Content $path

    Write-Host "[OK] version.json updated"
    Write-Host "     Version: $oldVer -> $newVer"
    Write-Host "     Timestamp: $($json.timestamp)"
    Write-Host ""
    Write-Host "[NOTICE] Client will detect update on next poll and show mandatory backup modal."
    Write-Host "     User must complete [Export backup] -> [Import confirm] to enter the app."
} else {
    Write-Host "[ERROR] version.json not found"
    Write-Host "     Creating default version.json..."
    $default = @{ version = "3.0.0"; timestamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds() } | ConvertTo-Json
    Set-Content -Path $path -Value $default
    Write-Host "[OK] Created $path"
}
