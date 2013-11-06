//
//  GenericFetcher.m
//  NewIceApp
//
//  Created by Yunas Qazi on 2/6/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import "GenericFetcher.h"
#import "GenericParser.h"
#import "URLBuilder.h"


@implementation GenericFetcher
- (id) init {
	if (self = [super init]) {
	}
	return self;
}



- (void)makeRequestWithUrl:(NSURL *)url withMethod:(NSString *)methodType withParams:(NSDictionary *)params completionBlock:(GenericFetcherCompletion)completed errorBlock:(GenericFetcherError)errored{
//
//
//	if ([methodType isEqualToString:@"POST"]) {
//		
//		[super fetchWithUrl:url 
//			 withMethodType:methodType
//			withMethodyBody:params
//			completionBlock:^(NSData *webRawData){
//				GenericParser *parser = [[GenericParser alloc]init];
//				[parser getParsedDataFrom:webRawData completionBlock:^(NSDictionary *dict){
//					completed(dict);
//				} 
//				errorBlock:^(NSError *error)
//				 {
//					 errored(error);
//				 }];
//				} 
//			 errorBlock:^(NSError *error){
//				 errored(error);
//			 }];
//				
//				
//	}
//	
}
- (void)makeGenericRequestWithUrl:(NSURL *)url withParams:(NSDictionary *)params completionBlock:(GenericFetcherCompletion)completed errorBlock:(GenericFetcherError)errored{
	
	[super fetchWithUrl:url
		completionBlock:^(NSData *webRawData){
			//parse data and send back
			GenericParser *parser = [[GenericParser alloc]init];
			[parser getParsedDataFrom:webRawData completionBlock:^(NSDictionary *dict){
				completed(dict);
			}
                           errorBlock:^(NSError *error)
			 {
				 errored(error);
			 }];
		}
             errorBlock:^(NSError *error){
                 errored(error);
             }];
}

@end
