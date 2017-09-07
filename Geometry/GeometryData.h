//
//  GeometryData.h
//
//  Created by Tom Welsh on 8/21/17.
//  Copyright © 2017 Welsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief 2 float indices in a flattened array */
@interface FloatData2 : NSObject
- (id)initWithData:(float*)data
             count:(NSUInteger)count;
@property(nonatomic, assign) float* data;
@property(nonatomic, assign) NSUInteger count;
@end

/*! @brief 3 integer indices in a flattened array */
@interface IntData3: NSObject
@property(nonatomic, assign) int* data;
@property(nonatomic, assign) NSUInteger count;
@end


