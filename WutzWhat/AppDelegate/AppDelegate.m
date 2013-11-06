//
//  AppDelegate.m
//  WutzWhat
//
//  Created by My Mac on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GPPSignIn.h"
#import "GPPURLHandler.h"

@implementation AppDelegate

@synthesize share = share_;
@synthesize window = _window;
@synthesize facebookData;
@synthesize deviceTokenForNotifications;
@synthesize isGuestUser = _isGuestUser;
@synthesize isNotificationClicked = _isNotificationClicked;
@synthesize isPerkPurchased = _isPerkPurchased;
@synthesize allowViewToRotate = _allowViewToRotate;

static NSString * const kClientID = GOOGLEPLUS_CLIENT_ID;

+ (NSString *)clientID
{
    return kClientID;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CommonFunctions getDeviceUUID];
    
    [GPPSignIn sharedInstance].clientID = kClientID;
    
    [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url)
     {        
        NSString *cacheKey = [CommonFunctions getImageCacheKey:url];
        
         return cacheKey;
    }];
    
    [[LocationManagerHelper staticLocationManagerObject] startLocationManager];

    [self registerForRemoteNotification];
    
    
    // Initialising Crittercism for bug reporting
    
    [Crittercism enableWithAppID: @"51f16bf88b2e3370fa000008"];
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User is on OS version %@ , %@ , %f", self.description, [NSDate date],OS_VERSION]];
    
    // Initialising Flurry for Analytics
    
    [Flurry setCrashReportingEnabled:NO];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"S4GH3XTFV9MDJDSVDJY5"];
    
    /////////////////////////////////////////
    
    //User data that is returned by the "Get User Data" call
    self.facebookData = [[NSMutableDictionary alloc] init];
    
    [Utiltiy setupAppNavigationBarStyle];
    
    self.allowViewToRotate = NO;
    
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];

    NSDictionary *remoteNotication = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotication)
    {        
        self.isNotificationClicked = YES;
        self.notificationDictionary = [[NSDictionary alloc] initWithDictionary:remoteNotication];
        [CommonFunctions setAppBadgeNumber:0];
    }
    
//    sleep(3);//I have no clue why they had this here
    
    return YES;
}

//The app only rotates when in the gallery, hence this code

-(void)galleryViewOpening
{
    self.allowViewToRotate = YES;
}

-(void)galleryViewClosing
{
    self.allowViewToRotate = NO;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window NS_AVAILABLE_IOS(6_0)
{
    if(self.allowViewToRotate)
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

//Syncing saved data
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FacebookWrapper handleApplicationDidBecomeActive];
    application.applicationIconBadgeNumber = 0;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FacebookWrapper handleApplicationWillTerminate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SharedManager sharedManager] clearMemory];
}

#pragma mark- Notification Setting Methods

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATION_TOKEN_SENT_FLAG])
    {
        
        self.deviceTokenForNotifications = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSLog(@"%@",self.deviceTokenForNotifications);
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    self.deviceTokenForNotifications = nil;
}


#pragma mark - fb api

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([share_ handleURL:url
        sourceApplication:sourceApplication
               annotation:annotation])
    {
        return YES;
    }
    else if ([GPPURLHandler handleURL:url
               sourceApplication:sourceApplication
                      annotation:annotation])
    {
        return YES;
        
    }
    else
    {
        return [FacebookWrapper applicationHandleURL:url];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FacebookWrapper applicationHandleURL:url];
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
}

//When the notification alert is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 200)
    {
        if(buttonIndex == 0) {
            self.isNotificationClicked = YES;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationReceived" object:nil];
            [CommonFunctions setAppBadgeNumber:0];
        }
           
    }
    
    if (alertView.tag == 9999 )
    {
        if (buttonIndex == 1)
        {
            [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"appdelegate alertview clicked , %@ , %f",  [NSDate date],OS_VERSION]];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@"" forKey:@"access_token"];
            [userDefault synchronize];
            
            self.facebookData = @{
            @"username": @"",
            @"city":@"",
            @"profilePicture":@"",
            @"email":@""
            };
            
            UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
            
            NSArray *viewControllers = navController.viewControllers;
            
            for (UIViewController *controller in viewControllers)
            {
                if ([controller isKindOfClass:[LoginViewController class]])
                {
                    [navController popToRootViewControllerAnimated:YES];
                    break;
                }
            }
        }
    }
}


#pragma mark- Remote Notification Delegate Methods

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //displays the alert message if the app is open and a notification comes in - I would switch this to a custom dialog/display object, similar to a native notification or the website when you send a feedback email
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        self.notificationDictionary = [[NSDictionary alloc] initWithDictionary:userInfo];
        notificationAlert =  [[UIAlertView alloc] initWithTitle:@"Notification" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        notificationAlert.tag = 200;
        [notificationAlert show];
        
    }
    //takes care of the action associated with clicking a notification when the app is closed
    else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
    {
        self.isNotificationClicked = YES;
        self.notificationDictionary = [[NSDictionary alloc] initWithDictionary:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationReceived" object:nil];
        
        [CommonFunctions setAppBadgeNumber:0];
        
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@/notificationId=%d", BASE_URL, SET_NOTIFICATION_AS_READ,[[userInfo objectForKey:@"NotificationId"] intValue]]
                     andDelegate:nil
                  andRequestType:@"GET"
                 andPostDataDict:nil];

        

        
        
    }
}

#pragma mark - Register for Remote Notifications

//Calls the apple servers to register for remote notifications
-(void)registerForRemoteNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(galleryViewOpening)
                                                 name:@"galleryViewOpening"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(galleryViewClosing)
                                                 name:@"galleryViewClosing"
                                               object:nil];
}

@end
