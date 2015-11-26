//
//  AlbumCell.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 25/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *albumName;
@property (strong, nonatomic) IBOutlet UILabel *artistName;

@end
