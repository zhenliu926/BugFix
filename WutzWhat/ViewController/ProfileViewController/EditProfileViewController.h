//
//  EditProfileViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/16/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "DataFetcher.h"
#import "Base64.h"
#import "UIImageView+WebCache.h"
#import "ChangePasswordViewController.h"

@interface EditProfileViewController : UIViewController<DataFetcherDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate>
{
     NSDictionary *resultDictionary;
}
@property (strong, nonatomic) IBOutlet UIButton *btnImgSelect;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCity;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnChangePass;
@property (strong, nonatomic) IBOutlet UIImageView *line1;
@property (strong, nonatomic) IBOutlet UIImageView *line2;
@property (strong, nonatomic) IBOutlet UILabel *lblTextInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblEditTitle;
@property (strong, nonatomic) NSDictionary *resultDictionary;

- (IBAction)btnSelectCityClicked:(id)sender;
- (IBAction)showPasswordScreen:(id)sender;


@end
