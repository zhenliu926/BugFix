//
//  CreditCardViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 2/25/13.
//
//

#import "CreditCardViewController.h"

@interface CreditCardViewController ()

@end

@implementation CreditCardViewController

@synthesize isCardAddedSuccessfully = _isCardAddedSuccessfully;

@synthesize btnAddNewCreditCard, btnCreditCardInfo1, btnDeleteCard1, btnDeleteCard2, btnDeleteCard3, imgDefaultCard1, imgDefaultCard2, imgDefaultCard3, lblCardNumber1, lblCardNumber2, lblCardNumber3, lblCardType1, lblCardType2, lblCardType3, viewCreditCard1, viewCreditCard2, viewCreditCard3,lblCreditCard;

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
    
    [self setUpHeaderView];
    
    userCards = [[NSArray alloc] init];
    
    [self displayUserCardsInfo:userCards];
    
    self.isCardAddedSuccessfully = NO;
    
    [self getCreditCardInfo];
    
    if(OS_VERSION>=7)
    {
        self.lblCreditCard.frame=CGRectMake(self.lblCreditCard.frame.origin.x,self.lblCreditCard.frame.origin.y+44,self.lblCreditCard.frame.size.width,self.lblCreditCard.frame.size.height);
        
        self.btnAddNewCreditCard.frame=CGRectMake(self.btnAddNewCreditCard.frame.origin.x,self.btnAddNewCreditCard.frame.origin.y+44,self.btnAddNewCreditCard.frame.size.width,self.btnAddNewCreditCard.frame.size.height);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isCardAddedSuccessfully)
    {
        [self getCreditCardInfo];
    }
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
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImage *forwardButton = [UIImage imageNamed:@"top_edit.png"];
    UIImage *forwardButtonPressed = [UIImage imageNamed:@"top_edit_c.png"];
    
    editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, forwardButton.size.width, forwardButton.size.height)];
    [editBtn addTarget:self action:@selector(editBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [editBtn setImage:forwardButton forState:UIControlStateNormal];
    [editBtn setImage:forwardButtonPressed forState:UIControlStateHighlighted];
    UIBarButtonItem *rightbtnItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [[self navigationItem]setRightBarButtonItem:rightbtnItem ];
    
    UIImageView *titleIV1 = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_credits.png"]];
    [[self navigationItem]setTitleView:titleIV1];
}

- (void)viewDidUnload
{
    [self setBtnCreditCardInfo1:nil];
    [self setBtnAddNewCreditCard:nil];
    [self setViewCreditCard1:nil];
    [self setViewCreditCard2:nil];
    [self setViewCreditCard3:nil];
    [self setLblCardNumber1:nil];
    [self setLblCardType1:nil];
    [self setImgDefaultCard1:nil];
    [self setLblCardNumber2:nil];
    [self setLblCardType2:nil];
    [self setImgDefaultCard2:nil];
    [self setLblCardNumber3:nil];
    [self setLblCardType3:nil];
    [self setImgDefaultCard3:nil];
    [self setBtnDeleteCard1:nil];
    [self setBtnDeleteCard2:nil];
    [self setBtnDeleteCard3:nil];
    [super viewDidUnload];
}


#pragma mark- Button Events

-(void)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)editBtnTapped:(id)sender
{
    [self showDeleteButtonOnCreditCards];
}


- (IBAction)btnCreditCard1Clicked:(id)sender
{
    clickedCardIndex = 0;
    if ([userCards objectAtIndex:clickedCardIndex])
    {
        [self setUserDefaultCard:[userCards objectAtIndex:clickedCardIndex]];
    }
}

- (IBAction)btnCreditCard2Clicked:(id)sender
{
    clickedCardIndex = 1;
    if ([userCards objectAtIndex:clickedCardIndex])
    {
        [self setUserDefaultCard:[userCards objectAtIndex:clickedCardIndex]];
    }
}

- (IBAction)btnCreditCard3Clicked:(id)sender
{
    clickedCardIndex = 2;
    if ([userCards objectAtIndex:clickedCardIndex])
    {
        [self setUserDefaultCard:[userCards objectAtIndex:clickedCardIndex]];
    }
}

- (IBAction)btnDeleteCard1Clicked:(id)sender
{
    clickedCardIndex = 0;
    [self showConfirmAlertView];
}

- (IBAction)btnDeleteCard2Clicked:(id)sender
{
    clickedCardIndex = 1;
    [self showConfirmAlertView];
}

- (IBAction)btnDeleteCard3Clicked:(id)sender
{
    clickedCardIndex = 2;
    [self showConfirmAlertView];
}

- (IBAction)btnAddNewCreditCardClicked:(id)sender
{
    AddCreditCardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCreditCardViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark- Get Credit Card Info

-(void)getCreditCardInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_CARD_INFO]
                 andDelegate:self
              andRequestType:@"POST"
             andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];    
}

-(void)deleteCreditCardAPICall:(CreditCardInfoModel *)model
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setObject:model.cardToken forKey:@"card_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, DELETE_USER_CARD]
                 andDelegate:self
              andRequestType:@"POST"
             andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];    
}

