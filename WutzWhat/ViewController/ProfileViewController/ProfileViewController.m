//
//  ProfileViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/16/12.
//
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "IIViewDeckController.h"
#import "GTLPlusConstants.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GTMOAuth2Authentication.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController ()

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) TWAPIManager *apiManager;
@property (nonatomic, retain) NSArray *accounts;

@end

@implementation ProfileViewController
@synthesize resultDictionary;
@synthesize btnLinkWithGooglePlus=_btnLinkWithGooglePlus;
@synthesize btnSignoutTwitter=_btnSignoutTwitter;
@synthesize activityIndicatorView=_activityIndicatorView;
@synthesize activityIndicator=_activityIndicator;
@synthesize scroll=_scroll;
@synthesize lblLinkWithGooglePP = _lblLinkWithGooglePP;
@synthesize lblLinkWithFacebook = _lblLinkWithFacebook;
@synthesize lblLinkWithTwitter = _lblLinkWithTwitter;




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _accountStore = [[ACAccountStore alloc] init];
        _apiManager = [[TWAPIManager alloc] init];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(sessionStateChanged:)
         name:FBSessionStateChangedNotification
         object:nil];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [_imgProfilePic release];
    [self setImgProfilePic:nil];
    [_lblUsername release];
    [self setLblUsername:nil];
    [_lblEmail release];
    [self setLblEmail:nil];
    [_txtBaseCity release];
    [self setTxtBaseCity :nil];
    [_btnLinkWithFacebook release];
    [self setBtnLinkWithFacebook:nil];
    [_btnLinkWithTwitter release];
    [self setBtnLinkWithTwitter:nil];
    [_lblCity release];
    [self setLblCity:nil];
    [_btnLinkWithGooglePlus release];
    [self setBtnLinkWithGooglePlus:nil];
    [_btnSignoutTwitter release];
    [self setBtnSignoutTwitter:nil];
    [_accountStore release];
    _accountStore = nil;
    [_apiManager release];
    _apiManager = nil;
    [_accounts release];
    _accounts = nil;
    [_lblLinkWithGooglePP release];
    _lblLinkWithGooglePP = nil;
    [donebar release];
    [birthdayPicker release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    [self setUpHeaderView];
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    AppDelegate *appDelegate = [self getAppDelegateInstance];
    resultDictionary = appDelegate.facebookData;
    
    _lblEmail.text=[resultDictionary objectForKey:@"email"];
    _lblUsername.text=[resultDictionary objectForKey:@"username"];
    _lblCity.text=[resultDictionary objectForKey:@"city"];
    _lblCity.textColor=[UIColor colorFromHexString:@"#4D4D4D"];
    _lblUsername.textColor=[UIColor colorFromHexString:@"#4D4D4D"];
    
    _imgProfilePic.layer.cornerRadius = 6.0;
    _imgProfilePic.clipsToBounds = YES;
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshTwitterAccounts)
     name:ACAccountStoreDidChangeNotification
     object:nil];
    
    //    [[SharedManager sharedManager] loadTwitterUsernameToDisk];
    
    if(OS_VERSION>=7)
    {
        if(IS_IPHONE_5)
            self.scroll.frame=CGRectMake(0,40,320,530);
        else
            self.scroll.frame=CGRectMake(0,40,320,440);
        
    }
    [self.scroll setContentSize:CGSizeMake(320, 760)];
    [self.scroll setScrollEnabled:YES];
    self.scroll.bounces = self.scroll.bouncesZoom = false;

    [self.btnLinkWithGooglePlus setFrame:CGRectMake(20,self.btnLinkWithTwitter.frame.origin.y + 10 + self.btnLinkWithTwitter.frame.size.height,280,40)];
    [self setUpGooglePlusButton];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self refreshTwitterAccounts];
    
    self.lblLinkWithTwitter = [self createLabelForButton:@"Link with Twitter" withShadowColor:[UIColor colorWithRed:0.0f green:170.0/255.0f blue:170.0/255.0f alpha:1.0f] ];
    
    if ([[SharedManager sharedManager] loadTwitterUsernameToDisk])
    {
        //        [self.btnLinkWithTwitter setEnabled:NO];
        
        self.lblLinkWithTwitter.text = [[SharedManager sharedManager] twitterAuthenticationUsername];
        
        [[SharedManager sharedManager] setTwitterAuthenticationUsername:[[SharedManager sharedManager] twitterAuthenticationUsername]];
    }else
    {
        [self.btnLinkWithTwitter setEnabled:YES];
    }
    
    [self.btnLinkWithTwitter addSubview:self.lblLinkWithTwitter];
    
    self.lblLinkWithFacebook = [self createLabelForButton:@"Link with Facebook" withShadowColor:[UIColor blackColor]];
    [self.btnLinkWithFacebook addSubview:self.lblLinkWithFacebook];
    
    //Facebook
    [self sessionStateChanged:nil];
    //Googleplus
    [self reportAuthStatus];
    
    [self setUpDefaultButtons];
    [self createDatePicker];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"] != nil)
    {
        [self getProfileImage];
        
    }else
    {
        [self getFBImage];
    }

}

