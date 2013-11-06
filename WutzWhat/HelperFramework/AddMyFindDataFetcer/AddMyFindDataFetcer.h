//
//  AddMyFindDataFetcer.h
//  WutzWhat
//
//  Created by iPhone Development on 4/18/13.
//
//

#import <Foundation/Foundation.h>
#import "OADataFetcher.h"
#import "OAPlaintextSignatureProvider.h"
#import "JSON.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "SharedManager.h"
#import "OAServiceTicket.h"
#import "GenericFetcher.h"
#import "ProcessingView.h"

@protocol AddMyFindDataFetcerDelegate <NSObject>

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url;
- (void) dataFetchedFailureForUrl:(NSString*)url;
- (void)internetNotAvailable:(NSString *)errorMessage;

@end

@interface AddMyFindDataFetcer : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *receivedData;
    UIView *tintView;
    UIProgressView * myProgressIndicator;    
}

@property (nonatomic,retain) id <AddMyFindDataFetcerDelegate> delegate;

@property (nonatomic,retain) NSString *urlStr;
@property (nonatomic,retain) NSString *methodType;
@property (nonatomic,retain) NSDictionary *paramDict;
@property (nonatomic,retain) NSArray *imagesArray;
@property (nonatomic,assign) int oldImagesCount;
@property (nonatomic,retain) NSArray *newlyAddedImagesArray;
@property (nonatomic,retain) NSArray *deletedImagesIDs;
@property (nonatomic,assign) BOOL editMode;

- (void)fetchDataForUrl :(NSString*)urlStrParam andDelegate:(id<AddMyFindDataFetcerDelegate>)delegateParam postDataDict:(NSDictionary*)postDataParamDict UIImagesArray:(NSArray *)UIImagesArray;

-(NSMutableURLRequest *)multipartRequestWithURL:(NSURL *)url andMethod:(NSString *)HTTPMethod andDataDictionary:(NSDictionary *) dictionary images:(NSArray *)imagesArray;

@end