-(void)setUserDefaultCard:(CreditCardInfoModel *)model
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setObject:model.cardToken forKey:@"card_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, SET_USER_DEFAULT_CARD]
                 andDelegate:self
              andRequestType:@"POST"
             andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_CARD_INFO]])
    {
        if ([self isValueExist:[responseData objectForKey:@"data"]])
        {
            userCards = [CreditCardInfoModel parseCreditCardInfoFromArray:[responseData objectForKey:@"data"]];
            [self displayUserCardsInfo:userCards];
        }
    }
    else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, DELETE_USER_CARD]])
    {
        if ([self isValueExist:[responseData objectForKey:@"result"]] && [self isServerSuccessResponse:[responseData objectForKey:@"result"]])
        {
            [self deleteUserCardFromView];
        }
        else
        {
            [self showAlertView:MSG_FAILED];
        }
    }
    else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, SET_USER_DEFAULT_CARD]])
    {
        if ([self isValueExist:[responseData objectForKey:@"result"]] && [self isServerSuccessResponse:[responseData objectForKey:@"result"]])
        {
            [self setDefaultCreditCardImage];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showAlertView:MSG_FAILED];
        }
    }
}

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_CARD_INFO]])
    {
        [self showAlertView:MSG_FAILED];
    }
    else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, DELETE_USER_CARD]])
    {
        [self showAlertView:MSG_FAILED];
    }
    else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, SET_USER_DEFAULT_CARD]])
    {
        [self showAlertView:MSG_FAILED];
    }
}


-(BOOL)isServerSuccessResponse:(id)value
{
    return [value isEqualToString:@"true"];
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

-(void)displayUserCardsInfo:(NSArray *)modelArray
{
    int cardsCount = [modelArray count];
    if (cardsCount > 0)
    {
        self.viewCreditCard1.hidden = NO;
        self.viewCreditCard2.hidden = YES;
        self.viewCreditCard3.hidden = YES;
        editBtn.hidden = NO;
        
        [self showCardInfoOnButton:1 model:[modelArray objectAtIndex:0]];
        
        [self changeAddNewCreditCardButtonPlace:self.viewCreditCard1.frame.origin.y + 100];
        
        if (cardsCount > 1)
        {
            self.viewCreditCard1.hidden = NO;
            self.viewCreditCard2.hidden = NO;
            self.viewCreditCard3.hidden = YES;
            
            [self showCardInfoOnButton:2 model:[modelArray objectAtIndex:1]];
            
            [self changeAddNewCreditCardButtonPlace:self.viewCreditCard2.frame.origin.y + 100];
        }
        if(cardsCount > 2)
        {
            self.viewCreditCard1.hidden = NO;
            self.viewCreditCard2.hidden = NO;
            self.viewCreditCard3.hidden = NO;
            
            [self showCardInfoOnButton:3 model:[modelArray objectAtIndex:2]];
            
            [self changeAddNewCreditCardButtonPlace:self.viewCreditCard3.frame.origin.y + 100];
        }
        
        if(cardsCount == 1)
        {
            self.viewCreditCard1.frame = CGRectMake(self.viewCreditCard1.frame.origin.x, self.viewCreditCard1.frame.origin.y + 15, self.viewCreditCard1.frame.size.width, self.viewCreditCard1.frame.size.height);
        }
    }
    else
    {
        self.viewCreditCard1.hidden = YES;
        self.viewCreditCard2.hidden = YES;
        self.viewCreditCard3.hidden = YES;
        editBtn.hidden = YES;
        [self changeAddNewCreditCardButtonPlace:self.viewCreditCard1.frame.origin.y + 50];
    }
}

-(void)showCardInfoOnButton:(int)buttonIndex model:(CreditCardInfoModel *)model
{
    if (buttonIndex == 1)
    {
        self.lblCardNumber1.text = model.cardNumber;
        self.lblCardType1.hidden = NO;
        self.btnDeleteCard1.hidden = YES;
        self.lblCardType1.text = model.cardType;
        self.imgDefaultCard1.hidden = !model.defaultCard;
    }
    else if (buttonIndex == 2)
    {
        self.lblCardNumber2.text = model.cardNumber;
        self.lblCardType2.hidden = NO;
        self.btnDeleteCard2.hidden = YES;
        self.lblCardType2.text = model.cardType;
        self.imgDefaultCard2.hidden = !model.defaultCard;
    }
    else if (buttonIndex == 3)
    {
        self.lblCardNumber3.text = model.cardNumber;
        self.lblCardType3.hidden = NO;
        self.btnDeleteCard3.hidden = YES;
        self.lblCardType3.text = model.cardType;
        self.imgDefaultCard3.hidden = !model.defaultCard;
    }
}

-(void)changeAddNewCreditCardButtonPlace:(float)yAxis
{
    self.btnAddNewCreditCard.frame = CGRectMake(self.btnAddNewCreditCard.frame.origin.x, yAxis, self.btnAddNewCreditCard.frame.size.width, self.btnAddNewCreditCard.frame.size.height);
}

-(void)setDefaultCreditCardImage
{
    self.imgDefaultCard1.hidden = clickedCardIndex != 0;
    self.imgDefaultCard2.hidden = clickedCardIndex != 1;
    self.imgDefaultCard3.hidden = clickedCardIndex != 2;
}

-(void)deleteUserCardFromView
{
    [self getCreditCardInfo];
}


-(void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)showDeleteButtonOnCreditCards
{
    self.lblCardType1.hidden = !self.lblCardType1.hidden;
    self.lblCardType2.hidden = !self.lblCardType2.hidden;
    self.lblCardType3.hidden = !self.lblCardType3.hidden;
    
    self.btnDeleteCard1.hidden = !self.lblCardType1.hidden;
    self.btnDeleteCard2.hidden = !self.lblCardType2.hidden;
    self.btnDeleteCard3.hidden = !self.lblCardType3.hidden;
}

#pragma mark- Alert View Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self deleteCreditCardAPICall:[userCards objectAtIndex:clickedCardIndex]];
    }
}

-(void)showConfirmAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