- (void)setUpDefaultButtons
{
    if(!DEFAULT_SORTING_VALUE){
        SET_DEFAULT_SORTING(0);
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSArray *labels = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"sort_latest.png", @"sort_latest_c.png", nil],[NSArray arrayWithObjects:@"sort_distance.png", @"sort_distance_c.png", nil], nil];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton new];
        [button setImage:[UIImage imageNamed:labels[i][0]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:labels[i][1]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:labels[i][1]] forState:UIControlStateSelected];
        button.frame = CGRectMake((((UIImage *)[UIImage imageNamed:labels[i][0]]).size.width * i) + 20, self.defaultSettingsLabel.frame.origin.y + self.defaultSettingsLabel.frame.size.height, ((UIImage *)[UIImage imageNamed:labels[i][0]]).size.width, ((UIImage *)[UIImage imageNamed:labels[i][0]]).size.height);
        button.tag = i;
        if(button.tag == [DEFAULT_SORTING_VALUE integerValue])
            button.selected = TRUE;
        [button addTarget:self action:@selector(defaultButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:button];
    }
}

- (void)defaultButtonClicked:(UIButton *)bClicked
{
    SET_DEFAULT_SORTING(bClicked.tag);
    [[NSUserDefaults standardUserDefaults] synchronize];
    for (UIButton *b in self.scroll.subviews) {
        if([b isKindOfClass:[UIButton class]]) {
            b.selected = FALSE;
            if(b == bClicked)
                b.selected = TRUE;
        }
    }
}

- (UILabel *)createLabelForButton:(NSString *)lbl withShadowColor:(UIColor *)sC
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 225, 36)];
    
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:HELVETIC_NEUE_BOLD size:16];
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, -1.0f);
    label.layer.shadowOpacity = 0.3f;
    label.layer.shadowRadius = 0.5f;
    label.clipsToBounds = FALSE;
    label.text = lbl;
    
    
    return label;
}


#pragma mark -
#pragma mark Google Plus
#pragma mark -

-(void)setUpGooglePlusButton
{
    
    self.lblLinkWithGooglePP = [self createLabelForButton:@"Link to Google+" withShadowColor:[UIColor colorWithRed:160.0/255.0f green:61.0/255.0f blue:53.0/255.0f alpha:1.0f]];

    [self.btnLinkWithGooglePlus setImage:[UIImage imageNamed:@"btn_gg.png"] forState:UIControlStateNormal];
    [self.btnLinkWithGooglePlus setImage:[UIImage imageNamed:@"btn_gg_c.png"] forState:UIControlStateHighlighted];
    [self.btnLinkWithGooglePlus setImage:[UIImage imageNamed:@"btn_gg.png"] forState:UIControlStateDisabled];
    
    [self.btnLinkWithGooglePlus addTarget:self action:@selector(gpSignInOut) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnLinkWithGooglePlus addSubview:self.lblLinkWithGooglePP];
    
    [GPPSignInButton class];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.actions = [NSArray arrayWithObjects:
                      @"http://schemas.google.com/AddActivity",
                      @"http://schemas.google.com/BuyActivity",
                      @"http://schemas.google.com/CheckInActivity",
                      @"http://schemas.google.com/CommentActivity",
                      @"http://schemas.google.com/CreateActivity",
                      @"http://schemas.google.com/ListenActivity",
                      @"http://schemas.google.com/ReserveActivity",
                      @"http://schemas.google.com/ReviewActivity",
                      nil];
    
    [signIn trySilentAuthentication];
    
    [self reportAuthStatus];
}

