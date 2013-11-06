//
//  HelpusViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 4/23/13.
//
//

#import "HelpusViewController.h"

@interface HelpusViewController ()

@end

@implementation HelpusViewController
@synthesize sender=_sender;
@synthesize mainScrollView=_mainScrollView;

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
    [self setUpHeaderView];
    
    if (!IS_IPHONE_5)
    {
        [self.mainScrollView setContentSize:CGSizeMake(320, 528)];
        [self.mainScrollView setScrollEnabled:YES];
    }
    if(OS_VERSION>=7)
        
    {
        self.mainScrollView.frame=CGRectMake(self.mainScrollView.frame.origin.x,self.mainScrollView.frame.origin.y+46,self.mainScrollView.frame.size.width,self.mainScrollView.frame.size.height);
    }

    self.mainScrollView.bounces = self.mainScrollView.bouncesZoom = false;
    
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Navigation Bar
#pragma mark -
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
#pragma mark -
#pragma mark Button Actions
#pragma mark -
- (IBAction)btnTour_Pressed:(id)sender
{
    TourViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TourViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFAQs_Pressed:(id)sender
{
    
}

- (IBAction)btnEmailUs_Pressed:(id)sender
{
    self.sender = [[CommonFunctions alloc] initWithParent:self];
    [self.sender emailWithTitle:@""];
}

- (IBAction)btnTermOfUse_Pressed:(id)sender
{
    
}

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
