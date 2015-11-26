//
//  Album.m
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import "Album.h"

@implementation Album

- (void) albumWithDictionary:(NSDictionary *) albumDictionary {
    
    [self setTitle:[albumDictionary objectForKey:@"title"]];
    [self setAlbumId:[albumDictionary objectForKey:@"id"]];
    [self setArtistId:[[albumDictionary objectForKey:@"main_artist"] objectForKey:@"id"]];
    [self setArtist:[[albumDictionary objectForKey:@"main_artist"] objectForKey:@"name"]];
}

@end
