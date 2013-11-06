//
//  FacebookWrapper.m
//  FaceBook Demo App
//
//  Created by Asad Ali on 6/6/13.
//  Copyright (c) 2013 Asad Ali. All rights reserved.
//

#import "FacebookWrapper.h"

NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@implementation FacebookWrapper

#pragma mark - Facebook Delegate Methods

+ (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
            {
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        [[ProcessingView instance] forceHideTintView];
    }
}


+ (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_likes", @"user_birthday", nil];
    
    if([FBSession activeSession].isOpen){
         [self sessionStateChanged:[FBSession activeSession] state:FBSessionStateOpen error:nil];
        return true;
    } else {
        return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session,FBSessionState state,NSError *error)
                {
                    [self sessionStateChanged:session state:state error:error];
                }];
    }
    return false;
}


+ (BOOL)applicationHandleURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];    
}

+ (void) closeSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

+(void)handleApplicationWillTerminate
{
    [FBSession.activeSession close];
}

+(void)handleApplicationDidBecomeActive
{
    [FBSession.activeSession handleDidBecomeActive];
}

+(BOOL)isSessionOpen
{
    return FBSession.activeSession.isOpen;
}

@end
