//
//  CacheDatabase.m
//  WutzWhat
//
//  Created by Andrew Apperley on 2013-06-17.
//
//

#import "CacheDatabase.h"

@implementation CacheDatabase

#define INSERT_DATA [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"title"]], (NSString *)[ldata[i] objectForKey:@"postTime"], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"description"]], (NSString *)[ldata[i] objectForKey:@"postId"], [(NSNumber *)[ldata[i] objectForKey:@"like_count"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"perk_count"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"isfavourite"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"islike"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"hotpick"] intValue],(NSString *)[ldata[i] objectForKey:@"latitude"],(NSString *)[ldata[i] objectForKey:@"longitude"], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"info"]], [(NSNumber *)[ldata[i] objectForKey:@"distance"] intValue], (NSString *)[ldata[i] objectForKey:@"price"], (NSString *)[ldata[i] objectForKey:@"thumbnail_url"], (NSString *)[ldata[i] objectForKey:@"sectionType"], (NSString *)[ldata[i] objectForKey:@"selectedCity"], (NSString *)[ldata[i] objectForKey:@"eventDate"], [(NSNumber *)[ldata[i] objectForKey:@"check_in_count"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"location_count"] intValue], (NSString *)[ldata[i] objectForKey:@"event_start_date"], (NSString *)[ldata[i] objectForKey:@"event_end_date"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"monday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"monday_close_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"tuesday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"tuesday_close_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"wednesday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"wednesday_close_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"thursday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"thursday_close_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"friday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"friday_close_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"saturday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"saturday_close_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"sunday_open_time"], (NSString *)[[ldata[i] objectForKey:@"wutzwat_time"] objectForKey:@"sunday_close_time"], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"curation"]], (NSString *)[ldata[i] objectForKey:@"state"], [(NSNumber *)[ldata[i] objectForKey:@"review_count"] intValue], (NSString *)[ldata[i] objectForKey:@"website"], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"address"]], (NSString *)[ldata[i] objectForKey:@"postalCode"], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"city"]], (NSString *)[ldata[i] objectForKey:@"country"], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"tags"]], [(NSNumber *)[ldata[i] objectForKey:@"bannerImageID"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"taxi_name"]], (NSString *)[ldata[i] objectForKey:@"taxi_phone"], (NSString *)[ldata[i] objectForKey:@"phone"], (NSString *)[ldata[i] objectForKey:@"wutzwat_time_note"], (NSString *)[ldata[i] objectForKey:@"category"]

#define INSERT_LIST_DATA [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"title"]], [(NSNumber *)[ldata[i] objectForKey:@"distance"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"favourited"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"hotpick"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"info"]], [(NSNumber *)[ldata[i] objectForKey:@"likeCount"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"liked"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"perk_count"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"postTime"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"price"]], (NSString *)[ldata[i] objectForKey:@"postId"]]

#define INSERT_PERK_LIST_DATA [(NSNumber *)[ldata[i] objectForKey:@"cat_id"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"discount_price"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"isfav"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"isLike"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"likeCount"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"min_credits"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"orig_price"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"perk_id"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"short_desc"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"title"]], [(NSNumber *)[ldata[i] objectForKey:@"perk_id"] intValue]

#define INSERT_PERK_DATA [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"address"]], [(NSNumber *)[ldata[i] objectForKey:@"selectedCity"] intValue],  [(NSNumber *)[ldata[i] objectForKey:@"c_required"] intValue],  [(NSNumber *)[ldata[i] objectForKey:@"cat_id"] intValue],  [(NSNumber *)[ldata[i] objectForKey:@"discount_price"] intValue],  [(NSNumber *)[ldata[i] objectForKey:@"distance"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"event_end_date"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"event_start_date"]], [(NSNumber *)[ldata[i] objectForKey:@"fav_count"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"isLike"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"isShipping"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"isfav"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"latitude"] floatValue], [(NSNumber *)[ldata[i] objectForKey:@"like_count"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"link"]], [(NSNumber *)[ldata[i] objectForKey:@"location_count"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"long_desc"]], [(NSNumber *)[ldata[i] objectForKey:@"longitude"] floatValue], [(NSNumber *)[ldata[i] objectForKey:@"min_credits"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"orig_price"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"perk_id"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"phone"]], [(NSNumber *)[ldata[i] objectForKey:@"qty"] intValue], [(NSNumber *)[ldata[i] objectForKey:@"review_count"] intValue], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"short_desc"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"taxi_name"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"taxi_phone"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"terms_conditions"]], [self encodeNonNullString:(NSString *)[ldata[i] objectForKey:@"title"]], [(NSNumber *)[ldata[i] objectForKey:@"user_credits"] intValue]

