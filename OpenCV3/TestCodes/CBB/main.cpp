#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

void main()
{
    Mat srcImage = imread("1.jpg");
    imshow("oriImg",srcImage);
    waitKey(0);

    //图像腐蚀
    Mat element = getStructuringElement(MORPH_RECT,Size(15,15));
    Mat dstImage;
    erode(srcImage,dstImage,element);
    
}