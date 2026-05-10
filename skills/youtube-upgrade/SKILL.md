# YouTube 升級版製作技能（長/短影音 + 雙語字幕）

## 目標
把單一原始素材轉成：
1. 長影音版本（完整剪輯）
2. 短影音版本（可多支）
3. 雙語字幕（zh-TW + en）
4. 可回溯 handoff 記錄

## 目錄約定
- `workflow/jobs/raw/<job_id>/`：原始素材
- `workflow/jobs/output/<job_id>/`：所有輸出
- `workflow/handoff/<job_id>.md`：流程紀錄
- `skills/youtube-upgrade/templates/`：模板

## 標準流程
1. 建立 job：以時間戳建立 `job_id`。
2. 媒體盤點：讀取 raw 目錄中的影片、音訊、腳本。
3. 長影音剪輯：輸出 `long/final.mp4`。
4. 短影音切片：至少輸出 3 支 `shorts/*.mp4`。
5. 字幕生成：先轉錄，再翻譯，輸出 `subs/zh-TW.srt`、`subs/en.srt`。
6. 雙語燒錄（選配）：輸出 `burned/long-bilingual.mp4`。
7. SEO 產物：輸出 `meta/title.txt`、`meta/description.txt`、`meta/tags.txt`。
8. 寫入 handoff：包含輸入、模型、參數、時間、輸出檔案 checksum。

## 品質門檻
- 長影音：解析度 >= 1080p，音畫同步。
- 短影音：9:16，15~60 秒，前 3 秒有 hook。
- 字幕：每行 <= 22 個 CJK 字或 <= 42 英文字符。
- 雙語：同時間碼內 zh-TW 在上、en 在下。

## 失敗重試
- 任一步驟失敗時更新 handoff 狀態為 `blocked`。
- 最多重試 2 次並記錄 error 摘要。