- (id)init
{
    return [self initWithDatabase:@"wutzwhatOfflineCache"];
}

- (NSString *)encodeNonNullString:(NSString *)lstring
{
    if([lstring isKindOfClass:[NSNull class]])
        return lstring;
    else
        return [lstring stringByReplacingOccurrencesOfString:@"'" withString:@"%@%"];
}

- (NSString *)decodeNonNullString:(NSString *)lstring
{
    if([lstring isKindOfClass:[NSNull class]])
        return lstring;
    else
        return [lstring stringByReplacingOccurrencesOfString:@"%@%" withString:@"'"];
}


#pragma mark PerkSection

- (void)saveCachedPerkData:(NSArray *)ldata
{
    for (uint i = 0; i < ldata.count; i++) {
        if([[ldata[i] objectForKey:@"perk_id"] intValue] < 1)
            break;
        const char *query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO Cache_Perks(address, base_city, c_required, cat_id, discount_price, distance, event_end_date, event_start_date, fav_count, isLike, isShipping, isfav, latitude, like_count, link, location_count, long_desc, longitude, min_credits, orig_price, perk_id, phone, qty, review_count, short_desc, taxi_name, taxi_phone, terms_conditions, title, user_credits) VALUES('%@', '%d', '%d', '%d', '%d', '%d', '%@', '%@', '%d', '%d', '%d', '%d', '%f', '%d', '%@', '%d', '%@', '%f', '%d', '%d', '%d', '%@', '%d', '%d', '%@', '%@', '%@', '%@', '%@', '%d')",INSERT_PERK_DATA] UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
        
        [self saveCachedPerkImages:[ldata[i] objectForKey:@"images"] andPerkID:[[ldata[i] objectForKey:@"perk_id"] intValue]];
        
    }
}

- (void)saveCachedPerkImages:(NSArray *)limages andPerkID:(int)lperkID
{
    for (int i = 0; i < limages.count; i++) {
        NSString *thumb = [[limages objectAtIndex:i] objectForKey:@"url_thumbnail"];
        if(i == 1)
            thumb = i == 1 && [[[limages objectAtIndex:i] objectForKey:@"url_thumbnail"] isEqualToString:@"<null>"] ? [self getPerkThumbnailURLForID:lperkID] : [[limages objectAtIndex:i] objectForKey:@"url_thumbnail"];
        
        
        const char *query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO PerkImageURLs(_id, id, PerkID, mediumURL, thumbnailURL, smallURL, largeURL, videoURL) VALUES('%@','%d', '%d', '%@', '%@', '%@', '%@', '%@')", [NSString stringWithFormat:@"%d_%d",lperkID,i], i, lperkID, [[limages objectAtIndex:i] objectForKey:@"url_medium"], thumb, [[limages objectAtIndex:i] objectForKey:@"url_small"], [[limages objectAtIndex:i] objectForKey:@"url_large"], [[limages objectAtIndex:i] objectForKey:@"url_video"]] UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
                
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
    }
}

- (NSArray *)getPerkImageURLsForID:(int)lperkID andCity:(NSString *)lcity
{
    NSMutableArray *data = [NSMutableArray array];
    
    const char *query = [[NSString stringWithFormat:@"SELECT * FROM PerkImageURLs WHERE PerkID = '%d' ORDER BY id ASC", lperkID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 1)], @"Id", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]], @"url_medium", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]], @"url_thumbnail", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]], @"url_small", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]], @"url_large", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]], @"url_video", nil];
                    
                    [data addObject:object];
                }
                
                
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
    }
    return data;
}


