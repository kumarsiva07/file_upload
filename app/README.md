# README


`cd app && bundle install`

`rake db:setup && rake db:migrate && rails s`

Open postman

POST   http://localhost:3000/users/ 

{"name": "name", "email": "kumarsiva0707@gmail.com"}


POST  http://localhost:3000/users/1/images

send image => file  

Type : Form-data 
Key : image
Value: select your file

GET http://localhost:3000/users/1/images



We can controll file in https://github.com/kumarsiva07/file_upload/blob/master/app/app/uploaders/image_uploader.rb
file type, storage, size, image sizes, etc
