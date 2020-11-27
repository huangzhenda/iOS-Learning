//
//  ViewController.m
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import "ViewController.h"
#import "LJVideoTrimViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIVideoEditorControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)chooseVideo:(id)sender {
    
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.mediaTypes =     [UIImagePickerController availableMediaTypesForSourceType:
                         UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showVideTrimer:(PHAsset *)asset {
    
    if (!asset) {
        return;
    }
    
    
    LJVideoTrimViewController *vc = [[LJVideoTrimViewController alloc] initWithAsset:asset];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showUIVideoEditor:(PHAsset *)asset {
    
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        return;
    }
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
        if (!avasset) {
            return;
        }
        AVURLAsset *urlAsset = (AVURLAsset *)avasset;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIVideoEditorController *editorVC = [[UIVideoEditorController alloc] init];
            editorVC.videoPath = urlAsset.URL.path;
            editorVC.delegate = self;
            [weakSelf presentViewController:editorVC animated:YES completion:nil];
            
        });
    }];


}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    PHAsset *asset = nil;
    if (@available(iOS 11, *)) {
        asset = info[UIImagePickerControllerPHAsset];
    }
    
    if (!asset) {
        NSURL *videoURL = info[UIImagePickerControllerReferenceURL];
        PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[videoURL] options:nil];
        asset = result.firstObject;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showUIVideoEditor:asset];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIVideoEditorControllerDelegate
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    
}

@end
