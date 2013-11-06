//
//  MoviePlayerController.h
//  WutzWhat
//
//  Created by iPhone Development on 5/9/13.
//
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerController : NSObject
{
    
}

@property (strong) MPMoviePlayerViewController *moviePlayerController;
@property (strong, nonatomic) UIViewController *viewController;

-(void)playVideoFromURL:(NSURL *)movieURL containerView:(UIViewController *)containerView;

@end
