//
//  NotificationSettingsViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/26/12.
//
//

#import "NotificationSettingsViewController.h"

@interface NotificationSettingsViewController ()

@end

@implementation NotificationSettingsViewController

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
    
    if(OS_VERSION>=7)
    {
        self.scrollView.frame=CGRectMake(0,44,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    }
    self.scrollView.contentSize = CGSizeMake(320.0f, 610.0f);
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_notifications.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"] ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    [self getNotificationSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setBtnFeaturedWutzwhat:nil];
    [self setBtnFeaturedPerks:nil];
    [self setBtnNewPromoCodes:nil];
    [self setBtnCreditUpdates:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (IBAction)btnSaveClicked:(id)sender
{
    [self setNotificationSettings];
}

- (IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];    
}

- (IBAction)btnCreditUpdateClicked:(id)sender
{
    self.btnCreditUpdates.selected = !self.btnCreditUpdates.selected;
}

- (IBAction)btnFeaturedPerksClicked:(id)sender
{
    self.btnFeaturedPerks.selected = !self.btnFeaturedPerks.selected;
}

- (IBAction)btnFeaturedWutzwhatClicked:(id)sender
{
    self.btnFeaturedWutzwhat.selected = !self.btnFeaturedWutzwhat.selected;
}

- (IBAction)btnNewPromoCodesUpdatesClicked:(id)sender
{
    self.btnNewPromoCodes.selected = !self.btnNewPromoCodes.selected;
}


#pragma mark- Notification Setting Get/Set API Methods

-(void)getNotificationSettings
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_NOTIFICATION_SETTINGS]
                 andDelegate:self
              andRequestType:@"POST"
             andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}

-(void)setNotificationSettings
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];

    [params setObject:self.btnCreditUpdates.selected ? @"false" : @"true" forKey:@"credit_updates"];
    [params setObject:self.btnFeaturedPerks.selected ? @"false" : @"true" forKey:@"feature_perks"];
    [params setObject:self.btnFeaturedWutzwhat.selected ? @"false" : @"true" forKey:@"featured_wutzwhat"];
    [params setObject:self.btnNewPromoCodes.selected ? @"false" : @"true" forKey:@"promo_codes"];
    
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, SET_NOTIFICATION_SETTINGS]
                 andDelegate:self
              andRequestType:@"POST"
             andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}


#pragma mark- DataFetcher Delegate Methods

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_NOTIFICATION_SETTINGS]])
    {
        BOOL hasError = [[responseData objectForKey:@"result"] isEqualToString:@"error"];
        
        if (hasError)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:MSG_FAILED
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            [self parseResponseData:[responseData objectForKey:@"data"]];
        }
    }
    else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, SET_NOTIFICATION_SETTINGS]])
    {
        BOOL hasError = [[responseData objectForKey:@"result"] isEqualToString:@"error"];
        
        if (hasError)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:MSG_FAILED
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_NOTIFICATION_SETTINGS]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:MSG_FAILED
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, SET_NOTIFICATION_SETTINGS]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:MSG_FAILED
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark- Response Parser Method

-(void)parseResponseData:(NSDictionary *)dataDictionary
{
    self.btnCreditUpdates.selected = ![[dataDictionary objectForKey:@"credit_updates"] boolValue];
    self.btnFeaturedPerks.selected = ![[dataDictionary objectForKey:@"feature_perks"] boolValue];
    self.btnFeaturedWutzwhat.selected = ![[dataDictionary objectForKey:@"featured_wutzwhat"] boolValue];
    self.btnNewPromoCodes.selected = ![[dataDictionary objectForKey:@"promo_codes"] boolValue];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


