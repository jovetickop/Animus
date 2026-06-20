#!/bin/bash
# linear-automation Stop Hook
# 在会话结束时写入 session-summary.json，由下次会话的 Claude 读取后同步到 Linear
# 不直接调用 Linear API

LINEAR_DIR=".claude/linear"
CONFIG_FILE="$LINEAR_DIR/config.json"
ISSUE_MAP="$LINEAR_DIR/issue-map.json"
SESSION_SUMMARY="$LINEAR_DIR/session-summary.json"

# 如果没有配置文件，说明未设置 Linear 跟踪，静默退出
[ -f "$CONFIG_FILE" ] || exit 0

# 确保 .claude/linear 目录存在
mkdir -p "$LINEAR_DIR"

SESSION_ID="sess-$(date +%s)"

# 如果存在 issue-map.json，统计任务状态
if [ -f "$ISSUE_MAP" ]; then
    if command -v jq >/dev/null 2>&1; then
        IN_PROGRESS=$(jq '[.tasks[] | select(.status == "in_progress")] | length' "$ISSUE_MAP" 2>/dev/null || echo 0)
        DONE=$(jq '[.tasks[] | select(.status == "passed" or .status == "done" or .status == "completed")] | length' "$ISSUE_MAP" 2>/dev/null || echo 0)
        PENDING=$(jq '[.tasks[] | select(.status == "pending")] | length' "$ISSUE_MAP" 2>/dev/null || echo 0)
        TOTAL=$(jq '[.tasks[]] | length' "$ISSUE_MAP" 2>/dev/null || echo 0)

        IN_PROGRESS_TITLES=$(jq -r '[.tasks[] | select(.status == "in_progress") | .title] | join(", ")' "$ISSUE_MAP" 2>/dev/null || echo "")
        DONE_TITLES=$(jq -r '[.tasks[] | select(.status == "passed" or .status == "done" or .status == "completed") | .title] | join(", ")' "$ISSUE_MAP" 2>/dev/null || echo "")

        SUMMARY="Session ended. Tasks: $TOTAL total, $DONE done, $IN_PROGRESS in progress, $PENDING pending."

        cat > "$SESSION_SUMMARY" << EOF
{
  "session_id": "$SESSION_ID",
  "ended_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "tasks_total": $TOTAL,
  "tasks_done": $DONE,
  "tasks_in_progress": $IN_PROGRESS,
  "tasks_pending": $PENDING,
  "in_progress_titles": "$IN_PROGRESS_TITLES",
  "done_titles": "$DONE_TITLES",
  "summary": "$SUMMARY",
  "synced_to_linear": false
}
EOF
    else
        # 没有 jq，写入最小格式的 summary
        cat > "$SESSION_SUMMARY" << EOF
{
  "session_id": "$SESSION_ID",
  "ended_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "summary": "Session ended. Install jq for detailed task breakdown.",
  "synced_to_linear": false
}
EOF
    fi
else
    # 没有 issue-map，写入最小 summary
    cat > "$SESSION_SUMMARY" << EOF
{
  "session_id": "$SESSION_ID",
  "ended_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "summary": "Session ended. No issues tracked yet.",
  "synced_to_linear": false
}
EOF
fi

exit 0
