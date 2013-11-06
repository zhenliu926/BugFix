//
//  InitialViewController.m
//  ViewDeckStoryboardExample
//
//  Created by Simon Rice on 10/10/2012.
//  Copyright (c) 2012 Simon Rice. All rights reserved.
//

#import "InitialViewController.h"
#import "TalkSingletonManager.h"
#import "Constants.h"

@interface InitialViewController ()

@end

@implementation InitialViewController
@synthesize type;

#define FIRST_LOGIN_TOUR 20

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //NSLog(@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"indexpathmenu"] );
    //selected menu
    type = ([FIRST_LOGIN boolValue] == true || [CommonFunctions isGuestUser]) ? [[NSUserDefaults standardUserDefaults] integerForKey:@"indexpathmenu"] : FIRST_LOGIN_TOUR;
    
    if([CommonFunctions isGuestUser] || [FIRST_LOGIN_TOUR_FINISHED boolValue] == true){
        SET_DEFAULT_SORTING(1);
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        if(!DEFAULT_SORTING_VALUE){
            SET_DEFAULT_SORTING(0);
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

    UIStoryboard *storyboard;
    storyboard= [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    WutzWhatViewController *vcWutzWhatListViewController ;
    WutzWhatViewController *vcHotPicksListViewController ;
    PerksViewController *vcPerksListViewController ;
    TalksListViewController *vcTalksListViewController ;
    CreditViewController *vcCreditViewController ;
    NotificationsViewController *vcNotificationsViewController ;
    FavouritesViewController *vcFavouritesViewController ;
    ProfileViewController *vcProfileViewController ;
    MenuViewController *vcMenuViewController ;
    CityViewController *vcCityViewController ;

    
  //  vcMenuViewController = [[SharedManager sharedManager] menuViewController];
    if (!vcMenuViewController) {
        vcMenuViewController= [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
    }
    if (type==0)
    {
        vcWutzWhatListViewController= [storyboard instantiateViewControllerWithIdentifier:@"WutzWhatViewController"];
        vcWutzWhatListViewController.accessibilityHint = @"1";
        
        self = [super initWithCenterViewController:vcWutzWhatListViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            
            
        }
        return self;
    }
    if (type==1) {
        vcHotPicksListViewController= [storyboard instantiateViewControllerWithIdentifier:@"WutzWhatViewController"];
        vcHotPicksListViewController.accessibilityHint = @"3";
        self = [super initWithCenterViewController:vcHotPicksListViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            
        }
        return self;
    }
    if (type==2) {
        vcPerksListViewController= [storyboard instantiateViewControllerWithIdentifier:@"PerksViewController"];

        self = [super initWithCenterViewController:vcPerksListViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            
            
        }
        return self;
    }
    if (type==7) {
        vcCreditViewController= [storyboard instantiateViewControllerWithIdentifier:@"CreditViewController"];
        self = [super initWithCenterViewController:vcCreditViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            [self.navigationController.navigationBar setHidden:NO];
            [self.navigationController.navigationBar setAlpha:1.0f];
            
        }
        return self;
    }
    if (type==8) {
        vcNotificationsViewController= [storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
        self = [super initWithCenterViewController:vcNotificationsViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            
        }
        return self;
    }
    if (type==6) {
        vcProfileViewController= [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        self = [super initWithCenterViewController:vcProfileViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            
            
        }
        return self;
    }
    if (type==9) {
        vcCityViewController= [storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
        vcCityViewController.isFromMainMenu = YES;
        self = [super initWithCenterViewController:vcCityViewController
                                leftViewController:vcMenuViewController];
        if (self)
        {
        }
        return self;
    }
    if (type==4)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FromAddPost"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        vcTalksListViewController= [storyboard instantiateViewControllerWithIdentifier:@"TalksListViewController"];
        self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"TalksListViewController"]
                                leftViewController:vcMenuViewController];
        if (self)
        {
        }
        return self;
        
    }
    
    if (type==3) {
        
        vcFavouritesViewController= [storyboard instantiateViewControllerWithIdentifier:@"FavouritesMainViewController"];
        self = [super initWithCenterViewController:vcFavouritesViewController
                                leftViewController:vcMenuViewController];
        if (self) {
            // Add any extra init code here
            
            
        }
        return self;
        
    }
    
    if(type == FIRST_LOGIN_TOUR)
    {
        if ([FIRST_LOGIN_TOUR_FINISHED boolValue] == true) {
        
            [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"indexpathmenu"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
        ProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        self = [super initWithCenterViewController:vc
                                    leftViewController:vcMenuViewController];
            
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"firstLogin"];
            
        [self sendRequest];
            
            return self;
        }
       
       TourViewController *vcTourViewController = [storyboard instantiateViewControllerWithIdentifier:@"TourViewController"];
        self = [super initWithCenterViewController:vcTourViewController
                                leftViewController:vcMenuViewController];
        
        return self;
    }
    
    return nil;
}

- (BOOL)sendRequest
{
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession] message:@"Check out this awesome app. http://wutzwhat.com" title:@"Wutzwhat" parameters:nil handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
        [[ProcessingView instance] hideTintView];
    }];
    
    //    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Check out this awesome app. http://wutzwhat.com" title:@"Wutzwhat" parameters:nil handler:nil];
    
    return YES;
}


@end
