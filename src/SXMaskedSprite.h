//
//  SXMaskedSprite.h
//  Demo
//
//  Created by Daniel Sperl on 31.03.14.
//
//

#import <Sparrow/Sparrow.h>

@interface SXMaskedSprite : SPSprite

@property (nonatomic, strong) SPDisplayObject *mask;
@property (nonatomic, assign) BOOL inverted;

@end
