//
//  Artist.h
//  NMusic Challenge
//
//  Created by Bruno Tavares on 24/11/15.
//  Copyright © 2015 Bruno Tavares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject

@property (strong, nonatomic) NSString *artistId;
@property (strong, nonatomic) NSString *name;

- (void) artistWithDictionary:(NSDictionary *) artistDictionary;

@end
