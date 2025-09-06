# AI-TEAM-TMUX 🚀

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![tmux](https://img.shields.io/badge/tmux-3.0%2B-green.svg)](https://github.com/tmux/tmux)

マルチAI協調開発環境 - Claude、Cursor、Codex、Geminiを統合されたtmuxインターフェースで同時利用

[English](README.md) | [日本語](#japanese)

## 🌟 概要

AI-TEAM-TMUXは、複数のAIアシスタントを単一のtmuxワークスペースに統合したツールです。異なるAIの強みを同時に活用したい開発者に最適です。

![AI-Team-Tmux ダイアグラム](screenshots/ai-team-tmux-diagram.png)

## ✨ 特徴

- 📐 **Quadレイアウト** - 2x2グリッドで4つのAI
- 🖱️ **マウスサポート** - クリックでペイン切り替え
- 🔄 **簡単なセッション管理** - 作成、一覧表示、削除が簡単

## 🚀 クイックスタート

### 前提条件

- tmux 3.0以上
- AI CLIツールがインストール済み：
  - `claude` - Claude AI CLI
  - `cursor-agent` - Cursor AI CLI
  - `codex` - Codex AI CLI
  - `gemini` - Gemini AI CLI
- Bash 4.0+

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/cruzyjapan/AI-Team-Tmux.git
cd AI-Team-Tmux

# 初期セットアップを実行（推奨）
./init.sh setup

# または手動で実行可能にする
chmod +x ai-team-tmux

# デフォルトレイアウトで起動
./ai-team-tmux
```

### Quadレイアウト（2x2グリッド）
4つのAIを2x2グリッドで表示：
```
┌─────────────┬─────────────┐
│ 0: Claude   │ 2: Cursor                             │
├─────────────┼─────────────┤
│ 1: Codex    │ 3: Gemini                             │
└─────────────┴─────────────┘
```

## 🎨 視覚的識別

各AIペインには識別しやすいように固有の絵文字が表示されます：

- **Claude**: 🤖
- **Cursor**: 🖱️
- **Codex**: 🔧
- **Gemini**: ✨

## 🎯 使用方法

### 基本コマンド

```bash
# デフォルトセッションで起動
./ai-team-tmux

# 名前付きセッションで起動
./ai-team-tmux my-session

# アクティブなセッションを一覧表示
./ai-team-tmux --list

# セッションを終了
./ai-team-tmux --kill my-session

# ヘルプを表示
./ai-team-tmux --help
```

## 🔧 設定

セッションとログは以下に保存されます：
```
~/.config/ai-team-tmux/     # 設定
~/.local/share/ai-team-tmux/
├── logs/                   # セッションログ
└── recordings/             # セッション記録
```

### セットアップとメンテナンススクリプト

`init.sh`を使用してセットアップとログ管理を行います：

```bash
# 初期セットアップ - ディレクトリと設定ファイルを作成
./init.sh setup

# システムステータスを確認
./init.sh status

# 古いログを削除（7日以上前）
./init.sh clean-logs

# カスタム保持期間で古いログを削除
./init.sh clean-logs 30  # 30日以上前のログを削除

# すべてのログを削除
./init.sh clean-all-logs

# ヘルプを表示
./init.sh help
```

### 設定ファイル

設定ファイル（`~/.config/ai-team-tmux/config.conf`）では以下が可能です：
- ログの有効/無効
- セッション記録の有効/無効
- ログ保持日数の設定
- AIコマンドパスのカスタマイズ

## 🐛 トラブルシューティング

### AIツールが見つからない
AI CLIがインストールされ、PATHに含まれていることを確認：
```bash
which claude
which cursor-agent
which codex
which gemini
```

### セッションが既に存在する
```bash
./ai-team-tmux --kill session-name
./ai-team-tmux session-name
```

### tmuxが見つからない
```bash
# Ubuntu/Debian
sudo apt-get install tmux

# macOS
brew install tmux
```

## 📝 ライセンス

MITライセンス - 詳細は[LICENSE](LICENSE)ファイルを参照

## 🙏 謝辞

- Anthropic製Claude
- Anysphere製Cursor
- OpenAI製Codex
- Google製Gemini

---

**AI支援開発コミュニティのために❤️で作られました**