
//
//  WutzWhatModel.h
//  WutzWhat
//
//  Created by Asad Ali on 04/10/13.
//
//

#import <UIKit/UIKit.h>
#import "WutzWhatListViewController.h"
#import "MapViewController.h"
#import "WutzWhatProductDetailViewController.h"
#import "FilterViewController.h"
#import "MenuViewController.h"
#import "JSScrollableTabBar.h"
#import "ParentViewController.h"

@interface WutzWhatViewController : ParentViewController <UIScrollViewDelegate, WutzWhatListViewDelegate>
{
    BOOL animating;
    BOOL scrollBarHidden;
}

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageView;

@property (nonatomic) int sectionType;

@end