- (NSDictionary *)getAllPerkCachedDataForID:(int)lperkID
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSMutableArray array] forKey:@"data"];
    
    const char *query = [[NSString stringWithFormat:@"SELECT * FROM Cache_Perks WHERE perk_id = '%d' ", lperkID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]], @"address", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]], @"base_city",[NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 2)], @"c_required", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 3)], @"cat_id", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 4)], @"discount_price", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 5)], @"distance", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]], @"event_end_date", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]], @"event_start_date", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 8)], @"fav_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 9)], @"isLike", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 10)], @"isShipping", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 11)], @"isfav", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]], @"latitude", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 13)], @"like_count", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 14)]], @"link", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 15)], @"location_count", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 16)]], @"long_desc", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 17)]], @"longitude", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 18)], @"min_credits", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 19)], @"orig_price", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 20)], @"perk_id", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 21)]], @"phone", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 22)], @"qty", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 23)], @"review_count", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 24)]], @"short_desc", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 25)]], @"taxi_name", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 26)]], @"taxi_phone", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 27)]], @"terms_conditions", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 28)]], @"title", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 29)], @"user_credits", [self getPerkImageURLsForID:lperkID andCity:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]]], @"images", nil];
                
                [(NSMutableArray *)[data objectForKey:@"data"] addObject:object];
                

                [data setObject:@"true" forKey:@"result"];
                
                
            }else {
                [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"section_type", @"null", @"category", nil] forKey:@"params"];
                [data setObject:@"false" forKey:@"result"];
                [data setObject:@"true" forKey:@"error"];
            }
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
    return data;
}

- (NSString *)getPerkThumbnailURLForID:(int)lperkID
{
    NSString *data = [NSString string];
    
    const char *query = [[NSString stringWithFormat:@"SELECT thumbnailURL FROM PerkImageURLs WHERE PerkID = '%d' AND id = 1", lperkID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
                data = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
    return data;
}


- (void)updateCachedPerkThumbnailImage:(NSString *)lthumb andPostID:(int)lperkID
{
    if(!lthumb || [lthumb isEqualToString:@"(null)"] || [lthumb isEqualToString:@"<null>"])
        return;
    
    const char *query = [[NSString stringWithFormat:@"UPDATE PerkImageURLs SET thumbnailURL = '%@' WHERE PerkID = '%d' AND id = 1",lthumb, lperkID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_RANGE)
            {
                [BaseDatabase failedToRunQuery:query];
            }
            
            sqlite3_finalize(statement);
            
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
}

- (NSDictionary *)getPerkListCachedDataForCategory:(int)lcategory andCity:(NSString *)lcity
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSMutableArray array] forKey:@"data"];
    
    const char *query = [[NSString stringWithFormat:@"SELECT cat_id, discount_price, distance, isfav, isLike, latitude, like_count, longitude, min_credits, orig_price, perk_id, short_desc, title FROM Cache_Perks WHERE cat_id = '%d'", lcategory] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    BOOL ROW = FALSE;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            ROW = FALSE;
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ROW = TRUE;
                
                //create dictionary of information
                NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 0)], @"cat_id", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 1)], @"discount_price", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 2)], @"distance", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 3)], @"isfav", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 4)], @"isLike", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]], @"latitude", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 6)], @"likeCount", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]], @"longitude", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 8)], @"min_credits", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 9)], @"orig_price", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 10)], @"perk_id", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]], @"short_desc", [self getPerkThumbnailURLForID:[[NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 12)] intValue]], @"thumb_url", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]], @"title", nil];
                
                [(NSMutableArray *)[data objectForKey:@"data"] addObject:object];
                [data setObject:@"true" forKey:@"result"];
                
                
            }
            
            if(!ROW){
                [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"section_type", @"null", @"category", nil] forKey:@"params"];
                [data setObject:@"false" forKey:@"result"];
                [data setObject:@"true" forKey:@"error"];
            }
            
            
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
    return data;
}



- (void)updatePerkListInfo:(NSArray *)ldata
{
    for (uint i = 0; i < ldata.count; i++) {
        const char *query = [[NSString stringWithFormat:@"UPDATE Cache_Perks SET cat_id = '%d', discount_price = '%d', isfav = '%d', isLike = '%d', like_count = '%d', min_credits = '%d', orig_price = '%d', perk_id = '%d', short_desc = '%@', title = '%@' WHERE perk_id = '%d'", INSERT_PERK_LIST_DATA] UTF8String];
                             
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                                     
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
                sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
                             
        [self updateCachedPerkThumbnailImage:[ldata[i] objectForKey:@"thumb_url"] andPostID:[[ldata[i] objectForKey:@"perk_id"] intValue]];
                             
    }
                             
}
                             
- (void)deleteWherePerkID:(int)lid
{
    const char *query = [[NSString stringWithFormat:@"DELETE FROM Cache_Perks WHERE perk_id = '%d'", lid] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_RANGE)
            {
                [BaseDatabase failedToRunQuery:query];
            }
            
            [self deleteImagesAtPerkID:lid];
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
}

