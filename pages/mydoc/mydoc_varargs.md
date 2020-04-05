---
title: Porting Variable Arguments in Methods
keywords: vararg method
last_updated: March 26, 2019
tags: [runtime]
summary: "Variable Arguments in mulle-objc"
permalink: mydoc_varargs.html
folder: mydoc
---

## Intro

Variable arguments in methods follow the Mulle MetaABI and are incompatible
with `va_list`. C functions continue to use `va_list` though. So mulle-objc
will support both formats.

### A typical variable argument method


#### va_list

This is the `+[NSString stringWithFormat:]` method as presumably coded in the
Apple Foundation. Conventionally the `va_list` parameter in Apple Foundation
methods is called "arguments:":


```
+ (instancetype) stringWithFormat:(NSString *) format, ...
{
   NSString   *s;
   va_list    args;

   va_start( args, format);
   s = [self stringWithFormat:format
              arguments:args];
   va_end( args);
   return( s);
}
```


#### mulle_vararg_list


In mulle-objc the type is `mulle_vararg_list`. And if it is used as a
parameter its called "mulleVarargList:" by convention. `va_list` which is still
a possibility type due to C code (e.g. `NSLog`), is called  `varargList:`
instead for discrimination.

This is how `+[NSString stringWithFormat:]` is actually coded in
MulleFoundation:

```
+ (instancetype) stringWithFormat:(NSString *) format, ...
{
   NSString             *s;
   mulle_vararg_list    args;

   mulle_vararg_start( args, format);
   s = [self stringWithFormat:format
              mulleVarargList:args];
   mulle_vararg_end( args);
   return( s);
}
```

So that's pretty similar.


#### mulle-objc supports both

It's not an either or scenarion, as mulle-objc supports both:

```
+ (instancetype) stringWithFormat:(NSString *) format
                  mulleVarargList:(mulle_vararg_list) arguments
{
   return( [[[self alloc] initWithFormat:format
                         mulleVarargList:arguments] autorelease]);
}


+ (instancetype) stringWithFormat:(NSString *) format
                       varargList:(va_list) args
{
   return( [[[self alloc] initWithFormat:format
                                 varargList:args] autorelease]);
}
```


## Accessing variable arguments


The actual access of variable arguments of `mulle_vararg_list` is very
different though.

See [objc-compat](https://github.com/MulleFoundation/objc-compat) for some
details on how to achieve this portably.
