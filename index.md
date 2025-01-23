---
title: "De Re mulle-objc"
keywords: homepage
tags: [intro]
permalink: index.html
summary: What you need to know to use mulle-objc to its full potential.
---

![Logo](images/dere.jpg)

{% include note.html content="This is a draft/work in progress." %}

Welcome to the developer guide for [mulle-objc](//mulle-objc.github.io). This
guide will enable you to get up and running quickly with Objective-C on the
platform of your choice.

mulle-objc is C, so anywhere C runs Objective-C should run too. But that's
not entirely true. mulle-objc is not suitable for tiny CPUs. When you
build the Foundation library as a shared library you end up with 2.5MB
(mulle-objc 0.5MB). So any system with less than 4MB RAM, will likely not
cut it. The CPU needs to be at least 32 bit wide to be able to
use mulle-objc selectors efficiently.

## Install mulle-objc

This guide doesn't have detailed installation instructions for **mulle-objc**.
Read the instructions on
[foundation-developer](https://github.com/MulleFoundation/foundation-developer)
and follow them.

Afterwards you should have **mulle-clang** and **mulle-sde** in your PATH.

``` console
mulle-clang --version
mulle-sde --version
```

and you should all be setup for coding.

## License

mulle-objc is permissively - BSD3 - licensed and free of cost, meaning you can
use it anywhere you like and wish.

## Next

The next step is to [Learn Objective-C](mydoc_links.html). Or if you
already know the language, skip to the [modern workflow](mydoc_modetn.html)

{% include links.html %}
