
//
//  WutzWhatModel.h
//  WutzWhat
//
//  Created by Asad Ali on 04/10/13.
//
//

#import <UIKit/UIKit.h>
#import "WutzWhatModel.h"
#import "EGORefreshTableHeaderView.h"
#import "CustomSearchBar.h"
#import "FilterModel.h"
#import "FilterViewController.h"
#import "MNMBottomPullToRefreshManager.h"
#import "WutzWhatListAPIManager.h"
#import "WutzWhatProductDetailViewController.h"
#import "LoadMore.h"
#import "CustomCell.h"

#define MAX_SHIFT_PER_SCROLL    10

@protocol WutzWhatListViewDelegate <NSObject>
@optional
-(void)hideNavigationBar:(BOOL)hide;
-(BOOL)tabBarHidden;


@end

@interface WutzWhatListViewController : UIViewController
<
UISearchBarDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
UITableViewDelegate,
WutzWhatListAPIManagerDelegate,
EGORefreshTableHeaderDelegate,
FilterDelegate,
WutzWhatProductDetailViewDelegate,
MNMBottomPullToRefreshManagerClient
>
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL isLoadMore;
    UIImageView *selectedBgView;
    LoadMore *loadMore;
    CGRect scrollviewRect;
}

@property (nonatomic, assign) id<WutzWhatListViewDelegate> delegate;

@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *sectionsArray;
@property (nonatomic,strong) NSMutableArray *serverResponseArray;

@property (nonatomic) CGRect rectSGMConceirge;
@property (strong, nonatomic) WutzWhatListAPIManager *apiManager;
@property (nonatomic) int segmentSelectedIndex;
@property (nonatomic) int filterBy;
@property (nonatomic, strong) FilterModel *savedFilter;

@property (nonatomic, strong) MNMBottomPullToRefreshManager *pullToRefreshTableManager;

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableHeaderView;

@property (strong, nonatomic) IBOutlet UITableView *tblCategoryList;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgmConceirge;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSString *sectionHeaderIconName;

@property (assign, nonatomic) BOOL reloadingCategoryTable;
@property (nonatomic) BOOL isLastLoadSuccessful;

@property (nonatomic) int categoryType;
@property (nonatomic) int sectionType;
@property (nonatomic) BOOL viewingAsFavourite;
@property (nonatomic) BOOL isTableEditModeEnabled;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;

-(void)hideTableSearchBar;
-(void)enableEditModeForTableView;

@end


