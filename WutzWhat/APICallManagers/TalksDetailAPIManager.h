//
//  TalksDetailAPIManager.h
//  WutzWhat
//
//  Created by iPhone Development on 4/25/13.
//
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
#import "TalksDetailModel.h"
#import "HardCodedResponse.h"

@protocol TalksDetailAPIManagerDelegate <NSObject>

-(void)successfullyReceivedServerResponse:(TalksDetailModel *)model;

-(void)failToReceivedServerResponse:(NSString *)errorMessage;
@optional
-(void)internetNotAvailableError:(NSString *)errorMessage;

@end


@interface TalksDetailAPIManager : NSObject <DataFetcherDelegate>
{
    
}

@property(nonatomic, assign) id<TalksDetailAPIManagerDelegate> delegate;


-(void)callTalksDetailAPIForID:(NSString *)talkID;


@end
