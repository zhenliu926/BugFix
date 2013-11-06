//
//  MyPerksViewController.m
//  WutzWhat
//
//  Created by Rafay on 3/20/13.
//
//

#import "MyPerksViewController.h"
#import "CreditModel.h"
#import "PerksProductDetailViewController.h"

@interface MyPerksViewController ()

@end

@implementation MyPerksViewController

@synthesize sectionsArray,rows,dataDict,page;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    
	[self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];

    UIImage *backButton = [UIImage imageNamed:@"top_back.png"];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];    
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks.png"]];
    [[self navigationItem]setTitleView:titleIV];
   
    if (self.pullToRefreshTableManager == nil)
    {
                self.pullToRefreshTableManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tblCredit withClient:self];
    }
    isLoadMore = NO;
    self.isLastLoadSuccessful = NO;
    loadMore = [[LoadMore alloc] init];    
    
    [self calServiceWithURL:GET_MYPERKS_LIST];
    [[ProcessingView instance] showTintViewWithUserInteractionEnabled];
    
    self.view.backgroundColor = self.tblCredit.backgroundColor = [UIColor colorFromHexString:@"F2F2F2"];
   
    
    
    
//    self.tblCredit.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tblCredit.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    
}

#pragma mark -
#pragma mark Table View Delgates
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.contentSize = CGSizeMake(tableView.contentSize.width, [array count] * 80);
    tableView.scrollEnabled = tableView.contentSize.height > tableView.frame.size.height ? true : false;
    
    if(OS_VERSION>=7)
    {
        tableView.frame=CGRectMake(tableView.frame.origin.x,44,tableView.frame.size.width,tableView.frame.size.height);
        
        
    }

    else
    tableView.frame = CGRectMake(0, 0, tableView.frame.size.width, self.view.frame.size.height);
    
    return [array count];
}


- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CreditCell";
    
    CustomCell *cell = (CustomCell*)[self.tblCredit dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    CreditModel *menu = [array objectAtIndex:indexPath.row];
    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    if ( ![menu.dataInfo.title isKindOfClass:[NSNull class]] && ![menu.dataInfo.title isEqualToString:@""])
    {
        [title setText:menu.dataInfo.title];
    }
    else
    {
        [title setText:@""];
    }
    
    UILabel *summary = (UILabel*)[cell viewWithTag:2];
    if ( ![menu.dataInfo.info isKindOfClass:[NSNull class]] && ![menu.dataInfo.info isEqualToString:@""] )
    {
        [summary setText:menu.dataInfo.info];
        
    }
    else
    {
        [summary setText:@""];
    }
    
    
    UILabel *date = (UILabel*)[cell viewWithTag:3];
    if ( ![menu.date isKindOfClass:[NSNull class]] && ![menu.date isEqualToString:@""] )
    {
        [date setText:menu.date];
    }
    else{
        [date setText:@""];
    }
    
    
    UIImageView *managedImage = (UIImageView*)[cell viewWithTag:4];
    [[managedImage layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[managedImage layer] setBorderWidth:0.8];
    [[managedImage layer] setCornerRadius:5];
    managedImage.ClipsToBounds= YES;
    if ( ![menu.dataInfo.thumbnailUrl isKindOfClass:[NSNull class]] && ![menu.dataInfo.thumbnailUrl isEqualToString:@""] )
    {
        [managedImage setImageWithURL:[NSURL URLWithString:menu.dataInfo.thumbnailUrl]];
    }
    else
    {
        [managedImage setImage:[UIImage imageNamed:@"list_thumbnail.png"]];
    }
    
    
    //cell backgrounds
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_clean_dark.png"]];
    [cell setBackgroundView:bgview];
    UIView* bgview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview1.opaque = YES;
    bgview1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_clean_light.png"]];
    
    if (indexPath.row%2==0)
    {
        cell.backgroundView = bgview;
    }
    else
    {
        cell.backgroundView = bgview1;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openReceiptScreen:indexPath.row];
}

- (void)openReceiptScreen:(int)row
{
    CreditModel *perks = [array objectAtIndex:row];
    ReceiptViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptViewController"];
    controller.perkID = perks.dataInfo.postId;
    controller.pdfID = perks.dataInfo.pdfID;
    
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark -
#pragma mark Webservice
#pragma mark -
- (void) calServiceWithURL:(NSString*)serviceUrl
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:[NSString stringWithFormat:@"%d", [self getPageNumber]] forKey:@"page"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}


- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_MYPERKS_LIST]])
    {
        [[ProcessingView instance] hideTintView];
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess)
        {
            NSMutableArray *dataArray = [responseData objectForKey:@"data"];
            NSMutableArray *modelArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in dataArray)
            {
                CreditModel *credits = [[CreditModel alloc] init];
                [credits setDate:[dic valueForKey:@"purchase_date"]];
            
                DataModel *datam = [[DataModel alloc]init];
                [datam setTitle:[dic objectForKey:@"p_title"]];
                [datam setPostId:[dic objectForKey:@"perk_id"]];
                [datam setDescription:[dic objectForKey:@"p_short_desc"]];
                [datam setInfo:[dic objectForKey:@"p_short_desc"]];
                [datam setThumbnailUrl:[dic objectForKey:@"thumb_url"]];
                [datam setPdfID:[dic objectForKey:@"pdf_id"]];
        
                [credits setDataInfo:datam];
                
                [modelArray addObject:credits];
            }
            [self checkLastRequestSuccess:modelArray];
            if (isLoadMore ==YES)
            {
                [self.pullToRefreshTableManager tableViewReloadFinished];
                [array addObjectsFromArray:modelArray];
            }
            else
            {
                array = [[NSMutableArray alloc] initWithArray:modelArray];
            }
            [self.tblCredit reloadData];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:[responseData objectForKey:@"error"] != nil && [[responseData objectForKey:@"error"] isKindOfClass:[NSNull class]] ? @"Error from database server" : [responseData objectForKey:@"error"]];
        }
        if([CommonFunctions isPerkPurchased]){
            [self openReceiptScreen:0];
            [CommonFunctions setPerkPurchasedOff];
        }
    }
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] hideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_MYPERKS_LIST]])
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
    }
}


