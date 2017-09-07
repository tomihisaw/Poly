//
//  GeometryWrapper.h
//
//  Created by Tom Welsh on 8/21/17.
//  Copyright © 2017 Welsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeometryData.h"

// Internal c++ core
struct InternalGeometryWrapper;
@interface GeometryWrapper : NSObject {
    struct InternalGeometryWrapper *internal;
}
/*! @brief initialized with a float array of 2d points
 */
- (id)initWithPoints:(FloatData2*)points;

/*! @brief run the algorithm and return the results as 3 triangle indices
     corresponding to the input vertices
 */
- (IntData3*)triangleVertices;
@end
