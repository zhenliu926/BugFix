//
//  PerksProductDetailViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 12/11/12.
//
//

#import "PerksProductDetailViewController.h"
#import "PerksModel.h"
#import "MapViewController.h"
#import "WutzWhatProductDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "DataFetcher.h"
#import "Constants.h"
#import "ProcessingView.h"
#import "NearbyPlacesRequestResult.h"
#import "JSON.h"
#import "TermsofServiceViewController.h"
#import "Util.h"

@interface PerksProductDetailViewController ()
{
    NSString * callno;
    NSString * strWebsite;
    NSString * taxiPhoneNo;
    NSString *strAddress;
    NSString *credits;
    NSString * taxiName;
    
}

@end

@implementation PerksProductDetailViewController

@synthesize delegate = _delegate;
@synthesize mainScroll;
@synthesize imgMainProductImage;
@synthesize imgTumbnailProductImage;
@synthesize menu, imageForSharing;
@synthesize categoryType;
@synthesize rows;
@synthesize img_Perkbanner=_img_Perkbanner;
@synthesize eventStore = _eventStore,defaultCalendar;
@synthesize viewCall, viewEvents, viewLongDesc, viewMap, viewOtherLocation, viewPrice, viewTags, viewTime, viewTopReviews, viewWebSite, viewBottom, viewPurchase, shouldDisableMerchantBanner, strWebsite, termsOfServices;

@synthesize txtvLongDescription, imgLongDescLine;
@synthesize sender=_sender;
@synthesize moviePlayer = _moviePlayer;
@synthesize imagesURLModelArray = _imagesURLModelArray;

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    
    visibleViews = [[NSMutableArray alloc] initWithObjects:self.viewLongDesc, self.viewPrice, self.viewMap, self.viewCall, self.viewOtherLocation, self.viewWebSite, self.viewTime, self.viewEvents, self.viewTopReviews, self.viewTags, self.viewPurchase, self.viewBottom, nil];
    
    [self setUpNavigationBar];
    
    imageUrlsForPhotoGallery = [[NSMutableArray alloc] init];
    self.imageForSharing = [[UIImage alloc] init];
    self.imageForSharing = [UIImage imageNamed:@"default_sharing_photo.png"];
    
    self.rows= [[NSMutableArray alloc] initWithObjects:menu, nil];
    if(OS_VERSION>=7)
    {
        mainScroll.frame=CGRectMake(0,44,320,530);
    }

    self.mainScroll.contentSize=CGSizeMake(self.view.frame.size.width, 1570);
    self.imagesURLModelArray = [[NSArray alloc] init];
    
    [self maintainPreviousValues];
    
    [CommonFunctions addShadowOnTopOfView:self.imgInfoBarView];
    
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        NSDictionary *cachedResponse = [FavouritesCache getProductDetailsByProductID:self.menu.postId andIsPerk:TRUE];
        if (cachedResponse == nil)
        {
            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
        }
        else
        {
            [self dataFetchedSuccessfully:cachedResponse forUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_PERK_DETAILS]];
        }
    }
    else
    {
        [[ProcessingView instance] forceHideTintView];
        [self calServiceWithURL:GET_PERK_DETAILS];
        self.mainScroll.scrollEnabled = NO;
        self.mainScroll.bounces = self.mainScroll.bouncesZoom = false;
    }
    
    UITapGestureRecognizer *oneFingerTwoTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(relatedPerks)];
    
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    [[self img_Perkbanner] addGestureRecognizer:oneFingerTwoTaps];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setAlpha:1.0f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"retreivedVideoImage" object:nil];
     [Flurry endTimedEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_perk"] withParameters:nil];
}

#pragma mark -
#pragma mark Navigation Bar
#pragma mark -

-(void)setUpNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    if(OS_VERSION>=7)
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar.png"]
                                           forBarMetrics:UIBarMetricsDefault];
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    
    [v addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
//    UIImage *mapButton = [UIImage imageNamed:@"top_map.png"] ;
//    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_map_c.png"];
//    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mapBtn setFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
//    [mapBtn addTarget:self action:@selector(btnMap_Pressed:) forControlEvents:UIControlEventTouchUpInside];
//    [mapBtn setImage:mapButton forState:UIControlStateNormal];
//    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
//    UIBarButtonItem *donebtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
//    [[self navigationItem]setRightBarButtonItem:donebtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks.png"]];
    [[self navigationItem]setTitleView:titleIV];
    self.title=menu.title;
}

