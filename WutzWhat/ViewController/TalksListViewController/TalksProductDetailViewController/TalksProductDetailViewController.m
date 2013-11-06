//
//  TalksProductDetailViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import "TalksProductDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
@interface TalksProductDetailViewController ()
{
    NSString * taxiPhoneNo;
    NSString *taxiName;
}
@end

@implementation TalksProductDetailViewController

@synthesize mainScroll;
@synthesize categoryType;
@synthesize imgMainProductImage;
@synthesize imgTumbnailProductImage;
@synthesize menu;
@synthesize rows, strWebsite;
@synthesize delegate = _delegate;
@synthesize eventStore = _eventStore,defaultCalendar;
@synthesize viewCall, viewEvents, viewLongDesc, viewMap, viewOtherLocation, viewPrice, viewTags, viewTime, viewTopReviews, viewWebSite, viewBottom, viewPurchase;
@synthesize txtvLongDescription;
@synthesize sender = _sender;
@synthesize moviePlayer = _moviePlayer;
@synthesize imagesURLModelArray = _imagesURLModelArray;

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setAlpha:1.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    [self setUpNavigationBar];
    
    imageUrlsForPhotoGallery = [[NSArray alloc] init];
    
    self.imageForSharing = [[UIImage alloc] init];
    self.imageForSharing = [UIImage imageNamed:@"default_sharing_photo.png"];
    
    visibleViews = [[NSMutableArray alloc] initWithObjects:self.viewLongDesc, self.viewPrice, self.viewMap, self.viewCall, self.viewWebSite, self.viewEvents, self.viewBottom, nil];
    
    
    [self maintainPreviousValues];
    
    [CommonFunctions addShadowOnTopOfView:self.imgInfoBarView];
    
    self.rows= [[NSMutableArray alloc] initWithObjects:menu, nil];
    if(OS_VERSION>=7)
    {
        mainScroll.frame=CGRectMake(0,44,320,530);
    }
    self.mainScroll.contentSize=CGSizeMake(self.view.frame.size.width, 1208);
    self.imagesURLModelArray = [[NSArray alloc] init];
    
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        
        
    }
    else
    {
        [[ProcessingView instance] forceHideTintView];
        [self calServiceWithURL:GET_TALK_DETAIL];
        self.mainScroll.scrollEnabled = NO;
    }
    
    [self.navigationController setNavigationBarHidden:NO];
    self.mainScroll.bounces = false;
    
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark Navigation Bar
#pragma mark -

-(void)setUpNavigationBar
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    self.title=menu.title;
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    [v addSubview:backBtn];
    
    UIImage *mapButton = [UIImage imageNamed:@"top_map.png"] ;
    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_map_c.png"] ;
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
    [mapBtn addTarget:self action:@selector(btnMap_Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapBtn setImage:mapButton forState:UIControlStateNormal];
    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    UIBarButtonItem *mapbtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
    [[self navigationItem]setRightBarButtonItem:mapbtnItem ];
    
    
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_myfinds.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    
}
#pragma mark -
#pragma mark Previous Values
#pragma mark -

-(void)maintainPreviousValues
{
    
    if (self.categoryType == 1) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_1.png"]];
    }else if (self.categoryType == 2) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_2.png"]];
    }else if (self.categoryType == 3) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_3.png"]];
    }else if (self.categoryType == 5) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_5.png"]];
    }else if (self.categoryType == 4) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_4.png"]];
    }else if (self.categoryType == 6) {
        [self.imgType setImage:[UIImage imageNamed:@"detail_find_cat_6.png"]];
    }
    self.lblTitle.text = menu.title;
    self.lblShortDescription.text = menu.info;
    
    [self.lblPosttime setText:[CommonFunctions getDateStringInFormat:LIST_CELL_DATE_FORMATE date:menu.postTime]];

    self.lblPrice.text = menu.price == 4 ? @"$$$$" : menu.price == 3 ? @"$$$" : menu.price == 2 ? @"$$" : menu.price == 1 ? @"$" : @"$";
    
    if ( ![menu.thumbnailURL isKindOfClass:[NSNull class]] && menu.thumbnailURL!=nil && ![menu.thumbnailURL isEqualToString:@""] )
    {
        [imgTumbnailProductImage setImageWithURLWithOutPlaceHolder:[NSURL URLWithString:menu.thumbnailURL]];

        [[imgTumbnailProductImage layer] setCornerRadius:5];
        [imgTumbnailProductImage setClipsToBounds:YES];
        [imgTumbnailProductImage setNeedsDisplay];
    }else
    {
    }
    if(menu.distance < 0) {
        [self hideView:self.lblDistance];
    } else
        [self.lblDistance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:[NSNumber numberWithInt:self.menu.distance]]];
}

