//
//  FavrouritesCache.m
//  WutzWhat
//
//  Created by iPhone Development on 4/2/13.
//
//

#import "FavouritesCache.h"
#import "Database.h"
#import "CacheDatabase.h"
#import "AppDelegate.h"

@implementation FavouritesCache

#define AD (AppDelegate *)[UIApplication sharedApplication].delegate

+(NSDictionary *)getProductDetailsByProductID:(NSString *)productID andIsPerk:(BOOL)lisPerk
{
    
    Database *database = nil;
    database = [Database new];
    
    NSDictionary *dic = nil;
    
    if(lisPerk)
        dic = [cacheDatabase getAllPerkCachedDataForID:[productID intValue]];
    else
        dic = [cacheDatabase getAllCachedDataForID:productID];
    
    return !dic ? nil : dic;
    
    //    NSString *jSONResponse = [FileIOManager readTextFileAtPath:[NSString stringWithFormat:@"%@.txt",productID]];
    //
    //    if (jSONResponse != nil)
    //    {
    //        NSDictionary *responseDictionary = [jSONResponse JSONValue];
    //        return responseDictionary;
    //    }
    //    else
    //    {
    //        return nil;
    //    }
}


+(void)saveProductDetails:(NSDictionary *)serverResponse andSection:(int)lsection andCategory:(int)lcategory
{
    
    if(((NSArray *)[serverResponse objectForKey:@"data"]).count < 1 || [[[serverResponse objectForKey:@"data"][0] objectForKey:@"postID"] isEqualToString:@"(null)"])
        return;
    
    if([[serverResponse objectForKey:@"data"][0] objectForKey:@"perk_id"]) {
        [FavouritesCache savePerkDetails:serverResponse];
        return;
    }
    
    Database *database = nil;
    database = [Database new];
    
    NSMutableArray *data = [NSMutableArray array];
    
    for (uint i = 0; i < [[serverResponse objectForKey:@"data"] count]; i++) {
        NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:[serverResponse objectForKey:@"data"][i]];
        [object setObject:[NSString stringWithFormat:@"%d",lsection] forKey:@"sectionType"];
        //        [object setObject:[[serverResponse objectForKey:@"params"] objectForKey:@"baseCity"] forKey:@"base_city"];
        [object setObject:[NSString stringWithFormat:@"%d",lcategory] forKey:@"category"];
        [object setObject:[NSString stringWithFormat:@"%@",[[serverResponse objectForKey:@"params"] objectForKey:@"postid"]] forKey:@"postId"];
        [object setObject:[((AppDelegate *)AD).facebookData objectForKey:@"city"] forKey:@"selectedCity"];
        if(![object objectForKey:@"postId"] || [[object objectForKey:@"postId"] isEqualToString:@""] || [[object objectForKey:@"postId"] isEqualToString:@"(null)"])
            [object setObject:[NSString stringWithFormat:@"%@",[[serverResponse objectForKey:@"data"][i] objectForKey:@"postID"]] forKey:@"postId"];
        
        [data addObject:object];
    }
    [cacheDatabase saveCachedData:data];
}

+(void)savePerkDetails:(NSDictionary *)serverResponse
{
    if(((NSArray *)[serverResponse objectForKey:@"data"]).count < 1 || [[serverResponse objectForKey:@"data"][0] objectForKey:@"perk_id"] == nil || [[[serverResponse objectForKey:@"data"][0] objectForKey:@"perk_id"] intValue] < 1)
        return;
    
    Database *database = nil;
    database = [Database new];
    
    NSMutableArray *data = [NSMutableArray array];
    
    for (uint i = 0; i < [[serverResponse objectForKey:@"data"] count]; i++) {
        NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:[serverResponse objectForKey:@"data"][i]];
        
        [data addObject:object];
    }
    [cacheDatabase saveCachedPerkData:data];
}


+(void)deleteProductDetailsByID:(id)ID
{
    Database *database = nil;
    database = [Database new];
    
    if([ID isKindOfClass:[NSString class]])
        [cacheDatabase deleteWherePostID:(NSString *)ID];
    else
        [cacheDatabase deleteWherePerkID:[(NSNumber *)ID intValue]];
    
    
    //    [FileIOManager deleteFileByFileName:[NSString stringWithFormat:@"%@.txt",productID]];
}


+(NSDictionary *)getListOfProductsByCategoryName:(NSString *)categoryName isPerks:(BOOL)isPerks
{
    categoryName = isPerks ? [NSString stringWithFormat:@"PERKS_%@.txt" ,categoryName] : [NSString stringWithFormat:@"%@.txt" ,categoryName];
    
    NSString *jSONResponse = [FileIOManager readTextFileAtPath:categoryName];
    
    if (jSONResponse != nil)
    {
        NSDictionary *responseDictionary = [jSONResponse JSONValue];
        return responseDictionary;
    }
    else
    {
        return nil;
    }
}


