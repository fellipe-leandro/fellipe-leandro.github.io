#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main()
{
    Mat matMain,matHide;
    int width,height;
    Mat newImg;
    Mat splitMain,splitHide;
    int LSBytes;
    int MSBytes;


    matMain=imread("../../imgs/forest.jpg",CV_LOAD_IMAGE_GRAYSCALE);
    matHide=imread("../../imgs/noemie.jpg",CV_LOAD_IMAGE_GRAYSCALE);
    if((!matMain.data) || (!matHide.data)){
        cout<<"Falha em abrir arguma das imagens"<<endl;
    }
    //cvtColor(matMain,newImg,CV_BGR2GRAY);
   // namedWindow("Imagem Original",WINDOW_AUTOSIZE);
   // namedWindow("Imagem to hide",WINDOW_AUTOSIZE);
    namedWindow("Imagem Final",WINDOW_AUTOSIZE);
    namedWindow("Separação - Main",WINDOW_AUTOSIZE);
    namedWindow("Separação - Hide",WINDOW_AUTOSIZE);
    width=matMain.size().width;
    height=matMain.size().width;
    resize(matHide,matHide,matMain.size());

    newImg.create(matMain.size(),matMain.type());
    Scalar valor1;
    Scalar valor2;
    for (int i=0;i<height;i++){ //TROCAR por i<newImg.size().height
        for(int j=0;j<width;j++){
            valor1=matMain.at<uchar>(i,j); //selecionar 5 MS bits e zerar os 3 LS bits
            valor2=matHide.at<uchar>(i,j);
            MSBytes=(int)valor1.val[0]& (int)0xF8;
            //int teste =valor.val[0];
            LSBytes=(int)valor2.val[0]&0xE0; //selecionar os 3 MS bits e zerar os 5 LS bit
            newImg.at<uchar>(i,j)=(int)(MSBytes|(LSBytes>>5));
            //cout<<"M-Antes: "<<valor1.val[0]<<" Depois: "<<MSBytes<<endl;
            //cout<<"H-Antes: "<<valor2.val[0]<<" Depois: "<<LSBytes<<endl;

        }
    }
   // imshow("Imagem Original",matMain);
   // imshow("Imagem to hide",matHide);
    imshow("Imagem Final",newImg);

    waitKey();
    //Etapa de separação
    splitMain.create(matMain.size(),matMain.type());
    splitHide.create(matHide.size(),matHide.type());
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            splitMain.at<uchar>(i,j)=newImg.at<uchar>(i,j)&0xF8;
            splitHide.at<uchar>(i,j)=(newImg.at<uchar>(i,j)&0x07)<<5;
        }

    }
    imshow("Separação - Main",splitMain);
    imshow("Separação - Hide",splitHide);
    waitKey();


    //cout << "Hello World!" << endl;
    return 0;
}
