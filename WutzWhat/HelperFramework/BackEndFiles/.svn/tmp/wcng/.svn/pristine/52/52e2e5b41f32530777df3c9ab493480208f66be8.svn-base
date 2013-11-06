//
//  AbstractParser.h
//  iceapp1
//
//  Created by Yunas Qazi on 12/13/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AbstractParserCompletion)(NSObject *responseContainer);
typedef void (^AbstractParserError)(NSError *error);

@interface AbstractParser : NSObject

- (void)getParsedDataFrom:(NSData *)rawWebData completionBlock:(AbstractParserCompletion)completed errorBlock:(AbstractParserError)errored;
@end
