//
//  KSImagePickerController.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerController.h"
#import "KSImagePickerView.h"

#import "KSImagePickerVideoItemCell.h"
#import "KSImagePickerCameraCell.h"

#import "KSImagePickerAlbumCell.h"
#import "KSImagePickerAlbumModel.h"

#import "KSImagePickerViewerController.h"
#import "KSImagePickerEditPictureController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface KSImagePickerController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, KSImagePickerEditPictureDelegate>

@property (nonatomic, strong) KSImagePickerView *view;

@property (nonatomic, strong) KSImagePickerAlbumModel *selectedAlbum;
@property (nonatomic, strong, readonly) NSMutableArray <KSImagePickerItemModel *> *selectedAsset;

@property (nonatomic, strong, readonly) KSImagePickerCameraCell *cameraCell;

@end

@implementation KSImagePickerController {
    NSArray <KSImagePickerAlbumModel *> *_albumList;
    
    BOOL _isEditPictureStyle;
}
@synthesize selectedAsset = _selectedAsset, cameraCell = _cameraCell;
@dynamic view;

- (instancetype)init {
    return [self initWithMediaType:KSImagePickerMediaTypePicture];
}

- (instancetype)initWithMediaType:(KSImagePickerMediaType)mediaType {
    NSUInteger maxItemCount = mediaType == KSImagePickerMediaTypePicture ? 9 : 1;
    return [self initWithMediaType:mediaType maxItemCount:maxItemCount];
}

- (instancetype)initWithMediaType:(KSImagePickerMediaType)mediaType maxItemCount:(NSUInteger)maxItemCount {
    if (self = [super init]) {
        _mediaType = mediaType;
        _maxItemCount = maxItemCount;
        _isEditPictureStyle = NO;
    }
    return self;
}

- (instancetype)initWithEditPictureStyle:(KSImagePickerEditPictureStyle)editPictureStyle {
    if (self = [super init]) {
        _mediaType = KSImagePickerMediaTypePicture;
        _maxItemCount = 1;
        _editPictureStyle = editPictureStyle;
        _isEditPictureStyle = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [KSImagePickerController authorityCheckUpWithController:self type:KSImagePickerMediaTypePicture completionHandler:^(KSImagePickerMediaType type) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
            PHFetchResult<PHAssetCollection *> *regularAssetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            NSArray <PHFetchResult<PHAssetCollection *> *> *array = @[assetCollections, regularAssetCollections];
            [weakSelf setAssetData:array];
        });
    } cancelHandler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewController];
    }];
}

static NSString * const k_iden1 = @"KSImagePickerItemCell";
static NSString * const k_iden2 = @"KSImagePickerVideoItemCell";
static NSString * const k_iden3 = @"KSImagePickerCameraCell";

- (void)loadView {
    KSImagePickerView *view = [[KSImagePickerView alloc] init];
    
    KSImagePickerNavigationView *nav = view.navigationView;
    
    [nav.centerButton addTarget:self action:@selector(chengedAlbumListStatus) forControlEvents:UIControlEventTouchUpInside];
    [nav.backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];

    
    UICollectionView *collectionView = view.collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:KSImagePickerItemCell.class forCellWithReuseIdentifier:k_iden1];
    [collectionView registerClass:KSImagePickerVideoItemCell.class forCellWithReuseIdentifier:k_iden2];
    [collectionView registerClass:KSImagePickerCameraCell.class forCellWithReuseIdentifier:k_iden3];
    
    UITableView *albumTableView = view.albumTableView;
    albumTableView.delegate = self;
    albumTableView.dataSource = self;
    
    [view.doneButton addTarget:self action:@selector(didClickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [view.previewButton addTarget:self action:@selector(didClickPreviewButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = view;
}

- (void)dismissViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushViewController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickPreviewButton {
    KSImagePickerViewerController *ctl = [[KSImagePickerViewerController alloc] initWithTransitionAnimation:NO];
    [ctl setDataArray:_selectedAsset currentIndex:0];
    __weak typeof(self) weakSelf = self;
    [ctl setDidClickDoneButtonCallback:^(KSImagePickerViewerController *controller, NSUInteger index) {
        [weakSelf didClickDoneButton];
    }];
    [self pushViewController:ctl];
}

- (void)setAssetData:(NSArray <PHFetchResult<PHAssetCollection *> *> *)assetCollections {
    _albumList = [KSImagePickerAlbumModel albumModelFromAssetCollections:assetCollections mediaType:_mediaType];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadAssetDataFinish];
    });
}

