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
			return [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:2]]];
		case 3:
			return [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:3]]];
	}
	
	NSMutableArray *rowsForWidth = [[NSMutableArray alloc] init];
	//for each row with width-2, get an array of its ordered contents
	
	NSMutableArray *rowsWithout2 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(widthInUnits - 2)]];
	//append a 2 to each
	NSMutableArray *rowsWith2 = [[NSMutableArray alloc] init];
	for (NSMutableArray *column in rowsWithout2)
	{
		for (NSMutableArray *row in column)
		{
			[row addObject:[NSNumber numberWithInt:2]];
			[rowsWith2 addObject:row];
		}
	}
	//add those into our list
	[rowsForWidth addObjectsFromArray:rowsWith2];
	
	//for each row with width-3, get an array with 3 appended
	
	NSMutableArray *rowsWithout3 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(widthInUnits - 3)]];
	//append a 3 to each
	NSMutableArray *rowsWith3 = [[NSMutableArray alloc]init];
	for (NSMutableArray *column in rowsWithout3)
	{
		for (NSMutableArray *row in column)
		{
		[row addObject:[NSNumber numberWithInt:3]];
		[rowsWith3 addObject:row];
		}
	}
	//add those into our list
	[rowsForWidth addObjectsFromArray:rowsWith3];
	NSLog(@"Columns after rowsWith3 for width %i:%@",widthInUnits,rowsForWidth);
	
	////NSLog(@"columns for width %i:%@",widthInUnits,[self.possibleRows description]);
	
	//add all of those rows into one array
	return rowsForWidth;
}

- (int) findLegalPairsForWidth:(int)widthInUnits
{
	//TODO:find legal pairs for a given width
	return 1;
}

@end