- (void)viewDidUnload
{
    [self setLblTitle:nil];
    [self setLblShortDescription:nil];
    [self setLblHeadline:nil];
    [self setLblPosttime:nil];
    [self setLblDistance:nil];
    [self setLblCuration:nil];
    [self setBtnMap:nil];
    [self setLblLongDescription:nil];
    [self setBtnCall:nil];
    [self setBtnWebsite:nil];
    [self setBtnEvent:nil];
    [self setBtnReview:nil];
    [self setBtnFavorite:nil];
    [self setBtnLoveIt:nil];
    [self setBtnShare:nil];
    [self setBtnAddtoCalender:nil];
    [self setBtnFlag:nil];
    [self setImgMainProductImage:nil];
    [self setLblPrice:nil];
    [self setLblPriceCell:nil];
    [self setImgType:nil];
    [self setBtnTaxi:nil];
    [self setImgLongDescLine:nil];
    [self setLblAddress:nil];
    [self setImgInfoBarView:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 99)
    {
        if (buttonIndex == 1)
        {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:menu.postId forKey:@"postId"];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
            [[ProcessingView instance] showTintView];
            DataFetcher *fetcher  = [[DataFetcher alloc] init];
            [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_TALK] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
            [[ProcessingView instance] forceShowTintView];            
        }
        
    }
    if (alertView.tag==123){
        if (buttonIndex ==1){
            [CommonFunctions makePromptCall:taxiPhoneNo];
        }
    }
    else if (alertView.tag == 109)
    {
        if (buttonIndex == 1)
        {
            [self calServiceWithURL:SUBMIT_FIND];
            [[ProcessingView instance] forceShowTintView];            
        }
    }
}
#pragma mark -
#pragma mark Button Actions
#pragma mark -
-(void)OpenGalleryView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"galleryViewOpening" object:nil];

    MWPhotoBrowser *imageBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    imageBrowser.displayActionButton = NO;
    imageBrowser.wantsFullScreenLayout = YES;
    imageBrowser.hidesBottomBarWhenPushed= YES;
    
    [self.navigationController pushViewController:imageBrowser animated:YES];
}

- (IBAction)btnDeleteTalk_Pressed:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Delete this My Find?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag=99;
    [alert show];
}


- (IBAction)btnSubmitMyFind_Pressed:(id)sender
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Submit this My Find to Wutzwhat?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];

    [alert setTag:109];
    
    [alert show];

}

- (IBAction)btnEditTalk_Pressed:(id)sender
{
    AddTalkViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTalkViewController"];
    
    controller.talkID = menu.postId;
    controller.editMode = YES;
    controller.delegate = self;
    controller.categoryIndex = self.categoryType;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) loveunloveTalk :(UIButton*) sender
{
    if(sender.tag == 0) {
        [self calServiceWithURL:LOVE_TALK];
        sender.tag = 1;
    }
    else {
        [self calServiceWithURL:UNLOVE_TALK];
        sender.tag = 0;
    }
    
}
- (IBAction) flagunFlagTalk :(UIButton*) sender{
    if(sender.tag == 0) {
        [self calServiceWithURL:FLAG_TALK];
        sender.tag = 1;
    }
    else {
        [self calServiceWithURL:UNFLAG_TALK];
        sender.tag = 0;
    }
}
- (IBAction)favoriteUnFavoriteTalk:(UIButton*)sender
{
    if(sender.tag == 0) {
        [self calServiceWithURL:FAVORITE_TALK];
        sender.tag = 1;
    }
    else {
        [self calServiceWithURL:UNFAVORITE_TALK];
        sender.tag = 0;
    }
}

- (IBAction)btnShare_Pressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Share To Google+",@"Email To Friends",@"Message to Friends", nil];
    actionSheet.tag=3;
    [actionSheet showInView:self.view];
}


- (IBAction)btnEventDate_Pressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Event Date" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add To Calender",@"Copy", nil];
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
}
- (IBAction)btnReview_Pressed:(id)sender {
}

