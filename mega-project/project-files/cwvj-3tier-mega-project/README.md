# Cloud With VarJosh - GitHub Actions Mega Project

A production-grade three-tier application used to demonstrate GitHub Actions, DevSecOps, AWS, EKS, ECR, RDS, and GitOps progressively.

## Application architecture

Frontend (React) -> Backend (Spring Boot REST API) -> PostgreSQL / Amazon RDS

## Project structure

- `frontend/` - React + Vite presentation tier
- `backend/` - Spring Boot REST API and Flyway migrations
- `.github/workflows/` - GitHub Actions workflow

The application is intentionally kept simple enough to understand while leaving room for later CI/CD, security scanning, containerization, AWS, Kubernetes, and GitOps stages.

The codebase will later be used to introduce controlled examples of dependency vulnerabilities, code-quality issues, insecure configurations, secrets, and container issues for scanner demonstrations. These examples are not included in the clean baseline.
