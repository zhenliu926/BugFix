//
//  PerksViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 4/11/13.
//
//

#import "PerksViewController.h"

@interface PerksViewController ()

@end

@implementation PerksViewController

@synthesize viewControllers = _viewControllers;
@synthesize pageView = _pageView;
@synthesize tabBar = _tabBar;
@synthesize JSScrollbarView = _JSScrollbarView;
@synthesize sectionType = _sectionType;

#define numPages 6

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    self.sectionType = [self.navigationController.accessibilityHint intValue];
    
    self.viewControllers = [[NSMutableArray alloc] init];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageView.numberOfPages = numPages;
    self.pageView.currentPage = 0;
    
    [self setupNavigationBarStyle];
    [self setupCategoryTabBarItems];
    [self setupViewHeightForiPhone5];
    
    for (int i = 0; i < 3; i++)
    {
        [self loadScrollViewWithPage:i];
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int i = 3; i < 6; i++)
        {
            [self loadScrollViewWithPage:i];
        }
    });
}

-(void)setupViewHeightForiPhone5
{
    if (IS_IPHONE_5)
    {
        self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, 568);
    }
}

-(void)setupNavigationBarStyle
{
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    
    if(OS_VERSION>=7)
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar.png"]
                                           forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [UIImage imageNamed:@"top_menu.png"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
     UIImage *backButtonPressed = [UIImage imageNamed:@"top_menu_c.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 50 , 44)];
    
    [v addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImage *mapButton = [UIImage imageNamed:@"top_map.png"] ;
    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_map_c.png"];
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapBtn setFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
    [mapBtn addTarget:self action:@selector(btnMap_Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapBtn setImage:mapButton forState:UIControlStateNormal];
    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *mapbtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
    [[self navigationItem]setRightBarButtonItem:mapbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_perks.png"]];
    
    [[self navigationItem]setTitleView:titleIV];
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
    
   // self.JSScrollbarView  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-88, 320, 44)];
    
    self.JSScrollbarView.backgroundColor = [UIColor blackColor];
    self.tabBar = [[JSScrollableTabBar alloc] initWithFrame:CGRectMake(0,0, 320, 44) style:JSScrollableTabBarStyleBlack];
    [self.tabBar setTabItems:items];
	[self.tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.tabBar setDelegate:self];
	[self.JSScrollbarView addSubview:self.tabBar];
    [self.view addSubview:self.JSScrollbarView];
    
    rectJSScrollbarView = self.JSScrollbarView.frame;
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}
#endif

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= numPages)
        return;
    
    PerksListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksListViewController"];
    
    controller.categoryType = page + 1;
    controller.delegate = self;
    [self.viewControllers addObject:controller];
    
    
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:TRUE];
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageView.currentPage = page;
    
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Switched page to %d , %@ , %@", page, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    [self.tabBar selectTabItemAtIndex:page];
    [self hideTableViewSearchBar:page];    
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageView.currentPage;
    
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
    
    [self hideTableViewSearchBar:page];
}

- (IBAction)changePage:(id)sender
{
    [self.view endEditing:TRUE];
    [self gotoPage:YES];
}

#pragma mark Scrollable Tabbar

- (void)scrollableTabBar:(JSScrollableTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index
{
    [self.view endEditing:TRUE];
    [tabBar selectTabItemAtIndex:index];
    
    self.pageView.currentPage = index;
    
    [self gotoPage:YES];
}


#pragma mark Button Actions

-(void)btnMap_Pressed:(id)sender
{
    [self.view endEditing:TRUE];
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    NSArray *modelArray = [[self.viewControllers objectAtIndex:self.pageView.currentPage] serverResponseArray];
    
    controller.modelArray = modelArray;
    controller.isSingleMapView = NO;
    [controller setPostTypeID:PERK_ID_FOR_REVIEW];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) backBtnTapped:(id)sender
{
    [self.view endEditing:TRUE];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


#pragma mark - WutzWhat List view Delegate Method

-(void)hideNavigationBar:(BOOL)hide
{
    if(animating)
        return;
    
    [self.navigationController setNavigationBarHidden:hide animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^
     {
         animating = true;
         
         if (hide)
         {
             for (int i = 0; i < self.viewControllers.count; i++)
             {
                 PerksListViewController *controller = (PerksListViewController *)[self.viewControllers objectAtIndex:i];
                 controller.sgmConceirge.alpha=0.5f;
                 controller.sgmConceirge.frame= CGRectMake(controller.sgmConceirge.frame.origin.x, controller.sgmConceirge.frame.origin.y + 180, controller.sgmConceirge.frame.size.width, controller.sgmConceirge.frame.size.height);
                 if (OS_VERSION >=7) {
                     
                     CGRect b = controller.tblCategoryList.frame;    // v is the UIView object
                     b.origin.x = 0;
                     b.origin.y = 0;
                     controller.tblCategoryList.frame = b;
                 }
             }
             
             self.JSScrollbarView.alpha=0.5f;
             self.JSScrollbarView.frame= CGRectMake(self.JSScrollbarView.frame.origin.x, self.JSScrollbarView.frame.origin.y + 90, self.JSScrollbarView.frame.size.width, self.JSScrollbarView.frame.size.height);
         }
         else
         {
             for (int i = 0; i < self.viewControllers.count; i++)
             {
                 PerksListViewController *controller = (PerksListViewController *)[self.viewControllers objectAtIndex:i];
                 controller.sgmConceirge.alpha=1.0f;
                 controller.sgmConceirge.frame = controller.rectSGMConceirge;
                 if (OS_VERSION >=7) {
                     
                     CGRect b = controller.tblCategoryList.frame;    // v is the UIView object
                     b.origin.x = 0;
                     b.origin.y = 44;
                     controller.tblCategoryList.frame = b;
                 }
             }
             
             self.JSScrollbarView.alpha=1.0f;
             self.JSScrollbarView.frame=rectJSScrollbarView;
         }
     }
    completion:^(BOOL finished)
     {
         if(finished)
             animating = false;
     }];
}


#pragma mark - Hiding SearchBar

-(void)hideTableViewSearchBar:(int)pageNumber
{
    if (pageNumber >= self.viewControllers.count)
        return;
    
    if (pageNumber != 0)
    {
        PerksListViewController *lastController = (PerksListViewController *)[self.viewControllers objectAtIndex:pageNumber - 1];
        [lastController hideTableSearchBar];        
    }
    if (pageNumber != self.viewControllers.count - 1)
    {
        PerksListViewController *nextController = (PerksListViewController *)[self.viewControllers objectAtIndex:pageNumber + 1];
        [nextController hideTableSearchBar];
    }
}

@end
