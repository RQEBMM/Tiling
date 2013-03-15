//
//  BlockCalc.h
//  Tiling
//
//  Created by Ken Thomsen on 3/11/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockCalc : NSObject

@property int height;
@property double width;

+ (BlockCalc *) wallWithWidth:(double)width andHeight:(int)height;

- (int64_t) calcPermutations;

@end
