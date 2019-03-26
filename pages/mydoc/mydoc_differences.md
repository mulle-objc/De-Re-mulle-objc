---
title: Differences to Objective-C 2.0
keywords: class
last_updated: March 26, 2019
tags: [language,compiler,runtime]
summary: "But how can less be more ? It's impossible! More is more! -- Y. Malmsteen"
permalink: mydoc_differences.html
folder: mydoc
---

In terms of language features, **mulle_objc** resets the basis of Objective-C
back to ObjC 1.0 and cherrypicks improvements from the later versions.



## Differences to Objective-C 2.0

Do not use the "not planned" features even if the **mulle-objc** compiler might
still understand them. The runtime or the linker will not support them.


Topic                     | State                                  | Link
--------------------------|----------------------------------------|----------
**@compatibility_alias**  | unknown | ([what is this ?](https://www.acrc.bris.ac.uk/acrc/RedHat/rhel-gcc-en-4/compatibility_alias.html))
**@encode()**             | supported: 90% the same as the Apple runtime | ([what is this ?](https://nshipster.com/type-encodings/))
**@package**              | never: will produce an error
**@synchronized()**       | not planned | ([what is this ?](https://rykap.com/objective-c/2015/05/09/synchronized/))
**^**blocks               | not planned: [^3] | ([what is this ?](https://medium.com/@amyjoscelyn/blocks-and-closures-in-objective-c-2b763e9e0dc8))
**atomic**                | not planned: **atomic** as default: never
**BOOL**                  | supported: but it is an `int`. If you really need to use `bool` use `_Bool`.
**@import**               | not planned | ([what is this ?](https://stoneofarc.wordpress.com/2013/06/25/introduction-to-objective-c-modules/))
**nullable**              | not planned: will produce an error [^2]
**weak**, **strong**      | never
`__bridge`                | will be a nop #define (also `__bridge_retained`, `__bridge_transfer`)
`__unsafe_unretained`     | could be a nop #define  (`_autoreleasing`)
ARC                       | never: but look for mulle-objc's AAM | ([what is this ?](https://www.yorkhua.com/objective-c-arc/))
**@implementation()**     | never: class extension with added instance variables don't work
for ( i in x)             | supported: what is known as "Fast Enumeration"
**NSArray\<NSString\* \>**| never: generics are not in the cards | ([what is this ?](https://www.thomashanning.com/objective-c-lightweight-generics/)
ObjectiveC++              | never: But the mulle-objc instance memory layout should be `this->__vtab` compatible to allow dual facing objects.
NSArray *foo; foo[ 1]     | not planned: [^1] what is known as "Subscripting" | ([what is this ?](https://nshipster.com/object-subscripting/))
Non-fragile ivars         | never | ([what is this ?](https://www.sealiesoftware.com/blog/archive/2009/01/27/objc_explain_Non-fragile_ivars.html))
property dot syntax       | not planned: [^1] | ([what is this ?](https://stackoverflow.com/questions/7423853/whats-the-difference-between-dot-syntax-and-square-bracket-syntax))
Protocol                  | never: `Protocol` as a class is gone. You have to use `PROTOCOL` instead of `Protocol *`
variadic arguments (:...) | supported: but not compatible to `<stdarg.h>`


-----
### Appendix

#### Footnotes


[^1] : This is basically operator overloading, which is un-C like.

[^2] : Superflous keyword, ObjC is by design nullable. It only makes sense to
adorn non-nullable parameters.

[^3] : GCD is a Apple technology, that really needs kernel support to work well. lambdas are not a part of C11. Generally I find blocks unconvincing. It might be an idea to make `NSInvocation`s  out of block syntax ?


#### Glossary

Wording           | Meaning
------------------|-------------------------------------------------
supported         | should work already
will be supported | must work with the first release
not supported     | might just accidentally work
planned           | may not be in the first release
unknown           | neither "planned" not "not planned"
not planned       | never say never, but this probably won't happen
never             | sometimes you have to say never :)


#### Terminology

For the discussed concepts and terminology check any of the following links.

1. [Wikipedia: Objective-C](https://en.wikipedia.org/wiki/Objective-C#Objective-C_2.0)
2. [Apple: Objective-C Feature Availability Index](https://developer.apple.com/library/prerelease/ios/releasenotes/ObjectiveC/ObjCAvailabilityIndex/index.html)
3. [NSHipster: @compiler directives](http://nshipster.com/at-compiler-directives)


