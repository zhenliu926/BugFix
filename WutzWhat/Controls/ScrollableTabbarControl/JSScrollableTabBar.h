//
//  JSScrollableTabBar.h
//  ScrollableTabBar
//
//  Created by James Addyman on 20/10/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTabItem.h"

@class JSScrollableTabBar, JSTabButton;

typedef enum {
	
	JSScrollableTabBarStyleBlack,
	JSScrollableTabBarStyleBlue,
	JSScrollableTabBarStyleTransparent
	
} JSScrollableTabBarStyle;

@protocol JSScrollableTabBarDelegate <NSObject>

@optional

- (void)scrollableTabBar:(JSScrollableTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index;

@end

@interface JSScrollableTabBar : UIView <UIScrollViewDelegate> {
    
	UIScrollView *_scrollView;
	
	NSMutableArray *_tabItems;
	
	JSScrollableTabBarStyle _style;
	
	UIImageView *_background;
	UIImageView *_fadeLeft;
	UIImageView *_fadeRight;
	
	JSTabButton *_previouslySelectedTabButton;
}
@property (nonatomic, assign) UIScrollView *_scrollView;
@property (nonatomic, assign) JSScrollableTabBarStyle style;
@property (nonatomic, assign) id <JSScrollableTabBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame style:(JSScrollableTabBarStyle)style;
- (void)setTabItems:(NSArray *)tabItems;
- (void)selectTabItemAtIndex:(int)index;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)updateFaders;
@end
