---
title: Legacy Workflow
keywords: class
last_updated: October 1, 2019
tags: [tools]
summary: ""
permalink: mydoc_legacy.html
folder: mydoc
---


### Modern Workflow

The modern workflow is static library based, which gives the following
advantages over shared libraries:

* static linking works on platforms that do not support dynamic libraries
* static linking can be optimized to remove unused classes and categories
* static linking produces executables that are easier to install and deploy

In contrast, the legacy workflow is shared library based.

The advantages of that approach are:

* does not require mulle-sde for generating the link order
* does not require cmake
* fewer libraries to link

> Technically you can also do legacy workflow with static libraries. But
> it can be a pain in the ass to link the multitude of static libraries in
> the correct order, with the correct linker flags in a cross-platform manner.


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
optional component **MulleObjCDecimalFoundation**. This is harmless.

You can change the install location with the `--prefix` option. Otherwise
the `usr` directory of your home directory, will be the install destination.


``` console
mulle-sde install --standalone --prefix "${HOME}/usr" "https://github.com/MulleFoundation/Foundation/archive/latest.zip"
```

A shared (dynamic) `libFoundation` library and some other static libraries
should be present in your `~/usr/lib` folder now.

> If you have the repositories already checked out,
> you can prefix the command with a search path, to avoid downloads
> e.g.
>
> ``` sh
> SRCROOT="/Volumes/Source/srcO" ; \
> MULLE_FETCH_SEARCH_PATH="${SRCROOT}/MulleFoundation:\
> ${SRCROOT}/MulleWeb:\
> ${SRCROOT}/mulle-objc:\
> ${SRCROOT}/mulle-core:\
> ${SRCROOT}/mulle-concurrent:\
> ${SRCROOT}/mulle-c" mulle-sde install ...
> ```


### Build and install Foundation-startup

The Foundation-startup must be built and installed separately.


```
mulle-sde install --only-project --prefix "${HOME}/usr" "https://github.com/MulleFoundation/Foundation-startup/archive/latest.zip"
```

This duplicates much of the work already done by the previous Foundation
built, but this can not be avoided easily.

## Usage

### Write Hello World

Lets create the canonical hello world program:

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

### Build Hello World

Building is now platform specific (unless you use **cmake**). You must use
**mulle-clang** to compile the source:

#### Linux:

```
mulle-clang hello-world.m \
            -o hello-world \
            -isystem "${HOME}/usr/include" \
            -L"${HOME}/usr/lib" \
            -Wl,-rpath -Wl,"${HOME}/usr/lib" \
            -lFoundation \
            -Wl,--whole-archive \
            -lFoundation-startup \
            -lmulle-atinit \
            -lmulle-atexit \
            -Wl,--no-whole-archive \
            -lpthread \
            -ldl \
            -lm
```


#### macOS:

On macOS we need to use Xcode platform headers and therefore need the SDK
path, which can vary for each host. It is assumed you used the **brew**
install method, otherwise you need to correct the `-isystem`, `-L`, `-rpath`
values in the following commands:

```
XCODE_SDK_DIR="`xcrun --show-sdk-path`"
mulle-clang  hello-world.m \
            -o hello-world \\
            -isystem "/usr/local/include" \
            -isystem "${XCODE_SDK_DIR}/include" \
            -L"/usr/local/lib" \
            -Wl,-rpath -Wl,"/usr/local/lib" \
            -lFoundation \
            -Wl,-all_load \
            -lFoundation-startup \
            -lmulle_atinit \
            -lmulle_atexit
            -Wl,-noall_load
```

{% include note.html content="You can also use Xcode to build mulle-objc
code. See [Xcode integration](//github.com/mulle-objc/mulle-objc-developer/wiki/Xcode-integration) for setup instructions." %}


## Run Hello World

And run your first mulle-objc executable.

```
./hello-world
```

## Next

That is about the extent the legacy workflow is covered in this guide.
You likely might want to read [porting Xcode projects](mydoc_xcodeproj.html)
next.
