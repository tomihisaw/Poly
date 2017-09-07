#include <stdio.h>
#include <string.h>
#include <math.h>
#include <list>
#include <algorithm>
#include <set>

#include "Triangulate2d.hpp"
using namespace Geometry;

#define SQUARE(X) ((X) * (X))

struct MinCost {
    Float value = -1;
    Int index = -1;
};

typedef std::vector< std::vector<MinCost> > CostTable;

Polygon::Polygon(Point2 *vertices, unsigned long count) : points(vertices,vertices+count) {
    order = unknown;
}

Float distance(const Point2 p1, const Point2 p2) {
    return sqrt( SQUARE(p1.x - p2.x) + SQUARE(p1.y - p2.y));
}

Float triangleCost(const Point2 &v1, const Point2 &v2, const Point2 &v3) {
    return distance(v1,v2) + distance(v2,v3) + distance(v1,v3);
}

void printLookup(const CostTable &lookup) {
    printf("Lookup Table\n");
    for (int i = 0; i < lookup.size(); i++) {
        for (int j=0; j < lookup[i].size(); j++) {
            printf("(%d,%d) = %.1f[%d] ",i,j,lookup[i][j].value,lookup[i][j].index);
        }
        printf("\n");
    }
}

// Perform the min cost algorithm, and return the results in the lookup table
void buildCostDynamic(const std::vector<Point2> &points, CostTable &lookup) {
    auto n = lookup.size();
    for (int diag = 0; diag < points.size(); diag++) {
        int i = 0;
        for (int j = diag; j < n; j++) {
            if (j < i + 2) {
                lookup[i][j].value = 0.0;
            } else {
                lookup[i][j].value = std::numeric_limits<Float>::max();

                for (int k = i+1; k < j; k++) {
                    auto triangle = triangleCost(points[i], points[k], points[j]);
                    auto totalCost = lookup[i][k].value + lookup[k][j].value + triangle;
                    
                    if (totalCost < lookup[i][j].value) {
                        lookup[i][j].value = totalCost;
                        lookup[i][j].index = k;
                    }
                }
            }
            i++;
        }
    }
}

// Given the lookup table, return the min cost triangulation
Float getMinCost(const CostTable &lookup) {
    auto n = lookup.size();
    return  lookup[0][n-1].value;
}

// From the lookup table, generate the triangles
void listTriangles(CostTable &lookup, int i, int j, std::vector<Triangle> &triangles) {
    if (j >= i+2) {
        int k  = lookup[i][j].index;
        triangles.push_back(Triangle(i,j,k));
        listTriangles(lookup, i, k, triangles);
        listTriangles(lookup, k, j, triangles);
    }
}

void print(const std::vector<Point2> &points) {
    for (auto pt : points) {
        printf("%.f,%.f ",pt.x,pt.y);
    }
}

void Triangulate::printTriangles(const std::vector<Triangle> &triangles) const {
    for (auto i = 0; i < triangles.size(); ++i) {
        printf("<%d %d %d>\n", triangles[i].v1, triangles[i].v2, triangles[i].v3);
    }
}

std::vector<Triangle> Triangulate::Triangulate_optimal(const Polygon *poly ) {
    std::vector<Triangle> triangles;
    
    auto n = poly->points.size();
    MinCost initial;

    // create the lookup table
    CostTable lookup;
    lookup.resize(n, std::vector<MinCost>(n, initial));
    
    // run algo
    buildCostDynamic(poly->points, lookup);
    
    printLookup(lookup);
    // generate list of triangles
    listTriangles(lookup, 0, static_cast<int>(n-1), triangles);
    
    // print (for debugging)
    printTriangles(triangles);
    
    return triangles;
}
