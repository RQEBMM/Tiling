//
//  main.m
//  Tiling
//
//  Created by Ben McCloskey on 3/11/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockIO.h"
#import "BlockCalc.h"

#define TIMER = TRUE;

int main(int argc, const char * argv[])
{

	@autoreleasepool {
#ifdef TIMER
		NSDate *startTime = [NSDate date];		
	    //take inputs
		[BlockIO takeInput];
		NSDate *endTime = [NSDate date];
		printf("\n\nruntime = %.2fs",[endTime timeIntervalSinceDate:startTime]);
#else
		[BlockIO takeInput];
#endif
		//check inputs
		//determine permutations for width
		//calculate cadidate pairs for width
		//multiply by height
		//sum
		//output
	}
    pause();
    return 0;
}


