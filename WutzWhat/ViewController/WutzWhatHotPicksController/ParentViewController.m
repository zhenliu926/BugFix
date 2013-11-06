//
//  ParentViewController.m
//  WutzWhat
//
//  Created by Asad Ali on 6/18/13.
//
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

@synthesize JSScrollbarView = _JSScrollbarView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupCategoryTabBarItems
{
    NSMutableArray *items = [NSMutableArray array];
	NSString *imageBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"images.bundle"];
	NSBundle *imageBundle = [NSBundle bundleWithPath:imageBundlePath];
    
    for (int i = 0; i < 6; i++)
	{
        if (i==0) {
            JSTabItem *item = [[JSTabItem alloc] initWithTitle:nil color:nil textColor:nil image:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"foods" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0] highlightedImage:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"foods_c" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
            [items addObject:item];
        }
        if (i==1) {
            JSTabItem *item = [[JSTabItem alloc] initWithTitle:nil color:nil textColor:nil image:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"shopping" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0] highlightedImage:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"shopping_c" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
            [items addObject:item];
        }
        if (i==2) {
            JSTabItem *item = [[JSTabItem alloc] initWithTitle:nil color:nil textColor:nil image:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"events" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0] highlightedImage:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"events_c" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
            [items addObject:item];
        }
        if (i==3) {
            JSTabItem *item = [[JSTabItem alloc] initWithTitle:nil color:nil textColor:nil image:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"nightlife" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0] highlightedImage:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"nightlife_c" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
            [items addObject:item];
        }
        if (i==4) {
            JSTabItem *item = [[JSTabItem alloc] initWithTitle:nil color:nil textColor:nil image:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"services" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0] highlightedImage:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"services_c" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
            [items addObject:item];
        }
        if (i==5) {
            JSTabItem *item = [[JSTabItem alloc] initWithTitle:nil color:nil textColor:nil image:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"concierge" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0] highlightedImage:[[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"concierge_c" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
            [items addObject:item];
        }
	}
    
    if (OS_VERSION < 7)
        self.JSScrollbarView  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-88, 320, 44)];
        else
    self.JSScrollbarView  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-44, 320, 44)];
    
    self.JSScrollbarView.backgroundColor = [UIColor blackColor];
    self.tabBar = [[JSScrollableTabBar alloc] initWithFrame:CGRectMake(0,0, 320, 44) style:JSScrollableTabBarStyleBlack];
    [self.tabBar setTabItems:items];
	[self.tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.tabBar setDelegate:self];
	[self.JSScrollbarView addSubview:self.tabBar];
    [self.view addSubview:self.JSScrollbarView];
    
    rectJSScrollbarView = self.JSScrollbarView.frame;
}


@end