#pragma mark -
#pragma mark Previous Values
#pragma mark -

-(void)maintainPreviousValues
{
    self.lblTitle.text = menu.title;
    self.lblShortDescription.text = menu.shortDescription;
    self.lblLoveCount.text = [NSString stringWithFormat:@"%d", menu.likeCount] ;
    if (menu.originalPrice)
    {
        self.lblPrice.text = [NSString stringWithFormat:@"$%.0f",menu.originalPrice];
    }else
    {
        self.lblPrice.text = @"";
    }
    
    if (self.menu.distance)
    {
        [self.lblDistance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:self.menu.distance]];
    }
    else
    {
        [self.lblDistance setText:[NSString stringWithFormat:@"0 km"]];
    }
    
    if(menu.isLiked)
    {
        self.btn_likeit.selected=YES;
    }
    if (!menu.isLiked)
    {
        self.btn_likeit.selected=NO;
    }
    
    if (self.categoryType == 1) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_1.png"]];
    }else if (self.categoryType == 2) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_2.png"]];
    }else if (self.categoryType == 3) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_3.png"]];
    }else if (self.categoryType == 4) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_4.png"]];
    }else if (self.categoryType == 5) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_5.png"]];
    }else if (self.categoryType == 6) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_6.png"]];
    }
    
    
    [[imgTumbnailProductImage layer] setCornerRadius:5];
    imgTumbnailProductImage.ClipsToBounds= YES;
    
    if ( ![menu.thumbnailURL isKindOfClass:[NSNull class]] && ![menu.thumbnailURL isEqualToString:@""] )
    {
        [imgTumbnailProductImage setImageWithURLWithOutPlaceHolder:[NSURL URLWithString:menu.thumbnailURL]];
    }
    if (menu.minCredits)
    {
        credits=[NSString stringWithFormat:@"%d",menu.minCredits];
        
        [self.lblCredits setText:[NSString stringWithFormat:@"%@",credits]];
        
    }
    else
    {
        self.lblCredits.text = @"";
    }
    
    if (menu.isFavourited)
    {
        self.imgisFav.hidden = NO;
    }
    else
    {
        self.imgisFav.hidden = YES;
    }
    
}

#pragma mark -
#pragma mark Orientation
#pragma mark -
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload
{
    [self setMainScroll:nil];
    [self setImgMainProductImage:nil];
    [self setImgTumbnailProductImage:nil];
    
    [self setImg_Perkbanner:nil];
    [self setLblPerk:nil];
    [self setLblTime:nil];
    [self setLblTag:nil];
    [self setLblReviewCount:nil];
    [self setBtnCheckin:nil];
    [self setLblCredits:nil];
    [self setImgisFav:nil];
    [self setBtn_likeit:nil];
    [self setBtnMyCredits:nil];
    [self setLblMyCredits:nil];
    [self setLblActualPrice:nil];
    [self setImgInfoBarView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Button Actions
#pragma mark -
-(void)relatedPerks
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    if (!self.shouldDisableMerchantBanner)
    {
        WutzWhatProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatProductDetailViewController"];
        
        
        WutzWhatModel *model = [[WutzWhatModel alloc] init];
        model.postId = self.menu.postId;
        
        controller.menu = model;
        
        [controller setShouldDisableMerchantBanner:YES];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        NSArray *controllerArray = self.navigationController.viewControllers;
        
        WutzWhatProductDetailViewController *controller = (WutzWhatProductDetailViewController *)[controllerArray objectAtIndex:controllerArray.count - 3];
        
        [self.navigationController popToViewController:controller animated:YES];
    }
}

- (IBAction)taxiBtnPressed:(id)sender
{
    [CommonFunctions makePromptCall:taxiPhoneNo];
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
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Share To Google+",@"Email To Friends",@"Message to Friends", nil];
        actionSheet.tag=3;
        [actionSheet showInView:self.view];
    }
}


