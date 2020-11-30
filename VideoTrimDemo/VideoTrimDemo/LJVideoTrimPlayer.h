//
//  LJVideoTrimPlayer.h
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJVideoTrimPlayer : UIView

///  播放进度回调
@property (nonatomic, copy) void(^ __nullable periodicTimeObserverBlock) (double currentDuration, double totoalDuration);

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

- (instancetype)initWithAsset:(AVAsset *)asset;

- (void)play;

- (void)pause;

- (void)seekVideoToPos:(CGFloat)pos;

- (void)setVideoFillMode:(NSString *)mode;

@end

NS_ASSUME_NONNULL_END
