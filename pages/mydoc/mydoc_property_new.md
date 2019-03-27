---
title: New Property attributes
keywords: property class
last_updated: March 26, 2019
tags: [runtime,8.0.0]
summary:
permalink: mydoc_property_new.html
folder: mydoc
---

## dynamic

Indicate that a property is not backed by an ivar. This is useful for
forwarding properties.

```
@property( copy, dynamic) NSString   *bar;
```

E.g.

```
- (void) setBar:(NSString *) s
{
   [_other setBar:s];
}
```


## serializable

Indicate that a property should be serialized by `NSCoder`, MulleEOF or some
other persistence method. Then `-initWithCoder:`, `-encodeWithCoder:` do not
need to be written but can be inherited from the `NSCoder` protocol running on
properties only. The optional value can be used to indicate the destination
class.


```
@property( assign, serializable=Bar) NSArray   *foo;
```

