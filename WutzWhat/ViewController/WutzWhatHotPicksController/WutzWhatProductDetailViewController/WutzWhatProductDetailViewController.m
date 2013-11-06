//
//  WutzWhatProductDetailViewController.m
//  WutzWhat
//
//  Created by Zeeshan Haider on 11/18/12.
//
//

#import "WutzWhatProductDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "ProcessingView.h"
#import "NearbyPlacesRequestResult.h"
#import "JSON.h"
#import "RelatedPerksViewController.h"
#import "GPPSignIn.h"
#import "GTLPlusConstants.h"
#import "GTMOAuth2Authentication.h"
#import "FavouritesCache.h"
#import "Util.h"

@interface WutzWhatProductDetailViewController ()
{
    NSString * callno;
    NSString * strWebsite;
    NSString * taxiPhoneNo;
    NSString *strAddress;
    NSString *latLabel;
    NSString *longLabel;
    
    CLLocation * userLocation;
    CLLocation *productLocation;
    CLLocationDistance meters;
}

@end

@implementation WutzWhatProductDetailViewController

static int indexOfCheckIn = 0;

@synthesize delegate = _delegate;
@synthesize mainScroll;
@synthesize imgMainProductImage;
@synthesize imgTumbnailProductImage;
@synthesize menu;
@synthesize categoryType;
@synthesize rows, imageForSharing;
@synthesize eventStore = _eventStore,defaultCalendar;
@synthesize viewCall, viewEvents, viewLongDesc, viewMap, viewOtherLocation, viewPrice, viewTags, viewTime, viewTopReviews, viewWebSite, viewBottom, imgLongDescLine, viewPerksBanner;
@synthesize sender = _sender;
@synthesize shouldDisableMerchantBanner, strWebsite;
@synthesize moviePlayer = _moviePlayer;
@synthesize imagesURLModelArray = _imagesURLModelArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)retreivedVideoImage:(NSNotification *)event
{
    imageUrlsForPhotoGallery[0] = [[MWPhoto alloc] initWithImage:[event.userInfo objectForKey:@"image"]];
    ((MWPhoto *)imageUrlsForPhotoGallery[0]).isVideo = true;
    ((MWPhoto *)imageUrlsForPhotoGallery[0]).videoURL = [NSURL URLWithString:[event.userInfo objectForKey:@"url"]];
    
    imgMainProductImage.images = imageUrlsForPhotoGallery;
    ((UIImageView *)imgMainProductImage.viewControllers[0]).image = ((MWPhoto *)imageUrlsForPhotoGallery[0]).underlyingImage;
     ((UIImageView *)imgMainProductImage.viewControllers[0]).image = ((MWPhoto *)imageUrlsForPhotoGallery[0]).underlyingImage;
    
    [imgMainProductImage layoutSubviews];
    
    [imgMainProductImage addImageView:[[UIImageView alloc] initWithImage:[event.userInfo objectForKey:@"image"]] toImageScrollView:imgMainProductImage.imageScrollView withPage:0 removingSubview:imgMainProductImage.viewControllers[0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retreivedVideoImage:) name:@"retreivedVideoImage" object:nil];
    
    [self setUpNavigationBar];

    if(OS_VERSION>=7)
    {
        mainScroll.frame=CGRectMake(0,44,320,530);
       // imgMainProductImage.frame=CGRectMake(imgMainProductImage.frame.origin.x,imgMainProductImage.frame.origin.y+40,imgMainProductImage.frame.size.width,imgMainProductImage.frame.size.height);
        
        //self.lblTitle.textColor=[UIColor colorWithRed:26.0/255  green:26.0/255  blue:26.0/255  alpha:1.0];
        
        self.lblTitle.textColor=[UIColor blackColor];
    }
    
    
    
    imageUrlsForPhotoGallery = [[NSMutableArray alloc] init];
    self.imageForSharing = [[UIImage alloc] init];
    self.imageForSharing = [UIImage imageNamed:@"default_sharing_photo.png"];
    //for Blank Views

    visibleViews = [NSMutableArray arrayWithObjects:viewPerksBanner, self.viewLongDesc, self.viewPrice, self.viewMap, self.viewCall, self.viewWebSite, self.viewOtherLocation, self.viewTime, self.viewEvents, self.viewTopReviews, self.viewTags, self.viewBottom, nil];
    
    self.rows= [NSMutableArray arrayWithObjects:menu, nil];
    self.mainScroll.contentSize=CGSizeMake(self.view.frame.size.width, 1408);
    self.imagesURLModelArray = [[NSArray alloc] init];
    
    [CommonFunctions addShadowOnTopOfView:self.imgInfoBar];
    
    [self maintainPreviousValues];
    
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        NSDictionary *cachedResponse = [FavouritesCache getProductDetailsByProductID:self.menu.postId andIsPerk:FALSE];
        if (cachedResponse == nil)
        {
            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
        }
        else
        {
            [self dataFetchedSuccessfully:cachedResponse forUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_HOTPICKS_DETAIL]];
        }
    }
    else
    {
        [[ProcessingView instance] hideTintView];
        [self calServiceWithURL:GET_WUTZWHAT_HOTPICKS_DETAIL];
        self.mainScroll.scrollEnabled = NO;
        self.mainScroll.bounces = self.mainScroll.bouncesZoom = false;
    }
    self.lblDays = [UILabel new];
    self.lblDays.textAlignment = NSTextAlignmentLeft;
    self.lblDays.numberOfLines = 0;
    self.lblDays.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblDays.font = [UIFont fontWithName:@"HelveticaNeue" size: 13.0];
    self.lblDays.backgroundColor = [UIColor clearColor];
    self.lblDays.text = [NSString stringWithFormat:@"Monday\nTuesday\nWednesday\nThursday\nFriday\nSaturday\nSunday\n"];
    [self.viewTime addSubview:self.lblDays];
   // self.navigationController.navigationBarHidden = NO;
   // [self.navigationController.navigationBar setAlpha:1.0f];
}

-(void)getCurrentLocation
{
    [self checkInOnFacebookUsingDistance];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    
    if(OS_VERSION>=7)
    {
       [self setUpNavigationBar];
    }
    oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(relatedPerks)];
    
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    [[self img_Perkbanner] addGestureRecognizer:oneFingerTwoTaps];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self img_Perkbanner] removeGestureRecognizer:oneFingerTwoTaps];
    oneFingerTwoTaps = nil;
    
    [Flurry endTimedEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_wutzwhat"] withParameters:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"retreivedVideoImage" object:nil];
}


#pragma mark -
#pragma mark Navigation Bar
#pragma mark -

-(void)setUpNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
    
    if(OS_VERSION>=7)
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"];
    
//    UIImage *mapButton = [UIImage imageNamed:@"top_map.png"] ;
//    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_map_c.png"];
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(-6, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
//    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mapBtn setFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
//    [mapBtn addTarget:self action:@selector(btnMap_Pressed:) forControlEvents:UIControlEventTouchUpInside];
//    [mapBtn setImage:mapButton forState:UIControlStateNormal];
//    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    
    [v addSubview:backBtn];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
//    UIBarButtonItem *donebtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
//    [[self navigationItem]setRightBarButtonItem:donebtnItem ];
    
    UIImageView *titleIV;
    
    if (self.sectionType == 3)
    {
        titleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_hotpicks.png"]];
    }
    else
    {
        titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        [titleIV setImage:[UIImage imageNamed:@"top_wutzwhat.png"]];
    }

    [[self navigationItem] setTitleView:titleIV];
}

#pragma mark -
#pragma mark Previous Values
#pragma mark -

-(void)maintainPreviousValues
{
    self.imgIsFavourite.hidden = !self.menu.isFavourited;
    self.imgIsHotPick.hidden = !self.menu.isHotpick;
    self.imgIsPerk.hidden = !self.menu.perkCount > 0;
//    self.lblTitle.text = self.menu.title;
    self.lblShortDescription.text = self.menu.info;
    self.lblLoveCount.text = [NSString stringWithFormat:@"%d", self.menu.likeCount];
    int price = menu.price ;
    self.lblPrice.text = price == 1 ? @"$" : price == 2 ? @"$$" : price == 3 ? @"$$$" : @"$$$$";
    
    if (self.menu.distance)
    {
        [self.lblDistance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:self.menu.distance]];
    }
    else
    {
        [self.lblDistance setText:[NSString stringWithFormat:@"0 km"]];
    }
    
    if (menu.isLiked) {
        self.btn_likeit.selected = YES;
    }
    if (!menu.isLiked) {
        self.btn_likeit.selected = NO;
    }
    
    if (self.categoryType == 1)
    {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_1.png"]];
    }
    else if (self.categoryType == 2)
    {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_2.png"]];
    }
    else if (self.categoryType == 3)
    {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_3.png"]];
    }
    else if (self.categoryType == 4)
    {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_4.png"]];
    }
    else if (self.categoryType == 5)
    {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_5.png"]];
    }
    else if (self.categoryType == 6)
    {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_6.png"]];
    }
    
    [[imgTumbnailProductImage layer] setCornerRadius:5];
    imgTumbnailProductImage.ClipsToBounds= YES;
    
    if (![menu.thumbnailURL isEqualToString:@""] )
    {
        [imgTumbnailProductImage setImageWithURLWithOutPlaceHolder:[NSURL URLWithString:menu.thumbnailURL]];
    }
    else
    {
        [imgTumbnailProductImage setImage:[UIImage imageNamed:@"list_thumbnail.png"]];
    }
}


