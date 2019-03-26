---
title: id is the generic Objective-Ctype
keywords: protocol
last_updated: March 26, 2019
tags: [compiler]
summary: "The generic type of Objective-C is id, use it"
permalink: mydoc_generics.html
folder: mydoc
---


## Rewrite by removing generics typing

If your parameter is specified as `NSArray<NSNumber *>` reduce the type
to `NSArray *`.


## Validate content at runtime

The way to validate array content in Objective-C is at runtime, when you
are inserting a value:


```
NSParameterAssert( [obj isKindOfClass:[NSNumber class]]);
[array addObject:obj];
```

## Use `id` for truely generic algorithms

If you want true generic algorithms, consider replacing your type with `id`.
You can also then specify the methods your algorithm requires using a
`@protocol` and then type your methods with `id <protocol>`.
This keeps the algorithm the most resusable.

