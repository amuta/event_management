# Event Management API

Welcome to the Event Management API! This Ruby on Rails application allows users to manage events with features like user authentication, role-based access control, and event filtering. Below you'll find everything you need to get started.


## Features

- **User Authentication**: Secure your account with JWT-based authentication.
- **Event Management**: Create, update, delete, and view events.
- **Role-Based Access Control (RBAC)**: Roles and permissions for managing users and events.
- **Filtering and Pagination**: Filter events by date, location, or keyword, and paginate results.
- **Continuous Integration**: Automated testing and linting via GitHub Actions to ensure code quality.

## Getting Started

### Prerequisites

If you are using Docker, you don't need to install anything other than Docker and Docker Compose. If you are setting up the project manually, you'll need the following:

- Ruby 3.3.0
- Bundler
- SQLite

### Installation

#### Using Docker

If you are using Docker, just run the following command:

```bash
# Note: set your own email and password for the admin user
EMAIL=myadmin@example.com PASSWORD=mysecurepassword docker-compose up --build -d
```

If you don't provide `EMAIL` and `PASSWORD`, the system will default to `admin@example.com` and `password`. Once the container is running, visit `http://localhost:3000` to see the API documentation.

#### Manual Setup

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/event-management-api.git
   cd event-management-api
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Set up the database**:

   ```bash
   bundle exec rails db:create db:migrate
   bundle exec rails setup:seed_roles

   # Note: set your own email for the admin user
   bundle exec rails setup:create_admin_user EMAIL=myadmin@example.com PASSWORD=mysecurepassword
   ```

4. **Run the tests**:

   ```bash
   bundle exec rspec
   ```

5. **Start the server**:

   ```bash
   rails server
   ```

   Access the server at `http://localhost:3000`, and you're all set! The API documentation is available at the root URL.

### API Endpoints

- **POST /signup**: Register a new user and receive an authentication token.
- **POST /login**: Log in with your credentials to receive an authentication token.
- **POST /events**: Create a new event (Authenticated users only).
- **GET /events**: List all events with filtering and pagination options.
- **GET /events/:id**: View a specific event.
- **PUT /events/:id**: Update an event (Event owner or User with __update_any_event__ permission).
- **DELETE /events/:id**: Delete an event (Event owner or User with __delete_any_event__ permission).

### Admin API Endpoints

For managing users' roles:

- **GET /admin/roles**: List all roles with pagination. (__index_roles__ permission required)
- **GET /admin/users**: List all users with pagination. (__index_users__ permission required)
- **GET /admin/users/:user_id/roles**: List all roles for a specific user. (__index_user_roles__ permission required)
- **POST /admin/users/:user_id/roles/:role_id/add**: Add a role to a user. (__add_user_role__ permission required)
- **DELETE /admin/users/:user_id/roles/:role_id/remove**: Remove a role from a user. (__remove_user_role__ permission required)

### Role-Based Access Control (RBAC)

The API implements a permission-based RBAC system. Below are the available permissions and roles:

**Permissions:**
- **__update_any_event__**: Update any event.
- **__delete_any_event__**: Delete any event.
- **__add_user_role__**: Add a role to a user.
- **__remove_user_role__**: Remove a role from a user.
- **__index_roles__**: List all roles.
- **__index_users__**: List all users.
- **__index_user_roles__**: List all roles for a specific user.

**Roles:**
- **admin**: Full access to all permissions.
- **event_manager**: Can update and delete any event.
- **user_manager**: Can add and remove roles from users, and list roles and users.

### Continuous Integration

This project is configured with GitHub Actions for automated testing and linting on every push. This ensures that the code remains clean and the application is reliable.

### Example Usage with cURL

1. **Sign up**:

  ```bash
  export USER_EMAIL="your_email@example.com"
  export USER_PASSWORD="your_secure_password"

  curl -X POST http://localhost:3000/signup \
    -H "Content-Type: application/json" \
    -d '{
      "name": "Your Name",
      "email": "'"$USER_EMAIL"'",
      "password": "'"$USER_PASSWORD"'",
      "password_confirmation": "'"$USER_PASSWORD"'"
    }'
  ```

2. **Log in and fetch JWT Token**:

  ```bash
  export USER_EMAIL="your_email@example.com"
  export USER_PASSWORD="your_secure_password"
  TOKEN=$(curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"$USER_EMAIL"'",
    "password": "'"$USER_PASSWORD"'"
  }' | jq -r '.token')

  echo $TOKEN
  ```

3. **Create a new event**:

  ```bash
  curl -X POST http://localhost:3000/events \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{
      "name": "Your Event Title",
      "description": "Your Event Description",
      "location": "Your Event Location",
      "start_time": "2022-12-31T23:59:59",
      "end_time": "2023-01-01T00:00:00"
    }'
  ```

4. **List all events**:

  ```bash
  curl -X GET http://localhost:3000/events \
    -H "Content-Type: application/json" \
    | jq
  ```
