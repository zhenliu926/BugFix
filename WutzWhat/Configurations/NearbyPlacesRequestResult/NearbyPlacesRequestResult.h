//
//  NearbyPlacesRequestResult.h
//  WutzWhat
//
//  Created by Rafay on 1/23/13.
//
//

#import <Foundation/Foundation.h>

@protocol NearbyPlacesRequestDelegate;
@interface NearbyPlacesRequestResult : NSObject {
    id _nearbyPlacesRequestDelegate;
}
- (id) initWithDelegate:(id )delegate;
@end
@protocol NearbyPlacesRequestDelegate
- (void) nearbyPlacesRequestCompletedWithPlaces:(NSArray *)placesArray;
- (void) nearbyPlacesRequestFailed;
@end
