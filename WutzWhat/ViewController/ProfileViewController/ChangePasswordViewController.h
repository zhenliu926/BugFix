//
//  ChangePasswordViewController.h
//  WutzWhat
//
//  Created by Rafay on 1/2/13.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataFetcher.h"
#import "Utiltiy.h"

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate, DataFetcherDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *oldPass;
@property (strong, nonatomic) IBOutlet UIImageView *thenewPass;
@property (strong, nonatomic) IBOutlet UIButton *sbtBtn;

@end
