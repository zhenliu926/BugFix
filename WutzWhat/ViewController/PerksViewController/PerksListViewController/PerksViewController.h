//
//  PerksViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 4/11/13.
//
//

#import <UIKit/UIKit.h>
#import "PerksListViewController.h"
#import "MapViewController.h"
#import "PerksProductDetailViewController.h"
#import "PerkFilterViewController.h"
#import "MenuViewController.h"
#import "JSScrollableTabBar.h"

@interface PerksViewController : UIViewController <UIScrollViewDelegate, JSScrollableTabBarDelegate, PerksListViewDelegate>
{
    CGRect rectJSScrollbarView;
    BOOL animating;
}

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageView;

@property (strong, nonatomic) JSScrollableTabBar *tabBar;
@property (strong, nonatomic) UIView *JSScrollbarView;

@property (nonatomic) int sectionType;

@end
