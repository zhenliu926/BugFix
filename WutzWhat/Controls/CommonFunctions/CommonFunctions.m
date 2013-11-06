//
//  CommonFunctions.m
//  WutzWhat
//
//  Created by iPhone Development on 3/17/13.
//
//

#import "CommonFunctions.h"

@implementation CommonFunctions

@synthesize eventStore=_eventStore;
@synthesize defaultCalendar=_defaultCalendar;
@synthesize bonusCode=_bonusCode;
@synthesize delegate = _delegate;
@synthesize mailController = _mailController;
@synthesize msgController = _msgController;
@synthesize mainParentController = _mainParentController;

-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
}

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
}

- (id) initWithParent:(UIViewController*) mainController
{
    if( self = [super init])
    {
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        self.mainParentController =[[UIViewController alloc] init];
        self.mainParentController = mainController;
        _notifySuccess = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
        _notifySuccess.center = CGPointMake(appDelegate.window.center.x, appDelegate.window.center.y - 20);
        _notifyFail = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE_FAIL] text:@""];
        _notifyFail.center = CGPointMake(appDelegate.window.center.x, appDelegate.window.center.y - 20);
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+(void)makePromptCall:(NSString *)phoneNumber
{
    if (![phoneNumber isKindOfClass:[NSNull class]] && ![phoneNumber isEqualToString:@""])
    {
        UIDevice *device = [UIDevice currentDevice];
        if ([[device model] isEqualToString:@"iPhone"] )
        {
            phoneNumber = [NSString stringWithFormat:@"telprompt:%@",phoneNumber];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_CALL_FAILED];
        }
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_FAILED];
    }
}

#pragma mark -
#pragma mark Add Event
#pragma mark -
-(void)addEventToCalendar:(NSString *)title description:(NSString *)description startDate:(NSString *)startDateStamp endDate:(NSString *)endDateStamp link: (NSString *)link location : (NSString *)location
{
    
    self.eventStore = [[EKEventStore alloc] init];
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        if(granted)
        {
            self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
            EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
            
            // set the addController's event store to the current event store.
            addController.eventStore = self.eventStore;
            addController.event.title=title;
            addController.event.location=location;
            addController.event.URL= [NSURL URLWithString:link];
            addController.event.startDate=[CommonFunctions getDateFromTimeStamp:startDateStamp];
            addController.event.endDate=[CommonFunctions getDateFromTimeStamp:endDateStamp];
            addController.event.notes=description;
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                // present EventsAddViewController as a modal view controller
                [self.mainParentController.navigationController.navigationBar setHidden:NO];
                [self.mainParentController.navigationController.navigationBar setAlpha:1.0f];
                [self.mainParentController presentViewController:addController animated:YES completion:^(){}];
                
                addController.editViewDelegate = self;
            });
            
        } else
        {
            dispatch_async(dispatch_get_main_queue(), ^(){
             [Utiltiy showAlertWithTitle:@"Error " andMsg:MSG_FAILED];
            });
        }

    }];
    
}

#pragma mark -
#pragma mark EKEventEditViewDelegate
#pragma mark -

- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{

	switch (action)
    {
		case EKEventEditViewActionCanceled:
			[self displayNotification:NO];
			break;
			
		case EKEventEditViewActionSaved:
			[self displayNotification:YES];
			break;
			
		case EKEventEditViewActionDeleted:
			
            
			break;
			
		default:
			break;
	}

	[controller dismissViewControllerAnimated:YES completion:^(){}];
}


+(NSDate *)getDateFromTimeStamp:(NSString *)timeStamp
{
    if (timeStamp && ![timeStamp isKindOfClass:[NSNull class]] && ![timeStamp isEqualToString:@""])
    {
        timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@")/" withString:@""];
        
        NSArray *timeArray = [timeStamp componentsSeparatedByString:@"-"];
        
        double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
        
        postTimeLong = (postTimeLong/1000);
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:postTimeLong];
        
        return date;
    }
    else
    {
        return [NSDate date];
    }
}

