//
//  imageModel.m
//  PhotoAlbumDemo
//
//  Created by Krishana on 1/16/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

+ (NSMutableArray *)getArrayOfImagesFromModelArray:(NSMutableArray *)imageArray {
    
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< imageArray.count; i++) {
        
        PHAsset *asset = [imageArray objectAtIndex:i];
        ImageModel *model = [[ImageModel alloc] init];
        model.image = asset;
        model.isSelected = false;
        [imgArray addObject:model];
    }
    return imgArray;
}

//+ (NSMutableArray *)updateArrayWithModelValues


@end
