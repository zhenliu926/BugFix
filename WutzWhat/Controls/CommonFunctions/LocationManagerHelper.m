//
//  LocationManagerHelper.m
//  WutzWhat
//
//  Created by Asad Ali on 6/18/13.
//
//

#import "LocationManagerHelper.h"

@implementation LocationManagerHelper

@synthesize locationManager = _locationManager;
@synthesize userCurrentLocation = _userCurrentLocation;

+(id)staticLocationManagerObject
{
    static LocationManagerHelper *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

-(void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self performSelector:@selector(runBackGroundLocationThread)];
    
    [self fireLocationManagerToGetCurrentLocation];
}

#pragma mark- CLLocation Delegate Methods, User Position

-(void)runBackGroundLocationThread
{
//    self.userCurrentLocation = [[CLLocation alloc] initWithLatitude:[CURRENT_CITY isEqualToString:@"Toronto"] ? TORONTO_LATITUDE : NEW_YARK_LATITUDE  longitude:[CURRENT_CITY isEqualToString:@"Toronto"] ? TORONTO_LONGITUDE : NEW_YARK_LONGITUDE];
    
    NSTimer *locationTimer = [NSTimer timerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(locationTimerFired:)
                                                   userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:locationTimer forMode:NSRunLoopCommonModes];
}

-(void)locationTimerFired:(id)sender
{
    [self fireLocationManagerToGetCurrentLocation];
}

- (void) fireLocationManagerToGetCurrentLocation
{
    if (! self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    if (self.userCurrentLocation)
    {
        self.userCurrentLocation = newLocation;
    }
    else
    {
        self.userCurrentLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdatedForList" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:self.userCurrentLocation.coordinate.latitude],@"latitude", [NSNumber numberWithDouble:self.userCurrentLocation.coordinate.longitude],@"longitude", nil] forKey:@"location"]];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    
    CGFloat latitude=NEW_YARK_LATITUDE;
    CGFloat longitude=NEW_YARK_LONGITUDE;
    if([CURRENT_CITY isEqualToString:@"Toronto"])
    {
        latitude=TORONTO_LATITUDE;
        longitude=TORONTO_LONGITUDE;
    }
    
    else if([CURRENT_CITY isEqualToString:@"New York"])
    {
        latitude=NEW_YARK_LATITUDE;
        longitude=NEW_YARK_LONGITUDE;
    }
        
    else if([CURRENT_CITY isEqualToString:@"Los Angeles"])
    {
        latitude=LA_LATITUDE;
        longitude=LA_LONGITUDE;
            
    }

    self.userCurrentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdatedForList" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:self.userCurrentLocation.coordinate.latitude],@"latitude", [NSNumber numberWithDouble:self.userCurrentLocation.coordinate.longitude],@"longitude", nil] forKey:@"location"]];
}


@end
