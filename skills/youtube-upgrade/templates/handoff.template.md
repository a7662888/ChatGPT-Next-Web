# Handoff - {{job_id}}

## Status
- state: in_progress
- owner: codex
- started_at: {{started_at}}
- finished_at:

## Inputs
- raw_dir: workflow/jobs/raw/{{job_id}}
- primary_video:
- audio_tracks:
- reference_script:

## Pipeline
1. ingest
2. long_edit
3. shorts_cut
4. bilingual_subtitles
5. burn_in (optional)
6. metadata

## Model/Tool Config
- transcription_model:
- translation_model:
- highlight_strategy:
- subtitle_line_limit: zh<=22 / en<=42

## Outputs
- long_video:
- shorts:
- subtitles:
  - zh-TW:
  - en:
- burned_video:
- metadata:
  - title:
  - description:
  - tags:

## Checksums
- (path) sha256:

## Retry Log
- attempt 1:
- attempt 2:

## Blockers
-

## Handoff Notes
-
