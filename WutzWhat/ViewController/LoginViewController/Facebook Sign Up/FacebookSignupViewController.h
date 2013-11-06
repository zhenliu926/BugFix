//
//  FacebookSignupViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 16/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataFetcher.h"
#import "Base64.h"

@interface FacebookSignupViewController : UIViewController
<
UIActionSheetDelegate,UIImagePickerControllerDelegate,DataFetcherDelegate,UITextFieldDelegate,UINavigationControllerDelegate
>
{
    NSTimer *timer;
    BOOL isUserNameAvailable;
    NSString *encodedString;
    NSDictionary *resultDictionary;
}

@property (strong, nonatomic) NSDictionary *resultDictionary;

@property (strong, nonatomic) IBOutlet UIButton *btnImgSelect;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UIButton *signupFBButton;
- (IBAction)btnImgSelect_click:(UIGestureRecognizer*)sender;
- (IBAction)btnSignUp_click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCity;

- (IBAction)btnSelectCityClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgUserNameValidator;

@property (strong, nonatomic) IBOutlet UITextField *referral_field;


@end
