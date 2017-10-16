#include <iostream>
#include<opencv2/opencv.hpp>

using namespace cv;
using namespace std;

/// Global variables

Mat src, src_gray;
Mat dst, detected_edges;
VideoCapture cap;

int edgeThresh = 1;
int lowThreshold;
int const max_lowThreshold = 100;
int ratio = 3;
int kernel_size = 3;
char* window_name = "Edge Map";

/**
 * @function CannyThreshold
 * @brief Trackbar callback - Canny thresholds input with a ratio 1:3
 */
void CannyThreshold(int, void*)
{
  /// Reduce noise with a kernel 3x3
  blur( src_gray, detected_edges, Size(3,3) );

  /// Canny detector
  Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );

  /// Using Canny's output as a mask, we display our result
  dst = Scalar::all(0);

  src.copyTo( dst, detected_edges);
  imshow( window_name, dst );
 }


/** @function main */
int main( int argc, char** argv )
{


    /// Create a window
    namedWindow( window_name, CV_WINDOW_AUTOSIZE );


    cap.open(0);
    if(!cap.isOpened()){
        cout<<"cameras indisponiveis"<<endl;
        return -1;
    }
    cap>>src;
    /// Show the image
    CannyThreshold(0, 0);
    dst.create( src.size(), src.type() );



  while(true){
  cap>>src;

  /// Convert the image to grayscale
  cvtColor( src, src_gray, CV_BGR2GRAY );
  //dst.create( src.size(), src.type() );

  /// Create a matrix of the same type and size as src (for dst)

  /// Create a Trackbar for user to enter threshold
  createTrackbar( "Min Threshold:", window_name, &lowThreshold, max_lowThreshold, CannyThreshold );

  CannyThreshold(0, 0);



  /// Wait until user exit program by pressing a key
  if(waitKey(30)>=0) break;
  }
  return 0;
  }
