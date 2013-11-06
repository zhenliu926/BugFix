//
//  URLBuilder.m
//  AppSettings
//
//  Created by uk on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "URLBuilder.h"

#import "Constants.h"
#import "JSON.h"
@implementation URLBuilder



/*+ (NSURL*)urlForMethod:(NSString*)method withJsonParameters:(NSMutableDictionary*)params{
    
    NSURL* result;
    
    NSString *requestType = [params valueForKey:WEB_REQUEST];
	[params removeObjectForKey:WEB_REQUEST];

    AppSettings *settings=[AppSettings instance];
    SBJsonWriter *p = [[SBJsonWriter alloc] init];
    NSString *jsonStr = [p stringWithObject:params];
    NSLog(@"jsonStr=%@",jsonStr);
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@",[settings getBaseAddressOfType:requestType],method,jsonStr];
    NSLog(@"urlwithComa=%@",url);
	NSString *encodedURL=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    result = [NSURL URLWithString:encodedURL];
    return result;         
    
}*/

+ (NSURL*)urlForMethod:(NSString*)method withBaseUrl:(NSString*)baseUrl withParameters:(NSMutableDictionary*)params{
    
    NSURL* result;
    NSString *requestType = @"";//
    @try {
       requestType = [params valueForKey:WEB_REQUEST];
        [params removeObjectForKey:WEB_REQUEST];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    NSMutableString *queryString = [[NSMutableString alloc] init];
    int paramCounter = 0;
    for(NSString *key in [params allKeys]){
        paramCounter++;
        id object= [params objectForKey:key];
        
        if (object){
            if (paramCounter > 1) {
            [queryString appendFormat:@"&%@=%@", key, [params objectForKey:key]];    
            }
            else
            [queryString appendFormat:@"%@=%@", key, [params objectForKey:key]];
        }else{
            [NSException exceptionWithName:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] reason:@"Invalid key value pair" userInfo:nil]; 
        }          
    }
    
	
    //AppSettings *settings=[AppSettings instance];
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,method,queryString];
    NSLog(@"urlwithComa=%@",url);

	NSString *encodedURL=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    result = [NSURL URLWithString:encodedURL];
    
    return result;         
    
}



@end
