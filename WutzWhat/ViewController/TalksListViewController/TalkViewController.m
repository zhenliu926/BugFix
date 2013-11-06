//
//  TalkViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 4/12/13.
//
//

#import "TalkViewController.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

@synthesize viewControllers = _viewControllers;
@synthesize pageView = _pageView;
@synthesize tabBar = _tabBar;
@synthesize JSScrollbarView = _JSScrollbarView;
@synthesize sectionType = _sectionType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    self.sectionType = [self.navigationController.accessibilityHint intValue];
    
    TalksListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TalksListViewController"];
    controller.view.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    
    
    self.viewControllers = [[NSMutableArray alloc] initWithObjects:controller, controller, controller, controller, controller, controller, nil];
    
    NSUInteger numberPages = self.viewControllers.count;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    
    self.pageView.numberOfPages = numberPages;
    self.pageView.currentPage = 0;
    
    [self setupNavigationBarStyle];
    [self setupCategoryTabBarItems];
    [self setupViewHeightForiPhone5];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
    [self loadScrollViewWithPage:3];
    [self loadScrollViewWithPage:4];
    [self loadScrollViewWithPage:5];    
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
    
    UIImage *backButton = [UIImage imageNamed:@"top_menu.png"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_menu_c.png"]  ;
   
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 50 , 44)];
    [v addSubview:backBtn];
    UIImage *mapButton = [UIImage imageNamed:@"top_addfind.png"] ;
    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_addfind_c.png"] ;
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
    [mapBtn addTarget:self action:@selector(btnAddNewTalkPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapBtn setImage:mapButton forState:UIControlStateNormal];
    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *mapbtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
    [[self navigationItem]setRightBarButtonItem:mapbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_myfinds.png"]];
    titleIV.frame = CGRectMake(-40, 0, titleIV.frame.size.width, titleIV.frame.size.height);
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
    
    if(OS_VERSION>=7)
    {
        self.JSScrollbarView  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-44, 320, 44)];
    }
    else
    self.JSScrollbarView  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-88, 320, 44)];
    
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
    if (page >= self.viewControllers.count)
        return;
    
    TalksListViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TalksListViewController"];
        controller.categoryType = page + 1;
        controller.delegate = self;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
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
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageView.currentPage = page;
    
    [self.tabBar selectTabItemAtIndex:page];
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageView.currentPage;
    
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];
}

#pragma mark Scrollable Tabbar

- (void)scrollableTabBar:(JSScrollableTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index
{
    [tabBar selectTabItemAtIndex:index];
    
    self.pageView.currentPage = index;
    
    [self gotoPage:YES];
}


#pragma mark Button Actions

-(void)btnAddNewTalkPressed:(id)sender
{
    AddTalkViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTalkViewController"];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) backBtnTapped:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


#pragma mark - Talks List view Delegate Method

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
             self.JSScrollbarView.alpha=0.5f;
             self.JSScrollbarView.frame= CGRectMake(self.JSScrollbarView.frame.origin.x, self.JSScrollbarView.frame.origin.y + 90, self.JSScrollbarView.frame.size.width, self.JSScrollbarView.frame.size.height);

             for (int i = 0; i < self.viewControllers.count; i++)
             {
                 TalksListViewController *controller = (TalksListViewController *)[self.viewControllers objectAtIndex:i];
                 
                 if (OS_VERSION >=7) {
                     
                    // self.view.backgroundColor=[UIColor blackColor];

                     CGRect b = controller.tblCategoryList.frame;    // v is the UIView object
                     b.origin.x = 0;
                     b.origin.y = 0;
                     controller.tblCategoryList.frame = b;
                 }
             }
         }
         else
         {
             self.JSScrollbarView.alpha=1.0f;
             self.JSScrollbarView.frame=rectJSScrollbarView;
             if(OS_VERSION>=7)
             {

                 
                 for (int i = 0; i < self.viewControllers.count; i++)
                 {
                     TalksListViewController *controller = (TalksListViewController *)[self.viewControllers objectAtIndex:i];
                     
                     
                         
                         CGRect b = controller.tblCategoryList.frame;    // v is the UIView object
                         b.origin.x = 0;
                         b.origin.y = 44;
                         controller.tblCategoryList.frame = b;
                     
                 }

             }
         }
     }
     
     completion:^(BOOL finished)
     {
         if(finished)
             animating = false;
     }];
}

-(void)addMyFindButtonClicked
{
    [self btnAddNewTalkPressed:nil];
}

-(void)successfullyAddedNewTalkForCategory:(int)category
{
    self.pageView.currentPage = category -1;
    
    TalksListViewController *controller = [self.viewControllers objectAtIndex:category -1];
    
    [controller callTalksListAPI];
    
    [self.tabBar selectTabItemAtIndex:category - 1];
    
    [self gotoPage:YES];
}


@end
