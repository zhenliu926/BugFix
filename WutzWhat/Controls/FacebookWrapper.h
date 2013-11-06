//
//  FacebookWrapper.h
//  FaceBook Demo App
//
//  Created by Asad Ali on 6/6/13.
//  Copyright (c) 2013 Asad Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;

@interface FacebookWrapper : NSObject
{
    
}

+ (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
+ (void) closeSession;
+ (BOOL)applicationHandleURL:(NSURL *)url;
+ (void)handleApplicationWillTerminate;
+ (void)handleApplicationDidBecomeActive;
+ (BOOL)isSessionOpen;
@end
