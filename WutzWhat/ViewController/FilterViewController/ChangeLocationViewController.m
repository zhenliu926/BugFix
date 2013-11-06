//
//  ChangeLocationViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 1/22/13.
//
//

#import "ChangeLocationViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#define METERS_PER_MILE 1609.344


@implementation ChangeLocationViewController

@synthesize mapCoordinates;
@synthesize mapView         = _mapView;
@synthesize mapAnnotation   = _mapAnnotation;
@synthesize _lat;
@synthesize _long;
@synthesize type;
@synthesize xyz;
@synthesize currentLocationModel = _currentLocationModel;

- (void)userSelectNewAddress:(NSString *)address{}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    self.navigationController.navigationBar.hidden = NO;
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_wutzwhat.png"]];
    [[self navigationItem]setTitleView:titleIV];
    if(OS_VERSION>=7)
    {
        self.mapSearchBar.frame=CGRectMake(self.mapSearchBar.frame.origin.x,self.mapSearchBar.frame.origin.y+44,self.mapSearchBar.frame.size.width,self.mapSearchBar.frame.size.height);
    }
    
    [self checkForSaveLocation];
}

-(void)checkForSaveLocation
{
    self.mapView.showsUserLocation=TRUE;
	CLLocationCoordinate2D theCoordinate;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MapDrop"])
    {
        theCoordinate.latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLatitude"] doubleValue];
        theCoordinate.longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLongitude"] doubleValue];
        
        longitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLongitude"];
        latitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLatitude"];
    }
    else
    {
        theCoordinate.latitude = [CommonFunctions getUserCurrentLocation].coordinate.latitude;
        theCoordinate.longitude = [CommonFunctions getUserCurrentLocation].coordinate.longitude;
        
        longitude = [NSString stringWithFormat:@"%f",[CommonFunctions getUserCurrentLocation].coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%f",[CommonFunctions getUserCurrentLocation].coordinate.latitude];
    }
    
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil];
	annotation.title = @"Drag to change location";
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSMutableString * result = [[NSMutableString alloc] init];
    
    [geocoder reverseGeocodeLocation:annotation.location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if (placemarks.count == 1)
                            {
                                CLPlacemark *place = [placemarks objectAtIndex:0];
                                
                                NSArray *FormattedAddressLines = [place.addressDictionary objectForKey:@"FormattedAddressLines"];
                                
                                for (NSObject * obj in FormattedAddressLines)
                                {
                                    [result appendString:[NSString stringWithFormat:@" %@",[obj description]]];
                                }
                                annotation.subtitle = result;
                            }
                            else
                            {
                                annotation.subtitle = @"Not found.";
                            }
                        });
     }];
	
	[self.mapView addAnnotation:annotation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(theCoordinate, 1900*METERS_PER_MILE, 1900*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self.mapView setDelegate:self];
    [self.mapSearchBar setDelegate:self];
    addressSuggestions = [[GoogleAddressAPI alloc] init];
    [addressSuggestions setDelegate:self];
}


- (void)viewDidUnload
{
    [self setMapSearchBar:nil];
    [super viewDidUnload];
}


-(void)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark DDAnnotationCoordinateDidChangeNotification

- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSMutableString * result = [[NSMutableString alloc] init];
    CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    
    [geocoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if (placemarks.count == 1)
                            {
                                CLPlacemark *place = [placemarks objectAtIndex:0];
                                
                                NSArray *FormattedAddressLines = [place.addressDictionary objectForKey:@"FormattedAddressLines"];
                                
                                for (NSObject * obj in FormattedAddressLines)
                                {
                                    [result appendString:[NSString stringWithFormat:@" %@",[obj description]]];
                                }
                                annotation.subtitle = result;
                            }
                            else
                            {
                                annotation.subtitle = @"Not found.";
                            }
                        });
     }];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (newState == MKAnnotationViewDragStateEnding && oldState == MKAnnotationViewDragStateDragging)
        
    {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSMutableString * result = [[NSMutableString alloc] init];
        
        [geocoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(),^
                            {
                                if (placemarks.count == 1)
                                {
                                    CLPlacemark *place = [placemarks objectAtIndex:0];
                                    
                                    NSArray *FormattedAddressLines = [place.addressDictionary objectForKey:@"FormattedAddressLines"];
                                    
                                    for (NSObject * obj in FormattedAddressLines)
                                    {
                                        [result appendString:[NSString stringWithFormat:@" %@",[obj description]]];
                                    }
                                    annotation.subtitle = result;
                                }
                                else
                                {
                                    annotation.subtitle = @"Not found.";
                                }
                            });
         }];
        
		NSLog(@"Anotation : %@", [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude]);
        latitude = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView)
    {
		draggablePinView.annotation = annotation;
	}
    else
    {
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
	}
	[draggablePinView setDraggable:YES];

	return draggablePinView;
}