#pragma mark -
#pragma mark Navigation Bar
#pragma mark -
-(void)setUpHeaderView
{
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    UIImage *backButton = [UIImage imageNamed:@"top_menu.png"];
    UIImage *forwardButton = [UIImage imageNamed:@"top_edit.png"];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_menu_c.png"];
    UIImage *forwardButtonPressed = [UIImage imageNamed:@"top_edit_c.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, forwardButton.size.width, forwardButton.size.height)];
    [v addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn addTarget:self action:@selector(editBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [editBtn setImage:forwardButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [editBtn setImage:forwardButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    UIBarButtonItem *rightbtnItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [[self navigationItem]setRightBarButtonItem:rightbtnItem ];
    
    UIImageView *titleIV1 = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_profile.png"]];
    [[self navigationItem]setTitleView:titleIV1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getProfileImage
{
    if ([(AppDelegate *)[self getAppDelegateInstance] facebookData] && [[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"] && ![[[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"] isKindOfClass:[NSNull class]] && ![[[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"] isEqual:[NSNull null]])
    {
        
        int length = [[[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"] length];
        
        if (length > 1000)
        {
            NSData *imgData = [Base64 decode:[[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"]];
            
            [_imgProfilePic setImage:[UIImage imageWithData:imgData]];
        }
        else
        {
            [_imgProfilePic setImageWithURL:[NSURL URLWithString:[[(AppDelegate *)[self getAppDelegateInstance] facebookData] objectForKey:@"profilePicture"]] placeholderImage:_imgProfilePic.image];
        }
    }
}

- (void) getFBImage
{
    if (![[resultDictionary objectForKey:@"id"] isEqualToString:@""])
    {
        NSString *string=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=105&height=109",[resultDictionary objectForKey:@"id"]];
        NSURL *url = [NSURL URLWithString:string];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        UIImage *tmpImage = [[UIImage alloc] initWithData:data];
        
        [_imgProfilePic setImage:tmpImage];
    }
}

- (void) backBtnTapped:(id)sender
{
    
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void) editBtnTapped:(id)sender
{
    EditProfileViewController *evc=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    [self.navigationController pushViewController:evc animated:YES];
}




- (void)viewDidUnload
{
    [self setImgProfilePic:nil];
    [self setLblUsername:nil];
    [self setTxtBaseCity:nil];
    [self setBtnLinkWithFacebook:nil];
    [self setBtnLinkWithTwitter:nil];
    [self setLblCity:nil];
    [self setLblEmail:nil];
    [self setScroll:nil];
    [super viewDidUnload];
}



#pragma mark -
#pragma mark Button Actions
#pragma mark -

- (void)gpSignInOut {
    
    [[GPPSignIn sharedInstance] signOut];
    
    [self reportAuthStatus];
}

- (IBAction)disconnect:(id)sender {
    [[GPPSignIn sharedInstance] disconnect];
}
- (IBAction)btnLogout_clicked:(id)sender
{
    [self performSelectorOnMainThread:@selector(logoutx) withObject:nil waitUntilDone:NO];
}


- (IBAction)btnLinkWithFacebook_Pressed:(id)sender
{
    [self showActivityIndicatorInView:YES];
    
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    else
    {
        [self openSessionWithAllowLoginUI:YES];
    }
}

- (IBAction)btnLinkWithTwitter_Pressed:(id)sender
{
    
    [self performReverseAuth:sender];
}

- (IBAction)btnDeleteAccount_Pressed:(id)sender
{
    [self askPassword];
}

#pragma mark -
#pragma mark Delete Account
#pragma mark -

- (void)createDatePicker
{
    birthdayPicker = [[UIDatePicker alloc] init];
    [birthdayPicker setDatePickerMode:UIDatePickerModeDate];
    [birthdayPicker setMaximumDate:[NSDate date]];
    [birthdayPicker setFrame:CGRectMake(0, self.view.frame.size.height - birthdayPicker.frame.size.height, birthdayPicker.frame.size.width, birthdayPicker.frame.size.height)];
    
    donebar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, birthdayPicker.frame.origin.y - 50, self.view.frame.size.width, 50)];
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(donePressed)] autorelease];
    doneButton.width = 50;
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleBordered target: self action: @selector(cancelPressed)] autorelease];
    cancelButton.width = 50;
    donebar.items = [NSArray arrayWithObjects: doneButton,cancelButton,nil];

}

- (void)cancelPressed
{
    [birthdayPicker removeFromSuperview];
    [donebar removeFromSuperview];
}

- (void)donePressed
{
    
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    
    
    [self deleteAccountCall:[formatter stringFromDate:birthdayPicker.date] isBirthday:true];
}

- (void)askPassword {
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] isEqualToString:@"facebook"])
    {
        [self.view addSubview:donebar];
        
        [self.view addSubview:birthdayPicker];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:MSG_ENTER_PASSWORD
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Ok",nil];
        
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        message.tag = 99;
        
        [message show];
    }
}

-(void)logoutx
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MSG_LOGOUT delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
    alert.tag=199;
    [alert show];
    return;
}

- (void)deleteAccountCall:(NSString *)password isBirthday:(BOOL)birthday
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:birthday ? password : [CommonFunctions encryptPassword:password] forKey:@"password"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_PROFILE] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99)
    {
        if (buttonIndex == 1)
        {
            [self deleteAccountCall:[[alertView textFieldAtIndex:0] text] isBirthday:false];
        }
        
    }
    if(alertView.tag == 199){
        
        if (buttonIndex == 1)
        {
            [self showActivityIndicatorInView:YES];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
            [params setValue:[NSString stringWithFormat:@"%@",[CommonFunctions getDeviceUUID]] forKey:@"deviceID"];
            DataFetcher *fetcher  = [[DataFetcher alloc] init];
            [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGOUT_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
            
            
            
            
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
            [CommonFunctions setAppBadgeNumber:0];
            
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            //Zeeshan for Logout
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (appDelegate.facebookData && appDelegate.facebookData != nil)
            {
                appDelegate.facebookData=@
                {
                    @"username": @"",
                    @"city":@"",
                    @"profilePicture":@"",
                    @"id":@"",
                    @"email":@"",
                    @"distance_unit":@"",
                    @"country_code":@""
                };
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"profilePicture"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_email"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_password"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hiddenLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
            //Zeeshan check for Autologin : NO
            NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@NO,@"",@"",@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
            [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
            [[SharedManager sharedManager] saveSessionToDisk];
             NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

        }
    }
    
    
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag == 199) {
        return YES;
    }
    
    NSString *password = [[alertView textFieldAtIndex:0] text];
    [alertView textFieldAtIndex:0].secureTextEntry=YES;
    if( [password length] >= 3 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -
#pragma mark DataFetcher Delegates
#pragma mark -
- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    if([[responseData valueForKey:@"result"] isKindOfClass:[NSNull class]]) {
        [Utiltiy showAlertWithTitle:@"Delete Error " andMsg:MSG_FAILED];
        [self showActivityIndicatorInView:FALSE];
        return;
    }
    
    //Zeeshan Previously done Like That
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@%@&image_width=122&image_height=122",BASE_URL,GET_USER_DATA,access_token]])
    {
        [self.lblLinkWithFacebook setText:[[responseData objectForKey:@"data"]  objectForKey:@"user_name"]];
        [self.lblLinkWithFacebook setTextColor:[UIColor grayColor]];
        self.btnLinkWithFacebook.enabled=NO;
        [[SharedManager sharedManager] setFacebookAuthenticationUsername:[[responseData objectForKey:@"data"]  objectForKey:@"user_name"]];
        [[SharedManager sharedManager] saveFacebookUsernameToDisk];
    }
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGOUT_URL]])
    {
        if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
        {
            [CommonFunctions setAppBadgeNumber:0];
            
            AppDelegate *appDelegate = [self getAppDelegateInstance];
            //Zeeshan for Logout
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (appDelegate.facebookData && appDelegate.facebookData != nil)
            {
                appDelegate.facebookData=@
                {
                    @"username": @"",
                    @"city":@"",
                    @"profilePicture":@"",
                    @"id":@""
                };
            }
            //Zeeshan check for Autologin : NO
            NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@NO,@"",@"",@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
            [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
            [[SharedManager sharedManager] saveSessionToDisk];
            
            //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
            //            NSString *documentsDir = [paths objectAtIndex:0];
            //            NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"Twitteruser.plist"];
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            //                [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
            //            }
            
            //            [self btnGPsignOut_Pressed:nil];
            [self showActivityIndicatorInView:NO];
            UINavigationController *navController = (UINavigationController *)appDelegate.window.rootViewController;
            NSArray *vcs = navController.viewControllers;
            for (UIViewController *vc in vcs) {
                if ([vc isKindOfClass:[LoginViewController class]]) {
                    [navController popToRootViewControllerAnimated:YES];
                    break;
                }
            }
            
            //            NSLog(@"vcs->count%d",vcs.count);
        }
        else if([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 401) // if ([[responseData valueForKey:@"result"] isEqualToString:@"fail"]) {
        {
            [Utiltiy showAlertWithTitle:@"Logout Error " andMsg:MSG_FAILED];
        }
        else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 200) {
            AppDelegate *appDelegate = [self getAppDelegateInstance];
            appDelegate.facebookData=@{
                                       @"username": [appDelegate.facebookData objectForKey:@"username"],
                                       @"city":[appDelegate.facebookData objectForKey:@"city"],
                                       @"profilePicture":@"",
                                       @"id":@""
                                       };
        }
    }
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_PROFILE]]) {
        
        if ([[responseData valueForKey:@"result"] isEqualToString:@"true"]){
            [DataFetcher logoutOfApp];
            [Utiltiy showAlertWithTitle:@"Deactivate User" andMsg:MSG_SUCCESS_DELETE_USER];
            [self cancelPressed];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Delete Error " andMsg:[responseData valueForKey:@"message"]];
        }
    }
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    //NSLog(@"response=%@",responseData);
}



#pragma mark -
#pragma mark GPPSignInDelegate
#pragma mark -

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error)
        return;
    NSLog(@"%@",auth.accessToken);
    [self reportAuthStatus];
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
- (void)reportAuthStatus
{    
    if ([GPPSignIn sharedInstance].authentication)
    {
        NSString *gplusAccount = [[[GPPSignIn sharedInstance] authentication] userEmail];
        [self showActivityIndicatorInView:NO];
        if(gplusAccount.length > 24)
            gplusAccount = [NSString stringWithFormat:@"%@...",[gplusAccount substringToIndex:19]];
        [self.lblLinkWithGooglePP setText:gplusAccount];
    }
    else
    {
        [self.lblLinkWithGooglePP setText:@"Link to Google+"];
        [self showActivityIndicatorInView:NO];
    }
}

- (void)retrieveUserInfo
{
}




#pragma mark -
#pragma mark Appdelegate
#pragma mark -

-(AppDelegate*)getAppDelegateInstance
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate;
}


