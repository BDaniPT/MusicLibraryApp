//
//  Artist.m
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import "Artist.h"

@implementation Artist

- (void) artistWithDictionary:(NSDictionary *) artistDictionary {
    
    [self setArtistId:[artistDictionary objectForKey:@"id"]];
    [self setName:[artistDictionary objectForKey:@"name"]];
}

@end
