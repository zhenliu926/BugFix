//
//  TalksProductListViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import <UIKit/UIKit.h>
#import "TalksModel.h"
#import "EGORefreshTableHeaderView.h"
#import "MNMBottomPullToRefreshManager.h"
#import "TalksListAPIManager.h"
#import "TalksProductDetailViewController.h"
#import "LoadMore.h"
#import "CustomCell.h"

#define MAX_SHIFT_PER_SCROLL    10

@protocol TalksListViewDelegate <NSObject>

-(void)hideNavigationBar:(BOOL)hide;
-(void)addMyFindButtonClicked;

@end

@interface TalksListViewController : UIViewController
<
UITableViewDataSource,
UIScrollViewDelegate,
UITableViewDelegate,
TalksListAPIManagerDelegate,
EGORefreshTableHeaderDelegate,
MNMBottomPullToRefreshManagerClient,
TalksProductDetailViewControllerDelegate
>
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL isLoadMore;
    UIImageView *selectedBgView;
    LoadMore *loadMore;
}

@property (nonatomic, assign) id<TalksListViewDelegate> delegate;
@property (nonatomic, strong) TalksListAPIManager *apiManager;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSArray *sectionsArray;
@property (nonatomic,strong) NSMutableArray *serverResponseArray;

@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (nonatomic, strong) MNMBottomPullToRefreshManager *pullToRefreshTableManager;

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshTableHeaderView;

@property (retain, nonatomic) IBOutlet UITableView *tblCategoryList;

@property (strong, nonatomic) NSString *sectionHeaderIconName;

@property (assign, nonatomic) BOOL reloadingCategoryTable;
@property (nonatomic) BOOL isLastLoadSuccessful;

@property (nonatomic) int categoryType;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;


- (void)callTalksListAPI;

@end