- (IBAction)btnWebsite_Pressed:(id)sender
{
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:self.strWebsite]];
    webBrowser.delegate = self;
    [webBrowser setFixedTitleBarText:menu.title];
    webBrowser.mode = TSMiniWebBrowserModeNavigation;
    webBrowser.postTypeID=  MYFINDS_ID_FOR_REVIEW;
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

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnMap_Pressed:(id)sender
{
    if (self.menu.latitude == nil || !self.menu.latitude)
    {
        return;
    }
    
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    NSArray *modelArray = [[NSArray alloc] initWithObjects:self.menu, nil];
    
    controller.modelArray = modelArray;
    controller.isSingleMapView = YES;
    [controller setPostTypeID:MYFINDS_ID_FOR_REVIEW];
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)btnPhoneNo_Pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Phone Number" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call",@"Copy",@"Add To Contact", nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
}


- (IBAction)taxiBtnPressed:(id)sender
{
    [CommonFunctions makePromptCall:taxiPhoneNo];
}

- (IBAction)btnAddtoCalender_Pressed:(id)sender
{
    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender addEventToCalendar:menu.title description:menu.description startDate:self.menu.startDate endDate:self.menu.endDate link: self.strWebsite location : @""];
}


#pragma mark Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2)
    {
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
        switch (buttonIndex) {
            case 0:
            {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender addEventToCalendar:menu.title description:menu.description startDate:self.menu.startDate endDate:self.menu.endDate link: self.strWebsite location : @""];
            }
                break;
            case 1:
            {
                [CommonFunctions copyTextToClipboard:menu.title];
                
            }
                break;
        }
    }
    if (actionSheet.tag==3){
        if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
        switch (buttonIndex) {
            case 0:
            {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnFaceBookWithTitle:menu.title andInfo:strAddress andThumbnailImage:self.imageForSharing andWebsiteUrl:self.strWebsite ];
                
            }
                break;
            case 1:
            {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnTwitterWithTitle:menu.title andInfo:strAddress andThumbnailImage:self.imageForSharing andWebsiteUrl:self.strWebsite];
                
            }
                break;
            case 2:
            {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender shareOnGooglePlusWithTitle:menu.title andInfo:strAddress andThumbnailUrl:menu.thumbnailURL andWebsiteUrl:self.strWebsite];
            }
                break;
            case 3:
            {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender emailWithTitle:menu.title andInfo:strAddress andThumbnailImage:self.imageForSharing andWebsiteUrl:self.strWebsite];
            }
                break;
            case 4:
            {
                
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender textWithTitle:menu.title andInfo:strAddress andWebsiteUrl:self.strWebsite];            }
                break;
        }
    }
}




- (void) calServiceWithURL:(NSString*)serviceUrl
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:menu.postId forKey:@"postId"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    NSString *latitude = [[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.latitude] stringValue];
    
    NSString *longitude =[[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.longitude] stringValue];
    
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longitude forKey:@"longitude"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}

