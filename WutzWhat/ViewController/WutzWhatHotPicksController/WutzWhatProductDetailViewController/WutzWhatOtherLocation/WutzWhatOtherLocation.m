//
//  WutzWhatOtherLocation.m
//  WutzWhat
//
//  Created by Zeeshan on 1/21/13.
//
//

#import "WutzWhatOtherLocation.h"

@interface WutzWhatOtherLocation ()

@end

@implementation WutzWhatOtherLocation
@synthesize postid;
@synthesize page;
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
       
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    
    
    if(self.postTypeID == WUTZWHAT_ID_FOR_REVIEW)
    {
        
        UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_wutzwhat.png"]];
        [[self navigationItem]setTitleView:titleIV];
        
    }
    else if(self.postTypeID == PERK_ID_FOR_REVIEW)
    {
        
        UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks_2.png"]];
        [[self navigationItem]setTitleView:titleIV];
    }
    else if(self.postTypeID == HOTPICKS_ID_FOR_REVIEW)
    {
        
        UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_hotpicks.png"]];
        [[self navigationItem]setTitleView:titleIV];
    }

    
    
    
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
    }
    else
    {
        [[ProcessingView instance] showTintViewWithUserInteractionEnabled];
        [self calServiceWithURL:GET_WUTZWHAT_OTHER_LOCATIONS];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Webservice
#pragma mark -
- (void) calServiceWithURL:(NSString*)serviceUrl
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setValue:postid forKey:@"post_id"];
    [params setValue:page forKey:@"page"];
        
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
}
#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_OTHER_LOCATIONS]])
    {
        if ([CommonFunctions isValueExist:[responseData objectForKey:@"data"]])
        {
            NSMutableArray *dataArray = [responseData objectForKey:@"data"];
            array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dataArray) {
                WutzWhatModel *model = [[WutzWhatModel alloc] init];
                [model setLatitude:[[dic objectForKey:@"location"] valueForKey:@"latitude"]];
                [model setLongitude:[[dic objectForKey:@"location"] valueForKey:@"longitude"]];
                
                [model setTitle:[dic objectForKey:@"name"]];
                [model setPrice:[[dic valueForKey:@"phone1"] intValue]];
                [model setInfo:[dic valueForKey:@"email"]];
                
                
                [array addObject:model];
            }
            [self.tblLocation reloadData];
        }
    }
}
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_OTHER_LOCATIONS]]) {
        
    }
}
#pragma mark -
#pragma mark Button Actions
#pragma mark -
- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table View Delegates
#pragma mark -


- (UIView *)tableView : (UITableView *)tableView viewForHeaderInSection : (NSInteger) section {
    
    UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other_cell.png"]];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 17, 180, 18)];
    title.backgroundColor = [UIColor clearColor];
    title.text = [NSString stringWithFormat:@"Other Location %d",section+1];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    title.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    title.layer.shadowColor = [[UIColor whiteColor] CGColor];
    title.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    [imgVew addSubview:title];
    
    return imgVew;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"";
    UITableViewCell *cell= (UITableViewCell*)[self.tblLocation dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *title;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        if (indexPath.row ==0) {
            UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other_cell.png"]];
            [imgVew setFrame:CGRectMake(0, 0, tableView.frame.size.width, 42)];
            title = [[UILabel alloc] initWithFrame:CGRectMake(33, 13, 250, 18)];
            title.backgroundColor = [UIColor clearColor];
            title.text =[NSString stringWithFormat:@"%d", [(WutzWhatModel*)[array objectAtIndex:indexPath.section] price]]  ;
            
            [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            title.textColor = [UIColor darkGrayColor];
            title.layer.shadowColor = [[UIColor whiteColor] CGColor];
            title.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            [imgVew addSubview:title];
            
            UIImageView *icon =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"otherlocation_icon_phone.png"]];
            icon.frame= CGRectMake(10, icon.frame.size.height - 9, 20, 20);
            [imgVew addSubview:icon];
            UIImageView *iconarrow =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_arrow.png"]];
            iconarrow.frame= CGRectMake(290, 8, 25, 25);
            [imgVew addSubview:iconarrow];
            
            [cell addSubview:imgVew];
        }
        if (indexPath.row ==1) {
            UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other_cell.png"]];
            [imgVew setFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
            
            title = [[UILabel alloc] initWithFrame:CGRectMake(33, 11, 240, 32)];
            title.backgroundColor = [UIColor clearColor];
            title.text = [(WutzWhatModel*)[array objectAtIndex:indexPath.section] title];
            title.lineBreakMode = NSLineBreakByWordWrapping;
            title.numberOfLines = 0;
            [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            title.textColor = [UIColor darkGrayColor];
            title.layer.shadowColor = [[UIColor whiteColor] CGColor];
            title.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            [imgVew addSubview:title];
            UIImageView *icon =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"otherlocation_icon_address.png"]];
            icon.frame= CGRectMake(10, icon.frame.size.height - 9, 20, 20);
            [imgVew addSubview:icon];
            UIImageView *iconarrow =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_arrow.png"]];
            iconarrow.frame= CGRectMake(290, 12, 25, 25);
            [imgVew addSubview:iconarrow];
            [cell addSubview:imgVew];
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other_bottom.png"]];
    return imgVew;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == array.count-1)
    {
        return 130.0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        NSLog(@"price : %d", [(WutzWhatModel*)[array objectAtIndex:indexPath.section]  price]);
        UIDevice *device = [UIDevice currentDevice];
        if ([[device model] isEqualToString:@"iPhone"] ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%d",[(WutzWhatModel*)[array objectAtIndex:indexPath.section]  price]]]];
        } else {
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Failed" message:MSG_CALL_FAILED delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
            
        }
    }
    if (indexPath.row ==1)
    {
        MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        
        NSArray *modelArray = [[NSArray alloc] initWithObjects:[array objectAtIndex:indexPath.section], nil];
        
        controller.modelArray = modelArray;
        controller.isSingleMapView = YES;
        [controller setPostTypeID:self.postTypeID];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 42.0;
    }
    if (indexPath.row ==1) {
        return 50.0;
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
