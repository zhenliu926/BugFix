//
//  GenericFetcher.h
//  NewIceApp
//
//  Created by Yunas Qazi on 2/6/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import "AbstractFetcher.h"
//kashif to send NSData as response
typedef void (^GenericFetcherCompletion)(NSDictionary *dict);

typedef void (^GenericFetcherError)(NSError *error);


@interface GenericFetcher : AbstractFetcher

- (void)makeGenericRequestWithUrl:(NSURL *)url withParams:(NSDictionary *)params completionBlock:(GenericFetcherCompletion)completed errorBlock:(GenericFetcherError)errored;
- (void)makeRequestWithUrl:(NSURL *)url withMethod:(NSString *)methodType withParams:(NSDictionary *)params completionBlock:(GenericFetcherCompletion)completed errorBlock:(GenericFetcherError)errored;


@end
