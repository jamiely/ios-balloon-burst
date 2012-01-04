//
//  DropItem.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "DropItem.h"

@implementation DropItem

@synthesize string = string_, scoreValue = scoreValue_, sprite = sprite_;

-(id) initWithString:(NSString *)string scoreValue:(int)scoreVal
{
    self.string = string;
    self.scoreValue = scoreVal;
    
    return self;
}

@end
