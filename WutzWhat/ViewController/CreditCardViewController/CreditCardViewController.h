//
//  CreditCardViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 2/25/13.
//
//

#import <UIKit/UIKit.h>
#import "SharedManager.h"
#import "DataFetcher.h"
#import "Constants.h"
#import "Utiltiy.h"
#import "CreditCardInfoModel.h"
#import "AddCreditCardViewController.h"

@interface CreditCardViewController : UIViewController <DataFetcherDelegate, UIAlertViewDelegate>
{
    NSArray *userCards;
    UIButton *editBtn;
    int clickedCardIndex;
}

@property (strong, nonatomic) IBOutlet UIView *viewCreditCard1;
@property (strong, nonatomic) IBOutlet UIView *viewCreditCard2;
@property (strong, nonatomic) IBOutlet UIView *viewCreditCard3;

@property (strong, nonatomic) IBOutlet UILabel *lblCreditCard;


@property (strong, nonatomic) IBOutlet UIButton *btnDeleteCard1;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteCard2;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteCard3;



@property (strong, nonatomic) IBOutlet UIButton *btnCreditCardInfo1;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNewCreditCard;


@property (strong, nonatomic) IBOutlet UILabel *lblCardNumber1;
@property (strong, nonatomic) IBOutlet UILabel *lblCardType1;
@property (strong, nonatomic) IBOutlet UIImageView *imgDefaultCard1;


@property (strong, nonatomic) IBOutlet UILabel *lblCardNumber2;
@property (strong, nonatomic) IBOutlet UILabel *lblCardType2;
@property (strong, nonatomic) IBOutlet UIImageView *imgDefaultCard2;


@property (strong, nonatomic) IBOutlet UILabel *lblCardNumber3;
@property (strong, nonatomic) IBOutlet UILabel *lblCardType3;
@property (strong, nonatomic) IBOutlet UIImageView *imgDefaultCard3;

@property (assign, nonatomic) BOOL isCardAddedSuccessfully;


- (IBAction)btnCreditCard1Clicked:(id)sender;
- (IBAction)btnCreditCard2Clicked:(id)sender;
- (IBAction)btnCreditCard3Clicked:(id)sender;


- (IBAction)btnDeleteCard1Clicked:(id)sender;
- (IBAction)btnDeleteCard2Clicked:(id)sender;
- (IBAction)btnDeleteCard3Clicked:(id)sender;


- (IBAction)btnAddNewCreditCardClicked:(id)sender;


@end
