//
//  TalkViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import "TalksListViewController.h"
#import "MenuViewController.h"
#import "JSScrollableTabBar.h"
#import "AddTalkViewController.h"

@interface TalkViewController : UIViewController<UIScrollViewDelegate, JSScrollableTabBarDelegate, TalksListViewDelegate, AddTalkViewControllerDelegate>
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
