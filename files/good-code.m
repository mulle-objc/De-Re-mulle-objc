#import <Foundation/Foundation.h>   

// forward delclarations of a class and a protocol
@protocol SomeProtocol;
@class Foreign;


// declare a protocol with a required (default)
// and an optional method
@protocol MethodProtocol

@required
- (Foreign *) someMethod;

@optional
- (Foreign *) otherMethod;

// properties can be declared in protocols, yet the
// class must redeclare them

@property( assign) NSUInteger  value;  

@end


// extend Foreign class with this method, so 
// we know we can message it with that protocol
@class Foreign< MethodProtocol>;


#pragma clang diagnostic ignored "-Wobjc-root-class"
@interface Foo : NSObject < MethodProtocol>
{
@public        // The usual visibility modifiers except `@package`
@protected
@private
   NSUInteger   _value;    // will be used as property "value" ivar
}

// properties and all supported property attributes
@property( readwrite, assign) NSUInteger  value;      // reimplement Protocol 
@property( nonatomic, retain) Foreign     *foreign;   // creates own ivar
@property( readonly, nonnull) NSString    *backedByIvar; // creates own ivar

@end


@implementation Foo

@synthesize foreign = _foreign;

- (Foreign *) someMethod;
{
   return( _foreign);
}

@end


static inline Foreign  *FooGetForeign( Foo *self)
{
   return( ((struct{ @defs( Foo); } *) self)->_foreign);
}


// use Foo under alias Foobar
@compatibility_alias Foobar Foo;


// protocolclass Description with default implementation of -description
@class Description;
@protocol Description
- (NSString *) description;

// properties can not be declared in protocolclases yet
// @property( assign) NSUInteger  value;  
@end
#pragma clang diagnostic ignored "-Wobjc-root-class"

// protocolclass must implement Protocol of same name
@interface Description< Description>
@end

// implementation will serve the default implementation of description
@implementation Description 

- (NSString *) description
{
   return( @"VfL Bochum 1848");
}
@end


@interface Bar : Foo < Description>
@end


@implementation Bar

// call super on protocolclass (not superclass)
- (NSString *) description
{
   return( [super description]);  // unvoidable warning for now
}


- (BOOL) knowsThisProtocol:(PROTOCOL) proto
{
   return( @protocol( Description) == proto);
}


// instancetype keyword
- (instancetype) init
{
   return( self);
}


// @encode keyword
+ (char *) type
{
   return( @encode( Bar));
}


// keyword autoreleasepool 
- (void) autoreleasepool
{
   @autoreleasepool
   {
   }
}


- (void) trycatchfinally
{
   @try
   {
   }
   @catch( NSException *e)
   {
   }
   @finally
   {
   }
}


// exception handling with nsduring
- (void) nsduring
{
NS_DURING
NS_HANDLER
   [localException raise];
NS_ENDHANDLER
}


- (NSNumber *) literalInteger
{
   return( @1848);
}

- (NSNumber *) literalDouble
{
   return( @18.48);
}


- (NSNumber *) literalCharacter
{
   return( @'A');
}


- (NSArray *) literalArray
{
   return( @[ @1848, @"VfL Bochum" ]);
}


- (NSDictionary *) literalDictionary
{
   return( @{ @"VfL Bochum" : @1848 });
}


- (PROTOCOL) literalProtocol
{
   return( @protocol( Description));
}


- (SEL) literalSelector
{
   return( @selector( whatever:));
}


// fast enumeration
- (void) fastEnumerate:(NSArray *) array
{
   for( id p in array)
   {
   }
}

@end


int main()
{
   Bar   *bar;

   // don't need an enclosing @autoreleasepool in MulleObjC

   bar = [Bar new]; 

   [bar fastEnumerate:[NSArray arrayWithObject:@"foo"]];

   NSLog( @"description: %@", [bar description]);
   NSLog( @"literalInteger: %@", [bar literalInteger]);
   NSLog( @"literalDouble: %@", [bar literalDouble]);
   NSLog( @"literalCharacter: %@", [bar literalCharacter]);
   NSLog( @"literalArray: %@", [bar literalArray]);
   NSLog( @"literalDictionary: %@", [bar literalDictionary]);

// NSStringFromProtocol is a 8.0.0 feature
#if MULLE_FOUNDATION_VERSION  >= ((0 << 20) | (15 << 8) | 0)
   NSLog( @"literalProtocol: %@", NSStringFromProtocol( [bar literalProtocol]));
#endif   
   NSLog( @"literalSelector: %@", NSStringFromSelector( [bar literalSelector]));

   return( 0);
}