+(void)addNewContactWithTitle: (NSString *)title andAddress: (NSString*)address andPhoneNumber: (NSString*)phoneNumber andThumbnailImage: (UIImage*)thumbnailImage
{
    
    ABAddressBookRef libroDirec = ABAddressBookCreateWithOptions(nil, nil);
    
    ABAddressBookRequestAccessWithCompletion(libroDirec, ^(bool granted, CFErrorRef error){
    
        if(granted)
        {
            ABRecordRef persona = ABPersonCreate();
            
            ABRecordSetValue(persona, kABPersonFirstNameProperty,(__bridge CFTypeRef)([NSString stringWithFormat:@"%@",title]) , nil);
            
            ABMutableMultiValueRef multiHome = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
            
            NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
            
            NSString *homeStreetAddress=address;
            
            [addressDictionary setObject:homeStreetAddress forKey:(NSString *) kABPersonAddressStreetKey];
            
            
            
            bool didAddHome = ABMultiValueAddValueAndLabel(multiHome, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
            
            if(didAddHome)
            {
                ABRecordSetValue(persona, kABPersonAddressProperty, multiHome, NULL);
                
                NSLog(@"Address saved.....");
            }
            
            
            //##############################################################################
            
            
            
            ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            //bool didAddPhone = ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(menu.phone), kABPersonPhoneMobileLabel, NULL);
            bool didAddPhone = ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)phoneNumber, kABPersonPhoneMobileLabel, NULL);
            
            if(didAddPhone){
                
                ABRecordSetValue(persona, kABPersonPhoneProperty, multiPhone,nil);
                
                NSLog(@"Phone Number saved......");
                
            }
            
            CFRelease(multiPhone);
            
            //##############################################################################
            
            ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABPersonEmailProperty);
            
            //bool didAddEmail = ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(menu.website), kABOtherLabel, NULL);
            bool didAddEmail = ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(@""), kABOtherLabel, NULL);
            
            if(didAddEmail){
                
                ABRecordSetValue(persona, kABPersonEmailProperty, emailMultiValue, nil);
                
                NSLog(@"Email saved......");
            }
            
            CFRelease(emailMultiValue);
            
            if (![thumbnailImage isEqual:[UIImage imageNamed:@"list_thumbnail.png"]])
            {
                NSData * dataRef = UIImagePNGRepresentation(thumbnailImage);
                
                //                and add this to the records
                
                ABPersonSetImageData(persona, (__bridge CFDataRef)dataRef, nil);
            }
            
            
            
            
            ABAddressBookAddRecord(libroDirec, persona, nil);
            
            CFRelease(persona);
            
            ABAddressBookSave(libroDirec, nil);
            
            CFRelease(libroDirec);
            
            NSString * errorString = [NSString stringWithFormat:MSG_SAVED_CONTACT_INFO];
            NSString *contactName=[NSString stringWithFormat:@"%@ Info",title];
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:contactName message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [errorAlert show];
            });
        }
    
    });
    
  
    
}

-(void)shareOnFaceBookWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailImage: (UIImage *)thumbnailImage  andWebsiteUrl: (NSString *)url
{
    isPhotoFacebookShare = YES;
    if(url.length==0) url = @"http://wutzwhat.com/";
    NSString *shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,url];
    
    if ([info isKindOfClass:[NSNull class]])
    {
        shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,url];
    }
    else if ([url isKindOfClass:[NSNull class]])
    {
        shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,@"wutzwhat.com"];
    }
    else if ([url isKindOfClass:[NSNull class]]&&[info isKindOfClass:[NSNull class]])
    {
        shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,@"wutzwhat.com"];
    }
    shareOnFaceBookText = shareText;
    shareOnFaceBookImage = thumbnailImage;
    if (FBSession.activeSession.isOpen) {
        
        // if it is available to us, we will post using the native dialog
        BOOL displayedNativeDialog;
        if ([thumbnailImage isEqual:[UIImage imageNamed:@"list_thumbnail.png"]])
        {
            displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.mainParentController
                                                                       initialText:shareText
                                                                             image:nil
                                                                               url:nil
                                                                           handler:^(FBNativeDialogResult result, NSError *error) {
                                                                               if (error) {
                                                                                   //failBlock([[error userInfo] description]);
                                                                               } else {
                                                                                   if (result == FBNativeDialogResultSucceeded) {
                                                                                       [self displayNotification:YES];;
                                                                                       //completionBlock();
                                                                                   } else if (result == FBNativeDialogResultCancelled) {
                                                                                       [self displayNotification:NO];;
                                                                                       //failBlock(@"User cancelled");
                                                                                   } else if (result == FBNativeDialogResultError) {
                                                                                       [self displayNotification:NO];;
                                                                                       //failBlock(@"Unknown error");
                                                                                   }
                                                                               }
                                                                           }];
        }else
        {
            displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.mainParentController
                                                                       initialText:shareText
                                                                             image:thumbnailImage
                                                                               url:nil
                                                                           handler:^(FBNativeDialogResult result, NSError *error) {
                                                                               if (error) {
                                                                                   //failBlock([[error userInfo] description]);
                                                                                   
                                                                               } else {
                                                                                   if (result == FBNativeDialogResultSucceeded) {
                                                                                       [self displayNotification:YES];;
                                                                                       //completionBlock();
                                                                                   } else if (result == FBNativeDialogResultCancelled) {
                                                                                       [self displayNotification:NO];;
                                                                                       //failBlock(@"User cancelled");
                                                                                   } else if (result == FBNativeDialogResultError) {
                                                                                       [self displayNotification:NO];;
                                                                                       //failBlock(@"Unknown error");
                                                                                   }
                                                                               }
                                                                           }];
        }
        
        if (!displayedNativeDialog) {
            
                if ([thumbnailImage isEqual:[UIImage imageNamed:@"list_thumbnail.png"]])
                {
                    
                }else
                {
                    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                    [params setObject:shareText forKey:@"message"];
                    [params setObject:UIImagePNGRepresentation(thumbnailImage) forKey:@"picture"];
                    
                    [FBRequestConnection startWithGraphPath:@"me/photos"
                                                 parameters:params
                                                 HTTPMethod:@"POST"
                                          completionHandler:^(FBRequestConnection *connection,
                                                              id result,
                                                              NSError *error)
                     {
                         if (error)
                         {
                             [self displayNotification:NO];
                         }
                         else
                         {
                             [self displayNotification:YES];
                         }
                         
                     }];
                }
            
        }
    } else
    {
        NSArray* permissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"publish_actions", nil];
//        , @"user_location"
        
        FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
        [FBSession setActiveSession:session];
        [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             [self sessionStateChanged:session state:status error:error];
         }];
    }
}

