---
title: Porting ARC code
keywords: class
last_updated: March 26, 2019
tags: [runtime,compiler]
summary: "This is a list of porting tips for ARC code"
permalink: mydoc_arc.html
folder: mydoc
---

Ideally code should remain functional in ARC but work flawlessly in
MulleObjC.


## Use convenience constructors

Outside of `-init` and `-dealloc`, replace `[[obj alloc] init]` calls with
convenience constructors like `+[NSArray array]`, if available.

### Create your own convenience constructors

If a convenience constructor is not available, it might be useful to
create your own with a category. Consider this if there is a lot of calls
for the same class/method combination.

This is the code to replace a `[[Foo alloc] initWithRandomNumber]` with
`[Foo fooWithRandomNumber]`:


```
@interface Foo( Convenience)

+ (instancetype) fooWithRandomNumber;

@end


@implementation Foo( Convenience)

+ (instancetype) fooWithRandomNumber
{
   id   obj;

   obj = [[Foo alloc] initWithRandomNumber:rand()];
#if ! __has_feature(objc_arc)
   obj = [obj autorelease];
#endif
   return( obj);
}
@end
```


### Wrap alloc/init calls

You could also use this idea to wrap your `[[obj alloc] init]` code

```
#if __has_feature(objc_arc)
# define AUTORELEASE( x)  x
#else
# define AUTORELEASE( x)  NSAutoreleaseObject( x)
#endif
```

So you can simplify the above written `+fooWithRandomNumber` like this:

```
+ (instancetype) fooWithRandomNumber
{
   return( AUTORELEASE( [[Foo alloc] initWithRandomNumber:rand()] ));
}
```


## Fix convenience constructors in -init

```
- (id) init
{
   self = [super init];
   if( self)
      _foo = [NSArray array];
   return( self);
}
```

Here an instance variable is initialized with an autoreleased `NSArray`, which
will soon be unavailable.

Write `_foo = [[NSArray alloc] init];` to make your code ARC and MulleObjC
compatible.


## Release instance variables manually

There is often no `-dealloc` method in ARC code. That is fine if the
class has only properties. Then MulleObjC will clean up automatically.
If your class has non-property instance variables, they must be released in
`-dealloc` or `-finalize`.

Since `-finalize` isn't used in ARC code, this can be a good place to do it,
as you don't have to `#if __has_feature(objc_arc)` in `-dealloc`.

```
- (void) finalize
{
   [_foo autorelease];
   _foo = nil;

   [super finalize];
}

```

Remember to use `-autorelease` instead of `-release` as you would
use in `-dealloc`. Also `nil` out the instance variable in `-finalize`.
You don't have to do this in `-dealloc`.


