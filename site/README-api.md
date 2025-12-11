# CloudedX API Overview (Demo Site)

This project repository focuses on infrastructure and Kubernetes configuration. For the marketing site included under
`site/`, the following demo endpoints are conceptually referenced:

- `/api/cluster/summary` – returns a snapshot of cluster health and key metrics
- `/api/auth/login` – handles user authentication against an identity provider
- `/api/payments/checkout` – integrates with a payment gateway in real deployments

The static site in this repository does not call real APIs, but the structure is designed so that these endpoints can be
implemented behind a reverse proxy or gateway in a production environment.