- (void)loadAssetDataFinish {
    [self.view.albumTableView reloadData];
    self.selectedAlbum = _albumList.firstObject;
}

- (void)setSelectedAlbum:(KSImagePickerAlbumModel *)selectedAlbum {
    if (_selectedAlbum != selectedAlbum) {
        _selectedAlbum = selectedAlbum;
        KSImagePickerView *view = self.view;
        view.navigationView.title = selectedAlbum.albumTitle;
        [view.collectionView reloadData];
    }
}

- (void)chengedAlbumListStatus {
    [self.view chengedAlbumListStatus];
}

- (void)didClickDoneButton {
    if (_isEditPictureStyle) {
        KSImagePickerEditPictureController *edit = [[KSImagePickerEditPictureController alloc] init];
        edit.model = _selectedAsset.firstObject;
        edit.delegate = self;
        edit.circularMask = _editPictureStyle == KSImagePickerEditPictureStyleCircular;
        [self pushViewController:edit];
    } else if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(imagePicker:didFinishSelectedAssetModelArray:ofMediaType:)]) {
            [_delegate imagePicker:self didFinishSelectedAssetModelArray:_selectedAsset ofMediaType:_mediaType];
        }
        if (_mediaType == KSImagePickerMediaTypePicture) {
            if ([_delegate respondsToSelector:@selector(imagePicker:didFinishSelectedImageArray:)]) {
                NSMutableArray <UIImage *> *imageArray = [NSMutableArray arrayWithCapacity:_selectedAsset.count];
                UIImage *nullImage = [UIImage imageNamed:@"icon_transparent"];
                CGSize size = self.view.bounds.size;
                for (KSImagePickerItemModel *itemModel in _selectedAsset) {
                    PHAsset *asset = itemModel.asset;
                    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:KSImagePickerItemModel.pictureOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result == nil) {
                            [imageArray addObject:nullImage];
                        } else {
                            [imageArray addObject:result];
                        }
                    }];
                }
                [_delegate imagePicker:self didFinishSelectedImageArray:imageArray];
            }
        } else {
            if ([_delegate respondsToSelector:@selector(imagePicker:didFinishSelectedVideoArray:)]) {
                NSMutableArray <AVURLAsset *> *videoArray = [NSMutableArray arrayWithCapacity:_selectedAsset.count];
                NSNull *null = NSNull.null;
                dispatch_semaphore_t signal = dispatch_semaphore_create(0);
                for (KSImagePickerItemModel *itemModel in _selectedAsset) {
                    PHAsset *asset = itemModel.asset;
                    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:KSImagePickerItemModel.videoOptions resultHandler:^(AVAsset * _Nullable urlAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        if (urlAsset == nil) {
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
                            [videoArray addObject:null];
                        } else {
                            [videoArray addObject:urlAsset];
                        }
                        dispatch_semaphore_signal(signal);
                    }];
                    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
                }
                [_delegate imagePicker:self didFinishSelectedVideoArray:videoArray];
            }
        }
        [self dismissViewController];
    }
}

