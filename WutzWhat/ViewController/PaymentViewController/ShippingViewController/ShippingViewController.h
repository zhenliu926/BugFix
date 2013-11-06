//
//  ShippingViewController.h
//  WutzWhat
//
//  Created by Rafay on 3/12/13.
//
//

#import <UIKit/UIKit.h>
#import "TaxInfoModel.h"
#import "ShippingAddressModel.h"
#import "Utiltiy.h"
#import "DataFetcher.h"
#import "ProcessingView.h"
#import "PaymentViewController.h"

@interface ShippingViewController : UIViewController <DataFetcherDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;

@property (strong, nonatomic) IBOutlet UITextField *txtfirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtlastName;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtzipCode;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;

@property (strong, nonatomic)TaxInfoModel *infoModel;
@property (strong, nonatomic)NSArray *countryArray;

//for country selection picker view

@property (strong, nonatomic) IBOutlet UIPickerView *pickerCountrySelection;
@property (strong, nonatomic) IBOutlet UIToolbar *pikerViewToolBar;

- (IBAction)btnCancelOnToolBarClicked:(id)sender;
- (IBAction)btnDoneOnToolBarClicked:(id)sender;

@end
