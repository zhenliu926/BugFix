//
//  MapViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 4/17/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "WutzWhatModel.h"
#import "TalksModel.h"
#import "PerksModel.h"
#import "TalksProductDetailViewController.h"
#import "PerksProductDetailViewController.h"
#import "WutzWhatProductDetailViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,UIActionSheetDelegate>
{
    BOOL CurrentLocations;
    NSMutableArray *mapAnnotationArray;
}

@property (nonatomic, assign)BOOL forProfile;

@property (nonatomic, assign) int postTypeID;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIButton *current;
@property(nonatomic, retain) IBOutlet UIButton *refresh;

@property(nonatomic, retain) Annotation *mapAnnotation;
@property(nonatomic, retain) NSString *_lat;
@property(nonatomic, retain) NSString *_long;
@property(nonatomic) BOOL isSingleMapView;

@property (nonatomic, assign) int categoryType;

- (void)setCurrentLocation:(CLLocation *)location;

@property (nonatomic,strong) NSArray *modelArray;

-(IBAction)btnCurrentLocation_Pressed:(id)sender;
-(IBAction)btnRefresh_Pressed:(id)sender;

@end