-(void)shareOnFaceBookWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode
{
    isPhotoFacebookShare = NO;
    NSString *shareText;
    if ([self.mainParentController isKindOfClass:[SpreadWutzWhatViewController class]]) {
        shareText=[NSString stringWithFormat:@"Try a new app called Wutzwhat and find what's best in your city: www.facebook.com/Wutzwhat Here's a signup bonus: %@",bonusCode];
    }else
    {
        shareText=[NSString stringWithFormat:@"%@",title];
    }
    shareOnFaceBookText = shareText;
    
//    [FBSession setActiveSession:FBSession.activeSession];
    if (FBSession.activeSession.isOpen)
    {
        BOOL displayedNativeDialog;
        displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.mainParentController
                                                                   initialText:shareText
                                                                         image:nil
                                                                           url:nil
                                                                       handler:^(FBNativeDialogResult result, NSError *error) {
                                                                           if (error) {
                                                                               if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                                                               {
                                                                                   [self.delegate doneFacebookShare];
                                                                               }
                                                                               //failBlock([[error userInfo] description]);
                                                                           } else {
                                                                               if (result == FBNativeDialogResultSucceeded) {
                                                                                   [self displayNotification:YES];
                                                                                   //completionBlock();
                                                                               } else if (result == FBNativeDialogResultCancelled) {
                                                                                   [self displayNotification:NO];
                                                                                   //failBlock(@"User cancelled");
                                                                               } else if (result == FBNativeDialogResultError) {
                                                                                   [self displayNotification:NO];
                                                                                   if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                                                                   {
                                                                                       [self.delegate doneFacebookShare];
                                                                                   }
                                                                                   //failBlock(@"Unknown error");
                                                                               }
                                                                           }
                                                                           
                                                                       }];
        if (!displayedNativeDialog) {
            
            [self performPublishAction:^{
                NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                [params setObject:shareOnFaceBookText forKey:@"message"];
                [FBRequestConnection startWithGraphPath:@"me/feed"
                                             parameters:params
                                             HTTPMethod:@"POST"
                                      completionHandler:^(FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error)
                 {
                     if (error)
                     {
                         [self displayNotification:NO];
                     }
                     else
                     {
                         [self displayNotification:YES];
                     }
                     if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                     {
                         [self.delegate doneFacebookShare];
                     }
                 }];
            }];
        }
        
    } else
    {
        NSArray* permissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"publish_actions", nil];
        
        FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
        [FBSession setActiveSession:session];
        [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
        {
            [self sessionStateChanged:session state:status error:error];
        }];
    }
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    [self sessionStateChanged:session state:session.state error:error];
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    }
    else
    {
        //[self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil];
    }

    
    return YES;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                
                if (isPhotoFacebookShare) {
                    // if it is available to us, we will post using the native dialog
                    BOOL displayedNativeDialog;
                    if ([shareOnFaceBookImage isEqual:[UIImage imageNamed:@"list_thumbnail.png"]])
                    {
                        displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.mainParentController
                                                                                   initialText:shareOnFaceBookText
                                                                                         image:nil
                                                                                           url:nil
                                                                                       handler:^(FBNativeDialogResult result, NSError *error) {
                                                                                           if (error) {
                                                                                               if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                                                                               {
                                                                                                   [self.delegate doneFacebookShare];
                                                                                               }
                                                                                               //failBlock([[error userInfo] description]);
                                                                                           } else {
                                                                                               if (result == FBNativeDialogResultSucceeded) {
                                                                                                   [self displayNotification:YES];;
                                                                                                   //completionBlock();
                                                                                               } else if (result == FBNativeDialogResultCancelled) {
                                                                                                   [self displayNotification:NO];;
                                                                                                   //failBlock(@"User cancelled");
                                                                                               } else if (result == FBNativeDialogResultError) {
                                                                                                   [self displayNotification:NO];;
                                                                                                   //failBlock(@"Unknown error");
                                                                                               }
                                                                                               if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                                                                               {
                                                                                                   [self.delegate doneFacebookShare];
                                                                                               }
                                                                                           }
                                                                                           
                                                                                       }];
                    }else
                    {
                        displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.mainParentController
                                                                                   initialText:shareOnFaceBookText
                                                                                         image:shareOnFaceBookImage
                                                                                           url:nil
                                                                                       handler:^(FBNativeDialogResult result, NSError *error) {
                                                                                           if (error) {
                                                                                               if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                                                                               {
                                                                                                   [self.delegate doneFacebookShare];
                                                                                               }
                                                                                               //failBlock([[error userInfo] description]);
                                                                                               
                                                                                           } else {
                                                                                               if (result == FBNativeDialogResultSucceeded) {
                                                                                                   [self displayNotification:YES];;
                                                                                                   //completionBlock();
                                                                                               } else if (result == FBNativeDialogResultCancelled) {
                                                                                                   [self displayNotification:NO];;
                                                                                                   //failBlock(@"User cancelled");
                                                                                               } else if (result == FBNativeDialogResultError) {
                                                                                                   [self displayNotification:NO];;
                                                                                                   //failBlock(@"Unknown error");
                                                                                               }
                                                                                               if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                                                                               {
                                                                                                   [self.delegate doneFacebookShare];
                                                                                               }
                                                                                           }
                                                                                           
                                                                                       }];
                    }
                    
                    if (!displayedNativeDialog) {
                        [self performPublishAction:^{
                            if ([shareOnFaceBookImage isEqual:[UIImage imageNamed:@"list_thumbnail.png"]]) {
                                
                            }else
                            {
                                
                                NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                                [params setObject:shareOnFaceBookText forKey:@"message"];
                                [params setObject:UIImagePNGRepresentation(shareOnFaceBookImage) forKey:@"picture"];
                                
                                [FBRequestConnection startWithGraphPath:@"me/photos"
                                                             parameters:params
                                                             HTTPMethod:@"POST"
                                                      completionHandler:^(FBRequestConnection *connection,
                                                                          id result,
                                                                          NSError *error)
                                 {
                                     if (error)
                                     {
                                         [self displayNotification:NO];
                                     }
                                     else
                                     {
                                         [self displayNotification:YES];
                                     }
                                     if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                     {
                                         [self.delegate doneFacebookShare];
                                     }
                                 }];
                            }
                        }];

                    }
                }else
                {
                    BOOL displayedNativeDialog;
                    displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self.mainParentController
                                                                               initialText:shareOnFaceBookText
                                                                                     image:nil
                                                                                       url:nil
                                                                                   handler:^(FBNativeDialogResult result, NSError *error)
                    {
                                                                                       if (error) {
                                                                                           //failBlock([[error userInfo] description]);
                                                                                       } else {
                                                                                           if (result == FBNativeDialogResultSucceeded)
                                                                                           {
                                                                                               [self displayNotification:YES];;
                                                                                               //completionBlock();
                                                                                           }
                                                                                           else if (result == FBNativeDialogResultCancelled)
                                                                                           {
                                                                                               [self displayNotification:NO];;
                                                                                               //failBlock(@"User cancelled");
                                                                                           } else if (result == FBNativeDialogResultError) {
                                                                                               [self displayNotification:NO];;
                                                                                               //failBlock(@"Unknown error");
                                                                                           }
                                                                                       }
                        if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                        {
                            [self.delegate doneFacebookShare];
                        }
                        
                        
                    }];
                    if (!displayedNativeDialog)
                    {
                        
//                        [self performPublishAction:^{
//                            [FBRequestConnection startForPostStatusUpdate:shareOnFaceBookText completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                if(error) {
//                                    [self displayNotification:NO];
//                                }else{
//                                    [self displayNotification:YES];
//                                }
//                                if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
//                                {
//                                    [self.delegate doneFacebookShare];
//                                }
//                            }];
//                        }];
                        [self performPublishAction:^{
                            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                            [params setObject:shareOnFaceBookText forKey:@"message"];
                            [FBRequestConnection startWithGraphPath:@"me/feed"
                                                         parameters:params
                                                         HTTPMethod:@"POST"
                                                  completionHandler:^(FBRequestConnection *connection,
                                                                      id result,
                                                                      NSError *error)
                             {
                                 if (error)
                                 {
                                     [self displayNotification:NO];
                                 }
                                 else
                                 {
                                     [self displayNotification:YES];
                                 }
                                 if ( [self.delegate respondsToSelector:@selector(doneFacebookShare)])
                                 {
                                     [self.delegate doneFacebookShare];
                                 }
                             }];
                        }];
                        
                    }
                }
                
            }
            break;
        case FBSessionStateClosed:
            
            break;
        case FBSessionStateClosedLoginFailed:
            [self displayNotification:NO];
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
    }
}