#pragma mark- Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Button Actions

-(void)relatedPerks
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    if (!self.shouldDisableMerchantBanner)
    {
        RelatedPerksViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RelatedPerksViewController"];
        
        controller.perkID = self.menu.postId;
        controller.categoryID = self.categoryType;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        NSArray *controllerArray = self.navigationController.viewControllers;
        
        RelatedPerksViewController *controller = (RelatedPerksViewController *)[controllerArray objectAtIndex:controllerArray.count - 2];
        
        [self.navigationController popToViewController:controller animated:YES];
    }    
}


- (IBAction)btnShare_clicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    if(isGuest)
    {
        
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Share To Google+",@"Email To Friends",@"Message to Friends", nil];
        actionSheet.tag=3;
        [actionSheet showInView:self.view];
    }
}


- (IBAction)btnEventDate_Pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Event Date" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add To Calender",@"Copy", nil];
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
}


- (IBAction)btnOtherLocation_Pressed:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    WutzWhatOtherLocation *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatOtherLocation"];
    [vc setPostid:menu.postId];
    [vc setPage:@"1"];
    vc.postTypeID= self.sectionType;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)btnReviews_clicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    ReviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [vc setPostid:menu.postId];
    [vc setPage:@"1"];
    vc.postTypeID= self.sectionType;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) backBtnTapped:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnWebsite_Pressed:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strWebsite]]];
    webBrowser.delegate = self;
    webBrowser.postTypeID= WUTZWHAT_ID_FOR_REVIEW;
    [webBrowser setFixedTitleBarText:menu.title];
    webBrowser.mode = TSMiniWebBrowserModeNavigation;
    
    webBrowser.barStyle = UIBarStyleBlack;
    
    if (webBrowser.mode == TSMiniWebBrowserModeModal)
    {
        webBrowser.modalDismissButtonTitle = @"Home";
        [self presentViewController:webBrowser animated:YES completion:^(){}];
        
    }
    else if(webBrowser.mode == TSMiniWebBrowserModeNavigation)
    {
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
}

-(IBAction)btnMap_Pressed:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    NSArray *modelArray = [[NSArray alloc] initWithObjects:menu, nil];
    
    controller.forProfile = true;
    controller.modelArray = modelArray;
    controller.isSingleMapView = YES;
    [controller setPostTypeID:self.sectionType];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnPhoneNo_Pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Phone Number" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call",@"Copy",@"Add To Contact", nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
}

- (IBAction)btnAddtoCalendar_clicked:(id)sender
{
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    if(isGuest)
    {
        
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    
    else
    {
        self.sender = [[CommonFunctions alloc] initWithParent:self];
        
        NSDictionary *wutzwhat_details = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.menu.postId, @"post_id",
                                          
                                          [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                                         
                                          nil];
        
        [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_calendar"] withParameters:wutzwhat_details];
        
        [self.sender addEventToCalendar:self.menu.title description:self.menu.description startDate:self.menu.eventStartDate endDate:self.menu.eventEndDate link: self.strWebsite location: self.addressTaxiLabel.text];
    }
    
}



- (IBAction)btnCheckin_clicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    if([CommonFunctions isGuestUser])
    {
        
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Check In" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Check In",@"Check In on Facebook",@"Check In on Twitter", nil];
        
        actionSheet.tag=4;
        [actionSheet showInView:self.view];
    }
}

