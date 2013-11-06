//
//  CityViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/15/12.
//
//

#import "CityViewController.h"
#import "Utiltiy.h"
#import "DataFetcher.h"
#import "IIViewDeckController.h"


@interface CityViewController ()

@end

@implementation CityViewController

@synthesize isFromMainMenu, cityTableView = _cityTableView;
@synthesize rows = _rows;
@synthesize cellBgIV,lastSavedIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    _cityTableView.alpha = 0;
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    UIImage *backButton;
    UIImage *backButtonPressed;
    
    backButton = [UIImage imageNamed:self.isFromMainMenu ?  @"top_menu.png" : @"top_back.png"];
    backButtonPressed = [UIImage imageNamed:self.isFromMainMenu ? @"top_menu_c.png" : @"top_back_c.png"];
    
    [self.customNavBarView setHidden:! self.isFromMainMenu];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_cityselection.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    _cityTableView.showsHorizontalScrollIndicator = NO;
    _cityTableView.showsVerticalScrollIndicator = NO;
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_CITIES_URL] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
    
    [[ProcessingView instance] forceShowTintView];
    
    
    _rows=[[NSMutableArray alloc] init];
    self.cityTableView.layer.cornerRadius = 3;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void) backBtnTapped:(id)sender
{
    if (isFromMainMenu)
    {        
        MenuViewController *controller = (MenuViewController *)self.viewDeckController.leftController;
        [controller refreshMenuTable];
        
        [self.viewDeckController toggleLeftViewAnimated:YES];        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setCityTableView:nil];
    [self setCustomNavBarView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rows.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"CityCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
     
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [_rows objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment= NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor colorFromHexString:@"4B4B4B"];
        if(indexPath.row == [[NSUserDefaults standardUserDefaults] integerForKey:@"indexpath"])
        {
            [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    UIImageView *bgIV =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_1_c.png"]];
    
    if(indexPath.row != 0 && indexPath.row != _rows.count - 1)
        bgIV.image = [UIImage imageNamed:@"select_2_c.png"];
    if(indexPath.row == _rows.count - 1)
         bgIV.image = [UIImage imageNamed:@"select_3_c.png"];
    
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, bgIV.frame.size.height * (indexPath.row + 1) + 10);
    
    bgIV.clipsToBounds=YES;
    
    cell.selectedBackgroundView=bgIV;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setLastSavedIndexPath:indexPath];

    [[NSUserDefaults standardUserDefaults] setInteger:lastSavedIndexPath.row forKey:@"indexpath"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[_rows objectAtIndex:lastSavedIndexPath.row]] forKey:@"cityselected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *distanceUnit = @"KM";
    
    if(![[_rows objectAtIndex:lastSavedIndexPath.row] isEqualToString:@"Toronto"])
    {
        [[LocationManagerHelper staticLocationManagerObject] setUserCurrentLocation: [[CLLocation alloc] initWithLatitude:NEW_YARK_LATITUDE longitude:NEW_YARK_LONGITUDE]];
        distanceUnit = @"MILES";
    }
    
    NSString *Name=[appDelegate.facebookData objectForKey:@"username"];
    NSString *ProfilePic=[appDelegate.facebookData objectForKey:@"profilePicture"];
    NSString *Email=[appDelegate.facebookData  objectForKey:@"email"];
    
    if (ProfilePic==nil)
    {
        ProfilePic=@"";
    }
    if (Email==nil)
    {
        Email=@"";
    }
    if (Name==nil)
    {
        Name=@"";
    }
    
    
    appDelegate.facebookData=@{@"id" : @"",
    @"city":[_rows objectAtIndex:lastSavedIndexPath.row],
    @"profilePicture":ProfilePic,
    @"username":Name,
    @"email":Email,
    @"distance_unit":distanceUnit
    };
    
    if(([CommonFunctions isGuestUser]))
    {
        MenuViewController *controller = (MenuViewController *)self.viewDeckController.leftController;
        [controller refreshMenuTable];
        
        [self.viewDeckController toggleLeftViewAnimated:YES];
        return;

    }
    
    if (isFromMainMenu)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        [params setValue:[_rows objectAtIndex:lastSavedIndexPath.row] forKey:@"baseCity"];
        
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_PROFILE_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark -
#pragma mark DataFetcher Delegates
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"indexpath"])
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"indexpath"];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_PROFILE_URL]])
    {
        NSLog(@"city changed or not. ? === %@", responseData);
        
        MenuViewController *controller = (MenuViewController *)self.viewDeckController.leftController;
        [controller refreshMenuTable];
        
        [self.viewDeckController toggleLeftViewAnimated:YES];
        return;
    }
    NSMutableArray *cities = [responseData valueForKey:@"data"];
    [self setRows:cities];
    [_cityTableView reloadData];
    _cityTableView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^(){_cityTableView.alpha = 1.0f;}];
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    NSLog(@"response=%@",responseData);
}



- (IBAction)btnMenuClicked:(id)sender
{
    MenuViewController *controller = (MenuViewController *)self.viewDeckController.leftController;
    [controller refreshMenuTable];
    
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
