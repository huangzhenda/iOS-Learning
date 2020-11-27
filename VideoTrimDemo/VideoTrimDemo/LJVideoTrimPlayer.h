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

- (instancetype)initWithAsset:(AVAsset *)asset;

- (void)seekVideoToPos:(CGFloat)pos;

- (void)play;

- (void)pause;

- (void)setVideoFillMode:(NSString *)mode;

@end

NS_ASSUME_NONNULL_END
