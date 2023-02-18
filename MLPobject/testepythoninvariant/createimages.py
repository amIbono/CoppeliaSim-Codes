import cv2 as cv 
import random

# Just the basics, this program can create the amount of images that you want, randomly rotating and resizen then. You can use this program to generate sample images and test images for neural network stuffs.

numberOfImages = 500 # Type the number of images to create

toDuplicateImg = cv.imread("C:\imagens\\triangles\\triangle0.png",0) # Put the image that you want do duplicate, you will need to write that here and in the duplicate images. This program have this example to follow with.
cv.imshow("Image that will be duplicated",toDuplicateImg) 
cv.waitKey(0)
cv.destroyAllWindows()
width, height = toDuplicateImg.shape[0],toDuplicateImg.shape[1]
mediumX, mediumY = (width // 2, height // 2)

for i in range(500,numberOfImages+501):
    RNGToResize = random.randint(-54,100)
    RNGToRotate = random.randint(0,360)
    matrixToRotate = cv.getRotationMatrix2D((mediumX, mediumY), RNGToRotate, 1.0)
    duplicateImg = cv.warpAffine(toDuplicateImg, matrixToRotate, (width, height))
    duplicateImg = cv.resize(duplicateImg,[width+RNGToResize,height+RNGToResize])
    cv.imwrite("C:\imagens\\triangles\\triangle"+str(i)+".png",duplicateImg) # Here is where the duplicate images get saved, write that here to. Use \\ to skip the special caracters.

print("You have duplicate",str(numberOfImages),"images")