+ (NSString *)encryptPassword:(NSString *)password
{
    const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:password.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    //publish_actions
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
}

-(void)shareOnTwitterWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode
{
    NSString *shareText=[NSString stringWithFormat:@"%@",@""];
    if ([self.mainParentController isKindOfClass:[SpreadWutzWhatViewController class]]) {
        shareText= [NSString stringWithFormat:@"Try a new app @Wutzwhat and find what's best in your city: http://wutzwhat.com Here's a signup bonus: %@ #wutzwhat,#toronto,#nyc.", bonusCode];
    }else
    {
        shareText=[NSString stringWithFormat:@"%@",title];
    }
    NSLog(@"Integer : %@", shareText);
    if (NSClassFromString(@"TWTweetComposeViewController")) {
        
        NSLog(@"Twitter framework is available on the device");
        TWTweetComposeViewController *twitterComposer = [[TWTweetComposeViewController alloc]init]; 
        //set the text that you want to post Check out [Title of Pick] (Enter Address of Pick in brackets) on @wutzwhat: http://wutzwhat.com/
        
        [twitterComposer setInitialText:shareText];
        
        //add Image
        //[twitterComposer addImage:nil];
        
        //add Link
        // [twitterComposer addURL:[NSURL URLWithString:@"http://iphonebyradix.blogspot.in"]];
        
        //display the twitter composer modal view controller
        [self.mainParentController presentViewController:twitterComposer animated:YES completion:^(){}];
        
        //check to update the user regarding his tweet
        twitterComposer.completionHandler = ^(TWTweetComposeViewControllerResult res)
        {
            //if the posting is done successfully
            if (res == TWTweetComposeViewControllerResultDone)
            {
                [self displayNotification:YES];
            }
            else if(res==TWTweetComposeViewControllerResultCancelled)
            {
                [self displayNotification:NO];
            }
            [self.mainParentController dismissViewControllerAnimated:YES completion:^(){}];
            
        };
        
    }else{
        NSLog(@"Twitter framework is not available on the device");
        [self displayNotification:NO];
    }
}
-(void)shareOnTwitterWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailImage: (UIImage *)thumbnailImage  andWebsiteUrl: (NSString *)url{
    if (NSClassFromString(@"TWTweetComposeViewController")) {
        
        NSLog(@"Twitter framework is available on the device");
        TWTweetComposeViewController *twitterComposer = [[TWTweetComposeViewController alloc]init];
        //set the text that you want to post Check out [Title of Pick] (Enter Address of Pick in brackets) on @wutzwhat: http://wutzwhat.com/
        if(url.length==0) url = @"http://wutzwhat.com/";
        NSString *shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,url];
        
        if ([info isKindOfClass:[NSNull class]]) {
            shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,url];
        }else if ([url isKindOfClass:[NSNull class]])
        {
            shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,@"wutzwhat.com"];
        }else if ([url isKindOfClass:[NSNull class]]&&[info isKindOfClass:[NSNull class]])
        {
            shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,@"wutzwhat.com"];
        }
        [twitterComposer setInitialText:shareText];
        
        //add Image
        [twitterComposer addImage:thumbnailImage];
        
        //add Link
        // [twitterComposer addURL:[NSURL URLWithString:@"http://iphonebyradix.blogspot.in"]];
        
        //display the twitter composer modal view controller
        [self.mainParentController presentViewController:twitterComposer animated:YES completion:^(){}];
        
        //check to update the user regarding his tweet
        twitterComposer.completionHandler = ^(TWTweetComposeViewControllerResult res){
            
            //if the posting is done successfully
            if (res == TWTweetComposeViewControllerResultDone){
                [self displayNotification:YES];;
            }
            else if(res==TWTweetComposeViewControllerResultCancelled){
                [self displayNotification:NO];;
            }
            [self.mainParentController dismissViewControllerAnimated:YES completion:^(){}];
            
        };
        
    }else{
        [self displayNotification:NO];;
        NSLog(@"Twitter framework is not available on the device");
        
    }
}
-(void)shareOnGooglePlusWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailUrl: (NSString *)thumbnailUrl  andWebsiteUrl: (NSString *)url
{
    [GPPShare sharedInstance].delegate = self;
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    if(url.length==0) url = @"http://wutzwhat.com/";
    NSString *shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,url];
    [shareBuilder setURLToShare:[NSURL URLWithString:thumbnailUrl]];
    
    [shareBuilder setPrefillText:shareText];
    
    [shareBuilder setContentDeepLinkID:@"rest=1234567"];
    
    
    [shareBuilder open];
    
}

