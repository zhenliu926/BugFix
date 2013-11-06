//
//  WutzWhatListAPIManager.h
//  WutzWhat
//
//  Created by iPhone Development on 4/10/13.
//
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
#import "WutzWhatModel.h"
#import "HardCodedResponse.h"

@protocol WutzWhatListAPIManagerDelegate <NSObject>

-(void)successfullyReceivedServerResponse:(NSArray *)modelArray;

-(void)failToReceivedServerResponse:(NSString *)errorMessage;

-(void)successfullyDeletedFavorite;

-(void)failToDeleteFavorite:(NSString *)errorMessage;
@optional
-(void)internetNotAvailableError:(NSString *)errorMessage;

@end

@interface WutzWhatListAPIManager : NSObject <DataFetcherDelegate>
{
    NSMutableDictionary *params;
}

@property(nonatomic, assign) id<WutzWhatListAPIManagerDelegate> delegate;
@property(nonatomic, assign) BOOL forFavourite;
@property(nonatomic, assign) int categoryID;
@property(nonatomic, assign) int subCategoryID;

-(void)callWutzWhatListAPIForSection:(int)sectionType searchString:(NSString *)searchString filterBy:(int)filterBy maxPrice:(int)maxPrice minPrice:(int)minPrice startDate:(NSString *)startDate endDate:(NSString *)endDate openNow:(BOOL)openNow forPage:(int)pageNumber newLatitude:(NSString *)newLatitude newLongitude:(NSString *)newLongitude;

-(void)callDeleteFavoriteByID:(NSString *)postID;

@end
