//
//  FilterViewController.m
//  WutzWhat
//
//  Created by Asad Ali on 01/22/13.
//
//
//

#import "FilterViewController.h"
#import "ChangeLocationViewController.h"

#define VIEW_EVENT_DATES_Y 203.0f
#define VIEW_BOTTOM_Y 344.0f

@interface FilterViewController ()
@end

@implementation FilterViewController

@synthesize delegate = _delegate;
@synthesize FilterBy=_FilterBy;
@synthesize Price=_Price;
@synthesize Open=_Open;
@synthesize txtEndDate=_txtEndDate;
@synthesize txtStartDate=_txtStartDate;
@synthesize StartDate=_StartDate,EndDate=_EndDate;
@synthesize location = _location;
@synthesize filterModel = _filterModel;
@synthesize categoryType = _categoryType;
@synthesize moduleType = _moduleType;
@synthesize savedFilter = _savedFilter;
@synthesize sectionType = _sectionType;

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
        self.scroll.frame=CGRectMake(0,44,self.scroll.frame.size.width,self.scroll.frame.size.height);
    }
    self.scroll.contentSize=CGSizeMake(320, 1020);
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImageView *titleIV ;
    
    if (self.sectionType == 3)
    {
        titleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_hotpicks.png"]];
    }
    else
    {
        titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        [titleIV setImage:[UIImage imageNamed:@"top_wutzwhat.png"]];
    }
    
    [[self navigationItem]setTitleView:titleIV];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
    [self btnLatestSortByClicked:nil];
    
    self.filterModel = [[FilterModel alloc] init];
    
    [self applyControlToDateField];
    
    if (self.categoryType != 3)
    {
        [self btnLatestSortByClicked:nil];
        self.btnEventDateSortBy.enabled = NO;
    }
    else
    {
        self.btnEventDateSortBy.enabled = YES;
        [self btnEventDateSortByClicked:nil];
    }
    
    switch (([DEFAULT_SORTING_VALUE intValue]+1)) {
                    case 1:
                        self.btnLatestSortBy.selected = TRUE;
                        self.btnDistanceSortBy.selected = FALSE;
                        self.btnEventDateSortBy.selected = FALSE;
                        break;
                    case 2:
                        self.btnDistanceSortBy.selected = TRUE;
                        self.btnLatestSortBy.selected = FALSE;
                        self.btnEventDateSortBy.selected = FALSE;
                        break;
                    case 3:
                        self.btnDistanceSortBy.selected = FALSE;
                        self.btnLatestSortBy.selected = FALSE;
                        self.btnEventDateSortBy.selected = TRUE;
                        break;
                    default:
                        self.btnDistanceSortBy.selected = FALSE;
                        self.btnLatestSortBy.selected = FALSE;
                        self.btnEventDateSortBy.selected = TRUE;
                        break;
            
        }

    
    PRICE_MAX = 4;
    PRICE_MIN = 1;
    
    [self createSliderControl];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MapDrop"])
    {
        location.latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLatitude"] doubleValue];
        location.longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLongitude"] doubleValue];
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [self getAddressFromCoordinates:aLocation];
    }
    
    [self applySavedFilterSettings];
    
    }


-(void)applyControlToDateField
{
    [self.txtEndDate setText:@"Date"];
    [self.txtStartDate setText:@"Date"];
    [self.txtEndDate apply];
    [self.txtStartDate apply];
    
    [self.txtEndDate setTextAlignment:NSTextAlignmentCenter];
    [self.txtStartDate setTextAlignment:NSTextAlignmentCenter];
    
    self.txtEndDate.delegate = self;
    self.txtStartDate.delegate = self;
}


