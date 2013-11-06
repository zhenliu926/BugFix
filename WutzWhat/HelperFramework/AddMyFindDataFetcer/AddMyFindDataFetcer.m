//
//  AddMyFindDataFetcer.m
//  WutzWhat
//
//  Created by iPhone Development on 4/18/13.
//
//

#import "AddMyFindDataFetcer.h"

@implementation AddMyFindDataFetcer

@synthesize urlStr = _urlStr;
@synthesize imagesArray = _imagesArray;
@synthesize delegate = _delegate;
@synthesize methodType = _methodType;
@synthesize newlyAddedImagesArray = _newlyAddedImagesArray;
@synthesize deletedImagesIDs = _deletedImagesIDs;
@synthesize editMode = _editMode;
@synthesize oldImagesCount = _oldImagesCount;
@synthesize paramDict = _paramDict;


- (void)fetchDataForUrl :(NSString*)urlStrParam andDelegate:(id<AddMyFindDataFetcerDelegate>)delegateParam postDataDict:(NSDictionary*)postDataParamDict UIImagesArray:(NSArray *)UIImagesArray
{
    NSLog(@"START");
    self.methodType = @"POST";
    self.delegate = delegateParam;
    self.urlStr = urlStrParam;
    self.paramDict = postDataParamDict;
    self.imagesArray = UIImagesArray;
    
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        [[ProcessingView instance] forceHideTintView];
        
        if ([self.delegate respondsToSelector:@selector(internetNotAvailable:)])
        {
            [self.delegate internetNotAvailable:MSG_NO_INTERNET_CONNECTIVITY];
        }
        
        return;
    }
    
    
    [self performSelectorInBackground:@selector(getOauthDataUsingHMAC) withObject:nil];
    
    [self showUploadProgressBar:YES];
}


- (void) getOauthDataUsingHMAC
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"1EvVK5StAE2BzGoOo55U2mITN4obUS"
                                                    secret:@"2NBNuSwBKE3hX9aEtqEU3xwOqEVqu0"];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:NULL
                                                                      realm:NULL
                                                          signatureProvider:nil andMethodType:self.methodType];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:finishedWithData:)
                  didFailSelector:@selector(requestTokenTicket:failedWithError:)];
    [fetcher release];
    fetcher = nil;
}


- (void)requestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data
{
    [self performSelectorOnMainThread:@selector(fetchDataForTicket:)
                           withObject:ticket
                        waitUntilDone:YES];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(fetchDataForTicket:)
                           withObject:ticket
                        waitUntilDone:YES];
}


#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

    [self showUploadProgressBar:NO];
    
    if (self.delegate)
    {
        [self.delegate dataFetchedFailureForUrl:self.urlStr];
    }
    
if(receivedData){
    [receivedData release];
    receivedData = nil;
}
if(_paramDict){
    _paramDict = nil;
}
if(_newlyAddedImagesArray){
    [_newlyAddedImagesArray release];
    _newlyAddedImagesArray = nil;
}
if(_deletedImagesIDs){
    [_deletedImagesIDs release];
    _deletedImagesIDs = nil;
}

}

- (void)dealloc
{
    if(receivedData){
        [receivedData release];
        receivedData = nil;
    }
    if(_paramDict){
        _paramDict = nil;
    }
    if(_newlyAddedImagesArray){
        [_newlyAddedImagesArray release];
        _newlyAddedImagesArray = nil;
    }
    if(_deletedImagesIDs){
        [_deletedImagesIDs release];
        _deletedImagesIDs = nil;
    }
    
    [super dealloc];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self showUploadProgressBar:NO];
    
    NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];

     if (self.delegate)
     {
         NSDictionary *responseDict = [returnString JSONValue];

         [self.delegate dataFetchedSuccessfully:responseDict forUrl:self.urlStr];
         responseDict = nil;
     }
    
    NSLog(@"Response:: %@", returnString);
    
    [returnString release];
    returnString = nil;
    
    if(receivedData){
        [receivedData release];
        receivedData = nil;
    }
    if(_paramDict){
        _paramDict = nil;
    }
    if(_imagesArray){
        [_imagesArray release];
        _imagesArray = nil;
    }
    if(_newlyAddedImagesArray){
        [_newlyAddedImagesArray release];
        _newlyAddedImagesArray = nil;
    }
    if(_deletedImagesIDs){
        [_deletedImagesIDs release];
        _deletedImagesIDs = nil;
    }
    if(myProgressIndicator){
        [myProgressIndicator release];
        myProgressIndicator = nil;
    }
    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    myProgressIndicator.progress = progress;
}

-(void)fetchDataForTicket:(OAServiceTicket *)ticket
{
    NSString *completeURL = [NSString stringWithFormat:@"%@?oauth_consumer_key=1EvVK5StAE2BzGoOo55U2mITN4obUS&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%@&oauth_version=1.0&signature=%@",self.urlStr,ticket.request.nonce,ticket.request.getTime,ticket.request.signature];
    
    NSURL *url = [NSURL URLWithString:completeURL];
        
    NSMutableURLRequest *request = [self multipartRequestWithURL:url andMethod:self.methodType andDataDictionary:self.paramDict images:self.imagesArray];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection)
    {
        receivedData = [[NSMutableData data] retain];
        
        [self showUploadProgressBar:YES];
        
    }
    else
    {
        [self showUploadProgressBar:NO];
        
        if (self.delegate)
        {
            [self.delegate dataFetchedFailureForUrl:self.urlStr];
        }
    }
}


