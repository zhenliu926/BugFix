//
//  MoviePlayerController.m
//  WutzWhat
//
//  Created by iPhone Development on 5/9/13.
//
//

#import "MoviePlayerController.h"

@implementation MoviePlayerController

@synthesize viewController = _viewController;
@synthesize moviePlayerController = _moviePlayerController;

-(void)playVideoFromURL:(NSURL *)movieURL containerView:(UIViewController *)containerView
{
    self.viewController = containerView;
    
    [Utiltiy setupMoviePlayerNavigationBarStyle];
    
    [self playVideoFromURL:movieURL];
}


- (void)playVideoFromURL:(NSURL *)movieURL
{
    self.moviePlayerController = [[MPMoviePlayerViewController alloc] init];
    
    if (self.moviePlayerController)
    {
        [self.moviePlayerController.moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
        
        [self.moviePlayerController.moviePlayer setContentURL:movieURL];
        
        [self.moviePlayerController.moviePlayer prepareToPlay];
        
        [self.viewController presentViewController:self.moviePlayerController animated:NO completion:^(){}];
        [self installMovieNotificationObservers];
    }
    
    [[self.moviePlayerController moviePlayer] play];
}


#pragma mark Movie Notification Handlers

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (![self.viewController isKindOfClass:[MWPhotoBrowser class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"galleryViewClosing" object:nil];        
    }
	switch ([reason integerValue])
	{
		case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playback ended");
            [self deletePlayerAndNotificationObservers];
            [Utiltiy setupAppNavigationBarStyle];
			break;
            
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback, %@", [notification userInfo]);
            [self deletePlayerAndNotificationObservers];
            [Utiltiy setupAppNavigationBarStyle];
			break;
            
		case MPMovieFinishReasonUserExited:
            NSLog(@"user exited.");
            [self deletePlayerAndNotificationObservers];
            [Utiltiy setupAppNavigationBarStyle];
			break;
            
		default:
			break;
	}
}


- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	if (loadState & MPMovieLoadStateUnknown)
	{
        NSLog(@"unknow");
	}
	
	if (loadState & MPMovieLoadStatePlayable)
	{
        NSLog(@"playable...");
	}
	
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        NSLog(@"play through Ok");
	}
	
	if (loadState & MPMovieLoadStateStalled)
	{
        NSLog(@"state Stalled");
	}
}


- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        NSLog(@"stoped..");     
	}
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        NSLog(@"playing..");
	}
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
        NSLog(@"Puased...");
	}
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        NSLog(@"interrupted..");
	}
}

- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
}

#pragma mark Install Movie Notifications

-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = [[self moviePlayerController] moviePlayer];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

#pragma mark Remove Movie Notification Handlers

-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = [[self moviePlayerController] moviePlayer];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

-(void)deletePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    [self setMoviePlayerController:nil];
}


@end