-(NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp
{
    NSString *postTime = @"";
    if (timeStamp)
        {
            postTime = [timeStamp stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
            postTime = [postTime stringByReplacingOccurrencesOfString:@")/" withString:@""];
            NSArray *timeArray = [postTime componentsSeparatedByString:@"-"];
            double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
            
            postTimeLong = (postTimeLong/1000);
            
            NSDate *tr = [NSDate dateWithTimeIntervalSince1970:postTimeLong];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM d, yyyy h:mm aa"];
            postTime = [formatter stringFromDate:tr];
        }
    return postTime;
    
}

- (void) backBtnTapped:(id)sender
{
        
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load More Bussiness Logic

-(void)checkLastRequestSuccess:(NSArray *)responseArray
{
    self.isLastLoadSuccessful = responseArray.count > 9;
}

-(int)getPageNumber
{
    int pageNumber = 1;
    
    if (isLoadMore)
    {
        pageNumber = [loadMore getNextPageNumberForTablePaggination:self.tblCredit];
    }
    return pageNumber;
}


#pragma mark LoadMore

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    [self performSelector:@selector(loadMorePages) withObject:nil afterDelay:0.1f];
}


-(void)loadMorePages
{
    if ([loadMore canGetMoreRecordsForTableView:self.tblCredit andIsLastLoadSuccessful:self.isLastLoadSuccessful isMyFindTable:NO])
    {
        isLoadMore=YES;
        [self calServiceWithURL:GET_MYPERKS_LIST];
        [[ProcessingView instance] forceHideTintView];
    }
    else
    {
        [self.pullToRefreshTableManager tableViewReloadFinished];
    }
}


#pragma mark - Scroll View delegate Methods for Pagination

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        CGFloat currentOffset = scrollView.contentOffset.y;
        lastContentOffset = currentOffset;
        [self.pullToRefreshTableManager tableViewScrolled];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {        
        [self.pullToRefreshTableManager tableViewReleased];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        if(scrollView.contentOffset.y >= ([[UIScreen mainScreen] bounds].size.height / 2))
            //                [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height + 55) animated:TRUE];
            [UIView animateWithDuration:0.5f animations:^(){
                [scrollView setContentInset:UIEdgeInsetsMake(lastContentOffset,0,0,0)];
            }];
        
    }
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
