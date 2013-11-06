//
//  Database.h
//  wutzwhat
//
//  Created by Andrew Apperley on 2013-06-17.
//

@class CacheDatabase;

#define cacheDatabase [[Database database] _cacheDatabase]

@interface Database : NSObject

@property(nonatomic, retain)CacheDatabase *_cacheDatabase;


+ (Database *)database;

@end