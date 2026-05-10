# Handoff Log Convention

每個 job 使用一個 `workflow/handoff/<job_id>.md`。

必要欄位：
- 狀態（in_progress/completed/blocked）
- 開始/完成時間（UTC）
- 輸入素材清單
- 輸出檔案路徑
- checksum（sha256）
- 重試與錯誤摘要

此檔案是唯一可回溯來源（single source of truth）。
