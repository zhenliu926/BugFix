//
//  FAQViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 4/24/13.
//
//

#import "FAQViewController.h"

@interface FAQViewController ()

@end

@implementation FAQViewController
@synthesize tblFaq=_tblFaq;
@synthesize sectionArray=_sectionArray;
@synthesize dataDict=_dataDict;
@synthesize rows=_rows;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        selectedButtonIndex = -1;
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController Lifecycle
#pragma mark -


- (void)viewDidLoad {
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    [self setUpHeaderView];
    
    if(OS_VERSION>=7)
        
    {
        self.tblFaq.frame=CGRectMake(self.tblFaq.frame.origin.x,self.tblFaq.frame.origin.y+46,self.tblFaq.frame.size.width,self.tblFaq.frame.size.height);
    }

    [self.tblFaq setDelegate:self];
    [self.tblFaq setDataSource:self];

    [self.tblFaq setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setupRows];
    self.tblFaq.bounces = self.tblFaq.bouncesZoom = false;
}

- (void)viewDidUnload {
    [self setTblFaq:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Navigation Bar
#pragma mark -
-(void)setUpHeaderView
{
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
    
    UIImageView *titleIV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_profile.png"]];
    [[self navigationItem]setTitleView:titleIV1];
}
#pragma mark -
#pragma mark Button Actions
#pragma mark -
- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableview Delegates
#pragma mark -


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FAQCell";
    
    UITableViewCell *cell = (UITableViewCell*)[self.tblFaq dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    FAQModel *faq = [self.sectionArray objectAtIndex:indexPath.section];
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:1];
    [titleLbl setNumberOfLines:0];
    titleLbl.textColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.shadowColor=[UIColor whiteColor];
    titleLbl.shadowOffset=CGSizeMake(0, 1);
    
    NSString *myNewLineStr = @"\n";
    
    titleLbl.text = [faq.answer stringByReplacingOccurrencesOfString:@"\\n" withString:myNewLineStr];

    NSString* text = titleLbl.text;
    CGSize  size = [text sizeWithFont:titleLbl.font constrainedToSize:CGSizeMake(titleLbl.frame.size.width, 200000.f) lineBreakMode:NSLineBreakByWordWrapping];
    titleLbl.frame= CGRectMake(titleLbl.frame.origin.x, titleLbl.frame.origin.y, titleLbl.frame.size.width, size.height);
    
    titleLbl.backgroundColor = [UIColor clearColor];
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger manipulatedNoOfRows = 0;
    
    NSInteger noOfRowsInsection = 1;
    if (selectedButtonIndex == -1)
    {
        manipulatedNoOfRows = 0;
    }
    else if (selectedButtonIndex == section)
    {
        
        manipulatedNoOfRows = noOfRowsInsection;
    }
    
    return manipulatedNoOfRows;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) return nil;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:section];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn setBackgroundColor:self.view.backgroundColor];
    
    UIImageView *line= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    line.frame = CGRectMake(0, 0, 320, 2);
    [btn addSubview:line];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0f, 280, 30)];
    title.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    title.textColor = [UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1];
    title.shadowColor=[UIColor whiteColor];
    title.shadowOffset=CGSizeMake(0, 1);
    title.backgroundColor = [UIColor clearColor];
    title.text = [(FAQModel*)[self.sectionArray objectAtIndex:section] question];
    title.numberOfLines=0;
    
    NSString* text = [(FAQModel*)[self.sectionArray objectAtIndex:section] question]; // Get this from the some object using indexPath
    
    CGSize  size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:CGSizeMake(280, 200000.f) lineBreakMode:NSLineBreakByWordWrapping];
    title.frame= CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, size.height);
    
    [btn addSubview:title];
    
    UIImageView *btnAccessory=[[UIImageView alloc] initWithFrame:CGRectMake(290.0, ([self tableView:tableView heightForHeaderInSection:section] - 20) /2, 20, 20)];
    [btnAccessory setImage:[UIImage imageNamed:@"btn_right.png"]];
    [btn addSubview:btnAccessory];
    
    if (selectedButtonIndex == section)
    {
        [btn addTarget:self action:@selector(viewLessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.18];
        btnAccessory.layer.transform = CATransform3DMakeRotation((M_PI_2/180) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
        return btn;
    }
    else
    {
        [btn addTarget:self action:@selector(viewMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.18];
        btnAccessory.layer.transform = CATransform3DMakeRotation((0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
        return btn;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) return 0;
    
    
    static CGFloat extraHeight =20;
    NSString* text = [(FAQModel*)[self.sectionArray objectAtIndex:section] question]; // Get this from the some object using indexPath
    
    CGSize  size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:CGSizeMake(280, 200000.f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height+extraHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = [(FAQModel*)[self.sectionArray objectAtIndex:indexPath.section] answer]; // Get this from the some object using indexPath
    
    CGSize  size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0] constrainedToSize:CGSizeMake(300.0f, 200000.f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
       
}

#pragma mark -
#pragma mark - Prepare rows array through FAQ.plist file
#pragma mark -

- (void) setupRows
{    
    self.sectionArray = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"FAQ" withExtension:@"plist"];
    NSArray *rootArray = [[NSArray alloc] initWithContentsOfURL:url];
    for (NSDictionary *dict in rootArray)
    {
        FAQModel *model = [[FAQModel alloc] init];
        model.question = [dict valueForKey:@"Question"];
        model.answer = [dict valueForKey:@"Answer"];
        [self.sectionArray addObject:model];
    }
}

-(void)viewMoreButtonClicked:(id)sender
{
    selectedButtonIndex = [(UIButton *)sender tag];
    [self.tblFaq reloadData];
}

-(void)viewLessButtonClicked:(id)sender
{
    selectedButtonIndex = -1;
    [self.tblFaq reloadData];
}


@end
