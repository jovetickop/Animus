# setup.ps1 — animus-toolkit 自动配置脚本
# 运行方式：powershell -File setup.ps1

$pluginDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$settingsPath = "$env:USERPROFILE\.claude\settings.json"
$statuslinePath = "$pluginDir\hooks\statusline.sh"

Write-Host "=== animus-toolkit 自动配置 ===" -ForegroundColor Cyan
Write-Host "检测到插件安装路径: $pluginDir`n"

$content = Get-Content $settingsPath -Raw
$modified = $false

# 1. statusLine 冲突处理
if ($content -match '"statusLine"') {
  $choice = Read-Host "检测到已有 statusLine 配置，是否覆盖为插件版本？(y=覆盖/n=保留) [n]"
  if ($choice -eq 'y') {
    $content = $content -replace '"statusLine"\s*:\s*\{[^}]*\}', ''
    $modified = $true
    Write-Host "  ✅ 已清除旧 statusLine，将在最后写入新配置" -ForegroundColor Green
  } else {
    Write-Host "  ⏭️  保留现有 statusLine" -ForegroundColor Yellow
  }
}

# 写入新 statusLine
$statusLineConfig = @"
,"statusLine": {
    "command": "bash $($statuslinePath -replace '\\', '/')",
    "type": "command"
  }
"@
$content = $content.TrimEnd() -replace '\}$', "$statusLineConfig`n}"

# 2. 环境变量冲突处理（逐条询问）
$envVars = @{
  "CLAUDE_CODE_EFFORT_LEVEL" = "max"
  "CLAUDE_CODE_NO_FLICKER" = "1"
  "CLAUDE_CODE_WORKFLOWS" = "1"
  "DISABLE_AUTOUPDATER" = "1"
  "DISABLE_GROWTHBOOK" = "1"
  "ENABLE_TOOL_SEARCH" = "true"
}

foreach ($key in $envVars.Keys) {
  $pattern = '"' + $key + '"\s*:\s*"[^"]*"'
  if ($content -match $pattern) {
    $currentValue = [regex]::Match($content, $pattern).Value
    $choice = Read-Host "检测到 $key=$currentValue，是否覆盖为 '$($envVars[$key])'？(y=覆盖/n=保留) [n]"
    if ($choice -eq 'y') {
      $content = $content -replace $pattern, "`"$key`": `"$($envVars[$key])`""
      $modified = $true
      Write-Host "  ✅ $key 已更新" -ForegroundColor Green
    } else {
      Write-Host "  ⏭️  保留 $key" -ForegroundColor Yellow
    }
  } else {
    if ($content -match '"env"\s*:\s*\{') {
      $content = $content -replace '(?<="env"\s*:\s*\{)', "`n    `"$key`": `"$($envVars[$key])`","
      $modified = $true
    }
  }
}

# 3. 启用插件
if ($content -notmatch 'animus-toolkit@animus-toolkit-marketplace') {
  $choice = Read-Host "是否将 animus-toolkit 添加到 enabledPlugins？(y=是/n=跳过) [y]"
  if ($choice -ne 'n') {
    $content = $content -replace '"enabledPlugins"\s*:\s*\{', "`"enabledPlugins`": {`n    `"animus-toolkit@animus-toolkit-marketplace`": true,"
    $modified = $true
    Write-Host "  ✅ 已添加 animus-toolkit 到 enabledPlugins" -ForegroundColor Green
  }
}

if ($modified) {
  Set-Content $settingsPath $content -NoNewline
  Write-Host "`n✅ 配置已更新到 $settingsPath" -ForegroundColor Green
} else {
  Write-Host "`n⏭️  无需修改" -ForegroundColor Yellow
}

Write-Host "`n=== 配置完成 ===" -ForegroundColor Cyan
Write-Host "请重启 Claude Code 或执行 /reload-plugins 使配置生效"
