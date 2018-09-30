<h1 align="center"> On The Map </h1> <br>

<h4 align="center">View map showing pins, which can be selected to display site URL's.</h4> <br>
 

## Intro

This project allows you to view pins loaded from an API onto a map view. After signing in, current pins will load onto the the map with URL's assigned. You can then tap on them to view the URL via an external browser.  

<p align="center">
  <img alt="onthemap" title="onthemap" src="screenshots/onthemap1.gif" width=300>
</p>
<br>

## Functions 

* Sign-in to app using host API.
* API controllers to load user pins and post user pin.  
* Mapview controller to display pins. 
* Load URL's with external browser.
* Toggle between MapView and TableView.
<br>

## Methods on the Main Thread

An interesting part of the MapView controller was updating the UI when pins were loaded. Several functions had to use the "performUIUpdatesonMain" method to call a UI update on the main thread.  This was because API calls would run on a background thread, so UI updates had to be specified as running on the main thread. 

``` swift
func markPins(_ studentinfo : [studentInformation], _ refresh : Int)
    {
        performUIUpdatesOnMain {
            if(refresh == 1)
            {
                let annotationRefresh = self.mapView.annotations
                
                for i in annotationRefresh{
                    self.mapView.removeAnnotation(i)
                }
                print ("annotations removed after refresh")
            }           
        }
        
        for student in studentinfo
        {
            if  let latitude = student.latitude,let longitude = student.longitude{
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)               
                let coordinate =   CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                if let firstName = student.firstName,let lastName = student.lastName
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = student.mediaURL               
                    annotations.append(annotation)
                }
            }
        }
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }
```
<br>

## Article Tips

Some good articles for tips : <br>
* <a href="https://www.techrepublic.com/blog/software-engineer/create-your-own-web-service-for-an-ios-app-part-one/">Create your own web service for an iOS app - Part One</a> <br>
* <a href="https://www.hackingwithswift.com/example-code/location/how-to-add-annotations-to-mkmapview-using-mkpointannotation-and-mkpinannotationview">How to add annotations to MKMapView</a> <br>
* <a href="https://www.yudiz.com/working-with-unwind-segues-in-swift">Working with Segue unwinds in Swift</a><br>
* <a href="https://blog.supereasyapps.com/30-auto-layout-best-practices/#layout-ui-for-one-iphone">30 Auto Layout Best Practices</a>
