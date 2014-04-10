//
//  SXMaskedSprite.h
//  Sparrow
//
//  Created by Daniel Sperl on 31.03.14.
//  Copyright 2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Sparrow/Sparrow.h>

@interface SXMaskedSprite : SPSprite

@property (nonatomic, strong) SPDisplayObject *mask;
@property (nonatomic, assign) BOOL inverted;
@property (nonatomic, assign) BOOL animated;

@end
