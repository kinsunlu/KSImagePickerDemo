//
//  KSImagePickerAlbumModel.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerAlbumModel.h"

@implementation KSImagePickerAlbumModel

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection mediaType:(KSImagePickerMediaType)mediaType {
    NSAssert(assetCollection != nil, @"assetCollection不可以为nil");
    if (self = [super init]) {
        _assetCollection = assetCollection;
        _albumTitle = assetCollection.localizedTitle;
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        NSMutableArray <KSImagePickerItemModel *> *assetList = [NSMutableArray arrayWithCapacity:assets.count+1];
        BOOL isCameraRoll = assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
        if (isCameraRoll) {
            KSImagePickerItemModel *itemModel = [[KSImagePickerItemModel alloc] init];
            itemModel.cameraCell = YES;
            [assetList addObject:itemModel];
        }
        for (NSInteger i = assets.count-1; i >= 0; i--) {
            PHAsset *asset = [assets objectAtIndex:i];
            PHAssetMediaType type = asset.mediaType;
            if ((PHAssetMediaType)mediaType != type) continue;
            KSImagePickerItemModel *itemModel = [[KSImagePickerItemModel alloc] initWithAsset:asset];
            [assetList addObject:itemModel];
        }
        _assetList = assetList;
    }
    return self;
}

+ (NSArray <KSImagePickerAlbumModel *> *)albumModelFromAssetCollections:(NSArray <PHFetchResult<PHAssetCollection *> *> *)assetCollections mediaType:(KSImagePickerMediaType)mediaType {
    NSMutableArray <KSImagePickerAlbumModel *> *array = [NSMutableArray array];
    for (PHFetchResult<PHAssetCollection *> *result in assetCollections) {
        for (PHAssetCollection *assetCollection in result) {
            BOOL isCameraRoll = assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
            KSImagePickerAlbumModel *albumModel = [[KSImagePickerAlbumModel alloc] initWithAssetCollection:assetCollection mediaType:mediaType];
            if (isCameraRoll) {
                [array insertObject:albumModel atIndex:0];
            } else if (albumModel.assetList.count > 0) {
                [array addObject:albumModel];
            }
        }
    }
    return array;
}

@end
