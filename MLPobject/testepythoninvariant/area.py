import cv2 as cv

def momentos(img,p,q):
    sumMoment = 0
    for i in range(1,len(img)-1):
        for j in range(1,len(img[0])-1):
            sumMoment += (i**p)*(j**q)*img[i][j]
    return sumMoment/255

def momentosCentrais(img,p,q):
    xMedium = momentos(img,1,0)/momentos(img,0,0)
    yMedium = momentos(img,0,1)/momentos(img,0,0)
    sumMomentCentral = 0
    for i in range(1,len(img)-1):
        for j in range(1,len(img[0])-1):
            sumMomentCentral += ((i-xMedium)**p)*((j-yMedium)**q)*img[i][j]
    return sumMomentCentral/255

def momentosEscala(img,p,q):
    momentInvariant = (momentosCentrais(img,p,q))/(momentos(img,0,0)**((p+q+2)/2))
    return momentInvariant

def huMoments(img):
    huMomentsList = []

    huMomentsList.append(momentosEscala(img,2,0) + momentosEscala(img,0,2)) # I 1

    huMomentsList.append(((momentosEscala(img,2,0) - momentosEscala(img,0,2))**2) + (4*(momentosEscala(img,1,1)**2))) # I 2

    huMomentsList.append(((momentosEscala(img,3,0) - 3*momentosEscala(img,1,2))**2) + ((3*momentosEscala(img,2,1) - momentosEscala(img,0,3))**2)) # I 3

    huMomentsList.append(((momentosEscala(img,3,0) + momentosEscala(img,1,2))**2) + ((momentosEscala(img,2,1) + momentosEscala(img,0,3))**2)) # I 4

    huMomentsList.append( ( momentosEscala(img,3,0) - 3*momentosEscala(img,1,2) ) * ( momentosEscala(img,3,0) + momentosEscala(img,1,2) ) * ( ((momentosEscala(img,3,0) + momentosEscala(img,1,2))**2) - 3*((momentosEscala(img,2,1) + momentosEscala(img,0,3))**2) ) + 
    ( 3*momentosEscala(img,2,1) - momentosEscala(img,0,3) ) * ( momentosEscala(img,2,1) + momentosEscala(img,0,3) ) * ( 3*((momentosEscala(img,3,0) + momentosEscala(img,1,2))**2) - ((momentosEscala(img,2,1) + momentosEscala(img,0,3))**2) )) # I 5

    huMomentsList.append( (momentosEscala(img,2,0) - momentosEscala(img,0,2)) * (((momentosEscala(img,3,0) + momentosEscala(img,1,2))**2) - ((momentosEscala(img,2,1) + momentosEscala(img,0,3))**2)) + 
    4*momentosEscala(img,1,1) * (((momentosEscala(img,3,0))+(momentosEscala(img,1,2))) * ((momentosEscala(img,2,1))+(momentosEscala(img,0,3)))) ) # I 6
    
    huMomentsList.append( ( 3*momentosEscala(img,2,1) - momentosEscala(img,0,3) ) * ( momentosEscala(img,3,0) + momentosEscala(img,1,2) ) * ( ((momentosEscala(img,3,0) + momentosEscala(img,1,2))**2) - 3*((momentosEscala(img,2,1) + momentosEscala(img,0,3))**2) ) - 
    ( momentosEscala(img,3,0) - 3*momentosEscala(img,1,2) ) * ( momentosEscala(img,2,1) + momentosEscala(img,0,3) ) * ( 3*((momentosEscala(img,3,0) + momentosEscala(img,1,2))**2) - ((momentosEscala(img,2,1) + momentosEscala(img,0,3))**2) )) # I 7
    
    return huMomentsList

for i in range(961,1000):
    img = cv.imread("C:\imagens\\triangles\\triangle"+str(i)+".png",0)  # C:\Program Files\CoppeliaRobotics\CoppeliaSimEdu\img.png
    huMomentsLista = huMoments(img)
    toLuaCodes = open("triangles.txt", "at")
    toLuaCodes.write("\n"+str(huMomentsLista[0])+"\n"+str(huMomentsLista[1])+"\n"+str(huMomentsLista[2])+"\n"+str(huMomentsLista[3])+"\n"+str(huMomentsLista[4])+"\n"+str(huMomentsLista[5])+"\n"+str(huMomentsLista[6]))
    toLuaCodes.close()
    print(i)

'''cv.imshow("img",img)
if cv.waitKey(0):
    cv.destroyAllWindows''' 
961