---
title: Porting code with ^blocks
keywords: load unload
last_updated: March 26, 2019
tags: [language]
summary: "There are no blocks and never will be"
permalink: mydoc_block.html
folder: mydoc
---


## Disable blocks

A good first step is to wrap all method declarations and definitions with

```
#ifdef __has_extension(blocks)
#endif
```

If you are lucky, blocks are just a non-integral,value-added feature
in the ported library.


## Rewrite

Generally at this point, you should check _how much_ blocks code there is.
If it is used only a few places, here are some ideas how to convert the code
for MulleObjC.

### Transform to NSInvocation

Blocks that are stored for later execution, are basically a form of
`NSInvocation`. Transform your blocks code into a method and create an
`NSInvocation` for it.


### Transform to C function

If the block is used immediately, perhaps to map it to an NSArray,
extract the code into a C function. Encapsulate the parameters into a C
struct. No