#pragma mark -
#pragma mark Twitter
#pragma mark -

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != (actionSheet.numberOfButtons - 1)) {
        [[ProcessingView instance] showTintView];
        [_apiManager
         performReverseAuthForAccount:_accounts[buttonIndex]
         withHandler:^(NSData *responseData, NSError *error) {
             if (responseData) {
                 NSString *responseStr = [[NSString alloc]
                                          initWithData:responseData
                                          encoding:NSUTF8StringEncoding];
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    NSString *subString = [[responseStr componentsSeparatedByString:@"="] lastObject];
                                    if (subString.length > 30)
                                    {
                                        [[ProcessingView instance] hideTintView];
                                        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_TWITTER_RELOGIN];
                                        return;
                                    }
                                    [[ProcessingView instance] hideTintView];
                                    [Utiltiy showAlertWithTitle:@"Done" andMsg:MSG_SUCCESS];
                                    //                     [self.btnLinkWithTwitter setEnabled:NO];
                                    [self setTwitterButtonDefaultTitleWithText:subString];
                                    
                                    [[SharedManager sharedManager] setTwitterAuthenticationUsername:subString];
                                    [[SharedManager sharedManager] saveTwitterUsernameToDisk];
                                    [self showActivityIndicatorInView:NO];
                                });
                 [self showActivityIndicatorInView:YES];
             }
             else {
                 NSLog(@"Error!\n%@", [error localizedDescription]);
             }
         }];
    }
}