- (void)finishedSharing: (BOOL)shared {
    if (shared) {
        [self displayNotification:YES];;
    } else {
        [self displayNotification:NO];;
    }
}
-(void)emailWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailImage: (UIImage *)thumbnailImage andWebsiteUrl: (NSString *)url
{
    if ([MFMailComposeViewController canSendMail])
    {
        if(url.length==0) url = @"http://wutzwhat.com/";
        NSString *shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,url];
        
        if ([info isKindOfClass:[NSNull class]]) {
            shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,url];
        }else if ([url isKindOfClass:[NSNull class]])
        {
            shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,@"wutzwhat.com"];
        }else if ([url isKindOfClass:[NSNull class]]&&[info isKindOfClass:[NSNull class]])
        {
            shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,@"wutzwhat.com"];
        }
        self.mailController = [[MFMailComposeViewController alloc] init];
        [self.mailController setMailComposeDelegate:self];
        
        [self.mailController setMessageBody:shareText isHTML:NO];
        [self.mailController setSubject:title];
        [self.mainParentController.navigationController presentViewController:self.mailController animated:YES completion:^(){}];
    }
    else
    {
		[self displayNotification:NO];
    }
}
-(void)textWithTitle:(NSString *)title andInfo:(NSString *)info andWebsiteUrl: (NSString *)url
{
    if ([MFMessageComposeViewController canSendText])
    {
        if(url.length==0) url = @"http://wutzwhat.com/";
        NSString *shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,url];
        
        if ([info isKindOfClass:[NSNull class]]) {
            shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,url];
        }else if ([url isKindOfClass:[NSNull class]])
        {
            shareText=[NSString stringWithFormat:@"Check out %@ (%@) on @wutzwhat: %@",title,info,@"wutzwhat.com"];
        }else if ([url isKindOfClass:[NSNull class]]&&[info isKindOfClass:[NSNull class]])
        {
            shareText=[NSString stringWithFormat:@"Check out %@ on @wutzwhat: %@",title,@"wutzwhat.com"];
        }
        self.msgController = [[MFMessageComposeViewController alloc] init];
        self.msgController.messageComposeDelegate = self;
        [self.msgController setBody:shareText];
        [self.mainParentController.navigationController presentViewController:self.msgController animated:YES completion:^(){}];
    }
    else
    {
		[self displayNotification:FALSE];
    }
}

-(void)shareOnGooglePlusWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode
{
    NSString *preFillText = [NSString stringWithFormat:@"Try a new app called Wutzwhat and find what's best in your city: http://wutzwhat.com Here's a signup bonus: %@",bonusCode];
    [GPPShare sharedInstance].delegate = self;
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    [shareBuilder setURLToShare:[NSURL URLWithString:title]];
    
    [shareBuilder setPrefillText:preFillText];
    
    [shareBuilder open];
}

