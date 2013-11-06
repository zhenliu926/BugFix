//
//  GoogleAddressAPI.m
//  WutzWhat
//
//  Created by iPhone Development on 3/21/13.
//
//

#import "GoogleAddressAPI.h"

@implementation GoogleAddressAPI

@synthesize delegate = _delegate;

-(void)getGoogleAddressSuggestion:(NSString *)userEnterdAddress
{

    userEnterdAddress = [userEnterdAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    userEnterdAddress = [NSString stringWithFormat:@"%@%@", GOOGLE_ADRESS_API, userEnterdAddress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geoCodeInfo) name:@"geocodeInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geocodeFailed) name:@"failedGeocode" object:nil];
    
    
    NSLog(@"requestString %@",userEnterdAddress);
    
    NSURL *requestURL = [NSURL URLWithString:userEnterdAddress];
    
    request = [ASIHTTPRequest requestWithURL:requestURL];
    
    [request setCompletionBlock:^(void)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"geocodeInfo" object:nil];
    }];
    
    [request setFailedBlock:^(void)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"failedGeocode" object:nil];
     }];

    [request startAsynchronous];
}

- (void)geocodeFailed
{
    [self.delegate failToFindAddress];
    request = nil;
    [self removeObservers];
}

- (void)geoCodeInfo
{
    NSDictionary *responseDict = [request.responseString JSONValue];
    
    NSArray *addressModelArray = [GoogleLocationAPIModel parseAddressFromArray:[responseDict objectForKey:@"results"]];
    
    [self.delegate didFindAddress:addressModelArray];
    
    request = nil;
    [self removeObservers];
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"failedGeocode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"geocodeInfo" object:nil];
}

@end
