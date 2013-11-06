//
//  AddCreditCardViewController.h
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
#import "CreditCardModel.h"
#import "CreditCardTypeField.h"
#import "BraintreeEncryption.h"
#import "CreditCardViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "STPView.h"

@interface AddCreditCardViewController : UIViewController <DataFetcherDelegate,STPViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property STPView* stripeView;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet CreditCardTypeField *txtExpirationDate;
@property (strong, nonatomic) IBOutlet UITextField *txtCVV;

@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;

@property (strong, nonatomic) IBOutlet UIButton *btnAddCreditCard;


- (IBAction)btnAddCreditCardClicked:(id)sender;

@end