-(NSMutableURLRequest *)multipartRequestWithURL:(NSURL *)url andMethod:(NSString *)HTTPMethod andDataDictionary:(NSDictionary *) dictionary images:(NSArray *)imagesArray
{
    
    NSMutableURLRequest *mutipartPostRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
    [mutipartPostRequest setHTTPMethod:HTTPMethod];
    
    
    NSString *HTTPRequestBodyBoundary = [NSString stringWithFormat:@"---------------------------acebdf13572468"];
    
    [mutipartPostRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", HTTPRequestBodyBoundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *HTTPRequestBody = [NSMutableData data];
    [HTTPRequestBody appendData:[[NSString stringWithFormat:@"%@\r\n",HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    NSString *key;
    
    NSMutableArray *HTTPRequestBodyParts = [NSMutableArray array];
    
    while ((key = [enumerator nextObject]))
    {
        NSMutableData *someData = [[NSMutableData alloc] init];
        [someData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [someData appendData:[[NSString stringWithFormat:@"%@", [dictionary objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [HTTPRequestBodyParts addObject:someData];
        [someData release];
        someData = nil;
    }
    
    //for edit my find, add deleted images param if any
    
    if (self.deletedImagesIDs.count > 0 && self.editMode)
    {
        NSMutableData *someData = [[NSMutableData alloc] init];
        [someData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"imagesDeleted"] dataUsingEncoding:NSUTF8StringEncoding]];
        [someData appendData:[[NSString stringWithFormat:@"%@", [self makeCSStringOfDeletedImages]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [HTTPRequestBodyParts addObject:someData];
        [someData release];
        someData = nil;
    }
    
    // add image data, if edit mode then just add new ones. if add mode, then add all the images from images array
    if (self.editMode)
    {
        for (int i = 0; i < self.newlyAddedImagesArray.count; i ++)
        {
            NSMutableData *imageBody = [[NSMutableData alloc] init];
            NSData *imageData = UIImageJPEGRepresentation([self.newlyAddedImagesArray objectAtIndex:i], 0.45f);
            if (imageData)
            {
                [imageBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_%d\"; filename=\"image_%d.jpg\"\r\n", [self getNewImageIndex:i], [self getNewImageIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [imageBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [imageBody appendData:imageData];
                [imageBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [HTTPRequestBodyParts addObject:imageBody];
            [imageBody release];
            imageBody = nil;
        }        
    }
    else
    {
        for (int i = 0; i < imagesArray.count; i ++)
        {
            NSMutableData *imageBody = [[NSMutableData alloc] init];
            NSData *imageData = UIImageJPEGRepresentation([imagesArray objectAtIndex:i], 0.60f);
            if (imageData)
            {
                [imageBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_%d\"; filename=\"image_%d.jpg\"\r\n", i + 1, i + 1] dataUsingEncoding:NSUTF8StringEncoding]];
                [imageBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [imageBody appendData:imageData];
                [imageBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [HTTPRequestBodyParts addObject:imageBody];
            [imageBody release];
            imageBody = nil;
        }
    }
    
    NSMutableData *resultingData = [NSMutableData data];
    NSUInteger count = [HTTPRequestBodyParts count];
    
    [HTTPRequestBodyParts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [resultingData appendData:obj];
         if (idx != count - 1)
         {
             [resultingData appendData:[[NSString stringWithFormat:@"\r\n%@\r\n", HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
         }
     }];
    
    [HTTPRequestBody appendData:resultingData];
    
    
    // Add the closing -- to the POST Form
    [HTTPRequestBody appendData:[[NSString stringWithFormat:@"\r\n%@\r\n", HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [mutipartPostRequest setHTTPBody:HTTPRequestBody];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [HTTPRequestBody length]];
    [mutipartPostRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    return mutipartPostRequest;
}


#pragma mark SetUp Progress bar

-(void)showUploadProgressBar:(BOOL)show
{
    HideNetworkActivityIndicator();
    
    [tintView removeFromSuperview];
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.window setUserInteractionEnabled:YES];
    
    if (show)
    {
        ShowNetworkActivityIndicator();
        
        CGRect frame= CGRectMake(85, 175, 320-40, 100);
        
        tintView = [[UIView alloc]initWithFrame:frame];
        
        tintView.backgroundColor = [UIColor blackColor];
        tintView.alpha = 0.75;
        tintView.clipsToBounds =  YES;
        
        UILabel *tintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,60, frame.size.width, 30)];
        
        tintLabel.textAlignment = NSTextAlignmentCenter;
        tintLabel.backgroundColor = [UIColor clearColor];
        tintLabel.textColor = [UIColor whiteColor];
        tintLabel.text = @"Uploading...";
        
        [tintView.layer setCornerRadius:5.0f];
        [tintView addSubview:tintLabel];
        
        frame= CGRectMake(40,30, 200, 30);
        
        myProgressIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] ;
        
        myProgressIndicator.frame=frame;
        
        [tintView addSubview:myProgressIndicator];
        
        [appDelegate.window addSubview:tintView];
        
        tintView.center = appDelegate.window.center;
        
        [appDelegate.window setUserInteractionEnabled:NO];
    }
}

-(NSString *)makeCSStringOfDeletedImages
{
    NSString *string = @"";
    
    for (int i = 0; i < self.deletedImagesIDs.count; i ++)
    {
        NSLog(@"id is : %@", [self.deletedImagesIDs objectAtIndex:i]);
        
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",[self.deletedImagesIDs objectAtIndex:i]]];
        
        if (i != self.deletedImagesIDs.count - 1)
        {
            string = [string stringByAppendingString:@","];
        }
    }
    
    return string;
}

-(int)getNewImageIndex:(int)currentIndex
{
    int deleteImageCount = [self.deletedImagesIDs count];
    
    int index = currentIndex + 1 + self.oldImagesCount - deleteImageCount;
    
    return index;
}

@end
