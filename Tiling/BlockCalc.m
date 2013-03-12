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
	
	int64_t totalLegalPermutations;
	int64_t totalPermutations;
	if (self.height > 1)
	{
		
		NSMutableArray *permutationsForWidth = [self enumeratePermutationsForWidth:widthUnits];
		//replace each array with its bitmask
		for (int x = 0;x < [permutationsForWidth count];x++)
		{
			NSNumber *bitmask = [NSNumber numberWithLongLong:[self bitmaskRepresentationFor:[permutationsForWidth objectAtIndex:x]]];
			[permutationsForWidth replaceObjectAtIndex:x withObject:bitmask];
		}
		for (int y = 0;y < [permutationsForWidth count];y++)
		{
			for (int z = 0;z < [permutationsForWidth count];z++)
			{
				
			}
		}
	}
	else
		totalLegalPermutations = [[self enumeratePermutationsForWidth:widthUnits] count];
#ifdef DEBUG
	NSArray *columns = [NSArray arrayWithArray:[self enumeratePermutationsForWidth:widthUnits]];
	for (NSArray *column in columns)
	{
		[self bitmaskRepresentationFor:column];
	}
#endif
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
	
	NSMutableArray *enumeratedPermutationsForWidth = [[NSMutableArray alloc] init];
	
	//for each row with width-2, get an array of its ordered contents	
	NSMutableArray *permutationsWithout2 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(widthInUnits - 2)]];
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
	
	NSMutableArray *permutationsWithout3 = [NSMutableArray arrayWithObject:[self enumeratePermutationsForWidth:(widthInUnits - 3)]];
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
	NSLog(@"Columns after rowsWith3 for width %i:%@",widthInUnits,enumeratedPermutationsForWidth);
#endif
	////NSLog(@"columns for width %i:%@",widthInUnits,[self.possibleRows description]);
	
	return enumeratedPermutationsForWidth;
}

-(int64_t) bitmaskRepresentationFor:(NSArray *)permutation
{
	int64_t bitmask = 1;	
	for (NSNumber *block in permutation)
	{
		int blockVal = [block intValue];
		bitmask = bitmask << blockVal;
		bitmask++;
	}
#ifdef DEBUG
	NSString *bitString = @"1";
	NSString *appendString = @"";
	for (NSNumber *block in permutation)
	{
		if ([block isEqualToNumber:[NSNumber numberWithInt:2]])
			appendString = @"10";
		else if ([block isEqualToNumber:[NSNumber numberWithInt:3]])
			appendString = @"100";
		
		bitString = [NSString stringWithFormat:@"%@%@",appendString,bitString];
	}
	
	NSLog(@"%@ = %@ = %llu",permutation,bitString,bitmask);
#endif
	return bitmask;
}

@end
