//
//  WutzWhatListAPIManager.m
//  WutzWhat
//
//  Created by iPhone Development on 4/10/13.
//
//

#import "WutzWhatListAPIManager.h"

@implementation WutzWhatListAPIManager

@synthesize delegate = _delegate;
@synthesize forFavourite = _forFavourite;
@synthesize categoryID = _categoryID;
@synthesize subCategoryID = _subCategoryID;

-(void)callWutzWhatListAPIForSection:(int)sectionType searchString:(NSString *)searchString filterBy:(int)filterBy maxPrice:(int)maxPrice minPrice:(int)minPrice startDate:(NSString *)startDate endDate:(NSString *)endDate openNow:(BOOL)openNow forPage:(int)pageNumber newLatitude:(NSString *)newLatitude newLongitude:(NSString *)newLongitude
{
    if (![[SharedManager sharedManager] isNetworkAvailable] && self.forFavourite)
    {
        if (self.categoryID == 6)
        {
            self.categoryID = self.categoryID + self.subCategoryID;
        }
        
        NSDictionary *cachedDict = [FavouritesCache getListOfProductsByCategoryID:self.categoryID isPerks:NO];
        
        [self dataFetchedSuccessfully:cachedDict forUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_FAVORITES_LIST]];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
    
    params = [[NSMutableDictionary alloc] init];
    
    if (filterBy == EVENTS && startDate && endDate)
    {
        [params setObject:startDate forKey:@"start_date"];
        [params setObject:endDate forKey:@"end_date"];
    }
    if (openNow)
    {
        [params setObject:@"1" forKey:@"open_now"];
    }
    
    if (maxPrice != 0 || minPrice != 0)
    {
        [params setObject:[NSNumber numberWithInt:minPrice] forKey:@"price_min"];
        [params setObject:[NSNumber numberWithInt:maxPrice] forKey:@"price_max"];
    }
    
    if (self.forFavourite)
    {
        [params setValue:[NSString stringWithFormat:@"%d", self.categoryID] forKey:@"post_type"];
    }
    else
    {
        [params setValue:[NSString stringWithFormat:@"%d", self.categoryID] forKey:@"postType"];
    }
    
    [params setObject:[NSString stringWithFormat:@"%d", pageNumber]   forKey:@"page"];
    
    if (searchString && ![searchString isEqualToString:@""])
    {
        [params setObject:searchString forKey:@"search_text"];        
    }
    
    [params setObject:[NSString stringWithFormat:@"%d", self.subCategoryID + 1] forKey:@"category"];
    
    [params setObject:[NSString stringWithFormat:@"%d", sectionType] forKey:@"section_type"];
    
    [params setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"curr_date"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"cityselected"])
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"cityselected"] forKey:@"baseCity"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    [params setObject:[self getSortTypeParameterValue:filterBy] forKey:@"sort_type"];
    if(![CLLocationManager locationServicesEnabled] || ((![newLatitude isEqualToString:@"0.000000"] && newLatitude) && (![newLongitude isEqualToString:@"0.000000"] && newLongitude))) {
        
        if(newLongitude && newLatitude)
            [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation:[[CLLocation alloc] initWithLatitude:[newLatitude floatValue] longitude:[newLongitude floatValue]]];
        else
        {
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

            //else if([CURRENT_CITY isEqualToString:@"Toronto"])
                
            [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
        }
        [params setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[[LocationManagerHelper staticLocationManagerObject] userCurrentLocation].coordinate.latitude],@"latitude", [NSNumber numberWithDouble:[[LocationManagerHelper staticLocationManagerObject] userCurrentLocation].coordinate.longitude],@"longitude", nil] forKey:@"location"];
        
        NSString *requestURL = self.forFavourite ? GET_FAVORITES_LIST : GET_WUTZWHAT_LIST;
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,requestURL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    } else {
        [CommonFunctions getUserCurrentLocation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callListWithNewLocation:) name:@"LocationUpdatedForList" object:nil];
    }
}

- (void)callListWithNewLocation:(NSNotification *)not
{
    [params setObject:[[not userInfo] objectForKey:@"location"] forKey:@"location"];
    NSString *requestURL = self.forFavourite ? GET_FAVORITES_LIST : GET_WUTZWHAT_LIST;
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    NSLog(@"params - %@",params);
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,requestURL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    params = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocationUpdatedForList" object:nil];
    
}


-(NSString *)getSortTypeParameterValue:(int)filterBy
{
    if (filterBy == EVENTS)
    {
        return @"sort_by_eventDate";
    }
    else if(filterBy == 1)
    {
        return @"sort_by_latest";        
    }
    else
    {
        return @"sort_by_closest";
    }
}


#pragma mark - Data Fetcher Delegate Methods

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE]])
    {
        BOOL hasError = [[responseData objectForKey:@"result"] isEqualToString:@"error"];
        
        if (hasError)
        {
            if (self.delegate)
            {
                [self.delegate failToDeleteFavorite:[responseData objectForKey:@"error"]];
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate successfullyDeletedFavorite];
            }
        }
        return;
    }
    
    
    if (self.forFavourite)
    {
        int category = self.categoryID == 6 ? self.categoryID + self.subCategoryID : self.categoryID;
        
        [FavouritesCache saveListOfProductsResponse:responseData categoryID:category isPerks:NO];
    }
    
    NSLog(@"%@",responseData);

    if ([CommonFunctions isValueExist:[responseData objectForKey:@"result"]])
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
                NSArray *listArray = [WutzWhatModel parseWutzWhatResponse:[responseData objectForKey:@"data"]];
                
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
    else
    {
        if (self.delegate)
        {
            [self.delegate failToReceivedServerResponse:@"internet off or network error"];
        }
    }
}

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE]])
    {
        if (self.delegate)
        {
            [self.delegate failToDeleteFavorite:MSG_FAILED];
        }
        return;
    }

    if (self.delegate)
    {
        [self.delegate failToReceivedServerResponse:MSG_FAILED];
    }
}


#pragma mark - For Delete Favorite

-(void)callDeleteFavoriteByID:(NSString *)postID
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *now = [format stringFromDate:[NSDate date]];
    
    NSMutableDictionary *paramss = [[NSMutableDictionary alloc] init];
    
    [paramss setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [paramss setValue:postID forKey:@"postid"];
    [paramss setValue:now forKey:@"res_time"];
    [paramss setValue:@"0" forKey:@"favourite"];
    
    [[ProcessingView instance] forceShowTintView];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE] andDelegate:self andRequestType:@"POST" andPostDataDict:paramss];

    [[ProcessingView instance] forceHideTintView];
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
