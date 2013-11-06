//
//  SharedManager.m
//  WutzWhat
//
//  Created by Zeeshan on 15/11/2012.
//
//

#import "SharedManager.h"

#import "WutsWhatSingletonManager.h"
#import "TalkSingletonManager.h"
#import "HotpicksSingletonManager.h"
#import "PerksSingletonManager.h"

#define NORMAL_FONT_SIZE    22
#define	EMPTY_STRING							@""
static SharedManager *sharedInstance = nil;

@implementation SharedManager

@synthesize currentlyViewingModuleName;
@synthesize menuViewController;
@synthesize facebookAuthenticationUsername=_facebookAuthenticationUsername;
@synthesize twitterAuthenticationUsername=_twitterAuthenticationUsername;
@synthesize numberOfRequestInQueue;
@synthesize sessionDictionay=_sessionDictionay;
- (id) init
{
    self = [super init];
    if (self) {
        numberOfRequestInQueue = 0;
    }
    return self;
}
+ (id)sharedManager
{
	@synchronized(self)
	{
		if (sharedInstance == nil) {
			sharedInstance = [[SharedManager alloc] init];
            
        }
    
    
	}
	return sharedInstance;
}


-(void)saveFacebookUsernameToDisk
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]  init];
    [dictionary setObject:self.facebookAuthenticationUsername forKey:@"Facebookuser"];
    NSError  *error;
    NSData* archiveData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"Facebookuser.plist"];
    [archiveData writeToFile:fullPath options:NSDataWritingAtomic error:&error];
}


-(void)loadFacebookUsernameToDisk
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"Facebookuser.plist"];
    NSMutableDictionary *dict = nil;
    @try
    {
        NSData *archiveData = [NSData dataWithContentsOfFile:fullPath];
        dict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        
        if ([dict count] > 0) {
            
            // NSLog(@"dictCount=%d",[dict count]);
            _facebookAuthenticationUsername=[dict valueForKey:@"Facebookuser"];
        }
        
        
    }
    @catch (NSException * e)
    {
        //NSLog(@"exception in opening file");
        
    }
    @finally
    {
        
    }
    
}

-(void)saveTwitterUsernameToDisk
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]  init];
    [dictionary setObject:self.twitterAuthenticationUsername forKey:@"Twitteruser"];
    NSError  *error;
    NSData* archiveData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"Twitteruser.plist"];
    [archiveData writeToFile:fullPath options:NSDataWritingAtomic error:&error];
} 
-(BOOL)loadTwitterUsernameToDisk
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"Twitteruser.plist"];
    NSMutableDictionary *dict = nil;
    @try
    {
        NSData *archiveData = [NSData dataWithContentsOfFile:fullPath];
        dict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        
        if ([dict count] > 0) {
            
            // NSLog(@"dictCount=%d",[dict count]);
            if([self checkifTwitterIsStillValid:[dict valueForKey:@"Twitteruser"]]) {
                _twitterAuthenticationUsername = [dict valueForKey:@"Twitteruser"];
                return TRUE;
            }
        }
        
        
    }
    @catch (NSException * e)
    {
        //NSLog(@"exception in opening file");
        return FALSE;
    }
    @finally
    {
        
    }
    
    return FALSE;
    
}

- (BOOL)checkifTwitterIsStillValid:(NSString *)account
{
    BOOL activeStill = FALSE;
    ACAccountStore *ac = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [ac accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    for (ACAccount *a in [ac accountsWithAccountType:twitterType]) {
        if([a.username isEqualToString:account])
            activeStill = TRUE;
    }
    
    return activeStill;
}


-(void)saveSessionToDisk
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]  initWithDictionary:self.sessionDictionay];
    NSError  *error;
    NSData* archiveData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"SavedSession.plist"];
    [archiveData writeToFile:fullPath options:NSDataWritingAtomic error:&error];
}
-(void)loadSessionFromDisk
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:@"SavedSession.plist"];
    NSMutableDictionary *dict = nil;
    @try
    {
        NSData *archiveData = [NSData dataWithContentsOfFile:fullPath];
        dict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        if ([dict count] > 0) {
            self.sessionDictionay=dict;
        }  
    }
    @catch (NSException * e)
    {
    }
    @finally
    {    
    }
}



- (void) initializeTineView {
    tintView = [[UIAlertView alloc] initWithTitle:@"" message:@"Loading please wait..." delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
    
}

- (void) showTintView {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    //[[[[UIApplication sharedApplication] delegate] window] addSubview:tintView];
    
    [tintView setCenter:CGPointMake(window.center.x, window.center.y)];
    [tintView show];
    
}
- (void) hideTintView {
    [tintView removeFromSuperview];
}
- (BOOL) isNetworkAvailable {
	
	//return YES;
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable && [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable) {
		return NO;
	}
	
	else {
		return YES;
	}
}
- (void) clearMemory {
    NSString *currentlyviewingModuleName = [[SharedManager sharedManager] currentlyViewingModuleName];
    if (![currentlyviewingModuleName isEqualToString:@"WutzWhatListViewController"]) {
        [[WutsWhatSingletonManager sharedManager] destroy];
    }
    if (![currentlyviewingModuleName isEqualToString:@"HotPicksListViewController"]) {
        [[HotpicksSingletonManager sharedManager] destroy];
    }
    if (![currentlyviewingModuleName isEqualToString:@"PerksListViewController"]) {
        [[PerksSingletonManager sharedManager] destroy];
    }
    if (![currentlyviewingModuleName isEqualToString:@"TalksListViewController"]) {
        [[TalkSingletonManager sharedManager] destroy];
    }
}



#pragma mark -
#pragma mark NSDate
#pragma mark -

+ (NSString*) getStringFromDate:(NSDate*)aDate inFormat:(NSString*)aFormat
{
	NSString *retVal = nil;
	
	if (aFormat!=nil && [aFormat length] > 0)
    {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:aFormat];
		retVal = [formatter stringFromDate:aDate];
    }
	
	return retVal;
}

/**
 Returns NSDate* from string in the specified format
 */
+ (NSDate*) getDateFromString:(NSString*)aString withFormat:(NSString*)aFormat
{
	NSDate *retVal = nil;
	if (aFormat!=nil && [aFormat length] > 0)
    {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:aFormat];
		retVal = [formatter dateFromString:aString];
    }
	
	return retVal;
}

+(NSString*)getStringFromDifferentDateFormat:(NSString*)dateString format:(NSString*)dateFormat
{
    NSString *stringF = @"";
    NSDate *date = [self getDateFromString:dateString withFormat:@"dd-MMM-yyyy"];
    stringF  = [self getStringFromDate:date inFormat:dateFormat];
    return stringF;
}
/**
 Returns NSString* from string in the specified format
 */
+ (NSString*) getFormattedStringDateFromString:(NSString*)aString withFormat:(NSString*)aFormat
{
	NSString *retVal = nil;
	if (aFormat!=nil && [aFormat length] > 0)
    {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:aFormat];
		NSDate *dateFromString = [formatter dateFromString:aString];
		retVal = [formatter stringFromDate: dateFromString];
    }
	
	return retVal;
}
@end
