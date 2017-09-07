#ifndef TRIANGLES2D_H
#define TRIANGLES2D_H

#include <vector>

// Geometry Namespace contails basic structures required for triangulation
namespace Geometry {
    typedef float Float;
    typedef int Int;
    
    // A 2D point defining a vertex
    struct Point2 {
        Float x;
        Float y;
    };

    // A 2D Triangle defined by indices
    struct Triangle {
    public:
        Triangle(Int v1_, Int v2_, Int v3_) : v1(v1_), v2(v2_), v3(v3_){}
        Int v1, v2, v3;
    };
    
    // The ordering of the polygon
    enum Order { unknown, cw, ccw };
    
    struct Polygon {
    public:
        Polygon();
        Polygon(Point2 *points, unsigned long count);
        std::vector<Point2> points;
        Order order;
    };
    
    class Triangulate {
    public:
        /*! @brief triangulate using minimum cost method
         O(n^3) time complexit, O(n^2) space
         **/
        std::vector<Triangle> Triangulate_optimal(const Polygon *poly);
        
        /*! @brief print the triangles **/
        void printTriangles(const std::vector<Triangle> &triangles) const;
    };
    
}
#endif
