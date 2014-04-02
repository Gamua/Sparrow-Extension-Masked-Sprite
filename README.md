Sparrow Extension: Masked Sprite
================================

The Sparrow Extension class "SXMaskedSprite" provides pixel level masking for any Sparrow display object.

Use the class as a replacement for a normal Sprite. It contains a public property called "mask" that can be set to any display object. As each frame progresses, custom blend filters will apply the mask's alpha channel to the contents of the sprite. Both animated and static display objects are supported.

Installation
------------

Add the class files from the `src`-directory to your Sparrow-powered game.

Demo-Project
------------

The `demo`-directory contains a sample project. If you have configured your system for Sparrow, the project should compile and run out of the box.

Sample Code
-----------

Create the sprite class and attach any display object to it, and it will act as a mask. There is no need to add the mask to the display list; you can change its position, scale, alpha, etc. to achieve different effects.

    // create masked sprite and add some children
    SXMaskedSprite *sprite = [SXMaskedSprite sprite];
    [sprite addChild:...];

    // create a mask
    SPImage *mask = [SPImage imageWithContentsOfFile:@"my_mask.png"];

    // apply the mask to the sprite
    sprite.mask = mask;

More information
----------------

Additional information will be added to the [Sparrow wiki][1] soon.
Thanks a lot to Jonathan Heart — his [Pixelmask][2] Starling extension was the inspiration for this port.

[1]: http://wiki.sparrow-framework.org
[2]: http://wiki.starling-framework.org/extensions/pixelmask