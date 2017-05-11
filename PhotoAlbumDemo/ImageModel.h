//
//  imageModel.h
//  PhotoAlbumDemo
//
//  Created by Krishana on 1/16/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ImageModel : NSObject

@property(strong, nonatomic) PHAsset *image;
@property(assign, nonatomic) BOOL isSelected;


+ (NSMutableArray *)getArrayOfImagesFromModelArray:(NSMutableArray *)imageArray;

@end
