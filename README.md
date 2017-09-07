A simple project to triangulate 2d vertices

This was an experiment with SceneKit and as an example of calling into c++ code from Swift.
The app lets you add points by tapping on the screen and will triangulate using a dynamic programming algorithm which finds the minimum cost triangulation.

It may be useful for creating simple 2D trianulations. For now the vertices are printed to console, but it would be easy to have the triangulates write to a file and be reloaded in an app.
