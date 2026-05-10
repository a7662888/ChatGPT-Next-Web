@echo off
setlocal

REM Portable single-file installer for running directly inside a Vault folder.
set "TARGET=%CD%\skills\youtube-upgrade"
mkdir "%TARGET%" 2>nul
mkdir "%TARGET%\templates" 2>nul

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$skill = @'\n# YouTube 升級版製作技能（長/短影音 + 雙語字幕）\n\n## 目標\n1. 長影音\n2. 短影音\n3. 雙語字幕（zh-TW + en）\n4. 可回溯 handoff\n'@;" ^
  "$tpl = @'\n# Handoff - {{job_id}}\n\n## Status\n- state: in_progress\n- owner: codex\n- started_at: {{started_at}}\n- finished_at:\n\n## Inputs\n- raw_dir: workflow/jobs/raw/{{job_id}}\n\n## Outputs\n- long_video:\n- shorts:\n- subtitles:\n  - zh-TW:\n  - en:\n'@;" ^
  "Set-Content -LiteralPath '%TARGET%\SKILL.md' -Value $skill -Encoding UTF8;" ^
  "Set-Content -LiteralPath '%TARGET%\templates\handoff.template.md' -Value $tpl -Encoding UTF8;"

if errorlevel 1 (
  echo 安裝失敗
  exit /b 1
)

echo 安裝完成: %TARGET%
exit /b 0
