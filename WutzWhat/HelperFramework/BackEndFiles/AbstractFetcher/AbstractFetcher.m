//
//  AbstractFetcher.m
//  iceapp1
//
//  Created by Yunas Qazi on 12/13/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import "AbstractFetcher.h"
#import "ASyncURLConnection.h"

@implementation AbstractFetcher
@synthesize container;


- (id) init {
	if (self = [super init]) {
	}
	return self;
}


- (void)fetchWithUrl:(NSURL *)url completionBlock:(AbstractFetcherCompletion)completed errorBlock:(AbstractFetcherError)errored
{

	[AsyncURLConnection request:url completeBlock:^(NSData *data) {
		
		if (data) 
		{
			completed(data);
		}
		else
		{
			errored(nil);
		}
		
		
	} errorBlock:^(NSError *error) {

		errored(error);
	
	}];
}


@end