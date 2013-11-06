//
//  FavouritesViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 2/4/13.
//
//

#import "FavouritesViewController.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

@synthesize controllerShifter = _controllerShifter;
@synthesize tabBarPerks = _tabBarPerks;
@synthesize tabBarWutzWhat = _tabBarWutzWhat;
@synthesize viewControllersPerks = _viewControllersPerks;
@synthesize viewControllersWutzWhat = _viewControllersWutzWhat;
@synthesize JSScrollbarViewPerks = _JSScrollbarViewPerks;
@synthesize JSScrollbarViewWutzWhat = _JSScrollbarViewWutzWhat;
@synthesize scrollViewPerks = _scrollViewPerks;
@synthesize scrollViewWutzWhat = _scrollViewWutzWhat;
@synthesize pageViewPerks = _pageViewPerks;
@synthesize pageViewWutzWhat = _pageViewWutzWhat;


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
    
    PerksListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksListViewController"];
    
    self.viewControllersPerks = [[NSMutableArray alloc] initWithObjects:controller, controller, controller, controller, controller, controller, nil];
    
    NSUInteger numberPages = self.viewControllersPerks.count;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    
    self.viewControllersPerks = controllers;
    
    [self.scrollViewPerks setHidden:YES];
    self.scrollViewPerks.pagingEnabled = YES;
    self.scrollViewPerks.contentSize = CGSizeMake(CGRectGetWidth(self.scrollViewPerks.frame) * numberPages, CGRectGetHeight(self.scrollViewPerks.frame));
    self.scrollViewPerks.showsHorizontalScrollIndicator = NO;
    self.scrollViewPerks.showsVerticalScrollIndicator = NO;
    self.scrollViewPerks.scrollsToTop = NO;
    self.scrollViewPerks.delegate = self;
    
    self.pageViewPerks.numberOfPages = numberPages;
    self.pageViewPerks.currentPage = 0;
    
    
   
    
    WutzWhatListViewController *controllerWutzWhat = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatListViewController"];
    
    self.viewControllersWutzWhat = [[NSMutableArray alloc] initWithObjects:controllerWutzWhat, controllerWutzWhat, controllerWutzWhat, controllerWutzWhat, controllerWutzWhat, controllerWutzWhat, nil];
    
    NSUInteger numberPagesWutWhat = self.viewControllersWutzWhat.count;
    
    NSMutableArray *controllersWutWhat = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberPagesWutWhat; i++)
    {
		[controllersWutWhat addObject:[NSNull null]];
    }
    
    self.viewControllersWutzWhat = controllersWutWhat;
    
    [self.scrollViewWutzWhat setHidden:NO];
    self.scrollViewWutzWhat.pagingEnabled = YES;
    self.scrollViewWutzWhat.contentSize = CGSizeMake(CGRectGetWidth(self.scrollViewWutzWhat.frame) * numberPages, CGRectGetHeight(self.scrollViewWutzWhat.frame));
    self.scrollViewWutzWhat.showsHorizontalScrollIndicator = NO;
    self.scrollViewWutzWhat.showsVerticalScrollIndicator = NO;
    self.scrollViewWutzWhat.scrollsToTop = NO;
    self.scrollViewWutzWhat.delegate = self;
    
    self.pageViewWutzWhat.numberOfPages = numberPagesWutWhat;
    self.pageViewWutzWhat.currentPage = 0;
    
    
    [self setupNavigationBarStyle];
    [self setupCategoryTabBarItems];
    [self setupControllerShifterStyle];
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
        if(OS_VERSION>=7)
        {
            self.scrollViewPerks.frame = CGRectMake(0,self.scrollViewPerks.frame.origin.y+44, self.scrollViewPerks.frame.size.width, 524);
            self.scrollViewWutzWhat.frame = CGRectMake(0,self.scrollViewWutzWhat.frame.origin.y+44, self.scrollViewWutzWhat.frame.size.width, 524);
            
        }
        else
        {
            self.scrollViewPerks.frame = CGRectMake(0, self.scrollViewPerks.frame.origin.y, self.scrollViewPerks.frame.size.width, 524);
            self.scrollViewWutzWhat.frame = CGRectMake(0, self.scrollViewWutzWhat.frame.origin.y, self.scrollViewWutzWhat.frame.size.width, 524);
            
        }
        
    }
}

