//
//  BlockIO.m
//  Tiling
//
//  Created by Ken Thomsen on 3/11/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import "BlockIO.h"
#import "BlockCalc.h"

@implementation BlockIO

+(void)takeInput
{
	NSArray *arguments = [[NSProcessInfo processInfo] arguments];

	if ([arguments count] >= 2)
	{
		double width = [[arguments objectAtIndex:([arguments count] - 2)] doubleValue];
		int height = [[arguments objectAtIndex:([arguments count] -1)] intValue];
		[BlockIO showOutputForWall:[BlockCalc wallWithWidth:width andHeight:height]];
	}
	else
	{
		printf("Insufficient arguments, entering interactive mode\n");
		double width = [BlockIO takeWidth];
		int height = [BlockIO takeHeight];
		[BlockIO showOutputForWall:[BlockCalc wallWithWidth:width andHeight:height]];
	}
}

+(double)takeWidth
{	
	char widthString[20];
	
	printf("\nPlease enter the Width in inches:");
	if (fgets(widthString,20,stdin))
	{
		NSString *input = [NSString stringWithCString:widthString encoding:NSUTF8StringEncoding];
		double width = [input doubleValue];
		if (width)
		{
			if ([BlockIO checkWidth:width])			
				return width;			
		}
	}
		
	
	return [BlockIO takeWidth];
}

+(int)takeHeight
{
	char heightString[20];
	
	printf("Please enter the Height in inches:");
	if (fgets(heightString,20,stdin))
	{
		NSString *input = [NSString stringWithCString:heightString encoding:NSUTF8StringEncoding];
		int height = [input intValue];
		if (height)
		{
			if ([BlockIO checkHeight:height])
				return height;
		}
	}
	
	
	return [BlockIO takeHeight];
}

+(BOOL) checkWidth:(double)width
{
	if (width < 3)
	{
		printf("\nWidth must be greater than 3 inches\n");
		return FALSE;
	}
	int widthUnits = width * 10;
	
	int remainder = (widthUnits % 5);
	if (remainder != 0)
	{
		printf("\nWidth must be a multiple of 1.5 inches\n");
		return FALSE;
	}
	return TRUE;
}

+(BOOL)checkHeight:(int)height
{
	if (height < 1)
	{
		printf("\nHeight must be greater than 1 inch\n");
		return FALSE;
	}
	return TRUE;
}

+(void)showOutputForWall:(BlockCalc *)wall
{
	printf("%lli",[wall calcPermutations]);
}

@end
