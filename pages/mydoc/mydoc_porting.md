---
title: sde
keywords: class
last_updated: March 26, 2019
tags: [runtime,foundation,porting]
summary: ""
permalink: mydoc_porting.html
folder: mydoc
---

## Tips

### Use envelope headers

Rewrite code that imports specific headers to use the envelope header.

Example: Rewrite


```
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
```

to

```
#import <Foundation/Foundation.h>
```

The exception being `<Foundation/NSDebug.h>` or any other header not exposed by `<Foundation/Foundation.h>`.

