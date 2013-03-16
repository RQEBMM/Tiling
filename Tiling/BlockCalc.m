//
//  BlockCalc.m
//  Tiling
//
//  Created by Ken Thomsen on 3/11/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import "BlockCalc.h"

@implementation BlockCalc

@synthesize height;
@synthesize width;
@synthesize widthInUnits;

-(id) initWithWidth:(double)newWidth andHeight:(int)newHeight
{
	if (self = [super init])
	{
		self.height = newHeight;
		self.width = newWidth;
        self.widthInUnits = (newWidth /1.5);
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

//takes width and height in inches, returns total permutations
- (int64_t) calcPermutations
{
	int permutationsPerWidth = [self permutationsForWidth:self.widthInUnits];
	
	int64_t totalLegalPermutations;
	if (self.height > 1)
	{		
		NSMutableArray *permutationsForWidth = [self enumeratePermutationsForWidth:self.widthInUnits];
		//replace each row element of the array with its bitmask
		for (int x = 0;x < [permutationsForWidth count];x++)
		{
            int64_t bitmask = [self bitmaskRepresentationFor:[permutationsForWidth objectAtIndex:x]];
			NSNumber *bitmaskNumber = [NSNumber numberWithLongLong:bitmask];
			[permutationsForWidth replaceObjectAtIndex:x withObject:bitmaskNumber];
		}
		
		/*
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
		 */
#ifdef DEBUG
        NSLog(@"%@",[legalPairings description]);
        NSLog(@"Legal pair count:%lu",[legalPairings count]);
#endif
        //phew! So we now have a set of all legal pairings
        //TODO: build some walls!
        totalLegalPermutations = [[self enumerateWallPermutationsGivenHeight:self.height] count];         
    }
    
    
    else
        totalLegalPermutations = [[self enumeratePermutationsForWidth:self.widthInUnits] count];
#ifdef DEBUG
    NSArray *columns = [NSArray arrayWithArray:[self enumeratePermutationsForWidth:self.widthInUnits]];
    for (NSArray *column in columns)
    {
        [self bitmaskRepresentationFor:column];
    }
#endif
    return totalLegalPermutations;
}

//takes width in inches, and returns permutations recursively
- (int) permutationsForWidth:(int)inputWidth
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

-(NSArray *) enumerateWallPermutationsGivenHeight:(int)heightOfWall
{
#ifndef DEBUG
	return nil;
#endif
	
	
    NSMutableArray *wallsToReturn = [[NSMutableArray alloc] init];
    //base case returns an array with each line option
    //by taking unique portions of all legal pairs
    if (heightOfWall == 1)
    {        
		return [[self enumerateWallPermutationsGivenHeight:1] bitMaskRepresentation];
    }
    else 
    {
        NSArray *walls = [self enumerateWallPermutationsGivenLegalPairs:legalPairs andHeight:(heightOfWall-1)];
        //for each wall, grab the topmost row
        //check that row # vs all legal pairs
        //for each legal pair, add the corresponding row to the wallsToReturn
        //TODO:better flow than infinite for(if(for(if))). SO MANY BRACKETS
        for (NSMutableArray *wall in walls)
        {
#ifdef DEBUG
            NSLog(@"legal wall:%@",[wall description]);
#endif
            int topOfWall = (heightOfWall - 2);
            NSNumber *rowToCompareWith = [wall objectAtIndex:topOfWall];
            for (NSSet *pair in legalPairs)
            {
                if ([pair containsObject:rowToCompareWith])
                {
                    for(NSNumber *rowToAdd in pair)
                    {
                        if ([rowToAdd isNotEqualTo:rowToCompareWith])
                        {
                            NSMutableArray *wallToAdd = [NSMutableArray arrayWithArray:wall];
                            [wallToAdd addObject:rowToAdd];
                            [wallsToReturn addObject:wallToAdd];
#ifdef DEBUG
                            //NSLog(@"row being added:%@ from pair %@ to form wall:%@",rowToAdd,pair,wall);
#endif
                            
                        }
                    }                    
                }
            }
        }  
    }
#ifdef DEBUG
    NSLog(@"%@ = %lu walls",[wallsToReturn description],[wallsToReturn count]);
#endif
    
    
    return wallsToReturn;
}

//enumerate permutations recursively
-(NSMutableArray *) enumeratePermutationsForWidth:(int)_widthInUnits
{
    //base cases for recursive method
    if (_widthInUnits <= 1)
        return [NSMutableArray arrayWithArray:nil];
    switch (_widthInUnits)
    {
        case 2:
            return [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:2]]];
        case 3:
            return [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:3]]];
    }
    
    NSMutableArray *enumeratedPermutationsForWidth = [[NSMutableArray alloc] init];
    
    //for each row with width-2, get an array of its ordered contents	
    NSMutableArray *permutationsWithout2 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(_widthInUnits - 2)]];
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
    
    //do the same for each row with width-3
    
    NSMutableArray *permutationsWithout3 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(_widthInUnits - 3)]];
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
#endif
    ////NSLog(@"columns for width %i:%@",widthInUnits,[self.possibleRows description]);
    
    return enumeratedPermutationsForWidth;
}



@end
