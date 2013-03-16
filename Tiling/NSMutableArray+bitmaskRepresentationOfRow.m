//
//  NSMutableArray+bitmaskRepresentationOfRow.m
//  Tiling
//
//  Created by Benjamin McCloskey on 3/16/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import "NSMutableArray+bitmaskRepresentationOfRow.h"

@implementation NSMutableArray (bitmaskRepresentationOfRow)

/*
 //creates a bitmask representation such that a 1 occurs at each "potential break" between blocks
 
 this allows us to apply a bitwise AND to determine if there are any breaks that line up
 thus a bitwise AND of two blocks 8 units long will = 10000001
 
 i.e. a row of 4 blocks of 2units = 2,2,2,2 = 101010101
 a row = 3,3,2   = 100100101
 -------------
 100000101 = illegal row pair
 
 i.e. a row of 4 blocks of 2units = 2,2,2,2 = 101010101
 a row = 3,2,3   = 100101001
 -------------
 100000001 = legal row pair
 
 */
-(int64_t) bitmaskRepresentationOfRow;
{
	//bitmask starts with a 1 since the "ends" of the bitmask will always be "edges"
    int64_t bitmask = 1;
    //then for each number in the array of numbers (where a number = a block of n units)
	for (NSNumber *block in self)
    {
		//shift the bits left a number of times = the number (so a 2 will shift everything 2 bits, and a 3 will shift
        int blockVal = [block intValue];
        bitmask = bitmask << blockVal;
        bitmask++;
    }
    return bitmask;
}
@end