- (void)deleteImagesAtPerkID:(int)lid
{
    const char *query = [[NSString stringWithFormat:@"DELETE FROM PerkImageURLs WHERE PerkID = '%d'", lid] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_RANGE)
            {
                [BaseDatabase failedToRunQuery:query];
            }
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
}


#pragma mark WutzwhatSection


- (void)saveCachedData:(NSArray *)ldata
{
    for (uint i = 0; i < ldata.count; i++) {
        if((NSString *)[[ldata[i] objectForKey:@"postId"] isEqualToString:@"(null)"])
            break;
        
        const char *query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO Cache(title, postTime, description, postID, likeCount, perkCount, favourited, liked, hotPick, latitude, longitude, info, distance, price, thumbnail_url, sectionType, base_city, eventDate, checkInCount, locationCount, eventStartDate, eventEndDate, mondayOpenTime, mondayCloseTime, tuesdayOpenTime, tuesdayCloseTime, wednesdayOpenTime, wednesdayCloseTime, thursdayOpenTime, thursdayCloseTime, fridayOpenTime, fridayCloseTime, saturdayOpenTime, saturdayCloseTime, sundayOpenTime, sundayCloseTime, curation, state, reviewCount, webUrl, address, postalCode, city, country, tags, bannerImageID, taxiName, taxiPhone, phone, wutzwhatTimeNote, category) VALUES('%@', '%@', '%@', '%@', '%d', '%d', '%d', '%d', '%d', '%@', '%@', '%@', '%d', '%@', '%@', '%@', '%@', '%@', '%d', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%d', '%@', '%@', '%@', '%@', '%@')",INSERT_DATA] UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        

        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
        
        [self saveCachedImages:[ldata[i] objectForKey:@"images"] andPostID:(NSString *)[ldata[i] objectForKey:@"postId"]];
        
    }

}


- (void)saveCachedImages:(NSArray *)limages andPostID:(NSString *)lpostID
{
    for (int i = 0; i < limages.count; i++) {
        NSString *thumb = [[limages objectAtIndex:i] objectForKey:@"url_thumbnail"];
        if(i == 1)
           thumb = i == 1 && [[[limages objectAtIndex:i] objectForKey:@"url_thumbnail"] isEqualToString:@"<null>"] ? [self getThumbnailURLForID:lpostID] : [[limages objectAtIndex:i] objectForKey:@"url_thumbnail"];
        
        
        const char *query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO ImageURLs(_id, id, postID, mediumURL, thumbnailURL, smallURL, largeURL, videoURL) VALUES('%@','%d', '%@', '%@', '%@', '%@', '%@', '%@')", [NSString stringWithFormat:@"%@_%d",lpostID,i], i, lpostID, [[limages objectAtIndex:i] objectForKey:@"url_medium"], thumb, [[limages objectAtIndex:i] objectForKey:@"url_small"], [[limages objectAtIndex:i] objectForKey:@"url_large"], [[limages objectAtIndex:i] objectForKey:@"url_video"]] UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
                
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
    }
}

- (void)updateCachedImages:(NSArray *)limages andPostID:(NSString *)lpostID
{
    for (uint i = 0; i < limages.count; i++) {
        const char *query = [[NSString stringWithFormat:@"UPDATE ImageURLs SET id = '%d', mediumURL = '%@', thumbnailURL = '%@', smallURL = '%@', largeURL = '%@', videoURL = '%@' WHERE postID = '%@' AND id = '%d'", i, lpostID, (NSString *)[[limages objectAtIndex:i] objectForKey:@"url_medium"], (NSString *)[[limages objectAtIndex:i] objectForKey:@"url_thumbnail"], (NSString *)[[limages objectAtIndex:i] objectForKey:@"url_small"], (NSString *)[[limages objectAtIndex:i] objectForKey:@"url_large"], (NSString *)[[limages objectAtIndex:i] objectForKey:@"url_video"], i] UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
                
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
    }
}

- (void)updateCachedThumbnailImage:(NSString *)lthumb andPostID:(NSString *)lpostID
{
    if(!lthumb || [lthumb isEqualToString:@"(null)"] || [lthumb isEqualToString:@"<null>"])
        return;
    
    const char *query = [[NSString stringWithFormat:@"UPDATE ImageURLs SET thumbnailURL = '%@' WHERE postID = '%@' AND id = 1",lthumb, lpostID] UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
                
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
}

- (NSArray *)getImageURLsForID:(NSString *)lpostID
{
    NSMutableArray *data = [NSMutableArray array];
    
    const char *query = [[NSString stringWithFormat:@"SELECT * FROM ImageURLs WHERE postID = '%@' ORDER BY id ASC", lpostID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 1)], @"Id", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]], @"url_medium", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]], @"url_thumbnail", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]], @"url_small", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]], @"url_large", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]], @"url_video", nil];
                    
                    [data addObject:object];
                }
                
                
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
    }
    return data;
}

