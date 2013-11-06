//
//  SpreadWutzWhatViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/23/12.
//
//

#import "SpreadWutzWhatViewController.h"
#import "DataFetcher.h"
#import "Constants.h"
#import "Utiltiy.h"
#import "ProcessingView.h"
#import "WutzWhatModel.h"
#import "SharedManager.h"

@interface SpreadWutzWhatViewController ()

@end

@implementation SpreadWutzWhatViewController
@synthesize menu;
@synthesize activityIndicatorView=_activityIndicatorView;
@synthesize activityIndicator=_activityIndicator;
@synthesize btnInviteViaFacebook=_btnInviteViaFacebook;
@synthesize btnInviteViaGoogle=_btnInviteViaGoogle;
@synthesize btnInviteViaTwitter=_btnInviteViaTwitter;
@synthesize btnInviteViaEmail=_btnInviteViaEmail;
@synthesize btnInviteViaText=_btnInviteViaText;
@synthesize scrollView=_scrollView;
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
    [self showActivityIndicatorInView:YES];
    [self calServiceWithURL:SPREAD_WUTZWHAT];

    [self.btnInviteViaFacebook setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnInviteViaFacebook setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.btnInviteViaFacebook.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    
    [self.btnInviteViaTwitter setTitleShadowColor:[UIColor colorWithRed:0.0f green:170.0/255.0f blue:170.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnInviteViaTwitter setTitleShadowColor:[UIColor colorWithRed:0.0f green:170.0/255.0f blue:170.0/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    self.btnInviteViaTwitter.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    
    [self.btnInviteViaGoogle setTitleShadowColor:[UIColor colorWithRed:160.0/255.0f green:61.0/255.0f blue:53.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btnInviteViaGoogle setTitleShadowColor:[UIColor colorWithRed:160.0/255.0f green:61.0/255.0f blue:53.0/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    self.btnInviteViaGoogle.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    
    [self.btnInviteViaFacebook setUserInteractionEnabled:NO];
    [self.btnInviteViaGoogle setUserInteractionEnabled:NO];
    [self.btnInviteViaTwitter setUserInteractionEnabled:NO];
    [self.btnInviteViaEmail setUserInteractionEnabled:NO];
    [self.btnInviteViaText setUserInteractionEnabled:NO];
    
    
    
    if (!IS_IPHONE_5)
    {
        [self.scrollView setFrame:[UIScreen mainScreen].bounds];
        [self.scrollView setContentSize:CGSizeMake(320, 586)];
        [self.scrollView setScrollEnabled:YES];
    }else
    {
        [self.scrollView setFrame:[UIScreen mainScreen].bounds];
        [self.scrollView setContentSize:CGSizeMake(320, 586)];
        [self.scrollView setScrollEnabled:YES];
    }
    
    if(OS_VERSION>=7)
    {
        
        self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x,44,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    }
    self.scrollView.bounces = self.scrollView.bouncesZoom = false;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backBtnTapped:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Webservice
#pragma mark -
- (void) calServiceWithURL:(NSString*)serviceUrl {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
   
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    
}


#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,SPREAD_WUTZWHAT]]){
    //NSLog(@"response=%@\n\n",responseData);
    [[ProcessingView instance] hideTintView];
    
    BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
    if (isSuccess) {
        if ( ![[responseData objectForKey:@"message"] isKindOfClass:[NSNull class]] && [responseData objectForKey:@"message"]!=nil && ![[responseData objectForKey:@"message"] isEqualToString:@""] ) {
            [self showActivityIndicatorInView:NO];
            NSString *sub = [responseData objectForKey:@"message"];
            NSString *subString = [[sub componentsSeparatedByString:@"="] lastObject];
            self.lblPromoCode.text = subString;
            [self.btnInviteViaFacebook setUserInteractionEnabled:YES];
            [self.btnInviteViaGoogle setUserInteractionEnabled:YES];
            [self.btnInviteViaTwitter setUserInteractionEnabled:YES];
            [self.btnInviteViaEmail setUserInteractionEnabled:YES];
            [self.btnInviteViaText setUserInteractionEnabled:YES];
           // [[NSUserDefaults standardUserDefaults]objectForKey:@"PromoCode"];
            }
        }
    }
}
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    //NSLog(@"response=%@\n\n",responseData);
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,SPREAD_WUTZWHAT]])
    {
        
    }
}
#pragma mark- Button Actions

- (IBAction)btnInviteFacebook_clicked:(id)sender {
    // TODO
    // This is temp for the soft launch until the perks are fully tested with braintree
   // [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
   // return;
    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender setDelegate:(id)self];
    [self.sender setBonusCode:self.lblPromoCode.text];
    [self.sender shareOnFaceBookWithTitle:@"http://wutzwhat.com" bonusCode:self.lblPromoCode.text];
}

- (IBAction)btnInviteTwitter_clicked:(id)sender {
    // TODO
    // This is temp for the soft launch until the perks are fully tested with braintree
  //  [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
  //  return;
    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender setBonusCode:self.lblPromoCode.text];
    [self.sender shareOnTwitterWithTitle:@"http://wutzwhat.com" bonusCode:self.lblPromoCode.text];
}
- (IBAction)btnInviteGooglePlus_clicked:(id)sender {
    // TODO
    // This is temp for the soft launch until the perks are fully tested with braintree
  //  [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
  //  return;
    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender setBonusCode:self.lblPromoCode.text];
    [self.sender shareOnGooglePlusWithTitle:@"http://wutzwhat.com" bonusCode:self.lblPromoCode.text];
}


- (IBAction)btnInviteEmail_clicked:(id)sender {
    // TODO
    // This is temp for the soft launch
  //  [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
  //  return;

    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender setBonusCode:self.lblPromoCode.text];
    [self.sender emailWithTitle:@"http://wutzwhat.com" bonusCode:self.lblPromoCode.text];

}
- (IBAction)btnInviteMessage_clicked:(id)sender {
    // TODO
    // This is temp for the soft launch
  //  [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FEATURE_UNAVAILABLE];
  //  return;

    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender setBonusCode:self.lblPromoCode.text];
    [self.sender textWithTitle:@"http://wutzwhat.com" bonusCode:self.lblPromoCode.text];
}

- (void)viewDidUnload {
    [self setLblPromoCode:nil];
    [self setBtnInviteViaFacebook:nil];
    [self setBtnInviteViaTwitter:nil];
    [self setBtnInviteViaGoogle:nil];
    [self setBtnInviteViaEmail:nil];
    [self setBtnInviteViaText:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - Show Activity Indicator

-(void)showActivityIndicatorInView:(BOOL)show
{
    if (show)
    {
        self.activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2-15, ([UIScreen mainScreen].bounds.size.height)/2 - 80, 32, 32)];
        
        [self.activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        [self.activityIndicatorView setAlpha:0.4f];
        [self.activityIndicatorView.layer setCornerRadius:5.0f];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.activityIndicator setBackgroundColor:[UIColor clearColor]];
        
        [self.activityIndicator startAnimating];
        self.activityIndicator.center = CGPointMake(16, 16);
        
        [self.activityIndicatorView addSubview:self.activityIndicator];
        [self.view setUserInteractionEnabled:NO];
        [self.view addSubview:self.activityIndicatorView];
    }
    else
    {
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        [self.activityIndicatorView removeFromSuperview];
    }
}
#pragma mark -
#pragma mark Common Function Call
#pragma mark -
-(void)doneFacebookShare
{
    [self showActivityIndicatorInView:NO];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
