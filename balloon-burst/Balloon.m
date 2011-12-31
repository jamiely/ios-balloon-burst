//
//  Balloon.m
//  balloon-burst
//
//  Created by Jamie Ly on 12/30/11.
//  Copyright (c) 2011 angelforge.org. All rights reserved.
//

#import "Balloon.h"

@implementation Balloon

@synthesize sprite = sprite_, label = label_, speed = speed_, scale = scale_;

-(id) init:(CCSprite*) sprite
{
    return [self initWithString: sprite string:@""];
}

-(id) initWithString:(CCSprite*) sprite string: (NSString*) string
{
    speed_ = 30.0f; // 30 px a second
    scale_ = 0.1f;
    sprite.scale = scale_;
    
    sprite_ = sprite;
    label_ = [CCLabelTTF labelWithString:string fontName:@"Helvetica" fontSize:40];
    label_.position = sprite.position;
    return self;
}

-(void) setPosition:(CGPoint) position
{
    label_.position = position;
    sprite_.position = position;
}

-(void) raise:(float)delta
{
    CGPoint pos = [self.sprite position];
    pos.y += delta;
    
    self.sprite.position = pos;
    label_.position = pos;
}

-(void) setString:(NSString *)string
{
    [self.label setString:string];
}
@end
