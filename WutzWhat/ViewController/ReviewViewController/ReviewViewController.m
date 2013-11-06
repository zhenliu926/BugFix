//
//  ReviewViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/21/12.
//
//

#import "ReviewViewController.h"

#define RECT_REVIEW_TEXT CGRectMake(20,38,280,20)

@implementation ReviewViewController
@synthesize dataDict,sectionsArray,rows,reviews;
@synthesize postid;
@synthesize page;

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
        [[ProcessingView instance] showTintView];
        [self calServiceWithURL:GET_WUTZWHAT_REVIEWS];        
    }
    
    UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom.png"]];
    
    if(OS_VERSION>=7)
    {
    
        self.tblReviews.frame=CGRectMake(self.tblReviews.frame.origin.x,self.tblReviews.frame.origin.y+44,self.tblReviews.frame.size.width,self.tblReviews.frame.size.height);
    }

    self.tblReviews.tableFooterView =imgVew;
}


#pragma mark- Webservice

- (void) calServiceWithURL:(NSString*)serviceUrl
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:postid forKey:@"post_id"];
    [params setValue:page forKey:@"page"];

    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}

#pragma mark- Data fetcher

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_REVIEWS]])
    {
        NSMutableArray *dataArray = [responseData objectForKey:@"data"];
        array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in dataArray)
        {
            ReviewModel *model = [[ReviewModel alloc] init];
            
            [model setTitleofthePerson:[dic objectForKey:@"title"]];
            [model setName:[dic valueForKey:@"name"]];
            [model setReview:[dic valueForKey:@"review"]];
            
            [array addObject:model];
        }

        [self.tblReviews reloadData];
    }
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_WUTZWHAT_REVIEWS]])
    {
    }
}

#pragma mark- Button Actions

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReviewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[self.tblReviews dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ReviewModel *_reviews = [array objectAtIndex:indexPath.row];
   
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:1];
    [titleLbl setText:_reviews.name];
    [titleLbl setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *TitleofthePersonlbl = (UILabel*)[cell viewWithTag:2];
    [TitleofthePersonlbl setText:_reviews.TitleofthePerson];
    
    UILabel *review = (UILabel*)[cell viewWithTag:3];
   
    review.frame = RECT_REVIEW_TEXT;
    [review setLineBreakMode:NSLineBreakByWordWrapping];
    [review setMinimumScaleFactor:14.0f];
    [review setNumberOfLines:0];
    
    CGSize size = [self getTextSizeForReviewLable:_reviews.review];
    
    [review setText:_reviews.review];
    
    [review setFrame:CGRectMake(RECT_REVIEW_TEXT.origin.x, RECT_REVIEW_TEXT.origin.y, RECT_REVIEW_TEXT.size.width, MAX(size.height, RECT_REVIEW_TEXT.size.height))];
    
    UIImageView *lineImage = (UIImageView *)[cell viewWithTag:5];
    lineImage.frame = CGRectMake(0, RECT_REVIEW_TEXT.origin.y + MAX(size.height, RECT_REVIEW_TEXT.size.height) + 8, 320, 2);

    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ReviewModel *_reviews = [array objectAtIndex:indexPath.row];
    
    CGSize size = [self getTextSizeForReviewLable:_reviews.review];
    
    CGFloat height = MAX(size.height, RECT_REVIEW_TEXT.size.height);
    
    float cellHeight = height + 49;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblReviews deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload
{
    [self setTblReviews:nil];
    [super viewDidUnload];
}

-(CGSize)getTextSizeForReviewLable:(NSString *)text
{
    CGSize constraint = CGSizeMake(RECT_REVIEW_TEXT.size.width, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
