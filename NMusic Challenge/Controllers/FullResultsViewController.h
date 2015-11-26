//
//  FullResultsViewController.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 25/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSDictionary *searchResults;
@property (strong, nonatomic) NSArray *resultsArray;
@property (assign, nonatomic) NSInteger resultAmount;
@property (assign, nonatomic) NSInteger pageAmount;
@property (assign, nonatomic) BOOL hasMoreResults;

@end
