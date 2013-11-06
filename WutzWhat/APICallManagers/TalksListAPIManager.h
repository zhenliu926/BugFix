//
//  TalksListAPIManager.h
//  WutzWhat
//
//  Created by iPhone Development on 4/12/13.
//
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
#import "TalksModel.h"
#import "HardCodedResponse.h"

@protocol TalksListAPIManagerDelegate <NSObject>

-(void)successfullyReceivedServerResponse:(NSArray *)modelArray;

-(void)failToReceivedServerResponse:(NSString *)errorMessage;

-(void)internetNotAvailableError:(NSString *)errorMessage;

@end


@interface TalksListAPIManager : NSObject <DataFetcherDelegate>
{
    NSMutableDictionary *params;
}

@property(nonatomic, assign) id<TalksListAPIManagerDelegate> delegate;


-(void)callTalksListAPIForCategory:(int)categoryID forPage:(int)pageNumber;


@end