//
//  PerksListViewController.m
//  perks
//
//  Created by Rafay on 12/11/12.
//
//

#import "PerksListViewController.h"

@implementation PerksListViewController

@synthesize dataDict = _dataDict;
@synthesize sectionsArray = _sectionsArray;
@synthesize pullToRefreshTableManager = _pullToRefreshTableManager;
@synthesize refreshTableHeaderView = _refreshTableHeaderView;
@synthesize categoryType = _categoryType;
@synthesize delegate = _delegate;
@synthesize serverResponseArray = _serverResponseArray;
@synthesize filterBy = _filterBy;
@synthesize savedFilter = _savedFilter;
@synthesize activityIndicator = _activityIndicator;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize sectionHeaderIconName = _sectionHeaderIconName;
@synthesize isLastLoadSuccessful = _isLastLoadSuccessful;
@synthesize viewingAsFavourite = _viewingAsFavourite;
@synthesize rectSGMConceirge = _rectSGMConceirge;
@synthesize segmentSelectedIndex = _segmentSelectedIndex;
@synthesize apiManager = _apiManager;

#pragma mark View Controller Life Cycle

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
    
    if(OS_VERSION>=7)
    [self.delegate hideNavigationBar:NO];
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
    
    self.apiManager = [[PerksListAPIManager alloc] init];
    self.apiManager.delegate = self;
    
    
    self.serverResponseArray = [[NSMutableArray alloc] init];
    self.dataDict = [[NSDictionary alloc] init];
    self.sectionsArray = [[NSArray alloc] init];
    self.searchString = @"";
    self.savedFilter = nil;
    self.segmentSelectedIndex = 0;
    
//    if(OS_VERSION>=7)
//    {
//        self.view.backgroundColor=[UIColor clearColor];
//        
//        UIView *addStatusBar = [[UIView alloc] init];
//        addStatusBar.frame = CGRectMake(0, 0, 320, 20);
//        addStatusBar.backgroundColor = [UIColor blackColor]; //change this to match your navigation bar
//        [self.view addSubview:addStatusBar];
        
//    }
    
    if (self.refreshTableHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, (0.0f - self.tblCategoryList.bounds.size.height), self.view.frame.size.width, self.tblCategoryList.bounds.size.height)];
        
        view.delegate = self;
        
		[self.tblCategoryList addSubview:view];
		self.refreshTableHeaderView = view;
	}
    
    [self.refreshTableHeaderView refreshLastUpdatedDate];
    
    if (self.pullToRefreshTableManager == nil)
    {
        self.pullToRefreshTableManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tblCategoryList withClient:self];
    }
    
    self.reloadingCategoryTable = NO;
    
    isLoadMore = NO;
    
    if (_pullToRefreshTableManager == nil)
    {
        _pullToRefreshTableManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tblCategoryList withClient:self];
    }
    
    self.sectionHeaderIconName = @"icon_list_wutzwhat.png";
    
    [self setupTableHeightForiPhone5];
    [self setupConceirgeBar];
    
    [self callPerksListAPI];
    
    selectedBgView=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_c.png"] stretchableImageWithLeftCapWidth:320.0 topCapHeight:1.0]];
    loadMore = [[LoadMore alloc] init];
    [self hideTableSearchBar];
    
    self.filterBy = [self getFilterByValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.savedFilter.latitude longitude:self.savedFilter.longitude];
    [Flurry setLatitude:location.coordinate.latitude
              longitude:location.coordinate.longitude
     horizontalAccuracy:location.horizontalAccuracy
       verticalAccuracy:location.verticalAccuracy];
    [NSString stringWithFormat:@"%f",  self.savedFilter.latitude];
    
    [Flurry setUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
   // list_view -- latitude,longitude,access_token,base_city
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


-(void)setupConceirgeBar
{
    if (self.viewingAsFavourite)
    {
        [self.sgmConceirge setHidden:YES];
        return;
    }
    if (self.categoryType == 6)
    {        
        if (IS_IPHONE_5)
        {
            if(OS_VERSION>=7){
                self.sgmConceirge.frame= CGRectMake(0, 460, self.sgmConceirge.frame.size.width+1, 44);
                
            }
            else
                self.sgmConceirge.frame= CGRectMake(0, 417, self.sgmConceirge.frame.size.width, self.sgmConceirge.frame.size.height);
        }
        
        [self.sgmConceirge setHidden:NO];
        
        
        self.sgmConceirge.selectedSegmentIndex = 0;
        
        if(OS_VERSION<7){
            self.sgmConceirge.segmentedControlStyle=UISegmentedControlSegmentCenter;
            
        }
        
        
        
        
        [self.sgmConceirge setImage:[UIImage imageNamed:@"cat_ride.png"] forSegmentAtIndex:1];
        [self.sgmConceirge setImage:[UIImage imageNamed:@"cat_hotel_c.png"] forSegmentAtIndex:0];
        self.rectSGMConceirge = self.sgmConceirge.frame;
        [self.sgmConceirge addTarget:self action:@selector(sgmConceirge_Pressed:) forControlEvents:UIControlEventValueChanged];
        
        self.sgmConceirge.layer.masksToBounds = NO;
        self.sgmConceirge.layer.shadowOffset = CGSizeMake(0, -0.6);
        self.sgmConceirge.layer.shadowOpacity = 0.4;
        self.sgmConceirge.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.sgmConceirge.bounds].CGPath;
    }
    else
    {
        [self.sgmConceirge setHidden:YES];
    }
}

