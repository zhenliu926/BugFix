//
//  GenericParser.m
//  NewIceApp
//
//  Created by Yunas Qazi on 2/6/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import "GenericParser.h"

@implementation GenericParser

- (id) init {
	if (self = [super init]) {
	}
	return self;
}



- (void)getParsedDataFrom:(NSData *)rawWebData completionBlock:(GenericParserCompletion)completed errorBlock:(GenericParserError)errored{
	
	
    
	[super getParsedDataFrom:rawWebData completionBlock:^(NSObject* responseContainer)
	 {
		 //kashif to send NSData instead of NSDictionary
		 /*completed((NSDictionary *)responseContainer);*/
         completed((NSDictionary *)responseContainer);
         
//		 NSDictionary *advertDict = [(NSDictionary*)responseContainer objectForKey:KEY_AD];
//		 if ([(NSString *)[responseContainer valueForKey:KEY_STATUS] isEqualToString:KEY_STATUS_OK]) 
//		 {
//			 if (advertDict) 
//			 {     
//				 
//                 Advert *advert=[[Advert alloc] init];
//                 advert.id          = [[advertDict valueForKey:KEY_ADVERT_ID] intValue];
//                 advert.promoType   = [advertDict valueForKey:KEY_ADVERT_PROMOTYPE];
//                 advert.type        = [advertDict valueForKey:KEY_ADVERT_TYPE];
//                 advert.typeId      = [[advertDict valueForKey:KEY_ADVERT_TYPE_ID] intValue];
//                 advert.image_path  = [advertDict valueForKey:KEY_ADVERT_IMAGE_PATH];
//                 advert.startDate   = [advertDict valueForKey:KEY_ADVERT_STARTDATE];
//                 advert.endDate     = [advertDict valueForKey:KEY_ADVERT_ENDDATE];
//                 completed(advert);
//			 }
//             
//			 
//		 }
//		 else
//		 {
//			 NSLog(@"Advert Parsing Failed !");
//			 errored(nil);
//		 }
		 
	 } 
				  errorBlock:^(NSError *error)
	 {
		 
	 }];
	
}

@end
