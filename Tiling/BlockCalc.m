//
//  BlockCalc.m
//  Tiling
//
//  Created by Ken Thomsen on 3/11/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import "BlockCalc.h"
#import "NSMutableArray+bitmaskRepresentationOfRow.h"

@implementation BlockCalc

@synthesize height;
@synthesize width;
@synthesize possibleWalls;
@synthesize possibleRows;
@synthesize bitwiseComparator;

/*
 working with decimals is a pain, so we will reduce the width to units and only work with those.
 since the blocks available are all 1x3" or 1x4.5", dividing the width by 1.5
 gives blocks of 1x2u and 1x3u
 */
@synthesize widthInUnits;

-(id) initWithWidth:(double)newWidth andHeight:(int)newHeight
{
	if (self = [super init])
	{
		self.height = newHeight;
		self.width = newWidth;
        self.widthInUnits = (newWidth /1.5);
        self.possibleWalls = [self getEnumeratedBitmaskedPermutations];
        self.bitwiseComparator = pow(2,self.widthInUnits)+1;
        self.possibleRows = [self.possibleWalls valueForKeyPath:@"@unionOfArrays.self"];
		return self;
	}
	return nil;
}

//convenience initializer
+ (BlockCalc *) wallWithWidth:(double)width andHeight:(int)height
{
	BlockCalc *blockToReturn = [[BlockCalc alloc] initWithWidth:width andHeight:height];
	
	return blockToReturn;		
}

//takes width in inches, and returns a number permutations recursively
+ (int64_t) permutationsForWidth:(int)inputWidth
{
	switch (inputWidth)
	{
		case 1:
			return 0;
		case 2:
			return 1;
		case 3:
			return 1;
	}
	int	permutationsWithFirstBlockOf2 = [self permutationsForWidth:(inputWidth - 2)];
	int permutationsWithFirstBlockOf3 = [self permutationsForWidth:(inputWidth - 3)];
	
	return (permutationsWithFirstBlockOf2 + permutationsWithFirstBlockOf3);
}

//begin instance methods
//-------------------------------------------------------------------------------------------


//takes width and height in inches, returns the total permutations
- (int64_t) calcPermutations
{
    int64_t permutationsForWidthCount = [BlockCalc permutationsForWidth:self.widthInUnits];
	int64_t totalLegalPermutations;
    
    //calculating permutations for a wall of height 1 is the same as calculating permutations for a single row
    
    NSAssert((self.height >=1),@"Height should be a whole number");
    
    if (self.height ==1)
    {        
        return permutationsForWidthCount;
    }
    //if the height is greater than one, then we need to figure out legal row pairings
	else
	{       
        totalLegalPermutations = [[self enumerateWallPermutationsGivenHeight:self.height] count];         
    }  
    
    return totalLegalPermutations;
}

//recursively enumerates walls given a height 
-(NSMutableArray *) enumerateWallPermutationsGivenHeight:(int)heightOfWall
{	
    NSMutableArray *wallsToReturn = [NSMutableArray array];
    //base case returns an array with each line option
    if (heightOfWall == 1)
    {
		return [self.possibleWalls mutableCopy];
    }
    else 
    {
        //walls == case(n-1)
        NSMutableArray *walls = [self enumerateWallPermutationsGivenHeight:(heightOfWall-1)];
        //wallsToReturn == case(n)
        //check that row vs all possible pairs
        //for each legal pair, add the corresponding row to thewall and the wall to wallsToReturn
        
        //for each wall, grab the topmost row
        for (NSMutableArray *wall in walls)
        {
#ifdef DEBUG
            NSLog(@"legal wall:%@",[wall description]);
#endif
            //index is heightOfWall-2 because we want to work with the "next row down"
            //from the height we're calling this for
            //and an additional - 1 since indices start at 0
            NSAssert((heightOfWall >=2),
                     @"should not reach this point with heightOfWall <2. If we do it will throw an exception");
            
            NSNumber *topRow = [wall objectAtIndex:(heightOfWall-2)];
            //compare the top row to each possible row
            
            
            for (NSNumber *rowToAdd in self.possibleRows)
            {
                if ([rowToAdd isNotEqualTo:topRow])
                {
                    //compare the topRow and rowToAdd to see if they are compatible
                    //if a bitwise AND of bitmasks shows they are a legal pair
                    //we add it to the top of the wall, and add that into the new array of wallsToReturn
                    int64_t bitwiseVal = [topRow longLongValue] & [rowToAdd longLongValue];                    
                    
                    if (bitwiseVal == self.bitwiseComparator)
                    {
                        NSMutableArray *newWall = [NSMutableArray arrayWithArray:wall];
                        [newWall addObject:rowToAdd];
                        [wallsToReturn addObject:newWall];
#ifdef DEBUG
                        NSLog(@"new wall being added:%@",wall);
#endif
                    }
                }
                
                
            }                          
        }  
    }
#ifdef DEBUG
    NSLog(@"%@ = %lu walls being returned for height =%i",[wallsToReturn description],[wallsToReturn count],heightOfWall);
#endif
    
    return wallsToReturn;
}

