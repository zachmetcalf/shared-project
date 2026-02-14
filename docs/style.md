---
title: "style"
has_children: false
nav_order: 3
---

# style

## code

- Prefer simple APIs
- Prefer fail-fast for developer errors (e.g. `ASSERT_COMPILE`, `ASSERT_RUNTIME`)
- Prefer uniform initialization for `shared` types (i.e. `T value{}`)

## naming

- `PascalCase` for types, functions
- `mMemberName` for class members
- `sMemberName` for static members
- `kConstantName` for constants
- Simple temporary locals: `str`, `val`, `it`, `idx`, `sv`, etc.

## structure

- Match existing structure (e.g. branches, comments, includes, spacing, etc.)
- Prefer braces on branch blocks
- Prefer meaningful logging
- Prefer reuse, promotion, testing of repeated logic

## comments

comments in code use the following convention:

```c++
	// <shared> change - *description* </shared>
	// <shared> note - *description* </shared>
	// <shared> todo - *description* </shared>
	// <shared> won't fix - *description* </shared>
```
