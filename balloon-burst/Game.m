//
//  Game.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize score = score_, timer = timer_, dropItemsCollected = dropItemsCollected_,
    dropItemsNeeded = dropItemsNeeded_, balloons = balloons_, dropItems = dropItems_,
    round = round_, balloonPace = balloonPace_;

int dropItemsToAddNextRound;
int timerStart;

-(id) init
{
    timerStart = 20;
    dropItemsToAddNextRound = 2;
    
    self.dropItemsCollected = 0;
    self.score = 0;
    self.timer = timerStart;
    self.round = 1;
    self.dropItemsNeeded = 3;
    self.balloonPace = 2.0f;
    
    words_ = [@"APPLE,ANTLER,AXLE,BABY,CAT,DOG,EGG,FOOT,GIRL,HOME,ICE,JUMP,KITE,LION,MOM,NEST,ONION,PIG,QUIET,ROSE,STAR,TIN,UMBRELLA,VAN,WIN,XYLOPHONE,YELLOW,ZEBRA" componentsSeparatedByString:@","];
    
    // initialize lookup
    wordLookup_ = [[NSMutableDictionary alloc] init];
    for(NSString* word in words_) {
        NSString* firstLetter = [word substringToIndex:1];
        NSMutableArray* letterWords = [wordLookup_ objectForKey:firstLetter];
        if(letterWords == nil) {
            letterWords = [[NSMutableArray alloc] init];
            [wordLookup_ setObject:letterWords forKey:firstLetter];
        }
        [letterWords addObject:word];
    }
    
    balloons_ = [[NSMutableArray alloc] init];
    dropItems_ = [[NSMutableArray alloc] init]; 
    
    return self;
}

-(Boolean) isDropItemCollected
{
    return self.dropItemsCollected >= self.dropItemsNeeded;
}

-(Boolean) isGameOver
{
    return [self isRoundComplete] && ![self isDropItemCollected];
}

-(Boolean) isRoundComplete
{
    return [self isTimeUp] || [self isDropItemCollected];
}

-(Boolean) isTimeUp
{
    return self.timer <= 0;
}


-(void) nextRound 
{
    timerStart *= 1.5;
    
    // increment round
    self.round ++;
    
    // reset timer
    self.timer = timerStart;
    
    // score is not reset between rounds
    // player needs to collect more dropItems
    self.dropItemsCollected = 0;
    
    // player must retrieve more dropItems each round
    self.dropItemsNeeded += dropItemsToAddNextRound;
    dropItemsToAddNextRound += 5;
    
    self.balloonPace -= 0.1; 
    if(self.balloonPace < 0.5) {
        self.balloonPace = 0.5;
    }
}

- (Balloon *) newBalloon: (CCSprite*) sprite {
    int balloonSpeed = arc4random() % 8 + 2;
    
    NSString* letter = [NSString stringWithFormat:@"%c", (unsigned char) arc4random() % 26 + 65];
    Balloon* balloon = [[Balloon alloc] initWithString:balloonSpeed/60.0f sprite:sprite string:letter];
    
    [balloons_ addObject:balloon];
    
    return balloon;
}

-(NSString*) getWord:(NSString*) letter {
    NSArray *words = [wordLookup_ objectForKey:letter];
    return [words objectAtIndex:0];
}

-(DropItem*) newDropItem:(Balloon*) balloon
{
    NSString *word = [self getWord:balloon.string];
    DropItem* item = [[DropItem alloc] initWithString:word scoreValue:15];
    [dropItems_ addObject:item];
    return item;
}

-(void) removeDropItem:(id)object
{
    [dropItems_ removeObject:object];
}

-(void) removeBalloon:(id)object
{
    [balloons_ removeObject:object];
}

@end
