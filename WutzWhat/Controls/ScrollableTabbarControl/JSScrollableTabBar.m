//
//  JSScrollableTabBar.m
//  ScrollableTabBar
//
//  Created by James Addyman on 20/10/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//
#import "JSScrollableTabBar.h"
#import "JSTabButton.h"
#import "UIImage+JSRetinaAdditions.h"
#import <QuartzCore/QuartzCore.h>

#define TABBAR_HEIGHT 44
@interface JSScrollableTabBar ()

- (void)layoutTabs;
- (void)updateFaders;
- (void)tabSelected:(id)sender;
- (void)selectTabAtIndex:(NSInteger)index;

@end


@implementation JSScrollableTabBar

@synthesize style = _style;
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame style:(JSScrollableTabBarStyle)style
{
    if ((self = [super initWithFrame:frame]))
	{
		_tabItems = [[NSMutableArray alloc] init];
		
		_background = [[UIImageView alloc] initWithFrame:frame];
        _background.backgroundColor = [UIColor colorFromHexString:@"dddddd"];
        [_background setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[self addSubview:_background];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor colorFromHexString:@"dddddd"];
		[_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[_scrollView setShowsHorizontalScrollIndicator:NO];
		[_scrollView setShowsVerticalScrollIndicator:NO];
		[_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
		[self addSubview:_scrollView];
		
		_fadeLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
		_fadeRight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
		CGRect fadeFrame = [_fadeRight frame];
		fadeFrame.origin.x = self.frame.size.width - fadeFrame.size.width;
		[_fadeRight setFrame:fadeFrame];
		
		[self addSubview:_fadeLeft];
		[self addSubview:_fadeRight];
		
		self.style = style;
        [self addShadow];
        self.backgroundColor = [UIColor colorFromHexString:@"dddddd"];
	}
	
    return self;
}

- (void)dealloc
{
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect fadeFrame = [_fadeRight frame];
	fadeFrame.origin.x = self.frame.size.width - fadeFrame.size.width;
	[_fadeRight setFrame:fadeFrame];
}

- (void)setStyle:(JSScrollableTabBarStyle)style
{
	_style = style;
	
	NSString *imageBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"images.bundle"];
	NSBundle *imageBundle = [NSBundle bundleWithPath:imageBundlePath];
	
	UIImage *backgroundImage = nil;
	UIImage *fadeLeft = nil;
	UIImage *fadeRight = nil;
	
	switch (self.style)
	{
		case JSScrollableTabBarStyleBlue:
			backgroundImage = [[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"barBackgroundBlue" ofType:@"png"]] stretchableImageWithLeftCapWidth:1
																																										   topCapHeight:0];
			fadeLeft = [UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"fadeLeft_blue" ofType:@"png"]];
			fadeRight = [UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"fadeRight_blue" ofType:@"png"]];
			break;
		case JSScrollableTabBarStyleBlack:
			backgroundImage = [[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"barBackgroundBlack" ofType:@"png"]] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
			fadeLeft = [UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"fadeLeft_black" ofType:@"png"]];
			fadeRight = [UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"fadeRight_black" ofType:@"png"]];
			break;
		case JSScrollableTabBarStyleTransparent:
			backgroundImage = [[UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"barBackgroundTrans" ofType:@"png"]] stretchableImageWithLeftCapWidth:1
																																											topCapHeight:0];
			fadeLeft = [UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"fadeLeft_trans" ofType:@"png"]];
			fadeRight = [UIImage imageWithContentsOfResolutionIndependentFile:[imageBundle pathForResource:@"fadeRight_trans" ofType:@"png"]];
			break;
		default:
			break;
	}
//	[_background setImage:backgroundImage];
    _background.backgroundColor = [UIColor colorFromHexString:@"dddddd"];

//	[_fadeLeft setImage:fadeLeft];
//	[_fadeRight setImage:fadeRight];
}

- (void)setTabItems:(NSArray *)tabItems
{
	_tabItems = [tabItems mutableCopy];
	
	[self layoutTabs];
}

