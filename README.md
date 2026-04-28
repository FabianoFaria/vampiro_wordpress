# Vampiro Blogueirinho — WordPress ![version](https://img.shields.io/badge/version-1.1.0-blue)

Dockerized WordPress setup for [vampiroblogueirinho.com.br](https://vampiroblogueirinho.com.br), configured for CI/CD pipelines and multi-project Docker Compose integration.

---

## Project structure

```
.
├── docker-compose.yml       # Service definitions
├── wp-config.php            # WordPress config — reads all credentials from env vars
├── .env.example             # Documents all required environment variables
├── .gitignore               # Excludes .env from version control
└── wp-content/              # Themes, plugins, and uploads (volume-mounted)
```

---

## Services

| Service | Image | Description |
|---|---|---|
| `wordpress` | `vampiro_wordpress` | WordPress running on Apache |
| `nginx-proxy` | `jwilder/nginx-proxy` | Reverse proxy with virtual host routing |
| `letsencrypt-nginx-proxy-companion` | `jrcs/letsencrypt-nginx-proxy-companion` | Automatic SSL certificate management |

---

## Environment variables

Copy `.env.example` to `.env` and fill in the values before running the project.

```bash
cp .env.example .env
```

| Variable | Description |
|---|---|
| `MYSQL_HOST` | Database host (provided by the parent compose project) |
| `MYSQL_PORT` | Database port (default: `3306`) |
| `MYSQL_USER` | Database username |
| `MYSQL_PASSWORD` | Database password |
| `MYSQL_DATABASE` | Database name |
| `APACHE_SERVER_NAME` | Primary domain (e.g. `vampiroblogueirinho.com.br`) |
| `VIRTUAL_HOST` | Comma-separated virtual hosts for nginx-proxy |
| `LETSENCRYPT_HOST` | Comma-separated domains for SSL certificate |
| `LETSENCRYPT_EMAIL` | Email address for Let's Encrypt notifications |

---

## Multi-project Docker Compose integration

This project connects to an external Docker network (`shared_network`) to communicate with services — such as a MySQL database — defined in a separate compose project.

### Setup

1. Create the shared network once on the host:

```bash
docker network create shared_network
```

2. In the parent compose project, declare the same network:

```yaml
networks:
  shared_network:
    name: shared_network
```

3. Bring up the parent project first, then this one:

```bash
docker compose -f ../parent-project/docker-compose.yml up -d
docker compose up -d
```

---

## Running locally

```bash
cp .env.example .env
# fill in .env values
docker compose up -d
```

WordPress will be available at `http://localhost:8080`.

---

## CI/CD

The pipeline must inject all variables listed in `.env.example` as environment variables before running `docker compose up`. No secrets or environment-specific values are hardcoded in the repository.
