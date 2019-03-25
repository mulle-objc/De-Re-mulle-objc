---
title: nullable is the default in Objective-C
keywords: protocol
last_updated: March 26, 2019
tags: [runtime]
summary: "Don't use it"
sidebar: mydoc_sidebar
permalink: mydoc_nullable.html
folder: mydoc
---

One of the strong points of Objective-C is its gracious handling of
`nil` values, which simplifies coding a lot. Remember that messaging `nil`
also produces `nil`. With the introduction of `nonnullable` `nullable` was
also introduced. It is superflous.

You can easily get rid of `nullable` compile errors with:

```
#define nullable
```

## Tip

Tedious checks for `nil` means you are optimizing your code for the error case.
Use `non-nullable` sparingly. If a `nil` parameter has no ill effect,
don't mark the code `non-nullable`.