#pragma mark Button Actions

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)btnCurrentLocation_Pressed:(id)sender
{
    [self.mapSearchBar resignFirstResponder];
    
    CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    MKCoordinateRegion extentsRegion = MKCoordinateRegionMakeWithDistance(location, 800, 800);
    
    [self.mapView setRegion:extentsRegion animated:YES];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CLLocationCoordinate2D theCoordinate;
    
    theCoordinate.latitude = location.latitude;
    theCoordinate.longitude = location.longitude;
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil];
	annotation.title = @"Drag to change location";
	
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSMutableString * result = [[NSMutableString alloc] init];
    
    CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];

    [geocoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if (placemarks.count == 1)
                            {
                                CLPlacemark *place = [placemarks objectAtIndex:0];
                                
                                NSArray *FormattedAddressLines = [place.addressDictionary objectForKey:@"FormattedAddressLines"];
                                
                                for (NSObject * obj in FormattedAddressLines)
                                {
                                    [result appendString:[NSString stringWithFormat:@" %@",[obj description]]];
                                }
                                annotation.subtitle = result;
                            }
                            else
                            {
                                annotation.subtitle = @"Not found.";
                            }
                        });
     }];
    
	[self.mapView addAnnotation:annotation];
}

-(void)showCustomUserLocation:(CLLocationCoordinate2D )newLocation addressString:(NSString *)address
{
    NSLog(@"Location found from Map: %f %f", newLocation.latitude, newLocation.longitude);
    
    MKCoordinateRegion extentsRegion = MKCoordinateRegionMakeWithDistance(newLocation, 800, 800);
    
    [self.mapView setRegion:extentsRegion animated:YES];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:newLocation addressDictionary:nil];
	annotation.title = @"Drag to change location";
	annotation.subtitle = address;
	
	[self.mapView addAnnotation:annotation];
    
    latitude = [NSString stringWithFormat:@"%f", newLocation.latitude];
    longitude = [NSString stringWithFormat:@"%f", newLocation.longitude];
}


- (IBAction)btnSaveLocationClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MapDrop"];
    
    if ([latitude isEqualToString:@""] || latitude == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[CommonFunctions getUserCurrentLocation].coordinate.latitude] forKey:@"MapDropLatitude"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[CommonFunctions getUserCurrentLocation].coordinate.longitude] forKey:@"MapDropLongitude"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"MapDropLatitude"];
        [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"MapDropLongitude"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - SearchBar Delegate Method


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mapSearchBar resignFirstResponder];
    
    
    [addressSuggestions getGoogleAddressSuggestion:self.mapSearchBar.text];
}


#pragma mark- GoogleAddressSuggestion Delegate Methods

-(void)didFindAddress:(NSArray *)addressArray
{
    googleAddressSuggestions = [[NSArray alloc] initWithArray:addressArray];
    
    if (googleAddressSuggestions.count > 0)
    {
        [self showGoogleAddressAPIResultsView];
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
    }
}

-(void)failToFindAddress
{
    [[ProcessingView instance] forceHideTintView];
    [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
}


#pragma mark - Show Search Result Suggestions View

-(void)showGoogleAddressAPIResultsView
{
    if (googleAddressSuggestions.count > 1)
    {
        GoogleAddressAPIResultViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoogleAddressAPIResultViewController"];

        controller.delegate = self;
        controller.googleAddressSuggestions = googleAddressSuggestions;
        
        [self.navigationController presentViewController:controller animated:NO completion:^(){}];
    }
    else if (googleAddressSuggestions.count != 0)
    {
        GoogleLocationAPIModel *model = [[GoogleLocationAPIModel alloc] init];
        
        model = [googleAddressSuggestions objectAtIndex:0];
        self.mapSearchBar.text = model.formattedAddress;
        
        CLLocationCoordinate2D newLocation = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
        
        [self showCustomUserLocation:newLocation addressString:model.formattedAddress];
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
    }
}


#pragma mark - Google Address Result View Delegate

-(void)userSelectNewAddress:(NSString *)address WithLat:(NSString *)userLatitude longitude:(NSString *)userLongitude
{
    self.mapSearchBar.text = address;
    
    CLLocationCoordinate2D newLocation = CLLocationCoordinate2DMake([userLatitude floatValue], [userLongitude floatValue]);
    
    [self showCustomUserLocation:newLocation addressString:address];
}


@end

