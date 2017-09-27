#include <iostream>
#include <opencv2/opencv.hpp>
#include <cmath>
#include <string>

using namespace cv;
using namespace std;

std::string GetMatType(const cv::Mat& mat)
{
    const int mtype = mat.type();

    switch (mtype)
    {
    case CV_8UC1:  return "CV_8UC1";
    case CV_8UC2:  return "CV_8UC2";
    case CV_8UC3:  return "CV_8UC3";
    case CV_8UC4:  return "CV_8UC4";

    case CV_8SC1:  return "CV_8SC1";
    case CV_8SC2:  return "CV_8SC2";
    case CV_8SC3:  return "CV_8SC3";
    case CV_8SC4:  return "CV_8SC4";

    case CV_16UC1: return "CV_16UC1";
    case CV_16UC2: return "CV_16UC2";
    case CV_16UC3: return "CV_16UC3";
    case CV_16UC4: return "CV_16UC4";

    case CV_16SC1: return "CV_16SC1";
    case CV_16SC2: return "CV_16SC2";
    case CV_16SC3: return "CV_16SC3";
    case CV_16SC4: return "CV_16SC4";

    case CV_32SC1: return "CV_32SC1";
    case CV_32SC2: return "CV_32SC2";
    case CV_32SC3: return "CV_32SC3";
    case CV_32SC4: return "CV_32SC4";

    case CV_32FC1: return "CV_32FC1";
    case CV_32FC2: return "CV_32FC2";
    case CV_32FC3: return "CV_32FC3";
    case CV_32FC4: return "CV_32FC4";

    case CV_64FC1: return "CV_64FC1";
    case CV_64FC2: return "CV_64FC2";
    case CV_64FC3: return "CV_64FC3";
    case CV_64FC4: return "CV_64FC4";

    default:
        return "Invalid type of matrix!";
    }
}
double alfa[256];
//double alfa;


int alfa_slider = 0;
int alfa_slider_max = 100;

int top_slider = 0;
int top_slider_max = 100;

double d;
int d_slider=0;
int d_slider_max=100;

double l1;
int l1_slider=0;
int l1_slider_max=100;

double l2;
int l2_slider=0;
int l2_slider_max=100;

Mat image1, image2,imageFiltered(256,256,CV_32F), blended(256,256,CV_8UC3);
Mat imageTop;
Mat pondBlur,pondResultBlur(256,256,CV_8UC3),pondOrig,pondResultOrig(256,256,CV_8UC3);

char TrackbarName[50];




void on_trackbar_blend(int, void*){
l1=-20;
l2=30;
d=2;
 //alfa = (double) alfa_slider/alfa_slider_max ;
 for(int i=0;i<256;i++){
     alfa[i]=1/2*(tanh((i-l1)/d)-tanh((i-l2)/d));
     addWeighted(pondResultBlur.row(i), alfa[i], imageTop.row(i), 1-alfa[i], 0.0, blended.row(i));
 }
 //addWeighted(pondResultBlur, alfa, imageTop, 1-alfa, 0.0, blended);


 imshow("addweighted", blended);

}


void on_trackbar_d(int,void*){
    d= (double) d_slider/d_slider_max;
    for(int i=0;i<256;i++){
        alfa[i]=1/2*(tanh((i-l1)/d)-tanh((i-l2)/d));
        addWeighted(pondResultBlur.row(i), alfa[i], imageTop.row(i), 1-alfa[i], 0.0, blended.row(i));
    }
}

void on_trackbar_l1(int,void*){
    l1=(double)(l1_slider/l1_slider_max);
    for(int i=0;i<256;i++){
        alfa[i]=1/2*(tanh((i-l1)/d)-tanh((i-l2)/d));
        addWeighted(pondResultBlur.row(i), alfa[i], imageTop.row(i), 1-alfa[i], 0.0, blended.row(i));
    }
}

void on_trackbar_l2(int,void*){
    l2=(double)(l2_slider/l2_slider_max);
    for(int i=0;i<256;i++){
        alfa[i]=1/2*(tanh((i-l1)/d)-tanh((i-l2)/d));
        addWeighted(pondResultBlur.row(i), alfa[i], imageTop.row(i), 1-alfa[i], 0.0, blended.row(i));
    }
}

