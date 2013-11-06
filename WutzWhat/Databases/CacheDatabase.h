//
//  CacheDatabase.h
//  WutzWhat
//
//  Created by Andrew Apperley on 2013-06-17.
//
//

#import "BaseDatabase.h"

@interface CacheDatabase : BaseDatabase

- (void)saveCachedData:(NSArray *)ldata;
- (NSDictionary *)getAllCachedDataForID:(NSString *)lpostID;
- (void)deleteWherePostID:(NSString *)lid;
- (NSDictionary *)getListCachedDataForCategory:(int)lcategory andCity:(NSString *)lcity;
- (NSDictionary *)getAllCachedDataForCategory:(int)lcategory andCity:(NSString *)lcity;
- (void)updateListInfo:(NSArray *)ldata;
- (void)updatePerkListInfo:(NSArray *)ldata;
- (void)saveCachedPerkData:(NSArray *)ldata;
- (void)deleteWherePerkID:(int)lid;
- (NSDictionary *)getPerkListCachedDataForCategory:(int)lcategory andCity:(NSString *)lcity;
- (NSDictionary *)getAllPerkCachedDataForID:(int)lperkID;
@end
