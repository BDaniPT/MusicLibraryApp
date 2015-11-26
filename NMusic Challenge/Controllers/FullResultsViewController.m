//
//  FullResultsViewController.m
//  NMusic Challenge
//
//  Created by Bruno Tavares on 25/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import "FullResultsViewController.h"
#import "AFNetworking.h"
#import "Artist.h"
#import "Album.h"
#import "Track.h"
#import "ArtistCell.h"
#import "AlbumCell.h"
#import "EmptyCell.h"
#import "TrackCell.h"
#import "SVPullToRefresh.h"

@interface FullResultsViewController ()

@end

@implementation FullResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView.hidden = NO;
    self.pageAmount = 1;
    self.hasMoreResults = YES;
    
    if ([self.category isEqualToString:@"artists"]) {
        
        self.title = @"More Artists";
        
    } else if([self.category isEqualToString:@"albums"]) {
        
        self.title = @"More Albums";
        
    } else if([self.category isEqualToString:@"tracks"]) {
        
        self.title = @"More Tracks";
    }
    
    [self setupDataSource];
    
    __weak FullResultsViewController *weakSelf = self;
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        if (weakSelf.hasMoreResults) {
            
            [weakSelf insertRowsAtBottom];
            
        } else {
            
            [weakSelf.tableView setShowsInfiniteScrolling:NO];
        }
    }];
}

- (void)setupDataSource {
    
    NSString *refinedSearchText = [self.searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *searchQuery = [NSString stringWithFormat:@"http://services.sapo.pt/Music/OnDemand/Provider/apiv3/find?text=%@&what=%@&page=1&per_page=20",refinedSearchText, self.category];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"JSON: %@", responseObject);
        self.searchResults = responseObject;
        
        NSMutableArray *tempResults = [NSMutableArray arrayWithCapacity:21];
        
        self.resultAmount = [[[self.searchResults objectForKey:self.category] objectForKey:@"results"] count];
        
        if ([self.category isEqualToString:@"artists"]) {
            
            for (NSDictionary *artist in [[self.searchResults objectForKey:@"artists"] objectForKey:@"results"]) {
                
                Artist *newArtist = [Artist new];
                [newArtist artistWithDictionary:artist];
                
                [tempResults addObject:newArtist];
            }
            
        } else if([self.category isEqualToString:@"albums"]) {
            
            for (NSDictionary *album in [[self.searchResults objectForKey:@"albums"] objectForKey:@"results"]) {
                
                Album *newAlbum = [Album new];
                [newAlbum albumWithDictionary:album];
                
                [tempResults addObject:newAlbum];
            }
            
        } else if([self.category isEqualToString:@"tracks"]) {
            
            for (NSDictionary *track in [[self.searchResults objectForKey:@"tracks"] objectForKey:@"results"]) {
                
                Track *newTrack = [Track new];
                [newTrack trackWithDictionary:track];
                
                [tempResults addObject:newTrack];
            }
        }
        
        if (![[[self.searchResults objectForKey:self.category] objectForKey:@"has_more_results"] boolValue]) {
            
            [tempResults addObject:@"no_more_results"];
            [self setHasMoreResults:NO];
        }
        
        self.resultsArray = [tempResults copy];
        
        [self.tableView reloadData];
        self.loadingView.hidden = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.loadingView.hidden = NO;
        
        NSLog(@"Error: %@", error);
    }];
}

