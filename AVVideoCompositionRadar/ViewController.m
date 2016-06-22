//
//  ViewController.m
//  AVVideoCompositionRadar
//
//  Created by Hagai Weinfeld on 20/06/2016.
//  Copyright © 2016 Hagai Weinfeld. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "MyVideoCompositionInstruction.h"
#import "MyVideoCompositor.h"

@interface ViewController ()

@property (strong, nonatomic) AVPlayer *player;

@end

@implementation ViewController

static const CGFloat defaultSliderValue;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupSliders];
  [self setupPlayback];
}

- (void)setupSliders {
  [self.changeValueSlider addTarget:self action:@selector(changeValueSliderMoved:)
                   forControlEvents:UIControlEventValueChanged];
  [self.replaceCompositionSlider addTarget:self action:@selector(replaceCompositionSliderMoved:)
                          forControlEvents:UIControlEventValueChanged];
  self.changeValueSlider.value = defaultSliderValue;
  self.replaceCompositionSlider.value = defaultSliderValue;
}

- (void)setupPlayback {
  // Load asset from video file
  NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"bunny" ofType:@"mp4"];
  NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
  AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
  AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
  
  // Setup AVVideoComposition to use custom video compositor and video instructions.
  AVMutableVideoComposition *videoComposition = [self videoCompositionForAsset:asset
                                                                filterStrength:defaultSliderValue];
  playerItem.videoComposition = videoComposition;
  
  // Setup AVPlayer to loop.
  self.player = [AVPlayer playerWithPlayerItem:playerItem];
  self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(playerItemDidReachEnd:)
                                               name:AVPlayerItemDidPlayToEndTimeNotification
                                             object:[self.player currentItem]];
  
  // Setup AVPlayerLayer to display the video.
  AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
  [playerLayer setFrame:self.view.frame];
  [self.view.layer addSublayer:playerLayer];
  [self.player play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
  AVPlayerItem *playerItem = [notification object];
  [playerItem seekToTime:kCMTimeZero];
}

- (AVMutableVideoComposition *)videoCompositionForAsset:(AVAsset *)asset
                                         filterStrength:(CGFloat)filterStrength {
  AVMutableVideoComposition *videoComposition = [[AVMutableVideoComposition alloc] init];
  videoComposition.frameDuration =  CMTimeMake(1, 60);
  videoComposition.renderSize =
      [[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject] naturalSize];
  videoComposition.instructions = [self instructionsForAsset:asset filterStrength:filterStrength];
  videoComposition.customVideoCompositorClass = [MyVideoCompositor class];
  return videoComposition;
}

- (NSArray<id<AVVideoCompositionInstruction>> *)instructionsForAsset:(AVAsset *)asset
                                                      filterStrength:(CGFloat)filterStrength {
  NSUInteger trackID = [[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject] trackID];
  MyVideoCompositionInstruction *instruction = [[MyVideoCompositionInstruction alloc]
      initWithTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) trackID:trackID filterStrength:filterStrength];
  return @[instruction];
}

- (void)changeValueSliderMoved:(UISlider *)slider {
  AVPlayerItem *playerItem = self.player.currentItem;
  AVMutableVideoComposition *videoComposition =
      (AVMutableVideoComposition *)playerItem.videoComposition;
  
  // This line sometimes causes a crash because of a race condition occuring when the instructions
  // were already added to a AVAsynchronousVideoCompositionRequest for rendering.
  videoComposition.instructions =
      [self instructionsForAsset:playerItem.asset filterStrength:slider.value];
  
  playerItem.videoComposition = videoComposition;
}

- (void)replaceCompositionSliderMoved:(UISlider *)slider {
  AVPlayerItem *playerItem = self.player.currentItem;
  playerItem.videoComposition = [self videoCompositionForAsset:playerItem.asset
                                                filterStrength:slider.value];
}

@end