+(NSDictionary *)getListOfProductsByCategoryID:(NSInteger)categoryID isPerks:(BOOL)isPerks
{
    Database *database = nil;
    database = [Database new];
    
    if(isPerks)
        return [cacheDatabase getPerkListCachedDataForCategory:categoryID andCity:[((AppDelegate *)AD).facebookData objectForKey:@"city"]];
    else
        return [cacheDatabase getListCachedDataForCategory:categoryID andCity:[((AppDelegate *)AD).facebookData objectForKey:@"city"]];
    
    
    //    return [FavouritesCache getListOfProductsByCategoryName:[FavouritesCache getCategoryNameByID:categoryID] isPerks:isPerks];
}



+(void)saveListOfProductsResponse:(NSDictionary *)serverResponse categoryID:(NSInteger)categoryID isPerks:(BOOL)isPerks
{
    [FavouritesCache saveListOfProducts:serverResponse categoryID:categoryID isPerks:isPerks];
}



+(void)saveListOfProducts:(NSDictionary *)serverResponse categoryID:(NSInteger)categoryID isPerks:(BOOL)isPerks
{
    if([[serverResponse objectForKey:@"data"] isKindOfClass:[NSNull class]] || [[serverResponse objectForKey:@"data"] isEqual:[NSNull null]])
        return;
    
    if(((NSArray *)[serverResponse objectForKey:@"data"]).count < 1)
        return;
    
    if(isPerks) {
        [FavouritesCache saveListOfPerks:serverResponse categoryID:categoryID];
        return;
    }
    
    
    Database *database = nil;
    database = [Database new];
    
    NSMutableArray *data = [NSMutableArray array];
    
    for (uint i = 0; i < [[serverResponse objectForKey:@"data"] count]; i++) {
        NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:[serverResponse objectForKey:@"data"][i]];
        [object setObject:[[serverResponse objectForKey:@"params"] objectForKey:@"section_type"] forKey:@"sectionType"];
        [object setObject:[[NSNumber numberWithInteger:categoryID] stringValue] forKey:@"category"];
        [data addObject:object];
    }
    
    [cacheDatabase updateListInfo:data];
    
    //    NSString *responseString = [self getStringOfDictionary:serverResponse];
    //
    //    categoryName = isPerks ? [NSString stringWithFormat:@"PERKS_%@.txt" ,categoryName] : [NSString stringWithFormat:@"%@.txt" ,categoryName];
    //
    //    [FileIOManager writeTextToFileAtPath:categoryName stringToWrite:responseString];
}

+(void)saveListOfPerks:(NSDictionary *)serverResponse categoryID:(NSInteger)categoryID
{
    Database *database = nil;
    database = [Database new];
    
    NSMutableArray *data = [NSMutableArray array];
    
    for (uint i = 0; i < [[serverResponse objectForKey:@"data"] count]; i++) {
        NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:[serverResponse objectForKey:@"data"][i]];
        //        [object setObject:[[serverResponse objectForKey:@"params"] objectForKey:@"section_type"] forKey:@"sectionType"];
        [object setObject:[[NSNumber numberWithInteger:categoryID] stringValue] forKey:@"category"];
        [data addObject:object];
    }
    
    [cacheDatabase updatePerkListInfo:data];
}

+(NSString *)getStringOfDictionary:(NSDictionary *)dict
{
    if (dict == nil || [dict count] < 1)
    {
        return @"No Params";
    }
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    if (! jsonData)
    {
        return error.description;
    }
    else
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}


+(NSString *)getCategoryNameByID:(NSInteger)categoryID
{
    NSString *categoryName;
    
    switch (categoryID)
    {
        case 1:
            categoryName = CATEGORY_FOOD;
            break;
            
        case 2:
            categoryName = CATEGORY_SHOPPING;
            break;
            
        case 3:
            categoryName = CATEGORY_EVENT;
            break;
            
        case 4:
            categoryName = CATEGORY_NIGHT_LIFE;
            break;
            
        case 5:
            categoryName = CATEGORY_SERVICES;
            break;
            
        case 6:
            categoryName = CATEGORY_CONCEIRGE_CHAUFFEUR;
            break;
            
        case 7:
            categoryName = CATEGORY_CONCEIRGE_HOTEL;
            break;
            
        default:
            categoryName = CATEGORY_FOOD;
            break;
    }
    return categoryName;
}

@end

