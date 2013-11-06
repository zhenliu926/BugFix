//
//  ChangeLocationViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 1/22/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "WutzWhatModel.h"
#import "HotPicksModel.h"
#import "TalksModel.h"
#import "GoogleAddressAPI.h"
#import "GoogleLocationAPIModel.h"
#import "GoogleAddressAPIResultViewController.h"

@interface ChangeLocationViewController : UIViewController
<MKMapViewDelegate, UISearchBarDelegate, GoogleAddressAPIDelegate, GoogleAddressAPIResultViewDelegate> {
    
    MKMapView *_mapView;
    Annotation *_mapAnnotation;
    NSString *type;
    
    NSString *latitude;
    NSString *longitude;
    
    NSString *finalAddress;
    GoogleAddressAPI *addressSuggestions;
    
    NSArray *googleAddressSuggestions;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) Annotation *mapAnnotation;
@property(nonatomic, retain) NSString *_lat;
@property(nonatomic, retain) NSString *_long;
@property(nonatomic, retain) NSString *type;

@property(nonatomic, retain) LocationModel *currentLocationModel;

@property (nonatomic,retain) NSMutableArray *mapCoordinates;
@property (nonatomic,retain) NSMutableDictionary *xyz;

-(IBAction)btnCurrentLocation_Pressed:(id)sender;
- (IBAction)btnSaveLocationClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UISearchBar *mapSearchBar;

@end
