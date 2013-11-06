//
//  CreditViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/23/12.
//
//

#import <UIKit/UIKit.h>
#import "CreditModel.h"
#import "MyPerksViewController.h"

@interface CreditViewController : UIViewController <DataFetcherDelegate, UIScrollViewDelegate,MNMBottomPullToRefreshManagerClient>
{
    NSMutableArray *array;
    int page;
    
    BOOL isLoadMore;
    LoadMore *loadMore;
}

@property (nonatomic) BOOL isLastLoadSuccessful;

@property (nonatomic, strong) MNMBottomPullToRefreshManager *pullToRefreshTableManager;
@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSArray *sectionsArray;
@property (nonatomic,retain) NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UILabel *lblCreditBalance;
@property (strong, nonatomic) IBOutlet UILabel *creditText;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *creditImg;
@property (strong, nonatomic) IBOutlet UIButton *spreadWW;
@property (strong, nonatomic) IBOutlet UIButton *redeemCode;
@property (strong, nonatomic) IBOutlet UITableView *tblCredit;

@property (strong, nonatomic) IBOutlet UIButton *myPerksBtn;
- (IBAction)myPerksBtn_clicked:(UIButton *)sender;

@end