#pragma mark - Private

- (void)refreshTwitterAccounts
{
    //  Get access to the user's Twitter account(s)
    [self obtainAccessToAccountsWithBlock:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                //                _btnLinkWithTwitter.enabled = FALSE;
                
            }
            else {
                //                _btnLinkWithTwitter.enabled = YES;
                NSLog(@"You were not granted access to the Twitter accounts.");
            }
        });
    }];
}

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL))block
{
    ACAccountType *twitterType = [_accountStore
                                  accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler handler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            self.accounts = [_accountStore accountsWithAccountType:twitterType];
        }
        
        block(granted);
    };
    
    //  This method changed in iOS6.  If the new version isn't available, fall
    //  back to the original (which means that we're running on iOS5+).
    if ([_accountStore
         respondsToSelector:@selector(requestAccessToAccountsWithType:
                                      options:
                                      completion:)]) {
             [_accountStore requestAccessToAccountsWithType:twitterType
                                                    options:nil
                                                 completion:handler];
         }
    else {
        [_accountStore requestAccessToAccountsWithType:twitterType options:nil completion:handler];
    }
    
}
- (void)storeAccountWithAccessToken:(NSString *)token secret:(NSString *)secret
{
    //  Each account has a credential, which is comprised of a verified token and secret
    ACAccountCredential *credential =
    [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    
    //  Obtain the Twitter account type from the store
    ACAccountType *twitterAcctType =
    [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Create a new account of the intended type
    ACAccount *newAccount = [[ACAccount alloc] initWithAccountType:twitterAcctType];
    
    //  Attach the credential for this user
    newAccount.credential = credential;
    
    //  Finally, ask the account store instance to save the account
    //  Note: that the completion handler is not guaranteed to be executed
    //  on any thread, so care should be taken if you wish to update the UI, etc.
    [_accountStore saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            // we've stored the account!
            NSLog(@"the account was saved!");
        }
        else {
            //something went wrong, check value of error
            NSLog(@"the account was NOT saved");
            
            // see the note below regarding errors...
            //  this is only for demonstration purposes
            if ([[error domain] isEqualToString:ACErrorDomain]) {
                
                // The following error codes and descriptions are found in ACError.h
                switch ([error code]) {
                    case ACErrorAccountMissingRequiredProperty:
                        NSLog(@"Account wasn't saved because "
                              "it is missing a required property.");
                        break;
                    case ACErrorAccountAuthenticationFailed:
                        NSLog(@"Account wasn't saved because "
                              "authentication of the supplied "
                              "credential failed.");
                        break;
                    case ACErrorAccountTypeInvalid:
                        NSLog(@"Account wasn't saved because "
                              "the account type is invalid.");
                        break;
                    case ACErrorAccountAlreadyExists:
                        NSLog(@"Account wasn't added because "
                              "it already exists.");
                        break;
                    case ACErrorAccountNotFound:
                        NSLog(@"Account wasn't deleted because"
                              "it could not be found.");
                        break;
                    case ACErrorPermissionDenied:
                        NSLog(@"Permission Denied");
                        break;
                    case ACErrorUnknown:
                    default: // fall through for any unknown errors...
                        NSLog(@"An unknown error occurred.");
                        break;
                }
            } else {
                // handle other error domains and their associated response codes...
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    }];
    [[ProcessingView instance] hideTintView];
}
- (void)performReverseAuth:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet]) {
        UIActionSheet *sheet = [[UIActionSheet alloc]
                                initWithTitle:@"Choose an Account"
                                delegate:self
                                cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                otherButtonTitles:nil];
        
        for (ACAccount *acct in _accounts) {
            [sheet addButtonWithTitle:acct.username];
        }
        
        [sheet addButtonWithTitle:@"Cancel"];
        [sheet setDestructiveButtonIndex:[_accounts count]];
        [sheet showInView:self.view];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Accounts"
                              message:@"Please configure a Twitter "
                              "account in Settings.app"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark Facebook Session Check
#pragma mark -
- (void)sessionStateChanged:(NSNotification*)notification
{

    if ([FBSession activeSession].isOpen)
    {
        [self.btnLinkWithFacebook setEnabled:YES];
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error)
            {
                for (id l in self.btnLinkWithFacebook.subviews) {
                    if([l isKindOfClass:[UILabel class]])
                        ((UILabel *)l).text = user.username;
                }
            }
            [self showActivityIndicatorInView:NO];
        }];
    } else
    {
        [self setFacebookButtonDefaultTitleWithText:@"Link to Facebook"];
        [self showActivityIndicatorInView:NO];
        [self.btnLinkWithFacebook setEnabled:YES];
    }
}

