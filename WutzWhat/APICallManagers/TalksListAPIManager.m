//
//  TalksListAPIManager.m
//  WutzWhat
//
//  Created by iPhone Development on 4/12/13.
//
//

#import "TalksListAPIManager.h"

@implementation TalksListAPIManager

@synthesize delegate = _delegate;

-(void)callTalksListAPIForCategory:(int)categoryID forPage:(int)pageNumber
{
    /*
     NSString *hardcodeResponse = MY_FIND_LIST_RESPONSE;
     
     NSDictionary *dict = [hardcodeResponse JSONValue];
     
     [self dataFetchedSuccessfully:dict forUrl:@""];
     return;
     */
    
//    NSString *latitude = [[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.latitude] stringValue];
//    
//    NSString *longitude =[[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.longitude] stringValue];
//    
//    NSMutableDictionary *locationDict  = [[NSMutableDictionary alloc] initWithCapacity:2];
//    
//    [locationDict setObject:latitude forKey:@"latitude"];
//    [locationDict setObject:longitude forKey:@"longitude"];
    
     params = [[NSMutableDictionary alloc] init];
    
    [params setValue:[NSString stringWithFormat:@"%d", categoryID] forKey:@"postType"];
    
    [params setObject:[NSString stringWithFormat:@"%d", pageNumber]   forKey:@"page"];

    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    if(![CLLocationManager locationServicesEnabled]) {
        
        
        CGFloat latitude=NEW_YARK_LATITUDE;
        CGFloat longitude=NEW_YARK_LONGITUDE;
        if([CURRENT_CITY isEqualToString:@"Toronto"])
        {
            latitude=TORONTO_LATITUDE;
            longitude=TORONTO_LONGITUDE;
        }
        
        else if([CURRENT_CITY isEqualToString:@"New York"])
        {
            latitude=NEW_YARK_LATITUDE;
            longitude=NEW_YARK_LONGITUDE;
        }
        
        else if([CURRENT_CITY isEqualToString:@"Los Angeles"])
        {
            latitude=LA_LATITUDE;
            longitude=LA_LONGITUDE;
            
        }

        
        [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation:[[CLLocation alloc] initWithLatitude:latitude  longitude:longitude]];
        
        [params setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[[LocationManagerHelper staticLocationManagerObject] userCurrentLocation].coordinate.latitude],@"latitude", [NSNumber numberWithDouble:[[LocationManagerHelper staticLocationManagerObject] userCurrentLocation].coordinate.longitude],@"longitude", nil] forKey:@"location"];
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_LIST] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    } else {
        [CommonFunctions getUserCurrentLocation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callListWithNewLocation:) name:@"LocationUpdatedForList" object:nil];
    }
}

- (void)callListWithNewLocation:(NSNotification *)not
{
    [params setObject:[[not userInfo] objectForKey:@"location"] forKey:@"location"];
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_LIST] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    params = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocationUpdatedForList" object:nil];
    
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
            NSArray *listArray = [TalksModel parseTalksResponse:[responseData objectForKey:@"data"]];
            
            if (self.delegate)
            {
                [self.delegate successfullyReceivedServerResponse:listArray];
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
