//
//  LoginViewController.h
//  WutzWhat
//
//  Created by My Mac on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FacebookSignupViewController.h"
#import "MenuViewController.h"
#import "PerksProductDetailViewController.h"
#import "PerksModel.h"
#import "CommonFunctions.h"
#import "FacebookWrapper.h"

@interface LoginViewController : UIViewController
<
    DataFetcherDelegate,
    UITextFieldDelegate,
    UIAlertViewDelegate
>
{
    NSString *access_token;
    NSDictionary *facebookUserData;
    BOOL isFacebookLogin;
    BOOL reActivation;
     NSString *emailString;
}
@property (strong,nonatomic)  NSString *emailString;
@property (strong, nonatomic) IBOutlet UIImageView *logoWutzwhat;
@property (strong, nonatomic) IBOutlet UILabel *description;

@property (strong, nonatomic) IBOutlet UIImageView *imgUsername;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnLoginWithFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSignup;
@property (strong, nonatomic) IBOutlet UIButton *btnExplore;
@property (strong, nonatomic) IBOutlet UIButton *btnTour;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) IBOutlet UILabel *lblLoginTitle;
@property (nonatomic,retain) NSString *access_token;

@property (strong, nonatomic) NSDictionary *facebookUserData;

-(IBAction)loginInPressend:(id)sender;
//-(IBAction)DoneKeyboard:(id)sender;
- (IBAction)btnTour_Pressed:(id)sender;

@end
