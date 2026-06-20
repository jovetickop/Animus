# 配置分离指南

## 为什么需要配置分离？

`~/.claude/settings.json` 中混合了两种不同类型的配置：

- **公共配置**：插件相关、statusLine、feature flags 等，应在多台设备间保持一致
- **私有配置**：model 选择、API keys、代理地址、权限列表等，因设备/环境而异

分离管理可以让 animus 插件安装后自动生效，同时私有配置不受影响。

## 配置映射

| 文件 | 内容 | 优先级 |
|------|------|--------|
| `~/.claude/settings.json` | 私有配置（model、API keys、代理、权限等） | 低 |
| `~/.claude/settings.local.json` | 公共配置（插件启用、statusLine 等） | 高（覆盖 settings.json） |

`settings.local.json` 优先级更高，且不会被 Claude Code 更新覆盖，是放置插件公共配置的理想位置。

## 自动部署

animus 插件安装后，运行 setup 脚本即可自动写入公共配置：

```powershell
powershell -File <安装路径>/scripts/setup.ps1
```

setup 脚本会将 `config/settings.local.json` 拷贝到 `~/.claude/settings.local.json`，包含：

- **enabledPlugins**：自动启用 animus 及相关插件
- **statusLine**：状态栏配置（claude-hud）

## 手动管理

### 私有配置（settings.json）

```json
{
  "model": "haiku",
  "env": {
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:15721",
    "ANTHROPIC_AUTH_TOKEN": "your-token",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4-5"
  },
  "permissions": {
    "allow": [...]
  }
}
```

### 公共配置（settings.local.json）

由插件 setup 脚本管理，通常不需要手动编辑。如需自定义，直接编辑 `~/.claude/settings.local.json` 即可覆盖插件的默认值。

## 多设备场景

1. 每台设备安装 animus 插件
2. 运行 setup 脚本 → 公共配置自动生效
3. 每台设备独立配置 `settings.json`（model、API keys 等按设备设置）
