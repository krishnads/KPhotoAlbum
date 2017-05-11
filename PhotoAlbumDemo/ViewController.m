//
//  ViewController.m
//  PhotoAlbumDemo
//
//  Created by Krishana on 1/13/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "ImageModel.h"

#define kDefaultEdgeInsets UIEdgeInsetsMake(5, 20, 5, 20)


@interface ViewController () {
    NSMutableArray *albumArray;
    NSMutableArray *imageArray;
    PHImageManager *manager;
    PHImageRequestOptions *requestOptions;
    
    NSMutableArray *selectImageArray;
    NSMutableArray *arrayOfArray;
    int selectedButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    manager = [PHImageManager defaultManager];
    requestOptions = [[PHImageRequestOptions alloc] init];
    albumArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    selectImageArray = [[NSMutableArray alloc] init];
    selectedButton = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:userAlbumsOptions];
    
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        NSLog(@"album title %@", collection.localizedTitle);
        [albumArray addObject:collection];
    }];
    [self addAlbumInScroll:albumArray];
    arrayOfArray = [[NSMutableArray alloc] initWithCapacity:albumArray.count];
}

#pragma mark - Add Menu Buttons in Menu Scroll View
-(void) addAlbumInScroll:(NSArray *)albArray {
    
    
    CGFloat buttonHeight = self.albumScrollView.frame.size.height;
    CGFloat cWidth = 0.0f;
    
    for (int i = 0 ; i< albArray.count; i++) {
        PHAssetCollection *collection = [albArray objectAtIndex:i];
        NSString *tagTitle = collection.localizedTitle;
        CGFloat buttonWidth = [self widthForMenuTitle:tagTitle buttonEdgeInsets:kDefaultEdgeInsets];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(cWidth, 0.0f, buttonWidth, buttonHeight);
        [button setTitle:tagTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        //[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.albumScrollView addSubview:button];
        cWidth += buttonWidth;
    }
    
    NSLog(@"scroll menu width->%f",cWidth);
    self.albumScrollView.contentSize = CGSizeMake(cWidth, self.albumScrollView.frame.size.height);
}

- (void)buttonPressed:(UIButton *)button {
    
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    [self.tblViewImage reloadData];
    
    selectedButton = (int) button.tag;
    //NSLog(@"tag->%lu", (unsigned long)button.tag);
    PHFetchOptions *onlyImagesOptions = [PHFetchOptions new];
    PHAssetCollection *collection = [albumArray objectAtIndex:button.tag];
    onlyImagesOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:onlyImagesOptions];
    NSLog(@"count->%lu", (unsigned long)result.count);

    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        //NSLog(@"asset %@", asset);
        [imgArray addObject:asset];
    }];
    
    
    if (arrayOfArray.count <= selectedButton) {
        NSMutableArray *imageArr =  [ImageModel getArrayOfImagesFromModelArray:imgArray];
        [arrayOfArray addObject:imageArr];

    }
    else {
        NSMutableArray *imageArr = [arrayOfArray objectAtIndex:selectedButton];
        if (imageArr.count == 0) {
            imageArr =  [ImageModel getArrayOfImagesFromModelArray:imgArray];
            [arrayOfArray addObject:imageArr];
        }
        else {
            [arrayOfArray replaceObjectAtIndex:selectedButton withObject:imageArr];
        }
    }

//    if (arrayOfArray.count == 0) {
//        imageArr =  [ImageModel getArrayOfImagesFromModelArray:imgArray];
//        [arrayOfArray addObject:imageArr];
//    }
//    else {
//        
//    }
    
    

    
    NSLog(@"going to reloadtable");
    [self.tblViewImage reloadData];
}


#pragma mark - Calculate width of menu button
- (CGFloat)widthForMenuTitle:(NSString *)title buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    
    CGSize size = [title sizeWithAttributes:attributes];
    return CGSizeMake(size.width + buttonEdgeInsets.left + buttonEdgeInsets.right, size.height + buttonEdgeInsets.top + buttonEdgeInsets.bottom).width;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrayOfArray.count == 0) {
        return 0;
    }
    NSArray *imageArr = [arrayOfArray objectAtIndex:selectedButton];
    return imageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        //cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    //cell.imageView.image = [imageArray objectAtIndex:indexPath.row];
    
    NSArray *imageArr = [arrayOfArray objectAtIndex:selectedButton];
    ImageModel *model = [imageArr objectAtIndex:indexPath.row];
    PHAsset *asset = model.image;
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    [manager requestImageForAsset:asset
                       targetSize:PHImageManagerMaximumSize
                      contentMode:PHImageContentModeDefault
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                        if (image) {
                                cell.imageView.image = image;
                        }
    }];
    if (model.isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *imageArr = [arrayOfArray objectAtIndex:selectedButton];
    ImageModel *model = [imageArr objectAtIndex:indexPath.row];    PHAsset *asset = model.image;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (selectImageArray.count > 0) {
            for (PHAsset *iAsset in selectImageArray) {
                if (iAsset == asset) {
                    [selectImageArray removeObject:iAsset];
                    break;
                }
            }
        }
        model.isSelected = false;
        [imageArr replaceObjectAtIndex:indexPath.row withObject:model];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectImageArray addObject:asset];
        model.isSelected = true;
        [imageArr replaceObjectAtIndex:indexPath.row withObject:model];
    }
    [arrayOfArray replaceObjectAtIndex:selectedButton withObject:imageArr];
    NSLog(@"selected array-> %@", selectImageArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
