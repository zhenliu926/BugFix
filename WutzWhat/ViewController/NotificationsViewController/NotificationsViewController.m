//
//  NotificationsViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/26/12.
//
//

#import "NotificationsViewController.h"
#import "IIViewDeckController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

@synthesize sectionsArray, rows, dataDict, notificationListArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {        
    }
    return self;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_pullToRefreshManager relocatePullToRefreshView];
}
- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    self.notificationListArray = [[NSMutableArray alloc] init];
    
    isTableReloading = NO;
    isLoadMore=NO;
    [self setupHeaderView];
    
    if ([CommonFunctions isRemoteNotificationClicked])
    {
        [self handleRemoteNotificationClickedEvent];
        
        [CommonFunctions setRemoteNotificationRead];
        [CommonFunctions setRemoteNotificationDictionaryToNil];
        
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    [self getNotificationList];
    
    [self setupTableViewRefresh];
    [self setUpLoadMoreView];
    loadMore = [[LoadMore alloc] init];
    selectedBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_c.png"] stretchableImageWithLeftCapWidth:320.0 topCapHeight:0.0]];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void)handleRemoteNotificationClickedEvent
{
    NSDictionary *notificationDic = [[NSDictionary alloc] initWithDictionary:[CommonFunctions getRemoteNotificationDictionary]];
    
    NotificationsModel *model = [[NotificationsModel alloc] init];
    
    model.notificationType = [notificationDic objectForKey:@"notification_type"];
    model.notificationTypeID = [notificationDic objectForKey:@"tap_data.Id"];
    
    if ([model.notificationType isEqualToString:@"promo_code"])
    {
        RedeemCreditViewController *redeem= [self.storyboard instantiateViewControllerWithIdentifier:@"RedeemCreditViewController"];
        
        redeem.promoCode = model.notificationTypeID;
        
        [self.navigationController pushViewController:redeem animated:YES];
    }
    else if ([model.notificationType isEqualToString:@"credit_update"])
    {
    
    }
    else if ([model.notificationType isEqualToString:@"featured_perk"])
    {
        PerksModel *perkModel = [[PerksModel alloc] init];
        perkModel.postId = model.notificationTypeID;
        
        PerksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksProductDetailViewController"];
        
        [controller setMenu:perkModel];
        
        [controller setType:1];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([model.notificationType isEqualToString:@"featured_wutzwhat"])
    {
        WutzWhatModel *wutzModel = [[WutzWhatModel alloc] init];
        wutzModel.postId = model.notificationTypeID;
        
        WutzWhatProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatProductDetailViewController"];
        
        [controller setMenu:wutzModel];
        [controller setType:1];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)setupHeaderView
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    UIImage *backButton = [UIImage imageNamed:@"top_menu.png"] ;
     UIImage *backButtonPressed = [UIImage imageNamed:@"top_menu_c.png"] ;
    UIImage *settingsButton = [UIImage imageNamed:@"top_setting.png"];
    UIImage *settingsButtonPressed = [UIImage imageNamed:@"top_setting_c.png"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
     UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIButton *settingsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, settingsButton.size.width, settingsButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [settingsBtn addTarget:self action:@selector(settingsBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setImage:backButton forState:UIControlStateNormal];
     [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    [settingsBtn setImage:settingsButton forState:UIControlStateNormal];
    [settingsBtn setImage:settingsButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    UIBarButtonItem *rightbtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    [[self navigationItem]setRightBarButtonItem:rightbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_notifications.png"]];
    [[self navigationItem]setTitleView:titleIV];
}

-(void)setupTableViewRefresh
{
    if (_refreshNotificationTableView == nil)
    {
        if(OS_VERSION>=7)
        {
            self.tblNotifications.frame=CGRectMake(0,44,self.tblNotifications.frame.size.height,self.tblNotifications.frame.size.width);
        }
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblNotifications.bounds.size.height, self.view.frame.size.width, self.tblNotifications.bounds.size.height)];
        view.delegate = self;
		[self.tblNotifications addSubview:view];
		_refreshNotificationTableView = view;
	}
    
    [_refreshNotificationTableView refreshLastUpdatedDate];
}

- (void)setUpLoadMoreView
{
    _reloads= -1;
    if (_pullToRefreshManager == nil)
    {
        _pullToRefreshManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tblNotifications withClient:self];
    }
    isLoadMore = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
    [self setTblNotifications:nil];
    [super viewDidUnload];
}

#pragma mark- Button Actions

- (void) backBtnTapped:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


-(void)settingsBtnTapped
{
    NotificationSettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationSettingsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notificationListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NotificationsCell";
    
    UITableViewCell *cell = (UITableViewCell*)[self.tblNotifications dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NotificationsModel *model = [self.notificationListArray objectAtIndex:indexPath.row];

    UIImageView *image = (UIImageView*)[cell viewWithTag:1];
    [[image layer]setCornerRadius:5.0f];
    [image setClipsToBounds:YES];
    
    
    if (![model.thumbnailUrl isEqualToString:@""] && ![model.thumbnailUrl isKindOfClass:[NSNull class]])
    {
        [image setImageWithURL:[NSURL URLWithString:model.thumbnailUrl]];
    }
    else if([model.notificationType isEqualToString:@"promo_code"])
    {
        [image setImage:[UIImage imageNamed:@"icon_promo.png"]];
    } else if([model.notificationType isEqualToString:@"credit_update"]) {
        [image setImage:[UIImage imageNamed:@"icon_credit.png"]];
    } else if ([model.notificationType isEqualToString:@"featured_wutzwhat"] || [model.notificationType isEqualToString:@"featured_perk"] ||  [model.notificationType isEqualToString:@"temp"])
            [image setImage:[UIImage imageNamed:@"icon_general.png"]];
    
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:2];
    titleLbl.highlightedTextColor=[UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];

    [titleLbl setText:model.title];
    
    UILabel *lblDateTime = (UILabel*)[cell viewWithTag:3];
    lblDateTime.highlightedTextColor=[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    [lblDateTime setText:model.dateTime];

    UIImageView *bgImage = (UIImageView*)[cell viewWithTag:4];
    
    bgImage.image = indexPath.row % 2 == 0 ? [UIImage imageNamed:@"list_clean_dark.png"]:[UIImage imageNamed:@"list_clean_light.png"];
    
    cell.selectedBackgroundView=selectedBgView;
    
    cell.backgroundColor=[UIColor clearColor];
    if ([model.notificationType isEqualToString:@"credit_update"]){
        [cell setUserInteractionEnabled:NO];
    }
    
    cell.selectedBackgroundView=selectedBgView;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    NotificationsModel *model = [self.notificationListArray objectAtIndex:indexPath.row];
    
    if ([model.notificationType isEqualToString:@"promo_code"])
    {
        RedeemCreditViewController *redeem= [self.storyboard instantiateViewControllerWithIdentifier:@"RedeemCreditViewController"];
        
        redeem.promoCode = model.notificationTypeID;
        
        [self.navigationController pushViewController:redeem animated:YES];
    }
    else if ([model.notificationType isEqualToString:@"credit_update"])
    {
        // do nothing.. :P...sure bro
    }
    else if ([model.notificationType isEqualToString:@"featured_perk"])
    {
        PerksModel *perkModel = [[PerksModel alloc] init];
        perkModel.postId = model.notificationTypeID;
        
        PerksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksProductDetailViewController"];

        [controller setMenu:perkModel];
        
        [controller setType:1];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([model.notificationType isEqualToString:@"featured_wutzwhat"])
    {
        WutzWhatModel *wutzModel = [[WutzWhatModel alloc] init];
        wutzModel.postId = model.notificationTypeID;
        
        WutzWhatProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatProductDetailViewController"];
        
        [controller setMenu:wutzModel];
        [controller setType:1];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}



#pragma mark- Get Notification List Methods

-(void)getNotificationList
{
    if (isLoadMore ==YES)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        
        [params setObject:[NSNumber numberWithInt:[loadMore getNextPageNumberForTablePaggination:self.tblNotifications]] forKey:@"page"];
        
        
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_NOTIFICATION_LIST]
                     andDelegate:self
                  andRequestType:@"POST"
                 andPostDataDict:params];
        [[ProcessingView instance] forceHideTintView];
        return;
    }
    else
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        
        [params setObject:@"1" forKey:@"page"];
        
        
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_NOTIFICATION_LIST]
                     andDelegate:self
                  andRequestType:@"POST"
                 andPostDataDict:params];
        
        [[ProcessingView instance] forceShowTintView];
    }
}


#pragma mark- DataFetcher Delegate Methods

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_NOTIFICATION_LIST]])
    {
        BOOL hasError = [[responseData objectForKey:@"result"] isEqualToString:@"error"];
        
        if (hasError)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:MSG_FAILED
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            isLastLoadSuccessful = NO;
        }
        else
        {   
            [self parseResponseData:[responseData objectForKey:@"data"]];
        }
    }
    if (isTableReloading==YES)
    {
        isLoadMore = NO;
        isTableReloading=NO;
        [self doneLoadingTableViewData];
    }
    
    if (isLoadMore ==YES)
    {
        isLoadMore = NO;
        isTableReloading=NO;
        
        [_pullToRefreshManager tableViewReloadFinished];
    }
}

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", BASE_URL, GET_NOTIFICATION_LIST]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:MSG_FAILED
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles: nil];
        [alert show];
        isLastLoadSuccessful = NO;
    }
    
    if (isTableReloading)
    {
        [self doneLoadingTableViewData];
    }
    
    if (isLoadMore ==YES)
    {
        isLoadMore = NO;
        [_pullToRefreshManager tableViewReloadFinished];
    }
}

