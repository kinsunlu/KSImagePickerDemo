//
//  KSImagePickerAlbumModel.h
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSImagePickerController.h"
#import "KSImagePickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerAlbumModel : NSObject

@property (nonatomic, strong, readonly) PHAssetCollection *assetCollection;
@property (nonatomic, copy, readonly) NSString *albumTitle;
@property (nonatomic, strong, readonly) NSMutableArray <KSImagePickerItemModel *> *assetList;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection mediaType:(KSImagePickerMediaType)mediaType;

+ (NSArray <KSImagePickerAlbumModel *> *)albumModelFromAssetCollections:(NSArray <PHFetchResult<PHAssetCollection *> *> *)assetCollections mediaType:(KSImagePickerMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
