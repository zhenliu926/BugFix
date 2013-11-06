//
//  MenuViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/14/12.
//
//

#import "MenuViewController.h"
#import "MainMenu.h"
#import "ProfileViewController.h"
@implementation MenuViewController
{
}
@synthesize rows;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"Menu";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.viewDeckController.centerhiddenInteractivity=IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
}
- (void) viewWillDisappear:(BOOL)animated
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.45f];
    [self.navigationController.navigationBar setAlpha:1.0f];
    [UIView commitAnimations];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    
    
    if(OS_VERSION>=7)
        
    {
       // self.menuTableView.frame=CGRectMake(self.menuTableView.frame.origin.x,self.menuTableView.frame.origin.y+20,self.menuTableView.frame.size.width,self.menuTableView.frame.size.height);
        //self.menuTableView.backgroundColor=[UIColor blackColor];
        //self.view.backgroundColor=[UIColor clearColor];
    }
    
    [_menuTableView setShowsVerticalScrollIndicator:NO];
    
    [self setupRows];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived)
                                                 name:@"NotificationReceived"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(perkPurchased)
                                                 name:@"PerkPurchased"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     MainMenu *menu = [self.rows objectAtIndex:indexPath.row];
    UIView *viewrow ;
    UIImageView *selectedBgrow = [[UIImageView alloc] init];
    
    switch (indexPath.row)
    {
        case 5:
            viewrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 150)];
            viewrow.opaque = YES;
            viewrow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:menu.imageName]];
            selectedBgrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:menu.pressedImageName]];
            break;
        default:
            viewrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 44)];
            viewrow.opaque = YES;
            viewrow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:menu.imageName]];
            selectedBgrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:menu.pressedImageName]];
            break;
    }

    
    static NSString *cellIdentifier = @"MenuCell";

    UITableViewCell *cell = (UITableViewCell*)[self.menuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:2];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [cell setBackgroundView:viewrow];
    [cell setSelectedBackgroundView:selectedBgrow];
    UIImageView *bubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_3digit.png"]];
    bubble.frame = CGRectMake((cell.frame.size.width - bubble.frame.size.width) - 38, (cell.frame.size.height - bubble.frame.size.height) /2, bubble.frame.size.width, bubble.frame.size.height);
    switch (indexPath.row) {
        case 6:
            titleLbl.text=[appDelegate.facebookData objectForKey:@"username"];
            [titleLbl setFont:[UIFont fontWithName:@"Arial-Bold" size:16]];
            titleLbl.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            break;
        case 9:
            titleLbl.text=[CommonFunctions getUserSavedCity];
            titleLbl.text=[appDelegate.facebookData objectForKey:@"city"];
            [[NSUserDefaults standardUserDefaults] setObject:[appDelegate.facebookData objectForKey:@"city"] forKey:@"cityselected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [titleLbl setFont:[UIFont fontWithName:@"Arial-Bold" size:16]];
            titleLbl.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
            break;
        case 8:
            [cell addSubview:bubble];
            notificationCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bubble.frame.size.width, bubble.frame.size.height)];
            notificationCount.textAlignment = NSTextAlignmentCenter;
            notificationCount.backgroundColor = [UIColor clearColor];
            notificationCount.textColor = [UIColor colorFromHexString:@"f2f2f2"];
            notificationCount.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            notificationCount.text = @"";
            [bubble addSubview:notificationCount];
            break;
        default:
            titleLbl.text = @"";
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        return 150.0;
    }
    else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==[[NSUserDefaults standardUserDefaults] integerForKey:@"indexpathmenu"]) {
        [cell setSelected:YES];
    }else
    {
        [cell setSelected:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        [Utiltiy showInternetConnectionErrorAlert:nil];
        if (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9)
        {
            [tableView  deselectRowAtIndexPath:indexPath animated:YES];            
            return;
        }
    }
    
    BOOL isGuest = [CommonFunctions isGuestUser];
    
    if(isGuest)
    {
        if (indexPath.row == 4 ||  indexPath.row == 6 || indexPath.row == 7 ||indexPath.row == 8 ||indexPath.row == 3 || indexPath.row == 2)
        {
            [CommonFunctions showLoginAlertToGuestUser];
            [tableView  deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }
    

     if ( indexPath.row != 5)
    {
                
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"indexpathmenu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView reloadData];

        UIViewController *controller = [self getRightViewController:indexPath.row];
        
        [self.viewDeckController.centerController removeFromParentViewController];
        
        if (indexPath.row==9)
        {
            ((CityViewController*)controller).isFromMainMenu = YES;
            
            [self.viewDeckController setCenterController:controller];

        }
        else
        [self.viewDeckController setCenterController:controller];
        
        [_menuTableView setUserInteractionEnabled:NO];
        
        if (indexPath.row!=6 && indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2 && indexPath.row != 4 && indexPath.row != 3) {
         [[ProcessingView instance] showTintView];
        }
        
        [self.viewDeckController toggleLeftViewAnimated:YES];
        
        [self performSelector:@selector(enableUserInteraction) withObject:nil afterDelay:0.3];
    }
}

- (void) enableUserInteraction {
    [_menuTableView setUserInteractionEnabled:YES];
}

- (void)viewDidUnload {
    [self setMenuTableView:nil];
    [super viewDidUnload];
}

- (UIViewController *) getRightViewController:(int) row {
    
    if (row==0)
    {
        WutzWhatViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatViewController"];
        controller.accessibilityHint = @"1";
        return controller;
    }
    if (row==1) {
        WutzWhatViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WutzWhatViewController"];
        controller.accessibilityHint = @"3";
        return controller;
    }
    if (row==2) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"PerksViewController"];
    }
    if (row==7) {
        return  [self.storyboard instantiateViewControllerWithIdentifier:@"CreditViewController"];
    }
    if (row==8) {
        return  [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
    }
    if (row==6) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];

    }
    if (row==9)
    {
        return  [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    }
    if (row==4)
    {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"TalkViewController"];
    }
    
    if (row==3) {
        
       return [self.storyboard instantiateViewControllerWithIdentifier:@"FavouritesViewController"];
    }
    return nil;
}


