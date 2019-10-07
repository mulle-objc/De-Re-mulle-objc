---
title: ARC
keywords: class
last_updated: March 26, 2019
tags: [runtime,compiler]
summary: "This is a list of porting tips for ARC code"
permalink: mydoc_arc.html
folder: mydoc
---

ARC as a technology is not available in **mulle-objc** and never will be.

Ideally though, code should remain functional in ARC but work flawlessly in
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

### Add `[super dealloc]` to `-dealloc`

You could use this idea to modify your `-dealloc` code

```
#if __has_feature(objc_arc)
# define SUPER_DEALLOC()
#else
# define SUPER_DEALLOC()  [super dealloc]
#endif
```

```
- (void) dealloc
{
   SUPER_DEALLOC();
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

Since `-finalize` isn't used in ARC code, it can be a good place to do it.
Othewise you could use `#if __has_feature( objc_arc)` in `-dealloc`.

```
#ifdef __MULLE_OBJC__
- (void) finalize
{
   [_foo autorelease];
   _foo = nil;

   [super finalize];
}
#endif
```

Remember to use `-autorelease` instead of `-release`. Also `nil` out the instance variable in `-finalize`.

{% include note.html contents="You would not nil out in `-dealloc` and you would use `-release` in `-dealloc`." %}



