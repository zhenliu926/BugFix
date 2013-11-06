//
//  TourViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 4/23/13.
//
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"
#import "TourSingleViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TourViewController : UIViewController
<
UIScrollViewDelegate,
TourSingleViewDelegate
>
@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (nonatomic) StyledPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) int sectionType;
@end