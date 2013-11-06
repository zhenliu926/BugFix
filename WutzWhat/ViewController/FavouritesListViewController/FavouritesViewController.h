//
//  FavouritesViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 2/4/13.
//
//

#import <UIKit/UIKit.h>
#import "WutzWhatListViewController.h"
#import "PerksListViewController.h"
#import "MenuViewController.h"
#import "JSScrollableTabBar.h"
#import "UIImage+JSRetinaAdditions.h"

@interface FavouritesViewController : UIViewController<UIScrollViewDelegate, JSScrollableTabBarDelegate, WutzWhatListViewDelegate, PerksListViewDelegate>
{
    CGRect rectJSScrollbarViewPerks;
    CGRect rectJSScrollbarViewWutzWhat;
}


@property (nonatomic, strong) NSMutableArray *viewControllersWutzWhat;
@property (nonatomic, strong) NSMutableArray *viewControllersPerks;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewWutzWhat;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewPerks;
@property (strong, nonatomic) IBOutlet UIPageControl *pageViewWutzWhat;
@property (strong, nonatomic) IBOutlet UIPageControl *pageViewPerks;

@property (strong, nonatomic) JSScrollableTabBar *tabBarWutzWhat;
@property (strong, nonatomic) UIView *JSScrollbarViewWutzWhat;
@property (strong, nonatomic) JSScrollableTabBar *tabBarPerks;
@property (strong, nonatomic) UIView *JSScrollbarViewPerks;

@property (strong, nonatomic) IBOutlet UISegmentedControl *controllerShifter;
@end
