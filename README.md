# ImSplash
- A sample ios application which shows photos, download photos &amp; add photos into favorite
# Screens:
- Home screen: shows photos' thumbnails, load more page by pape
- Photo screen: show a photo with the download & favorite button. Do downloading if user clicks the download button
- Collection screen: show thumbnail of downloaded photos. Show percentages(from 1% to 100%) of downloading photos

# Frameworks
- RxAlamofire: handles API request, download photo
- Kingfisher: download/cache thumbnail photos

# Techniques:
- Use UIColectionView, UICollectionViewLayout to show photos with origin ratio in 2-column grid layout
- Multithreading for downloading photos, show percentages of current downloadings(progress value) on screen.
- Animation of displaying photo
- AutoLayout by using NSLayoutContraints in Interface Builder

# Need improving:
- Lacking of favorite feature: add/remove photo to/from favorite list
- Download again: if a downloading fails, app will show a button to let user downloads again
- Core data to save, cache & manage downloading & favorite action in local

# Screenshots
<img align="left" width="150" height="310" src="https://github.com/cuongdh1912/ImSplash/blob/master/HomeScreen.png">
<img align="left" width="150" height="310" src="https://github.com/cuongdh1912/ImSplash/blob/master/PhotoScreen.png">
<img align="left" width="150" height="310" src="https://github.com/cuongdh1912/ImSplash/blob/master/CollectionScreen.png">