- (NSString *)getThumbnailURLForID:(NSString *)lpostID
{
    NSString *data = [NSString string];
    
    const char *query = [[NSString stringWithFormat:@"SELECT thumbnailURL FROM ImageURLs WHERE postID = '%@' AND id = 1", lpostID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
                data = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]  ;
            
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }

    return data;
}


- (NSDictionary *)getAllCachedDataForID:(NSString *)lpostID
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSMutableArray array] forKey:@"data"];
    
    const char *query = [[NSString stringWithFormat:@"SELECT * FROM Cache WHERE postID = '%@'", lpostID] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]], @"title", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]], @"postTime", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] ], @"description", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)], @"postID", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 4)], @"like_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 5)], @"perk_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 6)], @"isfavourite", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 7)], @"islike", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 8)], @"hotpick", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 9)], @"latitude", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 10)], @"longitude", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)] ], @"info", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 12)], @"distance", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 13)], @"price", [self getThumbnailURLForID:lpostID], @"thumbnail_url", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 15)], @"section_type", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 16)], @"base_city", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 17)], @"check_in_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 18)], @"location_count", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 19)], @"event_start_date", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 20)], @"event_end_date", [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 21)], @"monday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 22)], @"monday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 23)], @"tuesday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 24)], @"tuesday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 25)], @"wednesday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 26)], @"wednesday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 27)], @"thursday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 28)], @"thursday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 29)], @"friday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 30)], @"friday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 31)], @"saturday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 32)], @"saturday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 33)], @"sunday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 34)], @"sunday_close_time", nil],@"wutzwat_time", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 35)] ], @"curation", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 36)], @"state", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 37)], @"review_count", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 38)], @"website", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 39)] ], @"address", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 40)], @"postal_code", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 41)], @"city", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 42)], @"country", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 43)] ], @"tags", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 44)], @"bannerImageID", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 45)] ], @"taxi_name", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 46)], @"taxi_phone", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 47)], @"phone", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 48)] ], @"wutzwat_time_note", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 49)], @"eventDate", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 50)], @"category", [self getImageURLsForID:lpostID], @"images", nil];
                
                [(NSMutableArray *)[data objectForKey:@"data"] addObject:object];
                
                [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]], @"section_type", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]], @"category", nil] forKey:@"params"];
                [data setObject:@"true" forKey:@"result"];
                
                
        }else {
            [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"section_type", @"null", @"category", nil] forKey:@"params"];
            [data setObject:@"false" forKey:@"result"];
            [data setObject:@"true" forKey:@"error"];
        }

            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
    return data;
}

- (void)updateListInfo:(NSArray *)ldata
{
    for (uint i = 0; i < ldata.count; i++) {
        const char *query = [[NSString stringWithFormat:@"UPDATE Cache SET title = '%@', distance = '%d', favourited = '%d', hotPick = '%d', info = '%@', likeCount = '%d', liked = '%d', perkCount = '%d', postTime = '%@', price = '%@' WHERE postID = '%@'", INSERT_LIST_DATA UTF8String];
        
        sqlite3_stmt *statement;
        sqlite3 *database;
        
        if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_RANGE)
                {
                    [BaseDatabase failedToRunQuery:query];
                }
                
                sqlite3_finalize(statement);
            } else {
                [BaseDatabase failedToRunQuery:query];
            }
            sqlite3_close(database);
        } else {
            [BaseDatabase failedToOpen];
        }
        
        [self updateCachedThumbnailImage:[ldata[i] objectForKey:@"thumb_url"] andPostID:(NSString *)[ldata[i] objectForKey:@"postId"]];
        
    }

}