- (IBAction)btnEventDate_Pressed:(id)sender {
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
    vc.postTypeID = PERK_ID_FOR_REVIEW;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnReviews_clicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    
    if(isGuest)
    {
        
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    
    ReviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [vc setPostid:menu.postId];
    [vc setPage:@"1"];
    vc.postTypeID = PERK_ID_FOR_REVIEW;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnWebsite_Pressed:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strWebsite]]];
    webBrowser.delegate = self;
    [webBrowser setFixedTitleBarText:menu.title];
    webBrowser.mode = TSMiniWebBrowserModeNavigation;
    webBrowser.postTypeID=  PERK_ID_FOR_REVIEW;
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
    
    NSArray *modelArray = [[NSArray alloc] initWithObjects:self.menu, nil];
    
    controller.forProfile = true;
    controller.modelArray = modelArray;
    controller.isSingleMapView = YES;
    [controller setPostTypeID:PERK_ID_FOR_REVIEW];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnPhoneNo_Pressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Phone Number" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call",@"Copy",@"Add To Contact", nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
}
- (IBAction)btnAddtoCalendar_clicked:(id)sender {
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
                                          self.menu.postId, @"post_id", // Capture author info
                                          
                                          [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                                          // Capture user status
                                          nil];
        
        [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_perk"] withParameters:wutzwhat_details];
        
        [self.sender addEventToCalendar:menu.title description:menu.shortDescription startDate:self.menu.eventStartDate endDate:self.menu.eventEndDate link: self.strWebsite location : menu.address];
    }
}

- (IBAction)btnFeedback_clicked:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    
    if(isGuest)
    {
        
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    
    AddCommentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCommentViewController"];
    [vc setPostid:menu.postId];
    vc.postTypeID = PERK_ID_FOR_REVIEW;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnTermsofService_clicked:(id)sender
{
    TermsofServiceViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"TermsofServiceViewController"];
    vc.termsOfServices = self.termsOfServices;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)btnCheckin_clicked:(id)sender
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Check In" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Check In",@"Check In on Facebook",@"Check In on Facebook", nil];
        
        actionSheet.tag=4;
        [actionSheet showInView:self.view];
    }
}


