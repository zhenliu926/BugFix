//
//  PerksListAPIManager.h
//  WutzWhat
//
//  Created by iPhone Development on 4/11/13.
//
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
#import "PerksModel.h"

@protocol PerksListAPIManagerDelegate <NSObject>

-(void)successfullyReceivedServerResponse:(NSArray *)modelArray;

-(void)failToReceivedServerResponse:(NSString *)errorMessage;

-(void)successfullyDeletedFavorite;

-(void)failToDeleteFavorite:(NSString *)errorMessage;
@optional
-(void)internetNotAvailableError:(NSString *)errorMessage;

@end


@interface PerksListAPIManager : NSObject <DataFetcherDelegate>
{
    NSMutableDictionary *params;
}

@property(nonatomic, assign) id<PerksListAPIManagerDelegate> delegate;

@property(nonatomic, assign) BOOL forFavourite;
@property(nonatomic, assign) int categoryID;
@property(nonatomic, assign) int subCategoryID;

-(void)callPerksListAPIForSearchString:(NSString *)searchString filterBy:(int)filterBy maxPrice:(int)maxPrice minPrice:(int)minPrice startDate:(NSString *)startDate endDate:(NSString *)endDate forPage:(int)pageNumber newLatitude:(NSString *)newLatitude newLongitude:(NSString *)newLongitude;

-(void)callDeleteFavoriteByID:(NSString *)postID;;

@end