-(void)createSliderControl
{
    [_slider removeFromSuperview];
    
    _slider=  [[RangeSlider alloc] initWithFrame:_sliderView.bounds];
    
    _slider.minimumValue = 1;
    _slider.maximumValue = 4;
    _slider.minimumRange = 0.5f;
    
    _slider.selectedMinimumValue = PRICE_MIN;
    _slider.selectedMaximumValue= PRICE_MAX;
    
    [_slider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [_sliderView addSubview:_slider];
    
    [self updateRangeLabel:_slider];
}

- (void)backBtnTapped:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FilterViewController"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateRangeLabel:(RangeSlider *)slider
{
    float minVal = slider.selectedMinimumValue;
    float maxVal = slider.selectedMaximumValue;
    
    UIColor *darkColor = [UIColor colorWithRed:77/255.f green:77/255.f blue:77/255.f alpha:1.0f];
    UIColor *lightColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f];
    
    
    if (minVal <= 1.4f)
    {
        slider.selectedMinimumValue = 1;
        [self.lblPrice1 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice2 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice3 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:darkColor forState:UIControlStateNormal];
    }
    else if(minVal > 1.4 && minVal <= 2.4)
    {
        slider.selectedMinimumValue = 2;
        [self.lblPrice1 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice2 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice3 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:darkColor forState:UIControlStateNormal];
    }
    else if(minVal > 2.4 && minVal <= 3.4)
    {
        slider.selectedMinimumValue = 3;
        [self.lblPrice1 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice2 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice3 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:darkColor forState:UIControlStateNormal];
    }
    else if(minVal > 3.4 && minVal <= 3.9)
    {
        slider.selectedMinimumValue = 3.7;
        [self.lblPrice1 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice2 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice3 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:darkColor forState:UIControlStateNormal];
    }
    
    
    if (maxVal <= 1.5f)
    {
        slider.selectedMaximumValue = 1.5;
        [self.lblPrice1 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice2 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice3 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:lightColor forState:UIControlStateNormal];
    }
    else if(maxVal > 1.5 && maxVal <= 2.5)
    {
        slider.selectedMaximumValue = 2.35;
        [self.lblPrice2 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice3 setTitleColor:lightColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:lightColor forState:UIControlStateNormal];
    }
    else if(maxVal > 2.5 && maxVal <= 3.4)
    {
        slider.selectedMaximumValue = 3.35;
        [self.lblPrice3 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:lightColor forState:UIControlStateNormal];
    }
    else if(maxVal > 3.4 && maxVal <= 3.7)
    {
        slider.selectedMaximumValue = 3.5;
        [self.lblPrice3 setTitleColor:darkColor forState:UIControlStateNormal];
        [self.lblPrice4 setTitleColor:lightColor forState:UIControlStateNormal];
    }
    else if(maxVal > 3.8 && maxVal <= 4.0)
    {
        slider.selectedMaximumValue = 4;
        [self.lblPrice4 setTitleColor:darkColor forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MapDrop"])
    {
        location.latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLatitude"] doubleValue];
        location.longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLongitude"] doubleValue];
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [self getAddressFromCoordinates:aLocation];
    } else {
        location.latitude = [CommonFunctions getUserCurrentLocation].coordinate.latitude;
        location.longitude = [CommonFunctions getUserCurrentLocation].coordinate.longitude;
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [self getAddressFromCoordinates:aLocation];
    }
}

- (IBAction)showCurrentLocation:(id)sender
{
}

-(void)getAddressFromCoordinates:(CLLocation *)aLocation
{
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
                                self.lblCurrentLocation.text = result;
                                location.latitude = aLocation.coordinate.latitude;
                                location.longitude = aLocation.coordinate.longitude;
                            }
                            else
                            {
                                [result appendString:@"Not found."];
                                self.lblCurrentLocation.text = result;
                            }
                        });
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(BOOL)validateStartEndDates:(NSString *)startDateString endDate:(NSString *)endDateString
{
    if (self.categoryType == 3)
    {
        return YES;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *startDate = [dateFormatter dateFromString:startDateString];
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    return startDate <= endDate;
}

-(BOOL)validatePrices:(float)minPrice maxPrice:(float)maxPrice
{
    
    return minPrice < maxPrice;
}

- (IBAction)btnDone:(id)sender
{
    
    PRICE_MAX = _slider.selectedMaximumValue;
    PRICE_MIN = _slider.selectedMinimumValue;
    
    _StartDate=_txtStartDate.text;
    _EndDate=_txtEndDate.text;
    
     _FilterBy = self.btnLatestSortBy.selected ? 1 : self.btnDistanceSortBy.selected ? 2 : 3;
    
    if(_FilterBy == 3) {
        if ([self validateStartEndDates:_StartDate endDate:_EndDate])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MSG_PRICE_FILTER delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
        self.filterModel = [[FilterModel alloc] init];
        self.filterModel.filterBy = _FilterBy;
        self.filterModel.priceMin = ceilf(_slider.selectedMinimumValue);
        self.filterModel.priceMax = floorf(_slider.selectedMaximumValue);
        self.filterModel.openNowOnly = self.btnOpenNowOnly.selected;
        self.filterModel.latitude = location.latitude;
        self.filterModel.longitude = location.longitude;
        self.filterModel.startDate = [NSString stringWithFormat:@"%@ 01:00:00",_StartDate];
        self.filterModel.endDate = [NSString stringWithFormat:@"%@ 23:59:59",_EndDate];
        self.filterModel.categoryType = self.categoryType;
        
        [self.delegate filterListUsingFilterSetting:self.filterModel];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FilterViewController"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnCancel_click:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FilterViewController"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnClearFilter_click:(id)sender
{
    self.btnOpenNowOnly.selected = NO;
    
    if (self.categoryType == 3)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.txtEndDate.text = [dateFormatter stringFromDate:[NSDate date]];
        self.txtStartDate.text = [dateFormatter stringFromDate:[NSDate date]];
        [self btnEventDateSortByClicked:nil];
    }
    else
    {
        [self btnLatestSortByClicked:nil];
        self.txtStartDate.text=@"Date";
        self.txtEndDate.text=@"Date";
    }
    
    PRICE_MAX = 4;
    PRICE_MIN = 1;
    
    [self createSliderControl];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MapDrop"])
    {
        location.latitude = [CommonFunctions getUserCurrentLocation].coordinate.latitude;
        location.longitude = [CommonFunctions getUserCurrentLocation].coordinate.longitude;
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [self getAddressFromCoordinates:aLocation];
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"MapDrop"];
    }
    
    if (self.delegate)
    {
        [self.delegate clearFilterSettings];
    }
}


-(void)btnSwitch_click:(id)sender
{
    [self.btnOpenNowOnly setSelected:!self.btnOpenNowOnly.selected];
}


- (void)viewDidUnload
{
    [self setScroll:nil];
    [self setTxtStartDate:nil];
    [self setTxtStartDate:nil];
    [self setTxtEndDate:nil];
    
    [self setBtnDone:nil];
    
    [self setSliderView:nil];
    [self setBtnLatestSortBy:nil];
    [self setBtnDistanceSortBy:nil];
    [self setBtnEventDateSortBy:nil];
    [self setLblPrice1:nil];
    [self setLblPrice2:nil];
    [self setLblPrice3:nil];
    [self setLblPrice4:nil];
    [self setBtnOpenNowOnly:nil];
    [self setLblCurrentLocation:nil];
    [self setViewEventDates:nil];
    [self setViewButtom:nil];
    [super viewDidUnload];
}


- (IBAction)btnLatestSortByClicked:(id)sender
{
    [self.btnLatestSortBy setSelected:YES];
    [self.btnEventDateSortBy setSelected:NO];
    [self.btnDistanceSortBy setSelected:NO];
    
    [self hideEventDates:YES];
    
    [self.txtEndDate setEnabled:NO];
    [self.txtStartDate setEnabled:NO];
    [self.imgtxtEndDate setAlpha:0.5];
    [self.imgtxtStartDate setAlpha:0.5];
    [self.imgtxtEndDate setHighlighted:YES];
    [self.imgtxtStartDate setHighlighted:YES];
    
}

- (IBAction)btnDistanceSortByClicked:(id)sender
{
    [self.btnLatestSortBy setSelected:NO];
    [self.btnEventDateSortBy setSelected:NO];
    [self.btnDistanceSortBy setSelected:YES];
    
    [self hideEventDates:YES];
    
    [self.txtEndDate setEnabled:NO];
    [self.txtStartDate setEnabled:NO];
    [self.imgtxtEndDate setAlpha:0.5];
    [self.imgtxtStartDate setAlpha:0.5];
    [self.imgtxtEndDate setHighlighted:YES];
    [self.imgtxtStartDate setHighlighted:YES];
    
}

- (IBAction)btnEventDateSortByClicked:(id)sender
{
    [self.btnLatestSortBy setSelected:NO];
    [self.btnEventDateSortBy setSelected:YES];
    [self.btnDistanceSortBy setSelected:NO];
    
    [self.txtEndDate setEnabled:YES];
    [self.txtStartDate setEnabled:YES];
    [self.imgtxtEndDate setAlpha:1];
    [self.imgtxtStartDate setAlpha:1];
    [self.imgtxtEndDate setHighlighted:NO];
    [self.imgtxtStartDate setHighlighted:NO];
    
    [self hideEventDates:NO];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.txtEndDate.text = [dateFormatter stringFromDate:[NSDate date]];
    self.txtStartDate.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (IBAction)btnChangePinLocationClicked:(id)sender
{
    ChangeLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeLocationViewController"];
    [vc setType:NSStringFromClass([self class])];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)hideEventDates:(BOOL)hide
{
    self.viewEventDates.hidden = hide;
    
    if (self.viewEventDates.hidden)
    {
        self.viewButtom.frame = CGRectMake(0, VIEW_EVENT_DATES_Y, 320, self.viewButtom.frame.size.height);
        
        if (self.scroll.contentSize.height > 1100)
        {
            self.scroll.contentSize = CGSizeMake(320, self.scroll.contentSize.height - self.viewEventDates.frame.size.height + 50);
        }
    }
    else
    {
        self.viewButtom.frame = CGRectMake(0, VIEW_BOTTOM_Y, 320, self.viewButtom.frame.size.height);
        self.viewEventDates.frame = CGRectMake(0, VIEW_EVENT_DATES_Y, 320, self.viewEventDates.frame.size.height);
        if (self.scroll.contentSize.height < 1100)
        {
            self.scroll.contentSize = CGSizeMake(320, self.scroll.contentSize.height + self.viewEventDates.frame.size.height);
        }
    }
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}


#pragma mark- TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual: self.txtStartDate] || [textField isEqual: self.txtEndDate])
    {
        if ([textField.text isEqualToString:@"Date"])
        {
            textField.text = @"";
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual: self.txtStartDate] || [textField isEqual: self.txtEndDate])
    {
        if ([textField.text isEqualToString:@"Date"])
        {
            textField.text = @"";
        }
    }
}

//New Price Slider changes
#pragma mark- Price Slider Events

- (IBAction)btnPrice1Clicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    float xAxis = btn.center.x - self.sliderView.frame.origin.x;
    [self.slider changeSliderValuesTo:xAxis];
}

