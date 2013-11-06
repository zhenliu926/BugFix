//
//  PaymentViewController.h
//  WutzWhat
//
//  Created by Rafay on 3/12/13.
//
//

#import <UIKit/UIKit.h>
#import "PerksModel.h"
#import "OptionsViewController.h"
#import "ShippingAddressModel.h"
#import "ShippingViewController.h"
#import "TaxInfoModel.h"
#import "DataFetcher.h"
#import "Utiltiy.h"
#import "ProcessingView.h"
#import "UIImageView+WebCache.h"
#import "CreditCardViewController.h"
#import "MyPerksViewController.h"
#import "TermsofServiceViewController.h"
#import "STPView.h"


@interface PaymentViewController : UIViewController <DataFetcherDelegate,STPViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    
    NSMutableArray *visibleViews;
    TaxInfoModel *taxInfoModel;
    NSMutableArray *quantityArray;
    int userSelectedQuantity;
    BOOL canUserBuyPerk;
}

//@property STPView* stripeView;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UILabel *lblPerkTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPerkDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblPerkCredit;
@property (strong, nonatomic) IBOutlet UIImageView *imgFavourit;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imgPerkThumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *imgLove;
@property (strong, nonatomic) IBOutlet UILabel *lblLoveCount;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UIButton * btncreditsOptions;
@property (strong, nonatomic) IBOutlet UIButton * btnConfirmPurchase;

@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalCredit;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPayment;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTax;
@property (strong, nonatomic) IBOutlet UILabel *lblShippingCost;
@property (strong, nonatomic) IBOutlet UILabel *lblShippingAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblOptions;

@property (nonatomic,retain) PerksModel *perksModel;
@property (nonatomic,assign) BOOL hasShippingFacility;
@property (nonatomic,retain) NSString *addressID;
@property (strong, nonatomic) NSString *termsOfServices;

@property (strong, nonatomic) IBOutlet UIView *viewOptions;
@property (strong, nonatomic) IBOutlet UIView *viewTaxInfo;
@property (strong, nonatomic) IBOutlet UIView *viewShippingAddress;
@property (strong, nonatomic) IBOutlet UIView *viewButtom;

@property (nonatomic, strong)NSString *optionsString;
@property (nonatomic, strong)NSString *optionsCreditsString;
@property (nonatomic, assign)BOOL optionsCredits;

@property (nonatomic, retain)UIActionSheet *actionSheet;
@property (nonatomic, retain)UIPickerView *uiPickerView;


- (IBAction)btnCreditOptionsClicked:(id)sender;
- (IBAction)btnTermsOfUseClicked:(id)sender;
- (IBAction)btnOptions_pressed:(id)sender;
- (IBAction)btnQuantity_pressed:(id)sender;
- (IBAction)btnConfirmPurchase_pressed:(id)sender;
- (IBAction)btnShippingAddress_pressed:(id)sender;
- (IBAction)btnCreditCard_pressed:(id)sender;
- (IBAction)btnTermsOfServicsClicked:(id)sender;


@end