-(void)sgmConceirge_Pressed:(id)sender
{
    self.segmentSelectedIndex = self.sgmConceirge.selectedSegmentIndex;
    
    if(self.sgmConceirge.selectedSegmentIndex==0)
    {
        [self.sgmConceirge setImage:[UIImage imageNamed:@"cat_ride.png"] forSegmentAtIndex:1];
        [self.sgmConceirge setImage:[UIImage imageNamed:@"cat_hotel_c.png"] forSegmentAtIndex:0];
    }
    else if (self.sgmConceirge.selectedSegmentIndex==1)
        
    {
        [self.sgmConceirge setImage:[UIImage imageNamed:@"cat_ride_c.png"] forSegmentAtIndex:1];
        [self.sgmConceirge setImage:[UIImage imageNamed:@"cat_hotel.png"] forSegmentAtIndex:0];
    }
    [self callPerksListAPI];
}



#pragma mark Table View Delegates


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionsArray count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionNameKey =[self.sectionsArray objectAtIndex:section];
    
    NSMutableArray *dataArray = [self.dataDict objectForKey:sectionNameKey];
    
    return dataArray.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *sectionBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_sectionbar.png"]];
    UIImageView *sectionHeaderIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.sectionHeaderIconName]];
    
    if([self.sectionHeaderIconName isEqualToString:@"icon_list_wutzwhat.png"])
    {
        sectionHeaderIcon.frame= CGRectMake(10, 5, 12, 11);
    }
    else if ([self.sectionHeaderIconName isEqualToString: @"icon_list_map.png"])
    {
        sectionHeaderIcon.frame= CGRectMake(10, 5, 7, 13);
    }
    else if ([self.sectionHeaderIconName isEqualToString:@"icon_list_event.png"])
    {
        sectionHeaderIcon.frame= CGRectMake(10, 5, 11, 13);
    }
    
    NSString *headerTitleString;
    
    if (self.filterBy == 1)
    {
        headerTitleString = [CommonFunctions getDateStringInFormat:LIST_CELL_HEADER_DATE_FORMATE date:[self.sectionsArray objectAtIndex:section]];
    }
    else if (self.filterBy == 2)
    {
        headerTitleString = [CommonFunctions getDistanceCellHeaderString:[self.sectionsArray objectAtIndex:section]];
    }
    else
    {
        headerTitleString = [CommonFunctions getDateStringInFormat:LIST_CELL_HEADER_DATE_FORMATE date:[self.sectionsArray objectAtIndex:section]];
    }
    
    UILabel *labelForHeaderView =[[UILabel alloc] initWithFrame:CGRectMake(25, 3, 180, 16)];
    labelForHeaderView.backgroundColor = [UIColor clearColor];
    labelForHeaderView.textColor = [UIColor darkGrayColor];
    labelForHeaderView.text = @"";
    [labelForHeaderView setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 13.0]];
    labelForHeaderView.text = headerTitleString;
    
    [sectionBgView addSubview:sectionHeaderIcon];
    
    [sectionBgView addSubview:labelForHeaderView];
    
    return sectionBgView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionsArray objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblCategoryList deselectRowAtIndexPath:indexPath animated:YES];
    
    PerksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksProductDetailViewController"];
    
    controller.menu = [[self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    controller.categoryType = self.categoryType;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PerksCategoryCell";
    UITableViewCell *cell;
    
    cell= (UITableViewCell*)[self.tblCategoryList dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PerksModel *model= [[self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
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
    
    [managedImage setImage:[self addVideoBanner:managedImage.image andHasVideo:model.hasVideo]];
    
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:2];
    [titleLbl setText:model.title];
    
    
    UILabel *shortDiscription = (UILabel*)[cell viewWithTag:3];
    [shortDiscription setText:model.shortDescription];
    
    UILabel *cost = (UILabel*)[cell viewWithTag:4];
    [cost setText:[NSString stringWithFormat:@"$%.02f", model.originalPrice]];
    
    
    UILabel *like = (UILabel*)[cell viewWithTag:5];
    [like setText:[NSString stringWithFormat:@"%d", model.likeCount]];
    
    
    UILabel *distance = (UILabel*)[cell viewWithTag:6];
    [distance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:model.distance]];
    
    UILabel *credits = (UILabel*)[cell viewWithTag:7];
    
    [credits setText:[NSString stringWithFormat:@"%d", model.minCredits]];
    
    UIImageView *isFavorite = (UIImageView*)[cell viewWithTag:8];
    
    if (model.isFavourited)
    {
        [isFavorite setImage:[UIImage imageNamed:@"list_favorite.png"]];
    }
    else
    {
        [isFavorite setImage:[UIImage imageNamed:@"list_favorite_white.png"]];
    }
    
    UIImageView *islikeit = (UIImageView*)[cell viewWithTag:10];
    
    if (model.isLiked)
    {
        [islikeit setImage:[UIImage imageNamed:@"icon_loveit_c.png"]];
    }
    else
    {
        [islikeit setImage:[UIImage imageNamed:@"icon_loveit.png"]];
    }
        
    if (indexPath.row%2==0)
    {
        UIImageView* imgDark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_perks_dark.png"]];
        cell.backgroundView = imgDark;
        
    }
    else
    {
        UIImageView* imgLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_perks_light.png"]];
        cell.backgroundView = imgLight;
        
    }
    
    [cell setSelectedBackgroundView:selectedBgView];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isTableEditModeEnabled)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *modelArray = [self.dataDict objectForKey:[self.sectionsArray objectAtIndex:indexPath.section]];
    
    PerksModel *model = [modelArray objectAtIndex:indexPath.row];
    
    [self deleteFavourite:model.postId];
}

- (UIImage *)addVideoBanner:(UIImage *)thumb andHasVideo:(BOOL)hasVideo
{
    UIImage *videoBanner = hasVideo ? [UIImage imageNamed:@"videoicon@2x.png"] : nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(thumb.size.width, thumb.size.height-1));
    
    [thumb drawAtPoint:CGPointMake(0, -1)];
    if(hasVideo)
        [videoBanner drawAtPoint:CGPointZero];
    
    thumb = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumb;
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
            [UIView animateWithDuration:0.5f animations:^(){
                [scrollView setContentOffset:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height)];
                [UIView animateWithDuration:0.1 animations:^
                 {
                     scrollView.contentInset = UIEdgeInsetsZero;
                 }];
            }];
    }
}