- (void)layoutTabs
{
	[[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	CGFloat currentXposition = 0;
	CGFloat padding = 0;
	
	CGFloat overallWidth = 0.0;
//	NSString *imageBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"images.bundle"];
//	NSBundle *imageBundle = [NSBundle bundleWithPath:imageBundlePath];
	for (JSTabItem *item in _tabItems)
	{
		JSTabButton *tabButton = [JSTabButton tabButtonWithTitle:[item title] color:[item color] textColor:[item textColor] image:item.image highlightedImage:item.highlightedImage];
		[tabButton setTag:[_tabItems indexOfObject:item]];
		[tabButton addTarget:self
					  action:@selector(tabSelected:)
			forControlEvents:UIControlEventTouchDown];
		
		CGRect frame = [tabButton frame];
		frame.origin.x = currentXposition;
		frame.origin.y = abs((self.frame.size.height - frame.size.height) / 2) + 0;
		[tabButton setFrame:frame];
		
		currentXposition = frame.origin.x + frame.size.width + padding;
		
		overallWidth += (frame.size.width + padding);
		
		[_scrollView addSubview:tabButton];
	}
    
	[_scrollView setContentSize:CGSizeMake((overallWidth + padding), self.frame.size.height)];
	[self selectTabAtIndex:0];
	[self updateFaders];
}

- (void)updateFaders
{
	[UIView beginAnimations:nil context:nil];
	
	if ([_scrollView contentOffset].x < ([_scrollView contentSize].width - self.frame.size.width))
		[_fadeRight setAlpha:1.0];
	else
		[_fadeRight setAlpha:0.0];
	
	if ([_scrollView contentOffset].x > 0)
		[_fadeLeft setAlpha:1.0];
	else
		[_fadeLeft setAlpha:0.0];
	
	[UIView commitAnimations];
}

- (void)tabSelected:(id)sender
{
	JSTabButton *tabButton = (JSTabButton *)sender;
	
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x ,0) animated:false];
    
	if ([tabButton isToggled])
		return;
	
	[tabButton setToggled:YES];
	
	[_previouslySelectedTabButton setToggled:NO];
	_previouslySelectedTabButton = tabButton;
	
	if ([self.delegate respondsToSelector:@selector(scrollableTabBar:didSelectTabAtIndex:)])
	{
		[self.delegate scrollableTabBar:self didSelectTabAtIndex:[tabButton tag]];
	}
    
    
    
}

- (void)selectTabAtIndex:(NSInteger)index
{
	if (index < 0 || index >= [[_scrollView subviews] count])
		return;
	;
	JSTabButton *tabButton = [[_scrollView subviews] objectAtIndex:index];
    
	[self tabSelected:tabButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self updateFaders];
}

- (void)selectTabItemAtIndex:(int)index
{
    if (index < 0 || index >= [[_scrollView subviews] count])
		return;
    
    JSTabButton *tabButton = [[_scrollView subviews] objectAtIndex:index];
    int scrollcount = [[_scrollView subviews] count]-1;
    if ([tabButton isToggled])
    {
        if (index == 3 || index == 1 || index == 2 )
        {
            [_scrollView setContentOffset:CGPointMake(tabButton.frame.origin.x - 28 ,0) animated:TRUE];
            
        } else if (index == 4 || index == 5){
            [_scrollView setContentOffset:CGPointMake(-self.frame.size.width + 640 - 28,0) animated:TRUE];
        } else if(index == 0)
            [_scrollView setContentOffset:CGPointMake(0 ,0) animated:TRUE];
        return;
    }
		
    [tabButton setToggled:YES];
	
	[_previouslySelectedTabButton setToggled:NO];
    
	_previouslySelectedTabButton = tabButton;

    
    if (index != 0 && index != scrollcount)
    {
        if (index==4||index==3) {
            [_scrollView setContentOffset:CGPointMake(292, tabButton.frame.origin.y) animated:TRUE];
        }else if (index==2 || index==1)
        {
            [_scrollView setContentOffset:CGPointMake(0, tabButton.frame.origin.y) animated:TRUE];
        }
        else{
         [_scrollView setContentOffset:CGPointMake(tabButton.frame.origin.x-100, tabButton.frame.origin.y) animated:TRUE];   
        }
        return;
    }
    else if (index == 0 )
    {
        [_scrollView setContentOffset:CGPointMake(0, tabButton.frame.origin.y) animated:TRUE];
        return;
    }
    else if (index == scrollcount )
    {
        [_scrollView setContentOffset:CGPointMake(292, tabButton.frame.origin.y) animated:TRUE];
        return;
    }
}

#pragma mark -
#pragma mark Shadow
#pragma mark -
- (void)addShadow
{
    // draw shadow
    self.layer.masksToBounds = NO;
    //-3 up 3 down
    self.layer.shadowOffset = CGSizeMake(0, -0.6);
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}


@end