#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    
    self.mainScroll.scrollEnabled = YES;
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOVE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,SUBMIT_FIND]])
    {
        if ([[responseData objectForKey:@"result"] isEqualToString:@"true"])
        {
            self.sender = [[CommonFunctions alloc] initWithParent:self];
            [self.sender displayNotification:YES];

        }
        
        else if ([[responseData objectForKey:@"result"] isEqualToString:@"false"])
        {
            if ([[responseData objectForKey:@"error"] isEqualToString:@"Already Submitted"])    
                [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ALREADY_SUMBITTED_FIND];
            else {
                self.sender = [[CommonFunctions alloc] initWithParent:self];
                [self.sender displayNotification:NO];
            }

        }
        else if ([[responseData objectForKey:@"result"] isEqualToString:@"false"])
        {
            self.sender = [[CommonFunctions alloc] initWithParent:self];
            [self.sender displayNotification:NO];
        }
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNLOVE_TALK]])
    {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,FAVORITE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNFAVORITE_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,FLAG_TALK]]) {
        
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNFLAG_TALK]]) {
        
    }else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_TALK]])
    {
        NSLog(@"detail=%@",responseData);
        
        if ([[responseData objectForKey:@"result"] isEqualToString:@"true"])
        {
            [self displayNotification];
            
            if (self.delegate)
            {
                [self.delegate successfullyDeletedTalk];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }if ([[responseData objectForKey:@"result"] isEqualToString:@"false"]||[[responseData objectForKey:@"result"] isEqualToString:@"error"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                    
                                                              message:MSG_FAILED
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_DETAIL]])
    {
        [[ProcessingView instance] forceHideTintView];
        
        if ( ![[responseData objectForKey:@"data"] isKindOfClass:[NSNull class]] && [responseData objectForKey:@"data"]!=nil )
        {
            NSDictionary * response = [responseData objectForKey:@"data"];
            
           // self.lblWutzwhatFactor=[response objectForKey:@"info"];
            
            [self openGalleryViewWithImages];
            if( ![[response objectForKey:@"info"] isKindOfClass:[NSNull class]] && [response objectForKey:@"info"]!=nil && ![[response objectForKey:@"info"] isEqualToString:@""] ){
                self.lblWutzwhatFactor.text = [response objectForKey:@"info"];
            }
            else{
                self.lblWutzwhatFactor.text = @"";
            }
            
            self.imagesURLModelArray = [ImagesURLModel parseImagesURL:[response objectForKey:@"images"]];
            
            [self openGalleryViewWithImages];
            if( ![[response objectForKey:@"description"] isKindOfClass:[NSNull class]] && [response objectForKey:@"description"]!=nil && ![[response objectForKey:@"description"] isEqualToString:@""] ){
                shortDesc = [response objectForKey:@"description"];
            }
            else{
                shortDesc = @"";
            }
            
            if( ![[response objectForKey:@"end_date"] isKindOfClass:[NSNull class]] && [response objectForKey:@"end_date"]!=nil && ![[response objectForKey:@"end_date"] isEqualToString:@""] ){
                endingDate = [response objectForKey:@"end_date"];
            }
            else{
                endingDate = @"";
            }
            if( ![[response objectForKey:@"start_date"] isKindOfClass:[NSNull class]] && [response objectForKey:@"start_date"]!=nil && ![[response objectForKey:@"start_date"] isEqualToString:@""] ){
                startingdate = [response objectForKey:@"end_date"];
            }
            else{
                startingdate = @"";
            }
            
            
            
            if ( ![[response objectForKey:@"description"] isKindOfClass:[NSNull class]] && [response objectForKey:@"description"]!=nil && ![[response objectForKey:@"description"] isEqualToString:@""] )
            {
                [self setLongDescriptionViewHeight:[response objectForKey:@"description"]];
            }
            else
            {
                [self hideView:self.viewLongDesc];
            }
            
            
            if ( ![[response objectForKey:@"price"] isKindOfClass:[NSNull class]] && [response objectForKey:@"price"]!=nil && ![[response objectForKey:@"price"] isEqualToString:@""] ) {
                
                self.lblPrice.text = [[response objectForKey:@"price"] intValue] == 4 ? @"$$$$" : [[response objectForKey:@"price"] intValue] == 3 ? @"$$$" : [[response objectForKey:@"price"] intValue] == 2 ? @"$$" : [[response objectForKey:@"price"] intValue] == 1 ? @"$" : @"$";
                
                self.lblPriceCell.text = self.lblPrice.text;
                self.lblPriceCell.font = self.lblAddress.font;
                self.lblPriceCell.backgroundColor = [UIColor clearColor];
                self.lblPriceCell.shadowColor=[UIColor whiteColor];
                self.lblPriceCell.shadowOffset=CGSizeMake(0.0f, 1.0f);
                self.lblPriceCell.textAlignment = NSTextAlignmentLeft;
                self.lblPriceCell.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                
            }
            else
            {
                self.lblPrice.text = @"$";
                [self hideView:self.viewPrice];
            }
            
            if ( ![[response objectForKey:@"address"] isKindOfClass:[NSNull class]] && [response objectForKey:@"address"]!=nil && ![[response objectForKey:@"address"] isEqualToString:@""] )
            {
                strAddress= [response objectForKey:@"address"];
                self.lblAddress.text = strAddress;
            }
            else
            {
                [self.btnMap setTitle:@"" forState:UIControlStateNormal] ;
                [self hideView:self.viewMap];
            }
            
            if ( ![[response objectForKey:@"pnumber"] isKindOfClass:[NSNull class]] && [response objectForKey:@"pnumber"]!=nil && ![[response objectForKey:@"pnumber"] isEqualToString:@""] ) {
                callno =[response objectForKey:@"pnumber"];
                
               [self addLabelToButton:self.btnCall withText:callno];
                
            }else{
                [self.btnCall setTitle:@"" forState:UIControlStateNormal] ;
                [self hideView:self.viewCall];
            }
            if ( ![[response objectForKey:@"webLink"] isKindOfClass:[NSNull class]] && [response objectForKey:@"webLink"]!=nil && ![[response objectForKey:@"webLink"] isEqualToString:@""] ) {
                self.strWebsite = [CommonFunctions creatProperURLString:[response objectForKey:@"webLink"]];
                
               [self addLabelToButton:self.btnWebsite withText:[CommonFunctions removeHTTPString:[response objectForKey:@"webLink"]]];
                
            }else{
                self.strWebsite = @"";
                [self.btnWebsite setTitle:@"" forState:UIControlStateNormal] ;
                [self hideView:self.viewWebSite];
                
            }
            
            if ([CommonFunctions isValueExist:[response objectForKey:@"start_date"]] && [CommonFunctions isValueExist:[response objectForKey:@"end_date"]])
            {
                NSString *startDate = [self getDateStringFromTimeStamp:[response objectForKey:@"start_date"]];
                NSString *endDate = [self getDateStringFromTimeStamp:[response objectForKey:@"end_date"]];
                
                [self addLabelToButton:self.btnEvent withText:[NSString stringWithFormat:@"From %@ to %@", startDate, endDate]];
                
                self.menu.startDate = [response objectForKey:@"start_date"];
                self.menu.endDate = [response objectForKey:@"end_date"];
            }
            else
            {
                [self hideView:self.viewEvents];
            }
            
            NSString *postTime = [response valueForKey:@"postTime"];
            
            if (postTime)
            {
                postTime = [postTime stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
                postTime = [postTime stringByReplacingOccurrencesOfString:@")/" withString:@""];
                NSArray *timeArray = [postTime componentsSeparatedByString:@"-"];
                double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
                
                postTimeLong = (postTimeLong/1000);

                NSDate *tr = [NSDate dateWithTimeIntervalSince1970:postTimeLong];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:LIST_CELL_DATE_FORMATE];
                postTime = [formatter stringFromDate:tr];
            }
            
            self.lblPosttime.text = postTime;
            
            if(menu.distance < 0) {
                [self hideView:self.lblDistance];
            } else {
                [self.lblDistance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:[NSNumber numberWithInt:self.menu.distance]]];
                self.distanceImage.hidden = false;
            }
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOVE_TALK]])
    {
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNLOVE_TALK]])
    {
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,FAVORITE_TALK]])
    {
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNFAVORITE_TALK]])
    {
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,FLAG_TALK]])
    {
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UNFLAG_TALK]])
    {
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TALK_DETAIL]])
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        [self.navigationController popViewControllerAnimated:YES];
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