-(void)hideTableSearchBar
{
    [self.delegate hideNavigationBar:NO];
    
    if (self.viewingAsFavourite)
    {
        self.tblCategoryList.tableHeaderView = nil;
        self.tblCategoryList.frame = CGRectMake(0, 0, self.tblCategoryList.frame.size.width, self.tblCategoryList.frame.size.height);
    }
    else
    {
        [self setTableContentOffSet:self.tblCategoryList];
    }
}


-(void)setTableContentOffSet:(UITableView *)tableView
{
    if ([self.searchString isEqualToString:@""] && self.savedFilter == nil)
    {
        tableView.contentOffset = CGPointMake(0, 44);
    }
    else
    {
        tableView.contentOffset = CGPointMake(0, 0);
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
    if ([loadMore canGetMoreRecordsForTableView:self.tblCategoryList andIsLastLoadSuccessful:self.isLastLoadSuccessful isMyFindTable:NO])
    {
        self.reloadingCategoryTable = NO;
        isLoadMore=YES;
        [self callPerksListAPI];
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
    
    self.savedFilter = nil;
    self.searchString = @"";
    self.searchBar.text = self.searchString;    
    
    isLoadMore=NO;
    
    [self callPerksListAPI];
}


- (void)doneLoadingTableViewData
{
	self.reloadingCategoryTable = NO;
    
    [self.refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblCategoryList];
}


#pragma mark SearchBarDelegates

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    PerkFilterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerkFilterViewController"];
    
    controller.delegate = self;
    controller.savedFilter = self.savedFilter;
    controller.categoryType = self.categoryType;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)customSearchBar
{
    customSearchBar.text = @"";
    
    [self updateSearchString:customSearchBar.text];
    
    [self callPerksListAPI];
    
    return YES;
}

- (void)updateSearchString:(NSString*)aSearchString
{
    self.searchString = aSearchString;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchString = searchBar.text;
    
    NSDictionary *search_analytics =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.searchString , @"search_term", // Capture author info
     [NSString stringWithFormat:@"%i",self.categoryType], @"search_category",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],@"access_token",// Capture user status
     nil];
    
    [Flurry logEvent:[NSString stringWithFormat:@"%i%@",self.categoryType, @"_search"] withParameters:search_analytics];
    
    [self callPerksListAPI];
    
   
    
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar
{
    [self updateSearchString:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateSearchString:searchBar.text];
}