-(void)emailWithTitle:(NSString *)title
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *body = title;
        self.mailController = [[MFMailComposeViewController alloc] init];
        [self.mailController setMailComposeDelegate:self];

        [self.mailController setMessageBody:body isHTML:NO];
        [self.mailController setToRecipients:[NSArray arrayWithObjects:@"info@wutzwhat.com", nil]];
        [self.mailController setSubject:@"Hello Wutzwhat"];
        [self.mainParentController.navigationController presentViewController:self.mailController animated:YES completion:^(){}];
    }
    else
    {
		[self displayNotification:NO];
    }
}

-(void)emailWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *body = [NSString stringWithFormat:@"Try a new app called Wutzwhat and find what's best in your city: http://wutzwhat.com Here's a signup bonus: %@", bonusCode];
        self.mailController = [[MFMailComposeViewController alloc] init];
        [self.mailController setMailComposeDelegate:self];

        [self.mailController setMessageBody:body isHTML:NO];
        [self.mailController setSubject:@"Try this new app: Wutzwhat"];
        [self.mainParentController.navigationController presentViewController:self.mailController animated:YES completion:^(){}];
    }
    else
    {
		[self displayNotification:NO];        
    }
}

-(void)sendEmailToAddress:(NSString *)toAddress withSubject:(NSString *)subject body:(NSString *)body
{
    if ([MFMailComposeViewController canSendMail])
    {
        self.mailController = [[MFMailComposeViewController alloc] init];
        [self.mailController setMailComposeDelegate:self];
        
        [self.mailController setToRecipients:[NSArray arrayWithObjects:toAddress, nil]];
        [self.mailController setMessageBody:body isHTML:NO];
        [self.mailController setSubject:subject];
        [self.mainParentController.navigationController presentViewController:self.mailController animated:YES completion:^(){}];
    }
    else
    {
		[self displayNotification:NO];        
    }
}

-(void)textWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode
{
    if ([MFMessageComposeViewController canSendText])
    {
        NSString *body = [NSString stringWithFormat:@"Try a new app called Wutzwhat and find what's best in your city: http://wutzwhat.com Here's a signup bonus: %@", bonusCode];
        self.msgController = [[MFMessageComposeViewController alloc] init];
        self.msgController.messageComposeDelegate = self;

        [self.msgController setBody:body];
        self.msgController.navigationBar.barStyle = UIBarStyleDefault;
        [self.mainParentController.navigationController presentViewController:self.msgController animated:YES completion:^(){}];
    }
    else
    {
        [self displayNotification:NO];
    }
}

#pragma mark -
#pragma mark Mail Composer Delegate
#pragma mark -

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	if (result == MFMailComposeResultSent) {
        [self displayNotification:YES];
        
	}
	else if (result == MFMailComposeResultSaved) {
		[self displayNotification:NO];
	}
	else if (result == MFMailComposeResultFailed) {
        [self displayNotification:NO];
 	}else if (result == MFMailComposeResultCancelled) {
		[self displayNotification:NO];
	}
	
	[self.mailController dismissViewControllerAnimated:YES completion:^(){}];
	
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    if (result == MessageComposeResultSent) {
		[self displayNotification:YES];
	}
	else if (result == MessageComposeResultFailed) {
		[self displayNotification:NO];
	}
    else if (result == MessageComposeResultCancelled) {
		[self displayNotification:NO];
	}
	
	[self.msgController dismissViewControllerAnimated:YES completion:^(){}];
    
}


+(void)copyTextToClipboard: (NSString *)textToCopy
{
    [UIPasteboard generalPasteboard].string = textToCopy;
    
}

+(void)setUserAsGuest:(BOOL)isGuest
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isGuestUser = isGuest;
    
    if (isGuest)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"guest" forKey:@"access_token"];
        if(![userDefault objectForKey:@"cityselected"])
            [userDefault setObject:@"Toronto" forKey:@"cityselected"];
        [userDefault synchronize];
        
        appDelegate.facebookData = @{
                                     @"username": @"Guest",
                                     @"city":[userDefault objectForKey:@"cityselected"],
                                     @"profilePicture":@"",
                                     @"email":@""
                                     };
    }
}


+(BOOL)isGuestUser
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.isGuestUser;
}

+(void)showLoginAlertToGuestUser
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isGuestUser)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login" delegate:appDelegate cancelButtonTitle:@"Keep exploring" otherButtonTitles:@"Login", nil];
        [alert setTag:9999];
        [alert show];
    }
    
}


+(CLLocation *)getUserCurrentLocation
{
    LocationManagerHelper *locationManager = [LocationManagerHelper staticLocationManagerObject];
    
    return locationManager.userCurrentLocation;
}


+ (NSString *)getLoginType
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [[appDelegate facebookData] objectForKey:@""];
}

- (void)displayNotification : (BOOL)isSuccessfull
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (isSuccessfull)
    {
        if (_notifySuccess.isAnimating) return;
        
        [appDelegate.window  addSubview:_notifySuccess];
        [_notifySuccess presentWithDuration:1.0f speed:0.5f inView:nil completion:^{
            [_notifySuccess removeFromSuperview];
        }];
    }
    else
    {
        if (_notifyFail.isAnimating) return;
        
        [appDelegate.window addSubview:_notifyFail];
        [_notifyFail presentWithDuration:1.0f speed:0.5f inView:appDelegate.window completion:^{
            [_notifyFail removeFromSuperview];
        }];
    }
    
}


+(void)setAppBadgeNumber:(int)number
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = number;
}

+(NSInteger)getAppBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

