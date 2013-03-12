//
//  BlockCalc.m
//  Tiling
//
//  Created by Ken Thomsen on 3/11/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import "BlockCalc.h"

@implementation BlockCalc

-(id) initWithWidth:(double)width andHeight:(int)height
{
	if (self = [super init])
	{
		self.height = height;
		self.width = width;		
		self.possibleRows = [[NSMutableArray alloc] init];
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
	int widthUnits = (self.width / 1.5);
	int permutationsPerWidth = [self permutationsForWidth:widthUnits];
	int legalPairsPerWidth = [self findLegalPairsForWidth:widthUnits];
	
	int64_t totalLegalPermutations;
	if (self.height > 1)
	{
		//handles "legal" pairings. i.e. the hard part
		totalLegalPermutations = (permutationsPerWidth * legalPairsPerWidth * (self.height - 1));
	}
	else
		totalLegalPermutations = [self permutationsForWidth:widthUnits];
	
	NSArray *columns = [NSArray arrayWithArray:[self enumeratePermutationsForWidth:widthUnits]];
	
	NSLog(@"count of columns: %lu",[columns count]);
	NSLog(@"description of columns: %@", [columns description]);
	return totalLegalPermutations;
}

//takes width in inches, and returns permutations recursively
- (int) permutationsForWidth:(int)widthInUnits
{
	switch (widthInUnits)
	{
		case 1:
			return 0;
		case 2:
			return 1;
		case 3:
			return 1;
	}
	int	permutationsWithFirstBlockOf2 = [self permutationsForWidth:(widthInUnits - 2)];
	int permutationsWithFirstBlockOf3 = [self permutationsForWidth:(widthInUnits - 3)];
	
	return (permutationsWithFirstBlockOf2 + permutationsWithFirstBlockOf3);
}

//enumerate permutations recursively
-(NSMutableArray *) enumeratePermutationsForWidth:(int)widthInUnits
{
	//base cases for recursive method
	if (widthInUnits <= 1)
		return [NSMutableArray arrayWithArray:nil];
	switch (widthInUnits)
	{
		case 2:
			return [NSMutableArray arrayWithObject:[NSNumber numberWithInt:2]];
		case 3:
			return [NSMutableArray arrayWithObject:[NSNumber numberWithInt:3]];
	}
	
	//for each row with width-2, get an array of its ordered contents
	
		NSMutableArray *rowsWith2 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(widthInUnits - 2)]];
		//append a 2 to each
		for (int y = 0; y < [rowsWith2 count]; y++)
		{
			NSMutableArray *row = [NSMutableArray arrayWithArray:[rowsWith2 objectAtIndex:y]];
			[row addObject:[NSNumber numberWithInt:2]];		
			[rowsWith2 replaceObjectAtIndex:y withObject:row];
		}
		//add those into our list
		[self.possibleRows addObjectsFromArray:rowsWith2];
	
	
	//for each row with width-3, get an array with 3 appended
	
		NSMutableArray *rowsWith3 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(widthInUnits - 3)]];
		//append a 3 to each
		for (int b = 0; b < [rowsWith3 count]; b++)
		{
			NSMutableArray *row = [NSMutableArray arrayWithArray:[rowsWith3 objectAtIndex:b]];
			[row addObject:[NSNumber numberWithInt:3]];
			[rowsWith3 replaceObjectAtIndex:b withObject:row];
		}
		//add those into our list
		[self.possibleRows addObjectsFromArray:rowsWith3];
	
	NSLog(@"columns for width %i:%@",widthInUnits,[self.possibleRows description]);
	//add all of those rows into one array
	return self.possibleRows;
}

- (int) findLegalPairsForWidth:(int)widthInUnits
{
	//TODO:find legal pairs for a given width
	return 1;
}

@end
