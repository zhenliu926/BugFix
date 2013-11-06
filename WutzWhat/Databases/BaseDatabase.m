//
//  BaseDatabase.m
//  WutzWhat
//
//  Created by Andrew Apperley on 2013-06-17.
//

#import "BaseDatabase.h"
#define SQLITE @"sqlite"

@implementation BaseDatabase
@synthesize databaseName;
@synthesize path;

- (id)initWithDatabase:(NSString*)ldatabase
{
    self = [super init];
    if(self)
    {
        databaseName = [ldatabase retain];
        [self connectToDatabase];
    }
    return self;
}

- (NSString *)databaseName
{
    return databaseName;
}

- (void)connectToDatabase
{
    BOOL success;
    
    //Get database directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    path = [[documentsDir stringByAppendingPathComponent:databaseName] retain];
    
    success = [fileManager fileExistsAtPath:path];
    
    if(success) return;
    
    //If database has not ben copied over then copy it from the main bundle
    NSError *error;
    NSString *bundle = [[[NSBundle mainBundle] pathForResource:databaseName ofType:nil inDirectory:nil] retain];
    success = [fileManager copyItemAtPath:bundle toPath:path error:&error];
    
    [bundle release];
    bundle = nil;
    
    if(!success) NSLog(@"Failed to create writable database : '%@'", [error localizedDescription]);
}

/*
 * Database exceptions
 */
+ (void)failedToOpen
{
    NSLog(@"Database Failed to Open");
}

+ (void)failedToRunQuery:(const char *)query
{
    NSLog(@"Database Query Failed : \"%@\"", [NSString stringWithUTF8String:query]);
}

- (void)dealloc
{
    [path release];
    path = nil;
    [databaseName release];
    databaseName = nil;
    [self release];
    self = nil;
    [super dealloc];
}

@end