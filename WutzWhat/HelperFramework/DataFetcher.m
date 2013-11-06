//
//  DataFetcher.m
//  WutzWhat
//
//  Created by Kashif Ilyas on 15/11/2012.
//
//

#import "DataFetcher.h"
#import "OADataFetcher.h"
#import "OAPlaintextSignatureProvider.h"
#import "JSON.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "SharedManager.h"
#import "OAServiceTicket.h"
#import "ProcessingView.h"
#import "GenericFetcher.h"

@implementation DataFetcher

@synthesize delegate,urlStr,paramDict,methodType, isStreamDataRequest;

-(void)logErrors:(NSString *)errorMessage{}

- (void) fetchDataForUrl :(NSString*)urlStrParam andDelegate:(id<DataFetcherDelegate>)delegateParam andRequestType:(NSString*)getOrPost andPostDataDict:(NSDictionary*)postDataParamDict
{
    
   // NSLog(@"%@ FETCHDATAURL",urlStrParam);
    self.urlStr = urlStrParam;
    self.delegate = delegateParam;
    self.paramDict = postDataParamDict;

    self.methodType = getOrPost;
    
    
    if (![[SharedManager sharedManager] isNetworkAvailable] && !((WutzWhatListAPIManager *)self.delegate).forFavourite)
    {
        [[ProcessingView instance] forceHideTintView];
        
        if ([self.delegate respondsToSelector:@selector(internetNotAvailable:)])
        {
            [self.delegate internetNotAvailable:MSG_NO_INTERNET_CONNECTIVITY];
        }
        
        return;
    }
    
    [self performSelectorInBackground:@selector(getOauthDataUsingHMAC) withObject:nil];
}


- (void) getOauthDataUsingHMAC
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"1EvVK5StAE2BzGoOo55U2mITN4obUS"
                                                    secret:@"2NBNuSwBKE3hX9aEtqEU3xwOqEVqu0"];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:NULL
                                                                      realm:NULL
                                                          signatureProvider:nil andMethodType:self.methodType];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:finishedWithData:)
                  didFailSelector:@selector(requestTokenTicket:failedWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    
     NSLog(@"Success requestTokenTicket");
    if ([self.methodType isEqualToString:@"POST"])
    {
        [self performSelectorOnMainThread:@selector(fetchDataForTicket:)
                               withObject:ticket
                            waitUntilDone:YES];
    }
    else if ([self.methodType isEqualToString:@"GET"])
    {
        [self performSelectorOnMainThread:@selector(getDataForTicket:)
                               withObject:ticket
                            waitUntilDone:YES];
    }
    
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error
{
    
    if ([self.methodType isEqualToString:@"POST"])
    {
        [self performSelectorOnMainThread:@selector(fetchDataForTicket:)
                               withObject:ticket
                            waitUntilDone:YES];
    }
    else if ([self.methodType isEqualToString:@"GET"])
    {
        [self performSelectorOnMainThread:@selector(getDataForTicket:)
                               withObject:ticket
                            waitUntilDone:YES];
    }
}


-(void)fetchDataForTicket:(OAServiceTicket *)ticket
{
    NSString *time=   ticket.request.getTime;
    
    NSString *url = [NSString stringWithFormat:@"%@?oauth_consumer_key=1EvVK5StAE2BzGoOo55U2mITN4obUS&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_version=1.0&signature=%@",self.urlStr,ticket.request.nonce,time,ticket.request.signature];
    
    NSLog(@"%@ URL",url);
    
    
   if (self.isStreamDataRequest)
    {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        NSString *body = [NSString stringWithFormat:@""];
        [request setRequestMethod:self.methodType];
        [request addRequestHeader:@"Content-Type" value:@"application/raw"];
        [request addRequestHeader:@"Accept" value:@"application/json"];

        body = [self getJsonStringFromParamDict];
        
        NSLog(@"%@ BODY",body);
        
        request.postBody = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *fileDownloadPath = [NSString stringWithFormat:@"%@/receipt_01.pdf",[FileIOManager getDocumentDirectoryPath]];
        [request setDownloadDestinationPath:fileDownloadPath];
        [request setCompletionBlock:^(void)
         {
             if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dataFetchedSuccessfully:forUrl:)])
             {
                 NSDictionary *responseDict = @{@"receipt": fileDownloadPath};
                 [self.delegate dataFetchedSuccessfully:responseDict forUrl:self.urlStr];
             }
         }];
        
        [request setFailedBlock:^(void)
         {
             if (delegate != nil && [delegate respondsToSelector:@selector(dataFetchedFailure:forUrl:)])
             {
                 [self.delegate dataFetchedFailure:nil  forUrl:self.urlStr];
                 return;
             }
         }];
        
        [request startAsynchronous];
        return;
    }

    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *body = [NSString stringWithFormat:@""];
    [request setRequestMethod:self.methodType];
    [request addRequestHeader:@"Content-Type" value:@"application/raw"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    body = [self getJsonStringFromParamDict];
    
    
    request.postBody = [NSMutableData dataWithData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setCompletionBlock:^(void)
     {
         NSString * ResponseString = [request responseString];
        
         NSError *e;
         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: [ResponseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error: &e];
         
         NSMutableDictionary *dict  = [[NSMutableDictionary alloc] initWithDictionary:responseDictionary];
                if([[dict objectForKey:@"HTTP_CODE"] intValue] == 401)
         {
              NSLog(@"%@ REQUEST FAILED",url);
             [DataFetcher logoutOfApp];
             [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_SERVER_FAILED];
             if (self.paramDict)
                 [dict setObject:self.paramDict forKey:@"params"];
             
             if ([self.urlStr isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL]] && [[self.paramDict valueForKey:@"login_type"] isEqualToString:@"Facebook"])
             {
                 self.urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL];
             }
             if (delegate != nil && [delegate respondsToSelector:@selector(dataFetchedFailure:forUrl:)])
             {
                 [self.delegate dataFetchedFailure:dict  forUrl:self.urlStr];
                 return;
                 
             }
             return;
         }
         
         if (self.paramDict)
         {
             [dict setObject:self.paramDict forKey:@"params"];
         }
         
        [[ProcessingView instance] hideTintView];
         
         if ([self.urlStr isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL]] && [[self.paramDict valueForKey:@"login_type"] isEqualToString:@"Facebook"])
         {
             self.urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL];
         }
         if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dataFetchedSuccessfully:forUrl:)]) {
             if (dict!=nil)
             {
                 [self.delegate dataFetchedSuccessfully:dict forUrl:self.urlStr];
             }
             else
             {
                 return;
             }
             
         }
     }];
    
    [request setFailedBlock:^(void)
     {
         NSString * ResponseString = [request responseString];
         
         NSDictionary *responseDictionary = [ResponseString JSONValue];
         
        [[ProcessingView instance] hideTintView];
         
         NSMutableDictionary *dict  = [[NSMutableDictionary alloc] initWithDictionary:responseDictionary];
         
         if (self.paramDict)
             [dict setObject:self.paramDict forKey:@"params"];
         
         if ([self.urlStr isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL]] && [[self.paramDict valueForKey:@"login_type"] isEqualToString:@"Facebook"])
         {
             self.urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL];
         }
         if (delegate != nil && [delegate respondsToSelector:@selector(dataFetchedFailure:forUrl:)])
         {
             [self.delegate dataFetchedFailure:dict  forUrl:self.urlStr];
             return;
             
         }
     }];
    
    [request startAsynchronous];
}