#pragma mark- Response Parser Method

-(void)parseResponseData:(NSArray *)dataDictionary
{
    if (isTableReloading)
    {
        [notificationListArray removeAllObjects];
    }
    
    int responseArrayCount = 0;
    
    for (NSDictionary *notification in dataDictionary)
    {
        NotificationsModel *model = [[NotificationsModel alloc] init];
        model.notificationID = [[notification objectForKey:@"NotificationId"] integerValue];
        model.notificationType = [notification objectForKey:@"notification_type"];
        
        model.notificationTypeID = ([notification objectForKey:@"tap_data"] && ![[notification objectForKey:@"tap_data"] isKindOfClass:[NSNull class]]) ? [[notification objectForKey:@"tap_data"] objectForKey:@"Id"] : nil;
        
        model.title = [notification objectForKey:@"text"];
        
        model.thumbnailUrl = ([notification objectForKey:@"thumbnail_url"] && ![[notification objectForKey:@"thumbnail_url"] isKindOfClass:[NSNull class]]) ? [notification objectForKey:@"thumbnail_url"] : @"";
        
        model.dateTime = [self getDateStringFromTimeStamp:[notification objectForKey:@"time"]];
        
        [notificationListArray addObject:model];
        responseArrayCount += 1;
    }
    
    [CommonFunctions setAppBadgeNumber:0];

    isLastLoadSuccessful = responseArrayCount > 9;    
    
    NSLog(@"[notificationListArray count] : %d", [notificationListArray count]);
    
    [self.tblNotifications reloadData];
    [_pullToRefreshManager relocatePullToRefreshView];
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


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    isTableReloading = YES;
    isLoadMore = NO;
    
    [NSThread detachNewThreadSelector:@selector(getNotificationList) toTarget:self withObject:nil];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return isTableReloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}

- (void)doneLoadingTableViewData
{
    isTableReloading = NO;
    isLoadMore = NO;
    [_refreshNotificationTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblNotifications];
}
#pragma mark -
#pragma mark Scroll View Delegates
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshNotificationTableView egoRefreshScrollViewDidScroll:scrollView];
    [_pullToRefreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshNotificationTableView egoRefreshScrollViewDidEndDragging:scrollView];
    [_pullToRefreshManager tableViewReleased];
}

#pragma mark -
#pragma mark LoadMore
#pragma mark -
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    [self performSelector:@selector(loadMorePages) withObject:nil afterDelay:0.1f];
}

-(void)loadMorePages
{
    if ([loadMore canGetMoreRecordsForTableView:self.tblNotifications andIsLastLoadSuccessful:isLastLoadSuccessful isMyFindTable:NO])
    {
        isTableReloading = NO;
        
        isLoadMore=YES;
        
        [self getNotificationList];
    }
    else
    {
        [_pullToRefreshManager tableViewReloadFinished];
    }
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


