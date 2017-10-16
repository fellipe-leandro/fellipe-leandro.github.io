#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main()
{
    Mat matMain,matHide;
    int width,height;
    Mat newImg;
    int LSBytes;
    int MSBytes;


    matMain=imread("../../imgs/beach.jpg",CV_LOAD_IMAGE_GRAYSCALE);
    matHide=imread("../../imgs/numeros.jpg",CV_LOAD_IMAGE_GRAYSCALE);
    if((!matMain.data) || (!matHide.data)){
        cout<<"Falha em abrir arguma das imagens"<<endl;
    }
    //cvtColor(matMain,newImg,CV_BGR2GRAY);
    namedWindow("Imagem Original",WINDOW_AUTOSIZE);
    namedWindow("Imagem to hide",WINDOW_AUTOSIZE);
    namedWindow("Imagem Final",WINDOW_AUTOSIZE);
    width=matMain.size().width;
    height=matMain.size().width;
    newImg=matMain.clone();

    for (int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            Scalar valor1=matMain.at<uchar>(i,j); //selecionar 5 MS bits e zerar os 3 LS bits
            Scalar valor2=matHide.at<uchar>(i,j);
            MSBytes=(int)valor1.val[0]& (int)0xF8;
            //int teste =valor.val[0];
            LSBytes=(int)valor2.val[0]&0xE0; //selecionar os 3 MS bits e zerar os 5 LS bit
            newImg.at<uchar>(i,j)=(int)(MSBytes|(LSBytes>>5));
            cout<<"M-Antes: "<<valor1.val[0]<<" Depois: "<<MSBytes<<endl;
            cout<<"H-Antes: "<<valor2.val[0]<<" Depois: "<<LSBytes<<endl;

        }
    }
    imshow("Imagem Original",matMain);
    imshow("Imagem to hide",matHide);
    imshow("Imagem Final",newImg);

    waitKey();

    //cout << "Hello World!" << endl;
    return 0;
}