- (void)openSystemCamera {
    __weak typeof(self) weakSelf = self;
    if (_mediaType == KSImagePickerMediaTypePicture) {
        [KSImagePickerController authorityCheckUpWithController:self type:KSImagePickerMediaTypeVideo completionHandler:^(KSImagePickerMediaType type) {
            UIImagePickerController *cameraCtl = [[UIImagePickerController alloc] init];
            cameraCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraCtl.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            cameraCtl.delegate = weakSelf;
            [weakSelf.navigationController presentViewController:cameraCtl animated:YES completion:nil];
        } cancelHandler:nil];
    } else {
        [KSImagePickerController authorityCheckUpWithController:self type:KSImagePickerMediaTypeVideo completionHandler:^(KSImagePickerMediaType type) {
            [KSImagePickerController authorityAVMediaTypeAudioCheckUpWithController:self completionHandler:^(BOOL isOpen) {
                UIImagePickerController *cameraCtl = [[UIImagePickerController alloc] init];
                cameraCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
                cameraCtl.mediaTypes = @[(__bridge NSString *)kUTTypeMovie];
                cameraCtl.videoQuality = UIImagePickerControllerQualityTypeHigh;
                cameraCtl.allowsEditing = YES ;
                cameraCtl.delegate = weakSelf;
                [weakSelf.navigationController presentViewController:cameraCtl animated:YES completion:nil];
            } cancelHandler:nil];
        } cancelHandler:nil];
    }
}


