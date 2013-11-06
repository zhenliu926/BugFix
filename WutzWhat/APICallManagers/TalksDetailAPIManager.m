//
//  TalksDetailAPIManager.m
//  WutzWhat
//
//  Created by iPhone Development on 4/25/13.
//
//

#import "TalksDetailAPIManager.h"

@implementation TalksDetailAPIManager

@synthesize delegate = _delegate;

-(void)internetNotAvailableError:(NSString *)errorMessage{}

-(void)callTalksDetailAPIForID:(NSString *)talkID
{
    /*
     NSString *hardcodeResponse = MY_FIND_LIST_RESPONSE;
     
     NSDictionary *dict = [hardcodeResponse JSONValue];
     
     [self dataFetchedSuccessfully:dict forUrl:@""];
     return;
     */
    
    NSString *latitude = [[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.latitude] stringValue];
    
    NSString *longitude =[[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.longitude] stringValue];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longitude forKey:@"longitude"];
    [params setValue:talkID forKey:@"postId"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_DETAIL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}


#pragma mark - Data Fetcher Delegate Methods

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    BOOL hasError = [[responseData objectForKey:@"result"] isEqualToString:@"error"];
    
    if (hasError)
    {
        if (self.delegate)
        {
            [self.delegate failToReceivedServerResponse:[responseData objectForKey:@"error"]];
        }
    }
    else
    {
        if ([CommonFunctions isValueExist:[responseData objectForKey:@"data"]])
        {
            TalksDetailModel *model = [TalksDetailModel parseTalksDetailResponse:[responseData objectForKey:@"data"]];
            
            if (self.delegate)
            {
                [self.delegate successfullyReceivedServerResponse:model];
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate failToReceivedServerResponse:[responseData objectForKey:@"error"]];
            }
        }
    }
}

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    if (self.delegate)
    {
        [self.delegate failToReceivedServerResponse:MSG_FAILED];
    }
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    if ([self.delegate respondsToSelector:@selector(internetNotAvailableError:)])
    {
        [self.delegate internetNotAvailableError:errorMessage];
    }
}

@end
