//
//  AbstractParser.m
//  iceapp1
//
//  Created by Yunas Qazi on 12/13/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import "AbstractParser.h"
#import "JSON.h"

@implementation AbstractParser

- (id) init {
	if (self = [super init]) {
	}
	return self;
}


- (void)getParsedDataFrom:(NSData *)rawWebData completionBlock:(AbstractParserCompletion)completed errorBlock:(AbstractParserError)errored{
    
	NSObject *result=nil;
	
	NSString *responseString = [[NSString alloc] initWithData:rawWebData encoding:NSStringEncodingConversionAllowLossy];
	
	SBJsonParser *parser=[[SBJsonParser alloc]init];//release
	
	result =  [parser objectWithString:responseString];
	
	if (completed)
	{
		completed(result);
	}
	else
	{
		errored(nil);
	}
}



@end