- (NSDictionary *)getAllCachedDataForCategory:(int)lcategory andCity:(NSString *)lcity
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSMutableArray array] forKey:@"data"];
    
    const char *query = [[NSString stringWithFormat:@"SELECT * FROM Cache WHERE category = '%d'", lcategory] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW){
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]], @"title", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)], @"postTime", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]], @"description", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)], @"postId", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 4)], @"like_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 5)], @"perk_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 6)], @"favourited", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 6)], @"isfavourite", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 7)], @"liked", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 7)], @"islike", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 8)], @"hotpick", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 9)], @"latitude", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 10)], @"longitude", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]], @"info", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 12)], @"distance", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 13)], @"price", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 14)], @"thumbnaul_url", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 15)], @"section_type", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 16)], @"base_city", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 17)], @"check_in_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 18)], @"location_count", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 19)], @"event_start_date", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 20)], @"event_end_date", [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 21)], @"monday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 22)], @"monday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 23)], @"tuesday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 24)], @"tuesday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 25)], @"wednesday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 26)], @"wednesday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 27)], @"thursday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 28)], @"thursday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 29)], @"friday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 30)], @"friday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 31)], @"saturday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 32)], @"saturday_close_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 33)], @"sunday_open_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 34)], @"sunday_close_time", nil],@"wutzwat_time", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 35)], @"curation", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 36)], @"state", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 37)], @"review_count", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 38)], @"webUrl", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 39)], @"address", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 40)], @"postal_code", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 41)], @"city", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 42)], @"country", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 43)], @"tags", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 44)], @"bannerImageID", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 45)], @"taxi_name", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 46)], @"taxi_phone", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 47)], @"phone", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 48)], @"wutzwat_time_note", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 49)], @"eventDate", [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 50)], @"category", [self getImageURLsForID:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]], @"images", nil];
                    
                    [(NSMutableArray *)[data objectForKey:@"data"] addObject:object];
                    
                    [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]], @"section_type", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]], @"category", nil] forKey:@"params"];
                    [data setObject:@"true" forKey:@"result"];
                    
                    
                }
            }else {
                [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"section_type", @"null", @"category", nil] forKey:@"params"];
                [data setObject:@"false" forKey:@"result"];
                [data setObject:@"true" forKey:@"error"];
            }
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
    return data;
}

- (NSDictionary *)getListCachedDataForCategory:(int)lcategory andCity:(NSString *)lcity
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    [data setObject:[NSMutableArray array] forKey:@"data"];
    
    const char *query = [[NSString stringWithFormat:@"SELECT title, postTime, postID, likeCount, perkCount, favourited, liked, hotPick, info, distance, price, sectionType, category FROM Cache WHERE category = '%d'", lcategory] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    BOOL ROW = FALSE;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, NULL) == SQLITE_OK)
        {
            ROW = FALSE;
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                ROW = TRUE;
            
                //create dictionary of information
                NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]], @"title", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]], @"postTime", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]], @"postId", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 3)], @"likeCount", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 4)], @"perk_count", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 5)], @"favourited", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 6)], @"liked", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 7)], @"hotpick", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 8)]], @"info", [NSNumber numberWithInt:(const char *)sqlite3_column_int(statement, 9)], @"distance", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]], @"price", [self getThumbnailURLForID:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]]], @"thumb_url", [self getImageURLsForID:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]], @"images", nil];
                
                [(NSMutableArray *)[data objectForKey:@"data"] addObject:object];
                
                [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:[self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]], @"section_type", [self decodeNonNullString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]], @"category", nil] forKey:@"params"];
                [data setObject:@"true" forKey:@"result"];
                
                
            }
                
                if(!ROW){
                    [data setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"section_type", @"null", @"category", nil] forKey:@"params"];
                    [data setObject:@"false" forKey:@"result"];
                    [data setObject:@"true" forKey:@"error"];
                    }
            
            

            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }
    
    return data;
}

- (void)deleteWherePostID:(NSString *)lid
{
    const char *query = [[NSString stringWithFormat:@"DELETE FROM Cache WHERE postID = '%@'", lid] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_RANGE)
            {
                [BaseDatabase failedToRunQuery:query];
            }
            
            [self deleteImagesAtPostID:lid];
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }

}

- (void)deleteImagesAtPostID:(NSString *)lid
{
    const char *query = [[NSString stringWithFormat:@"DELETE FROM ImageURLs WHERE postID = '%@'", lid] UTF8String];
    
    sqlite3_stmt *statement;
    sqlite3 *database;
    
    if(sqlite3_open([self.path UTF8String], &database) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_RANGE)
            {
                [BaseDatabase failedToRunQuery:query];
            }
            
            sqlite3_finalize(statement);
        } else {
            [BaseDatabase failedToRunQuery:query];
        }
        sqlite3_close(database);
    } else {
        [BaseDatabase failedToOpen];
    }

}
@end