-(void)setupControllerShifterStyle
{
    
    if(OS_VERSION>=7){
        self.controllerShifter.frame= CGRectMake(0, 44, self.controllerShifter.frame.size.width+1,44);
    }
    else
        self.controllerShifter.frame= CGRectMake(0, 0, self.controllerShifter.frame.size.width, self.controllerShifter.frame.size.height);
    
    self.controllerShifter.selectedSegmentIndex = 0;
    
    [self.controllerShifter setImage:[UIImage imageNamed:@"tap_wutzwhat_c.png"] forSegmentAtIndex:0];
    [self.controllerShifter setImage:[UIImage imageNamed:@"tap_perks.png"] forSegmentAtIndex:1];
    
    if(OS_VERSION<7)
    {
        self.controllerShifter.segmentedControlStyle=UISegmentedControlSegmentCenter;
    }


    self.controllerShifter.layer.masksToBounds = NO;
    self.controllerShifter.clipsToBounds = NO;
    self.controllerShifter.layer.shadowColor = [UIColor blackColor].CGColor;
    self.controllerShifter.layer.shadowOpacity = 0.4f;
    self.controllerShifter.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.controllerShifter.layer.shadowRadius = 1.0f;

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.controllerShifter.bounds];
    self.controllerShifter.layer.shadowPath = path.CGPath;
    
    [self.controllerShifter addTarget:self action:@selector(sgmMain_Pressed:) forControlEvents:UIControlEventValueChanged];
}

