//
//  SearchViewController.m
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewController.h"
#import "FullResultsViewController.h"
#import "AFNetworking.h"
#import "Artist.h"
#import "Album.h"
#import "Track.h"
#import "ArtistCell.h"
#import "AlbumCell.h"
#import "EmptyCell.h"
#import "SeeMoreCell.h"
#import "TrackCell.h"

@interface SearchViewController ()

@end

@implementation SearchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"Search";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.placeholder = @"Search...";
    self.searchBar.delegate = self;
    
    if ([self.searchBar.text isEqualToString:@""]) {
        
        self.loadingView.hidden = NO;
        self.loadingIndicator.hidden = YES;
    }
}

// When you click on search, the keyboard will close
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
}

// Search whenever the search bar text is changed, which will end up being something like an auto-complete feature
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.loadingView.hidden = NO;
    self.loadingIndicator.hidden = NO;
    
    if ([searchText isEqualToString:@""]) {
        
        self.loadingIndicator.hidden = YES;
        
    } else {
        
        NSString *refinedSearchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *searchQuery = [NSString stringWithFormat:@"http://services.sapo.pt/Music/OnDemand/Provider/apiv3/find?text=%@&what=albums,artists,tracks&page=1&per_page=5",refinedSearchText];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:searchQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"JSON: %@", responseObject);
            self.searchResults = responseObject;
            
            NSMutableArray *tempArtists = [NSMutableArray arrayWithCapacity:5];
            NSMutableArray *tempAlbums = [NSMutableArray arrayWithCapacity:5];
            NSMutableArray *tempTracks = [NSMutableArray arrayWithCapacity:5];
            
            self.artistAmount = [[[self.searchResults objectForKey:@"artists"] objectForKey:@"results"] count];
            self.albumAmount = [[[self.searchResults objectForKey:@"albums"] objectForKey:@"results"] count];
            self.trackAmount = [[[self.searchResults objectForKey:@"tracks"] objectForKey:@"results"] count];
            
            for (NSDictionary *artist in [[self.searchResults objectForKey:@"artists"] objectForKey:@"results"]) {
                
                Artist *newArtist = [Artist new];
                [newArtist artistWithDictionary:artist];
                
                [tempArtists addObject:newArtist];
            }
            
            self.artistArray = [tempArtists copy];
            
            for (NSDictionary *album in [[self.searchResults objectForKey:@"albums"] objectForKey:@"results"]) {
                
                Album *newAlbum = [Album new];
                [newAlbum albumWithDictionary:album];
                
                [tempAlbums addObject:newAlbum];
            }
            
            self.albumArray = [tempAlbums copy];
            
            for (NSDictionary *track in [[self.searchResults objectForKey:@"tracks"] objectForKey:@"results"]) {
                
                Track *newTrack = [Track new];
                [newTrack trackWithDictionary:track];
                
                [tempTracks addObject:newTrack];
            }
            
            self.trackArray = [tempTracks copy];
            
            [self.tableView reloadData];
            self.loadingIndicator.hidden = YES;
            self.loadingView.hidden = YES;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            self.loadingIndicator.hidden = YES;
            
            NSLog(@"Error: %@", error);
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.searchBar.text isEqualToString:@""]) {
        
        return 0;
    }
    
    return self.searchResults.count-1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchBar.text isEqualToString:@""]) {
        
        return 0;
    }
    
    if (section == 0 && self.artistAmount == 5) {
        
        return 6;
        
    } else if (section == 0) {
        
        return self.artistAmount;
        
    } else if (section == 1 && self.trackAmount == 5) {
        
        return 6;
        
    } else if (section == 1) {
        
        return self.trackAmount;
        
    } else if (section == 2 && self.albumAmount == 5) {
        
        return 6;
        
    } else if (section == 2) {
        
        return self.albumAmount;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 60.0)];
    headerView.backgroundColor = [UIColor colorWithRed:0.117 green:0.117 blue:0.117 alpha:1.0];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(15.0, 30.0, headerView.frame.size.width, 20.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont systemFontOfSize:18.0]];
    [headerLabel setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]];
    
    [headerView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            headerLabel.text = @"Artists";
            break;
        case 1:
            headerLabel.text = @"Tracks";
            break;
        case 2:
            headerLabel.text = @"Albums";
            break;
            
        default:
            break;
    }
    
    return headerView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // For "show more artists" cell
    if (indexPath.section == 0 && indexPath.row == self.artistAmount) {
        
        FullResultsViewController *fullResults = [[FullResultsViewController alloc] initWithNibName:@"FullResultsViewController" bundle:nil];
        
        fullResults.category = @"artists";
        fullResults.searchText = self.searchBar.text;
        
        [self.navigationController pushViewController:fullResults animated:YES];
        
        NSLog(@"clicked on \"show more artists\"");
        
    // For "show more tracks" cell
    } else if (indexPath.section == 1 && indexPath.row == self.trackAmount) {
        
        FullResultsViewController *fullResults = [[FullResultsViewController alloc] initWithNibName:@"FullResultsViewController" bundle:nil];
        
        fullResults.category = @"tracks";
        fullResults.searchText = self.searchBar.text;
        
        [self.navigationController pushViewController:fullResults animated:YES];
        
        NSLog(@"clicked on \"show more tracks\"");
        
    // For "show more albums" cell
    } else if (indexPath.section == 2 && indexPath.row == self.albumAmount) {
        
        FullResultsViewController *fullResults = [[FullResultsViewController alloc] initWithNibName:@"FullResultsViewController" bundle:nil];
        
        fullResults.category = @"albums";
        fullResults.searchText = self.searchBar.text;
        
        [self.navigationController pushViewController:fullResults animated:YES];
        
        NSLog(@"clicked on \"show more albums\"");
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // For artist cells
    if (indexPath.section == 0 && indexPath.row != self.artistAmount) {
        
        ArtistCell *cell = (ArtistCell *)[tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ArtistCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://catalogv3.nmusic.sapo.pt/artists/%@/300",((Artist *)[self.artistArray objectAtIndex:indexPath.row]).artistId]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        cell.nameLabel.text = ((Artist *)[self.artistArray objectAtIndex:indexPath.row]).name;
        
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
    
    // For "show more artists" cell
    } else if (indexPath.section == 0 && indexPath.row == self.artistAmount) {
        
        SeeMoreCell *cell = (SeeMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"SeeMoreCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeeMoreCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.label.text = @"See more artists...";
        
        return cell;
        
    // For track cells
    } else if (indexPath.section == 1 && indexPath.row != self.trackAmount) {
        
        TrackCell *cell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrackCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        cell.artistLabel.text = ((Track *)[self.trackArray objectAtIndex:indexPath.row]).artist;
        cell.albumLabel.text = ((Track *)[self.trackArray objectAtIndex:indexPath.row]).albumTitle;
        cell.trackLabel.text = ((Track *)[self.trackArray objectAtIndex:indexPath.row]).title;
        
        return cell;
        
    // For "show more tracks" cell
    } else if (indexPath.section == 1 && indexPath.row == self.trackAmount) {
        
        SeeMoreCell *cell = (SeeMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"SeeMoreCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeeMoreCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.label.text = @"See more tracks...";
        
        return cell;
        
    // For album cells
    } else if (indexPath.section == 2 && indexPath.row != self.albumAmount) {
        
        AlbumCell *cell = (AlbumCell *)[tableView dequeueReusableCellWithIdentifier:@"AlbumCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://catalogv3.nmusic.sapo.pt/albums/%@/300",((Album *)[self.albumArray objectAtIndex:indexPath.row]).albumId]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        cell.albumName.text = ((Album *)[self.albumArray objectAtIndex:indexPath.row]).title;
        cell.artistName.text = ((Album *)[self.albumArray objectAtIndex:indexPath.row]).artist;
        
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
        
    // For "show more albums" cell
    } else if (indexPath.section == 2 && indexPath.row == self.albumAmount) {
        
        SeeMoreCell *cell = (SeeMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"SeeMoreCell"];
        
        if(cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeeMoreCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.label.text = @"See more albums...";
        
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