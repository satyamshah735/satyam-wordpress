# WordPress Docker Starter

This project provides a containerized WordPress environment using Docker Compose. Follow the steps below to get your local development environment up and running.

---

## 🚀 Quick Start

### 1. Rename the Project
Before starting, search and replace all instances of the placeholder name with your actual project name:
* Replace `my_project`
* Replace `my-project`

### 2. Configuration & Credentials
You need to set up your WordPress configuration file:
1.  **Copy** `wp-config-sample.php` and rename the copy to `wp-config.php`.
2.  **Open** `compose.yml` to find your specific database credentials (`DB_NAME`, `DB_USER`, `DB_PASSWORD`).
3.  **Update** `wp-config.php` with those credentials.

### 3. Usage Commands
Use the provided shell script to manage the Docker containers:

| Action | Command |
| :--- | :--- |
| **Start** | `bash start-docker.sh` |
| **Restart** | `bash start-docker.sh restart` |
| **Stop** | `bash start-docker.sh stop` |
| **Terminal Access** | `bash app-cli.sh` |

> [!NOTE]
> Use `bash app-cli.sh` to open an interactive shell session inside the running WordPress container.

---

## 📁 Directory Structure & Mounting

The project is structured to ensure your data and configurations persist outside of the containers. The `/html` folder contains all core WordPress files.

**Persisted Files:**
The following items are mounted from the **root directory** to the appropriate paths inside the WordPress container:
* `wp-config.php`
* `uploads/` folder

---