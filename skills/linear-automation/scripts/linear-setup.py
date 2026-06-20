#!/usr/bin/env python3
"""
linear-automation: 项目初始化辅助脚本

检查当前项目是否已配置 Linear 跟踪。
如果未配置，输出设置指引；
如果已配置，验证配置有效性。
"""

import json
import os
import sys
from pathlib import Path


def get_git_repo() -> str | None:
    """尝试从 git remote 获取仓库标识"""
    try:
        import subprocess
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            url = result.stdout.strip()
            # 处理常见格式: git@github.com:owner/repo.git 或 https://github.com/owner/repo
            for prefix in ["git@github.com:", "https://github.com/", "https://gitlab.com/"]:
                if prefix in url:
                    repo = url.split(prefix)[1].replace(".git", "")
                    return repo
            return url
    except Exception:
        pass
    return None


def get_repo_name() -> str:
    """从 git remote 或目录名获取项目名"""
    repo = get_git_repo()
    if repo:
        return repo.split("/")[-1] if "/" in repo else repo

    # 回退到目录名
    return Path.cwd().name


def check_config(config_path: Path) -> dict | None:
    """读取并验证现有配置"""
    if not config_path.exists():
        return None

    try:
        with open(config_path, "r", encoding="utf-8") as f:
            config = json.load(f)

        required = ["linear_project_id", "linear_project_name", "linear_team_id"]
        missing = [k for k in required if k not in config]
        if missing:
            print(f"⚠  config.json 缺少必要字段: {', '.join(missing)}")
            return None

        return config
    except (json.JSONDecodeError, IOError) as e:
        print(f"⚠  config.json 读取失败: {e}")
        return None


def print_setup_guide(repo_name: str):
    """打印首次配置指引"""
    print("=" * 60)
    print("  Linear Automation — 首次配置指引")
    print("=" * 60)
    print()
    print(f"  项目: {repo_name}")
    print()
    print("  请按以下步骤操作：")
    print()
    print("  1. 确保 LINEAR_API_KEY 环境变量已设置")
    print()
    print("  2. 运行 Linear MCP 工具获取团队信息：")
    print("     list_teams()")
    print()
    print("  3. 创建 Linear Project：")
    print(f'     save_project(name="{repo_name}", setTeams=["<team-id>"])')
    print()
    print("  4. 验证 config.json 已写入：")
    print("     cat .claude/linear/config.json")
    print()
    print("  5. 复制 MCP 配置（如需）：")
    print("     cp templates/mcp.json .claude/linear/mcp.json")
    print()
    print("=" * 60)


def write_config(project_id: str, project_name: str, team_id: str):
    """写入配置文件"""
    linear_dir = Path.cwd() / ".claude" / "linear"
    linear_dir.mkdir(parents=True, exist_ok=True)

    config = {
        "linear_project_id": project_id,
        "linear_project_name": project_name,
        "linear_team_id": team_id,
        "git_repo": get_git_repo() or "",
        "created_at": __import__("datetime").datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "session_count": 0,
    }

    config_path = linear_dir / "config.json"
    with open(config_path, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)

    print(f"✅ 配置已写入: {config_path}")
    return config


def main():
    linear_dir = Path.cwd() / ".claude" / "linear"
    config_path = linear_dir / "config.json"
    repo_name = get_repo_name()

    # 检查现有配置
    config = check_config(config_path)

    if config:
        print(f"✅ Linear 跟踪已配置:")
        print(f"   Project: {config.get('linear_project_name', 'N/A')}")
        print(f"   Team ID: {config.get('linear_team_id', 'N/A')}")
        print(f"   Git Repo: {config.get('git_repo', 'N/A')}")
        print()
        print(f"   Session 计数: {config.get('session_count', 0)}")
        print(f"   如需重新配置，请删除 {config_path}")
        return 0

    # 未配置，打印指引
    print_setup_guide(repo_name)

    # 检查是否通过命令行参数传入配置
    if len(sys.argv) >= 4:
        write_config(sys.argv[1], sys.argv[2], sys.argv[3])
    elif len(sys.argv) == 3:
        # project_id, project_name, team_id 需要三个参数
        print("\n⚠  参数不足。需要: <project_id> <project_name> <team_id>")
        print("   或者不带参数运行，按照指引手动配置。")

    return 0


if __name__ == "__main__":
    sys.exit(main())
