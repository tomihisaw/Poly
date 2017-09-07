//
//  GeometryWrapper.m
//
//  Created by Tom Welsh on 8/21/17.
//  Copyright © 2017 Welsh. All rights reserved.
//

#import "GeometryWrapper.h"
#import "Triangulate2d.hpp"

struct InternalGeometryWrapper {
    Geometry::Triangulate *tri;
    Geometry::Polygon *polys;
    std::vector<Geometry::Triangle> results;
};

@implementation GeometryWrapper
- (id)initWithPoints:(FloatData2*)points {
    if (self = [super init]) {
        internal = new InternalGeometryWrapper();
        internal->tri = new Geometry::Triangulate();
        internal->polys = new Geometry::Polygon((Geometry::Point2*)points.data, points.count);
    }
    return self;
}

- (IntData3*)triangleVertices; {
    
    if (internal->results.size() == 0) {
        [self triangulate];
    }

    IntData3 *list = [IntData3 new];
    unsigned long count = internal->results.size() * 3;
    list.data = new int[count];
    list.count = count;
    int i = 0;
    for (auto item:internal->results){
        list.data[i++] = item.v1;
        list.data[i++] = item.v2;
        list.data[i++] = item.v3;
    }
    return list;
}

- (void)triangulate {
    internal->results = internal->tri->Triangulate_optimal(internal->polys);
}

- (void) dealloc {
    delete internal;
}
@end