+ (void)logoutOfApp
{
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    [CommonFunctions setAppBadgeNumber:0];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //Zeeshan for Logout
    [FBSession.activeSession closeAndClearTokenInformation];
    
    if (appDelegate.facebookData && appDelegate.facebookData != nil)
    {
        appDelegate.facebookData=@
        {
            @"username": @"",
            @"city":@"",
            @"profilePicture":@"",
            @"id":@"",
            @"email":@"",
            @"distance_unit":@"",
            @"country_code":@""
        };
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"profilePicture"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_email"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_password"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hiddenLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_name"];
     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    //Zeeshan check for Autologin : NO
    NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@NO,@"",@"",@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
    [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
    [[SharedManager sharedManager] saveSessionToDisk];
    
    UINavigationController *navController = (UINavigationController *)appDelegate.window.rootViewController;
    NSArray *vcs = navController.viewControllers;
    for (UIViewController *vc in vcs) {
        if (![vc isKindOfClass:[LoginViewController class]] && !vc.isBeingDismissed) {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [navController popViewControllerAnimated:YES];
            });
            
            break;
        }
    }
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}


-(void)getDataForTicket:(OAServiceTicket *)ticket
{
    NSString *time=   ticket.request.getTime;
    
    NSString *url = [NSString stringWithFormat:@"%@?oauth_consumer_key=1EvVK5StAE2BzGoOo55U2mITN4obUS&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_version=1.0&signature=%@",self.urlStr,ticket.request.nonce,time,ticket.request.signature];
    
    GenericFetcherCompletion completeBlock = ^(NSDictionary *responseDictionary)
    {
        
        NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithDictionary:responseDictionary] ;

        if (self.paramDict)
        {
            [dict setObject:self.paramDict forKey:@"params"];
        }
        
        if ([self.delegate respondsToSelector:@selector(dataFetchedSuccessfully:forUrl:)])
        {
            if (dict!=nil) {
                [self.delegate dataFetchedSuccessfully:dict forUrl:self.urlStr];
            }
            else
            {
                return;
            }
        
        }
    };
    
    GenericFetcherError errorBlock = ^(NSError *error)
    {
        if ([self.delegate respondsToSelector:@selector(dataFetchedFailure:forUrl:)])
        {
        }
            [[ProcessingView instance] forceHideTintView];
    };
    
    GenericFetcher *fetcher = [[GenericFetcher alloc] init];
    [fetcher makeGenericRequestWithUrl:[NSURL URLWithString:url] withParams:nil completionBlock:completeBlock errorBlock:errorBlock];
    
}

-(NSString *)getStringOfDictionary:(NSDictionary *)dict
{
    if (dict == nil || [dict count] < 1)
    {
        return @"No Params";
    }
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    if (! jsonData)
    {
        return error.description;        
    }
    else
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}


-(NSString*)getJsonStringFromParamDict
{
    NSError *error;
    NSString *jsonString = @"";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.paramDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

-(void)dealloc
{
    [self setUrlStr:nil];
    [self setParamDict:nil];
    [self setMethodType:nil];
    [self setDelegate:nil];
}

@end