- (BDKNotifyHUD *)notify
{
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}

- (void)displayNotification
{
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}


#pragma mark- Add Label To Button

-(void)addLabelToButton:(UIButton*)button withText:(NSString *)text
{
    UILabel* titleLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(40, -1, button.frame.size.width-30, button.frame.size.height)];
    titleLabel.text = text;
    titleLabel.font = self.lblAddress.font;
    titleLabel.textColor = self.lblAddress.textColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor=[UIColor whiteColor];
    titleLabel.shadowOffset=CGSizeMake(0.0f, 1.0f);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;                    
    [button addSubview:titleLabel];
}


#pragma mark- Dynamic Height Issue

-(void)setLongDescriptionViewHeight:(NSString *)string
{
    CGSize maximumLabelSize = CGSizeMake(self.lblLongDescription.frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize = [string sizeWithFont:self.lblLongDescription.font constrainedToSize:maximumLabelSize lineBreakMode:self.lblLongDescription.lineBreakMode];
    
    CGRect newFrame = self.lblLongDescription.frame;
    
    newFrame.size.height = expectedLabelSize.height;
    
    float differance = newFrame.size.height - self.lblLongDescription.frame.size.height;
    
    self.lblLongDescription.frame = newFrame;
    
    self.lblLongDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblLongDescription.numberOfLines = 0;
    
    self.lblLongDescription.text = string;
    
    [self.lblLongDescription sizeToFit];
    
    [self setNewHeightOfView:self.viewLongDesc difference:differance];
    
    [self dragLowerViewToUpperSide:differance];
    
    self.mainScroll.contentSize = CGSizeMake(self.mainScroll.contentSize.width, self.mainScroll.contentSize.height + differance);
}

-(void)dragLowerViewToUpperSide:(float)difference
{
    [self setNewFrameOfView:self.imgLongDescLine difference:difference];
    
    for (int i = 1; i < [visibleViews count]; i++)
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

-(void)successfullyEditedTalkForCategory:(int)category
{
    if (self.delegate)
    {
        [self.delegate successfullyEditTalk];
    }
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
    
    [self.imgMainProductImage initialize];
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

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
