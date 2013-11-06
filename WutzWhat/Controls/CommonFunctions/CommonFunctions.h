//
//  CommonFunctions.h
//  WutzWhat
//
//  Created by iPhone Development on 3/17/13.
//
//

#import <Foundation/Foundation.h>
#import "Utiltiy.h"
#import "GPPShare.h"
#import "TSMiniWebBrowser.h"
#import "GPPSignIn.h"
#import "LoginViewController.h"
#import "GTLPlusConstants.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "SpreadWutzWhatViewController.h"
#import "BDKNotifyHUD.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <CommonCrypto/CommonDigest.h>

@protocol CommonFunctionDelegate <NSObject>

-(void)doneFacebookShare;

@end

@interface CommonFunctions : NSObject
<
UIActionSheetDelegate,
GPPShareDelegate,
TSMiniWebBrowserDelegate,
GPPSignInDelegate,
MFMailComposeViewControllerDelegate,
ABNewPersonViewControllerDelegate,
EKEventEditViewDelegate,
UINavigationControllerDelegate,
MFMessageComposeViewControllerDelegate
>
{
    BOOL isPhotoFacebookShare;
    NSString *shareOnFaceBookText;
    UIImage *shareOnFaceBookImage;
}

@property (retain, nonatomic) BDKNotifyHUD *notifySuccess;
@property (retain, nonatomic) BDKNotifyHUD *notifyFail;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic,retain) NSString *bonusCode;
@property (nonatomic,strong) MFMailComposeViewController *mailController;
@property (nonatomic,strong) MFMessageComposeViewController *msgController;
@property (nonatomic,strong) UIViewController *mainParentController;
@property (nonatomic, assign) id<CommonFunctionDelegate> delegate;

- (id) initWithParent:(UIViewController*) mainController;
+(void)makePromptCall:(NSString *)phoneNumber;
-(void)addEventToCalendar:(NSString *)title description:(NSString *)description startDate:(NSString *)startDateStamp endDate:(NSString *)endDateStamp link: (NSString *)link location : (NSString *)location;
-(void)shareOnFaceBookWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailImage: (UIImage *)thumbnailImage  andWebsiteUrl: (NSString *)url ;
-(void) performPublishAction:(void (^)(void)) action;
-(void)shareOnTwitterWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailImage: (UIImage *)thumbnailImage  andWebsiteUrl: (NSString *)url;
-(void)shareOnGooglePlusWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailUrl: (NSString *)thumbnailUrl  andWebsiteUrl: (NSString *)url;
-(void)emailWithTitle:(NSString *)title andInfo:(NSString *)info andThumbnailImage: (UIImage *)thumbnailImage  andWebsiteUrl: (NSString *)url;
-(void)textWithTitle:(NSString *)title andInfo:(NSString *)info andWebsiteUrl: (NSString *)url;
+(void)copyTextToClipboard: (NSString *)textToCopy;
-(void)sendEmailToAddress:(NSString *)toAddress withSubject:(NSString *)subject body:(NSString *)body;
+(void)addNewContactWithTitle:(NSString *)title  andAddress: (NSString*)address andPhoneNumber: (NSString*)phoneNumber andThumbnailImage: (UIImage*)thumbnailImage;
+(void)setUserAsGuest:(BOOL)isGuest;
+(BOOL)isGuestUser;
+(void)showLoginAlertToGuestUser;

-(void)shareOnFaceBookWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode;
-(void)shareOnTwitterWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode;
-(void)shareOnGooglePlusWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode;
-(void)emailWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode;
-(void)textWithTitle:(NSString *)title bonusCode:(NSString *)bonusCode;
-(void)emailWithTitle:(NSString *)title;
+(CLLocation *)getUserCurrentLocation;
+(void)setAppBadgeNumber:(int)number;
+(NSInteger)getAppBadgeNumber;
+(BOOL)isRemoteNotificationClicked;
+(void)setRemoteNotificationRead;
+(NSDictionary *)getRemoteNotificationDictionary;
+(void)setRemoteNotificationDictionaryToNil;

+(BOOL)isPerkPurchased;
+(void)perkPurchasedSuccessfully;
+(void)setPerkPurchasedOff;

+(BOOL)isValueExist:(id)value;
+(NSInteger)getDistanceInKM:(NSInteger)distanceInMeters;
+(NSInteger)getDistanceInMiles:(NSInteger)distanceInMeters;

- (void)displayNotification : (BOOL)isSuccessfull;

+(NSString *)getDateStringInFormat:(NSString *)dateFormat date:(NSDate *)date;
+(double)getIntervalFromUnixTimeStamp:(NSString *)postTimeString;
+(NSDate *)getDateFromUnixTimeStamp:(NSString *)timeStamp;
+(NSString *)getPostTimeInFormat:(NSString *)postTimeString;


+(NSArray *)getSortedArrayContainingNSDate:(NSArray *)unSortedArray;
+(NSArray *)getSortedArrayContainingNSNumber:(NSArray *)unSortedArray;

+(NSString *)getDistanceCellHeaderString:(NSNumber *)distanceInMeters;
+(NSString *)getDistanceStringInCountryUnitForCell:(NSNumber *)distanceInMeters;
+(NSDictionary *)getURLQueryString:(NSURL *)url;
+(NSString *)getImageModifiedDateFromURL:(NSURL *)url;
+(NSString *)getImageCacheKey:(NSURL *)url;

+(NSString *)getDistanceUnitString;
+(NSString *)getDistanceStringInCountryUnit:(NSNumber *)distanceInMeters;

+(NSString *)getUSFormatedPhoneNumber:(NSString *)phoneNumber;

+(BOOL)isEmailValid:(NSString *)email;
+(void)addShadowOnTopOfView:(UIView *)view;
+(NSString *)creatProperURLString:(NSString *)urlString;
+(NSString *)removeHTTPString:(NSString *)urlString;
+(NSString *)getDeviceUUID;
+(NSString *)getDeviceInfo;
+ (NSString *)encryptPassword:(NSString *)password;
+(NSString *)getUserSavedCity;
@end
