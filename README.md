# Virtual-Tourist
This app part of udacity iOS Developer Nanodegree, This app allow anyone to see photos related to any place on earth if there is photo of course using Flickr API.
 * [Project Rubric](https://review.udacity.com/#!/rubrics/1990/view)

## This project focused on

* Store media on the device file system
* Use Core Data for local persistence of an object structure
* Accessing networked data - Flicker API
* Parsing JSON file using Codable (Decodable , Encodable)
* Creating user interfaces that are responsive using asynchronous requests
* Use MapKit framework to display pins on a map

## App Structure
Virtual-Tourist is following the MVC pattern. 

<img src="https://github.com/mohamedspicer/Virtual-Tourist/blob/master/Demo/AppStruct.png" alt="alt text" width="800" height="500" hspace=20 vspace=20 >

## Implementation
### Map Screen 
This screen show what previous pin add if any, allow user to drop new pin on the map by long press and if there is any pin on the map if user tab on it will show persist picture related to that place.

<p align="center">
<img src="https://github.com/mohamedspicer/Virtual-Tourist/blob/master/Demo/mainScreen.png" alt="alt text" width="300" height="550" >
</p>

### Pictures Screen 
if user drop new pin and click that pin the app will move to that screen and trying to dowenlaod images related to this place those images are persist and if he click on one of images will delete that image, using flickr api to get images, The app dowenload 50 images, if you need more press "New Collection" will dowenoad another 50.

<p align="center">
<img src="https://github.com/mohamedspicer/Virtual-Tourist/blob/master/Demo/imagesScreen.png" alt="alt text" width="300" height="550" hspace=20 vspace=20> ><img src="https://github.com/mohamedspicer/Virtual-Tourist/blob/master/Demo/imageScreen2.png" alt="alt text" width="300" height="550" hspace=20 vspace=20>
</p>

<p align="center">
<img src="https://github.com/mohamedspicer/Virtual-Tourist/blob/master/Demo/imagesScreen3.png" alt="alt text" width="300" height="550" hspace=20 vspace=20> ><img src="https://github.com/mohamedspicer/Virtual-Tourist/blob/master/Demo/imageScreen4.png" alt="alt text" width="300" height="550" hspace=20 vspace=20>
</p>

> ## This App uses userDefault to persist last region you visit brefore Terminate the App

## Frameworks
UIKit

MapKit

Core Data
