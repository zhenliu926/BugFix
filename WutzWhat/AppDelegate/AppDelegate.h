//
//  AppDelegate.h
//  WutzWhat
//
//  Created by My Mac on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Crittercism.h"
#import "Flurry.h"
#import "GPPDeepLink.h"
#import "GPPShare.h"
#import "SharedManager.h"
#import "SDWebImageManager.h"
#import "FacebookWrapper.h"
#import "LocationManagerHelper.h"

@class GTMOAuth2Authentication;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GPPDeepLinkDelegate, UIApplicationDelegate>
{
    UIAlertView *notificationAlert;
}


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSDictionary *facebookData;
@property (nonatomic,retain) NSString *deviceTokenForNotifications;
@property (retain, nonatomic) GPPShare *share;

@property (nonatomic,assign) BOOL isGuestUser;
@property (nonatomic,assign) BOOL isNotificationClicked;
@property (nonatomic,assign) BOOL isPerkPurchased;
@property (nonatomic,assign) BOOL allowViewToRotate;


@property (nonatomic,strong) NSDictionary *notificationDictionary;

+ (NSString *)clientID;

@end
