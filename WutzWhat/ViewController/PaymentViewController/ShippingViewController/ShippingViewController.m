//
//  ShippingViewController.m
//  WutzWhat
//
//  Created by Rafay on 3/12/13.
//
//

#import "ShippingViewController.h"

#define COUNTRY_ARRAY [NSArray arrayWithObjects: @"Canada",@"USA", @"Other", nil]

@interface ShippingViewController ()

@end

@implementation ShippingViewController


#pragma mark- Controller Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    self.scrollViewMain.contentSize = CGSizeMake(320, 550);
    self.scrollViewMain.showsHorizontalScrollIndicator = NO;
    self.scrollViewMain.showsVerticalScrollIndicator = NO;
    
    [self setUpNavigationBar];
    
    if (![self.infoModel.addressID isEqualToString:@""])
    {
        [self populateTextFieldWithExistingData:self.infoModel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTxtfirstName:nil];
    [self setTxtlastName:nil];
    [self setTxtAddress:nil];
    [self setTxtCity:nil];
    [self setTxtzipCode:nil];
    [self setTxtState:nil];
    [self setTxtCountry:nil];
    [self setScrollViewMain:nil];
    [self setPickerCountrySelection:nil];
    [self setPikerViewToolBar:nil];
    [super viewDidUnload];
}

-(void)setUpNavigationBar
{
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    [v addSubview:backBtn];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks_2.png"]];
    [[self navigationItem]setTitleView:titleIV];
}


#pragma mark- Button Actions

-(void)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSave_pressed:(id)sender
{
    if ([self validateTextFields])
    {
        [self callUpdateShippingAddressAPI];
    }
}

#pragma mark- Bussiness Logic


#pragma mark- Common View Functions

-(void)populateTextFieldWithExistingData:(TaxInfoModel *)infoModel
{
    self.txtAddress.text = infoModel.streetAddress;
    self.txtCity.text = infoModel.city;
    self.txtCountry.text = infoModel.country;
    self.txtfirstName.text = infoModel.firstName;
    self.txtlastName.text = infoModel.lastName;
    self.txtState.text = infoModel.province;
    self.txtzipCode.text = infoModel.postalCode;
}

#pragma mark- TextField Validations

-(BOOL)validateTextFields
{
    if (self.txtfirstName.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtfirstName becomeFirstResponder];
        return NO;
    }
    else if (self.txtlastName.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtlastName becomeFirstResponder];
        return NO;
    }
    else if (self.txtAddress.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtAddress becomeFirstResponder];
        return NO;
    }
    else if (self.txtCity.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtCity becomeFirstResponder];
        return NO;
    }
    else if (self.txtzipCode.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtzipCode becomeFirstResponder];
        return NO;
    }
    else if (self.txtState.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtState becomeFirstResponder];
        return NO;        
    }
    else if (self.txtCountry.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALL_FIELDS];
        [self.txtCountry becomeFirstResponder];
        return NO;        
    }
    else if (![COUNTRY_ARRAY containsObject:self.txtCountry.text])
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_VALID_COUNTRY];
        [self.txtCountry becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark- API Call Method Delegates

-(void)callUpdateShippingAddressAPI
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (![self.infoModel.addressID isEqualToString:@""])
    {
         [params setValue:self.infoModel.addressID forKey:@"addr_id"];
    }
    
    [params setValue:self.txtfirstName.text forKey:@"first_name"];
    [params setValue:self.txtlastName.text forKey:@"last_name"];
    [params setValue:self.txtAddress.text forKey:@"street_address"];
    [params setValue:self.txtzipCode.text forKey:@"postal_code"];
    [params setValue:self.txtCity.text forKey:@"city"];
    [params setValue:self.txtState.text forKey:@"province"];
    [params setValue:self.txtCountry.text forKey:@"country"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_SHIPPING_ADDRESS] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_SHIPPING_ADDRESS]])
    {
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess)
        {
            NSString *addressID = [responseData objectForKey:@"addr_id"];
            
            NSArray *controllersArray = [self.navigationController viewControllers];
            PaymentViewController *controller = (PaymentViewController *)[controllersArray objectAtIndex:[controllersArray count] - 2];
            
            controller.addressID = addressID;
            
            [self.navigationController popToViewController:controller animated:YES];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        }
    }
}

- (void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_SHIPPING_ADDRESS]])
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
    }
}


#pragma mark - Text Fields Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtCountry)
    {
        [self.pickerCountrySelection setHidden:NO];
        [self.pikerViewToolBar setHidden:NO];
        [textField setInputAccessoryView:self.pikerViewToolBar];
        [textField setInputView:self.pickerCountrySelection];
    }
    return YES;
}


#pragma mark - Country Selection Methods

- (IBAction)btnCancelOnToolBarClicked:(id)sender
{
    self.txtCountry.text = @"";
    [self.txtCountry resignFirstResponder];
}


- (IBAction)btnDoneOnToolBarClicked:(id)sender
{
    int index = [self.pickerCountrySelection selectedRowInComponent:0];
    self.txtCountry.text = [COUNTRY_ARRAY objectAtIndex:index];
    [self.txtCountry resignFirstResponder];
}

#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [COUNTRY_ARRAY count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [COUNTRY_ARRAY objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //do nothing here.. :D
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