#pragma mark - Filter View Controller Delegate

-(void)clearFilterSettings
{
    self.savedFilter = nil;
    self.searchString = @"";
    self.searchBar.text = @"";
    
    [self hideTableSearchBar];
    
    [self callPerksListAPI];
}


#pragma mark Call API Methods

-(void)filterListUsingFilterSetting:(FilterModel *)filterModel
{
    [self showActivityIndicatorInTableView:YES];
    
    self.apiManager.forFavourite = self.viewingAsFavourite;
    self.apiManager.subCategoryID = !self.segmentSelectedIndex;
    self.apiManager.categoryID = self.categoryType;
    
    self.filterBy = filterModel.filterBy;
    self.savedFilter = filterModel;
    
    [self setSectionHeaderImageName];
    
    [self.apiManager callPerksListAPIForSearchString:self.searchString filterBy:filterModel.filterBy maxPrice:filterModel.priceMax minPrice:filterModel.priceMin startDate:filterModel.startDate endDate:filterModel.endDate forPage:1 newLatitude:[NSString stringWithFormat:@"%f", filterModel.latitude] newLongitude:[NSString stringWithFormat:@"%f", filterModel.longitude]];
}


- (void)callPerksListAPI
{
    self.filterBy = [self getFilterByValue];
    
    [self showActivityIndicatorInTableView:NO];
    [self showActivityIndicatorInTableView:YES];
    
    [self setSectionHeaderImageName];
    
    self.apiManager.forFavourite = self.viewingAsFavourite;
    self.apiManager.subCategoryID = !self.segmentSelectedIndex;
    self.apiManager.categoryID = self.categoryType;
    
    [self.apiManager callPerksListAPIForSearchString:self.searchString filterBy:self.savedFilter.filterBy maxPrice:self.savedFilter.priceMax minPrice:self.savedFilter.priceMin startDate:self.savedFilter.startDate endDate:self.savedFilter.endDate forPage:[self getPageNumber] newLatitude:[NSString stringWithFormat:@"%f", self.savedFilter.latitude] newLongitude:[NSString stringWithFormat:@"%f", self.savedFilter.longitude]];
}


