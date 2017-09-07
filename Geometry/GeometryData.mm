//
//  GeometryData.m
//
//  Created by Tom Welsh on 8/21/17.
//  Copyright © 2017 Welsh. All rights reserved.
//

#import "GeometryWrapper.h"

@implementation FloatData2
- (id)initWithData:(float*)data
             count:(NSUInteger)count {
 
    if (self = [super init]) {
        self.data = data;
        self.count = count;
    }
    return self;
}
@end

@implementation IntData3
- (void) dealloc {
    delete _data;
}
@end


