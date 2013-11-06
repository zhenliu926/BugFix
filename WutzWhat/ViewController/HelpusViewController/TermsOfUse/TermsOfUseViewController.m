//
//  TermsOfUseViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 5/7/13.
//
//

#import "TermsOfUseViewController.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

@synthesize commonFunction = _commonFunction;

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
    
    if(OS_VERSION>=7)
    
    {
        self.mainScroll.frame=CGRectMake(self.mainScroll.frame.origin.x,self.mainScroll.frame.origin.y+46,self.mainScroll.frame.size.width,self.mainScroll.frame.size.height);
    }
    
    self.mainScroll.contentSize = CGSizeMake(320, 960);
    self.mainScroll.bounces = self.mainScroll.bouncesZoom = false;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark Navigation Bar

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
    
    UIImageView *titleIV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_profile.png"]];
    [[self navigationItem]setTitleView:titleIV1];
}


#pragma mark Button Actions

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setMainScroll:nil];
    [super viewDidUnload];
}


#pragma mark - Buttons Action Methods

- (IBAction)btnTermsOfServiceSiteClicked:(id)sender
{
    [self openWebLinkInSafari:@"http://www.wutzwhat.com/termsofservice"];
}

- (IBAction)btnPrivacySiteClicked:(id)sender
{
    [self openWebLinkInSafari:@"http://www.wutzwhat.com/privacy"];
}

- (IBAction)btnEmailUsClicked:(id)sender
{
    self.commonFunction = [[CommonFunctions alloc] initWithParent:self];
    
    [self.commonFunction sendEmailToAddress:@"info@wutzwhat.com" withSubject:@"" body:@""];
}


#pragma mark - Open WebAddress

-(void)openWebLinkInSafari:(NSString *)urlString
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


@end
