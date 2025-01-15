# Repo Structure

This is a monolithic repository structured as follows:  
- **app/**: Contains all Flutter-related files for the frontend.  
- **src/**: Contains all API-related files for the backend.  

# Project Idea

# Frontend Deployment

The frontend is primarily built for iOS and Android but can also run on macOS (via iPhone mirroring or emulators), Windows, and Linux (via Android emulators). While the web version *should* work, it hasn't been thoroughly tested. 

### Prerequisites  
- Ensure you have Flutter installed. Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) for setup instructions.
- Ensure you have docker installed. Follow the [official Docker installation guide](https://docs.docker.com/get-docker/) for setup instructions.

### Running the Frontend  
1. Navigate to the `/app` directory.  
2. Run the following command:  
   ```bash
   flutter run
   ```

> [!NOTE]  
> - By default, the app connects to https://api.sambot.dev as its backend.  
> - To use a local backend, edit the `apiUrl` variable in `lib/globals.dart`

# Backend Deployment  

## Option 1: Docker Compose (Preferred)  

1. Ensure Docker is installed on your system.  
2. Place the following files just outside the workspace folder:  
   - `papl.env`: Use `.env.example` as a template.  
   - `db_password.txt`: Contains the MySQL database password in plaintext.  
   - `~/caddy_config/Caddyfile`: Use `Caddyfile.example` as a template, ONLY if you're using Caddy as a reverse proxy. Some key things to note:
      - Replace `example.com` with your domain name.
      - Replace `CLOUDFLARE_API` with your Cloudflare API key.
      - Oh yeah, this only works if you're using Cloudflare as your DNS provider. If you're not, you'll have to change the DNS provider in the Caddyfile.

3. Run the following command from the root directory:  
   ```bash
   docker compose up
   ```  

Docker will automatically pull necessary images and build the containers.

### Database Configuration  

- Use `db` as the database URL in your connection string. For example:  
  ```plaintext
  mysql+pymysql://username:password@db/databaseName
  ```  

#### Troubleshooting MySQL Access Issues  

If you encounter issues accessing the MySQL database:  

1. Enter the MySQL container:  
   ```bash
   docker exec -it papl-cw-db-1 mysql -u root -p
   ```  
   Use the randomly generated root password found in the logs.  

2. Update the password for the user account:  
   ```sql
   ALTER USER '<Username>' IDENTIFIED BY '<NewPassword>';
   ```  

3. Exit the container and restart Docker Compose:  
   ```bash
   docker compose up
   ```  

### Development Environment  
The backend will run on `127.0.0.1`. To use this with the frontend, ensure the Flutter app is configured to connect to `127.0.0.1` instead of `https://api.sambot.dev`.  

---

## Option 2: Manual Deployment  

1. Ensure MySQL is running with a valid user account and password.  
2. Navigate to the `/src` directory.  
3. Run the backend server using:  
   ```bash
   uvicorn app:app
   ```  

### Configuration  

- Ensure you have a `.env` file with the correct database connection string, for example:  
  ```plaintext
  mysql+pymysql://username:password@db/databaseName
  ```