//
//  LJVideoTrimViewController.h
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJVideoTrimViewController : UIViewController

@property (nonatomic, strong, readonly) PHAsset *asset;

- (instancetype)initWithAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
