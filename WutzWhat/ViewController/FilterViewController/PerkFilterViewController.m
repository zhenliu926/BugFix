//
//  PerkFilterViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 2/1/13.
//
//

#import "PerkFilterViewController.h"
#import "ChangeLocationViewController.h"

#define VIEW_EVENT_DATES_Y 265.0f
#define VIEW_BOTTOM_Y 410.0f

@interface PerkFilterViewController ()

@end

@implementation PerkFilterViewController

@synthesize delegate = _delegate;
@synthesize FilterBy=_FilterBy;
@synthesize Price=_Price;
@synthesize txtEndDate=_txtEndDate;
@synthesize txtStartDate=_txtStartDate;
@synthesize StartDate=_StartDate,EndDate=_EndDate;
@synthesize location = _location;
@synthesize filterModel = _filterModel;
@synthesize categoryType = _categoryType;
@synthesize moduleType = _moduleType;
@synthesize savedFilter = _savedFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)setDefaultValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    _btnDefault.selected = true;
    
    [self setFilterBy:[defaults integerForKey:@"_filterBy"]];
}

-(void)saveDefaultValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setInteger:_FilterBy forKey:@"_filterBy"];
    
    [defaults synchronize];
}

- (void)clearAllFields
{
    [self btnLatestSortByClicked:nil];
    self.btnOpenNowOnly.selected = NO;
    
    self.txtStartDate.text=@"";
    self.txtEndDate.text=@"";
    self.txtMaxPrice.text = @"Price";
    self.txtMinPrice.text = @"Price";
    self.lblCurrentLocation.text = @"(Current Location is set as Default)";
    
    if (self.delegate)
    {
        [self.delegate clearFilterSettings];
    }
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
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_perks.png"]];
    
    [[self navigationItem]setTitleView:titleIV];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"_filterBy"] != nil)
        [self setDefaultValues];
    
    if (self.categoryType != 3)
    {
        [self btnLatestSortByClicked:nil];
        self.btnEventDateSortBy.enabled = NO;
    }
    else
    {
        [self btnEventDateSortByClicked:nil];
        self.btnEventDateSortBy.enabled = YES;
    }
    
    self.filterModel = [[FilterModel alloc] init];
    
    [self applyControlToDateField];
    
    PRICE_MAX = 3000;
    PRICE_MIN = 1;
    
    [self applySavedFilterSettings];
    
    switch (_FilterBy) {
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
    }
    
}


-(void)applyControlToDateField
{
    [self.txtEndDate apply];
    [self.txtStartDate apply];
    [self.txtEndDate setText:@"Date"];
    [self.txtStartDate setText:@"Date"];
    self.txtEndDate.delegate = self;
    self.txtStartDate.delegate = self;
    [self.txtEndDate setTextAlignment:NSTextAlignmentCenter];
    [self.txtStartDate setTextAlignment:NSTextAlignmentCenter];
    
    [self.txtMaxPrice apply];
    [self.txtMinPrice apply];
    [self.txtMaxPrice setText:@"Price"];
    [self.txtMinPrice setText:@"Price"];
    [self.txtMaxPrice setTextAlignment:NSTextAlignmentCenter];
    [self.txtMinPrice setTextAlignment:NSTextAlignmentCenter];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkForSaveLocation];
}

-(void)checkForSaveLocation
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MapDrop"])
    {
        location.latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLatitude"] doubleValue];
        location.longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLongitude"] doubleValue];
    }
    else
    {
        location.latitude = [CommonFunctions getUserCurrentLocation].coordinate.latitude;
        location.longitude = [CommonFunctions getUserCurrentLocation].coordinate.longitude;
    }
    
    CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [self getAddressFromCoordinates:aLocation];
}

