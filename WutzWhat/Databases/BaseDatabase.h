//
//  BaseDatabase.h
//  WutzWhat
//
//  Created by Andrew Apperley on 2013-06-17.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BaseDatabase : NSObject

@property(nonatomic, readonly)NSString *databaseName;
@property(nonatomic, readonly)NSString *path;

- (id)initWithDatabase:(NSString*)ldatabase;
- (NSString *)databaseName;

//Database exceptions
+ (void)failedToOpen;
+ (void)failedToRunQuery:(const char *)query;

@end