#pragma mark - Prepare rows array through MainMenu.plist file

- (void) setupRows
{
    self.rows = [[NSMutableArray alloc] init];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MainMenu" withExtension:@"plist"];

    NSArray *rootArray = [[NSArray alloc] initWithContentsOfURL:url];
    
    for (NSDictionary *dict in rootArray)
    {
        MainMenu *menu  = [[MainMenu alloc] init];
        
        menu.title = (NSString*)[dict valueForKey:@"title"];
        if (![menu.title isEqualToString:@"City"] || ![menu.title isEqualToString:@"Profile"]) {
            menu.title=@"";
        }
        menu.imageName = (NSString*)[dict valueForKey:@"imageName"];
        menu.pressedImageName = (NSString*)[dict valueForKey:@"selectedImageName"];
        
        [tmp addObject:menu];
    }
    
    [self setRows:tmp];
}

-(void)refreshMenuTable
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
    
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    
    [self.menuTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - Notification Handling

-(void)notificationReceived
{
    if ([CommonFunctions isRemoteNotificationClicked])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
        
        [self tableView:self.menuTableView didSelectRowAtIndexPath:indexPath];
    }
}


- (void)refreshNotificationCount
{
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@",BASE_URL,GET_UNREAD_NOTIFICATIONS,[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
}

- (void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    if([[responseData objectForKey:@"message"] intValue] < 100)
        notificationCount.text = [responseData objectForKey:@"message"];
    else
        notificationCount.text = @"99+";
}

#pragma mark - Perk Purchased Handling

-(void)perkPurchased
{
    [CommonFunctions perkPurchasedSuccessfully];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        
    [self tableView:self.menuTableView didSelectRowAtIndexPath:indexPath];
}


@end
