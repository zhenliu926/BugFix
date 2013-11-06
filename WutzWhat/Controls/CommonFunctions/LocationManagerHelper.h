//
//  LocationManagerHelper.h
//  WutzWhat
//
//  Created by Asad Ali on 6/18/13.
//
//

#import <Foundation/Foundation.h>

@interface LocationManagerHelper : NSObject<CLLocationManagerDelegate>
{
    
}

@property (strong, nonatomic)CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *userCurrentLocation;

-(void)startLocationManager;
+(id)staticLocationManagerObject;

@end
