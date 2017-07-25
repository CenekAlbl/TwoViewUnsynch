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

### Notes
Images must contain movement. The movement should span more frames than the amount of desuchnronization
