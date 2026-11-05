---
commit: 4f9e2a1
updated: 2026-11-05T19:40
status: active
files: [src/orders/list.py, src/orders/cursor.py, tests/test_cursor.py]
plan: docs/plans/paginacao-pedidos.md
---

# Objective
Adicionar paginação por cursor na listagem `GET /orders` em `src/orders/list.py`.

# Decisions
- Cursor `(created_at, id)` em vez de `OFFSET`: `OFFSET` relê as linhas puladas e degrada com o volume. O cursor usa o índice `orders_created_id_idx`.
- Limite de 100 itens por página: contrato já publicado para o app mobile. Não aumentar sem alinhar com o time mobile.

# Discarded
- Paginação por número de página: um pedido novo durante a navegação duplicaria itens.

# State
- Done and verified: encode/decode do cursor em `src/orders/cursor.py`, com `pytest tests/test_cursor.py` passando (12 testes).
- Half-done: o endpoint devolve `next_cursor`, mas o teste de integração ainda não cobre cursor inválido.

# Next step
Escrever o teste de cursor inválido em `tests/test_orders_list.py`. Esperado: HTTP 400 com `error: invalid_cursor`.

# Pitfalls
- `created_at` sem microssegundos gerava cursores repetidos. Resolvido: serializar com precisão de microssegundos.
- Com filtro de status, o `ORDER BY` secundário por `id` era ignorado. Corrigido na query, ainda sem teste de regressão.
