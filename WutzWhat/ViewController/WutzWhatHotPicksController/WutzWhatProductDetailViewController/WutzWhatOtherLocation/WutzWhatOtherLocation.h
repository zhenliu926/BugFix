//
//  WutzWhatOtherLocation.h
//  WutzWhat
//
//  Created by Zeeshan on 1/21/13.
//
//

#import <UIKit/UIKit.h>
#import "SharedManager.h"
#import "ProcessingView.h"
#import "Constants.h"
#import "DataFetcher.h"
#import "WutzWhatModel.h"
#import "AuthorInfoModel.h"
#import "LocationModel.h"
#import "DataModel.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface WutzWhatOtherLocation : UIViewController<DataFetcherDelegate>
{
    NSString *postid;
    NSString *page;
    NSMutableArray *array;
}

@property (nonatomic, assign) int postTypeID;
@property (nonatomic,retain) IBOutlet UITableView *tblLocation;
@property (nonatomic,retain) NSString *postid;
@property (nonatomic,retain) NSString *page;
@end
