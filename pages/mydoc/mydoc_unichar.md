---
title: Porting unichar
keywords: load unload
last_updated: March 26, 2019
tags: [foundation]
summary: "How classes are loaded and how to orchestrate them."
permalink: mydoc_class.html
folder: mydoc
---

Apple Foundation uses UTF-16 as `unichar`, whereas the mulle-objc Foundation used
UTF-32 as `unichar`. As long as your code is not assuming 16-bit for its size,
there should be no problem.

When accessing string contents as `unichar *` with `dataUsingEncoding:` use the
generic `NSUnicodeStringEncoding` instead of `NSUTF32StringEncoding`/`NSUTF16StringEncoding`.

```
  data = [s dataUsingEncoding:NSUnicodeStringEncoding];
  here_some_unichars( (unichar *) [data bytes], [data length] / sizeof( unichar));
```

TODO:  How about `printf` with `%S` ?
