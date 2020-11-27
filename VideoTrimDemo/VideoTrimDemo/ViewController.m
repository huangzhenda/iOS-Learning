//
//  ViewController.m
//  VideoTrimDemo
//
//  Created by huangzhenda on 2020/11/23.
//

#import "ViewController.h"
#import "LJVideoTrimViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
        [self showVideTrimer:asset];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
