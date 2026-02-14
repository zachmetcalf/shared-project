---
title: "style"
has_children: false
nav_order: 3
---

# style

## code

- Prefer simple, encapsulated APIs
- Prefer fail-fast for developer errors (e.g. `ASSERT_COMPILE`, `ASSERT_RUNTIME`)
- Prefer reuse, testing of repeated logic in `shared`
- Prefer uniform initialization for `shared` types (i.e. `T value{}`)
- Prefer meaningful logging
- Match existing structure (e.g. branches, comments, includes, namespaces, spacing, etc.)

## naming

- `PascalCase` for types, functions
- `mMemberName` for class members
- `sMemberName` for static members
- `kConstantName` for constants
- Simple temporary locals: `str`, `val`, `it`, `idx`, `sv`, etc.

## comments

comments in code use the following convention:

```c++
	// <shared> change - *description* </shared>
	// <shared> note - *description* </shared>
	// <shared> todo - *description* </shared>
	// <shared> won't fix - *description* </shared>
```
