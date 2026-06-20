# setup.ps1 — animus-toolkit 自动配置脚本
# 运行方式：powershell -File setup.ps1

$pluginDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$settingsPath = "$env:USERPROFILE\.claude\settings.json"
$statuslinePath = "$pluginDir\hooks\statusline.sh"

Write-Host "=== animus-toolkit 自动配置 ===" -ForegroundColor Cyan
Write-Host "检测到插件安装路径: $pluginDir`n"

# 读取 settings.json，不存在则创建空对象
if (Test-Path $settingsPath) {
  $jsonObj = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
  Write-Host "  ⚠️  未找到 settings.json，将创建新文件" -ForegroundColor Yellow
  $jsonObj = New-Object PSObject
}
$modified = $false

# 1. statusLine 配置
if ($jsonObj.statusLine) {
  $choice = Read-Host "检测到已有 statusLine 配置，是否覆盖为插件版本？(y=覆盖/n=保留) [n]"
  if ($choice -eq 'y') {
    $jsonObj.statusLine = @{
      command = "bash $($statuslinePath -replace '\\', '/')"
      type = "command"
    }
    $modified = $true
    Write-Host "  ✅ statusLine 已覆盖" -ForegroundColor Green
  } else {
    Write-Host "  ⏭️  保留现有 statusLine" -ForegroundColor Yellow
  }
} else {
  $jsonObj | Add-Member -NotePropertyName "statusLine" -NotePropertyValue @{
    command = "bash $($statuslinePath -replace '\\', '/')"
    type = "command"
  } -Force
  $modified = $true
  Write-Host "  ✅ statusLine 已配置" -ForegroundColor Green
}

# 2. 环境变量冲突处理（逐条询问）
$envVars = @{
  "CLAUDE_CODE_EFFORT_LEVEL" = "max"
  "CLAUDE_CODE_NO_FLICKER" = "1"
  "CLAUDE_CODE_WORKFLOWS" = "1"
  "DISABLE_AUTOUPDATER" = "1"
  "DISABLE_GROWTHBOOK" = "1"
  "ENABLE_TOOL_SEARCH" = "true"
}

# 确保 env 段存在
if (-not $jsonObj.env) {
  $jsonObj | Add-Member -NotePropertyName "env" -NotePropertyValue (@{ } -as [PSCustomObject]) -Force
}

foreach ($key in $envVars.Keys) {
  $existingValue = $jsonObj.env.$key
  if ($existingValue) {
    $choice = Read-Host "检测到 $key=$existingValue，是否覆盖为 '$($envVars[$key])'？(y=覆盖/n=保留) [n]"
    if ($choice -eq 'y') {
      $jsonObj.env.$key = $envVars[$key]
      $modified = $true
      Write-Host "  ✅ $key 已更新" -ForegroundColor Green
    } else {
      Write-Host "  ⏭️  保留 $key" -ForegroundColor Yellow
    }
  } else {
    $jsonObj.env | Add-Member -NotePropertyName $key -NotePropertyValue $envVars[$key] -Force
    $modified = $true
  }
}

# 3. 启用插件
if (-not $jsonObj.enabledPlugins) {
  $jsonObj | Add-Member -NotePropertyName "enabledPlugins" -NotePropertyValue (@{ } -as [PSCustomObject]) -Force
}
if (-not ($jsonObj.enabledPlugins.'animus-toolkit@animus-toolkit-marketplace')) {
  $choice = Read-Host "是否将 animus-toolkit 添加到 enabledPlugins？(y=是/n=跳过) [y]"
  if ($choice -ne 'n') {
    $jsonObj.enabledPlugins | Add-Member -NotePropertyName "animus-toolkit@animus-toolkit-marketplace" -NotePropertyValue $true -Force
    $modified = $true
    Write-Host "  ✅ 已添加 animus-toolkit 到 enabledPlugins" -ForegroundColor Green
  }
}

# 写回文件
if ($modified) {
  $jsonObj | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
  Write-Host "`n✅ 配置已更新到 $settingsPath" -ForegroundColor Green
} else {
  Write-Host "`n⏭️  无需修改" -ForegroundColor Yellow
}

Write-Host "`n=== 配置完成 ===" -ForegroundColor Cyan
Write-Host "请重启 Claude Code 或执行 /reload-plugins 使配置生效"
