<h1 align="center">URL Shortener Platform on AWS ECS</h1>

<div align="center">

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![Amazon ECS](https://img.shields.io/badge/Amazon%20ECS-FF9900?style=for-the-badge&logo=amazonecs&logoColor=white)
![AWS Fargate](https://img.shields.io/badge/AWS%20Fargate-FF9900?style=for-the-badge&logo=awsfargate&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Amazon RDS](https://img.shields.io/badge/Amazon%20RDS-527FFF?style=for-the-badge&logo=amazonrds&logoColor=white)
![Amazon ElastiCache](https://img.shields.io/badge/ElastiCache-C925D1?style=for-the-badge)
![Amazon SQS](https://img.shields.io/badge/Amazon%20SQS-FF4F8B?style=for-the-badge&logo=amazonsqs&logoColor=white)
![AWS WAF](https://img.shields.io/badge/AWS%20WAF-DD344C?style=for-the-badge)
![CloudWatch](https://img.shields.io/badge/CloudWatch-FF9900?style=for-the-badge&logo=amazoncloudwatch&logoColor=white)

</div>

## Overview

A secure URL shortening platform running on AWS ECS Fargate, designed around Infrastructure as Code, automated deployments, and resilient release strategies.

Infrastructure is provisioned entirely through Terraform within a custom multi-AZ VPC using private subnets for all application workloads. GitHub Actions authenticates to AWS using OpenID Connect (OIDC), removing the need for long-lived AWS credentials, while Amazon ECS delivers application updates using native canary deployments with CloudWatch alarm based automatic rollback.

The platform consists of three independent microservices deployed to a single ECS cluster. Amazon RDS PostgreSQL provides persistent storage, Amazon ElastiCache Redis improves API performance through caching, and Amazon SQS enables asynchronous processing of click events. The platform is fronted by an Application Load Balancer protected by AWS WAF, with HTTPS termination provided by AWS Certificate Manager.

## Key Outcomes

- Built a secure, multi-service URL shortening platform on Amazon ECS Fargate, consisting of independent API, Worker and Dashboard services deployed within a custom multi-AZ VPC.

- Provisioned the entire AWS infrastructure using Terraform, including VPC networking, ECS, RDS PostgreSQL, ElastiCache Redis, Amazon SQS, IAM, AWS WAF, ACM, and Application Load Balancer resources through reusable modules.

- Implemented a fully automated CI/CD pipeline using GitHub Actions with OpenID Connect (OIDC), eliminating long-lived AWS credentials while automating container builds, vulnerability scanning, infrastructure deployment, and application releases.

- Deployed application updates using native Amazon ECS canary deployments, progressively shifting production traffic to new task revisions before promoting them to full production.

- Configured automatic deployment rollback using Amazon CloudWatch alarms, enabling failed deployments to revert to the previous healthy task revision without manual intervention.

- Designed the platform following AWS security best practices using private subnets, least privilege IAM roles, AWS WAF, HTTPS with AWS Certificate Manager (ACM), non-root container images, and automated vulnerability scanning with Trivy.

- Optimised infrastructure costs by replacing NAT Gateways with VPC Endpoints, reducing container image sizes through multi-stage Docker builds, and provisioning infrastructure on demand using Terraform.

---
## Architecture

The platform is deployed within a custom multi-Availability Zone Amazon VPC, with all application workloads running in private subnets behind an internet-facing Application Load Balancer. HTTPS traffic is protected by AWS WAF and terminated using AWS Certificate Manager before being forwarded to Amazon ECS Fargate services.

The platform consists of three independent microservices: an API responsible for URL shortening and redirects, a Worker service that processes asynchronous tasks from Amazon SQS, and a Dashboard service for application management. Amazon RDS PostgreSQL provides persistent storage, while Amazon ElastiCache Redis improves application performance through caching.

To reduce operational overhead and improve security, the infrastructure is provisioned entirely with Terraform and deployed through GitHub Actions using OpenID Connect (OIDC). Native Amazon ECS canary deployments combined with Amazon CloudWatch deployment alarms provide automatic rollback when unhealthy task revisions are detected.

<p align="center">
  <img src="docs/architecture.png" alt="Architecture Diagram" width="100%">
</p>

---

## Features

### Platform

- Three independent microservices running on Amazon ECS Fargate
- Infrastructure provisioned entirely with Terraform
- Multi-AZ deployment across private subnets
- HTTPS using AWS Certificate Manager (ACM)

### Deployment

- GitHub Actions CI/CD pipelines
- OpenID Connect (OIDC) authentication to AWS
- Multi-stage Docker builds
- Native Amazon ECS canary deployments
- Automatic CloudWatch alarm-based rollback

### Networking

- Custom Amazon VPC spanning two Availability Zones
- Internet-facing Application Load Balancer
- Private application workloads
- AWS WAF protection
- Security group isolation between services

### Data

- Amazon RDS PostgreSQL for persistent storage
- Amazon ElastiCache Redis for caching
- Amazon SQS for asynchronous event processing

### Security

- Least privilege IAM roles
- Non-root container images
- Vulnerability scanning with Trivy
- No long-lived AWS credentials

## Security

Security was considered throughout both the development lifecycle and platform architecture, following the principle of least privilege and AWS security best practices.

### Secure Development

The repository uses `pre-commit` hooks to improve the security of the codebase before changes are committed.

Security-focused checks include:

- **Gitleaks** to prevent secrets, API keys and credentials from being committed.
- **Terraform validation** to detect invalid infrastructure configurations before they reach the CI pipeline.
- **Merge conflict detection** to reduce the risk of unintentionally deploying unresolved code.

By enforcing these checks locally, potential security issues can be identified and resolved before code is pushed to GitHub.

### Platform Security

- GitHub Actions authenticates to AWS using OpenID Connect (OIDC), eliminating the need for long-lived IAM access keys.
- All application workloads run within private subnets, with only the Application Load Balancer exposed to the internet.
- Security groups restrict communication between services to only the traffic required.
- AWS WAF protects the application using managed rule groups and rate limiting.
- HTTPS is enforced using AWS Certificate Manager (ACM).
- ECS tasks use dedicated IAM roles with only the permissions required for each service.
- Docker images run as a non-root user to reduce the impact of container compromise.
- Container images are automatically scanned for known vulnerabilities using Trivy during the CI pipeline.

## Cost Optimisation

The platform was designed to minimise running costs while maintaining security, scalability, and operational best practices.

- VPC Endpoints are used in place of NAT Gateways, reducing networking costs while allowing private workloads to access AWS services.
- Amazon ECS Fargate removes the need to provision, patch, or manage EC2 instances, allowing compute resources to scale independently with the workload.
- Right-sized Amazon RDS and ElastiCache instances were selected to match the application's requirements while avoiding unnecessary overprovisioning.
- Docker multi-stage builds produce smaller container images, reducing image transfer times and storage consumption.
- Infrastructure is provisioned using Terraform, allowing environments to be created when required and destroyed afterwards to avoid unnecessary cloud costs.

## Pipeline Execution

### Docker Build & Push

Builds container images for the API, Worker, and Dashboard services using a GitHub Actions matrix strategy, allowing all three images to be built in parallel from a single workflow. Each image is scanned for known vulnerabilities using Trivy before being pushed to Amazon ECR with an immutable image tag.

![Docker Build & Push](docs/docker-build-push-workflow.png)

---

### Terraform Apply

Authenticates to AWS using OpenID Connect (OIDC), generates a Terraform execution plan, and provisions or updates the AWS infrastructure. Where new container image tags are available, Terraform updates the ECS task definitions and services, triggering a native Amazon ECS canary deployment.

![Terraform Apply](docs/terraform-apply-workflow.png)

---

### Terraform Destroy

Authenticates to AWS using OpenID Connect (OIDC) before safely destroying all Terraform-managed infrastructure, allowing the environment to be cleaned up when no longer required.

![Terraform Destroy](docs/terraform-destroy-workflow.png)

## Canary Deployments & Automatic Rollback

Application updates are deployed using native Amazon ECS canary deployments, allowing new task revisions to be validated using a small percentage of production traffic before a full rollout.

Rather than replacing all running tasks simultaneously, ECS gradually shifts traffic to the new task revision while continuously monitoring deployment health using Amazon CloudWatch deployment alarms.

### Deployment Strategy

- Native Amazon ECS canary deployments
- 10% initial traffic shift
- 5-minute bake period before promotion
- CloudWatch deployment alarms
- Automatic rollback on deployment failure

### Rollback Validation

To verify the rollback mechanism, the application's `/healthz` endpoint was intentionally modified to return an unhealthy response during deployment.

The deployment entered the canary phase, where 10% of production traffic was directed to the new task revision for a 5-minute bake period. During this time, the Application Load Balancer health checks failed, causing the associated CloudWatch deployment alarm to enter the `ALARM` state.

Amazon ECS automatically cancelled the deployment, redirected production traffic to the previous healthy task revision, and completed the rollback without requiring manual intervention.

This validated both the deployment alarm configuration and the automatic rollback behaviour.

![Rollback Validation](docs/rollback-validation.png)

---

### CloudWatch Deployment Alarm

The deployment alarm continuously monitored the health of the Application Load Balancer target group throughout the canary deployment. When the unhealthy host count exceeded the configured threshold, the alarm entered the `ALARM` state, signalling Amazon ECS to roll back the deployment automatically.

![CloudWatch Deployment Alarm](docs/cloudwatch-deployment-alarm.png)

## Project Structure

```text
.
├── app/
│   ├── src/
│   └── tests/
│
├── services/
│   ├── dashboard/
│   └── worker/
│
├── infra/
│   ├── bootstrap/
│   ├── envs/
│   └── modules/
│
├── .github/
│   └── workflows/
│
├── docker-compose.yml
├── README.md
└── docs/
```

## Local Development

### Run Locally

Clone the repository:

```bash
git clone https://github.com/<username>/url-shortner.git
cd url-shortner
```

Start the local development environment:

```bash
docker compose up --build
```

Stop the environment:

```bash
docker compose down
```

---

### Deploy to AWS

#### 1. Bootstrap the Terraform Backend

Provision the remote Terraform backend used to store state.

```bash
terraform -chdir=infra/bootstrap init
terraform -chdir=infra/bootstrap apply
```

---

#### 2. Deploy the Platform

Initialise Terraform:

```bash
terraform -chdir=infra/envs/dev init
```

Review the execution plan:

```bash
terraform -chdir=infra/envs/dev plan
```

Deploy the infrastructure:

```bash
terraform -chdir=infra/envs/dev apply
```

---

#### 3. Destroy the Platform

Remove all provisioned infrastructure when it is no longer required:

```bash
terraform -chdir=infra/envs/dev destroy
```
