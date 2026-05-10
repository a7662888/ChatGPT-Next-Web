# youtube-upgrade 安裝說明

如果你平時把技能放在以下位置：

`C:\Users\User\OneDrive\應用程式\remotely-save\Obsidian Vault`

可以直接執行：

```bash
bash scripts/install-youtube-skill.sh
```

或指定自訂路徑：

```bash
bash scripts/install-youtube-skill.sh "D:\\MyVault"
```

腳本會複製：
- `skills/youtube-upgrade/SKILL.md`
- `skills/youtube-upgrade/templates/handoff.template.md`

到你的 Vault：
- `<Vault>/skills/youtube-upgrade/SKILL.md`
- `<Vault>/skills/youtube-upgrade/templates/handoff.template.md`


Windows 直接雙擊或命令列執行：

```bat
scripts\install-youtube-skill.bat
```


建立影片 job（會產生 handoff 草稿）：

```bash
bash scripts/create-youtube-job.sh "https://www.youtube.com/watch?v=T6wP44r5jQE"
```


> 若你是在 Vault 目錄直接執行 `.bat`，且沒有完整 repo 原始檔，
> 安裝器現在會自動使用內建 fallback 內容建立 `SKILL.md` 與模板。


如果 `scripts\install-youtube-skill.bat` 路徑不存在，請改用單檔版：
1. 複製 repo 根目錄 `install-youtube-skill.bat` 到 Vault 根目錄
2. 在 Vault 根目錄雙擊或執行 `install-youtube-skill.bat`
