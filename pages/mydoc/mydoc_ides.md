---
title: IDEs
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
permalink: mydoc_ides.html
folder: mydoc
---

You can probably use more IDEs than the three tools presented here.

## Xcode


## Sublime Text

This is an editor which you can tune for Objective-C development. Debugging
in Sublime Text is not really possible though.
You can easily get a useful Sublime Text project with:

```
mulle-sde extension add sublime-text
```

### Useful extensions

Extension           | Identifier         | Comment
--------------------|--------------------|--------------
Alignment           | wbond.net/sublime_packages/alignment        |
All Autocomplete    | github.com/alienhard/SublimeAllAutoComplete |
AutoFileName        | github.com/BoundInCode/AutoFileName         |
CMake               | github.com/zyxar/Sublime-CMakeLists         |
Diffy               |  |
FindKeyConflicts    |  |
Git                 |  |
GitGutter           |  |
Glue                |  |
Go To Definition    |  |
Origami             |  |
QuickGotoAnything   |  |
ReadonlyProtect     |  |
SideBarEnhancements |  |
SublimeLinter       |  |
SublimeLinter-clang |  |


## Visual Studio Code


[vscode](//code.visualstudio.com/) is a good fit for **mulle-objc**, as it is
a cross-platform editor. So you can use it on Linux, MacOS and Windows.

Though only an editor right out of the box, you can add a lot of plugins to
turn it into an IDE.

```
mulle-sde extension add mulle-objc/vscode-clang
```

This adds a default `.vscode` folder to your project, which will enables
build and debug support.

Here is a list of suggested plugins for development, you can install with
"Quick Open" or via the marketplace:


### Useful extensions

Extension                       | Identifier         | Comment
--------------------------------|--------------------|--------------
C/C++                           | `ms-vscode.cpptools` | [Configure for clang](https://code.visualstudio.com/docs/cpp/config-clang-mac)
CMake                           | `twxs.cmake`       | Useful when editing cmake files
Code Spell Checker              | streetsidesoftware.code-spell-checker | Catches some misspellings in source code comments, which is nice
Git Lens                        | eamodio.gitlens
Git History                     | donjayamanne.githistory    |
Markdown All in One             | yzhang.markdown-all-in-one |
Markdown Preview Github Styling | bierner.markdown-preview-github-styles |

### Debugging

Debugging in the IDE is still lackluster. You may want to try the following
extensions, but be braced for disappointment:


#### CodeLLDB `vadimcn.vscode-lldb`

The best results I had was with this `.vscode/settings.json`

```
{
   // other settings ...
   "lldb.adapterType": "classic",
   // "lldb.executable": "mulle-lldb",
   "lldb.library": "/home/src/srcL/mulle-lldb-90/lib/liblldb.so"
}
```

It is able to set breakpoints and you can see the stacktrace. But its slow and
very crashprone. I still keep on using **mulle-lldb** on the commandline.

`"lldb.adapterType": "bundled"` can not work I believe, since it comes bundled
with its own `lldb-server.so` binary. I didn't come very far with
`"lldb.adapterType": "native"`

#### Native Debug `webfreak.debug`

The disadvantage of this solution is, that it uses the "lldb-mi" debugger
interface. Some google guys decided, that "lldb-mi" should not be part of
`llvm` anymore.

It has been moved to [lldb-mi](https://github.com/lldb-tools/lldb-mi) and is
pretty much unmaintained.

To get anything happening with VSCode you should specify the proper "lldb-mi"
launch path in the configuration:

```
{
   "version": "0.2.0",
   "configurations": [
      {
         "type": "lldb-mi",
         "request": "launch",
         "name": "Launch Program",
         "target": "${workspaceRoot}/kitchen/Debug/<my executable>",
         "cwd": "${workspaceRoot}",
         "lldbmipath": "/home/src/srcL/mulle-lldb-90/bin/lldb-mi",
         "valuesFormatting": "parseText"
      }
   ]
}
```

## Next

Hmm
