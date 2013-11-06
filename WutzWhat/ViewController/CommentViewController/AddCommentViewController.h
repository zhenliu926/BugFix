//
//  AddCommentViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import <UIKit/UIKit.h>
#import "ProcessingView.h"
#import "SharedManager.h"
#import "DataFetcher.h"
#import "Constants.h"
#import "Utiltiy.h"
#import <QuartzCore/QuartzCore.h>

@interface AddCommentViewController : UIViewController<UITextViewDelegate, DataFetcherDelegate>
{
    NSString *postid;
}
@property (nonatomic, assign) int postTypeID;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (nonatomic,retain) NSString *postid;

@property (strong, nonatomic)IBOutlet UIScrollView *scrollView;
@end
