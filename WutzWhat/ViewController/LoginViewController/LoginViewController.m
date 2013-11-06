//
//  LoginViewController.m
//  WutzWhat
//
//  Created by My Mac on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTalkViewController.h"
#import "LoginViewController.h"
#import "DataFetcher.h"
#import "Constants.h"
#import "Reachability.h"
#import "JSON.h"
#import "Utiltiy.h"
#import "SharedManager.h"
#import "SignupViewController.h"
#import "FacebookSignupViewController.h"
#import "WutzWhatListViewController.h"
#import "ProcessingView.h"
#import "InitialViewController.h"

#import "LoginWithoutScreen.h"

@implementation LoginViewController

@synthesize emailString=_emailString;
@synthesize access_token;
@synthesize btnLoginWithFacebook;
@synthesize btnLogin;
@synthesize btnForgotPassword;
@synthesize btnSignup;
@synthesize btnExplore;
@synthesize facebookUserData;
@synthesize btnTour=_btnTour;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

#pragma mark - View Delegates

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setBtnLoginWithFacebook:nil];
    [self setBtnLogin:nil];
    [self setBtnForgotPassword:nil];
    [self setBtnSignup:nil];
    [self setBtnExplore:nil];
    [self setLblLoginTitle:nil];
    [self setLogoWutzwhat:nil];
    [self setDescription:nil];
    [self setImgUsername:nil];
    [self setTxtPassword:nil];
    [self setImgUsername:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.45f];
    [self.navigationController.navigationBar setAlpha:0.0f];
    [UIView commitAnimations];
    
    //Notifications tab in the menu is set as the index so when the menu is opened it shows you when you were
    if ([CommonFunctions isRemoteNotificationClicked])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:8] forKey:@"indexpathmenu"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:0 forKey:@"indexpathmenu"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateViewsForFormValidity];
    
    [[SharedManager sharedManager] loadSessionFromDisk];
    
    if ( ![[[SharedManager sharedManager] sessionDictionay] isKindOfClass:[NSNull class]]
        && ![[[SharedManager sharedManager] sessionDictionay] isEqual:nil] )
    {
        //Zeeshan if logged already for Autologin
        if([[[SharedManager sharedManager] sessionDictionay] valueForKey:@"IsLoggedInAlready"])
        {
            //opens the session text file and checks if you're logged in already - this could be used outside of the login screen and it could bypass it all together
            NSString *registerType = [[[SharedManager sharedManager] sessionDictionay] valueForKey:@"RegisterType"];
            //Zeeshan if logged via Facebook
            if([registerType isEqualToString:@"facebook"])
            {
                if ([[SharedManager sharedManager] isNetworkAvailable])
                {
                    isFacebookLogin = YES;
                    [FacebookWrapper openSessionWithAllowLoginUI:NO];
                }
                else
                {
                    [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
                }
            }
            else if ([registerType isEqualToString:@"email"])
            {
                _txtEmail.text=[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Email"];
//                _txtPassword.text=[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Password"];
                if ([[SharedManager sharedManager] isNetworkAvailable])
                {
                    isFacebookLogin=NO;
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    
                    if ([self validateEmail: _txtEmail.text])
                    {
                        [params setValue:_txtEmail.text  forKey:@"user_email"];
                    }
                    else
                    {
                        [params setValue:_txtEmail.text  forKey:@"user_name"];
                    }
                    
                    [params setValue:[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Password"] forKey:@"user_password"];
                    [params setValue:@"email" forKey:@"login_type"];
                    [params setValue:[CommonFunctions getDeviceUUID] forKey:@"deviceID"];
                    
                    DataFetcher *fetcher  = [[DataFetcher alloc] init];
                    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
                    
                    [[ProcessingView instance] forceShowTintView];
                }
                else
                {
                    [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
                }
            }
        }
        else
        {
            _txtEmail.placeholder=@"Username or Email";
            _txtPassword.placeholder=@"Password";
            self.txtPassword.text=  @"";
            self.txtEmail.text=@"";
        }
        
    }
    else
    {
        _txtEmail.placeholder=@"Username or Email";
        _txtPassword.placeholder=@"Password";
        self.txtPassword.text=  @"";
        self.txtEmail.text=@"";
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateViewsForFormValidity];
}

- (void)viewDidLoad
{
    //if they just installed the app these will be null so I give them default values
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"Login view reached %@ , %@ , %f", self.description, [NSDate date],OS_VERSION]];
    if(!FIRST_LOGIN)
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"firstLogin"];
    
    if(!FIRST_LOGIN_TOUR_FINISHED)
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"firstLoginTourDone"];
    
    if (IS_IPHONE_5)
    {
        self.view.frame = CGRectMake(0, 0, 320, 550);
        
        self.logoWutzwhat.frame= CGRectMake(self.logoWutzwhat.frame.origin.x, self.logoWutzwhat.frame.origin.y+20, self.logoWutzwhat.frame.size.width, self.logoWutzwhat.frame.size.height);
        
        self.btnLoginWithFacebook.frame= CGRectMake(self.btnLoginWithFacebook.frame.origin.x, self.btnLoginWithFacebook.frame.origin.y+30, self.btnLoginWithFacebook.frame.size.width, self.btnLoginWithFacebook.frame.size.height);
        
        self.description.frame= CGRectMake(self.description.frame.origin.x, self.description.frame.origin.y+30, self.description.frame.size.width, self.description.frame.size.height);
        
        self.imgUsername.frame= CGRectMake(self.imgUsername.frame.origin.x, self.imgUsername.frame.origin.y+40, self.imgUsername.frame.size.width, self.imgUsername.frame.size.height);
        self.txtEmail.frame= CGRectMake(self.txtEmail.frame.origin.x, self.txtEmail.frame.origin.y+40, self.txtEmail.frame.size.width, self.txtEmail.frame.size.height);
        self.txtPassword.frame= CGRectMake(self.txtPassword.frame.origin.x, self.txtPassword.frame.origin.y+40, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);
        self.btnLogin.frame= CGRectMake(self.btnLogin.frame.origin.x, self.btnLogin.frame.origin.y+40, self.btnLogin.frame.size.width, self.btnLogin.frame.size.height);
        self.btnSignup.frame= CGRectMake(self.btnSignup.frame.origin.x, self.btnSignup.frame.origin.y+50,self.btnSignup.frame.size.width, self.btnSignup.frame.size.height);
        self.btnForgotPassword.frame= CGRectMake(self.btnForgotPassword.frame.origin.x, self.btnForgotPassword.frame.origin.y+45, self.btnForgotPassword.frame.size.width, self.btnForgotPassword.frame.size.height);
        self.btnExplore.frame= CGRectMake(self.btnExplore.frame.origin.x, self.btnExplore.frame.origin.y+50, self.btnExplore.frame.size.width, self.btnExplore.frame.size.height);
        self.btnTour.frame= CGRectMake(self.btnTour.frame.origin.x, self.btnTour.frame.origin.y+50, self.btnTour.frame.size.width, self.btnTour.frame.size.height);
    }
    else
    {
        
//        self.view.frame = CGRectMake(0,0, 320, 460);
//        self.logoWutzwhat=[[UIImageView alloc]initWithFrame:CGRectMake(35,25,250,75)];
//        self.logoWutzwhat.image=[UIImage imageNamed:@"logo_login.png"];
//        
//        [self.view addSubview:self.logoWutzwhat];
    }
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [super viewDidLoad];
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
        
    self.view.backgroundColor =[UIColor colorFromHexString:@"#333"];
        
    [self.txtPassword addTarget:self action:@selector(validateForm) forControlEvents:UIControlEventEditingChanged];
    [self.txtEmail addTarget:self action:@selector(validateForm) forControlEvents:UIControlEventEditingChanged];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FilterViewController"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"indexpathmenu"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
   
    
   
    
    [[SharedManager sharedManager] loadSessionFromDisk];
    
    if ( ![[[SharedManager sharedManager] sessionDictionay] isKindOfClass:[NSNull class]]
        && ![[[SharedManager sharedManager] sessionDictionay] isEqual:nil] )
    {
        //Zeeshan if logged already for Autologin
        if([[[SharedManager sharedManager] sessionDictionay] valueForKey:@"IsLoggedInAlready"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"hidden"  forKey:@"hiddenLogin"];
            //opens the session text file and checks if you're logged in already - this could be used outside of the login screen and it could bypass it all together
            NSString *registerType = [[[SharedManager sharedManager] sessionDictionay] valueForKey:@"RegisterType"];
            //Zeeshan if logged via Facebook
            if([registerType isEqualToString:@"facebook"])
            {
                if ([[SharedManager sharedManager] isNetworkAvailable])
                {
                    isFacebookLogin = YES;
                    [FacebookWrapper openSessionWithAllowLoginUI:NO];
                }
                else
                {
                    [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
                }
            }
            else if ([registerType isEqualToString:@"email"])
            {
                _txtEmail.text=[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Email"];
                //                _txtPassword.text=[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Password"];
                if ([[SharedManager sharedManager] isNetworkAvailable])
                {
                    isFacebookLogin=NO;
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    
                    if ([self validateEmail: [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]])
                    {
                        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]  forKey:@"user_email"];
                    }
                    else
                    {
                        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"]  forKey:@"user_name"];
                    }
                    
                    [params setValue:[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Password"] forKey:@"user_password"];
                    [params setValue:@"email" forKey:@"login_type"];
                    [params setValue:[CommonFunctions getDeviceUUID] forKey:@"deviceID"];
                    
                    DataFetcher *fetcher  = [[DataFetcher alloc] init];
                    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
                    
                    [[ProcessingView instance] forceShowTintView];
                    
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]);
                    
                    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
                    NSString *email=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
                    if(username==nil || [username isEqualToString:@""]||[username isEqual:[NSNull null]])
                    {
                        username=@"username_not_available";
                    }
                    if(email==nil || [email isEqualToString:@""]||[email isEqual:[NSNull null]])
                    {
                        email=@"email_not_available";
                    }

                    
                    appDelegate.facebookData=@{
                        @"username": username,
                        @"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"cityselected"],
                        @"profilePicture":[[NSUserDefaults standardUserDefaults] objectForKey:@"profilePicture"],
                        @"email":email,
                        @"distance_unit":[[NSUserDefaults standardUserDefaults] objectForKey:@"distance_unit"],
                        @"country_code":[[NSUserDefaults standardUserDefaults] objectForKey:@"country_code"],
                    };
                    
                    NSString *currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityselected"];
                    
                    
                   
                    
                    //update this for LA
                    
                    if([currentCity isEqualToString:@"New York"])
                    {
                        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"indexpath"];
                        [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:NEW_YARK_LATITUDE longitude:NEW_YARK_LONGITUDE]];
                    } else if([currentCity isEqualToString:@"Toronto"]){
                        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"indexpath"];
                        [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:TORONTO_LATITUDE longitude:TORONTO_LONGITUDE]];
                    }
                    else if([currentCity isEqualToString:@"Los Angeles"]){
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"indexpath"];
                        [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:LA_LATITUDE longitude:LA_LONGITUDE]];
                    }
                    
                    //[[NSUserDefaults standardUserDefaults] synchronize];
                    //[[ProcessingView instance] hideTintView];
                    
                    
                   InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                }
                else
                {
                    [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
                }
            }
        }
        else
        {
            _txtEmail.placeholder=@"Username or Email";
            _txtPassword.placeholder=@"Password";
            self.txtPassword.text=  @"";
            self.txtEmail.text=@"";
        }
        
    }
    else
    {
        _txtEmail.placeholder=@"Username or Email";
        _txtPassword.placeholder=@"Password";
        self.txtPassword.text=  @"";
        self.txtEmail.text=@"";
    }
    
    
    
            //opens the session text file and checks if you're logged in already - this could be used outside of the login screen
   NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}