- (IBAction)btnPrice2Clicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    float xAxis = btn.center.x - self.sliderView.frame.origin.x;
    [self.slider changeSliderValuesTo:xAxis];
}

- (IBAction)btnPrice3Clicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    float xAxis = btn.center.x - self.sliderView.frame.origin.x;
    [self.slider changeSliderValuesTo:xAxis];
}

- (IBAction)btnPrice4Clicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    float xAxis = btn.center.x - self.sliderView.frame.origin.x;
    [self.slider changeSliderValuesTo:xAxis];
}


#pragma mark- Save Filter Settings Methods

-(void)applySavedFilterSettings
{
    FilterModel *model = self.savedFilter;
    
    if (model != nil)
    {
        model.filterBy == 1 ? [self btnLatestSortByClicked:nil] : model.filterBy == 2 ? [self btnDistanceSortByClicked:nil] : [self btnEventDateSortByClicked:nil];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.txtEndDate.text = [dateFormatter stringFromDate:[NSDate date]];
        self.txtStartDate.text = [dateFormatter stringFromDate:[NSDate date]];
        self.btnOpenNowOnly.selected = model.openNowOnly;
        
        PRICE_MAX = model.priceMax;
        PRICE_MIN = model.priceMin;
        
        [self createSliderControl];
        
        location.latitude = model.latitude;
        location.longitude = model.longitude;
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        
        [self getAddressFromCoordinates:aLocation];
    }
}

@end