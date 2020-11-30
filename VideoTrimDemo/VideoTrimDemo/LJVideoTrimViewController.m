//
//  LJVideoTrimViewController.m
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import "LJVideoTrimViewController.h"
#import "LJVideoTrimPlayer.h"
#import <ICGVideoTrimmer/ICGVideoTrimmer.h>
#import <Masonry/Masonry.h>


@interface LJVideoTrimViewController () <ICGVideoTrimmerDelegate>

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) AVAsset *avAsset;

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) LJVideoTrimPlayer *player;
@property (nonatomic, strong) ICGVideoTrimmerView *trimmerView;

@end

@implementation LJVideoTrimViewController

- (instancetype)initWithAsset:(PHAsset *)asset {

    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频裁剪";
    self.view.backgroundColor = [UIColor blackColor];
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSLog(@"progress: %f", progress);
    };
    
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
        if (!asset) {
            return;
        }
        weakSelf.avAsset = asset;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupNav];
            [weakSelf setupSubviews];
        });
    }];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
//    [self.trimmerView resetSubviews];
}

#pragma mark - UI
- (void)setupNav {
    
    self.confirmBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 32);
        [btn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0f]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 16.0;
        btn.layer.masksToBounds = YES;
        btn;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmBtn];

}

- (void)setupSubviews {
    
    __weak typeof(self) weakSelf = self;
    self.player = [[LJVideoTrimPlayer alloc] initWithAsset:self.avAsset];
    [self.player setPeriodicTimeObserverBlock:^(double currentDuration, double totoalDuration) {
        if (totoalDuration > 0) {
            [weakSelf.trimmerView seekToTime:currentDuration];
        }
    }];
    [self.view addSubview:self.player];
    self.player.frame = [self initTrimingPlayerFrame];
    self.player.endTime = self.videoMaxDuration;
    
    CGRect frame = CGRectMake(20, CGRectGetHeight(self.view.frame) - 90, CGRectGetWidth(self.view.frame) - 40, 90);
    self.trimmerView = [[ICGVideoTrimmerView alloc] initWithFrame:frame asset:self.avAsset];
    self.trimmerView.delegate = self;
    self.trimmerView.maxLength = self.videoMaxDuration;
    self.trimmerView.showsRulerView = YES;
    self.trimmerView.themeColor = [UIColor whiteColor];
    self.trimmerView.leftThumbImage = [UIImage imageNamed:@"btn_cutvideo_left"];
    self.trimmerView.rightThumbImage = [UIImage imageNamed:@"btn_cutvideo_right"];
    self.trimmerView.borderWidth = 0;
    [self.view addSubview:self.trimmerView];
    [self.trimmerView resetSubviews];
}

- (CGRect)initTrimingPlayerFrame {
    CGFloat width = self.asset.pixelWidth;
    CGFloat height = self.asset.pixelHeight;
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat screenHeight = CGRectGetHeight(self.view.frame);
    if (self.asset.pixelWidth > self.asset.pixelHeight) {
        width = screenWidth - 20;
        height = width * self.asset.pixelHeight/self.asset.pixelWidth;
        return CGRectMake((screenWidth - width)/2, (screenHeight-height)/2-20, width, height);
    } else {
        screenHeight = screenHeight-20*2-90;
        height = screenHeight;
        width = height * self.asset.pixelWidth/self.asset.pixelHeight;
        return CGRectMake((screenWidth-width)/2, 20, width, height);
    }
}


#pragma mark - Action
- (void)confirmAction:(id)sender {
    
//    CGFloat cut_duration = (self.stopTime - self.startTime) ;
    
}

#pragma mark - ICGVideoTrimmerDelegate
- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime {
    
    if (startTime != self.player.startTime) {
        [self.player seekVideoToPos:startTime];
    }else{
        [self.player seekVideoToPos:endTime];
    }
    [self.player setStartTime:startTime];
    [self.player setEndTime:endTime];

}

@end