#pragma mark - Check for Login Services Failure

-(void)webserviceFailed
{
    [[NSUserDefaults standardUserDefaults] setObject:@"58ae0077-ba69-47ab-bbed-1d6a3431317a" forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Validations

-(void)Validation
{
}

#pragma mark - Login Thread

-(void)LoginThread
{
    _txtEmail.keyboardType=UIKeyboardTypeEmailAddress;
    _txtEmail.text=@"";
    _txtPassword.text=@"";
    [self loginInPressend:nil];
}


#pragma mark - Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Sign Up button status

- (void)updateViewsForFormValidity
{
    if ([self isFormValid])
    {
        self.btnLogin.enabled = YES;
        self.btnLogin.alpha = 1.0f;
    }
    else
    {
        self.btnLogin.enabled = NO;
        self.btnLogin.alpha = 0.9f;
    }
}


-(BOOL)isFormValid
{
    if (self.txtEmail.text.length > 4 && self.txtPassword.text.length > 4)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)validateForm
{
    [self updateViewsForFormValidity];
}

#pragma mark -
#pragma mark - Appdelegate
#pragma mark -

-(AppDelegate*)getAppDelegateInstance
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

#pragma mark -
#pragma mark - Button Actions
#pragma mark -

- (IBAction)btnTour_Pressed:(id)sender
{    
}

- (IBAction)btnForgetpwd_click:(id)sender
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:MSG_SEND_MAIL delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alert.tag=199;
    
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alert show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag != 109)
    {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        [alertView textFieldAtIndex:0].secureTextEntry=NO;
        if( [text length] >= 10 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 199)
    {
        if(buttonIndex==1)
        {
            NSString *text = [[alertView textFieldAtIndex:0] text];
            self.emailString = text;
            DataFetcher *fetcher  = [[DataFetcher alloc] init];
            [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@",BASE_URL,FORGOT_PASSWORD_URL,self.emailString] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
        }
    }
    else if (alertView.tag == 109)
    {
        if (buttonIndex == 1)
        {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            [params setObject:self.txtEmail.text forKey:@"user_email"];
            
            DataFetcher *fetcher  = [[DataFetcher alloc] init];
            [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, RESEND_VARIFICATION_EMAIL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
            [[ProcessingView instance] forceShowTintView];
        }
    }
}


- (IBAction)signInViaFBLogin:(id)sender
{
    if (![[SharedManager sharedManager] isNetworkAvailable]) {
        [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
        return;
    }
//    [[ProcessingView instance] forceShowTintView];
    isFacebookLogin=YES;
    [FacebookWrapper openSessionWithAllowLoginUI:YES];
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
            {
                // We have a valid session
                NSLog(@"User session found");
                [[ProcessingView instance] hideTintView];
                
                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
                 {
                     if (!error)
                     {
                 
                 NSLog(@"%@",FBSession.activeSession.accessTokenData.accessToken);
                
                 NSString *name = user.name;
                 NSString *email = [user objectForKey:@"email"] != nil ? [user objectForKey:@"email"] : @"";
                 NSString *userName = user.username != nil ? user.username : @"";
                 
                 AppDelegate *appDelegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                 
                 [dict setObject:userName forKey:@"username"];
                 [dict setObject:@"" forKey:@"city"];
                 [dict setObject:@"" forKey:@"profilePicture"];
                 [dict setObject:user.id forKey:@"id"];
                 [dict setObject:email forKey:@"email"];
                 [dict setObject:@"" forKey:@"distance_unit"];
                 [dict setObject:@"" forKey:@"country_code"];
                 [dict setObject:user.birthday forKey:@"birth_date"];
                 [dict setObject:user.first_name forKey:@"first_name"];
                 [dict setObject:user.last_name forKey:@"last_name"];
                         
                 appDelegate.facebookData = dict;
                 
                         [btnLoginWithFacebook setTitle:[NSString stringWithFormat:@"Signed In As : %@",name] forState:UIControlStateNormal];
                         [[ProcessingView instance] forceShowTintView];
                         NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                         [params setValue:email forKey:@"user_email"];
                         [params setValue:@"facebook" forKey:@"login_type"];
                         [params setValue:[CommonFunctions getDeviceUUID] forKey:@"deviceID"];
                         DataFetcher *fetcher  = [[DataFetcher alloc] init];
                         [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:session.accessTokenData.accessToken  forKey:@"facebook_token"];
                 
                 
                 
                     }
                 }];
                
            }
            break;
            
        case FBSessionStateClosed:
            [[ProcessingView instance] hideTintView];
            break;
            
        case FBSessionStateClosedLoginFailed:
            [[ProcessingView instance] hideTintView];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
            
        default:
            [[ProcessingView instance] hideTintView];
            break;
    }
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Facebook login cancelled."//error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@NO,@"",@"",@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
        [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
        [[SharedManager sharedManager] saveSessionToDisk];
        [alertView show];
        
        [[ProcessingView instance] forceHideTintView];
    }
}

-(IBAction)loginInPressend:(id)sender
{
    [self.view endEditing:YES];
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User logged in , %@ , %@", [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    if ([[SharedManager sharedManager] isNetworkAvailable])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"not-hidden" forKey:@"hiddenLogin"];
        isFacebookLogin=NO;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        if ([self validateEmail: _txtEmail.text])
        {
            [params setValue:_txtEmail.text  forKey:@"user_email"];
            [[NSUserDefaults standardUserDefaults] setObject:_txtEmail.text forKey:@"user_email"];
        }
        else
        {
            [params setValue:_txtEmail.text  forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:_txtEmail.text forKey:@"user_name"];
        }
        
        [params setValue:[CommonFunctions encryptPassword:_txtPassword.text] forKey:@"user_password"];
        [params setValue:@"email" forKey:@"login_type"];
        [params setValue:[CommonFunctions getDeviceUUID] forKey:@"deviceID"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[CommonFunctions encryptPassword:_txtPassword.text] forKey:@"user_password"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]);
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
        
        [[ProcessingView instance] forceShowTintView];
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
    }
}