#pragma mark - Notification Methods

+(BOOL)isRemoteNotificationClicked
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appDelegate.isNotificationClicked;
}


+(void)setRemoteNotificationRead
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.isNotificationClicked = NO;
}

+(NSDictionary *)getRemoteNotificationDictionary
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appDelegate.notificationDictionary;
}


+(void)setRemoteNotificationDictionaryToNil
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.notificationDictionary = nil;
}


+(BOOL)isPerkPurchased
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appDelegate.isPerkPurchased;
}


+(void)perkPurchasedSuccessfully
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.isPerkPurchased = YES;
}


+(void)setPerkPurchasedOff
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.isPerkPurchased = NO;
}

+(BOOL)isValueExist:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(NSInteger)getDistanceInKM:(NSInteger)distanceInMeters
{
    distanceInMeters = distanceInMeters / 1000;
    
    return distanceInMeters;
}

+(NSInteger)getDistanceInMiles:(NSInteger)distanceInMeters
{
    int miles = distanceInMeters / 1609.34;
    
    return miles;
}

+(NSString *)getDateStringInFormat:(NSString *)dateFormat date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:dateFormat];
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}

+(double)getIntervalFromUnixTimeStamp:(NSString *)postTimeString
{
    if ([self isValueExist:postTimeString])
    {
        postTimeString = [postTimeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        postTimeString = [postTimeString stringByReplacingOccurrencesOfString:@")/" withString:@""];
        NSArray *timeArray = [postTimeString componentsSeparatedByString:@"-"];
        double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
        
        postTimeLong = (postTimeLong/1000);
        
        return postTimeLong;
    }
    else
    {
        return 0;
    }
}

+(NSDate *)getDateFromUnixTimeStamp:(NSString *)timeStamp
{
    NSTimeInterval interval = [CommonFunctions getIntervalFromUnixTimeStamp:timeStamp];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSDate *newDate = [dateFormat dateFromString:dateString];
    
    return newDate;
}

+(NSString *)getPostTimeInFormat:(NSString *)postTimeString
{
    if ([self isValueExist:postTimeString])
    {
        postTimeString = [postTimeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        postTimeString = [postTimeString stringByReplacingOccurrencesOfString:@")/" withString:@""];
        NSArray *timeArray = [postTimeString componentsSeparatedByString:@"-"];
        double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
        
        postTimeLong = (postTimeLong/1000);
        NSDate *tr = [NSDate dateWithTimeIntervalSince1970:postTimeLong];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setDateFormat:@"EEEE MMMM dd"];
        postTimeString = [formatter stringFromDate:tr];
        
        return postTimeString;
    }
    else
    {
        return @"";
    }
}


+(NSArray *)getSortedArrayContainingNSDate:(NSArray *)unSortedArray
{
    NSArray *sortedArray = [unSortedArray sortedArrayUsingComparator:^(id obj1, id obj2)
                            {
                                return [(NSDate*) obj2 compare: (NSDate*)obj1];
                            }];
    return sortedArray;
}


+(NSArray *)getSortedArrayContainingNSNumber:(NSArray *)unSortedArray
{
    NSArray *sortedArray = [unSortedArray sortedArrayUsingComparator:^(id obj1, id obj2)
                            {
                                return [(NSNumber *) obj1 compare: (NSNumber *)obj2];
                            }];
    return sortedArray;
}


+(NSString *)getDistanceStringInMilesUnit:(int)distance
{
    NSString *distanceString;
    
    if (distance <= 100)
    {
        distanceString = @"< 100m";
    }
    else if(distance <= 300)
    {
        distanceString = @"< 300m";
    }
    else if(distance <= 500)
    {
        distanceString = @"< 500m";
    }
    else if(distance <= 1609)
    {
        distanceString = @"< 1mi";
    }
    else if(distance <= 4827)
    {
        distanceString = @"< 3mi";
    }
    else if(distance <= 8045)
    {
        distanceString = @"< 5mi";
    }
    else if(distance <= 16090)
    {
        distanceString = @"< 10mi";
    }
    else if (distance > 16090)
    {
        distanceString = @"> 10mi";
    }
    if (distance >= 100000 || distance >= 160934)
    {
        distanceString = @"> 100mi";
    }
    
    return distanceString;
}


+(NSString *)getDistanceStringInKMUnit:(int)distance
{
    NSString *distanceString;
    
    if (distance <= 100)
    {
        distanceString = @"< 100m";
    }
    else if(distance <= 300)
    {
        distanceString = @"< 300m";
    }
    else if(distance <= 500)
    {
        distanceString = @"< 500m";
    }
    else if(distance <= 1000)
    {
        distanceString = @"< 1km";
    }
    else if(distance <= 3000)
    {
        distanceString = @"< 3km";
    }
    else if(distance <= 5000)
    {
        distanceString = @"< 5km";
    }
    else if(distance <= 10000)
    {
        distanceString = @"< 10km";
    }
    else if (distance > 10000)
    {
        distanceString = @"> 10km";
    }
    if (distance >= 100000 || distance >= 160934)
    {
        distanceString = @"> 100km";
    }

        
    return distanceString;
}


+(NSString *)getDistanceStringInCountryUnitForCell:(NSNumber *)distanceInMeters
{
    NSString *distanceUnitString = [CommonFunctions getDistanceUnitString];
    
    int distance = [distanceInMeters intValue];
    
    if (distance < 1000)
    {
        return [NSString stringWithFormat:@"%dm", distance];
    }
    
    if ([distanceUnitString isEqualToString:@"km"])
    {
        int distanceInKM = MAX(1, distance / 1000);
        
        if (distance >= 100000 || distance >= 160934)
        {
            return @"> 100km";
        }
        else
        {
            return [NSString stringWithFormat:@"%dkm", distanceInKM];
        }
    }
    else
    {
        int distanceInKM = MAX(1, distance / 1609);
        
        if (distance >= 100000 || distance >= 160934)
        {
            return @"> 100mi";
        }
        else
        {
            return [NSString stringWithFormat:@"%dmi", distanceInKM];
        }
    }
}


+(NSString *)getDistanceStringInCountryUnit:(NSNumber *)distanceInMeters
{
    NSString *distanceUnitString = [CommonFunctions getDistanceUnitString];
    
    int distance = [distanceInMeters intValue];
    
    if ([distanceUnitString isEqualToString:@"km"])
    {
        return [CommonFunctions getDistanceStringInKMUnit:distance];
    }
    else
    {
        return [CommonFunctions getDistanceStringInMilesUnit:distance];
    }
}


+(NSString *)getDistanceCellHeaderString:(NSNumber *)distanceInMeters
{
    NSString *distanceUnitString = [CommonFunctions getDistanceUnitString];
 
    if(![distanceInMeters isKindOfClass:[NSNumber class]])
        return @"";
    
    int distance = [distanceInMeters intValue];
    
    if ([distanceUnitString isEqualToString:@"km"])
    {
        return [CommonFunctions getDistanceStringInKMUnit:distance];
    }
    else
    {
        return [CommonFunctions getDistanceStringInMilesUnit:distance];
    }
}

+(NSDictionary *)getURLQueryString:(NSURL *)url
{
    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
    
    for (NSString *qs in [url.query componentsSeparatedByString:@"&"])
    {
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    
    return mdQueryStrings;
}

+(NSString *)getImageModifiedDateFromURL:(NSURL *)url
{
    NSDictionary *dict = [CommonFunctions getURLQueryString:url];
    
    if ([CommonFunctions isValueExist:[dict objectForKey:@"modifiedDate"]])
    {
        return [dict objectForKey:@"modifiedDate"];
    }
    else
    {
        return @"";
    }
}

+(NSString *)getImageCacheKey:(NSURL *)url
{
    NSString *modifiedDate = [CommonFunctions getImageModifiedDateFromURL:url];
    
    url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
    
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", [url absoluteString], modifiedDate];
    
    return cacheKey;
}


+(NSString *)getDistanceUnitString
{
    NSString * distanceUnitString;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if ([[appDelegate.facebookData objectForKey:@"distance_unit"] isEqualToString:@"KM"])
    {
        distanceUnitString = @"km";
    }
    else if ([[appDelegate.facebookData objectForKey:@"distance_unit"] isEqualToString:@"MILES"])
    {
        distanceUnitString = @"mi";
    }
    else
    {
        distanceUnitString = @"km";
    }
    
    return distanceUnitString;
}

+(NSString *)getUSFormatedPhoneNumber:(NSString *)phoneNumber
{
    NSString *number;
    
    if (phoneNumber.length < 10)
    {
        number = phoneNumber;
    }
    else
    {
        number = [NSString stringWithFormat:@"(%@) %@-%@", [phoneNumber substringWithRange:NSMakeRange(0, 3)], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6, 4)]];
    }
    
    return number;
}

