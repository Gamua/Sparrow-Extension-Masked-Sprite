//
//  Game.m
//  AppScaffold
//

#import "Game.h" 
#import "SXMaskedSprite.h"

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    float stageWidth  = Sparrow.stage.width;
    float stageHeight = Sparrow.stage.height;

    // add a background image

    SPImage *background = [SPImage imageWithContentsOfFile:@"background.jpg"];
    background.x = (stageWidth  - background.width)  / 2.0f;
    background.y = (stageHeight - background.height) / 2.0f;
    [self addChild:background];

    // load the movie clip that will be used as the mask

    SPTextureAtlas *atlas = [SPTextureAtlas atlasWithContentsOfFile:@"atlas.xml"];
    NSArray *frames = [atlas texturesStartingWith:@"walk"];

    SPMovieClip *movie = [SPMovieClip movieWithFrames:frames fps:12.0f];
    [movie alignPivotToCenter];
    [Sparrow.juggler addObject:movie];

    // create the image that will be masked

    SPImage *image = [SPImage imageWithContentsOfFile:@"sparrow_front.png"];
    [image alignPivotToCenter];

    SXMaskedSprite *sprite = [SXMaskedSprite sprite];
    sprite.x = stageWidth  / 2.0f;
    sprite.y = stageHeight / 2.0f;
    sprite.mask = movie;

    [sprite addChild:image];
    [self addChild:sprite];

    // and a button to change the mask mode

    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:@"button.png"];
    
    SPButton *buttonInvert = [SPButton buttonWithUpState:buttonTexture text:@"Invert Mask"];
    
    __weak SPButton *wButtonInvert = buttonInvert;
    [buttonInvert addEventListenerForType:SPEventTypeTriggered block:^(id event)
     {
         sprite.inverted = !sprite.inverted;
         wButtonInvert.text = [(sprite.inverted ? @"Normal" : @"Invert") stringByAppendingString:@" Mask"];
     }];

    buttonInvert.x = stageWidth / 2.0f - buttonInvert.width - 0.5f;
    buttonInvert.y = 20;
    [self addChild:buttonInvert];
    
    // and a button to change the animate mode
    
    SPButton *buttonAnimate = [SPButton buttonWithUpState:buttonTexture text:@"Deanimate Mask"];
    
    __weak SPButton *wButtonAnimated = buttonAnimate;
    [buttonAnimate addEventListenerForType:SPEventTypeTriggered block:^(id event)
     {
         sprite.animated = !sprite.animated;
         wButtonAnimated.text = [(sprite.animated ? @"Deanimate" : @"Animate") stringByAppendingString:@" Mask"];
     }];
    
    buttonAnimate.x = stageWidth / 2.0f + 0.5f;
    buttonAnimate.y = 20;
    [self addChild:buttonAnimate];
}

@end