//
//  PostCheckinRequestResult.m
//  WutzWhat
//
//  Created by Rafay on 1/23/13.
//
//

#import "PostCheckinRequestResult.h"

@implementation PostCheckinRequestResult
- (id) initWithDelegate: (id)delegate {
    self = [super init];
    _postCheckinRequestDelegate = delegate ;
    return self;
}
/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    [_postCheckinRequestDelegate postCheckinRequestCompleted];
}
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    NSLog(@"Post Checkin Failed:%@", [error localizedDescription]);
    [_postCheckinRequestDelegate postCheckinRequestFailed];
}
@end