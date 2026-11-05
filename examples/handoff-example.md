---
commit: 4f9e2a1
updated: 2026-11-05T19:40
status: active
files: [src/orders/list.py, src/orders/cursor.py, tests/test_cursor.py]
plan: docs/plans/orders-pagination.md
---

# Objective
Add cursor-based pagination to `GET /orders` in `src/orders/list.py`.

# Decisions
- Cursor `(created_at, id)` instead of `OFFSET`: `OFFSET` rereads the skipped rows and degrades as volume grows. The cursor uses the `orders_created_id_idx` index.
- Page size capped at 100 items: already published as the contract for the mobile app. Do not raise it without aligning with the mobile team.

# Discarded
- Page-number pagination: a new order arriving during navigation would duplicate items.

# State
- Done and verified: cursor encode/decode in `src/orders/cursor.py`, with `pytest tests/test_cursor.py` passing (12 tests).
- Half-done: the endpoint returns `next_cursor`, but the integration test does not cover an invalid cursor yet.

# Next step
Write the invalid-cursor test in `tests/test_orders_list.py`. Expected: HTTP 400 with `error: invalid_cursor`.

# Pitfalls
- `created_at` without microseconds produced repeated cursors. Resolved: serialize with microsecond precision.
- With a status filter, the secondary `ORDER BY id` was ignored. Fixed in the query, regression test still missing.
