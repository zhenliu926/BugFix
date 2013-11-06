//
//  RedeemCreditViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/23/12.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataFetcher.h"

@interface RedeemCreditViewController : UIViewController<DataFetcherDelegate>


@property (strong, nonatomic) IBOutlet UITextField *txtRedeemCode;
@property (strong, nonatomic) IBOutlet UILabel *titleRedeem;
@property (strong, nonatomic) IBOutlet UIButton *sbtBtn;
@property (strong, nonatomic) IBOutlet UIImageView *textImg;

@property (strong, nonatomic) NSString *promoCode;

@end
