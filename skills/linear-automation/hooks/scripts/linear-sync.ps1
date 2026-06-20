# linear-automation Stop Hook (Windows)
# 在会话结束时写入 session-summary.json，由下次会话的 Claude 读取后同步到 Linear
# 不直接调用 Linear API

$LinearDir = ".claude\linear"
$ConfigFile = "$LinearDir\config.json"
$IssueMap = "$LinearDir\issue-map.json"
$SessionSummary = "$LinearDir\session-summary.json"

# 如果没有配置文件，说明未设置 Linear 跟踪，静默退出
if (-not (Test-Path $ConfigFile)) { exit 0 }

# 确保目录存在
New-Item -ItemType Directory -Path $LinearDir -Force | Out-Null

$SessionId = "sess-$([int][double]::Parse((Get-Date -UFormat %s)))"
$EndedAt = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")

# 如果存在 issue-map.json，统计任务状态
if (Test-Path $IssueMap) {
    try {
        $IssueData = Get-Content $IssueMap -Raw -Encoding UTF8 | ConvertFrom-Json
        $Tasks = $IssueData.tasks
        $Total = $Tasks.Count
        $InProgress = @($Tasks | Where-Object { $_.status -eq "in_progress" }).Count
        $Done = @($Tasks | Where-Object { $_.status -eq "passed" -or $_.status -eq "done" -or $_.status -eq "completed" }).Count
        $Pending = @($Tasks | Where-Object { $_.status -eq "pending" }).Count
        $InProgressTitles = ($Tasks | Where-Object { $_.status -eq "in_progress" } | ForEach-Object { $_.title }) -join ", "
        $DoneTitles = ($Tasks | Where-Object { $_.status -eq "passed" -or $_.status -eq "done" -or $_.status -eq "completed" } | ForEach-Object { $_.title }) -join ", "
        $Summary = "Session ended. Tasks: $Total total, $Done done, $InProgress in progress, $Pending pending."

        $SummaryObj = @{
            session_id = $SessionId
            ended_at = $EndedAt
            tasks_total = $Total
            tasks_done = $Done
            tasks_in_progress = $InProgress
            tasks_pending = $Pending
            in_progress_titles = $InProgressTitles
            done_titles = $DoneTitles
            summary = $Summary
            synced_to_linear = $false
        }
        $SummaryObj | ConvertTo-Json -Depth 10 | Set-Content $SessionSummary -Encoding UTF8
    } catch {
        $SummaryObj = @{
            session_id = $SessionId
            ended_at = $EndedAt
            summary = "Session ended. Error reading issue-map.json."
            synced_to_linear = $false
        }
        $SummaryObj | ConvertTo-Json -Depth 10 | Set-Content $SessionSummary -Encoding UTF8
    }
} else {
    $SummaryObj = @{
        session_id = $SessionId
        ended_at = $EndedAt
        summary = "Session ended. No issues tracked yet."
        synced_to_linear = $false
    }
    $SummaryObj | ConvertTo-Json -Depth 10 | Set-Content $SessionSummary -Encoding UTF8
}

exit 0
