//
//  ParentViewController.h
//  WutzWhat
//
//  Created by Asad Ali on 6/18/13.
//
//

#import <UIKit/UIKit.h>
#import "JSScrollableTabBar.h"

@interface ParentViewController : UIViewController<JSScrollableTabBarDelegate>
{
    CGRect rectJSScrollbarView;    
}

@property (strong, nonatomic) JSScrollableTabBar *tabBar;
@property (strong, nonatomic) UIView *JSScrollbarView;


-(void)setupCategoryTabBarItems;

@end