- (IBAction)btnExplore_Pressed:(id)sender
{
    [CommonFunctions setUserAsGuest:YES];
    
    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)validateEmail :(NSString*) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


#pragma mark -
#pragma mark - DataFetcher Delegates
#pragma mark -
- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    access_token=[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
                   
    if (![responseData valueForKey:@"result"]) {
        
        [Utiltiy showAlertWithTitle:@"Login Error" andMsg:MSG_FAILED];
        return;
    }
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[responseData objectForKey:@"params"] objectForKey:@"login_type"] forKey:@"loginType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        if (isFacebookLogin==YES)
        {
            if ([[responseData valueForKey:@"result"] isEqualToString:@"false"]&&[[responseData valueForKey:@"error"] isEqualToString:@"new-user"])
            {
                FacebookSignupViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookSignupViewController"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
            {
                DataFetcher *fetcher  = [[DataFetcher alloc] init];
                
                NSLog(@"%@",[responseData objectForKey:@"access_token"]);
                [[NSUserDefaults standardUserDefaults] setObject:[responseData objectForKey:@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                access_token=[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
                [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@&image_width=122&image_height=122",BASE_URL,GET_USER_DATA,access_token] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
                [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_token"] forKey:@"facebook_token"];
                
                
                DataFetcher *fetcher_social  = [[DataFetcher alloc] init];
                [fetcher_social fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,SEND_SOCIAL_ACCESS_TOKENS] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
                
                [[ProcessingView instance] forceShowTintView];
            }
            else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400)
            {

                [Utiltiy showAlertWithTitle:@"Login Error" andMsg:MSG_FAILED];
            }
            else if ([[responseData valueForKey:@"result"] isEqualToString:@"false"])
            {
                AppDelegate *appDelegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.facebookData=@{
                    @"username": @"Username",
                    @"city":@"City",
                    @"profilePicture":@"",
                    @"id":@"",
                    @"distance_unit":@"",
                    @"country_code":@""
                };
            }
        }
        else  if (isFacebookLogin==NO)
        {
            if ([[responseData valueForKey:@"result"] isEqualToString:@"false"]&&[[responseData valueForKey:@"error"] isEqualToString:@"wrong-credentials"])
            {
                [Utiltiy showAlertWithTitle:@"Login Error" andMsg:MSG_INVALID_USERNAME];
            }
            else if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
            {
                DataFetcher *fetcher  = [[DataFetcher alloc] init];
                [[NSUserDefaults standardUserDefaults] setObject:[responseData objectForKey:@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                access_token=[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
                [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@&image_width=122&image_height=122",BASE_URL,GET_USER_DATA,access_token] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
                
                [[ProcessingView instance] forceShowTintView];
            }
            else if ([[responseData valueForKey:@"error"] isEqualToString:@"email-need-validation"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:MSG_VALIDATE_EMAIL delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Resend Email", nil];
                
                alert.tag = 109;
                
                [alert show];
                
                return;
            }
            else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400) {
                [Utiltiy showAlertWithTitle:@"Login Error" andMsg:MSG_FAILED];
            }
        }
        if([[responseData objectForKey:@"reactivated"] intValue] == 1)
            reActivation = true;
        
    }
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, RESEND_VARIFICATION_EMAIL]])
    {
        [[ProcessingView instance] forceHideTintView];
        if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
        {
            [Utiltiy showAlertWithTitle:@"" andMsg:@"Email sent successfully"];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
        }
    }
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@%@",BASE_URL,ACCESS_TOKEN_URL,access_token]])
    {
        
        if ([[responseData valueForKey:@"result"] isEqualToString:@"valid"])
        {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.facebookData=@{
                @"username": [[responseData objectForKey:@"params"]  objectForKey:@"user_name"],
                @"city":[[responseData objectForKey:@"params"]  objectForKey:@"baseCity"],
                @"profilePicture":[[responseData objectForKey:@"params"]  objectForKey:@"profilePicture"],
                @"email":[[responseData objectForKey:@"params"]  objectForKey:@"user_email"],
                @"distance_unit":@"",
                @"country_code":@""
            };
            
        }
        if ([[responseData valueForKey:@"result"] isEqualToString:@"new-user"])
        {
            FacebookSignupViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookSignupViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
        }
        
    }
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@%@&image_width=122&image_height=122",BASE_URL,GET_USER_DATA,access_token]]) {
        
        if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
        {
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            if (appDelegate.deviceTokenForNotifications)
            {
                [self sendPushNotificationTokenToServer:appDelegate.deviceTokenForNotifications];
            }
            
           appDelegate.facebookData=@{
                @"username": [[responseData objectForKey:@"data"]  objectForKey:@"user_name"],
                @"city":[[responseData objectForKey:@"data"]  objectForKey:@"baseCity"],
                @"profilePicture":[[responseData objectForKey:@"data"]  objectForKey:@"thumb_url_retina"],
                @"email":[[responseData objectForKey:@"data"]  objectForKey:@"user_email"],
                @"distance_unit":[[responseData objectForKey:@"data"]  objectForKey:@"distance_unit"],
                @"country_code":[[responseData objectForKey:@"data"]  objectForKey:@"country_code"]
            };
            
            NSString *currentCity = [[responseData objectForKey:@"data"]  objectForKey:@"baseCity"];
            NSString *username = [[responseData objectForKey:@"data"]  objectForKey:@"user_name"];
            NSString *profilePicture = [[responseData objectForKey:@"data"]  objectForKey:@"thumb_url_retina"];
            NSString *distance_unit = [[responseData objectForKey:@"data"]  objectForKey:@"distance_unit"];
            NSString *country_code = [[responseData objectForKey:@"data"]  objectForKey:@"country_code"];
            NSLog(@"User City : %@", currentCity);
            
            [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"cityselected"];
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
              [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:profilePicture forKey:@"profilePicture"];
            [[NSUserDefaults standardUserDefaults] setObject:distance_unit forKey:@"distance_unit"];
            [[NSUserDefaults standardUserDefaults] setObject:country_code forKey:@"country_code"];
            
            //update this for LA
            
            if([currentCity isEqualToString:@"New York"])
            {
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"indexpath"];
                [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:NEW_YARK_LATITUDE longitude:NEW_YARK_LONGITUDE]];
            } else if([currentCity isEqualToString:@"Toronto"]){
                [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"indexpath"];
                [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:TORONTO_LATITUDE longitude:TORONTO_LONGITUDE]];
            }
            else if([currentCity isEqualToString:@"Los Angeles"]){
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"indexpath"];
                [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:LA_LATITUDE longitude:LA_LONGITUDE]];
            }

            [[NSUserDefaults standardUserDefaults] synchronize];
            [[ProcessingView instance] hideTintView];
            
           // NSLog(@"%@",responseData);
             //           NSLog(@"%@",[[responseData objectForKey:@"data"]  objectForKey:@"user_email"]);
            NSString *email=[NSString stringWithFormat:@"%@",[[responseData objectForKey:@"data"]  objectForKey:@"user_email"]];
            if (isFacebookLogin)
            {
                
               
                NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@YES,@"facebook",email,@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
               

                [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
                [[SharedManager sharedManager] saveSessionToDisk];
                
                [CommonFunctions setUserAsGuest:NO];
                
                
                
                    
                    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                }            
            else
            {
                
                [CommonFunctions setUserAsGuest:NO];
                
                NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
                if(username==nil || [username isEqualToString:@""]||[username isEqual:[NSNull null]])
                {
                    username=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
                }
                
                NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@YES,@"email",username,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
                
                [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
                [[SharedManager sharedManager] saveSessionToDisk];
                
                NSString *check=[[NSUserDefaults standardUserDefaults] objectForKey:@"hiddenLogin"];
                //NSLog(@"%@",check);
                
                if([check isEqualToString:@"hidden"])
                {
                }
                else{
                
                    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            if(reActivation) {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [Utiltiy showAlertWithTitle:@"Reactivation" andMsg:[NSString stringWithFormat:@"%@%@",MSG_REACTIVATE, [[responseData objectForKey:@"data"]  objectForKey:@"user_name"]]];
                });
            }
        }
        else
        {
            //Profile Data
            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
            [CommonFunctions setUserAsGuest:NO];
            
            NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@NO,@"",@"",@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
            [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
            [[SharedManager sharedManager] saveSessionToDisk];
            
            InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, EDIT_DEVICE_TOKEN]])
    {
        BOOL hasError = [[responseData objectForKey:@"result"] isEqualToString:@"false"];
        
        if (hasError)
        {
            NSLog(@"wuhbad :(");
        }
        else
        {
            NSLog(@"wuhwah :)");
        }
    }
    if([url isEqualToString:[NSString stringWithFormat:@"%@%@%@",BASE_URL, FORGOT_PASSWORD_URL,self.emailString]])
    {
        if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400) {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:@"Try again."];
            
        }
        else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 200) {
            if ([[responseData valueForKey:@"result"] isEqualToString:@"success"] || [[responseData valueForKey:@"result"] isEqualToString:@"done"]||[[responseData valueForKey:@"result"] isEqualToString:@"true"])
            {
                [Utiltiy showAlertWithTitle:@"Done" andMsg:MSG_SUCCESS];
            }
            else {
                [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
                
            }
        }
    }
    
}


- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, EDIT_DEVICE_TOKEN]])
    {
        NSLog(@"fail to send notification token.. :(");
    }
}
#pragma mark -
#pragma mark - Send Push Notification Token
#pragma mark -


-(void)sendPushNotificationTokenToServer:(NSString *)token
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setObject:token forKey:@"deviceToken"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
   
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_DEVICE_TOKEN]
                 andDelegate:self
              andRequestType:@"POST"
             andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}


- (void)dialogCompleteWithUrl:(NSURL *)url
{
    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    
    if (FBSession.activeSession.isOpen)
    {
        [self sessionStateChanged:[FBSession activeSession] state:FBSession.activeSession.state error:nil];
    }
    else
    {
    }
}
#pragma mark - Story Board

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MenuViewController"])
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.facebookData=@{
            @"username": @"Username",
            @"city":@"City",
            @"profilePicture":@"",
            @"id":@"",
            @"email":@"",
            @"distance_unit":@"",
            @"country_code":@""
        };
    }
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