- (IBAction)btnFeedback_clicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    if([CommonFunctions isGuestUser])
    {
        
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    
    AddCommentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCommentViewController"];
    [vc setPostid:menu.postId];
    vc.postTypeID= self.sectionType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFavourite_clecked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:menu.postId forKey:@"postid"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *now = [format stringFromDate:[NSDate date]];
    [params setValue:now forKey:@"res_time"];
    
    if(isGuest)
    {
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    else
    {
    }
    
    if (!self.menu.isFavourited)
    {
        [params setValue:@"1" forKey:@"favourite"];
        
        NSDictionary *love_analytics =
        [NSDictionary dictionaryWithObjectsAndKeys:
         menu.postId , @"post_id",
         
         [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token"
         ,
         nil];
        
        [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_favourite"] withParameters:love_analytics];
        
    }
    else
    {
        [params setValue:@"0" forKey:@"favourite"];
    }
    
    [[ProcessingView instance] forceShowTintView];
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    
}

- (IBAction)btnLoveit_clecked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    if(isGuest)
    {
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:menu.postId forKey:@"postid"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [[ProcessingView instance] forceShowTintView];
    NSString *now = [format stringFromDate:[NSDate date]];
    [params setValue:now forKey:@"res_time"];
    if (!self.menu.isLiked)
    {
        [params setValue:@"1" forKey:@"like"];
        
        NSDictionary *love_analytics =
        [NSDictionary dictionaryWithObjectsAndKeys:
         menu.postId , @"post_id",
         
         [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token"
         ,
         nil];
        
        [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_love"] withParameters:love_analytics];
        
    }else
    {
        [params setValue:@"0" forKey:@"like"];
    }
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}



#pragma mark- Actionsheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(int)buttonIndex {
    
    if (actionSheet.tag==2) {
        if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
        switch (buttonIndex) {
            case 0:
            {
                [CommonFunctions makePromptCall:callno];
                break;
            }
            case 1:
            {
                [CommonFunctions copyTextToClipboard:callno];
                break;
            }
            case 2:
            {
                [CommonFunctions addNewContactWithTitle: menu.title andAddress: strAddress andPhoneNumber: callno andThumbnailImage:imgTumbnailProductImage.image];
                break;
                
            }
                
        }
    }
	if (actionSheet.tag==1) {
        if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
        switch (buttonIndex)
        {
            case 0:
            {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender addEventToCalendar:menu.title description:menu.description startDate:self.menu.eventStartDate endDate:self.menu.eventEndDate link: self.strWebsite location : @""];
            }
                break;
            case 1:
            {
                [CommonFunctions copyTextToClipboard:menu.title];
                
            }
                break;
        }
    }
    if (actionSheet.tag==3) {
        if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
        switch (buttonIndex) {
            case 0:
            {
                // TODO
                // This is temp for the soft launch
         //       [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
         //       return;
                
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnFaceBookWithTitle:menu.title andInfo:menu.info andThumbnailImage:self.imageForSharing andWebsiteUrl:self.strWebsite];
                
                /////////////*********************FLURRY ****************//////////////////////////////////////////////////////
                NSDictionary *share_analytics =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 menu.postId , @"post_id",
                 
                 [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                 @"facebook",@"media",
                 nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_share"] withParameters:share_analytics];
                
                [self callWutzwhatShareFeedbackWithShareType:@"facebook"];
                
            }
                break;
            case 1:
            {
                // TODO
                // This is temp for the soft launch
            //    [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
            //    return;
                
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnTwitterWithTitle:menu.title andInfo:strAddress andThumbnailImage:self.imageForSharing  andWebsiteUrl:self.strWebsite];
                
                /////////////*********************FLURRY ****************//////////////////////////////////////////////////////
                NSDictionary *share_analytics =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 menu.postId , @"post_id",
                 
                 [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                 @"twitter",@"media",
                 nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_share"] withParameters:share_analytics];
                
                [self callWutzwhatShareFeedbackWithShareType:@"twitter"];
                
            }
                break;
            case 2:
            {
                // TODO
                // This is temp for the soft launch
          //      [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
          //      return;
                
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnGooglePlusWithTitle:menu.title andInfo:strAddress andThumbnailUrl:menu.thumbnailURL andWebsiteUrl:self.strWebsite];
                
                NSDictionary *share_analytics =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 menu.postId , @"post_id",
                 
                 [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                 @"googleplus",@"media",
                 nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_share"] withParameters:share_analytics];

                
                [self callWutzwhatShareFeedbackWithShareType:@"googleplus"];
            }
                break;
            case 3:
            {
                // TODO
                // This is temp for the soft launch
         //       [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
         //       return;

                self.sender = [[CommonFunctions alloc] initWithParent:self];
                
                NSDictionary *share_analytics =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 menu.postId , @"post_id",
                 
                 [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                 @"email",@"media",
                 nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_share"] withParameters:share_analytics];

                
                [self.sender emailWithTitle:menu.title andInfo:strAddress andThumbnailImage:self.imageForSharing  andWebsiteUrl:self.strWebsite];
                
            }
                break;
            case 4:
            {
                // TODO
                // This is temp for the soft launch
          //      [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
          //      return;

                self.sender = [[CommonFunctions alloc] initWithParent:self];
                
                NSDictionary *share_analytics =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 menu.postId , @"post_id",
                 
                 [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                 @"text_message",@"media",
                 nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_share"] withParameters:share_analytics];
                
                [self.sender textWithTitle:menu.title andInfo:strAddress andWebsiteUrl:self.strWebsite];
            }
                break;
                
        }
    }
    if (actionSheet.tag==4) {
        if (buttonIndex == actionSheet.cancelButtonIndex)
        {
            return;
        }
        indexOfCheckIn = buttonIndex;
        switch (buttonIndex) {
            case 0:
            {
                
                [self getCurrentLocation];
            }
                break;
            case 1:
            {
                [self getCurrentLocation];
                
            }
                break;
            case 2:
            {
                [self getCurrentLocation];
            }
                break;
            default:
                break;
                
        }
        
    }
    
}

- (void)callWutzwhatShareFeedbackWithShareType:(NSString *)lshareType
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:menu.postId forKey:@"postid"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *now = [format stringFromDate:[NSDate date]];
    [params setValue:now forKey:@"res_time"];
    [params setValue:lshareType forKey:@"media_type"];
    [params setValue:[NSNumber numberWithBool:TRUE] forKey:@"share"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE] andDelegate:nil andRequestType:@"POST" andPostDataDict:params];
}

#pragma mark -
#pragma mark Facebook Check-in delegates
#pragma mark -


- (void)fbDidLogin
{
    NSLog(@"fbDidLogin");
    
    [self getNearbyPlaces:[CommonFunctions getUserCurrentLocation].coordinate.latitude andLong:[CommonFunctions getUserCurrentLocation].coordinate.longitude];
}

- (void)checkInOnFacebookUsingDistance
{
    userLocation = [[CLLocation alloc] initWithLatitude:[CommonFunctions getUserCurrentLocation].coordinate.latitude longitude:[CommonFunctions getUserCurrentLocation].coordinate.longitude];
    
    CGFloat  longi = [menu.longitude floatValue];
    CGFloat lati =   [menu.latitude floatValue];
    
    productLocation = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
    
    [self distanceFromLocation];
}

- (void)getNearbyPlaces:(float)latitude andLong:(float)longitude
{
    nearbyPlacesRequestResult = [[NearbyPlacesRequestResult alloc] initWithDelegate:self];
}

- (void) nearbyPlacesRequestCompletedWithPlaces:(NSArray *)placesArray
{
    bool placeFound = NO;
    int placendex=0;
    for (NSDictionary *object in placesArray) {
        NSString *nameOfPlace = [object valueForKey:@"name"];
        if ([[@"Kirk Remodel and Design" lowercaseString] isEqualToString:[nameOfPlace lowercaseString]]) {
            placeFound=YES;
            break;
        }
        placendex++;
    }
    
    if (placeFound) {
        NSDictionary *place = [placesArray objectAtIndex:placendex];
        [self postCheckinWithDictionary:[place mutableCopy]];
    }
}


- (void) nearbyPlacesRequestFailed
{
}

- (void) postCheckinWithDictionary:(NSMutableDictionary *)dictionary
{
    postCheckinRequestResult = [[PostCheckinRequestResult alloc] initWithDelegate:self];
//    SBJSON *jsonWriter = [SBJSON new] ;
//    NSMutableDictionary *coordinatesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                  [NSString stringWithFormat: @"%f", [[[dictionary objectForKey:@"location"] valueForKey:@"latitude"] floatValue]], @"latitude",
//                                                  [NSString stringWithFormat: @"%f", [[[dictionary objectForKey:@"location"] valueForKey:@"longitude"] floatValue]], @"longitude",
//                                                  nil];
    
//    NSString *coordinates = [jsonWriter stringWithObject:coordinatesDictionary];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [dictionary objectForKey:@"id"], @"place",
//                                   coordinates, @"coordinates",
//                                   [NSString stringWithFormat:@"currently at %@",menu.title], @"message",
//                                   nil];
}

- (void) postCheckinRequestCompleted {
    NSLog(@"successfully Checkin");
    [self displayNotification:YES];
}
- (void) postCheckinRequestFailed {
    NSLog(@"failure Checkin");
}


- (void)distanceFromLocation
{
    meters = [productLocation distanceFromLocation:userLocation];
    
    [[ProcessingView instance]forceHideTintView];
    
    
    if(meters < 150)
    {
        switch (indexOfCheckIn) {
            case 0:
            {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *locationDict  = [[NSMutableDictionary alloc] initWithCapacity:2];
                NSString *latitude = menu.latitude;
                NSString *longitude =menu.longitude;
                [locationDict setObject:longitude forKey:@"longitude"];
                [locationDict setObject:latitude forKey:@"latitude"];
                [params setObject:locationDict forKey:@"location"] ;
                [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
                [params setValue:menu.postId forKey:@"postid"];
                
                
                
                NSDictionary *wutzwhat_details = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  menu.postId, @"post_id", // Capture author info
                                                 
                                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                                                  @"wutzwhat",@"media",// Capture user status
                                                  nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_checkin"] withParameters:wutzwhat_details];

                
                
                
                [[ProcessingView instance] showTintView];
                
                DataFetcher *fetcher  = [[DataFetcher alloc] init];
                [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,CHECKIN_WUTZWHAT] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
            }
                break;
            case 1:
            {
                // TODO
                // This is temp for the soft launch
         //       [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
         //       return;
                NSDictionary *wutzwhat_details = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  menu.postId, @"post_id", // Capture author info
                                                  
                                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                                                  @"facebook",@"media",// Capture user status
                                                  nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_checkin"] withParameters:wutzwhat_details];
                
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnFaceBookWithTitle:[NSString stringWithFormat:@"Check in at %@",menu.title] bonusCode:@""];
            }
                break;
            case 2:
            {
                // TODO
                // This is temp for the soft launch
      //          [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
      //          return;
                NSDictionary *wutzwhat_details = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  menu.postId, @"post_id", // Capture author info
                                                  
                                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                                                  @"twitter",@"media",// Capture user status
                                                  nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_checkin"] withParameters:wutzwhat_details];
                
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnTwitterWithTitle:[NSString stringWithFormat:@"Check in at %@",menu.title] bonusCode:@""];
            }
                break;
                
                
            default:
                break;
        }
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED_CHECKIN_FAR];
    }
}



#pragma mark- Data fetcher


- (void) calServiceWithURL:(NSString*)serviceUrl
{
//    NSDictionary *dict = [WUTZWHAT_DETAIL_RESPONSE JSONValue];
//    [self dataFetchedSuccessfully:dict forUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_HOTPICKS_DETAIL]];
//    return;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:menu.postId forKey:@"postid"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    [params setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"curr_date"];
    
    NSString *latitude = [[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.latitude] stringValue];
    
    NSString *longitude =[[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.longitude] stringValue];
    
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longitude forKey:@"longitude"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}


- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    self.mainScroll.scrollEnabled = YES;
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User viewed the profile %@ , %@ , %@",[[responseData objectForKey:@"params"] objectForKey:@"postid"] , [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,CHECKIN_WUTZWHAT]])
    {
        BOOL isSuccess = [[responseData objectForKey:@"result"] boolValue];
        if (isSuccess) {
            
            
            int like_count1 = [[responseData objectForKey:@"message"] intValue];
            if (like_count1 > 100) {
                titleLabelReview.text = [NSString stringWithFormat:@"100+"];
            }if (like_count1 >= 1000) {
                titleLabelReview.text = [NSString stringWithFormat:@"1k+"];
            }if (like_count1 >= 10000) {
                titleLabelReview.text = [NSString stringWithFormat:@"10k+"];
            }if (like_count1 >= 100000) {
                titleLabelReview.text = [NSString stringWithFormat:@"100k+"];
            }if (like_count1 >= 1000000) {
                titleLabelReview.text = [NSString stringWithFormat:@"1m+"];
            }else
            {
                titleLabelReview.text = [NSString stringWithFormat:@"%d",[[responseData objectForKey:@"message"] intValue]];
            }

            [[ProcessingView instance] forceHideTintView];
            
            if([[responseData objectForKey:@"userCheckInCount"] intValue] == 1)
                [Utiltiy showAlertWithTitle:@"Successful" andMsg:MSG_SUCCESS_CHECKIN_FIRST];
            else
                [Utiltiy showAlertWithTitle:@"Successful" andMsg:[NSString stringWithFormat:@"Congratulations, you checked in %d times at this location!",[[responseData objectForKey:@"userCheckInCount"] intValue]]];
            
        }else if([[responseData objectForKey:@"error"] isEqualToString:@"too-soon"])
        {
            //Handle error message with what we choose to display
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED_CHECKIN_SOON];
        }
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE]])
    {
        BOOL isSuccess = [[responseData objectForKey:@"result"] boolValue];
        
        [[ProcessingView instance] forceHideTintView];
        
        if (isSuccess)
        {
            if ([[responseData objectForKey:@"params"] objectForKey:@"like"])
            {
                self.menu.isLiked = [[[responseData objectForKey:@"params"] objectForKey:@"like"] isEqualToString:@"1"];
                [self setLikeItButtonImage:self.menu.isLiked];
                int count = [self.lblLoveCount.text intValue];
                if (self.menu.isLiked)
                    count += 1;
                else
                    count -= 1;
                for (UIView *view in self.btnLoveIt.subviews)
                {
                    for (UIView *lblCount in view.subviews)
                    {
                        if ([lblCount isKindOfClass:[UILabel class]])
                        {
                            UILabel *lbl = (UILabel *)lblCount;
                            lbl.text = [NSString stringWithFormat:@"%d", count];
                        }
                    }
                }
                
                self.lblLoveCount.text = [NSString stringWithFormat:@"%d", count];
            }
            else if ([[responseData objectForKey:@"params"] objectForKey:@"favourite"])
            {
                self.menu.isFavourited = [[[responseData objectForKey:@"params"] objectForKey:@"favourite"] isEqualToString:@"1"];
                [self setFavouriteButtonImage:self.menu.isFavourited];
            }
            [self displayNotification:YES];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        }
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_HOTPICKS_DETAIL]])
    {
        if ( ![[responseData objectForKey:@"data"] isKindOfClass:[NSNull class]] && [responseData objectForKey:@"data"]!=nil )
        {
            NSArray *data  = [responseData objectForKey:@"data"];
            if ([data count]==1) {
                
                 NSDictionary *response= [data objectAtIndex:0];
                
///////////////////////////////////////*****FLURRY*******/////////////////////////////////////////////////////////////
                
                NSDictionary *wutzwhat_details = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  menu.postId, @"post_id", // Capture author info
                                                  [response objectForKey:@"title"], @"post_title",
                                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",// Capture user status
                                                  nil];
                
                [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_wutzwhat"] withParameters:wutzwhat_details timed:YES];
                
               
                
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
               
            
                //Asad Ali, Dynamic Label Height Issue.
                
                NSString *eventTime = [EventDateModel getEventTimeFromDictionary:[response objectForKey:@"wutzwat_time"]];
                if (![eventTime isEqualToString:@""])
                {
                    [self setDynamicViewHeight:self.viewTime sparatorImage:self.imgEventTime forLabel:self.lblTime withString:eventTime];
                    self.lblDays.frame = CGRectMake(45, self.lblTime.frame.origin.y, 100, self.lblTime.frame.size.height);
                    self.lblTime.frame = CGRectMake(self.lblDays.frame.size.width + self.lblDays.frame.origin.x, self.lblTime.frame.origin.y, self.lblTime.frame.size.width, self.lblTime.frame.size.height);
                    self.lblTime.textAlignment = NSTextAlignmentCenter;
                }
                else
                {
                    [self hideView:self.viewTime];
                }
                
                if ( ![[response objectForKey:@"description"] isKindOfClass:[NSNull class]] && [response objectForKey:@"description"]!=nil && ![[response objectForKey:@"description"] isEqualToString:@""] )
                {
                    [self setDynamicViewHeight:self.viewLongDesc sparatorImage:self.imgLongDescLine forLabel:self.lblLongDescription withString:[response objectForKey:@"description"]];
                    
                }else
                {
                    [self hideView:self.viewLongDesc];
                }
                
                if ( ![[response objectForKey:@"event_end_date"] isKindOfClass:[NSNull class]] && [response objectForKey:@"event_end_date"]!=nil && ![[response objectForKey:@"event_end_date"] isEqualToString:@""] && ![[response objectForKey:@"event_start_date"] isKindOfClass:[NSNull class]] && [response objectForKey:@"event_start_date"]!=nil && ![[response objectForKey:@"event_start_date"] isEqualToString:@""])
                {
                    NSString *startDate = [self getDateStringFromTimeStamp:[response objectForKey:@"event_start_date"]];
                    NSString *endDate = [self getDateStringFromTimeStamp:[response objectForKey:@"event_end_date"]];
                    
                    self.lblEvents.text = [NSString stringWithFormat:@"From %@ to %@", startDate, endDate];
                    
                    self.menu.eventStartDate = [response objectForKey:@"event_start_date"];
                    self.menu.eventEndDate = [response objectForKey:@"event_end_date"];
                }
                else
                {
                    [self hideView:self.viewEvents];
                }
                
                //Previous Values
                self.imgIsFavourite.hidden = ![[response objectForKey:@"isfavourite"] boolValue];
                self.imgIsHotPick.hidden = ![[response objectForKey:@"hotpick"] boolValue];
                int perksCount = [[response objectForKey:@"perk_count"] intValue];
                if (! perksCount > 0)
                {
                    self.imgIsPerk.hidden = ! perksCount > 0;
                    [self hideView:self.viewPerksBanner];
                }
                
                NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
                [pStyle setLineSpacing:-3];
                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:[response objectForKey:@"title"]];
                [aString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [[response objectForKey:@"title"] length])];
                
                if(OS_VERSION>=7)
                {
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[response objectForKey:@"title"] length])];
                }
                    self.lblTitle.attributedText = aString;
                self.lblShortDescription.text = [response objectForKey:@"info"];
                self.lblLoveCount.text = [NSString stringWithFormat:@"%d", [[response objectForKey:@"like_count"]intValue] ];
                
                
                if ( ![[response objectForKey:@"distance"] isKindOfClass:[NSNull class]] && [response objectForKey:@"distance"]!=nil )
                {
                    int dist = [[response objectForKey:@"distance"]intValue];
                    
                    if (dist)
                    {
                        [self.lblDistance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:[NSNumber numberWithInt:dist]]];
                    }
                    else
                    {
                        [self.lblDistance setText:[NSString stringWithFormat:@"0 km"]];
                    }
                }
                
                if (![[response objectForKey:@"images"] isKindOfClass:[NSNull class]] && [response objectForKey:@"images"] != nil && [response objectForKey:@"images"] !=nil)
                {
                    
                    Util *util = [[Util alloc]init];
                    
                    //send a array with the JSON information about all images.
                    NSString *urlImagePerk = ([[response objectForKey:@"banner_img"] isKindOfClass:[NSNull class]]) ? [util findFirstUrlImage:[response objectForKey:@"images"]] : [response objectForKey:@"banner_img"];
                    UIImage *imageCroppedAndResized = [util cropCenterAndResizeImage: urlImagePerk cropWidth:640 cropHeight:240 resizeWidth:320 resizeHeight:120];
                    
                    //add the background image
                    [self.img_Perkbanner setImage:imageCroppedAndResized];
                    
                    //create the wutzwhat icon images
                    UIImage *wutzWhatIconImage = [UIImage imageNamed:@"perk_banner.png"];
                    UIImage *wutzWhatIconImageClicked = [UIImage imageNamed:@"perk_banner_c.png"];
                    UIImage *shadow = [UIImage imageNamed:@"banner_shadow.png"];
                    //create and posicionate a button with the images over the background image
                    UIButton *btn_icon = [[UIButton alloc] initWithFrame:CGRectMake(250.5, (self.img_Perkbanner.frame.size.height - wutzWhatIconImage.size.height) / 2, wutzWhatIconImage.size.width,wutzWhatIconImage.size.height)];
                    
                    //set the images inside the button with the normal and "hover" effect
                    [btn_icon setImage: wutzWhatIconImage forState:UIControlStateNormal];
                    [btn_icon setImage: wutzWhatIconImageClicked forState:UIControlStateHighlighted];
                    [btn_icon setImage: wutzWhatIconImageClicked forState:UIControlStateSelected];
                    
                    //create an image with an arrow and positionate it over the background image
                    UIImageView *imageViewDetailArrow = [[UIImageView alloc] initWithFrame:CGRectMake(295, (self.img_Perkbanner.frame.size.height - 25) / 2, 25, 25)];
                    UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadow];
                    [imageViewDetailArrow setImage:[UIImage imageNamed:@"z_banner_arrow.png"]];
                    
                    //point the action of the button to the action of the perk.
                    [btn_icon addTarget:self action:@selector(relatedPerks) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    [self.img_Perkbanner addSubview:shadowView];
                    [self.img_Perkbanner addSubview:btn_icon];
                    [self.img_Perkbanner addSubview:imageViewDetailArrow];
                }else
                {
                    [self hideView:self.viewPerksBanner];
                }
                
                if ( ![[response objectForKey:@"price"] isKindOfClass:[NSNull class]] && [response objectForKey:@"price"]!=nil && ![[response objectForKey:@"price"] isEqualToString:@""] )
                {
                    int price = [[response valueForKey:@"price"] intValue];
                    self.lblPrice.text = price == 1 ? @"$" : price == 2 ? @"$$" : price == 3 ? @"$$$" : @"$$$$";
                    self.lblPriceCell.text = self.lblPrice.text;
                    
                }
                else
                {
                    self.lblPriceCell.text = @"";
                    [self hideView:self.viewPrice];
                }
                self.menu.isLiked = [[response objectForKey:@"islike"] boolValue];
                [self setLikeItButtonImage:self.menu.isLiked];
                
                self.menu.isFavourited = [[response objectForKey:@"isfavourite"] boolValue];
                [self setFavouriteButtonImage:self.menu.isFavourited];
                
                if ([[response objectForKey:@"isfavourite"] boolValue])
                {
                    [FavouritesCache saveProductDetails:responseData andSection:self.sectionType andCategory:self.categoryType];
                }
                else
                {
                    [FavouritesCache deleteProductDetailsByID:self.menu.postId];
                }
                
