//
//  FavrouritesCache.h
//  WutzWhat
//
//  Created by iPhone Development on 4/2/13.
//
//

#import <Foundation/Foundation.h>
#import "FileIOManager.h"
#import "JSON.h"

@interface FavouritesCache : NSObject
{
    
}

+(NSDictionary *)getProductDetailsByProductID:(NSString *)productID andIsPerk:(BOOL)lisPerk;

+ (void)saveProductDetails:(NSDictionary *)serverResponse andSection:(int)lsection andCategory:(int)lcategory;

+(void)deleteProductDetailsByID:(NSString *)productID;


+(NSDictionary *)getListOfProductsByCategoryName:(NSString *)categoryName isPerks:(BOOL)isPerks;

+(NSDictionary *)getListOfProductsByCategoryID:(NSInteger)categoryID isPerks:(BOOL)isPerks;

//+(void)saveListOfProducts:(NSDictionary *)serverResponse categoryName:(NSString *)categoryName isPerks:(BOOL)isPerks;
+(void)saveListOfProductsResponse:(NSDictionary *)serverResponse categoryID:(NSInteger)categoryID isPerks:(BOOL)isPerks;

+(void)saveListOfProductsResponse:(NSDictionary *)serverResponse categoryID:(NSInteger)categoryID isPerks:(BOOL)isPerks;

@end
