#import <Foundation/Foundation.h>

@import Whatever;             // @import doesn't work


@interface Foo 

// unsupported property attribute
@property( atomic) id  a;
@property( weak) id  b;
@property( strong) id  c;
@property( nullable) id  d;       // nullable can be #defined away without trouble
@property( unsafe_unretained) e;  // same as assign, use assign
@property( class) id  f;          // class has a chance of being supported sometime

// assign is supported 
// we need the next two declarations for @synthesize to complain 
@property( assign) id g;
@property( assign) id h;

@end


@implementation Foo


// can not synthesize to a different name, ivar must be '_'<name>.
@synthesize g = _g1;

// specfiying a property as dynamic with @dynamic does nothing 
@dynamic h;


// subscripting is not supported
- (id) getFirst:(NSArray *) array
{
   return( array[ 0]);
}

// dotsyntax is not supported
- (void) dotsyntax
{
   self.h = @"x";
}

// generics are not supported
- (void) generics:(NSArray<NSString *> *) array
{
}


// blocks are not supported
- (void) blocks:(int (^)(NSString *)) aBlock
{
}


// synchronized is not supported
- (void) synchronized
{
   @synchronized( self)
   {
   }
}


// literal BOOL is not supported
- (NSNumber *) literalBOOL
{
   return( @YES);
}


// literal () is currently broken
- (NSDictionary *) literalAnything
{
   return( @( 32));
}


// Protocol * is not supported, use PROTOCOL
- (void) keepProtocol:(Protocol *) proto
{
   [proto retain];  // PROTOCOL is not an object
}


- (void) printSelectorAsCString:(SEL) sel
{
   printf( "%s\n", sel); // SEL is not a C-String in MulleObjC
}


// variable arguments are NOT va_list in MulleObjC
- (void) variableArguments:(NSString *) format, ...
{
   va_list   args;

   va_start( args, format);
   va_end( args);
}

@end

@interface NoWorky
@package
@end
