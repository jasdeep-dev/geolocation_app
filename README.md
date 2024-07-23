# GeoLocation app
## Installation

Follow these steps to install and run the app locally using Docker.


### Prerequisites

- [Docker](https://www.docker.com/get-started)


### Instructions

1. Clone the project repository.
2. Navigate to the project directory.
3. Run `make setup` to set up the project.
4. Use `make start` to start the application.
5. Your rails application will be up and running.
6. Navigate to `ip_geolocations.html` to see the ui.
5. You will need a user to run the app.
#### Steps to create a users
 - `make console` will open the rails console.
 - Run this query.
    ```
    User.create(name: "user", email: "user@example.com", password: "password")
    ```

6. Hit a curl request to get the token.
```
    curl -X POST http://localhost:8000/api/v1/login            
    -H "Content-Type: application/json" \
    -d '{
    "email": "user@example.com",
    "password": "password"
    }'  
```
6. In response, you will get a token, replace '====TOKEN====' on line number 72 in `ip_geolocations.html` and everything will be up and running.

