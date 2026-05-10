@echo off
setlocal ENABLEDELAYEDEXPANSION

set "DEFAULT_TARGET=C:\Users\User\OneDrive\應用程式\remotely-save\Obsidian Vault"
set "TARGET_PATH=%~1"
if "%TARGET_PATH%"=="" set "TARGET_PATH=%DEFAULT_TARGET%"

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "REPO_ROOT=%%~fI"
set "SRC_DIR=%REPO_ROOT%\skills\youtube-upgrade"
set "DEST_DIR=%TARGET_PATH%\skills\youtube-upgrade"

mkdir "%DEST_DIR%" 2>nul
mkdir "%DEST_DIR%\templates" 2>nul

if exist "%SRC_DIR%\SKILL.md" (
  copy /Y "%SRC_DIR%\SKILL.md" "%DEST_DIR%\SKILL.md" >nul || exit /b 1
  copy /Y "%SRC_DIR%\templates\handoff.template.md" "%DEST_DIR%\templates\handoff.template.md" >nul || exit /b 1
  echo Installed youtube-upgrade skill from repo source to: %DEST_DIR%
  exit /b 0
)

echo Repo source not found. Creating built-in fallback skill files...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$skill = @'\n# YouTube 升級版製作技能（長/短影音 + 雙語字幕）\n\n## 目標\n1. 長影音\n2. 短影音\n3. 雙語字幕（zh-TW + en）\n4. 可回溯 handoff\n'@;" ^
  "$tpl = @'\n# Handoff - {{job_id}}\n\n## Status\n- state: in_progress\n- owner: codex\n- started_at: {{started_at}}\n- finished_at:\n\n## Inputs\n- raw_dir: workflow/jobs/raw/{{job_id}}\n\n## Outputs\n- long_video:\n- shorts:\n- subtitles:\n  - zh-TW:\n  - en:\n'@;" ^
  "Set-Content -LiteralPath '%DEST_DIR%\SKILL.md' -Value $skill -Encoding UTF8;" ^
  "Set-Content -LiteralPath '%DEST_DIR%\templates\handoff.template.md' -Value $tpl -Encoding UTF8;"

if errorlevel 1 exit /b 1

echo Installed youtube-upgrade skill using fallback content to: %DEST_DIR%
exit /b 0
