//
//  MapViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 4/17/13.
//
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize categoryType = _categoryType, forProfile = _forProfile,current,refresh;

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
    
    if(OS_VERSION>=7)
    {
        
        _mapView.frame=CGRectMake(0,44,320,530);
        current.frame=CGRectMake(0,49,49,49);
        refresh.frame=CGRectMake(271,49,49,49);
        
    }
    [self setupTopBarCategoryImage];
    [self setupNavigationBarStyle];
    
    [self btnRefresh_Pressed:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CurrentLocations = !_forProfile;
    [self getUserLocation];
    
    if(!_forProfile)
        [self btnCurrentLocation_Pressed:nil];
    else
        [self btnRefresh_Pressed:nil];
}


-(void)setupTopBarCategoryImage
{
    NSString *imageName = @"top_wutzwhat.png";
    
    if(self.postTypeID == WUTZWHAT_ID_FOR_REVIEW)
    {
        imageName = @"top_wutzwhat.png";        
    }
    else if(self.postTypeID == HOTPICKS_ID_FOR_REVIEW)
    {
        imageName = @"top_hotpicks.png";
    }    
    else if(self.postTypeID == PERK_ID_FOR_REVIEW)
    {
        imageName = @"top_perks.png";
    }
    else if(self.postTypeID == MYFINDS_ID_FOR_REVIEW)
    {
        imageName = @"top_myfinds.png";        
    }
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:imageName]];
    [[self navigationItem]setTitleView:titleIV];
}


-(void)setupNavigationBarStyle
{
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-6, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    [v addSubview:backBtn];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    if (self.isSingleMapView)
    {
        UIImage *optionButtonImage = [UIImage imageNamed:@"top_directions.png"] ;
        UIImage *optionButtonImagePressed = [UIImage imageNamed:@"top_directions_c.png"];
        
        UIButton *optionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, optionButtonImage.size.width, optionButtonImage.size.height)];
        [optionBtn addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtn setImage:optionButtonImage forState:UIControlStateNormal];
        [optionBtn setImage:optionButtonImagePressed forState:UIControlStateHighlighted];
        
        UIBarButtonItem *optionBtnItem = [[UIBarButtonItem alloc] initWithCustomView:optionBtn];
        [[self navigationItem]setRightBarButtonItem:optionBtnItem];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Button Actions 


-(IBAction)btnRefresh_Pressed:(id)sender
{
    [self addAnnotationToMapView];
    
    CurrentLocations=NO;
    
    [self getUserLocation];
}


- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)btnCurrentLocation_Pressed:(id)sender
{
    CurrentLocations = YES;
    
    [self getUserLocation];
}

-(void)optionsButtonTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Maps",@"Copy the Address", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Location Methods

-(void)addAnnotationToMapView
{
    [self removeExistingPins];
        
    for (int i = 0; i < self.modelArray.count; i ++)
    {
        WutzWhatModel *model = [self.modelArray objectAtIndex:i];
        
        CLLocationDegrees latitude = [model.latitude doubleValue];
        CLLocationDegrees longitude = [model.longitude doubleValue];
        CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        self.mapAnnotation = [Annotation annotationWithCoordinate:currentLocation.coordinate];
        
        self.mapAnnotation.title = model.title;
        self.mapAnnotation.accessibilityHint = [NSString stringWithFormat:@"%d", i];
        self.mapAnnotation.subtitle = model.info;
        
        if (nil != self.mapAnnotation)
        {
            [self.mapView addAnnotation:self.mapAnnotation];
            self.mapAnnotation = nil;
        }
        
       if(i == self.modelArray.count / 2)
            [self setCurrentLocation:currentLocation];
    }
    
    
}

-(void)removeExistingPins
{
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    
    for (id annotation in self.mapView.annotations)
    {
        if (annotation != self.mapView.userLocation)
        {
            [toRemove addObject:annotation];
        }
    }
    
    if (toRemove.count > 0)
    {
        [self.mapView removeAnnotations:toRemove];
    }
}

