//
//  ProfileViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/16/12.
//
//

#import <UIKit/UIKit.h>
#import "EditProfileViewController.h"
#import "EditProfileViewController.h"
#import "SharedManager.h"
#import "DataFetcher.h"
#import "Constants.h"
#import "Utiltiy.h"
#import "SharedManager.h"
#import "ProcessingView.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"


#import "GPPSignIn.h"
#import "GPPSignInButton.h"
@class GPPSignInButton;
@class GTMOAuth2Authentication;
@interface ProfileViewController : UIViewController
<
DataFetcherDelegate,
UIActionSheetDelegate,
GPPSignInDelegate,
UIAlertViewDelegate
>
{
    //birthday picker
    UIDatePicker *birthdayPicker;
    UIToolbar *donebar;
    
    UIView *editView;
    NSDictionary *resultDictionary;
    NSString *access_token;
    NSMutableDictionary *_googlePlusDictionary;
}
@property (strong, nonatomic) UILabel *lblLinkWithGooglePP;
@property (strong, nonatomic) UILabel *lblLinkWithFacebook;
@property (strong, nonatomic) UILabel *lblLinkWithTwitter;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtBaseCity;
@property (strong, nonatomic) NSDictionary *resultDictionary;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkWithFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkWithTwitter;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;
@property (retain, nonatomic) IBOutlet GPPSignInButton *btnLinkWithGooglePlus;
@property (strong, nonatomic) IBOutlet UIButton *btnSignoutTwitter;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet UILabel *defaultSettingsLabel;
@end
