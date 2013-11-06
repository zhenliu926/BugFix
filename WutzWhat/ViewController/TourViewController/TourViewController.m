//
//  TourViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 4/23/13.
//
//

#import "TourViewController.h"

@interface TourViewController ()
{
    NSUInteger numberPages;
}
@end

@implementation TourViewController
@synthesize viewBackGround=_viewBackGround;
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
   
    TourSingleViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TourSingleViewController"];
    
    self.viewControllers = [[NSMutableArray alloc] initWithObjects:controller, controller, controller, controller, controller, nil];
    
    numberPages = self.viewControllers.count;
    
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
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight];
    
    
    [self SetUpPageController];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
    [self loadScrollViewWithPage:3];
    [self loadScrollViewWithPage:4];
    
    [self setupNavigationBarStyle];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(exitTours)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark -
#pragma mark Exit Tour
#pragma mark -

-(void)exitTours
{
    if([FIRST_LOGIN_TOUR_FINISHED boolValue] == false)
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"firstLoginTourDone"];
    
    [UIView animateWithDuration:0.5f animations:^(){
        [self.navigationController.navigationBar setAlpha:1.0f];
    } completion:^(BOOL done){
        if(done)
            [self.navigationController.navigationBar setHidden:FALSE];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark setup Navigation Bar
#pragma mark -

-(void)setupNavigationBarStyle
{
    [UIView animateWithDuration:0.3f animations:^(){
        [self.navigationController.navigationBar setAlpha:0.0f];
    } completion:^(BOOL done){
        if(done)
            [self.navigationController.navigationBar setHidden:TRUE];
    }];
}

#pragma mark -
#pragma mark Load View
#pragma mark -

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.viewControllers.count)
        return;
    
    TourSingleViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TourSingleViewController"];
        
        controller.delegate=self;
        controller.index = page;
        
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;

        [controller.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}

#pragma mark -
#pragma mark SetUpPageController
#pragma mark -

- (void) SetUpPageController
{
    self.pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(60, 390 , 200, 50)];
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    
    [self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewContentModeBottom|UIViewContentModeTop];
    [self.pageControl setPageControlStyle:PageControlStyleThumb];
    [self.pageControl setThumbImage:[UIImage imageNamed:@"tour_dot_on.png"]];
    [self.pageControl setSelectedThumbImage:[UIImage imageNamed:@"tour_dot_off.png"]];
    
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    if (IS_IPHONE_5)
    {
        [self.pageControl setFrame:CGRectMake(60, 480, 200, 50)];
    }

    [self.view addSubview:self.pageControl];
}

#pragma mark -
#pragma mark Scroll View Delegates
#pragma mark -


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    if (self.scrollView.contentOffset.x > 10 + CGRectGetWidth(self.scrollView.frame) * (numberPages-1))
    {
        [self exitTours];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}


- (void)viewDidUnload
{
    [self setViewBackGround:nil];
    [super viewDidUnload];
}


@end
