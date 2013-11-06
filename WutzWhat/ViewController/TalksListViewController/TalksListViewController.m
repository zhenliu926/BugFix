//
//  TalksProductListViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import "TalksListViewController.h"
#import "SDImageCache.h"

@implementation TalksListViewController


@synthesize dataDict = _dataDict;
@synthesize sectionsArray = _sectionsArray;
@synthesize pullToRefreshTableManager = _pullToRefreshTableManager;
@synthesize isLastLoadSuccessful=_isLastLoadSuccessful;
@synthesize refreshTableHeaderView = _refreshTableHeaderView;
@synthesize categoryType = _categoryType;
@synthesize delegate = _delegate;
@synthesize serverResponseArray = _serverResponseArray;
@synthesize activityIndicator = _activityIndicator;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize sectionHeaderIconName = _sectionHeaderIconName;
@synthesize apiManager = _apiManager,tblCategoryList;

#pragma mark View Controller Life Cycle

- (void)internetNotAvailableError:(NSString *)errorMessage{}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL) animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    //self.tblCategoryList.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    
    
    
    self.apiManager = [[TalksListAPIManager alloc] init];
    self.apiManager.delegate = self;
    
    self.serverResponseArray = [[NSMutableArray alloc] init];
    self.dataDict = [[NSDictionary alloc] init];
    self.sectionsArray = [[NSArray alloc] init];
    
    if (self.refreshTableHeaderView == nil)
    {
        if(OS_VERSION>=7)
        {
            self.tblCategoryList.frame=CGRectMake(0,44,self.view.frame.size.width , self.tblCategoryList.bounds.size.height);
           // self.tblCategoryList.backgroundColor=[UIColor blackColor];
            
        }
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblCategoryList.bounds.size.height, self.view.frame.size.width, self.tblCategoryList.bounds.size.height)];
        
        view.delegate = self;
        
		[self.tblCategoryList addSubview:view];
		self.refreshTableHeaderView = view;
	}
    
    [self.refreshTableHeaderView refreshLastUpdatedDate];
    
    self.reloadingCategoryTable = NO;
    
    isLoadMore = NO;
    
    if (_pullToRefreshTableManager == nil)
    {
        _pullToRefreshTableManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tblCategoryList withClient:self];
    }
    
    self.sectionHeaderIconName = @"icon_list_wutzwhat.png";
    
    [self setupTableHeightForiPhone5];
    
    [self callTalksListAPI];
    
    selectedBgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_finds_c.png"]];
    loadMore = [[LoadMore alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.pullToRefreshTableManager relocatePullToRefreshView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setupTableHeightForiPhone5
{
    if (IS_IPHONE_5)
    {
        self.tblCategoryList.frame = CGRectMake(0, self.tblCategoryList.frame.origin.y, self.tblCategoryList.frame.size.width, 550);
    }
}


#pragma mark Table View Delegates


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionsArray count] > 0 ? [self.sectionsArray count] : 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sectionsArray.count == 0)
        return 1;
    
    NSString *sectionNameKey =[self.sectionsArray objectAtIndex:section];
    
    NSMutableArray *dataArray = [self.dataDict objectForKey:sectionNameKey];
    
    if (section == self.sectionsArray.count -1)
    {
        return dataArray.count + 1;
    }
    
    return dataArray.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sectionsArray.count == 0)
        return nil;
    
    UIImageView *sectionBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_sectionbar.png"]];
    UIImageView *sectionHeaderIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.sectionHeaderIconName]];
    sectionHeaderIcon.frame= CGRectMake(10, 5, 12, 11);
    
    UILabel *labelForHeaderView =[[UILabel alloc] initWithFrame:CGRectMake(25, 3, 180, 16)];
    labelForHeaderView.backgroundColor = [UIColor clearColor];
    labelForHeaderView.textColor = [UIColor darkGrayColor];
    labelForHeaderView.text = @"";
    [labelForHeaderView setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 13.0]];
    labelForHeaderView.text = [NSString stringWithFormat:@"%@",[CommonFunctions getDateStringInFormat:LIST_CELL_HEADER_DATE_FORMATE date:[self.sectionsArray objectAtIndex:section]]];
    
    [sectionBgView addSubview:sectionHeaderIcon];
    
    [sectionBgView addSubview:labelForHeaderView];
    
    return sectionBgView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.sectionsArray.count == 0)
        return nil;
    
    return [self.sectionsArray objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == self.sectionsArray.count - 1 && indexPath.row == [[self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]] count]) || (self.sectionsArray.count == 0 && indexPath.row == 0))
        return;
    
    [self.tblCategoryList deselectRowAtIndexPath:indexPath animated:YES];
    
    TalksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TalksProductDetailViewController"];
    
    controller.menu = [[self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    controller.categoryType = self.categoryType;
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == self.sectionsArray.count - 1 && indexPath.row == [[self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]] count]) || (self.sectionsArray.count == 0 && indexPath.row == 0))
    {
        CustomCell *cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMyFind"];
        cell.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btnAddNewFind = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btnAddNewFind setBackgroundImage:[UIImage imageNamed:@"btn_white.png"] forState:UIControlStateNormal];
        [btnAddNewFind setBackgroundImage:[UIImage imageNamed:@"btn_white_c.png"] forState:UIControlStateHighlighted];
        
        btnAddNewFind.frame = CGRectMake(20, 20, 280, 40);
        [btnAddNewFind setTitle:@"Add New Find" forState:UIControlStateNormal];
        [btnAddNewFind setTitle:@"Add New Find" forState:UIControlStateHighlighted];
        [btnAddNewFind setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnAddNewFind setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [btnAddNewFind setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAddNewFind setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnAddNewFind.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [btnAddNewFind.titleLabel setFont:[UIFont fontWithName:HELVETIC_NEUE_BOLD size:16]];
        [btnAddNewFind addTarget:self action:@selector(addNewFindClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnAddNewFind];
        
        return cell;
    }
    
    static NSString *cellIdentifier = @"CategoryCell";
    UITableViewCell *cell;
    
    cell = (CustomCell*)[self.tblCategoryList dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    TalksModel *model= [[self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UIImageView *managedImage = (UIImageView*)[cell viewWithTag:1];
    
    [[managedImage layer] setCornerRadius:5];
    managedImage.ClipsToBounds= YES;
    
    if (![model.thumbnailURL isEqualToString:@""])
    {
        [managedImage setImageWithURL:[NSURL URLWithString:model.thumbnailURL]];
    }
    else
    {
        [managedImage setImage:[UIImage imageNamed:@"list_thumbnail.png"]];
    }

    UILabel *titleLbl = (UILabel*)[cell viewWithTag:2];
    [titleLbl setText:model.title];
    
    
   // UILabel *shortDiscription = (UILabel*)[cell viewWithTag:3];
   // [shortDiscription setText:model.info];
    
    UILabel *cost = (UILabel*)[cell viewWithTag:4];
    [cost setText: model.price == 4 ? @"$$$$" : model.price == 3 ? @"$$$" : model.price == 2 ? @"$$" : model.price == 1 ? @"$" : @"$"];
    
    
    UILabel *like = (UILabel*)[cell viewWithTag:5];
    [like setText:[CommonFunctions getDateStringInFormat:LIST_CELL_DATE_FORMATE date:model.postTime]];
    
    ((UIImageView *)[cell viewWithTag:20]).hidden = true;
    UILabel *distance = (UILabel*)[cell viewWithTag:6];
    if(model.distance < 0) {
        distance.hidden = true;
        ((UIImageView *)[cell viewWithTag:20]).hidden = true;
    }
    else {
        distance.hidden = false;
        [distance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:[NSNumber numberWithInt:model.distance]]];
        ((UIImageView *)[cell viewWithTag:20]).hidden = false;
    }
    if (indexPath.row%2==0)
    {
        UIImageView* imgDark = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_clean_dark.png"] stretchableImageWithLeftCapWidth:320.0 topCapHeight:1.0]];
        
        cell.backgroundView = imgDark;
    }
    else
    {
        UIImageView* imgLight = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_clean_light.png"] stretchableImageWithLeftCapWidth:320.0 topCapHeight:1.0]];
        cell.backgroundView = imgLight;
    }
    
    [cell setSelectedBackgroundView:selectedBgView];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.sectionsArray.count == 0 && section == 0)
    {
        return 0;
    }
    else
    {
        return 20.0f;
    }
}


#pragma mark Scroll view Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        [self.delegate hideNavigationBar:YES];
        return YES;
    }
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        CGFloat currentOffset = scrollView.contentOffset.y;
        CGFloat differenceFromStart = startContentOffset - currentOffset;
        CGFloat differenceFromLast = lastContentOffset - currentOffset;
        lastContentOffset = currentOffset;
        
        [self.pullToRefreshTableManager tableViewScrolled];
        
        [self.refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
        
        if((differenceFromStart) < 0)
        {
            if(scrollView.isTracking && (abs(differenceFromLast)>1))
            {
                [self.delegate hideNavigationBar:YES];
            }
        }
        else
        {
            if(scrollView.isTracking && (abs(differenceFromLast)>1))
            {
                [self.delegate hideNavigationBar:NO];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        [self.refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        
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

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.reloadingCategoryTable;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}


#pragma mark LoadMore

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    [self performSelector:@selector(loadMorePages) withObject:nil afterDelay:0.1f];
}


-(void)loadMorePages
{
    if ([loadMore canGetMoreRecordsForTableView:self.tblCategoryList andIsLastLoadSuccessful:self.isLastLoadSuccessful isMyFindTable:YES])
    {
        self.reloadingCategoryTable = NO;
        isLoadMore=YES;
        [self callTalksListAPI];
    }
    else
    {
        [self.pullToRefreshTableManager tableViewReloadFinished];
    }
}


#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    self.reloadingCategoryTable = YES;
    
    isLoadMore=NO;
    
    [self callTalksListAPI];
}


- (void)doneLoadingTableViewData
{
	self.reloadingCategoryTable = NO;
    
    [self.refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblCategoryList];
}


#pragma mark Call API Methods

- (void)callTalksListAPI
{    
    [self showActivityIndicatorInTableView:YES];
    
    [self.apiManager callTalksListAPIForCategory:self.categoryType forPage:[self getPageNumber]];
}


#pragma mark - Talks List API Manager Methods

-(void)successfullyReceivedServerResponse:(NSArray *)modelArray
{
    if (isLoadMore ==YES)
    {
        [self.serverResponseArray addObjectsFromArray:modelArray];
        
        [self.pullToRefreshTableManager tableViewReloadFinished];
    }
    else
    {
        [self showActivityIndicatorInTableView:NO];
        
        self.serverResponseArray = [[NSMutableArray alloc] initWithArray:modelArray];
        
        [self doneLoadingTableViewData];
    }
    
    self.reloadingCategoryTable=NO;
    
    isLoadMore = NO;
    
    [self checkLastRequestSuccess:modelArray];
    
    NSDictionary *sortedDict = [TalksModel sortResponseArrayByFilterApplied:0 responseArray:self.serverResponseArray];
    
    self.sectionsArray = [CommonFunctions getSortedArrayContainingNSDate:[sortedDict allKeys]];
    
    self.dataDict = sortedDict;
    
    [self.tblCategoryList reloadData];
    
    [self.pullToRefreshTableManager relocatePullToRefreshView];    
}


-(void)failToReceivedServerResponse:(NSString *)errorMessage
{
    NSLog(@"error : %@", errorMessage);
    if (isLoadMore ==YES)
    {
        [self.pullToRefreshTableManager tableViewReloadFinished];
        self.isLastLoadSuccessful = NO;
        isLoadMore = NO;
    }
    else
    {
        [self doneLoadingTableViewData];
        [self showActivityIndicatorInTableView:NO];
    }
}


#pragma mark - Show Activity Indicator

-(void)showActivityIndicatorInTableView:(BOOL)show
{
    if (isLoadMore || self.reloadingCategoryTable || ![[SharedManager sharedManager] isNetworkAvailable])
    {
        return;
    }
    
    if (show)
    {
        self.activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2-15, ([UIScreen mainScreen].bounds.size.height)/2 - 80, 32, 32)];
        [self.activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        [self.activityIndicatorView setAlpha:0.4f];
        [self.activityIndicatorView.layer setCornerRadius:5.0f];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.activityIndicator setBackgroundColor:[UIColor clearColor]];
        
        [self.activityIndicator startAnimating];
        self.activityIndicator.center = CGPointMake(16, 16);
        
        [self.activityIndicatorView addSubview:self.activityIndicator];
        [self.view addSubview:self.activityIndicatorView];
        
    }
    else
    {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        [self.activityIndicatorView removeFromSuperview];
    }
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
        pageNumber = [loadMore getNextPageNumberForTablePaggination:self.tblCategoryList];
    }
    return pageNumber;
}


#pragma mark - Talks Detail View Controller Delegate

-(void)successfullyDeletedTalk
{
    [self callTalksListAPI];
}

-(void)successfullyEditTalk
{
    [self callTalksListAPI];
}

-(void)addNewFindClicked
{
    if (self.delegate)
    {
        [self.delegate addMyFindButtonClicked];
    }
}


@end