-(void)setFacebookButtonDefaultTitleWithText:(NSString *)string
{
    for (id l in self.btnLinkWithFacebook.subviews) {
        if([l isKindOfClass:[UILabel class]])
            ((UILabel *)l).text = string;
    }
}

-(void)setTwitterButtonDefaultTitleWithText:(NSString *)string
{
    for (id l in self.btnLinkWithTwitter.subviews) {
        if([l isKindOfClass:[UILabel class]])
            ((UILabel *)l).text = string;
    }
}


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    BOOL returnValue = true;
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            @"user_birthday",
                            nil];
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    [FBSession setActiveSession:session];
    //    [FBSession openActiveSessionWithReadPermissions:permissions
    //                                                            allowLoginUI:false
    //                                                       completionHandler:^(FBSession *session,
    //                                                                           FBSessionState state,
    //                                                                           NSError *error) { }];
    
    [session openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        [params setValue:session.accessTokenData.accessToken forKey:@"facebook_token"];
        
        DataFetcher *fetcher  = [[[DataFetcher alloc] init] autorelease];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,SEND_SOCIAL_ACCESS_TOKENS] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
        [self sessionStateChanged:nil];
    }];
    
    return returnValue;
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error)
            {
                [self.btnLinkWithFacebook setEnabled:YES];
                
                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    if (!error) {
                        NSString *name = user.username;
                        //NSString *email = [user objectForKey:@"email"];
                        [self.lblLinkWithFacebook setText:[NSString stringWithFormat:@"%@",name]];
                        [self showActivityIndicatorInView:NO];
                        //NSLog(@"Access Token : %@ , User Email %@ , Email %@", [[FBSession activeSession] accessToken],user.name,[user objectForKey:@"email"]);
                    }
                }];
            }
            break;
        case FBSessionStateClosed:
            [self showActivityIndicatorInView:NO];
            [self.btnLinkWithFacebook setEnabled:YES];
            [self setFacebookButtonDefaultTitleWithText:@"Link to Facebook"];
            break;
        case FBSessionStateClosedLoginFailed:
            [self showActivityIndicatorInView:NO];
            [self.btnLinkWithFacebook setEnabled:YES];
            [self setFacebookButtonDefaultTitleWithText:@"Link to Facebook"];
            break;
        default:
            break;
    }
}
#pragma mark - Show Activity Indicator

-(void)showActivityIndicatorInView:(BOOL)show
{
    if (show)
    {
        [self.view setUserInteractionEnabled:NO];
        self.activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2-15, ([UIScreen mainScreen].bounds.size.height)/2 - 80, 32, 32)];
        
        [self.activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        [self.activityIndicatorView setAlpha:0.4f];
        [self.activityIndicatorView.layer setCornerRadius:5.0f];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.activityIndicator setBackgroundColor:[UIColor clearColor]];
        
        [self.activityIndicator startAnimating];
        self.activityIndicator.center = CGPointMake(16, 16);
        
        [self.activityIndicatorView addSubview:self.activityIndicator];
        
        [self.view addSubview:self.activityIndicatorView];
    }
    else
    {
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        [self.activityIndicatorView removeFromSuperview];
    }
}
@end