- (void)setCurrentLocation:(CLLocation *)location
{
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    
    region.center = location.coordinate;
    
    region.span.longitudeDelta = 0.05f;
    region.span.latitudeDelta  = 0.05f;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}


#pragma mark - Map Kit Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    MKAnnotationView *view = nil;
    
    if (annotation != mapView.userLocation)
    {        
        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        
        if (nil == view)
        {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        }

        UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        myDetailButton.frame = CGRectMake(0, 0, 32,31);
        
        myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        Annotation *pinDrop = (Annotation *)annotation;
        
        myDetailButton.accessibilityHint = pinDrop.accessibilityHint;
        
        [myDetailButton addTarget:self action:@selector(onMapVenueSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        view.rightCalloutAccessoryView = myDetailButton;
        
        if (self.postTypeID == PERK_ID_FOR_REVIEW)
        {
            view.image = [UIImage imageNamed:@"pin_perk.png"];
        }
        else
        {
            view.image = [UIImage imageNamed:@"pin_wutzwhat.png"];            
        }
        
        [view setCanShowCallout:YES];
    }
    else
    {
        if(!OS_VERSION>=7)
        {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.userLocation.coordinate.latitude
                                                          longitude:mapView.userLocation.coordinate.longitude];
        [self setCurrentLocation:location];
        }
    }
    
    return view;
}

#pragma mark - Action Sheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WutzWhatModel *model = [self.modelArray objectAtIndex:0];
    
    if (buttonIndex == 0)
    {
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            CLLocationCoordinate2D coordinate =
            CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:model.address];
            [mapItem openInMapsWithLaunchOptions:nil];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com?ll=%@,%@", model.latitude, model.longitude]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else if (buttonIndex == 1)
    {
        [CommonFunctions copyTextToClipboard:model.address];
    }
}


#pragma mark - For Detail View

-(void)onMapVenueSelect:(id)sender
{
    if (self.isSingleMapView)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
        
    UIButton *btn = (UIButton*)sender;
    int index = [btn.accessibilityHint intValue];
    
    id object = [self.modelArray objectAtIndex:index];
    
    if ([object isKindOfClass:[WutzWhatModel class]])
    {
        WutzWhatModel *model = (WutzWhatModel*)object;
        
        WutzWhatProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatProductDetailViewController"];

        [controller setMenu:model];
        [controller setCategoryType:self.categoryType];
        [controller setSectionType:1];
        
        [self.navigationController pushViewController:controller animated:YES];
        return;
        
    }
    else if ([object isKindOfClass:[TalksModel class]])
    {
        TalksModel *talkObject = (TalksModel*)object;
        
        TalksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TalksProductDetailViewController"];

        [controller setMenu:talkObject];
        [controller setType:self.categoryType];
        
        [self.navigationController pushViewController:controller animated:YES];
        return;
        
    }
    else if ([object isKindOfClass:[PerksModel class]])
    {
        PerksModel *model =(PerksModel*)object;
        
        PerksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksProductDetailViewController"];

        [controller setMenu:model];
        [controller setCategoryType:model.categoryType];
        
        [self.navigationController pushViewController:controller animated:YES];
        return;        
    }
}


#pragma mark- CoreLocation Delegate Methods

-(void)getUserLocation
{
    [self.mapView setShowsUserLocation:YES];
    
    if (CurrentLocations==YES)
    {
        CLLocationCoordinate2D _coordinate = [CommonFunctions getUserCurrentLocation].coordinate;
        
        MKCoordinateRegion extentsRegion = MKCoordinateRegionMakeWithDistance(_coordinate, 5000, 5000);
        
        [self.mapView setRegion:extentsRegion animated:YES];
    }
    else
    {
        CLLocationDegrees latitude = [CommonFunctions getUserCurrentLocation].coordinate.latitude;
        CLLocationDegrees longitude = [CommonFunctions getUserCurrentLocation].coordinate.longitude;
        
        self._lat  = [[NSNumber numberWithDouble:latitude] stringValue];
        self._long = [[NSNumber numberWithDouble:longitude] stringValue];
    }
}


@end