-(void)setupNavigationBarStyle
{
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    UIImage *backButton = [UIImage imageNamed:@"top_menu.png"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_menu_c.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 50 , 44)];
    UIImage *mapButton = [UIImage imageNamed:@"top_edit.png"] ;
    UIImage *mapButtonPressed = [UIImage imageNamed:@"top_edit_c.png"] ;
    
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    [v addSubview:backBtn];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mapButton.size.width, mapButton.size.height)];
    [mapBtn addTarget:self action:@selector(btnMap_Pressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapBtn setImage:mapButton forState:UIControlStateNormal];
    [mapBtn setImage:mapButtonPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *mapbtnItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
    [[self navigationItem]setRightBarButtonItem:mapbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_favorites.png"]];
    
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
        self.JSScrollbarViewPerks  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-44, 320, 44)];
        self.JSScrollbarViewWutzWhat  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-44, 320, 44)];
        
    }
        else
        {
    self.JSScrollbarViewPerks  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-88, 320, 44)];
    self.JSScrollbarViewWutzWhat  = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-88, 320, 44)];
        }
    self.JSScrollbarViewPerks.backgroundColor = [UIColor blackColor];
    self.tabBarPerks = [[JSScrollableTabBar alloc] initWithFrame:CGRectMake(0,0, 320, 44) style:JSScrollableTabBarStyleBlack];
    [self.tabBarPerks setTabItems:items];
	[self.tabBarPerks setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.tabBarPerks setDelegate:self];
	[self.JSScrollbarViewPerks addSubview:self.tabBarPerks];
    [self.view addSubview:self.JSScrollbarViewPerks];
    
    rectJSScrollbarViewPerks = self.JSScrollbarViewPerks.frame;
    
    
    self.JSScrollbarViewWutzWhat.backgroundColor = [UIColor blackColor];
    
    
    
    self.tabBarWutzWhat = [[JSScrollableTabBar alloc] initWithFrame:CGRectMake(0,0, 320, 44) style:JSScrollableTabBarStyleBlack];
    
    
        [self.tabBarWutzWhat setTabItems:items];
	[self.tabBarWutzWhat setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.tabBarWutzWhat setDelegate:self];
	[self.JSScrollbarViewWutzWhat addSubview:self.tabBarWutzWhat];
    [self.view addSubview:self.JSScrollbarViewWutzWhat];
    
    rectJSScrollbarViewWutzWhat = self.JSScrollbarViewWutzWhat.frame;
    
    [self.JSScrollbarViewPerks setHidden:YES];
    [self.JSScrollbarViewWutzWhat setHidden:NO];
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}
#endif

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.viewControllersPerks.count)
        return;
    
    PerksListViewController *controller = [self.viewControllersPerks objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksListViewController"];
        controller.categoryType = page + 1;
        controller.viewingAsFavourite = YES;
        controller.delegate = self;
        [self.viewControllersPerks replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollViewPerks.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollViewPerks addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }

    WutzWhatListViewController *controllerWutWhat = [self.viewControllersWutzWhat objectAtIndex:page];
    
    if ((NSNull *)controllerWutWhat == [NSNull null])
    {
        controllerWutWhat = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatListViewController"];
        controllerWutWhat.categoryType = page + 1;
        controllerWutWhat.sectionType = 1;
        controllerWutWhat.viewingAsFavourite = YES;
        controllerWutWhat.delegate = self;
        [self.viewControllersWutzWhat replaceObjectAtIndex:page withObject:controllerWutWhat];
    }
    
    if (controllerWutWhat.view.superview == nil)
    {
        CGRect frame = self.scrollViewWutzWhat.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controllerWutWhat.view.frame = frame;
        
        [self addChildViewController:controllerWutWhat];
        [self.scrollViewWutzWhat addSubview:controllerWutWhat.view];
        [controllerWutWhat didMoveToParentViewController:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollViewWutzWhat.hidden)
    {
        CGFloat pageWidth = CGRectGetWidth(self.scrollViewPerks.frame);
        NSUInteger page = floor((self.scrollViewPerks.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        self.pageViewPerks.currentPage = page;
        [self.tabBarPerks selectTabItemAtIndex:page];
    }
    else
    {
        CGFloat pageWidth = CGRectGetWidth(self.scrollViewWutzWhat.frame);
        NSUInteger page = floor((self.scrollViewWutzWhat.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        self.pageViewWutzWhat.currentPage = page;
        [self.tabBarWutzWhat selectTabItemAtIndex:page];
    }
}

- (void)gotoPage:(BOOL)animated
{
    if (self.scrollViewWutzWhat.hidden)
    {
        NSInteger page = self.pageViewPerks.currentPage;
        
        CGRect bounds = self.scrollViewPerks.bounds;
        bounds.origin.x = CGRectGetWidth(bounds) * page;
        bounds.origin.y = 0;
        [self.scrollViewPerks scrollRectToVisible:bounds animated:animated];
    }
    else
    {
        NSInteger page = self.pageViewWutzWhat.currentPage;
        
        CGRect bounds = self.scrollViewWutzWhat.bounds;
        bounds.origin.x = CGRectGetWidth(bounds) * page;
        bounds.origin.y = 0;
        [self.scrollViewWutzWhat scrollRectToVisible:bounds animated:animated];
    }
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];
}

#pragma mark Scrollable Tabbar

- (void)scrollableTabBar:(JSScrollableTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index
{
    if (self.scrollViewWutzWhat.hidden)
    {
        self.pageViewPerks.currentPage = index;
    }
    else
    {
        self.pageViewWutzWhat.currentPage = index;
    }
    
    [tabBar selectTabItemAtIndex:index];
    
    [self gotoPage:YES];
}


#pragma mark Button Actions

-(void)btnMap_Pressed:(id)sender
{
    if (self.scrollViewWutzWhat.hidden)
    {
        PerksListViewController *controller = [self.viewControllersPerks objectAtIndex:self.pageViewPerks.currentPage];
        
        [controller enableEditModeForTableView];
    }
    else
    {
        WutzWhatListViewController *controller = [self.viewControllersWutzWhat objectAtIndex:self.pageViewWutzWhat.currentPage];
        
        [controller enableEditModeForTableView];
    }

}

- (void) backBtnTapped:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


-(void)sgmMain_Pressed:(id)sender
{
    if(self.controllerShifter.selectedSegmentIndex==0)
    {
        [self.controllerShifter setImage:[UIImage imageNamed:@"tap_wutzwhat_c.png"] forSegmentAtIndex:0];
        [self.controllerShifter setImage:[UIImage imageNamed:@"tap_perks.png"] forSegmentAtIndex:1];

        [self.scrollViewWutzWhat setHidden:NO];
        [self.scrollViewPerks setHidden:YES];

        [self.JSScrollbarViewPerks setHidden:YES];
        [self.JSScrollbarViewWutzWhat setHidden:NO];
    }
    else if (self.controllerShifter.selectedSegmentIndex==1)
        
    {
        [self.controllerShifter setImage:[UIImage imageNamed:@"tap_wutzwhat.png"] forSegmentAtIndex:0];
        [self.controllerShifter setImage:[UIImage imageNamed:@"tap_perks_c.png"] forSegmentAtIndex:1];
        
        [self.scrollViewWutzWhat setHidden:YES];
        [self.scrollViewPerks setHidden:NO];

        [self.JSScrollbarViewPerks setHidden:NO];
        [self.JSScrollbarViewWutzWhat setHidden:YES];
    }
}


#pragma mark - WutzWhat List view Delegate Method

-(void)hideNavigationBar:(BOOL)hide
{
    [self.navigationController setNavigationBarHidden:hide animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^
     {
         if (hide)
         {
             for (int i = 0; i < self.viewControllersPerks.count; i++)
             {
                 PerksListViewController *controller = (PerksListViewController *)[self.viewControllersPerks objectAtIndex:i];
                 controller.sgmConceirge.alpha=0.5f;
                 controller.sgmConceirge.frame= CGRectMake(controller.sgmConceirge.frame.origin.x, controller.sgmConceirge.frame.origin.y + 180, controller.sgmConceirge.frame.size.width, controller.sgmConceirge.frame.size.height);
             }
             
             for (int i = 0; i < self.viewControllersWutzWhat.count; i++)
             {
                 WutzWhatListViewController *controller = (WutzWhatListViewController *)[self.viewControllersWutzWhat objectAtIndex:i];
                 controller.sgmConceirge.alpha=0.5f;
                 controller.sgmConceirge.frame= CGRectMake(controller.sgmConceirge.frame.origin.x, controller.sgmConceirge.frame.origin.y + 180, controller.sgmConceirge.frame.size.width, controller.sgmConceirge.frame.size.height);
                 
                 
             }
             
             self.JSScrollbarViewPerks.alpha=0.5f;
             self.JSScrollbarViewPerks.frame= CGRectMake(self.JSScrollbarViewPerks.frame.origin.x, self.JSScrollbarViewPerks.frame.origin.y + 90, self.JSScrollbarViewPerks.frame.size.width, self.JSScrollbarViewPerks.frame.size.height);
             
             self.JSScrollbarViewWutzWhat.alpha=0.5f;
             self.JSScrollbarViewWutzWhat.frame= CGRectMake(self.JSScrollbarViewWutzWhat.frame.origin.x, self.JSScrollbarViewWutzWhat.frame.origin.y + 90, self.JSScrollbarViewWutzWhat.frame.size.width, self.JSScrollbarViewWutzWhat.frame.size.height);
             
             if(OS_VERSION>=7)
             {
                 
                     self.scrollViewPerks.frame = CGRectMake(0,44, self.scrollViewPerks.frame.size.width, 524);
                     self.scrollViewWutzWhat.frame = CGRectMake(0,44, self.scrollViewWutzWhat.frame.size.width, 524);
                 
                 

             self.controllerShifter.frame= CGRectMake(0,0, self.controllerShifter.frame.size.width+1,44);
             }
         }
         else
         {
             for (int i = 0; i < self.viewControllersPerks.count; i++)
             {
                 PerksListViewController *controller = (PerksListViewController *)[self.viewControllersPerks objectAtIndex:i];
                 if(controller && ![controller isKindOfClass:[NSNull class]])
                 {
                     controller.sgmConceirge.alpha=1.0f;
                     controller.sgmConceirge.frame = controller.rectSGMConceirge;
                 }
            }
             
             for (int i = 0; i < self.viewControllersWutzWhat.count; i++)
             {
                 WutzWhatListViewController *controller = (WutzWhatListViewController *)[self.viewControllersWutzWhat objectAtIndex:i];
                 if(controller && ![controller isKindOfClass:[NSNull class]])
                 {
                     controller.sgmConceirge.alpha=1.0f;
                     controller.sgmConceirge.frame = controller.rectSGMConceirge;
                 }
                 
                 
             }
             if(OS_VERSION>=7)
             {
                 self.controllerShifter.frame= CGRectMake(0,44, self.controllerShifter.frame.size.width+1,44);
                 self.scrollViewPerks.frame = CGRectMake(0,88, self.scrollViewPerks.frame.size.width, 524);
                 self.scrollViewWutzWhat.frame = CGRectMake(0,88, self.scrollViewWutzWhat.frame.size.width, 524);
                 
             }
             self.JSScrollbarViewPerks.alpha=1.0f;
             self.JSScrollbarViewPerks.frame=rectJSScrollbarViewPerks;
             
             self.JSScrollbarViewWutzWhat.alpha=1.0f;
             self.JSScrollbarViewWutzWhat.frame=rectJSScrollbarViewWutzWhat;
         }
     }
     completion:^(BOOL finished)
     {
     }];
}


@end
