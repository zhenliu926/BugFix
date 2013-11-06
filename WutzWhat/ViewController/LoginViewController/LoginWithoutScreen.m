//
//  LoginWithoutScreen.m
//  WutzWhat
//
//  Created by Andy Khatter on 2013-10-15.
//
//

#import "LoginWithoutScreen.h"
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

@implementation LoginWithoutScreen

@synthesize access_token,user_email;
-(void)Login{

    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    [[SharedManager sharedManager] loadSessionFromDisk];
    NSLog(@"%@",[[[SharedManager sharedManager] sessionDictionay] allKeys]);
        NSLog(@"%@",[[[SharedManager sharedManager] sessionDictionay] allValues]);
    if ( ![[[SharedManager sharedManager] sessionDictionay] isKindOfClass:[NSNull class]]
        && ![[[SharedManager sharedManager] sessionDictionay] isEqual:nil] )
    {
        //Zeeshan if logged already for Autologin
        if([[[SharedManager sharedManager] sessionDictionay] valueForKey:@"IsLoggedInAlready"])
        {
            self.user_email=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
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
                //_txtEmail.text=[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Email"];
                //                _txtPassword.text=[[[SharedManager sharedManager] sessionDictionay] valueForKey:@"Password"];
                if ([[SharedManager sharedManager] isNetworkAvailable])
                {
                    isFacebookLogin=NO;
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    
                    
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]);
                    
                    if ([self validateEmail: [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]])
                    {
                        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]  forKey:@"user_email"];
                    }
                    else
                    {
                        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"]  forKey:@"user_name"];
                    }
                    
                    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]  forKey:@"user_password"];
                    [params setValue:@"email" forKey:@"login_type"];
                    [params setValue:[CommonFunctions getDeviceUUID] forKey:@"deviceID"];
                    
                    DataFetcher *fetcher  = [[DataFetcher alloc] init];
                    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
                    
                    [[ProcessingView instance] forceShowTintView];
                    
//                    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
//                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                }
                else
                {
                    [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_NO_INTERNET_CONNECTIVITY];
                }
            }
        }
        else
        {
//            _txtEmail.placeholder=@"Username or Email";
//            _txtPassword.placeholder=@"Password";
//            self.txtPassword.text=  @"";
//            self.txtEmail.text=@"";
        }
        
    }
    else
    {
        
        return;
//        _txtEmail.placeholder=@"Username or Email";
//        _txtPassword.placeholder=@"Password";
//        self.txtPassword.text=  @"";
//        self.txtEmail.text=@"";
    }

}

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
                [[NSUserDefaults standardUserDefaults] setObject:[responseData objectForKey:@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                access_token=[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
                [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@&image_width=122&image_height=122",BASE_URL,GET_USER_DATA,access_token] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
                
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
            NSLog(@"User City : %@", currentCity);
            
            [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"cityselected"];
            
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
            NSString *email=[NSString stringWithFormat:@"%@",[responseData objectForKey:@"data"]];
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
                
                NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@YES,@"email",self.user_email,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
                [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
                [[SharedManager sharedManager] saveSessionToDisk];
                
                InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
                [self.navigationController pushViewController:vc animated:YES];
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
    
    
}


- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, EDIT_DEVICE_TOKEN]])
    {
        NSLog(@"fail to send notification token.. :(");
    }
}

- (BOOL)validateEmail :(NSString*) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

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


@end