//                self.imagesURLModelArray = [ImagesURLModel parseImagesURL:[response objectForKey:@"images"]];
//
//                [self openGalleryViewWithImages];
                
                if ( ![[response objectForKey:@"description"] isKindOfClass:[NSNull class]] && [response objectForKey:@"description"]!=nil && ![[response objectForKey:@"description"] isEqualToString:@""] )
                {
                    [self setDynamicViewHeight:self.viewLongDesc sparatorImage:self.imgLongDescLine forLabel:self.lblLongDescription withString:[response objectForKey:@"description"]];
                    
                    
                    self.lblLongDescription.frame = CGRectMake(self.lblLongDescription.frame.origin.x, (self.viewLongDesc.frame.size.height - self.lblLongDescription.frame.size.height) /2, self.lblLongDescription.frame.size.width, self.lblLongDescription.frame.size.height);
                    
                }else{
                    self.lblLongDescription.text=@"";
                    [self hideView:self.viewLongDesc];
                }
                                
                if ( ![[response objectForKey:@"curation"] isKindOfClass:[NSNull class]] && [response objectForKey:@"curation"]!=nil && ![[response objectForKey:@"curation"] isEqualToString:@""] ) {
                    self.lblPerk.text=[response objectForKey:@"curation"];
                    
                }else{
                    self.lblPerk.text=@"";
                }
                
                if (( ![[response objectForKey:@"address"] isKindOfClass:[NSNull class]] && [response objectForKey:@"address"]!=nil && ![[response objectForKey:@"address"] isEqualToString:@""] ))
                {
                    strAddress= [response objectForKey:@"address"];
                    self.addressTaxiLabel.text = strAddress;
                    self.taxiButton.hidden = true;
                    self.taxiButton.enabled = false;
                    self.addressTaxiLabel.frame = CGRectMake(self.addressTaxiLabel.frame.origin.x, self.addressTaxiLabel.frame.origin.y, 258.5f, self.addressTaxiLabel.frame.size.height);
                    self.menu.address = strAddress;
                    
                }else
                {
                    [self.btnMap setTitle:@"" forState:UIControlStateNormal] ;
                    taxiPhoneNo=@"";
                    [self hideView:self.viewMap];
                }
                if(( ![[response objectForKey:@"taxi_phone"] isKindOfClass:[NSNull class]] && [response objectForKey:@"taxi_phone"]!=nil && ![[response objectForKey:@"taxi_phone"] isEqualToString:@""] ))
                {
                    taxiPhoneNo=[response objectForKey:@"taxi_phone"];
                    self.taxiButton.hidden = FALSE;
                    self.taxiButton.enabled = TRUE;
                    self.addressTaxiLabel.frame = CGRectMake(self.addressTaxiLabel.frame.origin.x, self.addressTaxiLabel.frame.origin.y, 181, self.addressTaxiLabel.frame.size.height);
                    
                } else {
                    self.taxiButton.hidden = true;
                    self.taxiButton.enabled = false;
                }
                
                if ( ![[response objectForKey:@"phone"] isKindOfClass:[NSNull class]] && [response objectForKey:@"phone"]!=nil && ![[response objectForKey:@"phone"] isEqualToString:@""] ) {
                    callno = [response objectForKey:@"phone"];
                    [self addLabelToButton:self.btnCall withText:callno];
                    
                }else{
                    [self.btnCall setTitle:@"" forState:UIControlStateNormal] ;
                    [self hideView:self.viewCall];
                }
                if ( ![[response objectForKey:@"taxi_name"] isKindOfClass:[NSNull class]] && [response objectForKey:@"taxi_name"]!=nil && ![[response objectForKey:@"taxi_name"] isEqualToString:@""] ) {
                    
                    
                    
                    taxiName = [response objectForKey:@"taxi_name"];
                }
                if ( ![[response objectForKey:@"website"] isKindOfClass:[NSNull class]] && [response objectForKey:@"website"]!=nil && ![[response objectForKey:@"website"] isEqualToString:@""] && ![[[response objectForKey:@"website"] lowercaseString] isEqualToString:@"\u00a0"] ) {
                    self.strWebsite = [CommonFunctions creatProperURLString:[response objectForKey:@"website"]];
                    self.lblWebsiteAddress.text = [CommonFunctions removeHTTPString:[response objectForKey:@"website"]];
                    
                }
                else
                {
                    strWebsite = @"";
                    [self.btnWebsite setTitle:@"" forState:UIControlStateNormal] ;
                    
                    [self hideView:self.viewWebSite];
                    
                }
                
                //Reviews Count
                
                UIImageView *imageReview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_1w.png"]];
                UILabel* titleLabel = [[UILabel alloc]
                                       init] ;
                UIImageView *imageReview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_2w.png"]];
                
                UIImageView *imageReview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_3w.png"]];
                
                if (![[response objectForKey:@"review_count"] isKindOfClass:[NSNull class]] && [response objectForKey:@"review_count"]!=nil)
                {
                    
                    NSString *reviewcount=[NSString stringWithFormat:@"%d",[[response objectForKey:@"review_count"]intValue]];
                    if ([reviewcount isEqualToString:@"0"]) {
                        [self addLabelToButton:self.btnReview withText:@""];
                        [self hideView:self.viewTopReviews];
                    }else
                    {
                        [self addLabelToButton:self.btnReview withText:@"Top Reviews"];
                    }
                    if (reviewcount.length==1){
                        UILabel* titleLabel = [[UILabel alloc]
                                               init] ;
                        titleLabel.text = [NSString stringWithFormat:@"%d",[[response objectForKey:@"review_count"] intValue]];
                        
                        imageReview.frame=CGRectMake(_btnReview.frame.size.width-imageReview.frame.size.width-20, _btnReview.center.y-7, imageReview.frame.size.width, imageReview.frame.size.height);
                        imageReview.center = CGPointMake(self.btnReview.frame.size.width-imageReview.frame.size.width-10, self.self.btnReview.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageReview.frame.size.width, imageReview.frame.size.height) ;
                        
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
                        titleLabel.textColor = [UIColor blackColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.shadowColor = [UIColor whiteColor];
                        titleLabel.shadowOffset = CGSizeMake(0, -1);
                        
                        [self.btnReview addSubview:imageReview];
                        [imageReview addSubview:titleLabel];
                        
                        
                    } if (reviewcount.length==2 ) {
                        UILabel* titleLabel = [[UILabel alloc]
                                               init] ;
                        titleLabel.text = [NSString stringWithFormat:@"%d",[[response objectForKey:@"review_count"] intValue]];
                        imageReview2.frame=CGRectMake(_btnReview.frame.size.width-imageReview2.frame.size.width-20, _btnReview.center.y-7, imageReview2.frame.size.width, imageReview2.frame.size.height);
                        imageReview2.center = CGPointMake(self.btnReview.frame.size.width-imageReview2.frame.size.width-10, self.self.btnReview.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageReview2.frame.size.width, imageReview2.frame.size.height);
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
                        titleLabel.textColor = [UIColor blackColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.shadowColor = [UIColor whiteColor];
                        titleLabel.shadowOffset = CGSizeMake(0, -1);
                        
                        [self.btnReview addSubview:imageReview2];
                        [imageReview2 addSubview:titleLabel];
                    }
                    if(reviewcount.length>2)
                    {
                        UILabel* titleLabel = [[UILabel alloc]
                                               init] ;
                        titleLabel.text=@"99+";
                        imageReview3.frame=CGRectMake(_btnReview.frame.size.width-imageReview3.frame.size.width-20, _btnReview.center.y-7, imageReview3.frame.size.width, imageReview3.frame.size.height);
                        imageReview3.center = CGPointMake(self.btnReview.frame.size.width-imageReview3.frame.size.width-10, self.self.btnReview.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageReview3.frame.size.width, imageReview3.frame.size.height);
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
                        titleLabel.textColor = [UIColor blackColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.shadowColor = [UIColor whiteColor];
                        titleLabel.shadowOffset = CGSizeMake(0, -1);
                        
                        [self.btnReview addSubview:imageReview3];
                        [imageReview3 addSubview:titleLabel];
                    }
                    
                }
                else
                {
                    [self hideView:self.viewTopReviews];
                }
                //Other Locations
                if ( ![[response objectForKey:@"location_count"] isKindOfClass:[NSNull class]] && [response objectForKey:@"location_count"]!=nil)
                {
                    NSString *locationcount=[NSString stringWithFormat:@"%d",[[response objectForKey:@"location_count"]intValue]];
                    if ([locationcount isEqualToString:@"0"] || [locationcount isEqualToString:@"1"])
                    {
                        [self addLabelToButton:self.btnOtherLocations withText:@""];
                        [self hideView:self.viewOtherLocation];
                    }
                    else
                    {
                        [self addLabelToButton:self.btnOtherLocations withText:@"All Locations"];
                    }
                }
                else
                {
                    [self addLabelToButton:self.btnOtherLocations withText:@""];
                    [self hideView:self.viewOtherLocation];
                }
                
                //Like Count
                UIImageView *imageCount1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_1b.png"]];
                
                UIImageView *imageCount2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_2b.png"]];
                
                UIImageView *imageCount3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_3b.png"]];
                
                
                
                if ( ![[response objectForKey:@"like_count"] isKindOfClass:[NSNull class]] && [response objectForKey:@"like_count"]!=nil)
                {
                    
                    
                    NSString *like_count=[NSString stringWithFormat:@"%d",[[response objectForKey:@"like_count"] intValue]];
                    
                    if (like_count.length==1){
                        titleLabel.text = [NSString stringWithFormat:@"%d",[[response objectForKey:@"like_count"] intValue]];
                        imageCount1.frame=CGRectMake(_btnLoveIt.frame.size.width-imageCount1.frame.size.width, self.btnLoveIt.center.y-7, imageCount1.frame.size.width, imageCount1.frame.size.height);
                        imageCount1.center = CGPointMake(_btnLoveIt.frame.size.width-imageCount1.frame.size.width, self.self.btnLoveIt.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageCount1.frame.size.width, imageCount1.frame.size.height) ;
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                        titleLabel.textColor = [UIColor whiteColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        
                        [imageCount1 addSubview:titleLabel];
                        [self.btnLoveIt addSubview:imageCount1];
                        
                    }
                    if(like_count.length==2)
                    {
                        titleLabel.text = [NSString stringWithFormat:@"%d",[[response objectForKey:@"like_count"] intValue]];
                        imageCount2.frame=CGRectMake(_btnLoveIt.frame.size.width-imageCount2.frame.size.width, self.btnLoveIt.center.y-7, imageCount2.frame.size.width, imageCount2.frame.size.height);
                        imageCount2.center = CGPointMake(_btnLoveIt.frame.size.width-imageCount2.frame.size.width, self.self.btnLoveIt.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageCount2.frame.size.width, imageCount2.frame.size.height) ;
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                        titleLabel.textColor = [UIColor whiteColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        
                        [imageCount2 addSubview:titleLabel];
                        [self.btnLoveIt addSubview:imageCount2];
                    }
                    if (like_count.length>2) {
                        titleLabel.text = [NSString stringWithFormat:@"99+"];
                        imageCount2.frame=CGRectMake(_btnLoveIt.frame.size.width-imageCount2.frame.size.width, self.btnLoveIt.center.y-7, imageCount2.frame.size.width, imageCount2.frame.size.height);
                        imageCount2.center = CGPointMake(_btnLoveIt.frame.size.width-imageCount2.frame.size.width, self.self.btnLoveIt.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageCount2.frame.size.width, imageCount2.frame.size.height) ;
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                        titleLabel.textColor = [UIColor whiteColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        
                        [imageCount2 addSubview:titleLabel];
                        [self.btnLoveIt addSubview:imageCount2];
                    }
                    if (like_count.length>3)
                    {
                        titleLabel.text = [NSString stringWithFormat:@"999+"];
                        imageCount3.frame=CGRectMake(_btnLoveIt.frame.size.width-imageCount3.frame.size.width, self.btnLoveIt.center.y-7, imageCount3.frame.size.width, imageCount3.frame.size.height);
                        imageCount3.center = CGPointMake(_btnLoveIt.frame.size.width-imageCount3.frame.size.width, self.self.btnLoveIt.frame.size.height / 2);
                        titleLabel.frame=CGRectMake(0, 0,
                                                    imageCount3.frame.size.width, imageCount3.frame.size.height) ;
                        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                        titleLabel.textColor = [UIColor whiteColor];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        [imageCount3 addSubview:titleLabel];
                        [self.btnLoveIt addSubview:imageCount3];
                        
                    }
                    
                }else
                {
                    titleLabel.text = @"0";
                    imageCount1.frame=CGRectMake(_btnLoveIt.frame.size.width-imageCount1.frame.size.width, self.btnLoveIt.center.y-7, imageCount1.frame.size.width, imageCount1.frame.size.height);
                    imageCount1.center = CGPointMake(_btnLoveIt.frame.size.width-imageCount1.frame.size.width, self.self.btnLoveIt.frame.size.height / 2);
                    titleLabel.frame=CGRectMake(0, 0,
                                                imageCount1.frame.size.width, imageCount1.frame.size.height) ;
                    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                    titleLabel.textColor = [UIColor whiteColor];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    
                    [imageCount1 addSubview:titleLabel];
                    [self.btnLoveIt addSubview:imageCount1];
                }
                //Like Count
                
                
                //Checkin Count
                if(!imageCountReview)
                    imageCountReview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_3b.png"]];
                
                if ( ![[response objectForKey:@"check_in_count"] isKindOfClass:[NSNull class]] && [response objectForKey:@"check_in_count"]!=nil)
                {
                    imageCountReview.frame=CGRectMake(self.btnCheckin.frame.size.width - 60, self.btnCheckin.center.y-7, imageCountReview.frame.size.width, imageCountReview.frame.size.height);
                    imageCountReview.center = CGPointMake(self.btnCheckin.frame.size.width - 30, self.btnCheckin.frame.size.height / 2);

                    if(!titleLabelReview)
                        titleLabelReview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,imageCountReview.frame.size.width,imageCountReview.frame.size.height)] ;
                    
                    [titleLabelReview setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                    titleLabelReview.textColor = [UIColor whiteColor];
                    titleLabelReview.backgroundColor = [UIColor clearColor];
                    titleLabelReview.textAlignment = NSTextAlignmentCenter;
                    
                    int like_count1 = [[response objectForKey:@"check_in_count"]intValue];
                    if (like_count1 > 100) {
                        titleLabelReview.text = [NSString stringWithFormat:@"100+"];
                    }if (like_count1 >= 1000) {
                        titleLabelReview.text = [NSString stringWithFormat:@"1k+"];
                    }if (like_count1 >= 10000) {
                        titleLabelReview.text = [NSString stringWithFormat:@"10k+"];
                    }if (like_count1 >= 100000) {
                        titleLabelReview.text = [NSString stringWithFormat:@"100k+"];
                    }if (like_count1 > 1000000) {
                        titleLabelReview.text = [NSString stringWithFormat:@"1m+"];
                    }else
                    {
                        titleLabelReview.text = [NSString stringWithFormat:@"%d",like_count1];
                    }
                    
                    [self.btnCheckin addSubview:imageCountReview];
                    [imageCountReview addSubview:titleLabelReview];
                    
                }else{
                    imageCountReview.frame=CGRectMake(self.btnCheckin.frame.size.width - 60, self.btnCheckin.center.y-7, imageCountReview.frame.size.width, imageCountReview.frame.size.height);
                    
                    imageCountReview.center = CGPointMake(self.btnCheckin.frame.size.width - 30, self.btnCheckin.frame.size.height / 2);
                    
                    if(!titleLabelReview)
                        titleLabelReview = [[UILabel alloc]
                                                 initWithFrame:CGRectMake(0, 0,imageCountReview.frame.size.width,imageCountReview.frame.size.height)] ;
                    titleLabelReview.frame = CGRectMake(0, 0,imageCountReview.frame.size.width,imageCountReview.frame.size.height);
                    
                    [titleLabelReview setText:@"0"];
                    [titleLabelReview setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                    titleLabelReview.textColor = [UIColor whiteColor];
                    titleLabelReview.backgroundColor = [UIColor clearColor];
                    titleLabelReview.textAlignment = NSTextAlignmentCenter;
                    [self.btnCheckin addSubview:imageCountReview];
                    [imageCountReview addSubview:titleLabelReview];
                }
                
                if ( ![[response objectForKey:@"tags"] isKindOfClass:[NSNull class]] && [response objectForKey:@"tags"]!=nil)
                {
                    [self createTagsLinks:[response objectForKey:@"tags"]];
                }
                else
                {
                    [self hideView:self.viewTags];
                }
                
                self.imagesURLModelArray = [ImagesURLModel parseImagesURL:[response objectForKey:@"images"]];
                
                [self openGalleryViewWithImages];

                
            }else
            {
                self.view.userInteractionEnabled = FALSE;
                [self performSelector:@selector(popControllerAfterError) withObject:nil afterDelay:0.5f];
            }
        }
        else
        {
            self.view.userInteractionEnabled = FALSE;
            [self performSelector:@selector(popControllerAfterError) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)popControllerAfterError
{
    [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOVE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNLOVE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,FAVORITE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNFAVORITE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,FLAG_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNFLAG_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_DETAIL]])
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)taxiBtnPressed:(id)sender
{
    [CommonFunctions makePromptCall:taxiPhoneNo];
}

#pragma mark -
#pragma mark Blank Sections
#pragma mark -

-(void)setViewFrame:(UIView *)view yAxis:(CGFloat)yAxis
{
    view.frame = CGRectMake(view.frame.origin.x, yAxis, view.frame.size.width, view.frame.size.height);
}


-(void)hideView:(UIView *)viewToBeHide
{
    if ([visibleViews containsObject:viewToBeHide])
    {
        [viewToBeHide setHidden:YES];
        
        int viewToBeHideIndex = [visibleViews indexOfObject:viewToBeHide];
        
        CGFloat viewToBeHideYAxis = viewToBeHide.frame.origin.y;
        
        [self setViewFrame:[visibleViews objectAtIndex:viewToBeHideIndex + 1] yAxis:viewToBeHideYAxis];
        
        for (int i = viewToBeHideIndex + 1; i < [visibleViews count]; i ++)
        {
            UIView *upperView = (UIView *)[visibleViews objectAtIndex:i];
            
            CGFloat yAxis = upperView.frame.origin.y;
            CGFloat heigth = upperView.frame.size.height;
            
            if (i + 1 != [visibleViews count])
            {
                [self setViewFrame:[visibleViews objectAtIndex:i + 1] yAxis:yAxis + heigth];
            }
            
        }
        
        [visibleViews removeObject:viewToBeHide];
        
        self.mainScroll.contentSize = CGSizeMake(self.mainScroll.contentSize.width, self.mainScroll.contentSize.height - viewToBeHide.frame.size.height);
    }

}



#pragma mark - HUD

-(BDKNotifyHUD *)notifySuccess {
    if (_notifySuccess != nil) return _notifySuccess;
    _notifySuccess = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
    _notifySuccess.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notifySuccess;
}

- (BDKNotifyHUD *)notifyFail {
    if (_notifyFail != nil) return _notifyFail;
    _notifyFail = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE_FAIL] text:@""];
    _notifyFail.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notifyFail;
}

- (void)displayNotification : (BOOL)isSuccessfull {
    if (isSuccessfull) {
        if (self.notifySuccess.isAnimating) return;
        
        [self.view addSubview:self.notifySuccess];
        [self.notifySuccess presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
            if(![self.notifySuccess isKindOfClass:[NSNull class]])
                [self.notifySuccess removeFromSuperview];
        }];
    }else
    {
        if (self.notifyFail.isAnimating) return;
        
        [self.view addSubview:self.notifyFail];
        [self.notifyFail presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
            if(![self.notifyFail isKindOfClass:[NSNull class]])
                [self.notifyFail removeFromSuperview];
        }];
    }
    
}

