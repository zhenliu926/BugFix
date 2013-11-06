//
//  FBPoster.m
//  iScopesUniversal
//
//  Created by Ali Awais on 5/20/11.
//  Copyright 2011 EMSystems. All rights reserved.
//

#import "FBPoster.h"

//#import "iVillageAppDelegate.h"

@implementation FBPoster

//-@synthesize localSession;
//-@synthesize facebookSession;
@synthesize posterDelegate;
@synthesize lastUsedStatus,lastUsedStory;

-(id)initWithDelegate:(id<FBPosterDelegate>)aDelegate
{
   if(self == [super init])
    {
        self.posterDelegate = aDelegate;
 		//[self setupFacebook];
   }
    
    return self;
}

/*- (void)facebookPublishStory:(NSMutableDictionary *)story
{
	[story setObject:[NSString stringWithString:FBCONNECT_API_KEY] forKey:@"api_key"];
	facebookParams = [story retain];
	
	shouldPostFeedAfterLogin = NO;
	
	DLDSAppDelegate *appDelegate =(DLDSAppDelegate *) [[UIApplication sharedApplication]delegate];
	if ([appDelegate.facebookSession isSessionValid])
	{
		if ([story valueForKey:@"picture"]!=nil) {
        [appDelegate.facebookSession requestWithGraphPath:@"me/photos" andParams:facebookParams andHttpMethod:@"POST" andDelegate:self];    
        }
        else
        [appDelegate.facebookSession requestWithGraphPath:@"feed" andParams:facebookParams andHttpMethod:@"POST" andDelegate:self];
		//[appDelegate.facebookSession dialog:@"feed" andDelegate:self];
		//[appDelegate.facebookSession dialog:@"feed" andParams:story andDelegate:self];
	}
	else 
	{
		shouldPostFeedAfterLogin = YES;
		[appDelegate.facebookSession authorize:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", nil] delegate:self];
	}
}*/

- (void)facebookPublishStory:(NSMutableDictionary *)story
{
//	[story setObject:FBCONNECT_API_KEY forKey:@"api_key"];
//	facebookParams = story;
//	
//	shouldPostFeedAfterLogin = NO;
//	
//	AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
//	if (appDelegate.facebookSession.isOpen)
//	    [self sendRequests:story];
//	else {
//		shouldPostFeedAfterLogin = YES;
//        //[self loginLogoutFacebook];
//        
//        if (appDelegate.facebookSession.state != FBSessionStateCreated) {
//            // Create a new, logged out session.
//            appDelegate.facebookSession = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",@"email",@"user_birthday",@"friends_birthday", nil]];
//        }
//        
//        // if the session isn't open, let's open it now and present the login UX to the user
//        [appDelegate.facebookSession openWithCompletionHandler:^(FBSession *session,
//                                                                 FBSessionState status,
//                                                                 NSError *error) {
//            // and here we make sure to update our UX according to the new session state
//            //[delegate updateFaceBookButtonStatus];
//            if (appDelegate.facebookSession.isOpen)
//                [self sendRequests:story];
//            
//        }];
//        
//        
//        
//        
//	}
}

