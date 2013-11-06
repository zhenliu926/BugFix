//
//  FBPoster.h
//  iScopesUniversal
//
//  Created by Ali Awais on 5/20/11.
//  Copyright 2011 EMSystems. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FBPosterDelegate <NSObject>

@optional

- (void) facebookStoryPublishSucceded;
- (void) facebookStoryPublishFailed;
- (void) updateFaceBookButtonStatus;
@end

@interface FBPoster : NSObject 
{
    id<FBPosterDelegate> posterDelegate;  //we expect the delgate to be a UIViewController as well.
    //-FBSession * localSession;    

	NSMutableDictionary *facebookParams;
	BOOL shouldPostFeedAfterLogin;
}

@property (nonatomic,retain)  id<FBPosterDelegate> posterDelegate;
//-@property (nonatomic,retain)  FBSession *localSession;
@property (nonatomic,retain)  NSString *lastUsedStatus;
@property (nonatomic,retain)  NSString *lastUsedStory;


-(id)initWithDelegate:(id<FBPosterDelegate>)aDelegate;

-(void)facebookPublishStory:(NSMutableDictionary *)story;
- (BOOL) isFaceBookUserLoggedIn;
- (void) loginLogoutFacebook;

@end