#pragma mark -
#pragma mark Add Label To Button/View
#pragma mark -

-(void)addLabelToView:(UIView*)view withText:(NSString *)text
{
    UILabel* titleLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(40, 0, view.frame.size.width-30, view.frame.size.height)];
    titleLabel.text = text;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 13.0];
    titleLabel.textColor = [UIColor colorFromHexString:@"1A1A1A"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor=[UIColor whiteColor];
    titleLabel.shadowOffset=CGSizeMake(0.0f, 1.0f);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
}

-(void)addLabelToButton:(UIButton*)button withText:(NSString *)text
{
    if ([button isEqual:self.btnMap])
    {
        UILabel* titleLabel = [[UILabel alloc]
                               initWithFrame:CGRectMake(40, 0, button.frame.size.width-120, button.frame.size.height)];
        titleLabel.text = text;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 13.0];
        titleLabel.numberOfLines=0;
        titleLabel.textColor = [UIColor colorFromHexString:@"1A1A1A"];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowColor=[UIColor whiteColor];
        titleLabel.shadowOffset=CGSizeMake(0.0f, 1.0f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [button addSubview:titleLabel];
    }
    else
    {
        UILabel* titleLabel = [[UILabel alloc]
                               initWithFrame:CGRectMake(40, 0, button.frame.size.width-30, button.frame.size.height)];
        titleLabel.text = text;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 13.0];
        titleLabel.textColor = [UIColor colorFromHexString:@"1A1A1A"];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowColor=[UIColor whiteColor];
        titleLabel.shadowOffset=CGSizeMake(0.0f, 1.0f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [button addSubview:titleLabel];
    }
}

