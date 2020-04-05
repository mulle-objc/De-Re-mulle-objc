---
title: Sources
keywords: workflow modern
last_updated: March 26, 2019
tags: [tools modern includes]
summary: ""
permalink: mydoc_pnp_source.html
folder: mydoc
---

Ideally source files should be motile. One would like to easily move them
between various projects without having to edit anything. The modern workflow
achieves this with generic header names.

As we saw in the
previous chapter, headers and libraries are transparently added and removed
to a project with mulle-sde. All the **external** dependencies are isolated
in header files with generic names. Headers belonging to the project do not
appear in these files.

Header               |
---------------------|-------------------
`include.h`          | Used by C header files
`include-private.h`  | Used by C source files
`import.h`           | Used by Objective-C interface files
`import-private.h`   | Used by Objective-C implementation files



So we can write our source code in a uniform way.

## Objective-C


`Foo.h`:

```
#import "import.h"


@interface Foo : NSObject
@end
```

and the implementation like so:

`Foo.m`:

```
#import "Foo.h"

#import "import-private.h"

@implementation Foo
@end
```


## C

For C its quite the same, but different header files are used.

`foo.h`:

```
#include "include.h"


void  foo( void);
```

`foo.c`:

```
#include "foo.h"

#include "include-private.h"

void  foo( void)
{
   calling( "whatever");
}
```


## Conclusion

As platform dependent headers and `#ifdef` definitions are isolated in
the generic headers, this is basically all there is to it. Read [The beauty of generic header-names](https://www.mulle-kybernetik.com/weblog/2019/beauty_of_generic_headers.html)
for more details on this topic.


> Memo: What doesn't work yet, is full independence from other headers in the
> same library.


## Next

The modern workflow uses only static libraries. Static libraries can be
unpacked and repackaged. This can be used to good advantage, if we use
[coverage](mydoc_coverage.html) information to remove all Objective-C classes
and categories, that aren't actually used.

