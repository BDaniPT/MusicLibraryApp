//
//  SearchViewController.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 20/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) NSDictionary *searchResults;
@property (strong, nonatomic) NSArray *artistArray;
@property (strong, nonatomic) NSArray *albumArray;
@property (strong, nonatomic) NSArray *trackArray;
@property (assign, nonatomic) NSInteger artistAmount;
@property (assign, nonatomic) NSInteger albumAmount;
@property (assign, nonatomic) NSInteger trackAmount;

@end
