//
//  Timer.h
//  Tiling
//
//  Created by Ken Thomsen on 3/15/13.
//  Copyright (c) 2013 Ben McCloskey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject


@property NSDate *startTime;
@property NSDate *endTime;

-(void)startTimer;
-(NSDate *)getTime;

@end