#pragma mark- Dynamic Height Issue

-(void)setDynamicViewHeight:(UIView *)dynamicView sparatorImage:(UIImageView *)sparatorImage forLabel:(UILabel *)label withString:(NSString *)string
{
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize = [string sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    CGRect newFrame = label.frame;
    
    newFrame.size.height = expectedLabelSize.height;
    
    float differance = newFrame.size.height - label.frame.size.height;
    
    label.frame = newFrame;
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    
    label.text = string;
    
    [label sizeToFit];
    
    
    [self adjustDynamicViewFrame:dynamicView differance:differance sparatorImage:sparatorImage];
}

-(void)adjustDynamicViewFrame:(UIView *)dynamicView differance:(float)differance sparatorImage:(UIImageView *)sparatorImage
{
    [self setNewHeightOfView:dynamicView difference:differance];
    
    [self setNewFrameOfView:sparatorImage difference:differance];
    
    [self dragLowerViewToUpperSide:differance fromView:dynamicView];
    
    if (differance > 10 || differance < -10)
    {
        self.mainScroll.contentSize = CGSizeMake(self.mainScroll.contentSize.width, self.mainScroll.contentSize.height + differance);
    }
}

-(void)dragLowerViewToUpperSide:(float)difference fromView:(UIView *)dynamicView
{
    int index = [visibleViews indexOfObject:dynamicView];
    
    for (int i = index + 1; i < [visibleViews count]; i++)
    {
        UIView *view = [visibleViews objectAtIndex:i];
        [self setNewFrameOfView:view difference:difference];
    }
}

-(void)setNewFrameOfView:(UIView *)view difference:(float)difference
{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + difference, view.frame.size.width, view.frame.size.height);
}

