//
//  SXMaskedSprite.m
//  Sparrow
//
//  Created by Daniel Sperl on 31.03.14.
//  Copyright 2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SXMaskedSprite.h"
#import <Sparrow/Sparrow.h>

static uint SXBlendModeMaskNormal = 0;
static uint SXBlendModeMaskInvert = 0;

@implementation SXMaskedSprite
{
    SPDisplayObject *_mask;
    SPRenderTexture *_maskTexture;
    SPImage *_maskImage;

    SPRenderTexture *_canvasTexture;
    SPImage *_canvasImage;

    BOOL _isRendering;
    BOOL _maskRendered;
    uint _blendMode;
}

+ (void)initialize
{
    SXBlendModeMaskNormal = [SPBlendMode encodeBlendModeWithSourceFactor:GL_ZERO destFactor:GL_SRC_ALPHA];
    SXBlendModeMaskInvert = [SPBlendMode encodeBlendModeWithSourceFactor:GL_ZERO destFactor:GL_ONE_MINUS_SRC_ALPHA];
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        _blendMode = SXBlendModeMaskNormal;
        _animated = YES;
    }

    return self;
}

- (void)render:(SPRenderSupport *)support
{
    if (_mask && !_isRendering)
    {
        SPMatrix *matrix = [SPMatrix matrixWithIdentity];
        
        if (!_animated && _maskRendered)
        {
            [matrix copyFromMatrix:_mask.transformationMatrix];
            
            if (_blendMode == SXBlendModeMaskInvert)
            {
                SPRectangle *bounds = [self boundsInSpace:self];
                SPRectangle *intersectBounds = [bounds intersectionWithRectangle:_mask.bounds];
                [matrix translateXBy:bounds.x-intersectBounds.x yBy:bounds.y-intersectBounds.y];
            }
            
            [support pushStateWithMatrix:matrix alpha:1.0f blendMode:SPBlendModeAuto];
            [_canvasImage render:support];
            [support popState];
        }
        else
        {
            SPRectangle *bounds = [self boundsInSpace:self];
            
            if (_blendMode == SXBlendModeMaskNormal)
                bounds = [bounds intersectionWithRectangle:_mask.bounds];

            [self prepareTexturesForWidth:bounds.width height:bounds.height];

            [matrix copyFromMatrix:_mask.transformationMatrix];
            [matrix translateXBy:-bounds.x yBy:-bounds.y];

            [_maskTexture drawBundled:^
            {
                [_maskTexture clear];
                [_maskTexture drawObject:_mask withMatrix:matrix];
            }];

            [_canvasTexture drawBundled:^
            {
                _isRendering = YES;
                _maskImage.blendMode = _blendMode;

                [matrix identity];
                [matrix translateXBy:-bounds.x yBy:-bounds.y];

                [_canvasTexture clear];
                [_canvasTexture drawObject:self withMatrix:matrix];
                [_canvasTexture drawObject:_maskImage];

                _isRendering = NO;
            }];

            [matrix identity];
            [matrix translateXBy:bounds.x yBy:bounds.y];

            [support pushStateWithMatrix:matrix alpha:1.0f blendMode:SPBlendModeAuto];
            [_canvasImage render:support];
            [support popState];
            
            _maskRendered = YES;
        }
    }
    else
    {
        [super render:support];
    }
}

- (void)prepareTexturesForWidth:(float)width height:(float)height
{
    float scale = Sparrow.contentScaleFactor;
    float potWidth  = [SPUtils nextPowerOfTwo:width  * scale] / scale;
    float potHeight = [SPUtils nextPowerOfTwo:height * scale] / scale;

    if (!_canvasTexture || !SP_IS_FLOAT_EQUAL(potWidth,  _canvasTexture.width )
                        || !SP_IS_FLOAT_EQUAL(potHeight, _canvasTexture.height))
    {
        _canvasTexture  = [[SPRenderTexture alloc] initWithWidth:potWidth height:potHeight];
        _maskTexture    = [[SPRenderTexture alloc] initWithWidth:potWidth height:potHeight];

        if (!_canvasImage)
        {
            _canvasImage = [SPImage imageWithTexture:_canvasTexture];
            _maskImage   = [SPImage imageWithTexture:_maskTexture];
        }
        else
        {
            _canvasImage.texture = _canvasTexture;
            _maskImage.texture   = _maskTexture;

            [_canvasImage readjustSize];
            [_maskImage   readjustSize];
        }
    }
}

- (void)setMask:(SPDisplayObject *)mask
{
    if (mask && (mask.width == 0 || mask.height == 0))
        [NSException raise:SPExceptionInvalidOperation format:@"invalid mask dimensions"];

    _mask = mask;
    _maskRendered = NO;
}

- (BOOL)inverted
{
    return _blendMode == SXBlendModeMaskInvert;
}

- (void)setInverted:(BOOL)inverted
{
    _blendMode = inverted ? SXBlendModeMaskInvert : SXBlendModeMaskNormal;
    _maskRendered = NO;
}

@end
