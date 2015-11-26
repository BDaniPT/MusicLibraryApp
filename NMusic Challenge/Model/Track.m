//
//  Track.m
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import "Track.h"

@implementation Track

- (void) trackWithDictionary:(NSDictionary *) trackDictionary {
    
    [self setTrackId:[trackDictionary objectForKey:@"id"]];
    [self setTitle:[trackDictionary objectForKey:@"title"]];
    [self setAlbumId:[[trackDictionary objectForKey:@"album"] objectForKey:@"id"]];
    [self setAlbumTitle:[[trackDictionary objectForKey:@"album"] objectForKey:@"title"]];
    [self setArtistId:[[trackDictionary objectForKey:@"main_artist"] objectForKey:@"id"]];
    [self setArtist:[[trackDictionary objectForKey:@"main_artist"] objectForKey:@"name"]];
}

@end
