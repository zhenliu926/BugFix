//
//  RelatedPerksViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 1/30/13.
//
//

#import "RelatedPerksViewController.h"

@interface RelatedPerksViewController ()

@end

@implementation RelatedPerksViewController

@synthesize perkID = _perkID;

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
    if(OS_VERSION>=7)
    self.tblRelatedPerks.frame=CGRectMake(self.tblRelatedPerks.frame.origin.x,self.tblRelatedPerks.frame.origin.y+44,self.tblRelatedPerks.frame.size.width,self.tblRelatedPerks.frame.size.height);
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"] ;
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
    
    selectedBgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_perks_c.png"]];
    
    [[ProcessingView instance] showTintView];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    [params setValue:self.perkID forKey:@"post_id"];
    
    NSString *latitude = [[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.latitude] stringValue];
    NSString *longitude =[[NSNumber numberWithDouble:[CommonFunctions getUserCurrentLocation].coordinate.longitude] stringValue];
    
    NSMutableDictionary *locationDict  = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [locationDict setObject:latitude forKey:@"latitude"];
    [locationDict setObject:longitude forKey:@"longitude"];
    [params setObject:locationDict forKey:@"location"] ;
    [params setObject:@"1" forKey:@"page"] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
    [params setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"curr_date_time"];
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    //fetcher.delegate=self;
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,RELATED_PERKS] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] showTintViewWithUserInteractionEnabled];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Button Actions
#pragma mark -

- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] hideTintView];

    NSString *tempUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,RELATED_PERKS];
    if ([url isEqualToString:tempUrl]) {
        
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess)
        {
            [self parseResponseData:responseData];
        }else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:[responseData objectForKey:@"error"] != nil && [[responseData objectForKey:@"error"] isKindOfClass:[NSNull class]] ? @"The server encountered an error" : [responseData objectForKey:@"error"]];
        }
    }
}
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] hideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,RELATED_PERKS]])
    {
        
    }
}

#pragma mark -
#pragma mark Parse
#pragma mark -
- (void) parseResponseData:(NSDictionary *)responseData
{
    NSMutableArray *dataArray = [responseData objectForKey:@"data"];
    RelatedPerks = [[NSMutableArray alloc] init];
    for (id object in dataArray)
    {
        RelatedPerksModel *relatedperksObject = [[RelatedPerksModel alloc] init];
        [relatedperksObject setId:[object valueForKey:@"cat_id"]];
        [relatedperksObject setDiscount_price:[object valueForKey:@"discount_price"]];
        [relatedperksObject setDistance:[object valueForKey:@"distance"]];
        [relatedperksObject setHeadline:[object valueForKey:@"headline"]];
        [relatedperksObject setLikeCount:[[object valueForKey:@"likeCount"] intValue]];
        [relatedperksObject setMin_credits:[object valueForKey:@"min_credits"]];
        [relatedperksObject setOrig_price:[object valueForKey:@"orig_price"]];
        [relatedperksObject setPerk_id:[object valueForKey:@"perk_id"]];
        [relatedperksObject setShort_desc:[object valueForKey:@"short_desc"]];
        [relatedperksObject setThumb_url:[object objectForKey:@"thumb_url"]];
        [relatedperksObject setTitle:[object valueForKey:@"title"]];
        [RelatedPerks addObject:relatedperksObject];
    }
    
    [self.tblRelatedPerks reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    PerksModel *model = [[PerksModel alloc] init];
    
    RelatedPerksModel *relatedPerkModel = [RelatedPerks objectAtIndex:indexPath.row];
    
    model.postId = relatedPerkModel.perk_id;
    
    PerksProductDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PerksProductDetailViewController"];
    
    [controller setMenu:model];
    
    [controller setShouldDisableMerchantBanner:YES];
    
    [controller setType:1];
    controller.categoryType = self.categoryID;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RelatedPerks.count;
}

- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"RelatedPerksCell";
    CustomCell *cell= (CustomCell*)[self.tblRelatedPerks dequeueReusableCellWithIdentifier:cellIdentifier];
    
   
    if(cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RelatedPerksModel *menu=[RelatedPerks objectAtIndex:indexPath.row];
    UIImageView *managedImage = (UIImageView*)[cell viewWithTag:1];
    [[managedImage layer] setCornerRadius:5];
    managedImage.ClipsToBounds= YES;
    if ( ![menu.thumb_url isKindOfClass:[NSNull class]] && ![menu.thumb_url isEqualToString:@""] )
    {
        [managedImage setImageWithURL:[NSURL URLWithString:menu.thumb_url]];
    }
    else
    {
        [managedImage setImage:[UIImage imageNamed:@"list_thumbnail.png"]];
    }
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:2];
    [titleLbl setText:menu.title];
    
    UILabel *shortDiscription = (UILabel*)[cell viewWithTag:3];
    [shortDiscription setText:menu.short_desc];
    
    UILabel *cost = (UILabel*)[cell viewWithTag:4];
    [cost setText:[NSString stringWithFormat:@"$%@",menu.orig_price]];
    
    UILabel *like = (UILabel*)[cell viewWithTag:5];
    [like setText:[NSString stringWithFormat:@"%d", menu.likeCount]];
    
    UILabel *distance = (UILabel*)[cell viewWithTag:6];    
    if ( ![menu.distance isKindOfClass:[NSNull class]] && menu.distance!=nil )
    {
        [distance setText:[CommonFunctions getDistanceStringInCountryUnitForCell:[NSNumber numberWithInt:[menu.distance intValue]]]];
    }
    else
    {
        [distance setText:@"0km"];
    }
    UILabel *credits = (UILabel*)[cell viewWithTag:7];
    
    [credits setText:[NSString stringWithFormat:@"%@",menu.min_credits]];

    [credits setTextAlignment:NSTextAlignmentCenter];
    
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


- (void)viewDidUnload
{
    [self setTblRelatedPerks:nil];
    [super viewDidUnload];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
