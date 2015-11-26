//
//  Track.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSString *trackId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSString *albumTitle;
@property (strong, nonatomic) NSString *artistId;
@property (strong, nonatomic) NSString *artist;

- (void) trackWithDictionary:(NSDictionary *) trackDictionary;

@end
