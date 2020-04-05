---
title: Let's Get Started
keywords: class
last_updated: March 26, 2019
tags: [runtime]
permalink: mydoc_start.html
folder: mydoc
---


## Legacy workflow

The legacy workflow installs the **mulle-objc** Foundation as a *shared* library.
You use the custom compiler **mulle-clang** to compile Objective-C files.
These are then liked with the `Foundation` shared library and some startup
libraries.

You can use **make** or most IDEs with this setup.

{% include note.html content="The \"modern workflow\" uses static libraries." %}


### Install a shared MulleFoundation library

Use **mulle-sde** to download all required components of the Foundation
library and to build them. There will be an error, because it can not find an
optional component **mulle-objcDecimalFoundation**. This is harmless.

You can change the install location with the `--prefix` option. Otherwise
the `usr` directory of your home directory, will be the install destination.


``` console
mulle-sde install --standalone --prefix "${HOME}/usr" "https://github.com/MulleFoundation/Foundation/archive/latest.zip"
```

A shared (dynamic) `libFoundation` library and some other static libraries
should be present in your `~/usr/lib` folder now.

{% include note.html content="On MacOS there is a brew formula, which will
install into `/usr/local` a `libFoundation.dylib` and all required headers:

```
brew install mulle-kybernetik/software/Foundation
```
" %}





## Next

With this success in your bag, there are two routes to choose from. If you know
Objective-C continue with [mulle-objc basics](mydoc_basics.html).

Otherwise use one of the tutorials in [Learn ObjC](mydoc_links.html) to get
up to speed.