//returns an array of arrays
//each of those arrays is a single potential row in bitmask form
-(NSMutableArray *) getEnumeratedBitmaskedPermutations
{
    //get all possible rows
    NSMutableArray *permutations = [self enumerateRowPermutationsForWidth:widthInUnits];
    NSMutableArray *permutationsBitmasks = [NSMutableArray array];
    //for each possible row
    for (NSMutableArray *permutation in permutations)
    {
        //take the bitmask
        int64_t bitmask = [permutation bitmaskRepresentationOfRow];
        //and place into a new array
        NSMutableArray *protoWall = [NSMutableArray arrayWithObject:[NSNumber numberWithLongLong:bitmask]];
        //then place that array into the array we're going to return
        [permutationsBitmasks addObject:protoWall];
        
        //we need "walls" as arrays of their own for later
    }
    //leaving us with an array of the bitmasks
#ifdef DEBUG
    NSLog(@"Bitmask walls:%@",[permutationsBitmasks description]);
#endif
    return permutationsBitmasks;
}

//enumerates permutations of a single row recursively
-(NSMutableArray *) enumerateRowPermutationsForWidth:(int)_widthInUnits
{
    //base cases for recursive method
    if (_widthInUnits <= 1)
        return [NSMutableArray array];
    switch (_widthInUnits)
    {
        case 2:
            return [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:2]]];
        case 3:
            return [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:3]]];
            /*
             case 4:
             {
             Row *rowOf22 = [Row arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:2],nil];
             return [NSMutableArray arrayWithObject:rowOf22];
             }
             case 5:
             {
             Row *rowOf32 = [Row arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2],nil];
             Row *rowOf23 = [Row arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
             return [NSMutableArray arrayWithObjects:rowOf32,rowOf23, nil];
             }   
             */
    }
    
    NSMutableArray *enumeratedPermutationsForWidth = [NSMutableArray array];
    
    //for each row with (width-2), get an array of its ordered contents	
    NSMutableArray *permutationsWithout2 = [NSMutableArray arrayWithObject:[self enumerateRowPermutationsForWidth:(_widthInUnits - 2)]];
    //append a 2 to each
    NSMutableArray *permutationsWith2 = [[NSMutableArray alloc] init];
    for (NSMutableArray *column in permutationsWithout2)
    {
        for (NSMutableArray *row in column)
        {
            [row addObject:[NSNumber numberWithInt:2]];
            [permutationsWith2 addObject:row];
        }
    }
    //add those into our list
    [enumeratedPermutationsForWidth addObjectsFromArray:permutationsWith2];
    
    //do the same for each row with (width-3)
    
    NSMutableArray *permutationsWithout3 = [NSMutableArray arrayWithObject:[self enumerateRowPermutationsForWidth:(_widthInUnits - 3)]];
    //append a 3 to each
    NSMutableArray *permutationsWith3 = [[NSMutableArray alloc]init];
    for (NSMutableArray *column in permutationsWithout3)
    {
        for (NSMutableArray *row in column)
        {
            [row addObject:[NSNumber numberWithInt:3]];
            [permutationsWith3 addObject:row];
        }
    }
    //add those into our list
    [enumeratedPermutationsForWidth addObjectsFromArray:permutationsWith3];
#ifdef DEBUG
    //NSLog(@"Columns after rowsWith3 for width %i:%@",widthInUnits,enumeratedPermutationsForWidth);
    NSLog(@"columns for width %i:%@",_widthInUnits,enumeratedPermutationsForWidth);
#endif    
    return enumeratedPermutationsForWidth;
}



@end


/*
 Pairings code I cut for performance reasons, may want for reference:
 
 #ifdef DEBUG
 NSLog(@"Building set of legal pairs...");
 #endif
 //find all legal pairs of rows
 NSMutableSet *legalPairings = [[NSMutableSet alloc] init];
 for (int y = 0;y < [permutationsForWidth count];y++)
 {            
 int64_t baseRow = [[permutationsForWidth objectAtIndex:y] longLongValue];
 
 for (int z = 0;z < [permutationsForWidth count];z++)
 {
 //avoid comparing the row to itself
 if (y !=z)
 {
 int64_t rowToCompare = [[permutationsForWidth objectAtIndex:z] longLongValue];
 //if a bitwise AND of bitmasks shows they are a legal pair
 //so we log it in our array of legal pairs if it's not already there
 int64_t bitwiseVal = rowToCompare & baseRow;
 //should have two "edges" on either end, so define that bitmask
 int64_t bitwiseComp = pow(2,self.widthInUnits)+1;
 if ((rowToCompare & baseRow) == bitwiseComp)
 {
 NSSet *pairing = [NSSet setWithObjects:[NSNumber numberWithInt:y],
 [NSNumber numberWithInt:z],nil];
 [legalPairings addObject:pairing];
 }                     
 }
 }
 }
 
 #ifdef DEBUG
 NSLog(@"%@",[legalPairings description]);
 NSLog(@"Legal pair count:%lu",[legalPairings count]);
 #endif
 */
//phew! So we now have a set of all legal pairings
//TODO: build some walls!

