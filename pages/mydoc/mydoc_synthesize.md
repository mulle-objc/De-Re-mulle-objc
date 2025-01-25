---
title: synthesize
keywords: class
last_updated: March 26, 2019
tags: [compiler,runtime]
summary: ""
permalink: mydoc_synthesize.html
permalink: mydoc_synchronized.html
folder: mydoc
---

If `@synthesize` renames the instance variable, you will unfortunately have to
actually rename the instance variable to the name of the property prefixed
with an underscore, otherwise it won't work. Do best is to just delete the
`@synthesize` and fix the errors.


