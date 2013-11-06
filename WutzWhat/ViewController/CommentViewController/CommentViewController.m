//
//  CommentViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/19/12.
//
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize dataDict,sectionsArray;

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
//	_scrMainScroll.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    _scrMainScroll.contentSize=CGSizeMake(7*self.view.frame.size.width, self.view.frame.size.height);
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    
    UIImage *commentButton = [UIImage imageNamed:@"top_addcomment.png"] ;
    UIImage *commentButtonPressed = [UIImage imageNamed:@"top_addcomment_c.png"] ;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, commentButton.size.width, commentButton.size.height)];
    [commentBtn addTarget:self action:@selector(editBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setImage:commentButton forState:UIControlStateNormal];
    [commentBtn setImage:commentButtonPressed forState:UIControlStateSelected];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    UIBarButtonItem *commentbtnItem = [[UIBarButtonItem alloc] initWithCustomView:commentBtn];
    [[self navigationItem]setRightBarButtonItem:commentbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_hotpicks.png"]];
    [[self navigationItem]setTitleView:titleIV];
    [self setupRows];
    
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    return [self.rows count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CommentCell";
    
    UITableViewCell *cell = (UITableViewCell*)[self.tblComments dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }   
    
    CommentModel *comments = [self.rows objectAtIndex:indexPath.row];
    
    UILabel *titleLbl = (UILabel*)[cell viewWithTag:1];
    [titleLbl setText:comments.username];
    
    UILabel *shortDiscription = (UILabel*)[cell viewWithTag:2];
    [shortDiscription setText:comments.comment];
    
    UILabel *cost = (UILabel*)[cell viewWithTag:3];
    [cost setText:comments.uploadedTime];
    
    cell.backgroundColor=[UIColor blackColor];
    
    return cell;
}
#pragma mark - Prepare rows array through WutzWhat.plist file
#pragma mark -
- (void) setupRows {
    
    self.dataDict = [[NSMutableDictionary alloc] init];
    self.sectionsArray = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Comment" withExtension:@"plist"];
    NSArray *rootArray = [[NSArray alloc] initWithContentsOfURL:url];
    for (NSDictionary *dict in rootArray) {
        
        NSArray *rowss = [dict valueForKey:@"Rows"];
        self.rows = [[NSMutableArray alloc] init];
        for (NSDictionary *rowsDict in rowss) {
           CommentModel *model = [[CommentModel alloc] init];
            model.username = [rowsDict valueForKey:@"username"];
            model.comment = [rowsDict valueForKey:@"comment"];
            model.uploadedTime = [rowsDict valueForKey:@"uploadedTime"];
            
            [self.rows addObject:model];
        }
        
        
      //  [dataDict setObject:self.rows forKey:[dict valueForKey:@""]];
        
    }
    NSLog(@"%@",dataDict);
   // [self setSectionsArray:[self.dataDict allKeys]];
    
}


#pragma mark-Button Methods

- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) editBtnTapped:(id)sender {
    
    AddCommentViewController *avc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCommentViewController"];
    [self.navigationController pushViewController:avc animated:YES];
}




- (void)dealloc {
       }
- (void)viewDidUnload {
    [self setTblComments:nil];
    [super viewDidUnload];
}
@end
