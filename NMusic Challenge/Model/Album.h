//
//  Album.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *artistId;

- (void) albumWithDictionary:(NSDictionary *) albumDictionary;

@end
