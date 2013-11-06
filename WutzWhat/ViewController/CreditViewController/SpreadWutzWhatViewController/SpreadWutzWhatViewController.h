//
//  SpreadWutzWhatViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/23/12.
//
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "CommonFunctions.h"
#import "WutzWhatModel.h"
#import "DataFetcher.h"

@class CommonFunctions;

@interface SpreadWutzWhatViewController : UIViewController
<
DataFetcherDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *lblPromoCode;
@property (nonatomic,retain) WutzWhatModel *menu;
@property (strong, nonatomic) CommonFunctions *sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteViaFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteViaGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteViaTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteViaEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnInviteViaText;
@end
