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
    Vec3b LSBytes;
    Vec3b MSBytes;


    matMain=imread("../../imgs/praia_color.jpg",CV_LOAD_IMAGE_COLOR);
    matHide=imread("../../imgs/meme.jpeg",CV_LOAD_IMAGE_COLOR);
    if((!matMain.data) || (!matHide.data)){
        cout<<"Falha em abrir arguma das imagens"<<endl;
    }
    //cvtColor(matMain,newImg,CV_BGR2GRAY);
   // namedWindow("Imagem Original",WINDOW_AUTOSIZE);
   //namedWindow("Imagem to hide",WINDOW_AUTOSIZE);
    namedWindow("Imagem Final",WINDOW_AUTOSIZE);
   // namedWindow("Separação - Main",WINDOW_AUTOSIZE);
   // namedWindow("Separação - Hide",WINDOW_AUTOSIZE);
    width=matMain.size().width;
    height=matMain.size().width;
    resize(matHide,matHide,matMain.size());

    newImg.create(matMain.size(),matMain.type());
    newImg=matMain.clone();
    //matMain.clone()
    Vec3b valor1;
    Vec3b valor2;
    Vec3b aux;
    for (int i=0;i<newImg.size().height;i++){
        for(int j=0;j<newImg.size().width;j++){
            valor1=matMain.at<Vec3b>(i,j); //selecionar 5 MS bits e zerar os 3 LS bits
            valor2=matHide.at<Vec3b>(i,j);
            //cout<<"M-Antes: "<<(int)valor1.val[0]<<endl;
            //cout<<"H-Antes: "<<valor2<<endl;

            MSBytes.val[0]=(int)valor1.val[0]&(int)0xF8;
            MSBytes.val[1]=(int)valor1.val[1]&(int)0xF8;
            MSBytes.val[2]=(int)valor1.val[2]&(int)0xF8;
            //cout<<MSBytes<<endl;
            //int teste =valor.val[0];
            LSBytes.val[0]=(int)(valor2.val[0]&0xE0)>>5; //selecionar os 3 MS bits e zerar os 5 LS bit
            LSBytes.val[1]=(int)(valor2.val[1]&0xE0)>>5;
            LSBytes.val[2]=(int)(valor2.val[2]&0xE0)>>5;
            //cout<<LSBytes<<endl;

            aux.val[0]=(MSBytes[0]|LSBytes[0]);
            aux.val[1]=(MSBytes[1]|LSBytes[1]);
            aux.val[2]=(MSBytes[2]|LSBytes[2]);

//            aux[0]=0;
//            aux[1]=0;
//            aux[2]=255;
            //cout<<aux<<endl;
            //cout<<"Antes "<<newImg.at<Vec3b>(i,j)<<endl;
            newImg.at<Vec3b>(i,j)=aux;
            //cout<<"Depois "<<newImg.at<Vec3b>(i,j)<<endl;

        }
    }
    //waitKey();
    //cout<<"saiu"<<endl;
    imshow("Imagem Original",matMain);
    imshow("Imagem to hide",matHide);
    imshow("Imagem Final",newImg);

    waitKey();
//    //Etapa de separação
//    splitMain.create(matMain.size(),matMain.type());
//    splitHide.create(matHide.size(),matHide.type());
//    for(int i=0;i<height;i++){
//        for(int j=0;j<width;j++){
//            splitMain.at<uchar>(i,j)=newImg.at<uchar>(i,j)&0xF8;
//            splitHide.at<uchar>(i,j)=(newImg.at<uchar>(i,j)&0x07)<<5;
//        }

//    }
//    imshow("Separação - Main",splitMain);
//    imshow("Separação - Hide",splitHide);
//    waitKey();


    //cout << "Hello World!" << endl;
    return 0;
}