#pragma mark - KSImagePickerEditPictureDelegate
- (void)imagePickerEditPicture:(KSImagePickerEditPictureController *)imagePickerEditPicture didFinishSelectedImage:(UIImage *)image assetModel:(KSImagePickerItemModel *)assetModel {
//    if (assetModel != nil && [_delegate respondsToSelector:@selector(imagePicker:didFinishSelectedImageAssetModelArray:ofMediaType:)]) {
//        [_delegate imagePicker:self didFinishSelectedImageAssetModelArray:@[assetModel] ofMediaType:_mediaType];
//    }
    if (_delegate != nil && image != nil && [_delegate respondsToSelector:@selector(imagePicker:didFinishSelectedImageArray:)]) {
        [_delegate imagePicker:self didFinishSelectedImageArray:@[image]];
    }
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __block NSString *createdAssetID = nil;
    NSError *error = nil;
    [PHPhotoLibrary.sharedPhotoLibrary performChangesAndWait:^{
        PHAssetChangeRequest *request = nil;
        CFStringRef type = (__bridge CFStringRef)[info objectForKey:UIImagePickerControllerMediaType];
        if (type == kUTTypeImage) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } else if (type == kUTTypeMovie) {
            NSURL *URL = [info objectForKey:UIImagePickerControllerMediaURL];
            request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:URL];
        }
        createdAssetID = request.placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error == nil && createdAssetID != nil) {
        PHAsset *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetID] options:nil].firstObject;
        if (result != nil) {
            [self updateAssetData:result];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateAssetData:(PHAsset *)asset {
    KSImagePickerItemModel *itemModel = [[KSImagePickerItemModel alloc] initWithAsset:asset];
    itemModel.index = self.selectedAsset.count+1;
    [_selectedAlbum.assetList insertObject:itemModel atIndex:1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionView *collectionView = self.view.collectionView;
        [collectionView performBatchUpdates:^{
            [collectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self selectedAssetAddItemModel:itemModel];
        }];
    });
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedAlbum.assetList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSImagePickerItemModel *itemModel = [_selectedAlbum.assetList objectAtIndex:indexPath.item];
    KSImagePickerBaseCell *cell = nil;
    if (itemModel.isCameraCell) cell = self.cameraCell;
    else {
        PHAssetMediaType mediaType = itemModel.asset.mediaType;
        BOOL isPictureCell = mediaType == PHAssetMediaTypeImage;
        NSString *iden = isPictureCell ? k_iden1 : k_iden2;
        KSImagePickerItemCell *k_cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
        if (k_cell.didSelectedItem == nil) {
            __weak typeof(self) weakSelf = self;
            [k_cell setDidSelectedItem:^NSUInteger(KSImagePickerItemCell * _Nonnull b_cell) {
                return [weakSelf didSelectedItemWithItemModel:b_cell.itemModel];
            }];
            k_cell.multipleSelected = _maxItemCount > 1;
        }
        cell = k_cell;
    }
    cell.itemModel = itemModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KSImagePickerBaseCell *cell = (KSImagePickerBaseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    KSImagePickerItemModel *itemModel = cell.itemModel;
    if (itemModel != nil && !itemModel.isLoseFocus) {
        if (itemModel.isCameraCell) {
            [self openSystemCamera];
        } else {
            NSArray <KSImagePickerItemModel *> *assetList = _selectedAlbum.assetList;
            BOOL isCameraRoll = _selectedAlbum.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
            NSUInteger index = indexPath.item;
            if (isCameraRoll) {//处理相机胶卷带照相机item的问题
                NSMutableArray <KSImagePickerItemModel *> *m_assetList = assetList.mutableCopy;
                [m_assetList removeObject:self.cameraCell.itemModel];
                assetList = m_assetList;
                index -= 1;
            }
            
            KSImagePickerViewerController *ctl = [[KSImagePickerViewerController alloc] init];
            __weak typeof(self) weakSelf = self;
            [ctl setWillBeginCloseAnimation:^(NSUInteger index) {
                if (isCameraRoll) index += 1;
                NSIndexPath *k_indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                UICollectionView *k_collectionView = weakSelf.view.collectionView;
                [k_collectionView scrollToItemAtIndexPath:k_indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }];
            [ctl setItemFrameAtIndex:^CGRect(NSUInteger index) {
                if (isCameraRoll) index += 1;
                NSIndexPath *k_indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                UICollectionView *k_collectionView = weakSelf.view.collectionView;
                KSImagePickerBaseCell *k_cell = [k_collectionView cellForItemAtIndexPath:k_indexPath];
                return k_cell.imageViewFrameInSuperView;
            }];
            [ctl setDidClickSelectButtonCallback:^NSUInteger(NSUInteger index) {
                if (isCameraRoll) index += 1;
                return [weakSelf didSelectedItemWithIndex:index];
            }];
            [ctl setDidClickDoneButtonCallback:^(KSImagePickerViewerController *controller, NSUInteger index) {
                if (self->_selectedAsset.count == 0) {
                    if (isCameraRoll) index += 1;
                    [weakSelf didSelectedItemWithIndex:index];
                }
                [controller dismissViewControllerAnimated:self->_isEditPictureStyle];
                [weakSelf didClickDoneButton];
            }];
            ctl.multipleSelected = _maxItemCount > 1;
            [ctl setDataArray:assetList currentIndex:index];
            [self presentViewController:ctl animated:YES completion:nil];
        }
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (NSUInteger)didSelectedItemWithIndex:(NSUInteger)index {
    NSIndexPath *k_indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionView *k_collectionView = self.view.collectionView;
    KSImagePickerBaseCell *k_cell = [k_collectionView cellForItemAtIndexPath:k_indexPath];
    if (k_cell == nil) {
        KSImagePickerItemModel *itemModel = [self->_selectedAlbum.assetList objectAtIndex:index];
        NSUInteger k_index = [self didSelectedItemWithItemModel:itemModel];
        itemModel.index = k_index;
        return k_index;
    } else {
        KSImagePickerItemModel *itemModel = k_cell.itemModel;
        NSUInteger k_index = [self didSelectedItemWithItemModel:itemModel];
        itemModel.index = k_index;
        [k_collectionView reloadItemsAtIndexPaths:@[k_indexPath]];
        return k_index;
    }
}

- (NSUInteger)didSelectedItemWithItemModel:(KSImagePickerItemModel *)itemModel {
    if (itemModel != nil && !itemModel.isLoseFocus) {
        if (itemModel.index > 0) {//已选中
            return [self selectedAssetRemoveItemModel:itemModel];
        } else {
            return [self selectedAssetAddItemModel:itemModel];
        }
    }
    return 0;
}

- (NSUInteger)selectedAssetAddItemModel:(KSImagePickerItemModel *)itemModel {
    NSMutableArray<KSImagePickerItemModel *> *selectedAsset = self.selectedAsset;
    NSUInteger count = selectedAsset.count;
    if (count < _maxItemCount) {
        KSImagePickerView *view = self.view;
        [selectedAsset addObject:itemModel];
        NSUInteger lastCount = count+1;
        if (lastCount == _maxItemCount) {
            NSArray <KSImagePickerItemModel *> *assetList = _selectedAlbum.assetList;
            NSUInteger assetListCount = assetList.count;
            NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:assetListCount];
            for (NSUInteger i = 0; i < assetListCount; i++) {
                KSImagePickerItemModel *itemModel = [assetList objectAtIndex:i];
                if (![selectedAsset containsObject:itemModel]) {
                    itemModel.loseFocus = YES;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
            }
            UICollectionView *collectionView = view.collectionView;
            [collectionView performBatchUpdates:^{
                [collectionView reloadItemsAtIndexPaths:indexPaths];
            } completion:nil];
            self.view.navigationView.centerButton.enabled = NO;
        }
        BOOL enabled = lastCount > 0;
        view.doneButton.enabled = enabled;
        view.previewButton.enabled = enabled;
        return lastCount;
    }
    return 0;
}

- (NSUInteger)selectedAssetRemoveItemModel:(KSImagePickerItemModel *)itemModel {
    NSMutableArray<KSImagePickerItemModel *> *selectedAsset = self.selectedAsset;
    NSUInteger index = [selectedAsset indexOfObject:itemModel];
    NSUInteger count = selectedAsset.count;
    if (index >= 0 && index < count) {
        KSImagePickerView *view = self.view;
        itemModel.index = 0;
        [selectedAsset removeObjectAtIndex:index];
        BOOL needUpdateIndexNumber = index != count-1;
        BOOL needUpdateFocus = count == _maxItemCount;
        if (needUpdateIndexNumber && needUpdateFocus) {
            NSArray <KSImagePickerItemModel *> *assetList = _selectedAlbum.assetList;
            NSUInteger assetListCount = assetList.count;
            NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:assetListCount];
            NSUInteger j = 1;
            for (NSUInteger i = 0; i < assetListCount; i++) {
                KSImagePickerItemModel *k_itemModel = [assetList objectAtIndex:i];
                if ([selectedAsset containsObject:k_itemModel]) {
                    k_itemModel.index = j;
                    j++;
                } else if (k_itemModel.isLoseFocus) {
                    k_itemModel.loseFocus = NO;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            UICollectionView *collectionView = view.collectionView;
            [collectionView performBatchUpdates:^{
                [collectionView reloadItemsAtIndexPaths:indexPaths];
            } completion:nil];
        } else if (needUpdateIndexNumber) {
            NSArray <KSImagePickerItemModel *> *assetList = _selectedAlbum.assetList;
            NSUInteger assetListCount = assetList.count;
            NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:_maxItemCount];
            for (NSUInteger i = 0; i < selectedAsset.count; i++) {
                KSImagePickerItemModel *k_itemModel = [selectedAsset objectAtIndex:i];
                k_itemModel.index = i+1;
                
                NSUInteger k_index = [assetList indexOfObject:k_itemModel];
                if (k_index >= 0 && k_index < assetListCount) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:k_index inSection:0];
                    [indexPaths addObject:indexPath];
                }
            }
            UICollectionView *collectionView = view.collectionView;
            [collectionView performBatchUpdates:^{
                [collectionView reloadItemsAtIndexPaths:indexPaths];
            } completion:nil];
        } else if (needUpdateFocus) {
            NSArray <KSImagePickerItemModel *> *assetList = _selectedAlbum.assetList;
            NSUInteger assetListCount = assetList.count;
            NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:assetListCount];
            for (NSUInteger i = 0; i < assetListCount; i++) {
                KSImagePickerItemModel *itemModel = [assetList objectAtIndex:i];
                if (itemModel.isLoseFocus) {
                    itemModel.loseFocus = NO;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
            }
            UICollectionView *collectionView = view.collectionView;
            [collectionView performBatchUpdates:^{
                [collectionView reloadItemsAtIndexPaths:indexPaths];
            } completion:nil];
        }
        self.view.navigationView.centerButton.enabled = YES;
        BOOL enabled = selectedAsset.count > 0;
        view.doneButton.enabled = enabled;
        view.previewButton.enabled = enabled;
    }
    return 0;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const iden = @"KSImagePickerAlbumCell";
    KSImagePickerAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[KSImagePickerAlbumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    cell.albumModel = [_albumList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KSImagePickerAlbumCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KSImagePickerAlbumModel *albumModel = cell.albumModel;
    if (albumModel != nil) {
        self.selectedAlbum = albumModel;
        [self chengedAlbumListStatus];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - lazy load
- (NSMutableArray<KSImagePickerItemModel *> *)selectedAsset {
    if (_selectedAsset == nil) {
        _selectedAsset = [NSMutableArray arrayWithCapacity:9];
    }
    return _selectedAsset;
}

- (KSImagePickerCameraCell *)cameraCell {
    if (_cameraCell == nil && _albumList != nil) {
        _cameraCell = [self.view.collectionView dequeueReusableCellWithReuseIdentifier:k_iden3 forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    return _cameraCell;
}

@end

@implementation KSImagePickerController (Authority)

+ (void)authorityCheckUpWithController:(UIViewController *)controller type:(KSImagePickerMediaType)type completionHandler:(void(^)(KSImagePickerMediaType type))completionHandler cancelHandler:(void (^)(UIAlertAction *action))cancelHandler {
    if (controller != nil && completionHandler != nil) {
        switch (type) {
            case KSImagePickerMediaTypePicture: {
                void(^authorization)(PHAuthorizationStatus) = ^(PHAuthorizationStatus status) {
                    switch (status) {
                        case PHAuthorizationStatusAuthorized:
                            completionHandler(type);
                            break;
                        case PHAuthorizationStatusDenied:
                            [self authorityAlertWithController:controller name:@"照片" cancelHandler:cancelHandler];
                            break;
                        default:
                            break;
                    }
                };
                PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
                if (status == PHAuthorizationStatusNotDetermined)
                    [PHPhotoLibrary requestAuthorization:authorization];
                else authorization(status);
            }
                break;
            case KSImagePickerMediaTypeVideo: {
                void(^authorization)(BOOL) = ^(BOOL granted) {
                    if (granted) completionHandler(type);
                    else [self authorityAlertWithController:controller name:@"照相机" cancelHandler:cancelHandler];
                };
                NSString *AVMediaType = AVMediaTypeVideo;
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaType];
                if (status == AVAuthorizationStatusNotDetermined)
                    [AVCaptureDevice requestAccessForMediaType:AVMediaType completionHandler:authorization];
                else authorization(status == AVAuthorizationStatusAuthorized);
            }
                break;
        }
    }
}

+ (void)authorityAlertWithController:(UIViewController *)controller name:(NSString*)name cancelHandler:(void (^)(UIAlertAction *action))cancelHandler {
    if (controller != nil && name != nil) {
        NSBundle *bundle = NSBundle.mainBundle;
        NSString *appName = NSLocalizedStringFromTableInBundle(@"CFBundleDisplayName", @"InfoPlist", bundle, nil);
        NSString *title = [NSString stringWithFormat:@"没有打开“%@”访问权限", name];
        NSString *message = [NSString stringWithFormat:@"请进入“设置”-“%@”打开%@开关", appName, name];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *go = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([application canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [application openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
                } else {
                    [application openURL:url];
                }
            }
            if (cancelHandler != nil) {
                cancelHandler(action);
            }
        }];
        [alert addAction:go];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandler];
        [alert addAction:cancel];
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)authorityAVMediaTypeAudioCheckUpWithController:(UIView *)controller completionHandler:(void(^)(BOOL isOpen))completionHandler cancelHandler:(void (^)(UIAlertAction *action))cancelHandler {
    void(^authorization)(BOOL) = ^(BOOL granted) {
        if (granted) completionHandler(granted);
        else [self authorityAlertWithController:controller name:@"麦克风" cancelHandler:cancelHandler];
    };
    NSString *AVMediaType = AVMediaTypeAudio;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaType];
    if (status == AVAuthorizationStatusNotDetermined)
        [AVCaptureDevice requestAccessForMediaType:AVMediaType completionHandler:authorization];
    else (authorization(status == AVAuthorizationStatusAuthorized));
}

@end
