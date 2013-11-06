//
//  SignupViewController.h
//  WutzWhat
//
//  Created by My Mac on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "CityViewController.h"

@interface SignupViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,DataFetcherDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    NSTimer *timer;
    UIImage *imageofButton;
    BOOL isEmailAvailable;
    BOOL isUserNameAvailable;
    NSDictionary *resultDictionary;
}

@property (strong, nonatomic) BDKNotifyHUD *notifySuccess;
@property (strong, nonatomic) BDKNotifyHUD *notifyFail;
@property (strong, nonatomic) IBOutlet UIButton *btnImgSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnCityName;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) NSDictionary *resultDictionary;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtReferralCode;

- (IBAction)btnSelectCityClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgUserEmailValidator;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserNameValidator;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserPasswordValidator;


@end
