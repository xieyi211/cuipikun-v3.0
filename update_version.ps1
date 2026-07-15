# 更新 version.json 的时间戳
$path = "version.json"
if (Test-Path $path) {
    $json = Get-Content $path | ConvertFrom-Json
    $json.timestamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $json | ConvertTo-Json | Set-Content $path
    Write-Host "✅ version.json 已更新时间戳为: $($json.timestamp)"
} else {
    Write-Host "❌ 未找到 version.json"
}
