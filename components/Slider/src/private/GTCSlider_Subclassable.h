//
//  GTCSlider_Subclassable.h
//  Pods
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCSlider.h"

@class GTCThumbTrack;

/**
 Import this header in order to properly subclass GTCSlider including access to the internal thumb
 track.
 */
@interface GTCSlider () {
@protected
    /**
     The underlying thumb track backing the slider.
     */
    GTCThumbTrack *_thumbTrack;
}

@end
