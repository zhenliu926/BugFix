
//
//  WutzWhatModel.h
//  WutzWhat
//
//  Created by Asad Ali on 04/10/13.
//
//

#import "WutzWhatViewController.h"

@interface WutzWhatViewController ()

@end

@implementation WutzWhatViewController

@synthesize viewControllers = _viewControllers;
@synthesize pageView = _pageView;
@synthesize tabBar = _tabBar;
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
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
    for (int i = 0; i < 3; i++)
    {
        [self loadScrollViewWithPage:i];
    }
    });
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
    UIImage *mapButton = [UIImage imageNamed:@"top_map.png"] ;
    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_map_c.png"];
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
    [mapBtn addTarget:self action:@selector(btnMap_Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapBtn setImage:mapButton forState:UIControlStateNormal];
    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *mapbtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
    [[self navigationItem]setRightBarButtonItem:mapbtnItem ];
    
    UIImageView *titleIV ;

    if (self.sectionType == 3)	
    {
        titleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_hotpicks.png"]];
    }
    else
    {
        titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        [titleIV setImage:[UIImage imageNamed:@"top_wutzwhat.png"]];
    }
    
    [[self navigationItem]setTitleView:titleIV];
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}
#endif

- (void)loadScrollViewWithPage:(int)page
{
    if (page >= numPages)
        return;
    
    WutzWhatListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatListViewController"];
    controller.categoryType = page + 1;
    controller.sectionType = self.sectionType;
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
    controller.categoryType = self.pageView.currentPage + 1;
    [controller setPostTypeID:self.sectionType];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) backBtnTapped:(id)sender
{
    [self.view endEditing:TRUE];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


#pragma mark - WutzWhat List view Delegate Method

- (BOOL)tabBarHidden
{    
    return scrollBarHidden;
}

-(void)hideNavigationBar:(BOOL)hide
{
    if(animating)
        return;
    [self.navigationController setNavigationBarHidden:hide animated:YES];
// float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    [UIView animateWithDuration:0.2f animations:^
     {
         animating = true;
         if (hide)
         {
             for (int i = 0; i < self.viewControllers.count; i++)
             {
                 WutzWhatListViewController *controller = (WutzWhatListViewController *)[self.viewControllers objectAtIndex:i];
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
             scrollBarHidden = true;
         }
         else
         {
             for (int i = 0; i < self.viewControllers.count; i++)
             {
                WutzWhatListViewController *controller = (WutzWhatListViewController *)[self.viewControllers objectAtIndex:i];
                 controller.sgmConceirge.alpha=1.0f;
                 controller.sgmConceirge.frame = controller.rectSGMConceirge;
                 if (OS_VERSION >=7) {
                     
                     CGRect b = controller.tblCategoryList.frame;    // v is the UIView object
                     b.origin.x = 0;
                     b.origin.y = 44;
                     controller.tblCategoryList.frame = b;
                     

                 }
             }
             
             self.JSScrollbarView.alpha = 1.0f;
             self.JSScrollbarView.frame = rectJSScrollbarView;
             scrollBarHidden = false;
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
        WutzWhatListViewController *lastController = (WutzWhatListViewController *)[self.viewControllers objectAtIndex:pageNumber - 1];
        [lastController hideTableSearchBar];
    }
    
    if (pageNumber != self.viewControllers.count - 1)
    {
        WutzWhatListViewController *nextController = (WutzWhatListViewController *)[self.viewControllers objectAtIndex:pageNumber + 1];
        [nextController hideTableSearchBar];
    }
}

@end
