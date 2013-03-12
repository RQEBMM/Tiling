//
//  Row.h
//  Tiling
//
//  Created by Ken Thomsen on 3/12/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Row : NSMutableArray

@property int widthInUnits;

-(Row *) bitmaskRepresentations;

@end
