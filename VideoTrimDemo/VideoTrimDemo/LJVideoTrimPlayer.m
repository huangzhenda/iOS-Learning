//
//  LJVideoTrimPlayer.m
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import "LJVideoTrimPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LJVideoTrimPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) CGFloat videoPlaybackPosition;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) id timeObserver;

@end

@implementation LJVideoTrimPlayer

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }

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
        self.startTime = 0;
        self.endTime = CMTimeGetSeconds(item.duration);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        __weak typeof(self) weakSelf = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, item.currentTime.timescale) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            double currentDuration = CMTimeGetSeconds(time);
            weakSelf.videoPlaybackPosition = currentDuration;
            if (weakSelf.periodicTimeObserverBlock) {
                weakSelf.periodicTimeObserverBlock(currentDuration, CMTimeGetSeconds(item.duration));
            }
            
            if (currentDuration >= weakSelf.endTime) {
                [weakSelf seekVideoToPos:weakSelf.startTime];
            }

        }];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
        [self addGestureRecognizer:tap];

        self.playButton = [[UIButton alloc] init];
        [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"btn_video_play"] forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45,45));
            make.center.equalTo(self);
        }];
        
        RAC(self.playButton,hidden) = RACObserve(self, isPlaying);
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
    AVPlayerItem *p = [notification object];
    if (p == self.playerItem && self.isPlaying) {
        CMTime time = CMTimeMakeWithSeconds(self.startTime, self.player.currentTime.timescale);
        [self.player seekToTime:time];
    }
}

- (void)playButtonAction:(id)sender {
    
    if (!self.isPlaying) {
        [self play];
    }else{
        [self pause];
    }
}

- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap {

    if (self.isPlaying) {
        [self pause];
    }else{
        [self play];
    }
}

@end