- (void)backBtnTapped:(id)sender
{
    if(self.btnDefault.selected){
        [self saveDefaultValues];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"defaultFilterView"];
        [defaults synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
                                
                                //NSLog(@"addressDictionary %@", place.addressDictionary);
                                
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

-(int)getPriceFromTextFieldString:(NSString *)priceString
{
    priceString = [priceString stringByReplacingOccurrencesOfString:@"$ " withString:@""];
    
    return [priceString intValue];
}

- (IBAction)btnDone:(id)sender
{
    PRICE_MAX = [self getPriceFromTextFieldString:self.txtMaxPrice.text];
    PRICE_MIN = [self getPriceFromTextFieldString:self.txtMinPrice.text];
    
    _StartDate=_txtStartDate.text;
    _EndDate=_txtEndDate.text;
    
    if([self.txtMaxPrice.text isEqualToString:@"Price"])
        PRICE_MAX = 3000;
    
    if(([self.txtMinPrice.text isEqualToString:@"Price"]))
        PRICE_MIN = 1;
    
    _FilterBy = self.btnLatestSortBy.selected ? 1 : self.btnDistanceSortBy.selected ? 2 : 3;
    
    if(_FilterBy == 2)
    {
        if ([self validateStartEndDates:_StartDate endDate:_EndDate] && [self validatePrices:PRICE_MIN maxPrice:PRICE_MAX])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MSG_PRICE_FILTER delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    
    self.filterModel = [[FilterModel alloc] init];
    self.filterModel.filterBy = _FilterBy;
    self.filterModel.priceMin = PRICE_MIN;
    self.filterModel.priceMax = PRICE_MAX;
    self.filterModel.openNowOnly = self.btnOpenNowOnly.selected;
    self.filterModel.latitude = location.latitude;
    self.filterModel.longitude = location.longitude;
    self.filterModel.startDate = [NSString stringWithFormat:@"%@ 01:00:00",_StartDate];
    self.filterModel.endDate = [NSString stringWithFormat:@"%@ 23:59:59",_EndDate];
    self.filterModel.categoryType = self.categoryType;
    
    [self.delegate filterListUsingFilterSetting:self.filterModel];
    
    if(self.btnDefault.selected){
        [self saveDefaultValues];
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:nil forKey:@"_filterBy"];
        [defaults synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)btnCancel_click:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self btnCancel_click:nil];
}


- (IBAction)btnClearFilter_click:(id)sender
{
    [self clearAllFields];
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
    [self setBtnOpenNowOnly:nil];
    [self setLblCurrentLocation:nil];
    [self setViewEventDates:nil];
    [self setViewButtom:nil];
    [self setBtnDefault:nil];
    [super viewDidUnload];
}

- (IBAction)btnDefaultClick:(id)sender {
    self.btnDefault.selected = !self.btnDefault.selected;
}

- (IBAction)btnLatestSortByClicked:(id)sender
{
    [self.btnLatestSortBy setSelected:YES];
    [self.btnEventDateSortBy setSelected:NO];
    [self.btnDistanceSortBy setSelected:NO];
    
    [self.txtEndDate setEnabled:NO];
    [self.txtStartDate setEnabled:NO];
    [self.imgtxtEndDate setAlpha:0.5];
    [self.imgtxtStartDate setAlpha:0.5];
    [self.imgtxtEndDate setHighlighted:YES];
    [self.imgtxtStartDate setHighlighted:YES];
    
    [self hideEventDates:YES];
}

- (IBAction)btnDistanceSortByClicked:(id)sender
{
    [self.btnLatestSortBy setSelected:NO];
    [self.btnEventDateSortBy setSelected:NO];
    [self.btnDistanceSortBy setSelected:YES];
    
    [self.txtEndDate setEnabled:NO];
    [self.txtStartDate setEnabled:NO];
    [self.imgtxtEndDate setAlpha:0.5];
    [self.imgtxtStartDate setAlpha:0.5];
    [self.imgtxtEndDate setHighlighted:YES];
    [self.imgtxtStartDate setHighlighted:YES];
    
    [self hideEventDates:YES];
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

#pragma mark- Text Field Delegate Methods

#pragma mark- TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtStartDate || textField == self.txtEndDate)
    {
        if ([textField.text isEqualToString:@"Date"])
        {
            textField.text = @"";
        }
    }
    return YES;
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
        
        self.txtMaxPrice.text = [NSString stringWithFormat:@"$ %d", PRICE_MAX];
        self.txtMinPrice.text = [NSString stringWithFormat:@"$ %d", PRICE_MIN];
        
        location.latitude = model.latitude;
        location.longitude = model.longitude;
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        
        [self getAddressFromCoordinates:aLocation];
    }
}


@end
