---
title: Coverage information
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
permalink: mydoc_coverage.html
folder: mydoc
---

## Coverage

You can create Objective-C coverage information for any mulle-objc program.

Coverage files will be are generated when you run the program with
with the environment variables `MULLE_OBJC_PEDANTIC_EXIT` and
`MULLE_OBJC_COVERAGE` set to YES:

```
MULLE_OBJC_PEDANTIC_EXIT=YES MULLE_OBJC_COVERAGE=YES myexe
```

This will produce two coverage files `class-coverage.csv` and
`method-coverage.csv`.

{% include note.html content="Your executable needs to properly terminate, to generate
coverage information. If that isn't possible, call
`mulle_objc_csvdump_methodcoverage()` and `mulle_objc_csvdump_classcoverage()`
yourself, when you know the runtime system is quiescent." %}


## Extending coverage files

A second "coverage" run will append to previously existing coverage files.
But you can also concatenate coverage files from various source with `cat`.

```
cat coverage*.txt | sort -u > class-coverage.csv
```



## Next

[Tools](mydoc_tools.html).
