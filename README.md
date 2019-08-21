Ball Mapper
-----------

This code reimplements Algorithms 1 and 3 from P. Dlotko, "Ball mapper: A
shape summary for topological data analysis," arXiv:1901.07410v1 [math.AT].
We require MATLAB R2015b and the Statistics and Machine Learning Toolbox.

The following functions are included:

| Function          | Description       |
| ----------------- | ----------------- |
| `ballmapper`      | Ball mapper       |
| `colorballmapper` | Color ball mapper |

`ballmapper` is a faithful implementation of Algorithms 1 and 3 in \[1\],
whereas `colorballmapper` adds the node coloring scheme from \[2\]. Here is
an example of the Fisher iris data with `ballmapper`:

```matlab
load fisheriris
plot(ballmapper(meas,0.5))
```

One more time but with `colorballmapper`:

```matlab
y = cellfun(@(s) strcmp(s,'versicolor')+strcmp(s,'virginica')*2,species);
[G,C] = colorballmapper(meas,y,0.5);
h = plot(G);
h.NodeCData = C;
colormap jet
```

Here the cell function assigns 0 to 'setosa', 1 to 'versicolor' and 2 to
'virginica' (the enumeration is arbitrary). The jet colormap is used to
mimic the coloring scheme in \[2\], but this is optional.

My code is not optimized for speed. As a rule of thumb, do not use this
code if you have more than 10,000 data points.

Tak-Shing Chan

19 August 2019

### References

\[1\] P. Dlotko, "Ball mapper: A shape summary for topological data
analysis," arXiv:1901.07410v1 [math.AT].

\[2\] G. Singh, F. Memoli, and G. Carlsson, "Topological methods for the
analysis of high dimensional data sets and 3D object recognition," in
*Proc. Eurographics Symp. Point-Based Graphics*, 2007, pp. 91-100.