- (void)insertRowsAtBottom {
    
    self.pageAmount += 1;
    
    NSString *refinedSearchText = [self.searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *searchQuery = [NSString stringWithFormat:@"http://services.sapo.pt/Music/OnDemand/Provider/apiv3/find?text=%@&what=%@&page=%d&per_page=20",refinedSearchText, self.category, self.pageAmount];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"JSON: %@", responseObject);
        self.searchResults = responseObject;
        
        NSMutableArray *tempResults = [NSMutableArray arrayWithCapacity:21];
        
        self.resultAmount = [[[self.searchResults objectForKey:self.category] objectForKey:@"results"] count];
        
        if ([self.category isEqualToString:@"artists"]) {
            
            for (NSDictionary *artist in [[self.searchResults objectForKey:@"artists"] objectForKey:@"results"]) {
                
                Artist *newArtist = [Artist new];
                [newArtist artistWithDictionary:artist];
                
                [tempResults addObject:newArtist];
            }
            
        } else if([self.category isEqualToString:@"albums"]) {
            
            for (NSDictionary *album in [[self.searchResults objectForKey:@"albums"] objectForKey:@"results"]) {
                
                Album *newAlbum = [Album new];
                [newAlbum albumWithDictionary:album];
                
                [tempResults addObject:newAlbum];
            }
            
        } else if([self.category isEqualToString:@"tracks"]) {
            
            for (NSDictionary *track in [[self.searchResults objectForKey:@"tracks"] objectForKey:@"results"]) {
                
                Track *newTrack = [Track new];
                [newTrack trackWithDictionary:track];
                
                [tempResults addObject:newTrack];
            }
        }
        
        if (![[[self.searchResults objectForKey:self.category] objectForKey:@"has_more_results"] boolValue]) {
            
            [tempResults addObject:@"no_more_results"];
            [self setHasMoreResults:NO];
        }
        
        self.resultsArray = [self.resultsArray arrayByAddingObjectsFromArray:tempResults];
        
        [self.tableView beginUpdates];
        
        for (NSInteger newRow = (self.pageAmount - 1) * 20; newRow < (self.pageAmount - 1) * 20 + tempResults.count; newRow++) {
            
            [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:newRow inSection:0]];
        }

        [self.tableView endUpdates];
        
        [self.tableView.infiniteScrollingView stopAnimating];
        self.loadingView.hidden = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.loadingView.hidden = NO;
        
        NSLog(@"Error: %@", error);
    }];
}

- (void) insertRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.resultsArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        
        EmptyCell *cell = (EmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        return cell;
    }
    
    if ([self.category isEqualToString:@"artists"]) {
        
        ArtistCell *cell = (ArtistCell *)[tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ArtistCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://catalogv3.nmusic.sapo.pt/artists/%@/300",((Artist *)[self.resultsArray objectAtIndex:indexPath.row]).artistId]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        cell.nameLabel.text = ((Artist *)[self.resultsArray objectAtIndex:indexPath.row]).name;
        
        CALayer *imageLayer = cell.image.layer;
        [imageLayer setCornerRadius:25];
        [imageLayer setMasksToBounds:YES];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Response: %@", responseObject);
            
            cell.image.alpha = 0;
            
            cell.image.image = responseObject;
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{ cell.image.alpha = 1; }
                             completion:^(BOOL finished){}
             ];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{ cell.image.alpha = 1; }
                             completion:^(BOOL finished){}
             ];
        }];
        [requestOperation start];
        
        return cell;
        
    } else if([self.category isEqualToString:@"albums"]) {
        
        AlbumCell *cell = (AlbumCell *)[tableView dequeueReusableCellWithIdentifier:@"AlbumCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://catalogv3.nmusic.sapo.pt/albums/%@/300",((Album *)[self.resultsArray objectAtIndex:indexPath.row]).albumId]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        cell.albumName.text = ((Album *)[self.resultsArray objectAtIndex:indexPath.row]).title;
        cell.artistName.text = ((Album *)[self.resultsArray objectAtIndex:indexPath.row]).artist;
        
        CALayer *imageLayer = cell.image.layer;
        [imageLayer setCornerRadius:25];
        [imageLayer setMasksToBounds:YES];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Response: %@", responseObject);
            
            cell.image.alpha = 0;
            
            cell.image.image = responseObject;
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{ cell.image.alpha = 1; }
                             completion:^(BOOL finished){}
             ];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{ cell.image.alpha = 1; }
                             completion:^(BOOL finished){}
             ];
        }];
        [requestOperation start];
        
        return cell;
        
    } else if([self.category isEqualToString:@"tracks"]) {
        
        TrackCell *cell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrackCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.artistLabel.text = ((Track *)[self.resultsArray objectAtIndex:indexPath.row]).artist;
        cell.albumLabel.text = ((Track *)[self.resultsArray objectAtIndex:indexPath.row]).albumTitle;
        cell.trackLabel.text = ((Track *)[self.resultsArray objectAtIndex:indexPath.row]).title;
        
        return cell;
    }
    
    // backup for any failures
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    return cell;
}

@end