- (IBAction)btnFavourite_clecked:(id)sender
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
    
    if (!self.menu.isFavourited)
    {
        NSDictionary *share_analytics =
        [NSDictionary dictionaryWithObjectsAndKeys:
         menu.postId , @"post_id",
         
         [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
         
         nil];
        
        [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_favourite"] withParameters:share_analytics];
        
        [params setValue:@"1" forKey:@"favourite"];
    }else
    {
        [params setValue:@"0" forKey:@"favourite"];
    }
    
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
        NSDictionary *share_analytics =
        [NSDictionary dictionaryWithObjectsAndKeys:
         menu.postId , @"post_id",
         
         [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
         
         nil];
        
        [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_like"] withParameters:share_analytics];
        
        [params setValue:@"1" forKey:@"like"];
    }else
    {
        [params setValue:@"0" forKey:@"like"];
    }
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}

- (IBAction)btnPurchase_pressed:(id)sender
{
    // TODO
    // This is temp for the soft launch until the perks are fully tested with braintree
   // [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
   // return;
    
    
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    
    if(isGuest)
    {
        [CommonFunctions showLoginAlertToGuestUser];
        return;
    }
    
    PaymentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    controller.perksModel = self.menu;
    controller.termsOfServices = self.termsOfServices;
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -
#pragma mark Actionsheet Delegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
        if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
        switch (buttonIndex) {
            case 0:
            {
                //Call
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
	if (actionSheet.tag==1)
    {
        if (buttonIndex == actionSheet.cancelButtonIndex)
        {
            return;
        }
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
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnFaceBookWithTitle:menu.title andInfo:menu.info andThumbnailImage:self.imageForSharing andWebsiteUrl:self.strWebsite  ];
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
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnTwitterWithTitle:menu.title andInfo:strAddress andThumbnailImage:self.imageForSharing  andWebsiteUrl:self.strWebsite];
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
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnGooglePlusWithTitle:menu.title andInfo:strAddress andThumbnailUrl:menu.thumbnailURL  andWebsiteUrl:self.strWebsite];
                
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
        if (actionSheet.tag==4)
        {
            if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
            switch (buttonIndex) {
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
        /////////////////////////////////////////////////////////////////////////////////////////////////////
                    
                    NSDictionary *share_analytics =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     menu.postId , @"post_id",
                     
                     [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                     @"wutzwhat",@"media",
                     
                     nil];
                    
                    [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_checkin"] withParameters:share_analytics];
                    
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    DataFetcher *fetcher  = [[DataFetcher alloc] init];
                    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,CHECKIN_WUTZWHAT] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
                }
                    
                    break;
                case 1:
                {
                    self.sender = [[CommonFunctions alloc] initWithParent:self];
                    
                    
                    NSDictionary *share_analytics =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     menu.postId , @"post_id",
                     
                     [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                     @"facebook",@"media",
                     
                     nil];
                    
                    [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_checkin"] withParameters:share_analytics];
                    
                    
                    [self.sender shareOnFaceBookWithTitle:[NSString stringWithFormat:@"Check in at %@",menu.title]  bonusCode:@""];
                }
                    break;
                case 2:
                {
                    self.sender = [[CommonFunctions alloc] initWithParent:self];
                    
                    NSDictionary *share_analytics =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     menu.postId , @"post_id",
                     
                     [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",
                     @"twitter",@"media",
                     
                     nil];
                    
                    [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_checkin"] withParameters:share_analytics];
                    
                    
                    [self.sender shareOnTwitterWithTitle:[NSString stringWithFormat:@"Check in at %@",menu.title] bonusCode:@""];
                }
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


- (void) calServiceWithURL:(NSString*)serviceUrl {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:menu.postId forKey:@"perk_id"];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    [params setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"curr_date_time"];
    
    NSString *latitude = [[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.latitude] stringValue];
    
    NSString *longitude =[[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.longitude] stringValue];
    
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longitude forKey:@"longitude"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}



#pragma mark Data fetcher


- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    self.mainScroll.scrollEnabled = YES;
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User viewed the perk %@ , %@ , %@",[[responseData objectForKey:@"params"] objectForKey:@"postid"] , [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_HOTPICKS_LIKE_FAV_SHARE]])
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
            [self displayNotification];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        }
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_PERK_DETAILS]])
    {
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess) {
            
            if ( ![[responseData objectForKey:@"data"] isKindOfClass:[NSNull class]] && [responseData objectForKey:@"data"]!=nil )
            {
                NSArray *data  = [responseData objectForKey:@"data"];
                
                
               

                
                
                if ([data count]==1)
                {
                    
                    NSDictionary *response= [data objectAtIndex:0];
                    
                    
                    
                    NSDictionary *perk_details = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  menu.postId, @"post_id", // Capture author info
                                                  [response objectForKey:@"title"], @"post_title",
                                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",// Capture user status
                                                  nil];
                    
                    [Flurry logEvent:[NSString stringWithFormat:@"%@%@",menu.postId, @"_perk"] withParameters:perk_details timed:YES];
                    
                    
                    
                    
                    
                    
                    self.menu.isCreditsRequired = [[response objectForKey:@"c_required"] boolValue];
                    //Asad Ali, Dynamic Label Height Issue.
                    self.termsOfServices = [response objectForKey:@"terms_conditions"];
                    
//                    NSString *eventTime = [EventDateModel getEventTimeFromDictionary:[response objectForKey:@"wutzwat_time"]];
//                    if (![eventTime isEqualToString:@""])
//                    {
//                        [self setDynamicViewHeight:self.viewTime sparatorImage:self.imgEventTime forLabel:self.lblTime withString:eventTime];
//                    }
//                    else
//                    {
                        [self hideView:self.viewTime];
                        self.viewTime.hidden = YES;
//                    }
                    
                    if ( ![[response objectForKey:@"long_desc"] isKindOfClass:[NSNull class]] && [response objectForKey:@"long_desc"]!=nil && ![[response objectForKey:@"long_desc"] isEqualToString:@""] )
                    {
                        [self setDynamicViewHeight:self.viewLongDesc sparatorImage:self.imgLongDescLine forLabel:self.lblLongDescription withString:[response objectForKey:@"long_desc"]];
                        
                        self.viewLongDesc.frame = CGRectMake(self.viewLongDesc.frame.origin.x, self.imgInfoBarView.frame.origin.y + self.imgInfoBarView.frame.size.height + self.img_Perkbanner.frame.size.height + 10, self.viewLongDesc.frame.size.width, self.lblLongDescription.frame.size.height);
                        
                        self.lblLongDescription.frame = CGRectMake(self.lblLongDescription.frame.origin.x, (self.viewLongDesc.frame.size.height - self.lblLongDescription.frame.size.height) /2, self.lblLongDescription.frame.size.width, self.lblLongDescription.frame.size.height);
                        
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
                    
                    if ( ![[response objectForKey:@"isShipping"] isKindOfClass:[NSNull class]] && [response objectForKey:@"isShipping"]!= nil)
                    {
                        self.menu.isShipping = [[response objectForKey:@"isShipping"] boolValue];
                    }
                    else
                    {
                        self.menu.isShipping = NO;
                    }
                    
                    if ( ![[response objectForKey:@"discount_price"] isKindOfClass:[NSNull class]] && [response objectForKey:@"discount_price"]!= nil)
                    {
                        self.menu.discountPrice = [[response objectForKey:@"discount_price"] intValue];
                    }
                    else
                    {
                        self.menu.discountPrice = 0;
                    }
                    
                    if ( ![[response objectForKey:@"base_city"] isKindOfClass:[NSNull class]] && [response objectForKey:@"base_city"]!= nil)
                    {
                        self.menu.baseCityID = [[response objectForKey:@"base_city"] intValue];
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
                        UIImage *wutzWhatIconImage = [UIImage imageNamed:@"wutzwhat_banner.png"];
                        UIImage *wutzWhatIconImageClicked = [UIImage imageNamed:@"wutzwhat_banner_c.png"];
                        
                        //create and posicionate a button with the images over the background image
                        UIButton *btn_icon = [[UIButton alloc] initWithFrame:CGRectMake(250.5, (self.img_Perkbanner.frame.size.height - wutzWhatIconImage.size.height) / 2,wutzWhatIconImage.size.width,wutzWhatIconImage.size.height)];
                        
                        //set the images inside the button with the normal and "hover" effect
                        [btn_icon setImage: wutzWhatIconImage forState:UIControlStateNormal];
                        [btn_icon setImage: wutzWhatIconImageClicked forState:UIControlStateHighlighted];
                        [btn_icon setImage: wutzWhatIconImageClicked forState:UIControlStateSelected];
                        
                        //create an image with an arrow and positionate it over the background image
                        UIImageView *imageViewDetailArrow = [[UIImageView alloc] initWithFrame:CGRectMake(295, (self.img_Perkbanner.frame.size.height - 25) / 2, 25, 25)];
                        [imageViewDetailArrow setImage:[UIImage imageNamed:@"z_banner_arrow.png"]];
                        
                        //point the action of the button to the action of the perk.
                        [btn_icon addTarget:self action:@selector(relatedPerks) forControlEvents:UIControlEventTouchUpInside];
                        
                        [self.img_Perkbanner addSubview:btn_icon];
                        [self.img_Perkbanner addSubview:imageViewDetailArrow];
                        
                    }else
                    {
                        
                    }
                    
                    
                    
                    
                    if ( ![[response objectForKey:@"min_credits"] isKindOfClass:[NSNull class]] && [response objectForKey:@"min_credits"] != nil )
                    {
                        
                        [self.lblCredits setText:[NSString stringWithFormat:@"%@",[response objectForKey:@"min_credits"]]];
                        self.menu.minCredits = [[response objectForKey:@"min_credits"] intValue];
                    }
                    else
                    {
                        self.lblCredits.text = @"";
                        self.menu.minCredits = 0;
                    }
                    
                    self.imgisFav.hidden = ![[response objectForKey:@"isfav"] boolValue];
                    
                    self.lblTitle.text = [response objectForKey:@"title"];
                    self.lblShortDescription.text = [response objectForKey:@"short_desc"];
                    self.lblLoveCount.text = [NSString stringWithFormat:@"%d", [[response objectForKey:@"like_count"]intValue] ];
                    
                    if ( ![[response objectForKey:@"orig_price"] isKindOfClass:[NSNull class]] && [response objectForKey:@"orig_price"]!=nil)
                    {
                        self.lblPrice.text = [NSString stringWithFormat:@"$%@",[response objectForKey:@"orig_price"]];
                    }
                    else
                    {
                        self.lblPrice.text = [NSString stringWithFormat:@""];
                    }
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
                    
                    if ( ![[response objectForKey:@"orig_price"] isKindOfClass:[NSNull class]] && [response objectForKey:@"orig_price"]!=nil )
                    {
                        
                        self.lblPriceCell.text = [[response objectForKey:@"orig_price"] isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"$%@",[response objectForKey:@"orig_price"]] : [NSString stringWithFormat:@"$%@",[[response objectForKey:@"orig_price"] stringValue]];
                        self.menu.originalPrice = [[response objectForKey:@"orig_price"] intValue];
                    }else{
                        self.lblPriceCell.text = @"";
                        self.menu.originalPrice = 0;
                        [self hideView:self.viewPrice];
                    }
                    self.menu.isLiked = [[response objectForKey:@"isLike"] boolValue];
                    [self setLikeItButtonImage:self.menu.isLiked];
                    
                    self.menu.isFavourited = [[response objectForKey:@"isfav"] boolValue];
                    [self setFavouriteButtonImage:self.menu.isFavourited];
                    if ([[response objectForKey:@"isfav"] boolValue])
                    {
                        [FavouritesCache saveProductDetails:responseData andSection:nil andCategory:self.categoryType];
                    }
                    else
                        
                    {
                        [FavouritesCache deleteProductDetailsByID:self.menu.postId];
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
                        self.imagesURLModelArray = [ImagesURLModel parseImagesURL:[response objectForKey:@"images"]];
                        
                        [self openGalleryViewWithImages];
                    });
                    
                    if ([CommonFunctions isValueExist:[response objectForKey:@"orig_price"]])
                    {
                        self.lblActualPrice.text = [NSString stringWithFormat:@"($%@ Value)", [response objectForKey:@"orig_price"]];
                    }
                    else
                    {
                        self.lblActualPrice.text=@"";
                    }
                    
                    if ([CommonFunctions isValueExist:[response objectForKey:@"min_credits"]] && [CommonFunctions isValueExist:[response objectForKey:@"discount_price"]])
                    {
                        self.lblPerk.text = [NSString stringWithFormat:@"$%@ + %@ Credits", [response objectForKey:@"discount_price"], [response objectForKey:@"min_credits"]];
                    }
                    else
                    {
                        self.lblPerk.text=@"";
                    }
                    
                    if (( ![[response objectForKey:@"address"] isKindOfClass:[NSNull class]] && [response objectForKey:@"address"]!=nil && ![[response objectForKey:@"address"] isEqualToString:@""] ))
                    {
                        strAddress = [response objectForKey:@"address"];
                        self.addressTaxiLabel.text = strAddress;
                        self.taxiButton.hidden = true;
                        self.taxiButton.enabled = false;
                        self.addressTaxiLabel.frame = CGRectMake(self.addressTaxiLabel.frame.origin.x, self.addressTaxiLabel.frame.origin.y, 258.5f, self.addressTaxiLabel.frame.size.height);
                        menu.address = strAddress;
                        
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
                        callno =[response objectForKey:@"phone"];
                        [self addLabelToButton:self.btnCall withText:callno];
                        
                    }else{
                        [self.btnCall setTitle:@"" forState:UIControlStateNormal] ;
                        [self hideView:self.viewCall];
                    }
                    if ( ![[response objectForKey:@"taxi_phone"] isKindOfClass:[NSNull class]] && [response objectForKey:@"taxi_phone"]!=nil && ![[response objectForKey:@"taxi_phone"] isEqualToString:@""] ) {
                        taxiPhoneNo=[response objectForKey:@"taxi_phone"];
                        
                    }else{
                        taxiPhoneNo=@"";
                        self.taxiButton.hidden = true;
                        self.taxiButton.enabled = false;
                    }
                    
                    if ( ![[response objectForKey:@"taxi_name"] isKindOfClass:[NSNull class]] && [response objectForKey:@"taxi_name"]!=nil && ![[response objectForKey:@"taxi_name"] isEqualToString:@""] ) {
                        
                        
                        
                        taxiName = [response objectForKey:@"taxi_name"];
                    }
                    
                    
                    
                    
                    if ( ![[response objectForKey:@"link"] isKindOfClass:[NSNull class]] && [response objectForKey:@"link"]!=nil && ![[response objectForKey:@"link"] isEqualToString:@""] )
                    {
                        self.strWebsite = [CommonFunctions creatProperURLString:[response objectForKey:@"link"]];
                        [self addLabelToButton:self.btnWebsite withText:[CommonFunctions removeHTTPString:[response objectForKey:@"link"]]];
                    }
                    else
                    {
                        self.strWebsite = @"";
                        [self.btnWebsite setTitle:@"" forState:UIControlStateNormal] ;
                        
                        [self hideView:self.viewWebSite];
                        
                    }
                    
                    if ( ![[response objectForKey:@"user_credits"] isKindOfClass:[NSNull class]] && [response objectForKey:@"user_credits"]!=nil)
                    {
                        self.lblMyCredits.text = [NSString stringWithFormat:@" %@",[response objectForKey:@"user_credits"]];
                        self.menu.userCredits = [[response objectForKey:@"user_credits"] intValue];
                    }
                    else
                    {
                        self.lblMyCredits.text = [NSString stringWithFormat:@""];
                        self.menu.userCredits = 0;
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
                        self.lblReviewCount.text = @"";
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
                    
                    //Button Purchase
                    
                    if (![[response objectForKey:@"qty"] isKindOfClass:[NSNull class]] && [response objectForKey:@"qty"]!=nil)
                    {
                        
                        NSString *quantity=[NSString stringWithFormat:@"%d",[[response objectForKey:@"qty"]intValue]];
                        if ([quantity isEqualToString:@"0"])
                        {
                            [self.btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_white.png"] forState:UIControlStateNormal];
                            [self.btnPurchase setUserInteractionEnabled:NO];
                            [self.btnPurchase setTitle:@"Sold out" forState:UIControlStateNormal];
                            self.btnPurchase.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
                            self.btnPurchase.titleLabel.textColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
                            self.btnPurchase.titleLabel.shadowOffset=CGSizeMake(0, 1);
                            self.btnPurchase.titleLabel.shadowColor=[UIColor whiteColor];
                            
                            [self.btnPerkPurchase setImage:[UIImage imageNamed:@"detail_soldout.png"] forState:UIControlStateNormal];
                            [self.btnPerkPurchase setUserInteractionEnabled:NO];
                        }
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
                    if(!imageCountReview)
                        imageCountReview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_3b.png"]];
                    
                    if ( ![[response objectForKey:@"like_count"] isKindOfClass:[NSNull class]] && [response objectForKey:@"like_count"]!=nil)
                    {
                        imageCountReview.frame=CGRectMake(self.btnCheckin.frame.size.width-imageCountReview.frame.size.width-10, self.btnCheckin.center.y-7, imageCountReview.frame.size.width, imageCountReview.frame.size.height);
                        imageCountReview.center = CGPointMake(self.btnCheckin.frame.size.width-imageCountReview.frame.size.width-10, self.btnCheckin.frame.size.height / 2);
                        
                        if(!titleLabelReview)
                            titleLabelReview = [[UILabel alloc]
                                                     initWithFrame:CGRectMake(0, 0,             imageCountReview.frame.size.width,imageCountReview.frame.size.height)] ;
                        [titleLabelReview setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                        titleLabelReview.textColor = [UIColor whiteColor];
                        titleLabelReview.backgroundColor = [UIColor clearColor];
                        titleLabelReview.textAlignment = NSTextAlignmentCenter;
                        
                        NSString *like_count1=[NSString stringWithFormat:@"%d",[[response objectForKey:@"like_count"]intValue]];
                        if (like_count1.length>3) {
                            titleLabelReview.text = [NSString stringWithFormat:@"99+"];
                        }else
                        {
                            titleLabelReview.text = [NSString stringWithFormat:@"%d",[[response objectForKey:@"like_count"] intValue]];
                        }
                        
                        [self.btnCheckin addSubview:imageCountReview];
                        [imageCountReview addSubview:titleLabelReview];
                    }
//                    }else{
//                        imageCountReview.frame=CGRectMake(self.btnCheckin.frame.size.width-imageCountReview.frame.size.width-20, self.btnCheckin.center.y-7, imageCountReview.frame.size.width, imageCountReview.frame.size.height);
//                        imageCountReview.center = CGPointMake(self.btnCheckin.frame.size.width-imageCountReview.frame.size.width-10, self.btnCheckin.frame.size.height / 2);
//                       if(!titleLabelReview)
//                           titleLabelReview = [[UILabel alloc]
//                                                     initWithFrame:CGRectMake(0, 0,imageCountReview.frame.size.width,imageCountReview.frame.size.height)];
//                        titleLabelReview.frame = CGRectMake(0, 0,imageCountReview.frame.size.width,imageCountReview.frame.size.height);
//                        
//                        [titleLabelReview setText:@""];
//                        [titleLabelReview setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
//                        titleLabelReview.textColor = [UIColor whiteColor];
//                        titleLabelReview.backgroundColor = [UIColor clearColor];
//                        titleLabelReview.textAlignment = NSTextAlignmentCenter;
//                        [self.btnCheckin addSubview:imageCountReview];
//                        [imageCountReview addSubview:titleLabelReview];
//                    }
                    
                    if ( ![[response objectForKey:@"tags"] isKindOfClass:[NSNull class]] && [response objectForKey:@"tags"]!=nil)
                    {
                        [self createTagsLinks:[response objectForKey:@"tags"]];
                    }
                    else
                    {
                        [self hideView:self.viewTags];
                    }
                    self.viewPurchase.frame = CGRectMake(self.viewPurchase.frame.origin.x, self.viewPurchase.frame.origin.y - 3, self.viewPurchase.frame.size.width, self.viewPurchase.frame.size.height);
                }
                else
                {
                    
                    [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
                }
            }
            else
            {
                
                [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
            }
        }
        else
        {
            
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        }
     
        int i = 0;
        for (UIView *v in visibleViews) {
            if(i != 0){
                v.frame = CGRectMake(0, v.frame.origin.y - 20, v.frame.size.width, v.frame.size.height);
                mainScroll.contentSize = CGSizeMake(mainScroll.contentSize.width, mainScroll.contentSize.height - 5);
            }
            i++;
        }
        
    }
    
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
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_DETAIL]]) {
        
    }
    
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


#pragma mark -
#pragma mark HUD
#pragma mark -
- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}

- (void)displayNotification {
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
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
                               initWithFrame:CGRectMake(40, -1, button.frame.size.width-120, button.frame.size.height)];
        titleLabel.text = text;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 13.0];
        titleLabel.numberOfLines=0;
        titleLabel.textColor = [UIColor colorFromHexString:@"1A1A1A"];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowColor=[UIColor whiteColor];
        titleLabel.shadowOffset=CGSizeMake(0.0f, 1.0f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
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
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
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

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return  imageUrlsForPhotoGallery.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < imageUrlsForPhotoGallery.count)
    {
        return [imageUrlsForPhotoGallery objectAtIndex:index];
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
        self.imgisFav.hidden = NO;
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorited.png"] forState:UIControlStateNormal];
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorited_c.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.imgisFav.hidden = YES;
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorite.png"] forState:UIControlStateNormal];
        [self.btnFavorite setImage:[UIImage imageNamed:@"detail_favorite_c.png"] forState:UIControlStateHighlighted];
    }
    
}


#pragma mark Tags Button Creation Method

-(void)createTagsLinks:(NSString *)tagsString
{
    NSArray *tagsArray = [tagsString componentsSeparatedByString:@","];
    int startingPosition = 36;
    
    if (tagsArray.count > 0)
    {
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < tagsArray.count; i ++)
        {
            NSString *tagText = [tagsArray objectAtIndex:i];
            
            UIButton *btn = [self createTagButtonWithText:tagText startXPosition:startingPosition];
            [buttonsArray addObject:btn];
            
            startingPosition += btn.frame.size.width + 1;
        }
        
        for (int i = 0; i < buttonsArray.count; i ++)
        {
            UIButton *btn = (UIButton *)[buttonsArray objectAtIndex:i];
            
            [self.viewTags addSubview:btn];
        }
    }
}

-(UIButton *)createTagButtonWithText:(NSString *)text startXPosition:(int)startingPosition
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
    
    [btn setFrame:CGRectMake(startingPosition,6,stringsize.width + 30, 40)];
    
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


@end
