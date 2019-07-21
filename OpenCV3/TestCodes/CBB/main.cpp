#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(int argc, char const *argv[])
{
    Mat srcImage = imread("1.jpg");
    imshow("oriImg",srcImage);
    waitKey(0);

    //图像腐蚀
    Mat element = getStructuringElement(MORPH_RECT,Size(15,15));
    Mat dstImage;
    erode(srcImage,dstImage,element);
    imshow("erode image",dstImage);

    //图像模糊
    blur(srcImage,dstImage,Size(7,7));//均值滤波

    //边缘检测
    Mat edge,grayImage;
    cvtColor(srcImage,grayImage,CV_BGR2GRAY);
    blur(grayImage,edge,Size(3,3));
    canny(edge,edge,3,9,3);
    
    return 0;
}
