//
//  LJVideoTrimPlayer.m
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import "LJVideoTrimPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface LJVideoTrimPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) CGFloat videoPlaybackPosition;
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation LJVideoTrimPlayer

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.player) {
        [self.player pause];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.player = nil;
    }
}

- (instancetype)initWithAsset:(AVAsset *)asset {
    
    self = [super init];
    if (self) {
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:item];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (AVPlayerLayer *)playerLayer {
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    return playerLayer;
}

- (void)setVideoFillMode:(AVLayerVideoGravity)mode {
    [(AVPlayerLayer *)[self layer] setVideoGravity:mode];
}



#pragma mark - Public Methods
- (void)seekVideoToPos:(CGFloat)pos {

    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)play {
    
    self.isPlaying = YES;
    [self.player play];
    
}

- (void)pause {
    self.isPlaying = NO;
    [self.player pause];
}

#pragma mark - Private Methods
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    
}

- (void)tapOnVideoLayer:(id)sender {
    
}



@end
