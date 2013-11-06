//
//  RedeemCreditViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/23/12.
//
//

#import "RedeemCreditViewController.h"
#import "DataFetcher.h"
#import "Utiltiy.h"

@interface RedeemCreditViewController ()

@end

@implementation RedeemCreditViewController

@synthesize promoCode = _promoCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
	UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_credits.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    if (![self.promoCode isEqualToString:@""] && self.promoCode != nil)
    {
        self.txtRedeemCode.text = self.promoCode;
        self.txtRedeemCode.enabled = NO;
    }
    else
    {
        self.txtRedeemCode.enabled = YES;
    }
    
    if(OS_VERSION>=7)
    {
                self.titleRedeem.frame=CGRectMake(self.titleRedeem.frame.origin.x,64,self.titleRedeem.frame.size.width,self.titleRedeem.frame.size.height);
        
                self.textImg.frame=CGRectMake(self.textImg.frame.origin.x,self.textImg.frame.origin.y+64,self.textImg.frame.size.width,self.textImg.frame.size.height);
        
                        self.txtRedeemCode.frame=CGRectMake(self.txtRedeemCode.frame.origin.x,self.txtRedeemCode.frame.origin.y+64,self.txtRedeemCode.frame.size.width,self.txtRedeemCode.frame.size.height);
        
                        self.sbtBtn.frame=CGRectMake(self.sbtBtn.frame.origin.x,self.sbtBtn.frame.origin.y+64,self.sbtBtn.frame.size.width,self.sbtBtn.frame.size.height);
    }
    
    [[ProcessingView instance] forceHideTintView];
//    NSLog(@"txt reedeem is ::: %d", self.txtRedeemCode.enabled);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Buttons Method


- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSubmit_clicked:(id)sender
{
    
    if (self.txtRedeemCode.text.length > 0)
    {
        [self calServiceWithURL:GET_PROMO_CODE];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MSG_ENTER_PROMO_CODE delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark Webservice
#pragma mark -
- (void) calServiceWithURL:(NSString*)serviceUrl
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        [params setValue:self.txtRedeemCode.text forKey:@"promo_code"];
    
        [[NSUserDefaults standardUserDefaults]setValue:self.txtRedeemCode.text forKey:@"PromoCode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
    
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
        
}
#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    
    //NSLog(@"response=%@\n\n",responseData);
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_PROMO_CODE]])
    {
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
            [Utiltiy showAlertWithTitle:@"Done" andMsg:MSG_SUCCESS];
        }
        else if ([[responseData objectForKey:@"error"] isEqualToString:@"already-used"]){
            
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:@"Promo has already been used"];
        }
    
        else if([[responseData objectForKey:@"error"] isEqualToString:@"invalid-code"]){
            
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:@"Invalid code"];
            
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        }

    }
}
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    //NSLog(@"response=%@\n\n",responseData);
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_PROMO_CODE]]) {
        
    }
}


- (void)viewDidUnload {
    [self setTxtRedeemCode:nil];
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