void on_trackbar_line(int, void*){
  pondResultBlur.copyTo(imageTop);
  int limit = top_slider*255/100;
  if(limit > 0){
    Mat tmp = pondResultOrig(Rect(0, 0, 256, limit));
    tmp.copyTo(imageTop(Rect(0, 0, 256, limit)));
  }
  on_trackbar_blend(alfa_slider,0);
}

int main(int argvc, char** argv){
 //--------------------------------------Etapa de Filtragem - Borramento----------------------
  float media[] = {1,1,1,
                     1,1,1,
                     1,1,1};
  Mat mask(3,3,CV_32F,media),mask1;
  image1 = imread("train1.jpg");
  image1.convertTo(image2,CV_32F);
  scaleAdd(mask, 1/9.0, Mat::zeros(3,3,CV_32F), mask1);
  swap(mask, mask1);
  filter2D(image1, imageFiltered, image1.depth(), mask, Point(1,1), 0);
//  namedWindow("filtroespacial", WINDOW_AUTOSIZE);
//  imshow("filtroespacial", imageFiltered);

//----------------------------------------//-------------------------------------------------
  //Mat pondBlur,pondResultBlur(256,256,CV_8UC3),pondOrig,pondResultOrig(256,256,CV_8UC3);
  pondBlur=imread("pond_blur.jpg");
  pondOrig=imread("pond_orig.jpg");
  cout<<GetMatType(pondResultBlur)<<endl;
  cout<<GetMatType(pondResultOrig)<<endl;
  cout<<GetMatType(blended)<<endl;
  //pondBlur.convertTo(pondBlur,CV_32F);
  //pondResult=imageFiltered.mul(pondBlur);
  multiply(imageFiltered,pondBlur,pondResultBlur,0.005);
  multiply(image1,pondOrig,pondResultOrig,0.007);
  namedWindow("Ponderação-Blur");
  imshow("Ponderação-Blur",pondResultBlur);

  namedWindow("Ponderação-Original");
  imshow("Ponderação-Original",pondResultOrig);
  image2 = imread("train1.jpg");
  pondResultOrig.copyTo(imageTop);
  namedWindow("addweighted", 1);
//  alfa=0.6;
//  addWeighted(pondResultBlur, alfa, pondResultOrig, 1-alfa, 0.0, blended);

  l1=-20;
  l2=30;
  d=6;

   for(int i=0;i<256;i++){
       alfa[i]=tanh(((double)i+20.0));

       addWeighted(pondResultBlur.row(i), alfa[i], imageTop.row(i), 1-alfa[i], 0.0, blended.row(i));
       cout<<"alfa "<<alfa[i]<<endl;
   }
  imshow("teste", blended);

  sprintf( TrackbarName, "Alpha x %d", alfa_slider_max );
  createTrackbar(TrackbarName, "addweighted",
                  &alfa_slider,
                  alfa_slider_max,
                  on_trackbar_blend );
  on_trackbar_blend(alfa_slider, 0 );

  sprintf( TrackbarName, "Scanline x %d", top_slider_max );
  createTrackbar(TrackbarName, "addweighted",
                  &top_slider,
                  top_slider_max,
                  on_trackbar_line );
  on_trackbar_line(top_slider, 0 );

  sprintf( TrackbarName, "d x %d", d_slider_max );
  createTrackbar(TrackbarName, "addweighted",
                  &d_slider,
                  d_slider_max,
                  on_trackbar_d);
  on_trackbar_d(d_slider, 0 );

  sprintf( TrackbarName, "l1 x %d", l1_slider_max );
  createTrackbar(TrackbarName, "addweighted",
                  &l1_slider,
                  l1_slider_max,
                  on_trackbar_l1 );
  on_trackbar_l1(l1_slider, 0 );

  sprintf( TrackbarName, "l2 x %d", l2_slider_max );
  createTrackbar(TrackbarName, "addweighted",
                  &l2_slider,
                  l2_slider_max,
                  on_trackbar_l2 );
  on_trackbar_line(l2_slider, 0 );

  waitKey(0);
  return 0;
}
