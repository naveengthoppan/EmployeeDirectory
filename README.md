# EmployeeDirectory

## Build tools & versions used
Xcode 13.3 (13E113)
iOS Deployment Target 15.4

## Steps to run the app
The application can be run on Xcode and no 3rd party packages are used.

## What areas of the app did you focus on?
The major focus was on caching the images from URL. Also tested the network calls using the end points provided.

## What was the reason for your focus? What problems were you trying to solve?
I have not worked on caching images before as the application I work has very limited remote server calls and it is mostly offline. I was trying to implement the caching without using 3rd party packages.

## How long did you spend on this project?
The project took about 5 hours to complete.

## Did you make any trade-offs for this project? What would you have done differently with more time?
More attention was given to the caching of images. The caching is limited to basic caching using in-memory and on-disk. I would have focussed more on enhancing UI and network layer if there was more time.

## What do you think is the weakest part of your project?
The weakest part would be the UI and the architecture as I switched to MVC from MVVM as there were only limited operations in the mployee listing screen.

## Did you copy any code or dependencies? Please make sure to attribute them here!
I have followed a tutorial from CocoaControls for image caching. 

## Is there any other information you’d like us to know?
I spent some time creating a model with URL type for employee image URLs and there were few issues when trying to Parse using this model. So I parsed the model usig strings for URL.
