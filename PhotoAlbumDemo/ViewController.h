//
//  ViewController.h
//  PhotoAlbumDemo
//
//  Created by Krishana on 1/13/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/**
 *  Reference to Scroll View containg all top album items
 */
@property (weak) IBOutlet UIScrollView *albumScrollView;

@property (weak, nonatomic) IBOutlet UIView *albumView;

@property (weak, nonatomic) IBOutlet UILabel *labelAlbumName;
@property (weak, nonatomic) IBOutlet UITableView *tblViewImage;

@end

