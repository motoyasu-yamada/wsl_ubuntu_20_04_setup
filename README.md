# Windows開発作業環境構築

一度準備すれば他のプロジェクトでも共通の構築手順です

## Windows WSL環境の構築
- WSL2 / Ubuntsu-20.0.4 インスタンスの起動
- WSL2 <-> Windowsホスト間の 80,3000,3001,7200,5967 ポートを疎通させる
    - Windows側で管理者権限でPowerShellコンソールを起動
    - リポジトリホームへ移動 (例: `\\wsl.localhost\Ubuntu-22.04\home\workspaces\wsl_ubuntu_20_04_setup`)
    - `powershell -NoProfile -ExecutionPolicy Unrestricted .\wsl-proxy.ps1`