+(BOOL)isEmailValid:(NSString *)email
{
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_VALIDATION_REGULAR_EXPRESSION];
    
    return [regExPredicate evaluateWithObject:email];
}

+(void)addShadowOnTopOfView:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.clipsToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.4f;
    view.layer.shadowOffset = CGSizeMake(0, -1.0f);
    view.layer.shadowRadius = 2.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
}

+(NSString *)creatProperURLString:(NSString *)urlString
{
    if ([urlString rangeOfString:@"http"].location == NSNotFound)
    {
        NSMutableString *mStr = [urlString mutableCopy];
        CFStringTrimWhitespace((CFMutableStringRef)mStr);
        
        urlString = [NSString stringWithFormat:@"http://%@", mStr];
        
        mStr = nil;
    }
    return urlString;
}

+(NSString *)removeHTTPString:(NSString *)urlString
{
    if ([urlString rangeOfString:@"http"].location != NSNotFound)
    {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"http" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"https" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"://" withString:@""];        
    }
    return urlString;
}

+(NSString *)getDeviceUUID
{
    NSString *uID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
    
    if (uID)
    {
        return uID;
    }
    else
    {
        uID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [[NSUserDefaults standardUserDefaults] setObject:uID forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return uID;
    }
}

+(NSString *)getDeviceInfo
{
    NSString *deviceModel = [[UIDevice currentDevice] model];
    deviceModel = [[UIDevice currentDevice] systemVersion];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    deviceModel = [NSString stringWithFormat:@"%.0f x %.0f", screenBounds.size.width,screenBounds.size.height];
    
    return deviceModel;
}


+(NSString *)getUserSavedCity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userCity = @"";
    
    if (![[userDefaults objectForKey:@"city"] isKindOfClass:[NSNull class]] && ![[userDefaults objectForKey:@"city"] isEqualToString:@""])
    {
        userCity = [userDefaults objectForKey:@"city"];
    }
    
    return userCity;
}


@end