-(void)setNewHeightOfView:(UIView *)view difference:(float)difference
{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + difference);
}

-(NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp
{
    if (timeStamp)
    {
        timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@")/" withString:@""];
        
        NSArray *timeArray = [timeStamp componentsSeparatedByString:@"-"];
        
        double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
        
        postTimeLong = (postTimeLong/1000);
        
        NSDate *tr = [NSDate dateWithTimeIntervalSince1970:postTimeLong];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        
        [formatter setDateFormat:@"MMM dd, YYYY"];
        
        timeStamp = [formatter stringFromDate:tr];
        
        return timeStamp;
    }
    else
    {
        return @"";
    }
}


#pragma mark - GPPSignInDelegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error)
    {
        return;
    }
    if ([GPPSignIn sharedInstance].authentication) {
        id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
        
        NSString *inputURL = menu.thumbnailURL;
        NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
        if (urlToShare) {
            shareBuilder = [shareBuilder setURLToShare:urlToShare];
        }
        
        NSString *inputText = menu.title;
        NSString *text = [inputText length] ? inputText : nil;
        if (text) {
            shareBuilder = [shareBuilder setPrefillText:text];
        }
        
        if (![shareBuilder open]) {
            [Utiltiy showAlertWithTitle:@"Error " andMsg:MSG_FAILED];
        }
    }
    else
    {
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    if (error)
    {
    }
    else
    {
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    NSLog(@"%d", imageUrlsForPhotoGallery.count);
    return  imageUrlsForPhotoGallery.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < imageUrlsForPhotoGallery.count)
    {
        MWPhoto *photo = [imageUrlsForPhotoGallery objectAtIndex:index];
        
        return photo;
    }
    
    return nil;
}


