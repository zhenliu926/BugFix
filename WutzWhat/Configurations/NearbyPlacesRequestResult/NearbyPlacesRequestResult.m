//
//  NearbyPlacesRequestResult.m
//  WutzWhat
//
//  Created by Rafay on 1/23/13.
//
//

#import "NearbyPlacesRequestResult.h"

@implementation NearbyPlacesRequestResult
- (id) initWithDelegate:(id )delegate
{
    self = [super init];
    if (self) {
        _nearbyPlacesRequestDelegate = delegate;
    }
    return self;
}

/**
 * FBRequestDelegate
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    NSArray *placesArray = [result objectForKey:@"data"];
    [_nearbyPlacesRequestDelegate nearbyPlacesRequestCompletedWithPlaces: placesArray];
}
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    NSLog(@"NearbyPlaces %@", [error localizedDescription]);
    [_nearbyPlacesRequestDelegate nearbyPlacesRequestFailed];
}
@end