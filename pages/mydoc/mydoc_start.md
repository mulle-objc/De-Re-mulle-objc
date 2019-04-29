---
title: Let's Get Started
keywords: class
last_updated: March 26, 2019
tags: [runtime]
permalink: mydoc_start.html
folder: mydoc
---

Initally the "legacy workflow" for developing with MulleObjC, will be easiest,
since it's the most familiar. Later you will probably want to use the
[modern workflow](mydoc_modern.html).


# Install MulleObjC

This guide doesn't have detailed installation instructions. Read the
instructions on
[foundation-developer](https://github.com/MulleFoundation/foundation-developer)
and follow them.

Afterwards you should have **mulle-clang** and **mulle-sde** in your PATH.

```
mulle-clang --version
mulle-sde --version
```


## Legacy workflow

The legacy workflow installs the **mulle-objc** Foundation as a *shared* library. 

{% include note.html content="The \"modern workflow\" uses static libraries." %}


### Install a shared MulleFoundation library

**mulle-sde** will now download all required components of the Foundation
library and build them. There will be an error, because it can not find an
optional component **MulleObjCDecimalFoundation**. This is harmless.

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



## Write Hello World

Lets create the canonical hello world program with **mulle-objc**.

```
cat <<EOF > hello-world.m
#import <Foundation/Foundation.h>

int   main( int argc, char *argv[])
{
   NSLog( @"Hello World");
   return( 0);
}
EOF
```

## Build Hello World

Building is now platform specific (unless you use **cmake**):

### Linux:

``` console
mulle-clang hello-world.m \
            -o hello-world \
            -isystem "${HOME}/usr/include" \
            -L"${HOME}/usr/lib" \
            -Wl,-rpath -Wl,"${HOME}/usr/lib" \
            -lFoundation
```


### MacOS:

On MacOS we use Xcode platform headers and therefore need the SDK path first.
It is assumed you used the **brew** install method, otherwise you need to
correct the `-isystem`, `-L`, `-rpath` values.

``` console
XCODE_SDK_DIR="`xcrun --show-sdk-path`"
mulle-clang  hello-world.m \
            -o hello-world \\
            -isystem "/usr/local/include" \
            -isystem "${XCODE_SDK_DIR}/include" \
            -L"/usr/local/lib" \
            -Wl,-rpath -Wl,"/usr/local/lib" \
            -lFoundation
```

{% include note.html content="You can also use Xcode to build MulleObjC
code. See [Xcode integration](//github.com/mulle-objc/mulle-objc-developer/wiki/Xcode-integration) for setup instructions." %}


## Run Hello World

And run your first MulleObjC executable.

``` console
./hello-world
```


## Next

With this success in your bag, there are two routes to choose from. If you know
Objective-C continue with [MulleObjC basics](mydoc_basics.html).

Otherwise use one of the tutorials in [Learn ObjC](mydoc_links.html) to get
up to speed.

