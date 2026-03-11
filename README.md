# Highly Available Multi-Tier AWS Network Architecture
### Infrastructure as Code | Terraform | AWS VPC | West Midlands Police Interview Project

---

## Overview

This project provisions a secure, multi-tier network architecture on AWS using 
Terraform. It demonstrates the principle of **defence-in-depth** — a core 
requirement for infrastructure supporting sensitive policing systems such as 
Response, Custody and Intelligence data platforms.

The architecture physically isolates public-facing resources from private 
backend systems, ensuring sensitive data has no direct route to the internet.

---

## Architecture Diagram
```
Internet
    │
    ▼
Internet Gateway (IGW)
    │
    ▼
┌─────────────────────────────────────┐
│           VPC: 10.0.0.0/16          │
│                                     │
│  ┌──────────────────────────────┐   │
│  │  Public Subnet: 10.0.1.0/24  │   │
│  │  (Load Balancer / Bastion)   │   │
│  │  Security Group: HTTPS only  │   │
│  └──────────────┬───────────────┘   │
│                 │ internal only     │
│  ┌──────────────▼───────────────┐   │
│  │  Private Subnet: 10.0.2.0/24 │   │
│  │  (Databases / App Servers)   │   │
│  │  Security Group: VPC only    │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Security Design Decisions

| Decision | Rationale |
|---|---|
| `eu-west-2` (London) region | UK data sovereignty for law enforcement data |
| Private subnet has no IGW route | Databases cannot reach or be reached from the internet |
| HTTPS (443) only on public SG | No plaintext traffic permitted |
| Private SG egress locked to VPC CIDR | Prevents data exfiltration if a resource is compromised |
| Separate route tables per subnet | Changes to one subnet's routing cannot accidentally affect the other |

---

## AWS Resources Provisioned

- **VPC** — Isolated private network (`10.0.0.0/16`)
- **Public Subnet** — Internet-facing tier (`10.0.1.0/24`)
- **Private Subnet** — Protected backend tier (`10.0.2.0/24`)
- **Internet Gateway** — Controlled bridge to the internet
- **Route Tables** — Public routes to IGW; private stays local
- **Security Groups** — Least-privilege firewall rules per tier

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- AWS CLI configured with valid credentials (`aws configure`)
- An AWS account

---

## Usage
```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/wmp-aws-vpc-terraform.git
cd wmp-aws-vpc-terraform

# Initialise Terraform
terraform init

# Preview what will be created
terraform plan

# Deploy the infrastructure
terraform apply

# Tear down when done (avoids AWS charges)
terraform destroy
```

---

## Infrastructure Lifecycle

This project follows responsible infrastructure management. After verification 
via the AWS Console Resource Map, `terraform destroy` was run to ensure 
zero ongoing cost — consistent with cost-efficient cloud operations.

---

## Author

**Jamil Chowdhury**  
AWS Certified Cloud Practitioner  
[LinkedIn](https://linkedin.com/in/YOUR_PROFILE) | [GitHub](https://github.com/YOUR_USERNAME)


