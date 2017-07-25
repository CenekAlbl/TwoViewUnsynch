# TwoViewUnsynch
Tool for synchronizing two image sequences using epipolar geometry or homography
Based on the paper:
http://openaccess.thecvf.com/content_cvpr_2017/papers/Albl_On_the_Two-View_CVPR_2017_paper.pdf
## Function
Synchronizes two image sequences based on tracks provided by the user or computed by OpenMVG (windows only binaries). 
### Input 
* Image tracks (image points corresponding to the same 3D point in both sequences)
* Images or video sequences (optional if tracks provided)
### Output
* The time offset between the two sequences.

### Track file format
```
n1 id11 x11 y11 id12 x12 y12 ... n2 id21 x21 y21 id22 x22 y22 ...
```
Each line is one track
* n1 - number of image points in sequence 1 for this track
* id11 - frame in which image point 1 appeared in sequence 1
* x11, y11 - image coordinates
* n2 number of image points in sequence 2 for this track
* etc.

### Notes
Images must contain movement. The movement should span more frames than the amount of desychnronization
