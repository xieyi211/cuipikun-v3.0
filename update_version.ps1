# 更新 version.json 的版本号和时间戳
# 每次发布时运行此脚本，客户端将检测到更新并触发强制备份弹窗
$path = "version.json"
if (Test-Path $path) {
    $json = Get-Content $path | ConvertFrom-Json
    $oldVer = $json.version

    # 自动递增补丁版本号 (如 3.0.0 → 3.0.1)
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

    Write-Host "✅ version.json 已更新"
    Write-Host "   版本: $oldVer → $newVer"
    Write-Host "   时间戳: $($json.timestamp)"
    Write-Host ""
    Write-Host "📢 客户端将在下次轮询时检测到更新，弹出强制备份弹窗。"
    Write-Host "   用户需依次完成 [导出备份] → [导入确认] 方可进入游戏。"
} else {
    Write-Host "❌ 未找到 version.json"
    Write-Host "   创建默认 version.json..."
    $default = @{ version = "3.0.0"; timestamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds() } | ConvertTo-Json
    Set-Content -Path $path -Value $default
    Write-Host "✅ 已创建 $path"
}
