//
//  PerksListViewController.h
//  WutzWhat
//
//  Created by Rafay on 12/11/12.
//
//

#import <UIKit/UIKit.h>
#import "PerksModel.h"
#import "EGORefreshTableHeaderView.h"
#import "CustomSearchBar.h"
#import "FilterModel.h"
#import "PerkFilterViewController.h"
#import "MNMBottomPullToRefreshManager.h"
#import "PerksListAPIManager.h"
#import "PerksProductDetailViewController.h"
#import "CustomCell.h"

#define MAX_SHIFT_PER_SCROLL    10

@protocol PerksListViewDelegate <NSObject>

-(void)hideNavigationBar:(BOOL)hide;

@end

@interface PerksListViewController : UIViewController
<
UISearchBarDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
UITableViewDelegate,
PerksListAPIManagerDelegate,
EGORefreshTableHeaderDelegate,
PerkFilterDelegate,
PerksProductDetailViewDelegate,
MNMBottomPullToRefreshManagerClient
>
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL isLoadMore;
    UIImageView *selectedBgView;
    LoadMore *loadMore;
}

@property (nonatomic, assign) id<PerksListViewDelegate> delegate;
@property (nonatomic, strong) PerksListAPIManager *apiManager;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *sectionsArray;
@property (nonatomic,strong) NSMutableArray *serverResponseArray;

@property (nonatomic) CGRect rectSGMConceirge;

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
@property (nonatomic) BOOL isTableEditModeEnabled;

@property (nonatomic) int categoryType;
@property (nonatomic) BOOL viewingAsFavourite;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;

-(void)hideTableSearchBar;
-(void)enableEditModeForTableView;

@end
