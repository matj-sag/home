---
name: archery-analysis-pipeline
description: "Matt's reusable archery shot-analysis pipeline in ~/archery-videos (pose overlay/comparison from session videos)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 03fca7d0-1f6a-4a4f-94fb-912cedb3d5b1
---

Matt is building a reusable computer-vision pipeline at `~/archery-videos` that turns
session videos (one file = one "end" of ~6 arrows) into release-aligned, body-normalized
pose overlays to compare shot execution. Intended to be re-run on future sessions and on
other archers. Built 2026-06-30.

Key facts (verify against repo before asserting — README.md + config.yaml are the source of truth):
- Matt shoots **recurve with a clicker**, and is the archer **closest to the camera** (others may be in frame).
- Stack: MediaPipe pose (Apache-2.0, CPU), OpenCV-headless, librosa, scipy/sklearn, ffmpeg. Project venv at `.venv`.
- Pipeline = `python -m archery.cli {extract,segment,normalize,clip,compare,run-all}`; stages 1–5 in `archery/`.
- Design: release moment = t0 (clicker audio + release-hand snap); real shots = sustained full-draw holds (wind let-downs rejected); body-normalized coords for archer/camera independence.
- Hardware gotcha: the **Intel Arc GPU MediaPipe delegate corrupts landmarks** (~13px median vs CPU), so extraction uses CPU (`pose.delegate: cpu`).
- Possible future work: DTW warp of the aim phase, hand-landmark detail, cross-video/session-drift comparison.