#pragma mark - LikeIt Button Image Change

-(void)setLikeItButtonImage:(BOOL)liked
{
    if (liked)
    {
        [self.btnLoveIt setImage:[UIImage imageNamed:@"detail_lovedit.png"] forState:UIControlStateNormal];
        [self.btnLoveIt setImage:[UIImage imageNamed:@"detail_lovedit_c.png"] forState:UIControlStateHighlighted];
        self.btn_likeit.selected = TRUE;
    }
    else
    {
        [self.btnLoveIt setImage:[UIImage imageNamed:@"detail_loveit.png"] forState:UIControlStateNormal];
        [self.btnLoveIt setImage:[UIImage imageNamed:@"detail_loveit_c.png"] forState:UIControlStateHighlighted];
        self.btn_likeit.selected = FALSE;
    }
}

-(void)setFavouriteButtonImage:(BOOL)favourited
{
    if (favourited)
    {
        self.imgIsFavourite.hidden = NO;
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorited.png"] forState:UIControlStateNormal];
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorited_c.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.imgIsFavourite.hidden = YES;
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorite.png"] forState:UIControlStateNormal];
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorite_c.png"] forState:UIControlStateHighlighted];
    }

}


#pragma mark Tags Button Creation Method

-(void)createTagsLinks:(NSString *)tagsString
{
    NSArray *tagsArray = [tagsString componentsSeparatedByString:@","];
    
    int startingPosition = 36;
    int rowNumber = 0;
    
    if (tagsArray.count > 0)
    {
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < tagsArray.count; i ++)
        {
            NSString *tagText = [tagsArray objectAtIndex:i];
            if([tagText isEqualToString:@""] || [tagText isEqualToString:@" "])
                break;
            NSString *nextTagText = @"";
            if (i < tagsArray.count - 1)
            {
                nextTagText = [tagsArray objectAtIndex:i + 1];
            }
            
            UIButton *btn = [self createTagButtonWithText:tagText startXPosition:startingPosition row:rowNumber];
            [buttonsArray addObject:btn];
            
            startingPosition += btn.frame.size.width + 1;
            CGSize stringsize = [nextTagText sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
//            NSLog(@"startPosition: %d, String Width: %.0f, string: %@", startingPosition, stringsize.width, nextTagText);
            if (startingPosition + stringsize.width + 20 > 300)
            {
                rowNumber += 1;
                startingPosition = 36;
            }
        }
        
        [self adjustDynamicViewFrame:self.viewTags differance:rowNumber * 30 sparatorImage:self.imgTagsBottomLine];
        
        for (int i = 0; i < buttonsArray.count; i ++)
        {
            UIButton *btn = (UIButton *)[buttonsArray objectAtIndex:i];
            
            [self.viewTags addSubview:btn];
        }
    }
}

-(UIButton *)createTagButtonWithText:(NSString *)text startXPosition:(int)startingPosition row:(int)rowNumber
{

    text = [[text substringToIndex:1] isEqualToString:@" "] ? [text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] : text;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *buttonNormalImage = [[UIImage imageNamed:@"tagbubble.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 14, 16, 14)];
    UIImage *buttonHighlightedImage = [[UIImage imageNamed:@"tagbubble_c.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 14, 16, 14)];
    
    [btn setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:buttonHighlightedImage forState:UIControlStateHighlighted];
    
    [btn setTitle:text forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
    [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -2, 0)];
    
    [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    CGSize stringsize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
    
    [btn setFrame:CGRectMake(startingPosition,6 + (rowNumber * 30),stringsize.width + 30, 40)];
    
    [btn addTarget:self action:@selector(tagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)tagButtonClicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    UIButton *btn = (UIButton *)sender;
    
    NSString *tagString = btn.titleLabel.text;
    
    if ([tagString hasPrefix:@" "])
    {
        tagString = [tagString substringFromIndex:1];
    }
    
    NSLog(@"Text of Button is :: %@\n", tagString);
    
    if (self.delegate)
    {
        [self.delegate searchListWithTagString:[tagString stringByReplacingOccurrencesOfString:@"," withString:@""]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Gallery View Method

-(void)openGalleryViewWithImages
{
    if (![[ImagesURLModel getThumbnailImageURL:self.imagesURLModelArray] isEqualToString:@""])
    {
        [imgTumbnailProductImage setImageWithURLWithOutPlaceHolder:[NSURL URLWithString:[ImagesURLModel getThumbnailImageURL:self.imagesURLModelArray]]];
    }
    
    imageUrlsForPhotoGallery = [ImagesURLModel getMediumImagesArrayForSlidShow:self.imagesURLModelArray];
    
    
    int videoIndex = -1;
    NSString *videoURL = @"";
    
    if (self.imagesURLModelArray.count > 0)
    {
        ImagesURLModel *model = [self.imagesURLModelArray objectAtIndex:0];
        
        if (model.isVideoURL && ![model.videoURL isEqualToString:@""])
        {
            videoIndex = 0;
            videoURL = model.videoURL;
        }
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.imgMainProductImage initialize];
    });
    
    self.imgMainProductImage.imagesUrls = [ImagesURLModel getSmallImagesArray:self.imagesURLModelArray];
    self.imgMainProductImage.videoExistAtIndex = videoIndex;
    self.imgMainProductImage.videoURL = [NSURL URLWithString:videoURL];
    self.imgMainProductImage.delegate = self;
    self.imgMainProductImage.contentMode = UIViewContentModeScaleAspectFit;
    self.imgMainProductImage.loadingImage = [UIImage imageNamed:@"default_photo.png"];
    self.imgMainProductImage.tempDownloadedImageSavingEnabled = YES;
    [self.imgMainProductImage setInitialPage:0];

}



#pragma mark - AFImageViewer Delegate Method

-(void)imageClickedAtIndex:(int)index
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"galleryViewOpening" object:nil];
    
    MWPhotoBrowser *imageBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    imageBrowser.displayActionButton = NO;
    imageBrowser.wantsFullScreenLayout = YES;
    imageBrowser.hidesBottomBarWhenPushed= YES;
    [imageBrowser setInitialPageIndex:index];

    [self.navigationController presentViewController:imageBrowser animated:YES completion:^(){}];
}

-(void)videoClickedAtIndex:(int)index videoURL:(NSURL *)videoURL
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"galleryViewOpening" object:nil];
    
    NSURL *url = videoURL;
    
    self.moviePlayer = [[MoviePlayerController alloc] init];
    
    [self.moviePlayer playVideoFromURL:url containerView:self];
}

-(void)firstImageDownloadedForSharing:(UIImage *)downloadedImage
{
    self.imageForSharing = nil;
    self.imageForSharing = [[UIImage alloc] init];
    self.imageForSharing = downloadedImage;
}

- (void)viewDidUnload
{
    [self setViewPerksBanner:nil];
    [self setImgInfoBar:nil];
    [self setImgTagsBottomLine:nil];
    [super viewDidUnload];
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
