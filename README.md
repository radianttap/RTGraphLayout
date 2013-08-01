RTGraphLayout
=============

UICollectionViewFlowLayout subclass acting like zoomable bar chart. You basically use pinch gesture to zoom in on the chart and see more details. You can zoom in all the way until every bar represents a single point in the data source.

It's almost there, but not quite. The one piece missing is that when you zoom in, I want to keep the pinched point exactly where it is, but currently collection view will be pinned to the left edge and you need to scroll. 
I don't have time to continue with this, but you're welcome to finish it.