// FBSample logic
// Read the ids to request from textObjectID and generate a FBRequest
// object for each one.  Add these to the FBRequestConnection and
// then connect to Facebook to get results.  Store the FBRequestConnection
// in case we need to cancel it before it returns.
//
// When a request returns results, call requestComplete:result:error.
//
- (void)sendRequests:(NSDictionary*)params {
    // extract the id's for which we will request the profile
    //  NSArray *fbids = [self.textObjectID.text componentsSeparatedByString:@","];
    
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    // for each fbid in the array, we create a request object to fetch
    // the profile, along with a handler to respond to the results of the request
    // create a handler block to handle the results of the request for fbid's profile
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        
        if (error) {
            UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [msg show];
            [msg release];
        }else{
            UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Success!" message:MSG_FB_POST_SUCCESS delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [msg show];
            [msg release];
        }
        
        //[self requestCompleted:connection forFbID:fbid result:result error:error];
    };
    
    // create the request object, using the fbid as the graph path
    // as an alternative the request* static methods of the FBRequest class could
    // be used to fetch common requests, such as /me and /me/friends
    
    if ([params valueForKey:@"picture"]==nil) {
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"feed" parameters:params HTTPMethod:@"POST"];
    
    // add the request to the connection object, if more than one request is added
    // the connection object will compose the requests as a batch request; whether or
    // not the request is a batch or a singleton, the handler behavior is the same,
    // allowing the application to be dynamic in regards to whether a single or multiple
    // requests are occuring
    [newConnection addRequest:request completionHandler:handler];
    }
    else{
        FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                      graphPath:@"me/photos" parameters:params HTTPMethod:@"POST"];
        
        // add the request to the connection object, if more than one request is added
        // the connection object will compose the requests as a batch request; whether or
        // not the request is a batch or a singleton, the handler behavior is the same,
        // allowing the application to be dynamic in regards to whether a single or multiple
        // requests are occuring
        [newConnection addRequest:request completionHandler:handler];
        
    }
    
    
    [newConnection start];
}




/*- (void) loginLogoutFacebook
 {
 iVillageAppDelegate *appDelegate = (iVillageAppDelegate *) [[UIApplication sharedApplication]delegate];
 if ([appDelegate.facebookSession isSessionValid])
 {
 [appDelegate.facebookSession logout:self];
 }
 else
 {
 [appDelegate.facebookSession authorize:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", nil] delegate:self];
 }
 }*/

// FBSample logic
// handler for button click, logs sessions in or out
- (void)loginLogoutFacebook{
//    // get the app delegate so that we can access the session property
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    NSLog(@"%@",[appDelegate class]);
//    // this button's job is to flip-flop the session from open to closed
//    if (appDelegate.facebookSession.isOpen) {
//        // if a user logs out explicitly, we delete any cached token information, and next
//        // time they run the applicaiton they will be presented with log in UX again; most
//        // users will simply close the app or switch away, without logging out; this will
//        // cause the implicit cached-token login to occur on next launch of the application
//        [appDelegate.facebookSession closeAndClearTokenInformation];
//        
//    } else {
//        if (appDelegate.facebookSession.state != FBSessionStateCreated) {
//            // Create a new, logged out session.
//            appDelegate.facebookSession = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",@"email",@"user_birthday",@"friends_birthday", nil]];
//        }
//        
//        // if the session isn't open, let's open it now and present the login UX to the user
//        [appDelegate.facebookSession openWithCompletionHandler:^(FBSession *session,
//                                                                 FBSessionState status,
//                                                                 NSError *error) {
//            // and here we make sure to update our UX according to the new session state
//            [posterDelegate updateFaceBookButtonStatus];
//        }];
//    }
}

- (BOOL) isFaceBookUserLoggedIn
{
	BOOL loggedIn = NO;
	
//	AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
//	if ([appDelegate.facebookSession isOpen])
//	{
//		loggedIn = YES;
//	}
	
	return loggedIn;
}
- (void) setFacebookSession {
//    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
//    if (!appDelegate.facebookSession.isOpen) {
//        // create a fresh session object
//        appDelegate.facebookSession = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", @"email",@"user_birthday",@"friends_birthday",nil]];
//        
//        // if we don't have a cached token, a call to open here would cause UX for login to
//        // occur; we don't want that to happen unless the user clicks the login button, and so
//        // we check here to make sure we have a token before calling open
//        if (appDelegate.facebookSession.state == FBSessionStateCreatedTokenLoaded) {
//            // even though we had a cached token, we need to login to make the session usable
//            [appDelegate.facebookSession openWithCompletionHandler:^(FBSession *session,
//                                                                     FBSessionState status,
//                                                                     NSError *error) {
//                // we recurse here, in order to update buttons and labels
//                [posterDelegate updateFaceBookButtonStatus];
//            }];
//        }
//    }
}

@end