#pragma mark - Perks API Manager Methods

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
        
        if(self.searchString.length != 0 && modelArray.count == 0)
        {
            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_SEARCH_ITEM_NOT_FOUND];
        }
        else
        {
            self.serverResponseArray = [[NSMutableArray alloc] initWithArray:modelArray];
        }
        
        [self doneLoadingTableViewData];
    }
    
    self.reloadingCategoryTable=NO;
    
    isLoadMore = NO;
    
    [self checkLastRequestSuccess:modelArray];
    
    NSDictionary *sortedDict = [PerksModel sortResponseArrayByFilterApplied:self.filterBy responseArray:self.serverResponseArray];
    
    if (self.filterBy == 1)
    {
        self.sectionsArray = [CommonFunctions getSortedArrayContainingNSDate:[sortedDict allKeys]];
    }
    else if (self.filterBy == 2)
    {
        self.sectionsArray = [CommonFunctions getSortedArrayContainingNSNumber:[sortedDict allKeys]];
    }
    else
    {
        self.sectionsArray = [sortedDict allKeys];
    }
    
    self.dataDict = sortedDict;
    
    [self.searchBar resignFirstResponder];    
    [self.tblCategoryList reloadData];
    
    [self.pullToRefreshTableManager relocatePullToRefreshView];
}


-(void)successfullyDeletedFavorite
{
    [self showActivityIndicatorInTableView:NO];
    [self callPerksListAPI];
}


-(void)failToReceivedServerResponse:(NSString *)errorMessage
{
    NSLog(@"error : %@", errorMessage);
    if (isLoadMore)
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
    if(self.searchString.length != 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_SEARCH_ITEM_NOT_FOUND];
    }
}


-(void)failToDeleteFavorite:(NSString *)errorMessage
{
    NSLog(@"error : %@", errorMessage);
    [self showActivityIndicatorInTableView:NO];
}


#pragma mark - Enable Edit Mode for Table View

-(void)enableEditModeForTableView
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
        return;
    
    self.isTableEditModeEnabled = ! self.isTableEditModeEnabled;
    
    [self.tblCategoryList setEditing:self.isTableEditModeEnabled animated:YES];
}

-(void)deleteFavourite:(NSString *)postID
{
    [self showActivityIndicatorInTableView:YES];
    
    [self.apiManager callDeleteFavoriteByID:postID];
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


#pragma mark - Set Section Header View

-(void)setSectionHeaderImageName
{
    self.sectionHeaderIconName = self.filterBy == 1 ? @"icon_list_wutzwhat.png" : self.filterBy == 2 ? @"icon_list_map.png" : @"icon_list_event.png";
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

#pragma mark - Get Filterby

-(int)getFilterByValue
{
    
//    //    //temp
//    if(_viewingAsFavourite)
//        return 1;
    
    if (self.savedFilter)
    {
        return self.savedFilter.filterBy;
    }
    else
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultSorting"] + 1;
    }
}

#pragma mark - PerksProductDetailViewDelegate Method

-(void)searchListWithTagString:(NSString *)tagString
{
    self.searchString = tagString;
    self.searchBar.text = self.searchString;
    [self hideTableSearchBar];
    
    [self callPerksListAPI];
}

@end
