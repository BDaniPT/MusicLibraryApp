//
//  TrackCell.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 25/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *trackLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumLabel;

@end
