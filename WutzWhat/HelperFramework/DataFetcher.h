//
//  DataFetcher.h
//  WutzWhat
//
//  Created by Kashif Ilyas on 15/11/2012.
//
//

#import <Foundation/Foundation.h>

@protocol DataFetcherDelegate <NSObject>

@optional
- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url;
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url;
- (void)internetNotAvailable:(NSString *)errorMessage;

@end

@interface DataFetcher : NSObject
{
//    NSMutableDictionary *mainDictionary;
}
@property (nonatomic,retain) id <DataFetcherDelegate> delegate;

@property (nonatomic,retain) NSString *urlStr;
@property (nonatomic,retain) NSDictionary *paramDict;
@property (nonatomic,retain) NSString *methodType;
@property (nonatomic) BOOL isStreamDataRequest;

- (void) fetchDataForUrl :(NSString*)urlStrParam andDelegate:(id<DataFetcherDelegate>)delegateParam andRequestType:(NSString*)getOrPost andPostDataDict:(NSDictionary*)postDataParamDict;

-(void)logErrors:(NSString *)errorMessage;
+ (void)logoutOfApp;
@end
