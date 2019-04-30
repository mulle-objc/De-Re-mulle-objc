---
title: Porting unichar 
keywords: load unload
last_updated: March 26, 2019
tags: [foundation]
summary: "How classes are loaded and how to orchestrate them."
permalink: mydoc_class.html
folder: mydoc
---

Apple Foundation uses UTF-16 as `unichar`, whereas the MulleObjC Foundation used
UTF-32 as `unichar`. As long as your code is not assuming 16-bit for its size, 
there should be no problem.

TODO:  How about `printf` with `%S` ?
