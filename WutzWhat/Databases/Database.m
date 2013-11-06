//
//  Database.m
//  wutzwhat
//
//  Created by Andrew Apperley on 2013-06-17.
//

#import "Database.h"
#import "CacheDatabase.h"
@implementation Database
@synthesize _cacheDatabase;


static Database *_database;
+ (Database *)database
{
    return _database;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _database = self;
        [self createDatabases];
    }
    return self;
}

- (void)createDatabases
{
    if(_cacheDatabase)
    {
        [_cacheDatabase release];
        _cacheDatabase = nil;
    }
    _cacheDatabase = [CacheDatabase new];
}

- (void)dealloc
{
    [_cacheDatabase release];
    _cacheDatabase = nil;
    [super dealloc];
}

@end
