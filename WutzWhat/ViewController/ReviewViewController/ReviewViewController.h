//
//  ReviewViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/21/12.
//
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"
#import "SharedManager.h"
#import "ProcessingView.h"
#import "Constants.h"
#import "DataFetcher.h"

@interface ReviewViewController : UIViewController<DataFetcherDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSString *postid;
    NSString *page;
    NSMutableArray *array;
}


@property (nonatomic, assign) int postTypeID;
@property (nonatomic,retain) NSString *postid;
@property (nonatomic,retain)NSString *page;
@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSArray *sectionsArray;
@property (nonatomic,retain) NSMutableArray *rows;
@property (weak, nonatomic) IBOutlet UITableView *tblReviews;
@property (nonatomic,retain) ReviewModel *reviews;

@end
