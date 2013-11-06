//
//  AddCreditCardViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 2/25/13.
//
//

#import "AddCreditCardViewController.h"

@interface AddCreditCardViewController ()

@end

@implementation AddCreditCardViewController

@synthesize txtCardNumber = _txtCardNumber;
@synthesize txtCVV = _txtCVV;
@synthesize txtExpirationDate = _txtExpirationDate;
@synthesize txtName = _txtName;
@synthesize txtPhoneNumber = _txtPhoneNumber;
@synthesize scrollView = _scrollView;

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
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(320, 600);
    
    if(OS_VERSION>=7)
    {
        self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x,self.scrollView.frame.origin.y+44,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        
    }
    
    
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,44,290,55)
                                              andKey:@"pk_test_dXpdgOOiQ5TJQB5ifcIkFY5v"];
    
    self.stripeView.delegate = self;
  //  [self.view addSubview:self.stripeView];
    
    
    
    [self setUpHeaderView];
    
    [self setUpTextFields];
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    NSString *valid_text;
    if(valid)
        valid_text=[NSString stringWithFormat:@"%@",@"Card is valid"];
    else
        valid_text=[NSString stringWithFormat:@"%@",@"Card is  invalid"];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Vaild" message:valid_text delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    // Toggle navigation, for example
    // self.saveButton.enabled = valid;
    
    if(valid)
    {
        [self.stripeView createToken:^(STPToken *token, NSError *error) {
            if (error) {
                // Handle error
                // [self handleError:error];
            } else {
                
                NSLog(@"%@",token.tokenId);
                
                // Send off token to your server
                // [self handleToken:token];
            }
        }];
    }
}

- (void)handleError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setUpHeaderView
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];    
    
    UIImageView *titleIV1 = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_credits.png"]];
    [[self navigationItem]setTitleView:titleIV1];
}


-(void)setUpTextFields
{
    self.txtExpirationDate.type = PopupTypeExpiryDate;
    [self.txtExpirationDate apply];
}

#pragma mark- Button Events

-(void)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setTxtName:nil];
    [self setTxtCardNumber:nil];
    [self setTxtExpirationDate:nil];
    [self setTxtCVV:nil];
    [self setTxtPhoneNumber:nil];
    [self setBtnAddCreditCard:nil];
    [super viewDidUnload];
}

- (IBAction)btnAddCreditCardClicked:(id)sender
{
    [self addCreditCard];
}

#pragma mark- Get Credit Card Info

-(void)addCreditCard
{
    if ([self validateTextFields])
    {
        BraintreeEncryption * braintree = [[BraintreeEncryption alloc] initWithPublicKey: PAYMENT_PUBLIC_KEY];
        
        NSString *cardNumber = [braintree encryptString:self.txtCardNumber.text];
        NSString *cvv = [braintree encryptString:self.txtCVV.text];
        NSString *cardExpiryDate = [braintree encryptString:self.txtExpirationDate.text];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        
        [params setObject:self.txtName.text forKey:@"c_holder_name"];
        
        [params setObject:self.txtName.text forKey:@"stripe_card_token"];
        
        [params setObject:cardNumber forKey:@"c_num"];
        
        [params setObject:cardExpiryDate forKey:@"c_expiry"];
        
        [params setObject:cvv forKey:@"c_cvv"];
        
        [params setObject:self.txtPhoneNumber.text forKey:@"c_phone"];
        
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, ADD_CARD_TO_USER_ACCOUNT]
                     andDelegate:self
                  andRequestType:@"POST"
                 andPostDataDict:params];
        [[ProcessingView instance] forceShowTintView];
    }
}

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, ADD_CARD_TO_USER_ACCOUNT]])
    {
        if ([self isValueExist:[responseData objectForKey:@"result"]] && [self isServerSuccessResponse:[responseData objectForKey:@"result"]])
        {
            int lastViewControllerIndex = [self.navigationController.viewControllers count] - 2;
            
            CreditCardViewController *controller = (CreditCardViewController *)[[self.navigationController viewControllers] objectAtIndex:lastViewControllerIndex];
            
            controller.isCardAddedSuccessfully = YES;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showAlertView:[responseData objectForKey:@"error"]];
        }
    }
}

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, ADD_CARD_TO_USER_ACCOUNT]])
    {
        [self showAlertView:MSG_FAILED];
    }
}

-(BOOL)isValueExist:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)isServerSuccessResponse:(id)value
{
    return [value isEqualToString:@"true"];
}


-(BOOL)validateTextFields
{
    if (self.txtName.text.length == 0)
    {
        [self showAlertView:MSG_ENTER_NAME];
        return NO;
    }
    if (self.txtCardNumber.text.length < 14)
    {
        [self showAlertView:MSG_INAVLID_CARD_NUMBER];
        return NO;
    }
    if (self.txtCVV.text.length != 3)
    {
        [self showAlertView:MSG_INVALID_CVV_NUMBER];
        return NO;
    }
    if (self.txtExpirationDate.text.length == 0 || ![self isValidExpiryDate:self.txtExpirationDate.text])
    {
        [self showAlertView:MSG_INVALID_EXPIRY_DATE];
        return NO;
    }
    if (self.txtPhoneNumber.text.length == 0 || ![self isValidPhoneNumber:self.txtPhoneNumber.text])
    {
        [self showAlertView:MSG_PHONE_NUMBER];
        return NO;
    }
    return YES;
}

-(BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length < 7)
    {
        return NO;
    }
    return YES;
}

-(BOOL)isValidExpiryDate:(NSString *)expiryDate
{
    if (expiryDate.length < 7)
    {
        return NO;
    }
    return YES;
}


-(void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


