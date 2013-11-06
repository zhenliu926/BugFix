//
//  Utiltiy.h
//  Swella
//
//  Created by Yunas Qazi on 3/24/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDKNotifyHUD.h"

@interface Utiltiy : NSObject

@property (strong, nonatomic) BDKNotifyHUD *notifySuccess;
@property (strong, nonatomic) BDKNotifyHUD *notifyFail;


+(BOOL) isNumeric :(NSString *)str;
+(BOOL) isPhoneNumber :(NSString *)str;
+ (NSString *) stripTags:(NSString *)str;
+ (void) showAlertWithTitle:(NSString *)title andMsg:(NSString*)msg;
+ (void) showInternetConnectionErrorAlert:(NSString *)message;
+ (BDKNotifyHUD *)notifySuccess;
+ (BDKNotifyHUD *)notifyFail;
+ (void)displayNotification : (BOOL)isSuccessfull;

+(void)setupAppNavigationBarStyle;
+(void)setupMoviePlayerNavigationBarStyle;

@end
