//
//  GenericParser.h
//  NewIceApp
//
//  Created by Yunas Qazi on 2/6/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import "AbstractParser.h"

typedef void (^GenericParserCompletion)(NSDictionary *dict);
typedef void (^GenericParserError)(NSError *error);


@interface GenericParser : AbstractParser

- (void)getParsedDataFrom:(NSData *)rawWebData completionBlock:(GenericParserCompletion)completed errorBlock:(GenericParserError)errored;


@end
