# teslo_shop

App of Inventory of products that help to bussines: 

- View all the information of their products (price, description, images,etc) in the app. 
- Load new products informations to Backend/Rest API Endpoints, using the camera and the gallery of the phone when user is using the app.

# Technologies: 

- Local Backend use:
    - Enviroment variables. 
    - Bearer token in authentication headers. 
    - Local DataBase postgres: for storage new user account and products informations
    - REST API as architecture style of API for communication between Client and Server.
    - Docker(image docker, docker compose) as open platform for developing, shipping, and running applications.

- Flutter use:
    - Riverpod as state manager.
    - Dio for request CRUD (Create Read Update Delete) Rest API Endpoints.  
    - GoRouter for navigation.
    - Shared Preference for saved the Bearer token when user do an authentication. 
    
