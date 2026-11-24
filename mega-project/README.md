# GitHub Actions: Production-Grade DevSecOps & Continuous Delivery Workflow

## Video reference for this lecture is the following:

---

## ⭐ Support the Project  

If this **repository** helps you, give it a ⭐ to show your support and help others discover it! 

---

## Need Personalized Guidance on Cloud & DevOps?

Whether you're starting your Cloud & DevOps journey, preparing for interviews, pursuing certifications, designing cloud architectures, enhancing your resume, or planning your next career move, I'm here to help. Book a personalized 1:1 mentoring session tailored to your goals.

👉 **[Book a 1:1 Mentoring Session](https://topmate.io/cloudwithvarjosh)**

---

## Table of Contents

- [Introduction](#introduction)
- [Pre-requisites for this lecture](#pre-requisites-for-this-lecture)
- [Install Required Tools](#install-required-tools)

- [Phase 0: Understand the Application](#phase-0-understand-the-application)
  - [Stage 0: Understand the Application Architecture](#stage-0-understand-the-application-architecture)

- [Phase 1: Project & Repository Foundation](#phase-1-project--repository-foundation)
  - [Stage 1: Prepare the Project and Initial Workflow](#stage-1-prepare-the-project-and-initial-workflow)
  - [Stage 2: Create the GitHub Repository and Push the Initial Code](#stage-2-create-the-github-repository-and-push-the-initial-code)
  - [Stage 3: Establish Repository Governance and Environments](#stage-3-establish-repository-governance-and-environments)
  - [Stage 4: Run and Verify the Initial Workflow](#stage-4-run-and-verify-the-initial-workflow)

- [Phase 2: Continuous Integration & Artifact Publishing](#phase-2-continuous-integration--artifact-publishing)
  - [Stage 5: Integrate Trivy Filesystem Security Scanning](#stage-5-integrate-trivy-filesystem-security-scanning)
  - [Stage 6: Build and Validate the Application](#stage-6-build-and-validate-the-application)
  - [Labs: Create AWS Infrastructure for Our Application](#labs-create-aws-infrastructure-for-our-application)
    - [Lab 1: Create an Amazon EKS Cluster](#lab-1-create-an-amazon-eks-cluster)
    - [Lab 2: Create Networking for SonarQube and Amazon RDS](#lab-2-create-networking-for-sonarqube-and-amazon-rds)
    - [Lab 3: Create Security Groups for SonarQube and Amazon RDS](#lab-3-create-security-groups-for-sonarqube-and-amazon-rds)
    - [Lab 4: Create an Amazon RDS Instance](#lab-4-create-an-amazon-rds-instance)
    - [Lab 5: Install SonarQube on an EC2 Instance](#lab-5-install-sonarqube-on-an-ec2-instance)
  - [Stage 7: Performing Code Analysis with SonarQube](#stage-7-performing-code-analysis-with-sonarqube)
  - [Stage 8: Containerize and Scan the Application](#stage-8-containerize-and-scan-the-application)
  - [Stage 9: Publish and Promote Container Images](#stage-9-publish-and-promote-container-images)

- [Phase 3: AWS & EKS Foundation](#phase-3-aws--eks-foundation)
  - [Stage 10: Allow GitHub Actions to Deploy onto Our EKS Cluster](#stage-10-allow-github-actions-to-deploy-onto-our-eks-cluster)

- [Phase 4: Continuous Delivery & Release Management](#phase-4-continuous-delivery--release-management)
  - [Stage 11: Prepare DEV Environment and Configure Deployment Automation](#stage-11-prepare-dev-environment-and-configure-deployment-automation)
  - [Stage 12: Automate Pull Request Creation](#stage-12-automate-pull-request-creation)
  - [Stage 13: Prepare PROD Environment and Configure Deployment Automation](#stage-13-prepare-prod-environment-and-configure-deployment-automation)
  - [Stage 14: Push, Configure and Validate the Complete Automation](#stage-14-push-configure-and-validate-the-complete-automation)

- [Further Exploring and Evolving the Project](#further-exploring-and-evolving-the-project)
- [Conclusion](#conclusion)
- [References](#references)

---

## Introduction

In this hands-on mega-project, we will build a **production-grade DevSecOps and Continuous Delivery workflow** using **GitHub Actions** for a three-tier user management application. The application consists of a **React frontend**, a **Java 21 and Spring Boot backend**, and a **PostgreSQL database hosted on Amazon RDS**.

Our primary focus will be to use GitHub Actions to automate the software delivery lifecycle, integrating **automated builds and testing, code quality analysis, security scanning, containerization, artifact publishing, and environment-based deployments**.

We will progressively build the CI workflow to scan the repository using **Trivy**, build and validate the frontend and backend, enforce **SonarQube Quality Gates**, build and scan Docker images, and publish the validated images to **Amazon ECR**. We will then introduce separate deployment workflows to deploy the same container images to **DEV and PROD environments on Amazon EKS**.

Security and release governance will be important throughout this implementation. We will configure **OIDC-based authentication** between GitHub Actions and AWS, use dedicated IAM roles, establish **EKS access entries and Kubernetes RBAC**, automate DEV deployments and Pull Request creation, and retain **human-controlled code reviews, merge requirements, and production approvals**.

By the end of this project, our application changes will follow this release process:

**Feature Branch → CI Validation → Container Build and Scan → Amazon ECR → DEV Deployment → Automated Pull Request → Human Review and Merge → PROD Approval → PROD Deployment**

The project is designed to demonstrate how these individual components work together to establish a **secure, traceable, and controlled software delivery process**, with GitHub Actions at its core.

---

## Pre-requisites for this lecture

You should be familiar with the following concepts before starting this lecture. You do **not** need expert-level knowledge, but a basic understanding of the technologies used in this project will make the DevSecOps and deployment flow much easier to follow.

| Topic | What you should know | Resources |
|---|---|---|
| **Git & GitHub** | Commits, branching, merging, rebasing, Pull Requests, code reviews, remote repositories, and basic production Git workflows | **YouTube:** [Git YouTube Playlist](https://www.youtube.com/playlist?list=PLmPit9IIdzwT6nq8hIuf7MBcPVzw3cX3K) <br> **GitHub:** [Git Masterclass](https://github.com/CloudWithVarJosh/Git-Masterclass) |
| **Modern SDLC & CI/CD** | How software moves from **development → build → test → quality/security checks → environment promotion → deployment** | **YouTube:** [Modern SDLC Explained](https://youtu.be/imEHsgvJbYo) <br> **GitHub:** [Modern SDLC Notes](https://github.com/CloudWithVarJosh/Jenkins-Basics-To-Production/tree/main/Day%2001) <br><br> **YouTube:** [CI/CD Explained](https://www.youtube.com/watch?v=szPE1NKc614&ab_channel=CloudWithVarJosh) <br> **GitHub:** [CI/CD & Branching Strategies](https://github.com/CloudWithVarJosh/Jenkins-Basics-To-Production/tree/main/Day%2002) |
| **GitHub Actions** | GitHub Actions fundamentals, workflows, jobs, steps, actions, runners, triggers, secrets, variables, and basic CI/CD workflows | **YouTube:** [GitHub Actions Playlist](https://www.youtube.com/playlist?list=PLmPit9IIdzwThF00pAAvktjkVtL7APhD5) <br> **GitHub:** [GitHub Actions: Basics to Production](https://github.com/CloudWithVarJosh/GitHub-Actions-Basics-To-Production) |
| **Maven** | Maven build lifecycle, dependency management, running tests, and generating build and coverage reports | **YouTube:** [Maven Tutorial for DevOps](https://www.youtube.com/watch?v=3OKc5y_3wMM&ab_channel=CloudWithVarJosh) <br> **GitHub:** [Maven Lecture Notes](https://github.com/CloudWithVarJosh/YouTube-Standalone-Lectures/tree/main/Lectures/08-maven) |
| **SonarQube** | Projects, code analysis, Quality Gates, authentication tokens, coverage, and analysis results | **YouTube:** [SonarQube for DevOps](https://www.youtube.com/watch?v=qyYsLVZDieU) <br> **GitHub:** [SonarQube Lecture Notes](https://github.com/CloudWithVarJosh/SonarQube-For-DevOps/blob/main/README.md) |
| **Docker** | Basic understanding of container images, Dockerfiles, building images, and running containers | Covered as part of my CKA Series. |
| **Kubernetes** | Basic Kubernetes concepts such as Pods, Deployments, Services, namespaces, configuration, and application deployment | **YouTube:** [CKA Course Preparation](https://lnkd.in/g-7UEQfk) <br> **YouTube:** [Kubernetes Projects Playlist](https://lnkd.in/gg4tFfTD) |
| **AWS** | Basic understanding of AWS services, IAM, ECR, EKS, and AWS authentication | The AWS concepts required for each stage will be introduced during the project. |

> **Note:** You do not need to master all of these technologies before starting. The goal is to have a **basic understanding of the technologies that GitHub Actions will integrate with** throughout this project. We will introduce the specific concepts required at each stage, and deeper knowledge will be called out whenever necessary.

---

## Install Required Tools

Ensure the following tools are installed on your local machine or cloud jump-host:

- **Git:** Used to clone the repository, create branches, commit changes, and push code to GitHub. [Installation Guide](https://git-scm.com/install)
- **AWS CLI v2:** Used to configure AWS access and interact with AWS services. [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **eksctl:** Used to create and manage the Amazon EKS cluster. [Installation Guide](https://eksctl.io/installation/)
- **kubectl:** Used to interact with the Kubernetes cluster, manage resources, and verify deployments. [Installation Guide](https://kubernetes.io/docs/tasks/tools/)

---

# GitHub Actions: Production-Grade DevSecOps & Continuous Delivery Workflow

In this demo, we will build a **production-grade DevSecOps and Continuous Delivery workflow** using **GitHub Actions**, **Maven**, **SonarQube**, **Trivy**, **Docker**, **Amazon ECR**, and **Amazon EKS**. We will integrate automated testing, code quality analysis, security scanning, containerization, artifact publishing, and environment-based deployments while implementing **OIDC-based AWS authentication**, **immutable image tags**, **digest-based artifact promotion**, and **human-controlled production approvals**.

We will approach this project in five phases:

1. **Phase 0: Understand the Application**: Explore the three-tier application architecture, understand its frontend, backend, and PostgreSQL database, and trace how these components interact to deliver the application functionality.

2. **Phase 1: Project & Repository Foundation:** Establish the project structure, initialize the GitHub repository, configure SSH authentication, and implement repository governance through branch protection rules and GitHub Environments. Create and verify the initial GitHub Actions workflow.

3. **Phase 2: Continuous Integration & Artifact Publishing:** Build and validate the backend and frontend through automated testing, code coverage analysis, SonarQube Quality Gates, and Trivy security scanning. Containerize the validated application artifacts, scan the resulting images, and publish them to Amazon ECR.

4. **Phase 3: AWS & EKS Foundation:** Prepare the AWS infrastructure required by the project, including Amazon EKS, RDS, networking, and supporting services. Establish secure GitHub Actions access using OIDC, dedicated IAM roles, EKS access entries, and Kubernetes RBAC.

5. **Phase 4: Continuous Delivery & Release Management:** Prepare DEV and PROD environments and implement automated deployment and Pull Request workflows, promoting the same immutable container images across environments. Establish human-controlled code reviews and production approvals, bootstrap the completed workflows, and validate the end-to-end developer-to-production release process.

---

# **Phase 0: Understand the Application**

- Explore the **three-tier architecture**, including the React frontend, Spring Boot backend, and **Amazon RDS for PostgreSQL** database.
- Understand how the **frontend, backend, and database interact** to deliver application functionality.

---

## Stage 0: Understand the Application Architecture

Before building our CI workflow, let's understand **what our application does and how its components work together**. As seen in the diagram, the application follows a **three-tier architecture**, separating the user interface, application logic, and data storage.

**Tier 1: Frontend**

- The frontend uses **React** to build the user interface using reusable components. Users can view, add, edit, and delete user records through the interface. The frontend sends API requests to the backend and displays the responses.
- **Vite** is used as the frontend development server and build tool. During development, it helps us run the application locally. For production, it builds the application into optimized static files, which are then served to users' browsers by **Nginx**.
- We use **npm (Node Package Manager)** to manage the frontend's dependencies and execute project scripts. Although its name includes Node, npm is also widely used in frontend development because tools such as React and Vite rely on the JavaScript ecosystem. It installs the required packages defined in `package.json` and allows us to run commands such as `npm run dev` to start the development server and `npm run build` to invoke Vite's production build process.

| Technology | Responsibility |
|---|---|
| **React** | Builds the user interface |
| **Vite** | Provides the development server and builds optimized production assets |
| **npm** | Manages dependencies and runs project scripts |
| **Nginx** | Serves the generated static files to users' browsers |

---

**Tier 2: Backend**

- The backend is developed using **Java 21 and Spring Boot**. Spring Boot provides the framework and features required to build the application and expose a REST API at `/api/v1/users`. The API receives requests from the frontend, validates the input, and applies the necessary business rules.
- When a request requires data access, the backend communicates with the **PostgreSQL database** through its data-access layer. It retrieves or updates the required records and returns an HTTP response, allowing the frontend to display the result or an appropriate error.
- We use **Maven** as the backend's build and dependency management tool. It downloads and manages the libraries required by the application, invokes the Java compiler, runs tests, and packages the compiled application into a JAR file. This JAR file is then included in our backend container image.

| Technology | Responsibility |
|---|---|
| **Java 21** | Programming language used to develop the backend |
| **Spring Boot** | Framework providing the features required to develop the backend application and expose REST APIs |
| **Maven** | Manages dependencies, invokes compilation and tests, and packages the application into a JAR file |

> **CRUD Operations:** Our backend performs four basic operations on user records stored in PostgreSQL:
> - **Create (POST):** Add a new user record.
> - **Read (GET):** Retrieve existing user records and display them in the frontend.
> - **Update (PUT):** Modify an existing user's details.
> - **Delete (DELETE):** Remove a user record.
>
> The frontend sends these requests to the backend through REST APIs. The backend validates and processes them, while PostgreSQL stores or retrieves the records.

---

**Tier 3: Database**

- **Amazon RDS for PostgreSQL** acts as the application's **persistent data store**, maintaining user records in the `users` table independently of the application containers running on Amazon EKS. This is important because **containers are replaceable**. They can restart, scale, or be replaced during deployments without affecting the data stored in RDS. When a new container starts, the application reconnects to the database and continues working with the existing records.

- **Database constraints** provide an additional layer of **data integrity** by enforcing rules at the database level. Constraints such as **PRIMARY KEY, NOT NULL, UNIQUE, and CHECK**, where defined in the schema, help prevent invalid or duplicate data from being persisted. This complements the validation already performed by our backend application.

> **Production Insight: Managed Database Services**
>
> In modern cloud architectures, using **managed database services** is a very common approach. Rather than running and managing the database within the application Kubernetes cluster, organizations often use externally hosted, cloud-managed database services such as **Amazon RDS, Google Cloud SQL, and Azure SQL Database**.
>
> This is also consistent with my experience over the past **three years**, where most of the RFPs and solution architectures I have worked on have proposed managed database services. This approach allows application teams to leverage the cloud provider's database management capabilities while keeping database operations separate from application workloads.
>
> **This does not mean databases cannot run inside Kubernetes.** StatefulSets provide a way to run stateful applications, including databases, on Kubernetes. However, the choice depends on factors such as **operational capabilities, availability requirements, scalability, backup and recovery, security, and cost**. For many enterprise cloud workloads, managed database services are a practical choice.

---

**How the Application Works**

Let's understand how these three tiers work together from a user's perspective.

1. **Accessing the application:** A user opens the application URL in their browser. The frontend, served by Nginx, loads and displays the user management interface.
2. **Viewing users:** The interface requests the existing user records from the backend. The backend retrieves these records from PostgreSQL and sends them back to the frontend, where they are displayed to the user.
3. **Adding a user:** When a user fills in the details and clicks **Add User**, the frontend sends the information to the backend. The backend validates the input and stores the new record in the PostgreSQL database.
4. **Modifying or deleting a user:** When a user edits or deletes an existing record, the frontend sends the corresponding request to the backend. The backend processes the request and updates or removes the record in the database.
5. **Displaying the result:** The backend sends a response to the frontend, which updates the interface to reflect the changes.

In simple terms, the **frontend allows users to interact with the application**, the **backend processes their requests**, and the **database stores the information**. All three tiers work together to provide the functionality of our application.

---

**Deployment Architecture**

The application will run on **Amazon EKS across multiple Availability Zones**, with the frontend and backend deployed as separate workloads. **Amazon RDS for PostgreSQL** provides the database service separately, keeping data storage independent of the application workloads.

---

**What We'll Build**

We will progressively build a **GitHub Actions CI/CD automation workflow**. The CI process will scan the repository for security issues, build and test the backend, and build the frontend. We will then package both applications into **container images** and publish them to **Amazon ECR**. In subsequent stages, we will introduce separate deployment workflows to deploy these images to DEV and PROD on Amazon EKS.


---

# **Phase 1: Project & Repository Foundation**

- Establish the **project structure**, initialize the GitHub repository, configure **SSH authentication**, and push the initial application code.
- Implement **repository governance** through branch protection rules and GitHub Environments, and establish the initial GitHub Actions workflow.

---

## Stage 1: Prepare the Project and Initial Workflow

In this stage, we will understand the project structure and create the initial GitHub Actions workflow. We will build on this foundation incrementally throughout the project.

---

### Task 1: Understand the Project Directory Structure

We will work with two separate GitHub repositories throughout this project:

- **Course Repository:** [GitHub Actions: Basics to Production](https://github.com/CloudWithVarJosh/GitHub-Actions-Basics-To-Production) is the **complete repository for this GitHub Actions course**. It maintains all the lecture notes, documentation, configuration files, and project resources used throughout the course, including the **mega-project covered in this lecture**. You can refer to this repository whenever you need to revisit the concepts or access the associated course files. Any secret YAML templates included here will contain **placeholder values only**, never actual credentials.

- **GitHub Actions Repository:** We will create a separate GitHub repository named **`mega-project-demo`** together during this lecture. This will be our **hands-on working repository**, where you will follow along and implement, test, and validate the GitHub Actions workflows. It will contain only the contents of the `project-files` directory, pushed directly to the root of the repository.

The following is the target directory structure inside `project-files`. It shows where the project components will live as we progress through the course. **Do not create or populate every file at the beginning.** We will introduce files when they are needed.

```text
project-files/
├── .github/
│   └── workflows/
│       └── ci.yaml
│
├── cwvj-3tier-mega-project/
│   ├── backend/
│   ├── frontend/
│   └── README.md
│
├── infrastructure/
├── kubernetes/
```

The main directories have the following purposes:

- **`cwvj-3tier-mega-project/`** contains our Java backend, React frontend, and application documentation.
- **`.github/workflows/`** contains our GitHub Actions workflows. We will start with `ci.yaml` and add more workflow YAML files as we progress.
- **`infrastructure/`** will contain infrastructure-related configuration, such as the EKS configuration file and networking scripts.
- **`kubernetes/`** will contain Kubernetes manifests and deployment permissions for the DEV and PROD environments.

Only the **contents of `project-files`** will be pushed to the root of the GitHub Actions repository. The `project-files` directory itself will not become an additional directory level in the remote repository.

> **Production Insight:** Keeping application code, infrastructure configuration, Kubernetes manifests, and GitHub Actions workflows in version control provides a **single source of truth** for the project. We will introduce these components incrementally and test each stage before moving forward.

> **Security Note:** The course repository may contain secret YAML templates with placeholder values for learning purposes. Those secret templates will be kept outside `project-files`, so they will not be pushed to the GitHub Actions repository. **Never commit actual credentials or passwords to either repository.**

**Important:** If you are following along, please **progress step by step**. We will make changes to the application code, add workflow YAML files, and introduce infrastructure and Kubernetes configuration as we move through the stages. For now, create or modify files only when instructed.

---

### Task 2: Create the Initial GitHub Actions Workflow

Create a workflow file named **`ci.yaml`** under **`.github/workflows/`** and add the following initial configuration.

```yaml
name: CWVJ CI | Build, Scan and Publish

on:
  push:
    branches:
      - 'feature/**'
      - 'bugfix/**'
      - 'hotfix/**'
    paths:
      - 'cwvj-3tier-mega-project/frontend/**'
      - 'cwvj-3tier-mega-project/backend/**'
      - '.github/workflows/**'
      - 'kubernetes/**'

  workflow_dispatch:

concurrency:
  group: cwvj-ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  workflow-foundation-job:
    name: Workflow Foundation
    runs-on: ubuntu-26.04
    steps:
      - name: Checkout source code
        uses: actions/checkout@v7
```

This is a **minimal working workflow** containing only a checkout job. We will progressively add build, test, security scanning, containerization, image publishing, and other capabilities as we progress.

#### Explanation

- **`name`** defines the workflow's display name in GitHub Actions.
- **`push`** triggers the workflow when changes are pushed to branches matching `feature/**`, `bugfix/**`, or `hotfix/**`.
- **`branches`** restricts automatic execution to the specified development branches. There is intentionally no direct `push` trigger for `main`.
- **`paths`** filters ensure that the workflow runs only when changes affect the frontend, backend, GitHub Actions workflow files, or Kubernetes manifests.
- **`workflow_dispatch`** allows us to trigger the workflow manually from the GitHub Actions interface. Manual execution does not use the `push` branch and path filters.
- **`concurrency`** defines a concurrency group that GitHub uses to manage workflow executions. All runs with the same group identifier belong to the same group.
  - In our configuration, the group identifier includes `${{ github.ref }}`, which identifies the **Git reference associated with the workflow run**. For example, a push to `feature/login` produces `refs/heads/feature/login`.
  - Therefore, **runs triggered for the same branch belong to the same concurrency group**, while **runs for different branches belong to separate groups**.
  - **`github`** is the GitHub context, an object containing information about the workflow run and its execution environment.
  - **`ref`** is a property of the `github` context that provides the Git reference associated with the workflow run.
  - **`${{ }}`** is the expression syntax used by GitHub Actions to evaluate dynamic values and access context properties.
- **`cancel-in-progress: true`** tells GitHub to cancel an already-running execution when a newer run enters the same concurrency group. This ensures that the latest changes take priority over older, outdated CI executions.
- **`jobs`** defines the jobs that the workflow will execute. Each job contains the steps required to perform a specific task.
- **`workflow-foundation-job`** is the unique identifier for our initial job.
- **`runs-on: ubuntu-26.04`** specifies that the job will run on a GitHub-hosted Ubuntu 26.04 runner.
- **`actions/checkout@v7`** checks out the repository's source code on the runner so subsequent steps can access it.

> **Production Insight:** Path filters help avoid unnecessary workflow executions when unrelated files change. Using feature, bugfix, and hotfix branches for development, followed by Pull Requests to merge changes into `main`, supports a controlled development process.

> **Note on path filters:** For the same event, use either `paths` or `paths-ignore`, not both. The same restriction applies to `branches` and `branches-ignore`. If you need to include and exclude paths in the same filter, use positive and negative patterns with `paths`.

> **Note:** This is only the initial workflow configuration. We will add further jobs, steps, and required permissions incrementally as we progress through the project. **Follow each stage in order** rather than copying the complete workflow at the beginning.

---

## Stage 2: Create the GitHub Repository and Push the Initial Code

In this stage, we will create the remote GitHub repository, configure SSH authentication, initialize Git locally, and push our initial code to GitHub.

---

### Task 1: Create the Private GitHub Repository

Create a new GitHub repository with the following configuration:

- **Repository Name:** `mega-project-demo`
- **Visibility:** **Private**

When creating the repository, **do not initialize it** with a README, `.gitignore`, or license. We already have the project structure locally, and we will push it to GitHub ourselves.

We will configure **SSH-based Git authentication** so our local Git client can communicate securely with GitHub.

---

### Task 2: Generate an SSH Key Pair

We will use SSH authentication for Git operations. Generate a dedicated SSH key for this project:

```bash
ssh-keygen -t ed25519 \
  -C "cloudwithvarjosh@gmail.com" \
  -f ~/.ssh/cwvj_mega_project_ed25519
```

This creates two files:

```text
~/.ssh/cwvj_mega_project_ed25519
~/.ssh/cwvj_mega_project_ed25519.pub
```

The **private key must remain on your machine** and must never be shared. The public key will be added to GitHub.

The command-line options have the following purposes:

- **`-t ed25519`** specifies the key algorithm.
- **`-C`** adds an identification comment to the key.
- **`-f`** specifies the key file name and location.

> The value supplied with `-C` is only metadata for identification. It does not participate in authentication.

---

### Task 3: Configure the SSH Agent

When you run **`git push`**, Git invokes the SSH client to establish a secure connection with GitHub if your remote URL uses SSH. The SSH client must authenticate with GitHub using a private key whose corresponding public key is registered with your GitHub account.

The private key can be accessed in two ways:

- **Directly by the SSH client:** The SSH client reads the private key from its file and uses it for authentication. An SSH agent is not required.
  - **Advantages:** Simpler setup, fewer running components, and no need to manage an SSH agent.
  - **Limitations:** If the private key is encrypted, you may need to enter its passphrase whenever the key is used. The SSH client also needs direct access to the private key file.

- **Through an SSH agent:** The SSH agent holds the loaded private key in memory and performs cryptographic signing operations on behalf of the SSH client.
  - **Advantages:** You generally enter the passphrase only when loading the key into the agent, rather than repeatedly during SSH operations. It also provides a centralized way to manage multiple SSH keys without requiring each application to handle the private keys directly.
  - **Limitations:** Requires the SSH agent to be running and accessible to the SSH client. Access to the agent must also be protected because applications with access to it may be able to request authentication operations using its loaded keys.

For this project, we will use an **SSH agent** to explicitly load our project's private key before pushing code to GitHub. This gives us a convenient way to manage the key while avoiding repeated passphrase prompts.

> **Production Insight:** An SSH agent improves convenience and key handling, but it does not eliminate the need to **protect your private key**. Anyone who gains **unauthorized access to your agent socket** may be able to use the loaded identities for authentication, even though they cannot directly extract the private keys. **Keep agent access restricted and avoid forwarding your agent to untrusted remote systems.**

Run the following commands in sequence:

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Load the project's private key into the agent
ssh-add ~/.ssh/cwvj_mega_project_ed25519

# Verify that the key has been loaded
ssh-add -l
```

**How authentication works:**

1. **Git initiates the connection:** When you run `git push`, Git detects that the remote URL uses SSH and invokes the SSH client to establish a secure connection with GitHub.

2. **The SSH client offers the public key:** The SSH client offers the **public key** associated with the authentication attempt. GitHub checks whether the key is acceptable. As part of the optional preliminary check, GitHub can respond with `SSH_MSG_USERAUTH_PK_OK` to indicate that the key is acceptable.

3. **The SSH agent signs the authentication data:** The SSH client requests the SSH agent to generate a **digital signature using the corresponding private key**. The data being signed includes the **SSH session identifier and authentication request information**, binding the signature to the current session. The private key itself never leaves the agent.

4. **GitHub verifies the signature:** GitHub uses the corresponding **public key registered with your account** to verify the signature. Successful verification proves that the client possesses the corresponding private key and completes SSH authentication. GitHub then checks repository permissions and applicable rules to determine whether the push is authorized.

**Authentication Flow:**

```text
git push → Git invokes SSH client → Secure SSH connection established
         → SSH client offers registered public key
         → GitHub checks whether the public key is acceptable
         → GitHub responds with PK_OK (optional preliminary check)
         → SSH client requests SSH agent to sign session-bound authentication data
         → SSH agent signs using the private key
         → SSH client sends the digital signature to GitHub
         → GitHub verifies the signature using the registered public key
         → SSH authentication succeeds
         → GitHub checks repository permissions and rules
         → Push accepted
```

> **Note:** If an SSH agent is not used, the SSH client can access the **private key directly from its file**.

> **Important:** The **SSH agent is not mandatory** for SSH authentication. We are using it to **manage access to our project's private key**.

> **Production Insight:** **Never share or commit your private SSH key** to a Git repository. Only the corresponding **public key** should be registered with GitHub. The **private key must remain securely stored** on your machine.

---

### Task 4: Add the Public Key to GitHub

Display the public key:

```bash
cat ~/.ssh/cwvj_mega_project_ed25519.pub
```

Copy the complete output and navigate to:

**GitHub → Profile Picture → Settings → SSH and GPG Keys → New SSH Key**

Provide the following details:

- **Title:** `cwvj-mega-project`
- **Key:** Paste the public key.

GitHub can now authenticate Git operations originating from this machine using the corresponding private key.

---

### Task 5: Initialize Git and Push the Initial Code

Now that the remote repository and SSH authentication are ready, we will initialize Git locally, create the initial `main` branch, and push the project to GitHub.

From the **`project-files` directory**, run the following commands in sequence:

```bash
# Initialize the local Git repository
git init

# Check the files that Git detects
git status

# Add all project files to the staging area
git add .

# Verify the files staged for the initial commit
git status

# Create the initial commit
git commit -m "ci: add initial GitHub Actions workflow"

# Rename the current branch to main
git branch -M main

# Configure the GitHub repository as the remote origin
git remote add origin git@github.com:CloudWithVarJosh/mega-project-demo.git

# Verify the configured remote
git remote -v

# Push the local main branch to the origin remote. Since no destination branch is specified,
# Git creates/updates a remote branch named main and sets it as the upstream branch.
# To use a different remote branch name, specify both: git push -u origin main:main-remote
git push -u origin main
```

The `-u` option sets the upstream branch. After this initial push, future pushes from the local `main` branch can use `git push`.

**Critical**
At this point, the initial project structure and workflow exist on GitHub, but **the workflow will not run from this push** because our workflow does not include a `push` trigger for `main`.

**Why are we pushing `main` before enabling the full branch ruleset?** The remote repository is initially empty. This first push establishes the `main` branch. Immediately afterward, we will configure the rules that prevent direct pushes and require changes to go through Pull Requests. We will not start feature-branch development until those rules are in place.

> **Production Insight:** The objective is to establish `main` as the protected production code line and ensure that subsequent changes follow a controlled review process. We are making an initial bootstrap push to create the branch, then applying the governance rules before continuing.

---

## Stage 3: Establish Repository Governance and Environments

In this stage, we will establish **repository governance** before introducing CI/CD workflows. We will protect the `main` branch and create the **DEV** and **PROD** environments. This gives us a consistent foundation for the development, testing, and production deployment stages that follow.

---

### Task 1: Protect the Main Branch

We will follow a **trunk-based development** approach. Development will happen through short-lived `feature/*`, `bugfix/*`, and `hotfix/*` branches, while **`main` represents our production code line**.

Our objective is to **prevent direct pushes to `main`** and make Pull Requests the standard route for changes to reach it. We will configure the baseline protections now and enable the required status checks once our CI workflow has run successfully.

---

#### 1.1 Create the Ruleset

1. Go to **Repository → Settings → Rulesets**.
2. Click **New ruleset → New branch ruleset**.
3. Set **Ruleset name** to `protect-main`.
4. Set **Enforcement status** to `Active`.
5. Under **Target branches**, select **Add target → Include by pattern** and enter `main`.

---

#### 1.2 Configure Branch Rules and Create the Ruleset

Enable the following rules:

- **Restrict deletions:** Prevents unauthorized actors from deleting the `main` branch. Only actors with appropriate bypass permissions can delete matching refs.
- **Block force pushes:** Prevents force pushes that rewrite the branch history.
- **Require a pull request before merging:** Ensures that changes reach `main` through a Pull Request rather than a direct push. Configure the following additional settings:
  - **Required approvals: `1`.** Requires at least one approving review from an eligible reviewer before merging.
  - **Dismiss stale pull request approvals when new commits are pushed:** Enable this option to ensure that reviewers approve the latest changes, not an earlier version of the code.
    - If new commits are pushed while a PR is **awaiting approval**, the PR remains open with the new changes and still requires approval.
    - If a PR has **already been approved but has not yet been merged**, and new commits that change the code are pushed, GitHub dismisses the previous approval. The updated PR must be reviewed and approved again before it can be merged.
  - **Require approval of the most recent reviewable push:** Enable this option so that the latest reviewable changes must be approved by someone other than the person who made that push.
  - **Require conversation resolution before merging:** Enable this option so that review conversations must be resolved before a Pull Request can be merged.
  - **Allowed merge methods: `Squash`.** Allows a Pull Request to be merged into a single commit on the target branch.
  - **Require review from specific teams:** Leave unchecked because our demo uses a separate reviewer account rather than a designated review team.
  - **Require an additional approval for unattributed Copilot pull requests:** Leave disabled unless you specifically want to demonstrate this feature. When enabled, it adds an approval requirement for certain Copilot-created Pull Requests.

For now, leave **Require branches to be up to date before merging** unchecked as well. We will enable it alongside the required status checks so that the PR branch must be up to date with `main` before merging.

**Configure the bypass list:**

**Do not add users, teams, or applications to the bypass list.** For this exercise, we want the normal Pull Request process to apply consistently, without allowing routine bypasses of the ruleset.

Once the configuration is complete, click **Create ruleset** to save and activate the branch protection rules.


> **Production Insight:**
> Protecting `main` from **direct pushes** and requiring **independent code reviews** establishes a controlled process for introducing changes into the production codebase. We will progressively strengthen these controls as our **CI/CD workflows** take shape.

> **Plan Note:**
> GitHub Free supports rulesets for **public repositories**. Under our current plan, this ruleset is **not enforced while the repository remains private**. We will make the repository public for the relevant demonstration and **verify that the ruleset is actually enforced** before relying on it to demonstrate branch protection.

For reference, see GitHub's official documentation on [available rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets) and [managing repository rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets).

---

### Task 2: Create and Configure GitHub Environments

Create two GitHub Environments named **`dev`** and **`prod`**. We will use these environments later in the project to separate development and production deployments and their configurations.

---

#### Step 1: Create the DEV Environment

1. Go to **Repository → Settings → Environments**.
2. Click **New environment**.
3. Enter `dev` as the environment name and create it.
4. Under **Deployment branches and tags**, select **Selected branches and tags**.
5. Click **Add deployment branch or tag rule**.
6. Set the reference type to **Branch** and enter the following patterns, adding each one as a separate rule:
   - `feature/*`
   - `bugfix/*`
   - `hotfix/*`
7. Save the rules.

This configuration allows the `dev` environment to be used by workflow deployments running from matching feature, bugfix, and hotfix branches.

> **Note:** You may notice that GitHub displays **0 branches** for the `dev` environment, even though we have added the `feature/*`, `bugfix/*`, and `hotfix/*` rules. This is because we haven't pushed any branches matching these patterns to GitHub yet. Once we push matching branches, GitHub will recognize them. However, when we configure the `prod` environment in the next step, you'll notice that GitHub already detects **1 branch**, `main`, because we pushed it to the remote repository in **Stage 2**.

---

#### Step 2: Create the PROD Environment

1. Return to **Repository → Settings → Environments**.
2. Click **New environment**.
3. Enter `prod` as the environment name and create it.
4. Under **Deployment branches and tags**, select **Selected branches and tags**.
5. Click **Add deployment branch or tag rule**.
6. Set the reference type to **Branch** and enter `main`.
7. Save the rule.

This configuration restricts the `prod` environment to workflow deployments running from the `main` branch.

> **Important:** These rules control which branches are permitted to deploy to an environment. They do not trigger deployments by themselves. Later, we will configure our deployment workflows to reference the appropriate environment using `environment: dev` or `environment: prod`.

---

#### Step 3: Understand the Environment Configuration

We are creating and restricting the environments now, but **we will introduce their variables, secrets, AWS access, and additional protection controls as we implement those capabilities**.

- **`dev`** will hold development-specific configuration, such as environment variables and secrets. It will be used for deployments from `feature/*`, `bugfix/*`, and `hotfix/*` branches.
- **`prod`** will hold production-specific configuration and additional controls for production deployments. It will be used for deployments from `main`.

> **Production Insight:** Keeping environment-specific configuration separate helps prevent development settings from being **accidentally used in production.** Restricting deployment branches adds another layer of protection, while production approval controls and workflow checks will help ensure that only authorized, validated changes reach production.

**Note:** Follow the stages in order. We are defining the environment boundaries now, but we will configure and use these environments in our deployment workflows later.

---

## Stage 4: Run and Verify the Initial Workflow

Now that the repository has been created, the initial code has been pushed, and repository governance is configured, we can create a feature branch and verify the initial GitHub Actions workflow.

---

### Task 1: Create and Push a Feature Branch

Create a feature branch for the first CI execution:

```bash
# Create and switch to a feature branch
git checkout -b feature/initial-ci

# Push the local feature branch to GitHub and establish its upstream
git push -u origin feature/initial-ci
```

The `-u` option establishes the upstream branch so future pushes from this local branch can use `git push`.

> **Tip:** The local and remote branch names do not have to be the same. The syntax is `git push -u origin <local-branch>:<remote-branch>`. For example, `git push -u origin feature/initial-ci:feature/ci-demo` pushes the local `feature/initial-ci` branch to a remote branch named `feature/ci-demo`.

---

### Task 2: Understand Why the Push Does Not Trigger CI

Our initial push to `feature/initial-ci` did not trigger the CI workflow. Let's understand why.

Our workflow has the following branch filter:

```yaml
push:
  branches:
    - 'feature/**'
    - 'bugfix/**'
    - 'hotfix/**'
```

The branch `feature/initial-ci` matches this condition.

However, our workflow also has a **`paths` filter**:

```yaml
paths:
  - 'cwvj-3tier-mega-project/frontend/**'
  - 'cwvj-3tier-mega-project/backend/**'
  - '.github/workflows/**'
```

This filter tells GitHub to run CI only when the push includes changes to at least one of these paths.

Since `feature/initial-ci` was created from the same commit as `main`, **the push introduced no new changes matching these paths**.

Therefore:
- **Branch filter:** Passed. `feature/initial-ci` matches `feature/**`.
- **Path filter:** Not satisfied. No matching file changes were found.
- **Result:** GitHub does not start an automatic CI run.

> **What if we had not configured the `paths` filter?** The branch condition alone would have been sufficient, and the push to `feature/initial-ci` would have triggered CI.

This is exactly why we added **`workflow_dispatch`** to the workflow. It allows us to manually trigger CI from the GitHub Actions UI without making an unnecessary code change just to start a run.

The overall flow is:

```text
Push feature/initial-ci → Branch filter matches → Paths filter finds no matching changes → Automatic CI run skipped → Manually trigger via workflow_dispatch → CI workflow executes successfully
```

> **Production Insight:** Path filters help avoid unnecessary CI executions when changes do not affect the application or its workflows. At the same time, `workflow_dispatch` provides a way to run CI manually for testing, troubleshooting, or other operational needs.

---

### Task 3: Run and Verify the Workflow

#### Step 1: Open and Run the Workflow

1. Navigate to **GitHub Repository → Actions → All workflows** and select **`CWVJ CI | Build, Scan and Publish`**.

2. Click **Run workflow**. Under **Use workflow from**, select `feature/initial-ci`, then click **Run workflow** to manually start the execution.

3. Once the workflow starts, open the run and verify that all jobs complete successfully.

> **Critical Note:** The workflow file must exist on the repository's **default branch (`main`)** for `workflow_dispatch` to be available. We pushed `ci.yaml` to `main` in Stage 2, so this requirement is satisfied. Selecting `feature/initial-ci` under **Use workflow from** ensures that the workflow runs using that branch's revision.

---

#### Step 2: Inspect the Execution

Verify the following:

- **Workflow status:** Confirm that the workflow completed successfully.
- **Job:** Confirm that `Workflow Foundation` ran.
- **Runner operating system:** Verify that the job ran on the configured GitHub-hosted Ubuntu runner.
- **Checkout step:** Confirm that `Checkout source code` completed successfully.
- **Execution logs and duration:** Review the logs and overall execution duration.

The expected execution flow is:

`GitHub → Runner → Checkout → Success`

---

#### Step 3: Confirm the CI Checkpoint

A successful execution confirms that GitHub Actions can **trigger the workflow, provision a GitHub-hosted runner, and check out the repository source code**.

We can now progressively introduce the actual build and test capabilities.

> **Production Insight:** A CI workflow should be built incrementally. Establishing and verifying the workflow foundation first gives us a known-good starting point before adding compilation, testing, code quality, security scanning, containerization, and deployment.

> **Important:** We will continue to build the project **stage by stage**. The full project will eventually contain **additional workflows, infrastructure configuration, Kubernetes manifests, and GitOps configuration**, but students should add these only when instructed. Never copy the complete future project into the repository at the beginning.
>
> **GitOps will be covered in a separate video**, as a continuation of this same GitHub Actions Mega-Project. We will build upon the foundation established here rather than starting an entirely new project.

---

# **Phase 2: Continuous Integration & Artifact Publishing**

- Build and validate the backend and frontend through **automated testing, code coverage analysis, SonarQube Quality Gates, and Trivy security scanning**.
- Containerize the **validated application artifacts**, scan container images for vulnerabilities, and publish the same scanned images to **Amazon ECR** using version-based tags.

---

## Stage 5: Integrate Trivy Filesystem Security Scanning

In this stage, we extend the existing GitHub Actions workflow from Stage 3 by introducing **Trivy filesystem scanning as a dedicated job**. This separates repository-wide security scanning from application-specific build and test jobs, making the workflow easier to maintain and extend.

**Initial flow:** `Trivy Repository Scan ∥ Backend Build, Test and Quality Analysis ∥ Frontend Build`

---

### Task 1: Replace the Workflow Foundation Job with Trivy Security Scanning

In Stage 4, we introduced `workflow-foundation-job` to verify that GitHub Actions could start a runner and check out our source code. Now that we have verified the workflow foundation, we can replace this placeholder job with a **meaningful security scanning job**.

Open `.github/workflows/ci.yaml` and **remove the existing `workflow-foundation-job` entirely**. Under the `jobs:` section, add the following `trivy-scan-job` in its place.

**Reference:** [Trivy Action Documentation](https://github.com/marketplace/actions/aqua-security-trivy)

```yaml
trivy-scan-job:
  name: Repository Security Scan
  runs-on: ubuntu-26.04

  steps:
    - name: Checkout source code
      uses: actions/checkout@v7

    - name: Run Trivy repository security scan
      uses: aquasecurity/trivy-action@v0.36.0
      with:
        scan-type: repo
        scan-ref: ${{ github.workspace }}
        severity: HIGH,CRITICAL
        exit-code: '1'
```

#### Explanation

- **`trivy-scan-job`** is a dedicated job responsible for scanning the repository for security issues.
  - **Checkout source code:** We use `actions/checkout@v7` because each job runs in its own runner environment and needs to retrieve the source code independently.

- **Repository scanning:**
  - **`scan-type: repo`** tells Trivy to scan a Git repository. The Trivy Action defaults to `image` scanning, so we explicitly specify `repo` for this step.
  - **`scan-ref: ${{ github.workspace }}`** points Trivy to the root directory of our checked-out repository.
  - Trivy examines supported dependency files and lockfiles to identify known vulnerabilities. It also scans repository files for exposed secrets.
  - **Important:** Repository scanning does not inspect compiled artifacts such as JAR files or operating-system packages inside container images. We handle container image scanning separately.

- **Understanding the scanners:** Trivy supports four scanner types. In repository mode, **vulnerability and secret scanning are enabled by default**, while misconfiguration and license scanning are disabled. Since we have not specified the `scanners` input, Trivy uses these defaults.

  | Scanner | Default | Purpose |
  |---|---|---|
  | `vuln` | Enabled | Detects known vulnerabilities in supported application dependencies. |
  | `secret` | Enabled | Detects exposed credentials, API keys, tokens, and other sensitive information. |
  | `misconfig` | Disabled | Detects security misconfigurations in supported files, such as Kubernetes manifests and Terraform configurations. |
  | `license` | Disabled | Identifies licenses associated with application dependencies. |

  > **Important:** Our current scan does not check Kubernetes manifests for security misconfigurations because `misconfig` is not enabled. Users can explore this scanner as an enhancement by explicitly configuring `scanners: vuln,misconfig,secret`.

- **Severity filtering:** `severity: HIGH,CRITICAL` limits the scan results to findings classified as **High or Critical**. This helps us focus on more serious security issues.

- **Failure behavior:** `exit-code: '1'` instructs Trivy to return a non-zero exit code when matching findings are detected. GitHub Actions then marks the step and job as **failed**.

- **Job dependencies:** Jobs that declare `needs: trivy-scan-job` must wait for the security scan to succeed before starting. If this job fails, its dependent jobs are **skipped by default**. Independent jobs can still run.

> **Handling Accepted Security Findings:** Trivy allows us to exclude specific findings from scan results using an ignore file named **`.trivyignore`**, maintained in the repository.
>
> - Add the relevant finding IDs (such as CVE IDs, misconfiguration IDs, or secret rule IDs) to this file.
> - Reference the ignore file in the Trivy Action using `trivyignores: .trivyignore`.
> - Trivy skips the listed findings when evaluating scan results. Other findings are still reported and can cause the job to fail based on our configured severity and exit-code settings.
>
> **Example:**
>
> ```yaml
> - name: Run Trivy repository security scan
>   uses: aquasecurity/trivy-action@v0.36.0
>   with:
>     scan-type: repo
>     scan-ref: ${{ github.workspace }}
>     severity: HIGH,CRITICAL
>     exit-code: '1'
>     trivyignores: .trivyignore
> ```
>
> **Important:** Ignoring a finding does not fix the underlying issue. Use exceptions only for **reviewed false positives or formally accepted risks**. Never suppress an actual exposed credential; remove and rotate it instead.


---

### Task 2: Push the Changes and Verify the Scan

Commit and push the updated workflow to your existing feature branch:

```bash
# Stage the updated workflow
git add .

# Commit the Trivy integration
git commit -m "ci: add Trivy filesystem security scan"

# Push the changes and trigger the workflow
git push
```

Navigate to **GitHub → Repository → Actions → CWVJ CI | Build, Scan and Publish**. Verify that the **Repository Filesystem Security Scan** job runs and review the Trivy logs for the scan summary and findings.

**Expected execution:** `Push → (Trivy Repository Scan ∥ Backend Build and Test ∥ Frontend Build)`

The security scan should pass with the current repository contents, allowing the workflow to complete successfully. In the next task, we will **deliberately introduce vulnerable dependencies to simulate a security scan failure** and verify how Trivy handles it.

> **Important:** If Trivy detects **HIGH or CRITICAL findings**, the job should fail. The other jobs may still complete because they run independently.

---

### Task 3: Simulate Security Findings

Since the repository currently passes the scan, let's **deliberately introduce test findings** to demonstrate Trivy's detection capabilities.

**A. Add a vulnerable dependency**

Add the following dependency to the existing `<dependencies>` section in `cwvj-3tier-mega-project/backend/pom.xml`:

```xml
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.14.0</version>
</dependency>
```

**Log4j 2.14.0** has known vulnerabilities, including CVE-2021-44228 (Log4Shell), providing a test case for Trivy's dependency vulnerability scanning.

**B. Add a synthetic credential pattern**

Create `secrets.txt` in the repository root, alongside the root `README.md`, with the following content:

```text
AWS_ACCESS_KEY_ID=AKIAAAAAAAAAAAAAAAAA
```

> **Important:** This is a **synthetic test value, not a real AWS credential**.

**C. Commit and push the test changes**

We are working on the **`feature/initial-ci`** branch. Verify your current branch, then commit and push the test changes:

```bash
# Confirm the current branch
git branch --show-current

# Stage the test changes
git add .

# Commit the test changes
git commit -m "test: simulate Trivy security findings"

# Push to the feature branch
git push origin feature/initial-ci
```

**D. Verify the scan results**

Navigate to **GitHub → Repository → Actions → CWVJ CI | Build, Scan and Publish** and inspect the **Repository Filesystem Security Scan** job.

In our test, Trivy detected **3 dependency vulnerabilities** in `backend/pom.xml` and **1 secret** in `secrets.txt`. The frontend dependency lockfile had no vulnerabilities.

> **Important:** Trivy filesystem scanning is not limited to dependency vulnerabilities. Depending on the enabled scanners and repository contents, it can also detect **exposed secrets and security misconfigurations** in supported files, including infrastructure-as-code configurations such as Terraform and Kubernetes manifests.

Because the detected findings meet our configured **HIGH or CRITICAL severity threshold**, the Trivy job fails. The other jobs may still complete because they run independently.

---

### Task 4: Remove the Test Findings & Push Again

After verifying Trivy's detection capabilities, **remove the Log4j dependency** from `cwvj-3tier-mega-project/backend/pom.xml` and delete `secrets.txt`. Continue working on **`feature/initial-ci`** so the cleanup triggers another workflow run.

```bash
# Confirm the current branch
git branch --show-current

# Remove secrets.txt from the local filesystem and stage its deletion in Git
git rm secrets.txt

# Stage all remaining changes, including the removal of the Log4j dependency from pom.xml
git add .

# Commit the cleanup
git commit -m "chore: remove intentional Trivy test findings"

# Push the cleanup to the feature branch
git push origin feature/initial-ci
```

Navigate to **GitHub → Repository → Actions → CWVJ CI | Build, Scan and Publish** and verify that the next workflow run passes the Trivy scan.

---

## Stage 6: Build and Validate the Application

In this stage, we extend the GitHub Actions workflow from the previous stage by establishing CI for both application components. Our application contains a **React frontend** and a **Spring Boot backend**, so each component will have its own dedicated job with the appropriate build environment and tooling.

We will configure the backend with **Java 21 and Maven** to compile the application and run unit tests, while the frontend will use **Node.js 22 and npm** to install dependencies and build the React application. The **Trivy repository filesystem security scan** remains a separate job and acts as a **gate**, ensuring that application jobs run only after the security scan succeeds.

**CI flow:**

```text
GitHub Event → Trivy Repository Scan → (Backend Build & Test ∥ Frontend Build) → CI Result
```

**Expected outcome:** The workflow first validates repository security, then runs backend compilation and unit tests alongside the frontend build. The backend and frontend jobs can run in parallel **after Trivy succeeds**. If the Trivy scan fails, both application jobs are skipped; if either application job fails, the other is not automatically cancelled.


---

### Task 1: Configure the Backend CI Job

The first step is to extend our checkout-only workflow with a dedicated **backend CI job**. This job prepares the runner with the Java and Maven environment required by our Spring Boot application.

The **`backend-job`** must be added immediately after the existing **`trivy-scan-job`** definition under **`jobs`**. It will be the second job in our workflow.

#### Backend Job

```yaml
jobs:
  backend-job:
    name: Backend Build and Test
    runs-on: ubuntu-26.04
    needs: trivy-scan-job

    defaults:
      run:
        working-directory: cwvj-3tier-mega-project/backend

    steps:
      - name: Checkout source code
        uses: actions/checkout@v7

      - name: Set up Java
        uses: actions/setup-java@v6
        with:
          distribution: temurin
          java-version: '21'
          cache: maven
          cache-dependency-path: cwvj-3tier-mega-project/backend/pom.xml

      - name: Verify Java version
        run: java --version

      - name: Build, test, and package backend
        run: mvn --batch-mode clean verify

      - name: Inspect backend build outputs
        run: |
          echo "=== Maven Build Outputs ==="
          ls -lah target/

          echo "=== Unit Test Reports ==="
          ls -lah target/surefire-reports/

          echo "=== JaCoCo Coverage Reports ==="
          ls -lah target/site/jacoco/
```

#### Explanation

**Reference:** [Setup-Java Action Documentation](https://github.com/marketplace/actions/setup-java-jdk)

```yaml
jobs:
  backend-job:
    name: Backend Build and Test
    runs-on: ubuntu-26.04
    needs: trivy-scan-job
```

* The **`jobs`** block defines the individual jobs that make up a GitHub Actions workflow.
* **`backend-job`** is the unique identifier for this job, which can be referenced later when defining dependencies between jobs.
* **`name`** provides the human-readable name displayed for the job in the GitHub Actions UI.
* **`runs-on: ubuntu-26.04`** specifies the **GitHub-hosted runner environment** on which GitHub Actions provisions and executes the job. In this case, the job runs on a virtual machine with **Ubuntu 26.04**.
  > **Production Insight:** Pinning a specific runner OS version, such as `ubuntu-26.04`, helps provide a **more predictable and consistent build environment**. In production implementations, avoid using `ubuntu-latest` without careful consideration. Newer runner images may introduce changes to preinstalled tools, dependencies, or system libraries, potentially affecting compatibility with your application or build process. **Use the `-latest` tag with caution** when predictable and reproducible workflow execution is important.
- **`needs: trivy-scan-job`** establishes a dependency on the Trivy repository filesystem scan. GitHub Actions jobs **run in parallel by default** unless dependencies are defined. Here, the backend job waits for the Trivy job to **complete**, but runs only if the scan **succeeds**. If the Trivy job fails, the backend job is **skipped by default**, preventing unnecessary runner resource consumption on a repository that has already failed its security scan. *(We will introduce the frontend job shortly, with the same dependency on Trivy.)*

> **Production Insight:** GitHub-hosted runner labels such as `ubuntu-latest` are managed by GitHub and can move to newer OS versions over time. This provides access to supported runner environments, but production workflows with strict OS compatibility requirements may benefit from a **specific runner image** or a controlled, versioned self-hosted runner environment.

> **Note: Default Failure Behavior in GitHub Actions**
>
> By default, GitHub Actions follows this behavior:
>
> - **Step failure:** If a step fails, the **job is marked as failed**, and subsequent steps are **skipped by default**.
> - **Job failure:** Jobs that depend on the failed job through `needs` are **skipped by default**. However, **independent jobs continue executing**.
> - **Workflow status:** If a job fails, the overall **workflow run is marked as failed**, unless the failure is explicitly tolerated using configurations such as `continue-on-error: true`.
>
> This default behavior can be modified using **status check functions** in `if` conditions, such as `success()`, `failure()`, `always()`, and `cancelled()`. We covered these functions in **Lecture 05**.
>
> **Note:** `continue-on-error` is a separate configuration that can also change how step and job failures affect workflow execution.

---

```yaml
defaults:
  run:
    working-directory: cwvj-3tier-mega-project/backend
```

- **`defaults.run`** defines default settings, such as **`shell`** and **`working-directory`**, for commands and scripts executed through the `run` keyword within the job.
  >**Important:** These defaults apply only to **`run` steps**, not to steps that execute actions using the **`uses`** keyword, such as `actions/checkout@v7` or `actions/setup-java@v6`.
- **`working-directory`** sets the default directory from which these commands execute. **Without** this setting: Commands run from the **default working directory,** normally the repository root, unless overridden at the step level.

  > **Note:** This is similar to the `WORKDIR` instruction in a Dockerfile, which sets the working directory for subsequent instructions.

- As a result, commands such as `mvn clean verify` can be executed directly without repeatedly specifying the backend's complete path.
- This is necessary because our backend resides inside **`cwvj-3tier-mega-project/backend`**, rather than at the repository root.

  > **Production Insight:** Job-level working directories are particularly useful in **monorepos**, where multiple applications share a **single repository** but have different directory structures and build tools. For example, the **backend job** can execute Maven commands from the backend directory, while the **frontend job** executes npm commands from the frontend directory. This keeps each job's commands organized and avoids repeatedly specifying directory paths.

**Monorepo vs. multi-repository architecture:**

```text
Monorepo
One Repository
├── Frontend → Frontend working directory
├── Backend  → Backend working directory
└── Service A → Service A working directory

Multi-repository
Frontend Repository → Frontend Workflow
Backend Repository  → Backend Workflow
Service A Repository → Service A Workflow
```

> **Production Insight:** A multi-repository architecture allows teams to build, test, release, and deploy their applications independently. However, CI/CD logic does not need to be duplicated across repositories. **Reusable Workflows** can centralize common automation while allowing each repository to supply its own inputs and configuration.

> **Important:** A single workflow can also coordinate work across multiple repositories, but this requires additional consideration of **repository permissions, authentication, triggers, artifacts, and cross-repository dependencies**. For independently managed services, separate repository workflows combined with reusable workflows often provide a cleaner balance between **team autonomy and standardized CI/CD practices**.

---

```yaml
- name: Set up Java
  uses: actions/setup-java@v6
  with:
    distribution: temurin
    java-version: '21'
    cache: maven
    cache-dependency-path: cwvj-3tier-mega-project/backend/pom.xml
```

- This step configures the **Java environment** required by our Spring Boot backend.
- **`actions/setup-java@v6`** is GitHub's official action for configuring Java on the runner.
- **`distribution: temurin`** selects the Eclipse Temurin Java distribution.

  > **Why Temurin?** It provides a widely used OpenJDK distribution, giving us a **consistent Java runtime** for our CI environment.
  > **Note: Understanding Java Distributions**

  > Java is available through multiple **JDK distributions**, maintained by different vendors. **Eclipse Temurin** is one such distribution. Other examples include **Amazon Corretto, Azul Zulu, Microsoft Build of OpenJDK, Oracle JDK, and BellSoft Liberica**.
  >
  > In `actions/setup-java`, the **`distribution`** parameter selects the JDK vendor distribution, while **`java-version`** specifies the Java version. We use **Eclipse Temurin with Java 21** in this project.

- **`java-version: '21'`** ensures that CI uses Java 21, matching the version configured for our application.

  > **Production Insight:** Our GitHub-hosted Ubuntu 26.04 runner already has **Java 21 pre-installed**, but **Java 25 is configured as the default**. The `actions/setup-java` action checks whether the requested Java version is already available in the runner's tool cache. If a matching installation exists, it **reuses it without downloading Java again**. If the requested version is not available, the action **downloads and installs it**. It then configures **`JAVA_HOME` and `PATH`** to ensure subsequent commands use the requested Java version. This ensures that our CI workflow uses the **Java version required by the application**, rather than relying on the runner's default.

- **`cache: maven`** enables **Maven dependency caching** through `setup-java`. It caches Maven's local repository, normally located at `~/.m2/repository`, which stores **downloaded project dependencies and build-plugin artifacts** that can be reused across workflow runs.

- **`cache-dependency-path: cwvj-3tier-mega-project/backend/pom.xml`** explicitly specifies the **dependency file used to calculate the Maven cache key**. By default, `setup-java` automatically discovers Maven dependency files across the repository, including matching `pom.xml` files. Specifying this path makes the cache key reflect **our backend's Maven project configuration**, rather than automatically including dependency files from other Maven projects.
  - **Why is this useful?** This is particularly useful in **monorepos containing multiple Maven projects**, where each project can have its own dependency file and corresponding cache key.

  > **How caching works:** `setup-java` generates the **primary dependency cache key** using the **runner OS, Node.js process architecture, package manager, and a hash of the dependency files**. In our configuration, `cache-dependency-path` specifies the backend's `pom.xml` for calculating the file hash. On subsequent runs, GitHub Actions looks for a matching cache and restores it if available. Maven can then **reuse the restored dependencies** and download any missing artifacts. The cache is saved after the job so that subsequent workflow runs can reuse it.

  > **Production Insight:** Explicitly specifying the dependency file is particularly useful in **monorepos** containing multiple Maven projects because it allows each project's **dependency configuration to determine its cache key**, instead of relying on automatic discovery across the repository.

**Note:** `defaults.run.working-directory` sets the default directory for shell commands executed by `run` steps. It is similar to Docker's `WORKDIR` instruction, but it does **not** control how `setup-java` locates the `pom.xml` or where Maven stores its dependencies.

> **How Maven dependency caching works:**
>
> 1. **`cache: maven`** enables caching of Maven's local repository (`~/.m2/repository`).
> 2. **`cache-dependency-path`** identifies the `pom.xml` file used to calculate the dependency cache key.
> 3. **`setup-java`** checks for a matching cache and restores it if available.
> 4. Maven reuses the **restored dependencies** and downloads any required artifacts that are missing from the local repository.
> 5. **At the end of the job**, `setup-java` saves the local repository to the cache if a matching cache was not found. **An existing cache is not updated or saved again when there is a cache hit.**

---

```yaml
- name: Verify Java version
  run: java --version
```

- Displays the Java version configured on the runner, verifying that CI uses the expected **Java 21** runtime.

> **Operational Tip:** This simple check makes the runtime version visible in workflow logs, helping troubleshoot environment-related issues.

---


```yaml
- name: Build, test, and package backend
  run: mvn --batch-mode clean verify
```

- This step uses **Maven** to execute the `verify` phase of Maven's **default lifecycle**, running the preceding phases in sequence.
- A **lifecycle** defines a logical sequence of **phases**, such as `validate`, `compile`, `test`, `package`, and `verify`. Each phase invokes the appropriate **plugin goals** bound to it. The lifecycle defines the sequence, while plugins perform the actual work.



> **Important:** Running `mvn --batch-mode clean verify` executes the Maven lifecycle phases sequentially, including the **`test` phase**. Our unit tests are defined using **JUnit 5 and Mockito** in `project-files/cwvj-3tier-mega-project/backend/src/test/java/com/cloudwithvarjosh/usermanagement/user/UserServiceTest.java`. Without these test cases, Maven would still execute the `verify` phase, but no project unit tests would run.


**Conceptual flow:**

```text
mvn --batch-mode clean verify
        → Remove previous build outputs
        → Compile application and test source code
        → Execute unit tests
        → Package the application JAR
        → Generate the JaCoCo code coverage report
        → Complete the verify phase successfully
```

- **Maven lifecycle and plugins:** Maven executes the configured lifecycle phases in sequence. Plugins execute specific goals bound to those phases. For our project:
  - **Maven Compiler Plugin:** Compiles the application and test source code.
  - **Maven Surefire Plugin:** Executes unit tests during the `test` phase.
  - **Spring Boot Maven Plugin:** Repackages the application JAR as an executable Spring Boot JAR.
  - **JaCoCo Maven Plugin:** Collects code execution data during testing and generates the coverage report during the `verify` phase, according to our configuration.

- **Code Coverage:** Measures how much of the application's code is **executed by automated tests**. JaCoCo collects this information during test execution and generates reports showing **covered and uncovered code**. Coverage can include both **unit and integration tests**, provided JaCoCo is configured to collect execution data from both.

- **Testing:** The **Maven Surefire Plugin** executes our unit tests during the `test` phase. Although Maven can also execute integration tests through the **Maven Failsafe Plugin**, **we have not configured integration tests in this project**. Our current tests use **JUnit 5 and Mockito** to test `UserService` in isolation, with `UserRepository` mocked.

- **Code coverage report:** JaCoCo generates the coverage report during the `verify` phase. In our current configuration, the report reflects the code exercised by our unit tests. The generated XML report can subsequently be imported by **SonarQube** for code coverage analysis.
  > **Important:** JaCoCo generates the code coverage report because we have explicitly configured the **JaCoCo Maven Plugin and its lifecycle executions in `pom.xml`**. Maven's `verify` phase does not generate coverage reports by itself. The configured JaCoCo plugin goals are responsible for collecting execution data and generating the reports.

- **Packaging:** The Spring Boot Maven Plugin produces the executable application JAR. This JAR will be used later to build the backend's **Docker image**. The exact JAR filename depends on the Maven project configuration.

**Backend build outputs:**

```text
Unit Test Results → target/surefire-reports/
Code Coverage    → target/site/jacoco/jacoco.xml
Packaged JAR     → target/*.jar
```

- **`clean`** removes output from previous builds, helping ensure the build starts with fresh artifacts.
- **`--batch-mode`** runs Maven in non-interactive mode, making it suitable for automated CI environments.
- **Failure behavior:** If compilation or a unit test fails, Maven returns a **non-zero exit code**, causing the **step and job to fail**. Subsequent steps in that job are skipped by default unless configured otherwise.

> **Production Insight:** A Maven lifecycle defines the **build sequence**, while **plugins execute the work through their goals**. Choosing the appropriate lifecycle phase allows us to compile, test, package, and verify the application through a **single command** rather than maintaining separate commands for each activity.


---

```yaml
- name: Inspect backend build outputs
  run: |
    echo "=== Maven Build Outputs ==="
    ls -lah target/

    echo "=== Unit Test Reports ==="
    ls -lah target/surefire-reports/

    echo "=== JaCoCo Coverage Reports ==="
    ls -lah target/site/jacoco/
```

- This step inspects the **build artifacts and reports** generated by the preceding Maven build, making the results visible in the GitHub Actions logs.

- **`echo`** prints section headings to make the output easier to read, while **`ls -lah`** lists directory contents, including file sizes and hidden entries.

- **`target/`** contains the generated build outputs, including compiled classes, test classes, Maven metadata, and the packaged application JAR.

- **`target/surefire-reports/`** contains the unit test reports generated by the **Maven Surefire Plugin**. The `.txt` and `.xml` files provide test results that can be inspected or consumed by other tools.

- **`target/site/jacoco/`** contains the **JaCoCo code coverage report**, including `index.html` for human-readable results, `jacoco.xml` for tools such as SonarQube, and `jacoco.csv` for tabular analysis.

> **Learning Insight:** Maven generates more than a packaged JAR. It also produces **compiled artifacts, test results, and code coverage reports**, which can be consumed by subsequent CI stages for quality analysis and containerization.

---

### Task 2: Configure the Frontend CI Job

The frontend uses a different technology stack from the backend. Instead of Java and Maven, the React application requires **Node.js and npm**.

We will therefore create a separate job with its own runtime and dependency cache.

#### Frontend Job

```yaml
frontend-job:
  name: Frontend Build and Test
  runs-on: ubuntu-26.04
  needs: trivy-scan-job

  defaults:
    run:
      working-directory: cwvj-3tier-mega-project/frontend

  steps:
    - name: Checkout source code
      uses: actions/checkout@v7

    - name: Set up Node.js
      uses: actions/setup-node@v6
      with:
        node-version: '22'
        cache: npm
        cache-dependency-path: cwvj-3tier-mega-project/frontend/package-lock.json

    - name: Verify Node.js and npm versions
      run: |
        node --version
        npm --version

    - name: Install frontend dependencies
      run: npm ci

    - name: Build frontend application
      run: npm run build

    - name: Run frontend tests and generate coverage
      run: npm run test:coverage

    - name: Inspect frontend build and test outputs
      run: |
        echo "=== Frontend Build Outputs ==="
        ls -lah dist/

        echo "=== Frontend Coverage Reports ==="
        ls -lah coverage/
        ls -lah coverage/lcov.info
```
---

#### Explanation

```yaml
frontend-job:
  name: Frontend Build and Test
  runs-on: ubuntu-26.04
  needs: trivy-scan-job
```

- **`frontend-job`** is the unique job ID for the React frontend.
- **`needs: trivy-scan-job`** ensures the frontend job runs only after the Trivy scan succeeds. If the scan fails, the job is skipped by default.
- **`name`** defines the display name shown in the GitHub Actions UI.
- **`runs-on`** provisions a fresh Ubuntu runner. Each job runs independently, with its own environment, separate from the backend job's Java environment.

---

```yaml
defaults:
  run:
    working-directory: cwvj-3tier-mega-project/frontend
```

- Sets the default working directory for **`run` steps**, so commands such as **`npm ci`** and **`npm run build`** execute from the frontend directory.
- The backend and frontend use different working directories because they are **separate application components**.

---

```yaml
- name: Checkout source code
  uses: actions/checkout@v7
```

- Checks out the repository onto the frontend job's runner.
- Each job needs its own checkout because **runners and their local files are not shared between jobs**.

> **Production Insight:** Jobs run in **independent environments** unless data is explicitly shared through **artifacts, caches, outputs, or external storage**.

---

```yaml
- name: Set up Node.js
  uses: actions/setup-node@v6
  with:
    node-version: '22'
    cache: npm
    cache-dependency-path: cwvj-3tier-mega-project/frontend/package-lock.json
```

- This step configures **Node.js** for the React frontend using GitHub's official **`actions/setup-node@v6`** action.
  > **Why do we need Node.js for a React + Vite + NGINX frontend?** React and Vite use the Node.js ecosystem during development and the build process. In our CI workflow, Node.js provides the runtime required to install frontend dependencies using `npm` and execute the Vite build command, which compiles the React application into static HTML, CSS, and JavaScript files. These generated files are then packaged into our NGINX container image. **Node.js is required during the build process; we do not need Node.js to serve the application in production because NGINX serves the generated static files.**

- **`node-version: '22'`** selects **Node.js 22** for the CI environment.
  > **Note:** The Ubuntu 26.04 runner image release referenced in our setup already includes **Node.js 22.23.4 in its tool cache**. Since we specify `node-version: '22'`, `actions/setup-node@v6` finds and **reuses the existing installation** rather than downloading Node.js again. It selects the cached version and adds it to `PATH` for subsequent workflow steps. If a matching version is not available in the runner's tool cache, the action **downloads the requested version**.

- **`cache: npm`** enables caching of **npm's global package cache**, which stores downloaded package data. On GitHub-hosted Ubuntu runners, npm's cache is normally located at **`~/.npm`**.

- **`cache-dependency-path`** identifies the **dependency lockfile** whose contents are hashed and used as part of the dependency cache key.

**What is `package-lock.json`?**

It records the **exact dependency tree**, including the resolved package versions and their relationships. This helps ensure that developers' machines and CI environments can install a **consistent set of dependencies**.

**What exactly gets cached?**

- GitHub Actions caches the contents of **npm's package cache (normally `~/.npm` on Ubuntu)**, not the project's `node_modules` directory.
- The **`package-lock.json` file itself is not cached**. Its contents are hashed and used as part of the cache key.
- When the lockfile remains unchanged, GitHub Actions can restore a **matching cache**, allowing npm to reuse previously downloaded package data and reduce repeated downloads.
- When the lockfile changes, its hash changes, resulting in a **different cache key**. A new cache can then be saved for subsequent workflow runs, provided the job completes successfully.

**Why specify `cache-dependency-path`?**

Our `package-lock.json` is located inside `cwvj-3tier-mega-project/frontend`, not at the repository root. By default, `setup-node` searches for supported dependency files in the **repository root**. It does not automatically search arbitrary subdirectories.

Specifying the path explicitly ensures that the cache key is calculated using the **frontend's dependency lockfile**.

- **Why is this useful?** This is particularly useful in **monorepos containing multiple applications**, where each application may have its own dependency lockfile and should have its own dependency cache.

- The frontend uses **npm caching with `package-lock.json`**, while the backend uses **Maven caching with `pom.xml`**. Both use their respective dependency files to generate cache keys and accelerate subsequent dependency installations.

> **Production Insight:** Configure dependency caching using each application's **native package manager and dependency lock or configuration files**. Explicitly specifying dependency-file paths in monorepos helps ensure that cache keys reflect the dependencies of the intended application, making cache management more predictable and reducing unnecessary downloads.

---

```yaml
- name: Verify Node.js and npm versions
  run: |
    node --version
    npm --version
```

- This step displays the **Node.js and npm versions** available on the runner.
- Both commands are grouped into a single `run` block because they validate the same **frontend build environment**.
- The versions appear in the **workflow logs**, making runtime troubleshooting easier.


---

```yaml
- name: Install frontend dependencies
  run: npm ci
```

- **`package.json`** declares the application's **direct dependencies** and their acceptable version ranges. Developers update this file when adding, removing, or changing dependencies.

- **`package-lock.json`** is automatically generated and updated by npm when dependencies are installed or modified. It records the **exact resolved versions and dependency relationships** of both direct and transitive dependencies.

  > **Important:** The `package-lock.json` file must already exist in the repository before our CI workflow runs. Developers should run **`npm install` locally** to generate or update the lockfile whenever dependencies are initially installed or modified. Both **`package.json` and `package-lock.json` must be committed to Git**. Our GitHub Actions workflow uses the committed lockfile to calculate the **dependency cache key** and subsequently runs `npm ci` to install the dependencies.

- **`npm ci`** installs the dependency tree using the **exact versions recorded in `package-lock.json`**, rather than resolving dependency versions again using the version ranges in `package.json`.
  > `npm ci`**&#x20;(Continuous Integration):** Installs dependencies strictly from `package-lock.json` without modifying it. It also removes the existing `node_modules` directory before installation, ensuring **consistent and reproducible dependency versions** in CI builds.

- **`npm ci`** is designed for **clean, automated environments**, such as CI runners. It requires an existing lockfile that is consistent with `package.json` and **fails if the two files are out of sync**. It does not modify either file.

- Before installing dependencies, **`npm ci` removes the existing `node_modules` directory**, ensuring a **clean dependency installation** based on the committed lockfile.

> **Production Insight:** Always commit both **`package.json` and `package-lock.json`** to Git. Using **`npm ci`** in CI ensures that repeated executions install the **same resolved dependency versions**, reducing unexpected dependency differences between builds and improving **build consistency and reproducibility**.

---

```yaml
- name: Build frontend application
  run: npm run build
```

- **`npm run build`** executes the `build` script defined in the frontend's `package.json`.
- The script invokes **Vite**, which compiles and bundles the React application into production-ready static assets in the `dist/` directory.
- The build output is generated on the **GitHub Actions runner** and is not yet packaged into a Docker image.
- This step validates that the frontend can be successfully built for production. **Docker image creation and publishing** will be introduced in subsequent stages.

> **Production Insight:** CI should verify that an application can successfully produce its **production build output** before proceeding to subsequent stages such as code quality analysis, security scanning, containerization, and image publishing.

---

```yaml
- name: Run frontend tests and generate coverage
  run: npm run test:coverage
```

- **`npm run test:coverage`** executes the `test:coverage` script defined in the frontend's `package.json`.
- The script invokes **Vitest with coverage enabled**, executing the frontend test suite and collecting code coverage data.
- Vitest generates the **LCOV coverage report** at `coverage/lcov.info`.
- **SonarQube** will consume this report during code analysis to incorporate frontend test coverage into its analysis.

> **Production Insight:** SonarQube does not execute frontend tests or generate their coverage. **Vitest executes the tests and generates the coverage report, while SonarQube imports and analyzes that report.**

---

```yaml
- name: Inspect frontend build and test outputs
  run: |
    echo "=== Frontend Build Outputs ==="
    ls -lah dist/

    echo "=== Frontend Coverage Reports ==="
    ls -lah coverage/
    ls -lah coverage/lcov.info
```

- Lists the contents of the **`dist/` directory** generated by Vite during the build.
- Lists the **`coverage/` directory** and verifies that the `lcov.info` coverage report exists.
- **`ls -lah`** displays file sizes, permissions, and other details in a human-readable format.
- The output appears in the **GitHub Actions logs**, allowing us to verify that the expected build artifacts and coverage report were generated.
- The static assets in `dist/` will later be copied into the frontend's **Docker image** for deployment.
- The `coverage/lcov.info` report will be consumed by **SonarQube in Stage 7** for code coverage analysis.

> **Production Insight:** Inspecting build outputs and coverage reports helps verify that the expected **build artifacts and test reports** exist before proceeding to Docker packaging and SonarQube analysis.

---

### Task 3: Push the Changes and Verify the CI Workflow

Commit and push the updated workflow to your existing feature branch:

```bash
# Stage the updated workflow
git add .

# Commit the backend and frontend CI jobs
git commit -m "ci: add backend and frontend build jobs"

# Push the changes and trigger the workflow
git push
```

Navigate to **GitHub → Repository → Actions → CWVJ CI | Build, Scan and Publish**. Open the latest run and verify that the **Repository Filesystem Security Scan**, **Backend Build and Test**, and **Frontend Build and Test** jobs execute successfully.

- In the first run, the `Set up Java` and `Set up Node.js` logs will likely show **`maven cache is not found`** and **`npm cache is not found`**, respectively. This is expected because matching dependency caches may not exist yet.
- Maven downloads the required dependencies during the backend build, while `npm ci` installs the frontend dependencies. The setup actions save their respective caches when appropriate.
- Verify that the backend build, unit tests, and JaCoCo report generation complete successfully. For the frontend, confirm that the Vite build succeeds and generates the `dist/` directory.

**Expected execution:** `Push → Trivy Repository Scan → (Backend Build and Test ∥ Frontend Build and Test)`

The backend and frontend jobs run **in parallel after the Trivy scan succeeds**, because both declare `needs: trivy-scan-job`.

---

### Task 4: Verify Dependency Caching

Make a small, harmless change to `.github/workflows/ci.yaml`, such as adding a comment, and push it to the same feature branch:

```bash
# Stage the workflow change
git add .

# Commit the change
git commit -m "chore: update CI workflow comments"

# Push the change and trigger another run
git push
```

Navigate back to **GitHub → Repository → Actions** and inspect the latest workflow run.

- In the `Set up Java` logs, look for **`Cache hit for: setup-java-...-maven-...`** followed by **`Cache restored successfully`**.
- In the `Set up Node.js` logs, look for **`Cache hit for: node-cache-...-npm-...`** followed by **`Cache restored successfully`**.
- These messages confirm that GitHub Actions has restored the **Maven and npm dependency caches**, reducing the need to download previously cached package data.
- The cache keys are based on the dependency files, so a comment-only workflow change should not change those keys.

> **Important:** A cache hit does not skip the build or tests. Maven still executes `mvn --batch-mode clean verify`, and npm still executes `npm ci` and `npm run build`. Caching helps speed up dependency retrieval.

---

## Labs: Create AWS Infrastructure for Our Application

In this section, we will create the **AWS infrastructure** required to run our application and support its **DevSecOps pipeline**. We will provision an **Amazon EKS cluster** to run our containerized application, **Amazon RDS** to host the database, and a **SonarQube instance** to perform code quality and security analysis.

We will create the required **networking and security groups** before provisioning the database and SonarQube instance. This approach helps us understand how these AWS resources fit together and how to configure secure communication between them.

By the end of these labs, we will have the foundational infrastructure required to integrate our application with **Amazon EKS, Amazon RDS, and SonarQube**.

We will do the labs in the below sequence:

- **Lab 1:** Create an Amazon EKS Cluster
- **Lab 2:** Create Networking for SonarQube and Amazon RDS
- **Lab 3:** Create Security Groups for SonarQube and Amazon RDS
- **Lab 4:** Create an Amazon RDS Instance
- **Lab 5:** Create a SonarQube Instance

---

### Lab 1: Create an Amazon EKS Cluster

We will use **`eksctl`** to create our Amazon EKS cluster. `eksctl` is a command-line tool that simplifies EKS cluster creation and management. Instead of creating each AWS resource manually, we will define our cluster configuration in a YAML file and use it to provision the infrastructure.

Create a file named `eks-config.yaml` with the following configuration:

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: cwvj-mega-demo-eks
  region: ap-south-1
  version: "1.36"
  tags:
    owner: cloudwithvarjosh
    project: cwvj-mega-demo
    purpose: github-actions-mega-project
    managed-by: eksctl

availabilityZones:
  - ap-south-1a
  - ap-south-1b

iam:
  withOIDC: true

managedNodeGroups:
  - name: cwvj-mega-demo-ng
    instanceType: c7i-flex.large
    minSize: 2
    maxSize: 2
    desiredCapacity: 2

    volumeSize: 20
    volumeType: gp3
    volumeEncrypted: true

    # Workers use public subnets created by eksctl.
    privateNetworking: false

    # SSH intentionally disabled.
    # Add only workload-specific IAM permissions when required.

    labels:
      project: cwvj-mega-demo
      workload: general

    tags:
      owner: cloudwithvarjosh
      project: cwvj-mega-demo
      purpose: github-actions-mega-project
      managed-by: eksctl
      node-type: public-worker
```

**Reference:** https://schema.eksctl.io/

Let's understand some of the important configuration options:

- **`metadata`** defines the cluster name, AWS Region, Kubernetes version, and tags associated with the cluster. We are deploying the cluster in `ap-south-1` (Mumbai).
- **`availabilityZones`** specifies two Availability Zones for the cluster's networking infrastructure, helping distribute resources across separate zones.
- **`iam.withOIDC: true`** tells `eksctl` to register the EKS cluster's **OIDC issuer URL with AWS IAM**. AWS represents this registration as an **IAM OIDC identity provider**. This does not mean IAM issues the tokens. **The EKS OIDC issuer is the actual token issuer**; IAM maintains the trusted issuer configuration, allowing Amazon STS to validate tokens issued for Kubernetes Service Accounts.

  This is a prerequisite for configuring **IAM Roles for Service Accounts (IRSA)**. We can then create IAM roles whose trust policies allow specific Kubernetes Service Accounts to assume those roles using `sts:AssumeRoleWithWebIdentity` and receive **temporary AWS credentials**.

  > **Note:** Registering the EKS OIDC issuer with IAM alone does not grant AWS permissions to our Pods. We also need an IAM role with an appropriate trust policy and a Kubernetes Service Account associated with that role.

  > Our application workloads do not need AWS API access in this demo. However, we keep this setting enabled so that, later in the course, we can **contrast the EKS workload OIDC integration (IRSA)** with the separate **GitHub Actions OIDC integration**, which allows GitHub Actions workflows to authenticate with AWS.
- **`managedNodeGroups`** defines the worker nodes that will run our application workloads. We are creating two nodes using the `c7i-flex.large` instance type, with the desired, minimum, and maximum capacity all set to two.
- **`volumeSize`, `volumeType`, and `volumeEncrypted`** configure the worker nodes' root EBS volumes, using 20 GiB `gp3` volumes with encryption enabled.
- **`privateNetworking: false`** means the worker nodes will use public subnets created by `eksctl`. This simplifies our lab setup, but production environments commonly place worker nodes in private subnets and control access through appropriate networking and security controls.
  > **Note:** We have set **`privateNetworking: false`** because, for this lab, we will access our application using **Kubernetes NodePort**. This places the worker nodes in **public subnets**, simplifying application access for our demonstration.
  >
  > In production environments, worker nodes are commonly placed in **private subnets**, with application access controlled through appropriate networking and security configurations.
  >
  > **Further Exploration:** In this project, we are using **NodePort** to access the application. However, I encourage you to explore **Kubernetes Ingress** as an alternative approach. The **Cloud With VarJosh YouTube channel** already has a detailed [Ingress demonstration](https://www.youtube.com/watch?v=ngyegIE_5FM&ab_channel=CloudWithVarJosh). Try implementing Ingress in this project to gain additional hands-on experience.
- **`labels`** define Kubernetes labels for the worker nodes. In our example, `project=cwvj-mega-demo` and `workload=general` help us identify and select nodes based on their purpose. Kubernetes labels can later be used with node selectors, affinity rules, and other scheduling mechanisms to control where workloads run.
- **`tags`** are AWS resource metadata used for identification, cost allocation, reporting, automation, and governance. We have included tags such as `owner`, `project`, `purpose`, and `managed-by` to make it easier to identify resources belonging to this project. The `node-type` tag further identifies the intended role of the worker nodes.

> **Production Insight:** Use consistent **AWS tags** across your resources and meaningful **Kubernetes labels** on your nodes. Tags help with resource identification, cost allocation, reporting, and governance, while labels help organize workloads and control Kubernetes scheduling. They serve different purposes, so do not confuse the two.

Now, create the EKS cluster by running the following command from the directory containing `eks-config.yaml`:

```bash
# Create the EKS cluster and provision the AWS resources defined in the configuration file.
eksctl create cluster -f eks-config.yaml
```

Cluster creation can take several minutes. `eksctl` provisions the **EKS control plane** and the supporting AWS infrastructure required by our configuration.

Once the command completes, open the **AWS Management Console** and navigate to **Amazon EKS**. Select `cwvj-mega-demo-eks` and verify that the cluster status is **Active**.

Next, verify the following:

- **Cluster:** Confirm that `cwvj-mega-demo-eks` has been created successfully.
- **Node group:** Confirm that `cwvj-mega-demo-ng` is present and configured with two worker nodes.
- **AWS infrastructure:** Open the **VPC** and **EC2** consoles to inspect the **VPC, subnets, route tables, security groups, worker instances, and associated EBS volumes** created during provisioning.
- **Tags:** Inspect the EC2 instance tags to verify the metadata configured for the worker nodes. Remember that AWS tags and Kubernetes labels are different, so verify them separately.

Finally, confirm that the cluster is **Active** and both worker nodes are available. We will use this cluster in later labs to deploy our application through the CI/CD pipeline.

---

### Lab 2: Create Networking for SonarQube and Amazon RDS

In the previous lab, we created our **Amazon EKS cluster**, and `eksctl` provisioned a VPC along with the networking resources required by the cluster. We could deploy SonarQube and Amazon RDS using the existing subnets, but in a production environment, you would typically design the network based on the purpose of each resource and the level of isolation required.

For example, databases should generally be deployed in **private subnets**, while DevOps tools such as SonarQube, Nexus Repository, Jenkins, and self-hosted CI/CD runners may have dedicated subnets based on their connectivity requirements.

In this lab, we will create dedicated subnets for our DevOps tooling and database resources, and associate them with the appropriate route tables.

---

#### Understand the network design

Our EKS cluster resides in a VPC with the CIDR range `192.168.0.0/16`. We will use this existing VPC for SonarQube and Amazon RDS rather than creating a separate VPC.

The following subnets will be created across two Availability Zones in the Mumbai Region:

| Availability Zone | Auto-assign public IP | CIDR range | Subnet name | Purpose |
|---|---|---|---|---|
| `ap-south-1a` | Yes | `192.168.128.0/27` | `cwvj-mega-demo-devops-public-a` | Hosts DevOps tooling that requires public-subnet connectivity |
| `ap-south-1a` | No | `192.168.128.64/27` | `cwvj-mega-demo-db-private-a` | Private subnet for database resources |
| `ap-south-1b` | Yes | `192.168.128.32/27` | `cwvj-mega-demo-devops-public-b` | Second subnet for DevOps tooling in another Availability Zone |
| `ap-south-1b` | No | `192.168.128.96/27` | `cwvj-mega-demo-db-private-b` | Second private subnet for database resources |

---

#### Understand the Route Table Design

We will use **two route tables** to provide the intended network connectivity for our subnets.

- **Public route table:** We will reuse the existing `eksctl-cwvj-mega-demo-eks-cluster/PublicRouteTable`, created during EKS cluster provisioning, and associate both DevOps public subnets with it. It already has an active default route to an **Internet Gateway (IGW)**.
- **Private route table:** We will create a new route table named `cwvj-mega-demo-db-private-rt` and associate both database private subnets with it. It will retain the **local VPC route**, without a direct Internet Gateway or NAT Gateway route.

This approach **reuses the existing public routing configuration** while keeping database subnets separate from direct internet routing.

**Purpose of Each Subnet**

- **DevOps public subnets:** These host DevOps tools such as SonarQube. A subnet is **public when its associated route table has a direct route to an Internet Gateway (IGW)**. Assigning public IP addresses alone does not make a subnet public. We will configure access controls separately.

- **Database private subnets:** These are intended for **Amazon RDS**. Their route table will contain only the **local VPC route**, with no direct route to an Internet Gateway or NAT Gateway. AWS classifies this as an **isolated subnet** because it has no routes to destinations outside the VPC. In the next lab, we will configure the **database security group** to restrict which resources can connect to it.
- **Two Availability Zones:** We will create subnets in `ap-south-1a` and `ap-south-1b` to distribute resources across Availability Zones. An **RDS DB subnet group generally requires subnets in at least two Availability Zones**, even when the initial deployment uses a single-AZ DB instance.

> **Production Insight:** Keep databases in **private subnets** and expose only endpoints that genuinely require external access. DevOps tools can also run in private subnets behind a load balancer or be accessed through a VPN, bastion host, or another controlled access mechanism. Choose the design based on **security, availability, and operational requirements**.

---

#### Why are we using the same VPC?

For this project, we will keep **EKS, SonarQube, and Amazon RDS in the same VPC**. This allows us to establish private network connectivity between these resources without introducing additional VPCs and inter-VPC connectivity mechanisms.

To keep the infrastructure **simple and cost-effective**, we will use **one Amazon RDS for PostgreSQL instance** and create **three separate databases** within it:

- **SonarQube database:** Stores the information required by SonarQube, such as projects, code analysis results, and configuration.
- **DEV application database:** Stores the data used by our DEV application environment.
- **PROD application database:** Stores the data used by our PROD application environment, keeping it separate from DEV data.

This approach allows all three databases to share the same RDS instance while keeping their data logically separated.

An RDS instance can host multiple databases, depending on the database engine and its capabilities. This approach is suitable for our lab, but separate RDS instances may be more appropriate when workloads have different security, performance, availability, or maintenance requirements.

Remember, **an EKS cluster is not limited to one application**. A cluster can host multiple applications as long as it has sufficient compute resources and meets their requirements. Similarly, an environment can have multiple EKS clusters and multiple RDS instances.

For example, your architecture might include:

- **Separate environments:** Different EKS clusters for development and production, with dedicated RDS instances for stronger isolation.
- **Shared infrastructure:** Multiple applications running on the same EKS cluster, potentially sharing an RDS instance to reduce cost and operational overhead.
- **Dedicated infrastructure:** A business-critical application using its own EKS clusters and RDS instances to provide greater isolation and independent control.

> **Production Insight:** There is no single architecture that fits every application. Your design should reflect the required **isolation, security, availability, scalability, cost, and operational effort**. Sharing resources can reduce costs, while dedicated resources can provide stronger isolation and more independent control.

---

#### Create the networking resources

We have provided a script to create the networking resources required for **SonarQube and Amazon RDS**. You can find the script at the following location:

`project-files/infrastructure/setup-mega-project-network.sh`

Navigate to the directory containing the script and execute the following commands:

```bash
# Grant execute permission to the file owner only.
chmod u+x setup-mega-project-network.sh

# Execute the script to create the networking resources for this lab.
./setup-mega-project-network.sh
```

Allow the script to finish executing, then open the **Amazon VPC console** in the AWS Management Console.

Verify that all four subnets have been created in the **correct VPC**, with the expected **CIDR ranges and Availability Zones**. Also, check that the subnet names and route table associations match our intended design.

Pay particular attention to the following:

- **DevOps subnets:** Confirm that their associated route tables provide the intended public-subnet routing.
- **Database subnets:** Confirm that they remain private and do not have a direct route to an Internet Gateway.

Once the networking configuration is verified, we can proceed to the next lab, where we will create **security groups for SonarQube and Amazon RDS**.

---

### Lab 3: Create Security Groups for SonarQube and Amazon RDS

In this lab, we will create security groups for our **SonarQube instance** and **Amazon RDS instance**. Security groups act as virtual firewalls that control inbound and outbound traffic.

We will follow the **principle of least privilege**, allowing only the network traffic required by our application and DevSecOps pipeline.

---

#### Create a Security Group for SonarQube

Create a security group named **`cwvj-sonarqube-sg`** for our SonarQube instance in the **same VPC as our EKS cluster**.

Configure the following rules:

| Direction | Protocol | Port | Source/Destination | Purpose |
|---|---|---:|---|---|
| Inbound | TCP | 22 | Your public IP address (`x.x.x.x/32`) | Allow SSH access to the EC2 instance for administration. |
| Inbound | TCP | 9000 | `0.0.0.0/0` and `::/0` | Allow access to the SonarQube web interface over IPv4 and IPv6. |
| Outbound | Default rules | All | Default destinations | Allow package updates, software downloads, and database connectivity. |

> **Important:** Restrict SSH access to **your own public IP address**. In the AWS console, select **My IP** when configuring the source. Do not use `0.0.0.0/0` for SSH access. If your public IP address changes, update the security group rule accordingly.

> **Production Insight:** Allowing public access to SonarQube on port `9000` is a **lab-only simplification**. In production, restrict access to trusted networks, a VPN, or an approved load balancer or reverse proxy, and use HTTPS.

> **Note:** You can connect to the EC2 instance using **EC2 Instance Connect**, **AWS Systems Manager Session Manager**, or a standard SSH client.
>
> - **EC2 Instance Connect:** Requires the appropriate IAM permissions for the connecting user, EC2 Instance Connect software on the instance, and SSH connectivity on port `22`.
> - **Systems Manager Session Manager:** Requires the **SSM Agent** to be installed and running, appropriate IAM permissions for the instance (typically through an instance profile with `AmazonSSMManagedInstanceCore`, or Default Host Management Configuration), and IAM permissions for the connecting user to start a session. The instance also needs outbound HTTPS connectivity to Systems Manager endpoints. **No inbound SSH rule is required.**
> - **Standard SSH:** Requires an SSH key pair, an SSH client, and inbound TCP port `22` access from your public IP address.
>
> For this lab, we will use a **standard SSH connection from our local machine**.

**Why do we allow outbound traffic?**

- **Software installation:** We are creating the security group before launching the EC2 instance. When we install SonarQube later, the instance needs outbound connectivity to update system packages and download SonarQube and its dependencies.
- **Database connectivity:** SonarQube initiates connections to **Amazon RDS for PostgreSQL** to store and retrieve its data. The outbound rule permits these connections, provided the RDS security group allows inbound PostgreSQL traffic from the SonarQube security group.

SonarQube uses **port 9000** by default for its web interface. For this lab, we will allow inbound access from all IPv4 and IPv6 addresses.

> **Production Insight:** Allowing everyone to access port 9000 is a **lab-only simplification**. In production, restrict access to trusted networks, a VPN, or an approved load balancer or reverse proxy. Use HTTPS and appropriate authentication controls.

---

#### Allow GitHub Actions to Access SonarQube

Our GitHub Actions workflow needs to communicate with SonarQube to submit code analysis results. The required network configuration depends on the runner executing the workflow.

| Option | Network access | Considerations |
|---|---|---|
| **Self-hosted runner in your VPC** | Allow inbound TCP traffic on SonarQube's port `9000` (default) in its security group, using the runner's security group as the source. | Supports private connectivity, provided appropriate VPC routing is configured. You must manage and secure the runner. |
| **GitHub-hosted larger runner with static IP ranges** | Allowlist the runner's assigned static public IP ranges in the SonarQube security group or firewall. | Requires **GitHub Enterprise Cloud**, enabling static IP assignment, and a publicly reachable SonarQube endpoint. Static IP assignment is not supported for macOS larger runners. |
| **Standard GitHub-hosted runner** | Allowlist the relevant GitHub Actions IP ranges in the SonarQube security group or firewall. | Not recommended by GitHub for internal resources because of the large number of IP ranges and their changing nature. |

GitHub publishes its IP address ranges through its [Meta API](https://api.github.com/meta).

- For **Linux and Windows GitHub-hosted runners**, look for the `actions` ranges. For **macOS runners**, use the `actions_macos` ranges.
- These ranges are updated **weekly** and may change, requiring ongoing allowlist maintenance.
- Standard GitHub-hosted runners need a **publicly reachable SonarQube endpoint**, unless private connectivity is configured through another mechanism.
- **Network access and authentication are separate controls.** The security group or firewall controls network connectivity, while the SonarQube token authenticates the analysis request.

> **Production Insight:** Prefer **private connectivity through a self-hosted runner** or another appropriately configured private-networking solution. If using GitHub-hosted larger runners, static IP ranges provide a more manageable allowlisting option. Avoid relying on the large, changing IP ranges of standard GitHub-hosted runners for access control.

---

#### Create a security group for Amazon RDS

Create a security group named **`cwvj-rds-sg`** in the VPC where our EKS cluster resides.

Our RDS instance will host two databases, one for SonarQube and another for our application. We will restrict database connectivity to authorized resources.

Configure the following rules:

| Direction | Protocol | Port | Source/Destination | Purpose |
|---|---|---:|---|---|
| Inbound | TCP | 5432 | SonarQube security group | Allow SonarQube to connect to PostgreSQL |
| Outbound | No additional rules required for this design | N/A | N/A | Avoid unnecessary outbound permissions |

- **Port 5432** is the default PostgreSQL port we will use for our RDS instance.
- For the inbound rule, select the **SonarQube security group as the source**, rather than allowing access from all IP addresses or the entire VPC CIDR.
- Security groups are **stateful**, so response traffic for permitted connections is automatically allowed. We do not need a broad outbound rule just to permit responses to incoming database connections.

> **Production Insight:** Use **security group references instead of IP-based rules** when possible. This simplifies access management when private IP addresses change. Security groups control network connectivity, while database users and permissions control access to the data.

Finally, verify both security groups and their inbound and outbound rules in the **Amazon EC2 console under Security Groups**. In the next lab, we will create the Amazon RDS instance and associate it with the appropriate security group.

---

### Lab 4: Create an Amazon RDS Instance

We will create **Amazon RDS before deploying SonarQube** because SonarQube needs a database to store its configuration, projects, and code analysis results.

---

#### Create a DB subnet group

A **DB subnet group** tells Amazon RDS which subnets it can use when provisioning a database instance. We will use the private subnets created in Lab 2.

Navigate to **Amazon RDS → Subnet groups → Create DB subnet group** and configure the following:

| Setting | Value |
|---|---|
| Name | `cwvj-subnet-group` |
| Description | `cwvj-subnet-group` |
| VPC | Select the VPC created for our EKS cluster in Lab 1 |
| Availability Zones | Select `ap-south-1a` and `ap-south-1b` |
| Subnets | Select the two private database subnets created in Lab 2 |

Create the subnet group and verify that it contains both database subnets.

---

#### Create the PostgreSQL database

Navigate to **Amazon RDS → Databases → Create database** and configure the following options.

**1. Database creation method and engine**

- **Database creation method:** Full configuration
- **Engine type:** PostgreSQL, not Aurora PostgreSQL
- **Engine version:** Keep the default version offered by AWS.

**2. Templates and availability**

Choose the **Free tier** template if it is available to your account. Depending on your account eligibility and AWS console options, you may see some settings preselected or unavailable.

For this demonstration, a **Single-AZ deployment** is sufficient.

> **Production Insight:** Select an instance class and availability configuration based on your application's workload, performance requirements, availability objectives, and budget. Production databases may require Multi-AZ deployment for higher availability.

**3. Database identification and credentials**

| Setting | Value |
|---|---|
| DB instance identifier | `cwvj-mega-postgres` |
| Master username | `postgres` |
| Credentials management | Self managed |
| Master password | Set a password for the lab |

>Use meaningful resource names that identify the **project and purpose** of each resource. As your AWS environment grows, consistent naming makes resources easier to identify, troubleshoot, and manage.

For this lab, you can use a password of your choice.

> **Production Insight:** Never use a **weak or hardcoded password** in production. Modern production environments typically use dedicated **secrets management solutions**, such as **AWS Secrets Manager**, **HashiCorp Vault**, or equivalent tools, to securely store, control access to, and rotate database credentials. Restrict access to credentials based on the **principle of least privilege**.

**4. Connectivity and networking**

Configure the following settings:

| Setting | Value |
|---|---|
| Virtual private cloud (VPC) | Select the VPC created for EKS in Lab 1 |
| DB subnet group | `cwvj-subnet-group` |
| VPC security group | Select `cwvj-rds-sg` created in Lab 3 |
| Availability Zone | Select `ap-south-1a` or `ap-south-1b` for this Single-AZ lab setup |

Ensure that the database uses the **private database subnets** and the security group created in the previous lab.

**5. Monitoring**

We do not need detailed database and per-query metrics for this demonstration, so you can leave the corresponding detailed monitoring option disabled.

Review the configuration and create the database. Wait until its status changes to **Available** before proceeding.

Once the database is available, review its connectivity details in the RDS console. We will use the database endpoint when configuring SonarQube in the next lab.

---

### Lab 5: Install SonarQube on an EC2 Instance

In this lab, we will install **SonarQube on an Amazon EC2 instance** and connect it to the **Amazon RDS PostgreSQL database** created in Lab 4. Once configured, SonarQube will be ready to integrate with our GitHub Actions pipeline for code quality analysis.

---

#### Create the EC2 instance

Navigate to **Amazon EC2 → Instances → Launch instances** and configure the following:

| Setting | Value |
|---|---|
| Name | `cwvj-mega-sonarqube` |
| AMI | Ubuntu 26.04 LTS |
| Instance type | `c7i-flex.large` |
| Root volume | 20 GiB or more |
| VPC | VPC created in Lab 1 |
| Subnet | DevOps public subnet created in Lab 2 |
| Security group | SonarQube security group created in Lab 3 |
| Key pair | Select an existing key pair or create a new one |

We are using `c7i-flex.large` because SonarQube requires sufficient memory to run its web server, background processing, and search components.

> **Production Insight:** The `c7i-flex.large` instance type is eligible for certain AWS Free Tier offers and credit-based plans, but eligibility depends on your account and usage. **AWS credits are not unlimited**, and other resources can incur charges. Check your account's offer and remaining credits before launching the instance.

---

#### Connect to the EC2 instance

Once the instance is running, copy its public IP address. On your **local machine**, ensure that your private key has the correct permissions before connecting.

```bash
# Restrict the private key so only your user can read and write it.
chmod 600 ~/.ssh/<your-private-key>.pem

# Set the key file's ownership to your current user.
chown "$(whoami):$(whoami)" ~/.ssh/<your-private-key>.pem

# Connect to the Ubuntu instance using SSH and your private key.
ssh -i ~/.ssh/<your-private-key>.pem ubuntu@<sonarqube-ec2-public-ip>
```

Replace the placeholders with your actual key filename and EC2 public IP address.

After connecting, set a meaningful hostname and configure the timezone.

```bash
# Set the hostname to make the server easier to identify.
sudo hostnamectl set-hostname sonarqube

# Reload the current shell so the new hostname is reflected in the prompt.
exec bash

# Configure the timezone to India Standard Time.
sudo timedatectl set-timezone Asia/Kolkata

# Verify the configured timezone and system time.
timedatectl status

# Alternatively, display the current date and time.
date
```

Using a consistent hostname helps identify the server in SSH sessions, monitoring dashboards, and system logs.

---

#### Install Java 21

SonarQube requires a compatible Java runtime. We will install **OpenJDK 21** for this lab.

Before installing Java, you can check which OpenJDK versions are available in your configured package repositories:

```bash
# Refresh the local package index.
sudo apt update

# Search for available OpenJDK packages and versions.
sudo apt search openjdk
```

Review the output to see which OpenJDK packages are available for your Ubuntu version. Availability may vary depending on your operating system and configured repositories.

Now, install Java 21:

```bash
# Install the Java 21 runtime.
sudo apt install -y openjdk-21-jre

# Verify the installed Java version.
java --version
```

Confirm that the output shows **Java 21** before proceeding.

> **Note:** We are installing the **JRE (Java Runtime Environment)** because this EC2 instance only needs Java to **run the SonarQube server**. The JRE provides the runtime environment but does not include the Java compiler (`javac`). The **JDK (Java Development Kit)** includes the runtime along with the compiler and other development tools. If we were using this instance to **develop, compile, or build Java applications**, we would install the JDK instead.

---

### Install the PostgreSQL client and create the SonarQube database

Our PostgreSQL database is hosted on **Amazon RDS**, so we only need the **PostgreSQL client** on the EC2 instance to connect to RDS and create the SonarQube database. We do not need to install a PostgreSQL database server locally.

> **Why are we installing the PostgreSQL client here?** We are using this EC2 instance as a **thin client** to connect to our RDS database and perform the initial database setup. We could have used **any EC2 instance** with network access to the RDS instance for this purpose. Having the PostgreSQL client on the SonarQube EC2 instance is **not a prerequisite for running SonarQube**.

```bash
# Refresh the package index before installing software.
sudo apt update

# Install the PostgreSQL client tools.
sudo apt install -y postgresql-client

# Verify that the PostgreSQL client is installed.
psql --version
```

Please replace the hardcoded endpoint with a placeholder and explicitly ask students to supply their own RDS endpoint:

Connect to your RDS PostgreSQL instance using its endpoint. You can find the endpoint in **Amazon RDS → Databases → cwvj-mega-postgre → Connectivity & security**.

Replace `<YOUR_RDS_ENDPOINT>` with the endpoint of **your own RDS instance**:

```bash
# Connect to the RDS PostgreSQL server using the endpoint, port, username, and initial database.
# Replace <YOUR_RDS_ENDPOINT> with the endpoint of your RDS PostgreSQL instance.
# -h specifies the database host.
# -p specifies the PostgreSQL port.
# -U specifies the database username.
# -d specifies the database to connect to.
psql \
  -h <YOUR_RDS_ENDPOINT> \
  -p 5432 \
  -U postgres \
  -d postgres
```

> **Note:** The `postgres` database is a **default PostgreSQL database**, not an RDS-specific feature. Amazon RDS for PostgreSQL also provides a database named `postgres` by default, which we can use to connect to the server and create additional databases, such as `sonarqube`.

Enter the master password configured when you created the RDS instance. Once connected, execute the following SQL statements:

```sql
-- List the existing databases
\l

-- Create a dedicated login role for SonarQube.
-- In PostgreSQL, CREATE USER is an alias for CREATE ROLE with LOGIN enabled.
CREATE USER sonar WITH PASSWORD 'replace-with-a-strong-password';

-- Grant the sonar role to the PostgreSQL postgres user, allowing it
-- to assume the sonar role and create a database owned by the sonar role.
GRANT sonar TO postgres;

-- Create the SonarQube database and assign ownership to the sonar role.
CREATE DATABASE sonarqube OWNER sonar;

-- List the databases to verify that sonarqube was created.
\l

-- List database roles to verify that sonar exists.
\du

-- Exit the PostgreSQL interactive terminal.
\q
```

We are creating a **dedicated database user** rather than running SonarQube using the PostgreSQL master account. The `sonar` user owns the `sonarqube` database, allowing it to manage its own database objects.

> **Production Insight:** Use strong credentials and store them securely. The password shown above is a placeholder, not a password to reuse in production. For production deployments, consider storing database credentials in **AWS Secrets Manager** and controlling access through IAM.

---

#### Download and install SonarQube

We will download the SonarQube archive into `/tmp`, extract it under `/opt`, and use a stable directory name for the installation.

```bash
# Move to the temporary directory to download the installation archive.
cd /tmp

# Download the SonarQube 26.11.0 distribution archive.
curl -L -o sonarqube.zip \
  'https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.11.0.134175.zip'

# Refresh the package index before installing the archive extraction utility.
sudo apt update

# Install unzip so that we can extract the downloaded archive.
sudo apt install -y unzip

# Extract SonarQube into /opt, a standard location for manually installed
# third-party software that is not managed by the system package manager.
sudo unzip sonarqube.zip -d /opt

# Rename the version-specific directory to a stable path.
sudo mv /opt/sonarqube-26.11.0.134175 /opt/sonarqube-current
```

Using a stable directory such as `/opt/sonarqube-current` means that service configuration does not need to reference a version-specific path.

---

#### Create a dedicated SonarQube user

SonarQube should run as a **dedicated, non-root service account**, not as `root`.

```bash
# Create a system group for SonarQube.
sudo groupadd sonar

# Create a system user with the sonar group and disable interactive login.
sudo useradd --system --gid sonar --shell /bin/false sonar

# Assign ownership of the SonarQube installation to its service account.
# In the USER:GROUP format, the first value specifies the owner (user),
# and the second specifies the group. Both are named 'sonar' in our case.
# -R applies the ownership change recursively to the directory and all its contents.
sudo chown -R sonar:sonar /opt/sonarqube-current

# Grant execute permission to the file owner (sonar) only.
sudo chmod u+x /opt/sonarqube-current/bin/linux-x86-64/sonar.sh

# Verify that the sonar service account exists.
id sonar

# Verify the ownership of the installation directory.
ls -ld /opt/sonarqube-current

# Remove the downloaded archive because the installation has been extracted.
rm -f /tmp/sonarqube.zip
```

---

#### Configure SonarQube to use Amazon RDS

SonarQube must know which database to connect to. We will configure the PostgreSQL connection details in its `sonar.properties` file.

```bash
# Open the SonarQube configuration file for editing with elevated privileges.
sudo vim /opt/sonarqube-current/conf/sonar.properties
```

Add or update the following properties, replacing the password and endpoint with your actual values:

```properties
# PostgreSQL username created for SonarQube.
sonar.jdbc.username=sonar

# Password configured for the SonarQube database user.
sonar.jdbc.password=replace-with-a-strong-password

# JDBC connection URL for the Amazon RDS PostgreSQL database.
sonar.jdbc.url=jdbc:postgresql://cwvj-mega-postgre.c7m8gq4y4w13.ap-south-1.rds.amazonaws.com:5432/sonarqube
```

Save the file and exit the editor.

> **Important:** The EC2 instance's security group must be able to reach the RDS instance on TCP port `5432`. In Lab 3, we allowed this traffic from the **SonarQube security group**. The RDS instance must also be associated with the security group and private DB subnet group configured in Lab 4.

---

#### Create a systemd service for SonarQube

**systemd** is a **system and service manager** used by most modern Linux distributions. It manages different system resources through **units**, handling their lifecycle, dependencies, and activation.

A **systemd unit** represents a resource managed by systemd. Different types of units include **services** (`.service`), **sockets** (`.socket`), **mounts** (`.mount`), and **timers** (`.timer`). Each unit type defines how systemd manages that particular resource.

We will configure SonarQube as a **service unit** rather than starting it manually from the terminal. Once we create the `sonarqube.service` file, systemd recognizes it as a service unit that we can manage using `systemctl` commands, such as `systemctl start sonarqube`, `systemctl stop sonarqube`, and `systemctl restart sonarqube`. We can also configure it to **start automatically when the server reboots** and monitor its **service status** using `systemctl status sonarqube`.

> **Note:** `systemctl` is the **command-line utility** used to inspect and manage resources (units) controlled by **systemd**. It allows us to start, stop, restart, enable, disable, and check the status of units, including services, sockets, mounts, and timers.

```bash
# Create the systemd service definition for SonarQube.
sudo vim /etc/systemd/system/sonarqube.service
```

> **Important:** Files created under `/etc/systemd/system/` define **system-level units** and are commonly used for custom units managed by the system administrator.

Add the following configuration:

```ini
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube-current/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube-current/bin/linux-x86-64/sonar.sh stop
Restart=on-failure
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
```

**Note: Unit file directive explanations**

- `Description`: Human-friendly name for the service.
- `After`: Starts this service after the listed systemd units. Here, SonarQube is ordered after `network.target`.
- `Type=forking`: Tells systemd that the startup command launches the service process and then returns, with SonarQube continuing to run in the background.
- `User` / `Group`: Runs the service using the `sonar` system account instead of `root`, following the principle of least privilege.
- `ExecStart`: Full path to the command used to start SonarQube.
- `ExecStop`: Full path to the command used to stop SonarQube cleanly.
- `Restart=on-failure`: Automatically restarts the service if it exits unexpectedly or fails.
- `LimitNOFILE`: Raises the maximum number of open file descriptors available to the service. This is important for SonarQube's Elasticsearch component.
- `LimitNPROC`: Raises the maximum number of processes available to the service user.
- `WantedBy=multi-user.target`: Allows the service to start automatically during the normal system boot process.


Save the file, then run these commands:

```bash
# Reload systemd so it recognizes the new SonarQube service definition.
sudo systemctl daemon-reload

# Enable SonarQube to start automatically when the instance boots.
sudo systemctl enable sonarqube

# Start SonarQube now.
sudo systemctl start sonarqube

# Check the current service status.
sudo systemctl status sonarqube
```

SonarQube can take a few minutes to initialize. If the service is not running or the UI is unavailable, inspect the logs.

```bash
# Display the most recent systemd logs for the SonarQube service.
# -u specifies the systemd unit whose logs we want to view (sonarqube).
# -n 100 displays the last 100 log entries.
# --no-pager prints the output directly to the terminal instead of opening it in a pager.
sudo journalctl -u sonarqube -n 100 --no-pager

# View the main SonarQube application log.
sudo tail -n 100 /opt/sonarqube-current/logs/sonar.log

# View the SonarQube web server log.
sudo tail -n 100 /opt/sonarqube-current/logs/web.log

# View the background task processing log.
sudo tail -n 100 /opt/sonarqube-current/logs/ce.log

# View the search engine log.
sudo tail -n 100 /opt/sonarqube-current/logs/es.log
```

The logs help you investigate startup failures, database connectivity issues, web server errors, background processing failures, and search engine problems.

---

#### Access SonarQube

Open the following URL in your browser, replacing the placeholder with your EC2 instance's public IP address:

`http://<sonarqube-ec2-public-ip>:9000`

- **Default credentials:** Username: `admin`, Password: `admin`. You will be prompted to change the password after your initial login.
- **Verify the installation:** Explore **Quality Profiles, Quality Gates, and Rules** to familiarize yourself with SonarQube's code quality features.
- **Verify database connectivity:** Open the Administration area and review the system information to confirm that SonarQube is running and connected to the configured database.

---

#### Create the SonarQube Projects

We will create **two separate SonarQube projects**: one for the backend and one for the frontend. This allows us to analyze and manage the quality of each application independently.

##### Step 1: Create the Backend Project

Go to **Projects → Create Project** and create the backend project with the following details:

| Setting | Value |
|---|---|
| **Project key** | `cwvj-mega-backend` |
| **Display name** | `cwvj-mega-backend` |
| **Visibility** | Public or Private, as preferred for this demo |

Click **Create**.

The **project key** uniquely identifies the project in SonarQube. It must match the `sonar.projectKey` value used in the GitHub Actions workflow.

> **Production Insight:** Keep the SonarQube project key stable. Your CI/CD workflow uses this key to submit analysis results to the correct project.

---

##### Step 2: Create the Frontend Project

Create another SonarQube project with the following details:

| Setting | Value |
|---|---|
| **Project key** | `cwvj-mega-frontend` |
| **Display name** | `cwvj-mega-frontend` |
| **Visibility** | Public or Private, as preferred for this demo |

Click **Create**.

The frontend and backend will now have separate SonarQube projects and can have different Quality Gates and coverage requirements.

---

#### Create and Configure the Quality Gates

A **Quality Gate** defines conditions that code analysis must satisfy for the project to pass.

We will create separate Quality Gates for the backend and frontend. For this demonstration, we will initially use an **80% coverage threshold** so that we can observe what happens when the project does not meet the requirement.

##### Step 1: Create the Backend Quality Gate

Go to **Quality Gates → Create** and create the following Quality Gate:

| Setting | Value |
|---|---|
| **Name** | `cwvj-backend-qg` |
| **Condition** | Coverage |
| **On** | Overall Code |
| **Operator** | is greater than |
| **Value** | 80% |

Save the Quality Gate and assign it to the **`cwvj-mega-backend`** project.

The **is greater than 80%** condition means coverage must exceed 80%. Coverage of exactly 80% will not satisfy this condition.

---

##### Step 2: Create the Frontend Quality Gate

Create another Quality Gate:

| Setting | Value |
|---|---|
| **Name** | `cwvj-frontend-qg` |
| **Condition** | Coverage |
| **On** | Overall Code |
| **Operator** | is greater than |
| **Value** | 80% |

Save the Quality Gate and assign it to the **`cwvj-mega-frontend`** project.

This ensures that the frontend project is evaluated against its own Quality Gate rather than relying on a different project-level configuration.

---

#### Code Coverage and Quality Gate

**What is Code Coverage?**

**Code coverage** measures the percentage of coverable code executed during testing. SonarQube imports coverage reports generated by tools such as JaCoCo. Unit tests are commonly used, but **integration and other tests can also contribute** when their coverage is collected and included in the reports.

**Overall Code vs. New Code**

SonarQube allows us to apply Quality Gate conditions to either the **entire codebase** or only the **New Code**. Understanding the difference is particularly important when working with large, established applications.

- **Overall Code:** Evaluates code quality and coverage across the **entire codebase**, including both existing and newly added or modified code.

  - **Advantage:** Provides visibility and enforces quality standards across the entire application. It is particularly useful for new projects where there is no significant legacy code or accumulated technical debt.
  - **Disadvantage:** In established applications, existing code may already have low test coverage or other quality issues. Enforcing strict conditions on the entire codebase can make it difficult to meet Quality Gate requirements without first addressing historical issues. This may delay the integration of otherwise good-quality changes.

- **New Code:** Evaluates code quality and coverage only for **recently added or modified code**, based on the project's configured New Code Definition (for example, since the previous version, within a specified number of days, or compared with a reference branch).

  - **Advantage:** Allows teams to maintain quality standards for new changes without requiring them to fix all existing issues before delivering new features. Teams can gradually improve the overall codebase as they modify existing code.
  - **Disadvantage:** Existing code that has not been modified can continue to contain bugs, vulnerabilities, low coverage, or code smells without affecting Quality Gate conditions applied only to New Code. Teams must still monitor overall code quality and address accumulated technical debt over time.

> **Production Insight:** For established enterprise applications, a common recommended approach is to follow **Clean as You Code**, focusing Quality Gate conditions on New Code. This prevents existing technical debt from blocking new development while ensuring that newly introduced or modified code meets defined quality standards. SonarSource's recommended **Sonar way Quality Gate** follows this approach by applying its primary quality conditions to New Code.

---

**Why use Overall Code for this project?**

Our application is **built from scratch**, so we do not have a significant legacy codebase or accumulated technical debt. Therefore, applying the coverage requirement to **Overall Code** is appropriate for this demonstration because we want to measure test coverage across the entire application.

In an established enterprise application, we would generally consider applying the coverage requirement to **New Code** so that existing code does not prevent teams from delivering improvements. We could then gradually improve coverage across the remaining codebase.

---

**Does New Code make analysis faster?**

An important distinction: choosing **New Code** does not automatically mean the scanner analyses only changed files. The New Code definition determines which code is considered new for issue reporting and Quality Gate evaluation. The scanner still analyses code according to the **configured analysis scope**.

SonarQube provides separate **incremental analysis mechanisms** to reduce unnecessary analysis work:

- **Skip unchanged files:** During supported Pull Request analyses, SonarQube can skip or optimize the analysis of files that have not changed.
- **Analysis caching:** For supported languages and analysis types, SonarQube can reuse previously generated analysis results instead of repeating the same analysis from scratch.

The availability and effectiveness of these optimizations depend on the **programming language, analyzer, and type of analysis** being performed.

As DevOps engineers, we should aim to maintain effective quality controls while keeping CI/CD workflows efficient. We should use appropriate **incremental analysis optimizations** rather than weaken quality requirements simply to reduce execution time.

**Why 80% Coverage?**

- **80% is our demonstration target**, not a universal standard or a guarantee of code quality.
- Coverage shows how much coverable code is exercised by tests, but it does not guarantee effective tests or defect-free code.
- Our Quality Gate requires coverage to **meet or exceed 80%**. Coverage below this threshold fails the Quality Gate.

> **Production Insight:** Quality Gates can evaluate multiple conditions, including **coverage, bugs, vulnerabilities, security hotspots, and code duplication**. Choose thresholds based on your application's requirements and engineering standards.

> **What Does SonarQube Analyze?**
>
> - **Bugs:** Issues in the code that can cause incorrect behaviour or runtime failures.
> - **Vulnerabilities:** Security weaknesses in the code that could be exploited to compromise an application or its data.
> - **Security Hotspots:** Security-sensitive code that requires manual review to determine whether it introduces a genuine security risk.
> - **Code Smells:** Code patterns that make the application harder to understand, maintain, or modify.
> - **Code Coverage:** Measures how much of the executable code is exercised by tests, using coverage reports generated by external tools such as JaCoCo and Vitest.
> - **Code Duplication:** Identifies repeated blocks of code that could potentially be reused or refactored.
> - **Code Complexity:** Measures cyclomatic and cognitive complexity to highlight code that may be difficult to understand, test, or maintain.
> - **Technical Debt:** Estimates the effort required to fix maintainability issues and improve the codebase.
> - **Code Metrics:** Tracks metrics such as lines of code, statements, functions, and duplicated lines to help assess the size and structure of the codebase.
> - **Quality Gates:** Evaluates analysis results against configured quality criteria and determines whether a project passes or fails.

---

#### Generate a SonarQube Analysis Token

Next, generate a token that GitHub Actions can use to authenticate with SonarQube and submit code analysis results.

1. Navigate to **Administration → Security → Users**.
2. Create a dedicated service user, such as `sonar-user`, and grant only the permissions required for code analysis.
3. Under **Generate Tokens**, create a token named `github-actions-token`.
4. **Copy and securely store the token immediately**, as it may not be displayed again.

> **Production Insight:** Use a dedicated service account with **minimum required permissions**, rather than an administrator account.

---

#### Configure GitHub Actions Authentication

In your GitHub repository, navigate to **Settings → Secrets and variables → Actions** and configure the following:

| Type | Name | Value |
|---|---|---|
| **Secret** | `SONAR_TOKEN` | The token generated for the service user |
| **Variable** | `SONAR_HOST_URL` | `http://<sonarqube-ec2-public-dns>:9000` |

The GitHub Actions workflow will use these values to connect to SonarQube and submit analysis results.

---

## Stage 7: Performing Code Analysis with SonarQube

In the previous stages, we built and tested our backend and frontend applications and added a Trivy filesystem security scan. In this stage, we will integrate **SonarQube** into our GitHub Actions workflow.

SonarQube is a **code quality and security analysis platform** that can detect bugs, vulnerabilities, security hotspots, code smells, and code duplication. It can also analyze **code coverage** using reports generated by external testing tools.

For this project, we will focus on **code coverage** and configure a **Quality Gate** to determine whether the analyzed code meets our defined coverage requirement.

Because our backend and frontend use different technology stacks, we will use different tools to generate coverage reports and integrate SonarQube:

- **Backend:** Maven builds and tests our Java application, while **JaCoCo** generates the coverage report. We will use the **SonarQube Maven plugin** for analysis.
- **Frontend:** npm and Vitest handle testing, with Vitest generating an **LCOV coverage report**. We will use the **SonarQube Scan Action** for analysis.

---

#### Java Backend vs. React Frontend

The following table summarizes how our two application stacks handle dependency management, building, testing, code coverage, and SonarQube analysis.

| Concept | Java Backend | React Frontend |
|---|---|---|
| **Dependency management** | Maven | npm |
| **Dependency configuration** | `pom.xml` | `package.json` |
| **Dependency lockfile** | No separate lockfile used in this project | `package-lock.json` |
| **Build and test commands** | `mvn --batch-mode clean verify` | `npm run build` and `npm run test:coverage` |
| **Test framework** | JUnit 5 and Mockito (executed by Maven Surefire) | Vitest |
| **Coverage tool** | JaCoCo | Vitest with V8 coverage |
| **Coverage report** | `target/site/jacoco/jacoco.xml` | `coverage/lcov.info` |
| **SonarQube scanner integration** | SonarScanner for Maven (`sonar-maven-plugin`) | SonarQube Scan Action |

The key takeaway is that **each application uses its own build, testing, and coverage tools, while SonarQube provides a common platform for code quality analysis**. SonarQube consumes the coverage reports generated by JaCoCo and Vitest; it does not execute the tests or generate coverage itself.

> **Learning Note – Test Cases and Code Coverage:** Testing frameworks execute test cases written by developers or testing teams, while coverage tools measure how much application code those tests execute. **Without test cases, meaningful code coverage cannot be generated.**
>
> **DevOps Perspective:** DevOps engineers are not typically responsible for writing test cases, but should understand how tests run in CI, how coverage is generated, and how SonarQube consumes the reports.

---

#### How the Quality Gate Controls GitHub Actions

Once SonarQube analysis is configured, our workflow proceeds as follows:

In our setup, the **SonarQube Server runs on an EC2 instance**, while the **SonarQube Scanner components run on GitHub Actions runners**. The scanners perform code analysis on the runners and submit the results to the server. We do not need to manually install a separate scanner on the runner images because each integration obtains and invokes the required scanner differently.

1. **Execute Tests and Generate Coverage Reports:**
   - **Backend:** Maven executes our JUnit tests, while **JaCoCo** collects coverage data and generates the XML report at `target/site/jacoco/jacoco.xml`.
   - **Frontend:** **Vitest** executes our tests using the V8 coverage provider and generates the LCOV report at `coverage/lcov.info`.

   These coverage reports are generated during the build and test process in Stage 6. **JaCoCo and Vitest generate the reports; SonarQube does not generate coverage reports itself.**

2. **Analyze Code with SonarScanner:**

   The **SonarQube Scanner** orchestrates code analysis, imports the previously generated coverage reports, and prepares the analysis results for submission to the SonarQube Server.

   We demonstrate two different scanner integrations:

   - **Backend:** We use the **SonarScanner for Maven** through the `sonar-maven-plugin`. This is SonarSource's **recommended default scanner for Maven projects**. When Maven executes the `sonar` goal, it resolves the plugin and its dependencies from Maven repositories and runs the analysis. The plugin provides the scanner integration, so we do not need to separately download, install, or maintain the SonarScanner CLI.
   - **Frontend:** We use the official **SonarQube Scan Action** (`SonarSource/sonarqube-scan-action@v8.3.0`). The action obtains and sets up the **SonarScanner CLI** on the GitHub Actions runner and invokes it to perform the analysis.

   Both scanners run on the **GitHub Actions runner**. They use the relevant language analyzers to inspect the source code and import the existing coverage reports. **The scanners do not execute our tests or generate coverage reports.**

3. **Submit Analysis Reports:** Once analysis is complete, each scanner generates and uploads an **analysis report** to the SonarQube Server. The report contains the analysis results, including **code quality metrics, identified issues, and imported coverage information**.

4. **Process Analysis and Evaluate Quality Gates:** The SonarQube Server's **Compute Engine** processes the uploaded reports and saves the analysis results in the SonarQube database. In our setup, this database is **Amazon RDS for PostgreSQL**. The server then evaluates the results against the respective project's configured **Quality Gate**.

5. **Wait for the Quality Gate Result:** The `-Dsonar.qualitygate.wait=true` property makes the scanner **poll the SonarQube Server and wait for the Quality Gate evaluation to complete**. The scanner then receives the evaluation status.

6. **Pass or Fail the Workflow:** If the Quality Gate passes, the analysis step completes successfully. If it fails, the scanner exits with a **non-zero status**, causing the corresponding GitHub Actions step and job to fail.

> **Implementation Note:** We intentionally demonstrate **two different scanner integrations**: the SonarScanner for Maven for our Java backend, following SonarSource's recommended approach, and the official SonarQube Scan Action for our React frontend. Both perform analysis on the GitHub Actions runner and submit their results to the same SonarQube Server.

> **Production Insight:** This makes code quality an actual **CI/CD control**. The workflow can stop when defined quality standards are not met, rather than merely submitting analysis results for someone to review later.

---

### Task 1: Analyze Backend Code with SonarQube

First, rename the existing backend job from **`Backend Build and Test`** to **`Backend Build, Test and Quality Analysis`**. We will extend this same job to perform SonarQube analysis rather than creating a separate job.

> **Important:** Rename only the job's display name. Keep the existing job ID and dependencies unchanged.

Our backend application uses **Java and Maven**. Since Maven already handles the backend build and test lifecycle, we can integrate SonarQube directly into the existing workflow.

Add a **new step** to the backend job, immediately after the existing step named **`Inspect backend build outputs`**:

```yaml
- name: Analyze backend code with SonarQube
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
  run: |
    mvn --batch-mode org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
      -Dsonar.projectKey=cwvj-mega-backend \
      -Dsonar.qualitygate.wait=true
```

- This step integrates **SonarQube analysis** into the existing backend job.
- The **coverage report was generated in Stage 6** during the Maven build and test process. We will reuse that report rather than generating it again.
- The scanner analyzes the backend code and submits the results to the SonarQube server.

---

```yaml
env:
  SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
  SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
```

The scanner needs to know **where SonarQube is running** and **how to authenticate with it**.

- **`SONAR_TOKEN`** retrieves the authentication token we created earlier from GitHub Actions Secrets.
- **`SONAR_HOST_URL`** retrieves the SonarQube server URL from GitHub Actions Variables.
- We use a **Secret** for the token because it contains sensitive information.
- We use a **Variable** for the server URL because the URL itself is not sensitive.

This allows the scanner to connect to SonarQube **without hardcoding credentials or connection details** into the workflow.

> **Note:** GitHub Actions maps the values from Secrets and Variables to environment variables through the `env` block. The SonarScanner automatically recognises the standard environment variable names **`SONAR_TOKEN`** and **`SONAR_HOST_URL`**. Therefore, we do not need to explicitly pass them as Maven command-line arguments.
>
> **Important:** The environment variable names on the **left side of the `env` block`** must match SonarSource's expected names for automatic recognition. However, the GitHub Secret and Variable names on the **right side** can be different, as long as we map them correctly.
>
> For example, we can use `secrets.MY_SONAR_AUTH_TOKEN` and `vars.MY_SONAR_SERVER_URL` while keeping the environment variable names as `SONAR_TOKEN` and `SONAR_HOST_URL`.
>
> If we use different environment variable names instead, the scanner will not automatically recognise them. We would need to explicitly provide the corresponding analysis parameters:
>
> - **`-Dsonar.token`** for the authentication token.
> - **`-Dsonar.host.url`** for the SonarQube server URL.
>
> **Recommendation:** Keep the standard environment variable names and map your GitHub Secrets and Variables to them. Also, avoid passing authentication tokens directly as command-line parameters because they may be exposed in process information or logs.

---

```yaml
run: |
  mvn --batch-mode org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
    -Dsonar.projectKey=cwvj-mega-backend \
    -Dsonar.qualitygate.wait=true
```

This command invokes the **SonarQube Maven plugin** to analyze our backend code. We do not need to install a separate SonarScanner CLI on the GitHub-hosted runner because Maven resolves and runs the required plugin.

- **`mvn`** invokes Maven, which is already available on the GitHub-hosted runner.
Reference: https://docs.github.com/en/actions/concepts/runners/github-hosted-runners & https://github.com/actions/runner-images
- **`--batch-mode`** runs Maven in non-interactive mode, making it suitable for CI/CD environments.
- **`org.sonarsource.scanner.maven:sonar-maven-plugin:sonar`** identifies the SonarQube Maven plugin and its `sonar` goal. When invoked, Maven downloads the plugin and its dependencies if they are not already available in its local cache, then runs the analysis on the runner.
- **`-Dsonar.projectKey=cwvj-mega-backend`** identifies the SonarQube project that receives the analysis results. It must match the **backend project** we created earlier in SonarQube.

The scanner runs on the **GitHub Actions runner**, while the **SonarQube server on our EC2 instance** receives and processes the analysis results.

---

#### How Does the Quality Gate Affect GitHub Actions?

The following property is particularly important for our CI/CD workflow:

```yaml
-Dsonar.qualitygate.wait=true
```

Normally, SonarQube can process submitted analysis and evaluate the Quality Gate asynchronously. Setting this property to `true` makes the scanner **wait for SonarQube to complete the Quality Gate evaluation**.

- **If the Quality Gate passes**, the analysis step completes successfully.
- **If the Quality Gate fails**, the analysis step fails, causing the GitHub Actions job to fail.

This allows GitHub Actions to determine whether the analysis **passed or failed the Quality Gate**, rather than simply submitting the analysis and finishing before the result is available.

> **Production Insight:** Waiting for the Quality Gate allows GitHub Actions to treat **code quality as an actual CI/CD control**. The workflow can stop when defined quality standards are not met, rather than merely generating a report that someone must inspect manually.

---

**At this point, our backend job follows this sequence:**

```text
Checkout → Set up Java → Build, test, and generate coverage
         → Inspect build and coverage reports
         → Run SonarQube analysis
         → Wait for Quality Gate
         → Pass or fail the GitHub Actions job
```

The key takeaway is that **Maven generates the coverage report in Stage 6**, while the SonarQube Maven plugin uses the available project information and coverage report to perform analysis in Stage 7. The **SonarQube server processes the submitted analysis** and returns the Quality Gate result.

---

### Task 2: Analyze Frontend Code with SonarQube

First, rename the existing frontend job from **`Frontend Build and Test`** to **`Frontend Build, Test and Quality Analysis`**. We will extend this same job to perform SonarQube analysis rather than creating a separate job.

> **Important:** Rename only the job's display name. Keep the existing job ID and dependencies unchanged.

Our frontend uses **React, Node.js, npm, and Vitest**, so its SonarQube integration differs from the backend. We will use the **SonarQube Scan Action** to run the scanner and submit the analysis results to SonarQube.

In Stage 6, we configured the frontend job to generate the **LCOV coverage report** and verify that it exists. We will reuse that report in Stage 7 rather than generating it again.

Add a **new step** to the existing frontend job, immediately after the step named **`Inspect frontend build and test outputs`**:

```yaml
- name: Analyze frontend code with SonarQube
  uses: SonarSource/sonarqube-scan-action@v8.3.0
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
  with:
    projectBaseDir: cwvj-3tier-mega-project/frontend
    args: >
      -Dsonar.projectKey=cwvj-mega-frontend
      -Dsonar.sources=src
      -Dsonar.tests=src
      -Dsonar.test.inclusions=**/*.test.jsx
      -Dsonar.exclusions=**/*.test.jsx,src/test-setup.js
      -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
      -Dsonar.qualitygate.wait=true
```

- This step runs **SonarQube analysis** for our frontend application.
- The scanner consumes the existing coverage report generated in Stage 6.
- We configure the frontend project separately in SonarQube using the project key `cwvj-mega-frontend`.

---

#### Explanation


```yaml
uses: SonarSource/sonarqube-scan-action@v8.3.0
```

- **`uses`** invokes the official **SonarQube Scan Action** maintained by SonarSource.
- The action sets up and invokes the **SonarScanner CLI** on the GitHub Actions runner. We do not need to install the scanner manually.
- The scanner analyzes the frontend code and submits the results to our **SonarQube server running on EC2**.

---

```yaml
env:
  SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
  SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
```

The scanner needs to know **where SonarQube is running** and **how to authenticate with it**.

- **`SONAR_TOKEN`** retrieves the authentication token we created earlier from GitHub Actions Secrets.
- **`SONAR_HOST_URL`** retrieves the SonarQube server URL from GitHub Actions Variables.
- We use a **Secret** for the token because it contains sensitive information.
- We use a **Variable** for the server URL because the URL itself is not sensitive.

This allows the scanner to connect to SonarQube **without hardcoding credentials or connection details** into the workflow.

---

```yaml
with:
  projectBaseDir: cwvj-3tier-mega-project/frontend
  args: >
    -Dsonar.projectKey=cwvj-mega-frontend
    -Dsonar.sources=src
    -Dsonar.tests=src
    -Dsonar.test.inclusions=**/*.test.jsx
    -Dsonar.exclusions=**/*.test.jsx,src/test-setup.js
    -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
    -Dsonar.qualitygate.wait=true
```

The **`with` block** passes configuration options to the SonarQube Scan Action. The `args` input supplies analysis parameters to the scanner.

- **`projectBaseDir: cwvj-3tier-mega-project/frontend`** sets the frontend directory as the base directory for analysis. Relative source and coverage paths are resolved from this directory.
- **`-Dsonar.projectKey=cwvj-mega-frontend`** identifies the SonarQube project that receives the analysis results. It must match the **frontend project** we created earlier in SonarQube.
- **`-Dsonar.sources=src`** specifies the location of the frontend application source code.
- **`-Dsonar.test.inclusions=**/*.test.jsx`:** Identifies files matching the `.test.jsx` naming convention as **test files**, allowing SonarQube to distinguish test code from application source code and apply the appropriate analysis rules.
- **`-Dsonar.exclusions=**/*.test.jsx,src/test-setup.js`:** Excludes these files from **production source-code analysis**. Since our source and test files reside under the same `src` directory, we exclude `*.test.jsx` files from the source scope while retaining them in the test scope through `sonar.test.inclusions`. We also exclude `src/test-setup.js` because it contains **Vitest test-environment setup logic**, not application functionality.

  > **Important:** These properties serve different purposes. `sonar.test.inclusions` identifies test files, whereas `sonar.exclusions` excludes files from the source-code scope. **We are classifying test files separately, not excluding them from SonarQube analysis altogether.**
- **`-Dsonar.javascript.lcov.reportPaths=coverage/lcov.info`** tells SonarQube where to find the **LCOV coverage report generated by Vitest in Stage 6**. This allows SonarQube to incorporate the frontend coverage data into its analysis.

---

#### How Does the Quality Gate Affect GitHub Actions?

```yaml
-Dsonar.qualitygate.wait=true
```

This property makes the scanner **wait for SonarQube to complete the Quality Gate evaluation** rather than finishing as soon as the analysis is submitted.

- **If the Quality Gate passes**, the analysis step completes successfully.
- **If the Quality Gate fails**, the analysis step fails, causing the GitHub Actions job to fail.

> **Production Insight:** Waiting for the Quality Gate allows GitHub Actions to treat **code quality as an actual CI/CD control**, rather than simply generating a report that someone must inspect manually.

---

### Task 3: Push the Changes

We have now added SonarQube analysis for both the backend and frontend. Before running the workflow, push these changes to the `feature/initial-ci` branch.

```bash
# Check the files that have been modified.
git status

# Stage the updated GitHub Actions workflow and frontend coverage configuration.
git add .

# Commit the SonarQube integration changes.
git commit -m "ci: add sonarqube code coverage analysis"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

Once the changes are pushed, GitHub Actions will automatically trigger the workflow based on the `push` configuration for `feature/**` branches.

> **Production Insight:** Keep CI/CD configuration changes in version control just like application code. This gives you **traceability, reviewability, and a history of how the pipeline evolved**.

---

### Task 4: Observe and Verify the Workflow

Now that the SonarQube integration has been added and the changes have been pushed, open **GitHub → Actions** and select the latest run of the **GitHub Actions Mega Project** workflow.

You should see that the workflow does not completely succeed. This is **expected at this stage** because we configured our Quality Gates with an initial coverage requirement of **greater than 80%**, while the current code coverage of both applications is below that threshold.

The workflow should show the following result:

- **Repository Filesystem Security Scan:** **Passed**, meaning the Trivy filesystem scan completed successfully.
- **Backend Build, Test and Quality Analysis:** **Failed**, because the SonarQube Quality Gate failed on the code coverage requirement.
- **Frontend Build:** **Failed**, because the SonarQube Quality Gate failed on the code coverage requirement.

It is important to understand that the backend and frontend **tests themselves can pass successfully**. The failure happens later, when SonarQube evaluates the coverage against the configured Quality Gate.

The overall execution can be summarized as:

`Trivy Scan passes → Backend tests pass → Backend Quality Gate fails`

`Trivy Scan passes → Frontend tests pass → Frontend Quality Gate fails`

This demonstrates an important CI/CD concept: **a successful test execution does not automatically mean that the pipeline should pass**. SonarQube can perform an additional quality evaluation after the tests have completed, and that result can determine whether the GitHub Actions job succeeds or fails.

> **Production Insight:** A successful security scan and successful test execution do not necessarily mean that the pipeline should pass. **Quality Gates can enforce additional engineering standards**, such as minimum code coverage, bugs, vulnerabilities, security hotspots, code smells, and other code quality metrics.

For this project, we are intentionally using **code coverage as our Quality Gate condition** because it is easy to demonstrate. However, SonarQube provides several other conditions that can be used when creating a Quality Gate, as we saw earlier while configuring our custom gates. In a production environment, the conditions and thresholds should be selected according to the application's **quality, security, and engineering requirements** rather than simply using the same values demonstrated in this lab.

---

### Task 5: Update the Quality Gate Thresholds and Run the Workflow Again

The previous workflow run failed because both the backend and frontend projects were below the **80% code coverage requirement**. For this lab, we will now temporarily reduce the coverage thresholds so that the Quality Gates can pass with the current test coverage.

We will change the thresholds as follows:

| Project | Current Threshold | New Threshold |
|---|---:|---:|
| **Backend** | Greater than 80% | Greater than 60% |
| **Frontend** | Greater than 80% | Greater than 40% |

These values are being used **only for demonstration purposes** so that we can observe how changing a Quality Gate affects the GitHub Actions pipeline.

---

#### Step 1: Update the Backend Quality Gate

Open the **`cwvj-backend-qg`** Quality Gate in SonarQube.

Locate the existing **Coverage → Overall Code** condition and change the value from **80% to 60%**.

The condition should now be:

| Setting | Value |
|---|---|
| **Condition** | Coverage |
| **On** | Overall Code |
| **Operator** | is greater than |
| **Value** | 60% |

Save the Quality Gate after making the change.

---

#### Step 2: Update the Frontend Quality Gate

Next, open the **`cwvj-frontend-qg`** Quality Gate.

Change the existing **Coverage → Overall Code** condition from **80% to 40%**.

The condition should now be:

| Setting | Value |
|---|---|
| **Condition** | Coverage |
| **On** | Overall Code |
| **Operator** | is greater than |
| **Value** | 40% |

Save the Quality Gate.

> **Important:** We are lowering these thresholds only to demonstrate how a Quality Gate controls the CI pipeline. **Do not lower production quality standards simply to make a pipeline pass.** In a real project, coverage requirements should be based on the application's requirements and the team's engineering standards.

---

#### Step 3: Run the Workflow Manually

We do not need to make another code change because the Quality Gate configuration exists in SonarQube, not in our Git repository.

Instead, we will manually trigger the GitHub Actions workflow.

1. Open **GitHub → Actions**.
2. Select **GitHub Actions Mega Project**.
3. Click **Run workflow**.
4. Select the **`feature/initial-ci`** branch.
5. Click **Run workflow**.

The `workflow_dispatch` configuration in our workflow allows us to trigger the workflow manually without pushing another commit.

---

#### Step 4: Observe the New Result

Once the workflow starts, observe the execution of the three jobs.

The expected result is:

- **Repository Filesystem Security Scan:** **Passed**
- **Backend Build, Test and Quality Analysis:** **Passed**
- **Frontend Build:** **Passed**

The execution can now be summarized as:

`Trivy Scan passes → Backend tests → SonarQube → Quality Gate passes`

`Trivy Scan passes → Frontend tests → SonarQube → Quality Gate passes`

The important difference from the previous run is that the **Quality Gate thresholds have changed**, so the current coverage is now sufficient for both projects.

> **Production Insight:** This demonstrates why Quality Gates are powerful in CI/CD. **The application code did not change, but the pipeline result changed because the quality policy changed.** In production, Quality Gate thresholds should be managed carefully and should not be relaxed simply to avoid pipeline failures.

---

## Stage 8: Containerize and Scan the Application

In the previous stages, we built and tested our backend and frontend applications, added a **Trivy filesystem security scan**, and integrated **SonarQube for code quality analysis and Quality Gates**.

In this stage, we will **containerize both applications and scan the resulting container images for vulnerabilities**. We will also introduce an important production concept: **build once, validate the application, and package the same validated artifact**. Instead of rebuilding the applications during containerization, we will reuse the artifacts produced by the existing build and test processes.

Since our project contains a **Java backend** and a **React frontend**, we will handle their containerization separately:

- **Backend:** Transfer the validated JAR between GitHub Actions jobs, generate an image tag using the application version and commit SHA, build the container image, verify it, and scan it with Trivy.
- **Frontend:** Transfer the validated React build, generate an image tag using the application version and commit SHA, build the container image, verify it, and scan it with Trivy.

We will start with the backend, understand the required workflow changes, and then apply the same principles to the frontend.

---

### Backend

In **Stages 6 and 7**, our `backend-job` built the Java application, ran the tests, generated the coverage report, and completed the SonarQube analysis. We already have a **validated JAR file** produced by this process.

Our goal in Stage 8 is to **containerize the application and scan the resulting container image with Trivy**. Since we already have the required artifact, **we do not need to build the JAR again**.

**What Changes Will We Make?**

We will make two main changes to our GitHub Actions workflow:

1. **Modify the existing `backend-job`:** Upload the tested JAR as a **GitHub Actions artifact**.
2. **Create a separate `backend-image-build-scan-job`:** Download the exact JAR, read the application version, generate an image tag, build the container image, verify it, and scan it with Trivy.

**How Will the Two Jobs Share the JAR?**

Each GitHub-hosted job runs on a **fresh runner**. Therefore, the JAR created by `backend-job` will not automatically exist on the runner assigned to the second job. We will use a **GitHub Actions artifact** to transfer the JAR between jobs.

Our workflow will follow this sequence:

```text
Build + Test + Quality Analysis → Upload JAR → Download JAR → Read Version + Generate Image Tag → Build Image → Verify Image → Trivy Scan
```

> **Production Insight:** We do **not** run `mvn clean verify` again in the image-build job just to generate another JAR. Rebuilding the application increases workflow execution time and could produce a different artifact. Instead, we carry the **same validated JAR** forward.

**Why Are We Creating a Separate Job?**

Technically, we could build the container image and run the Trivy scan inside the existing `backend-job`. However, these jobs have **different responsibilities**:

- **`backend-job`:** Builds and validates the application, then uploads the validated JAR.
- **`backend-image-build-scan-job`:** Retrieves the JAR, handles image metadata and tagging, builds the container image, and performs security scanning.

This separation establishes a clear boundary between application validation and container image validation:

```text
Source Code → Build & Validate → JAR Artifact → Containerize & Scan → Container Image
```



**Our Backend Job Architecture**

The resulting architecture is:

```text
backend-job: Build + Test + Quality Analysis → Upload JAR

backend-image-build-scan-job: Download JAR → Read Application Version → Generate Image Tag → Build Image → Verify Image → Trivy Scan
```

The key principle we are introducing is:

> **Build once, validate the application, and package the same validated artifact.**

This is the natural continuation of **Stages 6 and 7**. Rather than rebuilding the application simply because we have moved to containerization, we carry forward the JAR that has already passed the application build, test, and quality analysis stages.

---

#### Understanding the Backend Dockerfile

Before we move to the tasks associated with this stage, I want to walk you through our **Backend Dockerfile** and explain the instructions we have used to build the container image.

A **Dockerfile** is a text file containing a set of instructions that Docker uses to build a container image. Each instruction defines a particular configuration or operation, such as selecting a base image, creating users, copying application files, and defining how the application should start.

> **Production Insight – Beyond Standard Base Images:**
>
> The base images we use in this project are official, publicly maintained images. However, in many enterprise environments, organizations go a step further by maintaining their own **custom, hardened base images**.
>
> These images are centrally maintained and contain only the **packages, libraries, runtime dependencies, and supporting components required by the applications** running on them. They may also include organization-specific security configurations, approved certificates, and other required components. This gives organizations greater control over what goes into their production container images.
>
> **Distroless is another important concept in minimal container image design, and it can also be applied to custom base images.** A distroless image contains only the application and its required runtime dependencies. It excludes package managers, shells, and other general-purpose operating system utilities. Organizations can use publicly maintained distroless images or build and maintain their own custom distroless images.
>
> Whether an organization uses a conventional or distroless base image, it can adopt additional container security and operational practices, such as:
>
> - **Multi-stage builds:** Separate build and runtime environments, copying only the required application artifacts into the final image.
> - **Image digest pinning:** Use immutable SHA-256 digests to ensure builds use an exact base image.
> - **Non-root execution:** Run application processes using dedicated, unprivileged users.
> - **Runtime hardening:** Apply controls such as read-only root filesystems and dropping unnecessary Linux capabilities.
> - **Image scanning and maintenance:** Regularly scan images and incorporate available security updates.
> - **Software supply-chain security:** Generate SBOMs, sign container images, and verify their provenance and authenticity.
>
> These practices help organizations build **smaller, more secure, predictable, and maintainable container images**. The right combination depends on the application's requirements and the organization's security and operational standards.
>
> **For this project:** We use official **Nginx (Frontened)** and **Eclipse Temurin (Backend)** runtime images and deliberately keep development and build dependencies outside our production containers. Our application artifacts are built, tested, and validated earlier in the GitHub Actions workflow before being packaged into their respective runtime images.

**Our Backend Dockerfile:**

```dockerfile
# Use a Java 21 runtime image based on Ubuntu 24.04 LTS.
FROM eclipse-temurin:21-jre-noble

# Add metadata to identify and describe the container image.
LABEL org.opencontainers.image.title="CWVJ User Management API" \
      org.opencontainers.image.description="Spring Boot backend for the Cloud With VarJosh GitHub Actions Mega Project" \
      org.opencontainers.image.vendor="Cloud With VarJosh"

# Create a dedicated non-root system group and user for running the application.
RUN groupadd --system --gid 10001 appuser \
    && useradd --system \
       --uid 10001 \
       --gid 10001 \
       --no-create-home \
       --shell /usr/sbin/nologin \
       appuser

# Set /app as the working directory inside the container.
WORKDIR /app

# Copy the backend JAR into the image and assign ownership to UID 10001 and GID 10001.
COPY --chown=10001:10001 user-management-api.jar app.jar

# Run the application as the non-root user and group.
USER 10001:10001

# Document the port on which the backend application listens.
EXPOSE 8080

# Start the Spring Boot application when the container launches.
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Understanding the instructions:**

**1. `FROM`**

```dockerfile
FROM eclipse-temurin:21-jre-noble
```

- **`FROM`** specifies the base image from which our application image will be built.
- **`eclipse-temurin`** is a distribution of OpenJDK maintained by the Eclipse Adoptium project.
- **`21-jre-noble`** specifies Java 21 JRE (Java Runtime Environment) based on Ubuntu 24.04 LTS (Noble Numbat).

We use a **JRE instead of a JDK** because our backend application has already been compiled and packaged into an executable JAR during the CI process. We only need the Java runtime to execute it; development tools such as the Java compiler (`javac`) are unnecessary inside the production container. This helps keep the image leaner.

> **Production Insight:** Using a JRE-based image instead of a full JDK avoids including unnecessary development tools in the production container, helping reduce the image footprint.

---

**2. `LABEL`**

```dockerfile
LABEL org.opencontainers.image.title="CWVJ User Management API" \
      org.opencontainers.image.description="Spring Boot backend for the Cloud With VarJosh GitHub Actions Mega Project" \
      org.opencontainers.image.vendor="Cloud With VarJosh"
```

- **`LABEL`** adds metadata to the container image in the form of key-value pairs.
- **`org.opencontainers.image.title`** specifies the human-readable title of the image.
- **`org.opencontainers.image.description`** describes the application packaged inside the image.
- **`org.opencontainers.image.vendor`** identifies the organization or publisher responsible for the image.

These labels follow the **Open Container Initiative (OCI) image annotation conventions**, making image metadata easier for tools and platforms to interpret. They help identify and manage images but do not affect how the application executes.

> **Note:** Labels provide metadata that helps identify, describe, and manage container images. They do not change how the application executes. Following OCI annotation conventions also makes this metadata easier for compatible tools to interpret.

---

**3. `RUN`**

```dockerfile
RUN groupadd --system --gid 10001 appuser \
    && useradd --system \
       --uid 10001 \
       --gid 10001 \
       --no-create-home \
       --shell /usr/sbin/nologin \
       appuser
```

The **`RUN`** instruction executes commands during image construction. We use it to create a dedicated Linux group and user for running our application instead of running it as root.

- **`groupadd`** creates a new Linux group.
- **`--system`** creates a system group rather than a regular user group.
- **`--gid 10001`** explicitly assigns `10001` as the group's numeric GID (Group ID).
- **`appuser`** is the name of the group being created.
- **`&&`** ensures that the next command executes only if the preceding command succeeds.

Next, we create the application user:

- **`useradd`** creates a new Linux user.
- **`--system`** creates a system user intended for running services rather than an interactive human user.
- **`--uid 10001`** assigns `10001` as the user's numeric UID (User ID).
- **`--gid 10001`** associates the user with the group whose GID is `10001`.
- **`--no-create-home`** prevents the creation of a home directory for this user.
- **`--shell /usr/sbin/nologin`** assigns a shell that prevents the user from obtaining a normal interactive login session.
  > **Note:** This prevents normal interactive login sessions, such as SSH logins. However, it does not prevent command execution through `kubectl exec`, which can directly start another shell or process inside the container.
- **`appuser`** is the name of the user being created.

Running the application under a **dedicated non-root user** follows the **principle of least privilege**: the application receives only the permissions it needs rather than the elevated privileges available to root.

> **Production Insight:** Running application containers as non-root users is an important security practice. If an application is compromised, the attacker does not automatically receive the elevated privileges available to the root user.

> **Note:** Linux can automatically create a **primary group with the same name as the user**, depending on the system configuration and `useradd` defaults. However, we explicitly create the `appuser` group using `groupadd` to ensure that it exists with the **specific GID `10001`**. We then use `useradd --gid 10001` to assign this existing group as the user's primary group. This avoids relying on distribution-specific defaults and ensures consistent user and group IDs across environments.

---

**4. `WORKDIR`**

```dockerfile
WORKDIR /app
```

- **`WORKDIR`** sets the working directory for subsequent Dockerfile instructions, such as `RUN`, `COPY`, `ADD`, `CMD`, and `ENTRYPOINT`.
- If the specified directory does not exist, Docker creates it.
- We use `/app` as the dedicated working directory for our backend application, keeping its files organized rather than placing them directly in the filesystem root.

> **Note:** None of the preceding instructions in our Dockerfile creates the `/app` directory. When Docker executes `WORKDIR /app`, it **automatically creates the directory if it does not already exist** in the base image and sets it as the working directory. Subsequent relative paths, such as the destination in our `COPY` instruction and the JAR path in `ENTRYPOINT`, are resolved relative to this directory.

---

**5. `COPY --chown`**

```dockerfile
COPY --chown=10001:10001 user-management-api.jar app.jar
```

The **`COPY`** instruction copies files from the build context into the container image.

- **`--chown=10001:10001`** assigns ownership of the copied file to UID `10001` and GID `10001`. This ensures our previously created application user and group own the JAR.
- **`user-management-api.jar`** is the source JAR generated during our earlier backend build and downloaded from the GitHub Actions artifact.
- **`app.jar`** is the destination filename inside the container. Since we previously configured `/app` as our working directory, the JAR is copied to `/app/app.jar`.

We use **numeric IDs (UID and GID)** instead of usernames because Docker can assign ownership directly without resolving user and group names inside the image. Alternatively, we can use `--chown=appuser:appuser`, provided the user and group already exist in the image.

> **Important:** We assign ownership while copying the JAR using `--chown` instead of executing a separate `RUN chown` command afterward. This avoids an additional ownership-changing instruction and ensures the **application user owns the JAR as soon as it is added to the image**.

---

**6. `USER`**

```dockerfile
USER 10001:10001
```

- **`USER`** specifies the user and group under which subsequent instructions such as `RUN`, `CMD`, and `ENTRYPOINT` execute.
- **`10001` (first value)** identifies our application user through its UID.
- **`10001` (second value)** identifies its primary group through its GID.

We use numeric IDs to reference the same user and group created earlier. From this point onwards, the application process started by the container runs as this **non-root user**, rather than root.

> **Important:** The `USER` instruction does not create a user. It selects an existing user (or numeric UID) for subsequent instructions and the container's default runtime process.

---

**7. `EXPOSE`**

```dockerfile
EXPOSE 8080
```

- **`EXPOSE`** documents the port on which the application is expected to listen inside the container.
- Our Spring Boot backend listens on port `8080`, so we declare that port here.

> **Important:** `EXPOSE` is purely **documentation**. It does not configure your application to listen on the specified port, nor does it open or publish that port. **Developers must explicitly configure the application or server to listen on the declared port.** Actual network connectivity must be configured separately through Docker port mapping, Kubernetes Services, or other networking mechanisms.

---

**8. `ENTRYPOINT`**

```dockerfile
ENTRYPOINT ["java", "-jar", "app.jar"]
```

The **`ENTRYPOINT`** instruction defines the **default executable** that runs when a container starts. It essentially establishes what the container image is designed to run.

Let's understand the command:

- **`java`** invokes the Java runtime available in our base image.
- **`-jar`** instructs Java to execute an application packaged as an executable JAR.
- **`app.jar`** is the JAR file we copied into `/app` earlier. Since `/app` is our working directory, Java resolves the filename relative to that directory.

---

**Why are we using `ENTRYPOINT` instead of `CMD`?**

- **`CMD`** specifies the default command to run when a container starts. This command can be replaced at runtime.
- **`ENTRYPOINT`** defines the main executable the container is designed to run. Arguments supplied at runtime are passed to this executable instead of replacing it.

Since our image is designed to run the **Spring Boot backend**, we use `ENTRYPOINT` to make Java the main executable. To run a completely different command, we must explicitly override it using Docker's `--entrypoint` option.

---

**Why use the exec form of `ENTRYPOINT`?**

Docker supports two forms for both `CMD` and `ENTRYPOINT`:

- **Exec form:** `ENTRYPOINT ["java", "-jar", "app.jar"]` (JSON-array syntax).
- **Shell form:** `ENTRYPOINT java -jar app.jar` (runs the command through a shell).

In our Dockerfile, we use the **exec form of `ENTRYPOINT`** to start Java directly as the container's **main process (PID 1)**, without an intermediate shell. This allows Java to receive termination signals such as `SIGTERM` directly and handle application shutdown properly.

> **Production Insight:** The exec form is generally preferred for application containers because it supports proper **signal handling and graceful shutdown**.
---

When Docker builds this image, it starts with a Java 21 runtime image, adds application metadata, creates a dedicated non-root user, establishes `/app` as the working directory, and copies our previously built JAR into that directory with the appropriate ownership.

When a container is started from this image, the `ENTRYPOINT` launches our Spring Boot application using Java 21 under the **non-root `appuser` account**.

> **Production Consideration:** Running as a non-root user is only one part of container security. Ensure the application has appropriate filesystem permissions for any directories it needs to write to, such as temporary-file or application-data directories.

The result is a **lightweight, self-contained, and security-conscious backend container image**, ready to be scanned and published to Amazon ECR.

---

### Task 1: Make Changes to the Existing `backend-job`

We need to make one change to the existing `backend-job`: **upload the tested JAR as a GitHub Actions artifact** so that another job can download and use it later in the same workflow run.

Add the following step to the existing `backend-job`, **immediately after SonarQube analysis**. The complete workflow is available separately for reference, so we are showing only the addition rather than repeating the existing workflow.

```yaml
- name: Upload backend JAR
  uses: actions/upload-artifact@v7
  with:
    name: backend-jar
    path: cwvj-3tier-mega-project/backend/target/user-management-api.jar
    if-no-files-found: error
```

**Important:** Keep this step inside the existing `steps:` block. Placing it after SonarQube analysis ensures the JAR is uploaded only after the backend has successfully completed its existing build, test, and quality validation.


- **`actions/upload-artifact@v7`:** Uploads files generated by one job as a GitHub Actions artifact, making them available to other jobs in the same workflow run.
- **`name: backend-jar`:** Assigns a **logical name to the artifact**. This is particularly important because GitHub Actions uses this name to identify the artifact when another job downloads it using `actions/download-artifact`. We must use the same artifact name in the download step.
- **`path`:** Specifies the actual file or directory to upload. Here, we are uploading one specific JAR generated by `mvn clean verify`.

  **The artifact name and the uploaded file name are two different things.** In our example:
  - Artifact name: `backend-jar`
  - Original file name: `user-management-api.jar`

  The artifact name identifies the uploaded package in GitHub Actions; it does not rename the JAR file. Therefore, when downloading the artifact, we specify `backend-jar`, not `user-management-api.jar`.

- **`if-no-files-found: error`:** Makes the workflow fail if the expected JAR cannot be found. This prevents the workflow from silently proceeding without the required build output.

> **Important:** The `name` under `with:` is different from the `name` immediately preceding `uses:`. The latter is simply the **display name of the workflow step**, shown in the GitHub Actions UI. The `with.name` value is the actual **artifact identifier** used by GitHub Actions.

> **Additional Note:** The `path` input is not restricted to individual files. We can upload an **entire directory**, multiple files, or files matching wildcard patterns. For example, specifying `cwvj-3tier-mega-project/backend/target/` would upload the contents of the target directory. We are deliberately specifying the JAR file here because it is the only build output required by our subsequent image-build job.

> **Production Insight:** This approach supports **build once, validate, and package the same artifact**. Rebuilding the application in a later job could produce a different artifact. Transferring the exact JAR that passed testing and quality analysis provides a more predictable promotion process.

At the end of this task, the `backend-job` provides the **tested backend JAR**, stored as a GitHub Actions artifact named `backend-jar`.

In the next task, we will create a separate job to download this artifact by its **artifact name (`backend-jar`)**, generate the container image tag, and **build and scan the backend container image**.

---

### Task 2: Create a New Job to Build and Scan the Backend Container Image

In the previous task, we modified the existing `backend-job` to upload the tested JAR as a GitHub Actions artifact named `backend-jar`.

We will now create a separate job that downloads this artifact, reads the application version from `pom.xml`, generates an image tag, builds the backend container image, verifies it, and scans it with Trivy.

Add the following new job after the existing `backend-job`:

```yaml
backend-image-build-scan-job:
  name: Build and Scan Backend Container Image
  runs-on: ubuntu-26.04
  needs: backend-job

  steps:
    # Checkout the repository so the Dockerfile and pom.xml are available.
    - name: Checkout source code
      uses: actions/checkout@v7

    # Download the exact JAR produced and validated by the backend job.
    - name: Download backend JAR
      uses: actions/download-artifact@v8
      with:
        name: backend-jar
        path: cwvj-3tier-mega-project/backend

    # Verify that the downloaded JAR is available.
    - name: Verify backend JAR
      working-directory: cwvj-3tier-mega-project/backend
      run: ls -lh user-management-api.jar

    # Set up Java to run the Maven Help Plugin.
    - name: Set up Java
      uses: actions/setup-java@v6
      with:
        distribution: temurin
        java-version: '21'

    # Read the application version from pom.xml.
    - name: Read application version
      id: app-version
      working-directory: cwvj-3tier-mega-project/backend
      run: |
        VERSION=$(mvn --batch-mode help:evaluate \
          -Dexpression=project.version \
          -q \
          -DforceStdout)

        echo "version=$VERSION" >> "$GITHUB_OUTPUT"

    # Generate an image tag using the application version and short commit SHA.
    - name: Generate image tag
      id: image-tag
      env:
        APP_VERSION: ${{ steps.app-version.outputs.version }}
      run: |
        IMAGE_TAG="${APP_VERSION}-${GITHUB_SHA::7}"

        echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"

    # Build the image using the exact JAR validated by the backend job.
    - name: Build backend container image
      uses: docker/build-push-action@v7
      with:
        context: cwvj-3tier-mega-project/backend
        file: cwvj-3tier-mega-project/backend/Dockerfile
        tags: cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}
        load: true

    # Display the locally built image for verification.
    - name: Verify backend container image
      run: docker images cwvj-mega-backend

    # Scan the container image for HIGH and CRITICAL vulnerabilities.
    - name: Scan backend container image with Trivy
      uses: aquasecurity/trivy-action@v0.36.0
      with:
        image-ref: cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}
        severity: HIGH,CRITICAL
        exit-code: '1'
```

---


#### Explanation

The first three lines define our new job:

```yaml
backend-image-build-scan-job:
  name: Build and Scan Backend Container Image
  runs-on: ubuntu-26.04
  needs: backend-job
```

- **`backend-image-build-scan-job`** is the unique job ID used to reference this job elsewhere in the workflow.
- **`name`** provides a readable name displayed in the GitHub Actions UI.
- **`runs-on: ubuntu-26.04`** assigns a fresh GitHub-hosted runner to the job.
- **`needs: backend-job`** ensures this job starts only after `backend-job` completes successfully.

> **Important Point:** The `needs` dependency ensures that containerization proceeds only after the backend build, tests, and SonarQube analysis succeed. We are **not using a Job Output to pass the application version**; we will retrieve it directly in this job.

---

After the checkout step, the next step downloads the JAR produced by `backend-job`:

```yaml
- name: Download backend JAR
  uses: actions/download-artifact@v8
  with:
    name: backend-jar
    path: cwvj-3tier-mega-project/backend
```

- **`actions/download-artifact@v8`** downloads an artifact uploaded earlier in the same workflow run.
- **`name: backend-jar`** must match the artifact name used by `actions/upload-artifact` in Task 1.
- **`path`** specifies where the artifact is downloaded. We place the JAR directly inside the backend directory because our Dockerfile expects it there.

**Artifact handoff:**

```text
backend-job → Upload backend-jar → Download backend-jar → Container Build
```

> **Important:** The second job runs on a **fresh runner**, so the JAR produced by `backend-job` is not already available in its workspace. The artifact transfers the exact JAR produced and validated by the previous job.
>
> **Failure behaviour:** If the requested artifact (`backend-jar`) does not exist in the current workflow run, `actions/download-artifact@v8` **automatically fails with an error**. Unlike the upload action, it does not require an additional `if-no-files-found` setting.

---

Before building the image, we verify that the expected JAR is available:

```yaml
- name: Verify backend JAR
  working-directory: cwvj-3tier-mega-project/backend
  run: ls -lh user-management-api.jar
```

- **`working-directory`** changes the working directory to the backend directory before executing the command.
- **`ls -lh`** displays the JAR's file details, including its size in a human-readable format. If the file does not exist at the specified location, `ls` returns a **non-zero exit status**, causing the step and job to fail.

> **Production Insight:** Verifying the artifact immediately after downloading makes failures easier to diagnose. We can identify an artifact handoff problem before attempting to build the container image.

---

Next, we configure Java 21 so Maven can execute and retrieve the backend application's version.

```yaml
- name: Set up Java
  uses: actions/setup-java@v6
  with:
    distribution: temurin
    java-version: '21'
```

- **`actions/setup-java@v6`:** Sets up the requested JDK on the runner. It checks the runner's tool cache for an existing installation and downloads and installs the JDK if a matching version is not available. It also configures `JAVA_HOME` and updates `PATH`.
- **`distribution: temurin`:** Specifies **Eclipse Temurin** as the JDK distribution.
- **`java-version: '21'`:** Specifies Java 21, matching our backend project's Java version.

> **Important:** Java 21 is already available in our **Ubuntu 26.04 runner image**, but Java 25 is the default. The `setup-java` action selects the requested Java 21 installation rather than relying on the runner's default. In our case, it can reuse the preinstalled JDK from the tool cache instead of downloading it again.

We need Java because **Maven itself requires a Java runtime to execute**. **We are not rebuilding the backend application** in this job; Maven is only being used to retrieve the application's version.

---

The next step reads the application version from our Maven project:

```yaml
- name: Read application version
  id: app-version
  working-directory: cwvj-3tier-mega-project/backend
  run: |
    VERSION=$(mvn --batch-mode help:evaluate \
      -Dexpression=project.version \
      -q \
      -DforceStdout)

    echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`mvn help:evaluate`** invokes the Maven Help Plugin's `evaluate` goal to evaluate a project property.
- **`-Dexpression=project.version`** uses Maven's `-D` syntax to set the `expression` property to `project.version`, retrieving the application version from `pom.xml`. The current version is `0.0.1-SNAPSHOT`.
- **`-q`** enables quiet mode to suppress routine Maven output, while **`-DforceStdout`** ensures the evaluated value is printed to standard output.
- **`VERSION=$(...)`** captures the command's output and stores the returned version in the shell variable `VERSION`.

We then publish this value as a **Step Output**:

```yaml
echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`$GITHUB_OUTPUT`** is a special file provided by GitHub Actions. Writing `version=$VERSION` to this file creates an output named `version` for the current step.
- Because the step has **`id: app-version`**, subsequent steps in the same job can access the value using **`${{ steps.app-version.outputs.version }}`**.

The flow is:

```text
pom.xml → Maven Help Plugin → VERSION → Step Output
```

---

Next, we need a **container image tag** that identifies both the application version and the source code revision used to produce the image.

```yaml
- name: Generate image tag
  id: image-tag
  env:
    APP_VERSION: ${{ steps.app-version.outputs.version }}
  run: |
    IMAGE_TAG="${APP_VERSION}-${GITHUB_SHA::7}"

    echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"
```

The `Generate image tag` step uses the following values:

- **`APP_VERSION`** receives the **Step Output** created by the `Read application version` step. We map it through `env` so that the shell script can access it as `$APP_VERSION`.

  > **Note:** We could reference `${{ steps.app-version.outputs.version }}` directly inside the `run` script. However, GitHub evaluates expressions **before passing the script to the runner**. Directly inserting an expression into the script can create a **script injection risk** if its value contains malicious shell syntax. Passing the value through an environment variable keeps it separate from the shell code. This follows GitHub's recommended security practice.

- **`GITHUB_SHA`** is a **default environment variable provided automatically by GitHub Actions**. It contains the full commit SHA associated with the workflow run and is available to every step on the runner. Therefore, we do not need to declare it in the `env` block; the shell script can access it directly.

- **`${GITHUB_SHA::7}`** uses **Bash substring expansion** to extract the first seven characters of the commit SHA. We can use `GITHUB_SHA` directly because GitHub Actions automatically makes **default environment variables** available to the runner. We do not need to declare them separately in the `env` block.

  For example, we can directly use the following variables inside a shell script:
  - **`$GITHUB_SHA`** – Full commit SHA associated with the workflow run.
  - **`$GITHUB_REPOSITORY`** – Repository name in `owner/repository` format.
  - **`$GITHUB_REF_NAME`** – Branch or tag name associated with the workflow run.
  - **`$GITHUB_WORKSPACE`** – Path to the checked-out repository on the runner.

  > **Note:** Some default environment variables are available only for specific event types. Always check their documented availability before using them.

  > **Reference:** [GitHub Actions – Default Environment Variables](https://docs.github.com/en/actions/reference/workflows-and-actions/variables#default-environment-variables)

- **`IMAGE_TAG`** combines the application version and the short commit SHA to generate the container image tag.

- **`$GITHUB_OUTPUT`** is a special file provided by GitHub Actions. Writing `image_tag=$IMAGE_TAG` to this file publishes a **Step Output** named `image_tag`.

For example, if the application version is `0.0.1-SNAPSHOT` and the short commit SHA is `a1b2c3d`, the resulting image tag is:

```text
0.0.1-SNAPSHOT-a1b2c3d
```

Since the step has **`id: image-tag`**, subsequent steps in the same job can access the generated tag using **`${{ steps.image-tag.outputs.image_tag }}`**.

> **Production Insight:** We avoid generic tags such as `latest`. A version-and-commit-based tag helps associate the **container image with its application version and source code revision**, making it easier to trace releases, identify deployed code, and investigate issues.

---

We can now build the backend container image:

```yaml
- name: Build backend container image
  uses: docker/build-push-action@v7
  with:
    context: cwvj-3tier-mega-project/backend
    file: cwvj-3tier-mega-project/backend/Dockerfile
    tags: cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}
    load: true
```

Here, we use the official **Docker Build and Push Action** rather than manually running `docker build`.

- **`context`** specifies the directory whose files are available to the Docker build.
- **`file`** points to the Dockerfile that defines how our backend application is containerized.
- **`tags`** assigns the image the version-and-commit-based tag generated in the previous step.
- **`load: true`** loads the resulting image into the runner's local Docker image store.

The `load: true` option is important because **we are not pushing the image to a registry yet**. We need the image to exist locally so that subsequent steps can inspect it and scan it with Trivy.

> **Important Point:** Stage 8 covers **building and validating the container image**. Publishing it to Amazon ECR will be introduced later.

---

Before scanning the image, we verify that Docker has created it successfully:

```yaml
- name: Verify backend container image
  run: docker images cwvj-mega-backend
```

This displays the locally available images matching `cwvj-mega-backend`, allowing us to check that the image was created with the expected tag.

The flow so far is:

```text
Download JAR → Verify JAR → Set Up Java → Read Version → Generate Image Tag → Build Image → Verify Image
```
---

Finally, we scan the container image for security vulnerabilities:

```yaml
- name: Scan backend container image with Trivy
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    scan-type: image
    image-ref: cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}
    severity: HIGH,CRITICAL
    exit-code: '1'
```

- **`scan-type`**: image tells Trivy to perform a container image scan.
- **`image-ref`** tells Trivy exactly which local container image to scan.
- **`severity: HIGH,CRITICAL`** limits the scan to vulnerabilities classified as High or Critical.
- **`exit-code: '1'`** tells Trivy to return a failure exit code when matching vulnerabilities are found.

Trivy therefore acts as a **security gate**, rather than simply reporting vulnerabilities for later review.

> **Production Insight:** A container image should not automatically progress toward a registry or deployment simply because it was successfully built. The image should first pass the required security checks. Our **Build → Verify → Scan** sequence creates that validation boundary.

We have now completed the backend containerization flow:

```text
Validated JAR → Download → Verify JAR → Read Version → Generate Image Tag → Build Image → Verify Image → Trivy Scan
```

The important architectural point is that the container image is built from the **same JAR produced by the Maven build and tests in Stage 6**. The backend also completed its **SonarQube analysis in Stage 7** before the artifact was uploaded. In Stage 8, we package that existing JAR into a container image instead of rebuilding the application.

This is the **build once, validate, and package the same artifact** approach we established at the beginning of Stage 8.

---


### Task 3: Push the Changes and Observe

We have completed the changes required to **build and scan the backend container image**. Now we will run the workflow and observe what happens when Trivy detects vulnerabilities.

Push the changes to the `feature/initial-ci` branch:

```bash
# Check the files that have been modified.
git status

# Stage the backend containerization and workflow changes.
git add .

# Commit the backend container build and security scan changes.
git commit -m "ci(backend): build and scan container image"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

**Important:** Review `git status` before committing to ensure you are staging only the intended changes. The `git add .` command stages all changes under the current directory.

GitHub Actions automatically triggers the workflow because our `push` configuration includes **`feature/**` branches**.

---

#### Observe the Workflow

When the workflow runs, the **backend container image scan should fail** because Trivy detects HIGH and CRITICAL vulnerabilities.

The scan is configured as follows:

- **`severity: HIGH,CRITICAL`** limits the findings that trigger the security gate to HIGH and CRITICAL vulnerabilities.
- **`exit-code: '1'`** makes Trivy return a non-zero exit code when matching vulnerabilities are found.
- GitHub Actions treats this as a failed step, causing `backend-image-build-scan-job` to fail.

The scan reports:

```text
Total: 8 (HIGH: 5, CRITICAL: 3)
```

Trivy identifies the operating system and Java application as separate scan targets:

```text
Target                                                    Type   Vulnerabilities
cwvj-mega-backend:0.0.1-SNAPSHOT-8bc7f8f (ubuntu 24.04)  ubuntu        0
app/app.jar                                               jar           8
```

The results mean:

- **Ubuntu 24.04: 0 vulnerabilities.** Our Dockerfile uses `FROM eclipse-temurin:21-jre-noble`, based on Ubuntu 24.04 LTS. Trivy found no matching vulnerabilities in the identified operating system packages.
- **`app/app.jar`: 8 vulnerabilities.** Trivy identified vulnerabilities in the Java application and its packaged dependencies.

These results are not contradictory. **A clean operating system scan does not mean the entire container image is free of vulnerabilities.** Our Dockerfile copies the already-built JAR into the image:

```dockerfile
COPY --chown=10001:10001 user-management-api.jar app.jar
```

The `COPY` instruction places the existing JAR inside the image and sets its file ownership. It **does not modify the JAR or fix its dependencies**, so vulnerabilities in the Java application remain detectable.

**Important:** The failure is **expected at this stage**. We deliberately want the security gate to stop an image containing HIGH or CRITICAL vulnerabilities.

In Task 4, we will update the affected Jackson and Tomcat dependency versions and rerun the workflow to verify that the image passes the security gate.

> **Important:** The vulnerability count shown in the scan results is **not fixed** and may vary between workflow executions. Trivy uses an updated vulnerability database to identify known security issues. As new vulnerabilities are disclosed and existing vulnerability records are updated, the same dependency version may produce additional findings in a later scan. Changes to dependency or base image versions can also affect the results.
>
> For example, when I initially implemented this stage, Trivy reported **8 vulnerabilities**. However, when I ran the scan again on **20 November 2026**, it reported **9 vulnerabilities**. Therefore, the numbers shown in this demonstration are illustrative. Your scan may report a different number of vulnerabilities depending on when you execute it and the versions of the dependencies being scanned.

---

#### Why Do the Repository and Image Scan Results Differ?

Our initial Trivy **repository scan (`scan-type: repo`)** reported zero vulnerabilities in the identified Maven dependencies. However, the subsequent **container image scan** detected **8 HIGH and CRITICAL vulnerabilities** in `app/app.jar`.

**Why can the results differ?**

Trivy analyses different targets depending on the scan type:

| Scan Type | What Trivy Analyses |
|---|---|
| **Repository (`repo`)** | Supported dependency files, such as Maven `pom.xml`. It does not inspect compiled JARs or container OS packages. |
| **Container Image (`image`)** | Files inside the image, including OS packages and packaged application dependencies. |

Our container image scan reported:

| Target | Type | Vulnerabilities |
|---|---|---:|
| Ubuntu 24.04 | Operating system | 0 |
| `app/app.jar` | Java application | 8 |

> **Important:** Vulnerability counts are not fixed. Trivy uses an updated vulnerability database, so new disclosures and database updates can change scan results even when dependency versions remain unchanged. Changes to application dependencies or the base image can also affect the results.
>
> For example, our initial scan reported **8 vulnerabilities**, while a rerun on **20 November 2026** reported **9**. Treat these numbers as examples; your results may differ depending on when you run the scan and which versions are present.

**Maven Dependency Analysis: Important Limitations**

Trivy analyses Maven dependencies differently depending on whether it scans `pom.xml` or a packaged JAR.

- **Dependency resolution:** When scanning `pom.xml`, Trivy looks for dependency information in the project directory, the parent POM's `relativePath`, the local Maven repository, and remote Maven repositories.
- **Supported scopes:** Trivy analyses `import`, `compile`, `runtime`, and empty Maven scopes. It skips other scopes and optional dependencies.
- **Unresolved dependencies:** If the parent POM cannot be reached or Trivy cannot determine a dependency's version, it records an empty version and cannot discover that dependency's transitive dependencies.
- **Development dependencies:** Maven POM analysis excludes development dependencies by default, whereas JAR analysis includes dependencies packaged in the JAR.
- **JAR detection:** Trivy reads `pom.properties` and `MANIFEST.MF` to identify Java packages. If these files are missing or incomplete, it can use the **Trivy Java DB** as a fallback. This fallback mechanism is experimental.

Reference: [Trivy – Java Scanning](https://trivy.dev/docs/latest/coverage/language/java/)

**Applying This to Our Project**

Our `pom.xml` references a **parent POM**, so not all dependency versions are explicitly declared in the child POM. Some versions are inherited or managed through the parent's dependency management, while other dependencies are introduced transitively.

Therefore, **looking only at the child POM does not reveal the complete resolved dependency tree**.

> **Challenge:** Investigate why the repository scan reported **zero vulnerabilities** while the image scan detected **8 vulnerabilities in `app/app.jar`**. Compare Maven's resolved dependency tree with the dependencies Trivy identifies during each scan. Pay particular attention to parent POM accessibility, dependency versions, scopes, and transitive dependencies.
>
> **Important:** These are possible reasons for the difference, not confirmed causes. Our current scan results alone do not establish exactly why the findings differ.

---

#### Optional: Scan the JAR Before Container Image Build

You can also scan the packaged JAR immediately after Maven generates it, allowing you to identify vulnerabilities **before building the container image**.

The repository scan (`scan-type: repo`) analyses supported dependency files but does not scan compiled JAR files. Trivy also does not perform JAR vulnerability scanning in `fs` mode. For this diagnostic exercise, we use **`rootfs` mode** to scan the generated JAR.

Add the following step immediately after the Maven build:

```yaml
- name: Run Trivy backend JAR scan
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    version: v0.76.2
    scan-type: rootfs
    scan-ref: cwvj-3tier-mega-project/backend/target
    scanners: vuln
    severity: HIGH,CRITICAL
    exit-code: '1'
```

This scans the Maven `target` directory, where the packaged JAR is generated. With the vulnerable dependency versions restored, Trivy should identify the vulnerabilities contained in the JAR. In our earlier run, it reported **8 HIGH and CRITICAL vulnerabilities**.

> **Note:** The exact **vulnerability count may change** as Trivy's vulnerability database is updated. Refer to the earlier note on changing vulnerability counts.
>
> **Important:** Because `exit-code: '1'` is configured, detecting matching vulnerabilities will **fail the Trivy step** and consequently the **backend job**. Downstream jobs that depend on the backend job completing successfully will be **skipped**. **Remove this diagnostic step** after reproducing the findings.

---

#### Key Takeaways

- **Filesystem scanning** provides an early security checkpoint for repository files and supported dependency definitions.
- **JAR scanning** checks the packaged Java application.
- **Container image scanning** checks the application and the operating system packages included in the image.

> **Production Insight:** Filesystem and container image scans are **complementary security checks**. Do not rely solely on an early filesystem scan to establish that the final application is secure. Scan the artifact you intend to package and deploy, and retain the container image scan as a security gate.

In our case, the image scan exposed **8 HIGH and CRITICAL vulnerabilities in `app/app.jar`**. In Task 4, we will update the affected Jackson and Tomcat versions, rerun the workflow, and verify that the resulting image passes the security gate.

---

### Task 4: Fix Backend Dependency Vulnerabilities

In the previous task, Trivy identified **8 HIGH/CRITICAL vulnerabilities** in the Java application packaged inside our backend container image. We traced these findings to the **Jackson and Tomcat dependencies**.

Open `cwvj-3tier-mega-project/backend/pom.xml`. Locate the existing `properties` section:

```xml
<properties>
    <java.version>21</java.version>
</properties>
```

Add the two dependency version properties:

```xml
<properties>
    <java.version>21</java.version>
    <jackson-bom.version>3.2.3</jackson-bom.version>
    <tomcat.version>11.0.25</tomcat.version>
</properties>
```

#### Explanation

We are **not adding Jackson or Tomcat as direct dependencies**. Spring Boot already manages these dependencies. By defining these properties, we override the versions used by its dependency management.

The flow is:

`Spring Boot Dependency Management → Jackson/Tomcat Versions → Maven Build → JAR → Container Image → Trivy Scan`

The fix happens **before the JAR is built**. When the workflow runs again, Maven resolves the dependencies using the updated versions, builds and validates the application, and uploads the resulting JAR. The image-build job then packages that **same validated JAR** into the container image for scanning.

**Push the Changes to GitHub**

```bash
# Check the modified files.
git status

# Stage the backend dependency changes.
git add cwvj-3tier-mega-project/backend/pom.xml

# Commit the vulnerability fixes.
git commit -m "fix(backend): update vulnerable Jackson and Tomcat versions"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

The push triggers the workflow again because our `push` configuration includes **`feature/**` branches**.

This time, the workflow should complete the backend build, container image build, and Trivy scan successfully.

> **Important Point:** We are fixing vulnerabilities at the **dependency level**, not by changing the Trivy configuration. We retain `severity: HIGH,CRITICAL` and `exit-code: '1'`, so the **security gate remains active**.

Once the workflow succeeds, we have demonstrated an important production practice: **build the application, validate it, package the validated artifact, and scan the resulting container image before allowing it to progress further**.

---

### Frontend

In **Stage 6**, our `frontend-job` built and tested the frontend application and generated the coverage report. In **Stage 7**, it completed the SonarQube analysis. We now have a **validated frontend build** in the `dist` directory.

In Stage 8, our goal is to **containerize this application and scan the resulting container image with Trivy**. Do we need to build the frontend application again?

No. We already have the build artifact we need.

We will make two changes:

1. **Modify the existing `frontend-job`** to upload the already-tested frontend build as a GitHub Actions artifact.
2. **Create a separate `frontend-image-build-scan-job`** to download that build, read the application version from `package.json`, generate an image tag using the application version and Git commit SHA, build the container image, verify it, and scan it with Trivy.

**Important Point:** Why upload the frontend build as an artifact? Each GitHub-hosted job runs on a **fresh runner**. The `dist` directory created by `frontend-job` will not automatically exist on the new runner. The GitHub Actions artifact provides the handoff mechanism between the two jobs.

The workflow will follow this sequence:

```text
Build + Test + Quality Analysis → Upload Frontend Build → Download Build → Generate Image Tag → Build Image → Verify Image → Trivy Scan
```

**Production Insight:** We do **not** run `npm run build` again in the image-build job. Instead, we package the **same validated frontend build** produced earlier. This avoids unnecessary rebuilds and ensures that the artifact we containerize is the one that passed the earlier validation.

Why create a separate job instead of building and scanning the image inside the existing `frontend-job`?

Both approaches are technically possible, but separating them gives each job a clear responsibility:

- **`frontend-job`:** Builds and validates the frontend application, then uploads the build artifact.
- **`frontend-image-build-scan-job`:** Downloads the validated build, reads the application version, generates the image tag, builds the container image, and scans it.

This separation creates clearer **failure boundaries**, simplifies artifact handoffs, and makes it easier to apply different permissions, tools, and controls to each job. Because the second job explicitly downloads the artifact, the containerization process does not depend on files left behind by the first runner.

As the project grows, this separation also allows us to **publish the container image to Amazon ECR and promote it toward deployment** without changing the application build and validation job.

Our frontend workflow therefore becomes:

```text
frontend-job: Build + Test + Quality Analysis → Upload Frontend Build

frontend-image-build-scan-job: Download Build → Read Version + Generate Image Tag → Build Image → Verify Image → Trivy Scan
```

The key principle is **build once, validate the application, and package the same validated artifact**. We are extending the workflow from application validation to containerization without rebuilding the application unnecessarily.

---

#### Understanding the Frontend Dockerfile

Before we move to the tasks associated with this stage, I want to walk you through our **Frontend Dockerfile** and explain the instructions we have used to build the container image.

A **Dockerfile** is a text file containing a set of instructions that Docker uses to build a container image. Each instruction defines a particular configuration or operation, such as selecting a base image, upgrading packages, copying application files, configuring permissions, and defining how the application should start.

Unlike our backend Dockerfile, which uses a Java runtime to execute a Spring Boot JAR, our frontend Dockerfile uses **Nginx to serve the static production files generated by Vite**. Nginx also acts as a reverse proxy, forwarding API requests to our backend service.

**Our Frontend Dockerfile:**

```dockerfile
# Use the official Nginx image based on Alpine 3.24 (slim variant).
FROM nginx:1.31.6-alpine3.24-slim

# Upgrade installed packages to the latest versions available from the configured Alpine repositories.
RUN apk upgrade --no-cache

# Remove the default Nginx server configuration.
RUN rm /etc/nginx/conf.d/default.conf

# Copy our application-specific Nginx configuration into the image.
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the Vite production build output into Nginx's document root.
COPY dist /usr/share/nginx/html

# Prepare writable cache and PID-file locations for the non-root Nginx process.
RUN chown -R nginx:nginx /var/cache/nginx \
    && touch /tmp/nginx.pid \
    && chown nginx:nginx /tmp/nginx.pid

# Run Nginx as a non-root user.
USER nginx

# Declare the container port used by our Nginx configuration.
EXPOSE 8080

# Set the default command for the inherited Nginx entrypoint.
CMD ["nginx", "-g", "daemon off;"]
```

**Understanding the instructions:**

**1. `FROM`**

```dockerfile
FROM nginx:1.31.6-alpine3.24-slim
```

- **`FROM`** specifies the base image from which our application image will be built.
- **`nginx`** is the official Nginx image, maintained by the Nginx Docker maintainers.
- **`1.31.6`** specifies the Nginx version.
- **`alpine3.24`** specifies Alpine Linux 3.24 as the underlying operating system.
- **`slim`** identifies the slim image variant.

We use an Nginx-based image because our React application has already been built into static production files. We don't need Node.js or a Node.js application server inside the production container. **Nginx is responsible for serving the generated HTML, CSS, and JavaScript files.**

The base image also provides an `nginx` system user and group, which we will use to run the server without root privileges.

> **Production Insight:** Choosing a suitable runtime image avoids including unnecessary development tools in the production container. In our case, the frontend only needs Nginx to serve static files and handle reverse proxy requests.

---

**2. `RUN apk upgrade --no-cache`**

```dockerfile
RUN apk upgrade --no-cache
```

The **`RUN`** instruction executes commands during image construction. We use it here to upgrade the installed Alpine packages.

- **`apk`:** Alpine Package Keeper, **Alpine Linux's native package management utility**, used to install, remove, and upgrade packages.
  > **Why `apk` instead of `apt`?** Our base image, `nginx:1.31.6-alpine3.24-slim`, is based on **Alpine Linux 3.24**. Alpine uses `apk` as its package manager, whereas **`apt` is used by Debian and Ubuntu-based distributions**. Therefore, we use `apk` because it is the package manager supported by our chosen base image.
- **`upgrade`:** Upgrades installed packages to the latest eligible versions available from the configured Alpine package repositories.
- **`--no-cache`:** Prevents APK from using a local cache path, avoiding retention of package index and cache data in the image.

> **Note:** We are using `apk upgrade` because Trivy identified vulnerabilities in packages included in our existing Nginx base image. For this project, we are demonstrating **two approaches to vulnerability remediation**:
>
> - **Backend application dependencies:** We updated the affected Maven dependency versions in `pom.xml`.
> - **Container operating-system packages:** We used `apk upgrade` to incorporate available security fixes into the Alpine packages.
>
> You can choose between two approaches:
> - **Upgrade all eligible packages:** `apk upgrade --no-cache` upgrades all installed packages for which newer eligible versions are available.
> - **Selective upgrade:** Identify the vulnerable package names from Trivy's findings and pass only those packages to `apk upgrade`. For example:
>   ```dockerfile
>   RUN apk --no-cache upgrade <package-1> <package-2>
>   ```
>   This upgrades the specified packages **along with any dependencies required for the upgrade**, rather than upgrading every installed package.
>
> In **production environments**, we would generally prefer controlled and tested package updates rather than upgrading packages indiscriminately during every image build. We would also manage package versions to maintain **build reproducibility and predictability**.
>
> This implementation demonstrates both remediation techniques. We will rerun Trivy to verify the fixes and identify any remaining vulnerabilities.

---

**3. `RUN rm`**

```dockerfile
RUN rm /etc/nginx/conf.d/default.conf
```

The **`rm`** command removes files or directories in Linux.

- **`/etc/nginx/conf.d/default.conf`:** The default Nginx server configuration provided by the base image. It defines the default virtual server configuration.

We remove this file because we are supplying our **own application-specific Nginx configuration** in the next instruction. This prevents the default server configuration from being retained unnecessarily and avoids confusion about which server configuration should be used.

> **Important:** Notice that we are removing `default.conf` from `/etc/nginx/conf.d/`, whereas our custom configuration is copied to `/etc/nginx/nginx.conf`. These are **two different configuration locations**:
> - **`/etc/nginx/nginx.conf`:** Nginx's main configuration file, which controls global settings and can include additional server configurations.
> - **`/etc/nginx/conf.d/default.conf`:** A separate server configuration file, typically loaded through an `include` directive in the main configuration.
>
> Our custom `nginx.conf` does not include `/etc/nginx/conf.d/*.conf`. Therefore, the default configuration would not be loaded by our current setup even if it remained in the image. We remove it to **keep the image clean and avoid potential configuration conflicts** if additional configuration includes are introduced later.

---

**4. `COPY nginx.conf`**

```dockerfile
COPY nginx.conf /etc/nginx/nginx.conf
```

The **`COPY`** instruction copies files from the build context into the container image.

- **`nginx.conf`:** Our application-specific Nginx configuration file present in the frontend build context.
- **`/etc/nginx/nginx.conf`:** The destination path where Nginx expects its **main configuration file**.

Unlike the previous `RUN rm` instruction, which removes the default server configuration, this instruction **replaces the base image's main Nginx configuration** with our own. We do this because we need Nginx to do more than simply serve static content. Our configuration defines the listening port, static content directory, API reverse proxy, and routing behaviour for the React application.

In particular, our configuration provides the following functionality:

- **Port `8080`:** Nginx listens on port `8080` instead of the default HTTP port `80`.
- **Static content:** Serves the React production build from `/usr/share/nginx/html`.
- **API reverse proxy:** Forwards requests beginning with `/api/` to our backend Kubernetes Service, `cwvj-backend`, on port `8080`.
- **React routing:** Uses `try_files` to serve `index.html` when a requested frontend route does not correspond to an existing static file. This supports **client-side routing** in our React application.

> **Important:** The custom Nginx configuration connects our frontend and backend at runtime. The browser communicates with Nginx, and Nginx forwards API requests to the backend Kubernetes Service. This allows the frontend to use the **same origin for both static content and API requests**, avoiding the need for the browser to communicate directly with the backend Service.

---

**5. `COPY dist`**

```dockerfile
COPY dist /usr/share/nginx/html
```

We use the **`COPY`** instruction again, this time to copy our frontend production build into the Nginx image.

- **`dist`** is the output directory generated by Vite when we execute `npm run build`.
- **`/usr/share/nginx/html`** is the directory from which Nginx serves static content.

When Vite builds our React application, it generates production-ready HTML, CSS, JavaScript, and other static assets inside `dist`. We copy those generated files into Nginx's document root so that Nginx can serve them to users.

Notice that we copy the **contents of `dist`** into `/usr/share/nginx/html`, rather than creating another `dist` directory inside it.

We also intentionally leave these files without an ownership change. Nginx only needs **read access** to serve the frontend assets; it does not need to modify them.

> **Important:** We are not copying the React source code or installing Node.js dependencies inside the container. We are copying the **validated production build artifact** generated earlier in our CI workflow.

---

**6. `RUN chown` – Prepare NGINX Cache Directory**

```dockerfile
RUN chown -R nginx:nginx /var/cache/nginx
```

We use this `RUN` instruction to ensure that NGINX has the required permissions to write to its cache directory when running as a **non-root user**.

Let's understand the command:

- **`chown`** changes the ownership of files and directories.
- **`-R`** applies the ownership change recursively to the specified directory and its contents.
- **`nginx:nginx`** follows the `USER:GROUP` format. The first `nginx` specifies the owner (user), and the second specifies the group.
- **`/var/cache/nginx`** is used by NGINX for temporary files and caching operations.

Since NGINX runs as the `nginx` user, we assign ownership of this directory to ensure it has the **necessary write permissions**.

> **Production Insight:** Running NGINX as a non-root user requires more than just adding the `USER` instruction. We must ensure that the user has the **necessary permissions to access configuration files and write to runtime directories**, without granting unnecessary privileges.

---

**7. `USER`**

```dockerfile
USER nginx
```

The **`USER`** instruction specifies the user (and optionally the group) under which subsequent Dockerfile instructions and the container's default runtime process execute.

- **`nginx`:** Refers to the **non-root user already created by the official Nginx base image**. The base image creates both the `nginx` user and its corresponding group, so we do not need to create them explicitly in our Dockerfile.
  
We switch to this user so that Nginx does not run with **root privileges**. From this point onwards, the container's default runtime process runs under the **non-root `nginx` account**.

> **Why didn't we create a user explicitly, as we did in the backend?** In our backend Dockerfile, we explicitly created the **`appuser` user and group** with a dedicated UID and GID because we wanted a specific application identity to own and run our Java application. In this frontend Dockerfile, the official Nginx image already provides the required `nginx` user and group, so creating another user would be redundant.
>
> **Production Insight:** Running Nginx as a non-root user follows the **principle of least privilege**. The web server does not need unrestricted root privileges to serve static files and proxy API requests.

---

**8. `EXPOSE`**

```dockerfile
EXPOSE 8080
```

- **`EXPOSE`** documents the port on which the application is expected to listen inside the container.
- Our custom Nginx configuration specifies `listen 8080`, so we declare port `8080` here.

We use port `8080` instead of the default HTTP port `80` because ports below `1024` are privileged ports on Linux. Running Nginx as a regular non-root user makes using a non-privileged port a suitable choice.

> **Important:** `EXPOSE` does not publish the container port to the host machine or make it externally accessible by itself. Actual network connectivity must be configured separately through Docker port mapping, Kubernetes Services, or other networking mechanisms.

---

**9. `CMD`**

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

The **`CMD`** instruction specifies the **default command** to execute when a container starts.

Let's break down the command:

- **`nginx`:** Invokes the Nginx server executable.
- **`-g`:** Allows us to specify a global Nginx configuration directive.
- **`daemon off;`:** Tells Nginx to run in the **foreground** rather than starting as a background daemon.

We use the **exec form** of `CMD`, represented by JSON-array syntax, instead of the shell form. This executes the specified command directly without introducing an intermediate shell.

**Why `CMD` here but `ENTRYPOINT` in the backend?**

- **Backend Dockerfile:** We use `ENTRYPOINT ["java", "-jar", "app.jar"]` because **Java is the primary application executable**. We want the container to launch our Spring Boot application as its main process.
- **Frontend Dockerfile:** The official Nginx base image already defines an **`ENTRYPOINT`** (`/docker-entrypoint.sh`). This script executes applicable initialization hooks from `/docker-entrypoint.d/` and subsequently runs the command supplied through `CMD`.

Therefore, our startup sequence is:

```text
Container starts
      |
      v
/docker-entrypoint.sh
      |
      v
Execute Nginx initialization scripts
      |
      v
exec nginx -g "daemon off;"
      |
      v
Nginx runs in the foreground
```

We deliberately use `CMD` to provide the default Nginx startup command while **preserving the inherited `ENTRYPOINT`**. Defining our own `ENTRYPOINT` would replace the base image's startup script and bypass its initialization hooks unless we explicitly invoked that script ourselves.

> **Important:** The official Nginx image already defines the same `CMD` instruction. We explicitly retain it in our Dockerfile to make the intended startup command visible and self-documenting.

**Production Insight:** Containers should run their primary application process in the **foreground**. The `daemon off;` directive ensures Nginx remains the main running process, allowing Docker and Kubernetes to manage its lifecycle, monitor its status, and stop it through the normal container lifecycle.

---

When Docker builds this image, it starts with the official Nginx image, upgrades the installed Alpine packages, replaces the default Nginx configuration, and copies our validated React production build into Nginx's static content directory.

It also prepares the required filesystem permissions and configures Nginx to run as a **non-root user**.

When a container starts, Nginx serves the React application on port `8080` and forwards requests under `/api/` to our **backend Kubernetes Service**, `cwvj-backend`.

The result is a **lightweight, security-conscious frontend container image**, ready to be scanned and published to Amazon ECR.

---

### Task 1: Make Changes to the Existing `frontend-job`

We need to make one change to the existing `frontend-job`: **upload the validated frontend build as a GitHub Actions artifact** so the image-build job can download and use it.

Add the following step to the existing `frontend-job`, **immediately after SonarQube analysis**. The complete workflow is available separately for reference, so we are showing only the addition rather than repeating the existing workflow.

```yaml
- name: Upload frontend build
  uses: actions/upload-artifact@v7
  with:
    name: frontend-dist
    path: cwvj-3tier-mega-project/frontend/dist
    if-no-files-found: error
```

**Important:** Keep this step inside the existing `steps:` block. Placing it after SonarQube analysis ensures the frontend build is uploaded only after the frontend job has successfully completed its existing build, test, and quality validation.

---

#### Explanation

The step uploads the frontend build produced by our existing workflow:

```yaml
- name: Upload frontend build
  uses: actions/upload-artifact@v7
  with:
    name: frontend-dist
    path: cwvj-3tier-mega-project/frontend/dist
    if-no-files-found: error
```

- **`actions/upload-artifact@v7`** uploads files produced by one job so another job can download them later in the same workflow run.
- **`name: frontend-dist`** assigns the artifact a name that the image-build job will use when downloading it.
- **`path`** specifies the `dist` directory containing the built frontend application.
- **`if-no-files-found: error`** makes the workflow fail if the expected build directory or its files cannot be found.

The artifact is uploaded **after SonarQube analysis**, so only a frontend build from a successfully completed validation job becomes available for containerization.

> **Production Insight:** This approach supports **build once, validate, and package the same artifact**. Rebuilding the application in a later job could produce a different artifact. Transferring the exact frontend build that passed validation provides a more predictable promotion process.

At the end of this task, the `frontend-job` provides the **validated frontend build**, stored as a GitHub Actions artifact named `frontend-dist`.

In the next task, we will create a separate job to download this exact build, read the application version from `package.json`, generate the container image tag using the application version and Git commit SHA, and **build and scan the frontend container image**.

---

### Task 2: Create a New Job to Build and Scan the Frontend Container Image

In the previous task, we modified the existing `frontend-job` so that it now provides the **validated frontend build**, stored as a GitHub Actions artifact named `frontend-dist`.

We will now create a separate job that downloads this exact build, reads the application version from `package.json`, generates the container image tag, and **builds and scans the frontend container image**.

Add the following new job after the existing `frontend-job`:

```yaml
frontend-image-build-scan-job:
  name: Build and Scan Frontend Container Image
  runs-on: ubuntu-26.04
  needs: frontend-job

  steps:
    # Checkout the repository so the Dockerfile and package.json are available.
    - name: Checkout source code
      uses: actions/checkout@v7

    # Download the exact frontend build produced and validated by the frontend job.
    - name: Download frontend build
      uses: actions/download-artifact@v8
      with:
        name: frontend-dist
        path: cwvj-3tier-mega-project/frontend/dist

    # Verify that the frontend build artifact is available.
    - name: Verify frontend build
      working-directory: cwvj-3tier-mega-project/frontend
      run: ls -lah dist

    # Read the application version from package.json.
    - name: Read application version
      id: app-version
      working-directory: cwvj-3tier-mega-project/frontend
      run: |
        VERSION=$(node -p "require('./package.json').version")
        echo "version=$VERSION" >> "$GITHUB_OUTPUT"

    # Generate a readable image tag using the application version and short commit SHA.
    - name: Generate image tag
      id: image-tag
      env:
        APP_VERSION: ${{ steps.app-version.outputs.version }}
      run: |
        IMAGE_TAG="${APP_VERSION}-${GITHUB_SHA::7}"
        echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"

    # Build the frontend container image using the validated frontend build artifact.
    - name: Build frontend container image
      uses: docker/build-push-action@v7
      with:
        context: cwvj-3tier-mega-project/frontend
        file: cwvj-3tier-mega-project/frontend/Dockerfile
        tags: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
        load: true

    # Display the locally built container image for verification.
    - name: Verify frontend container image
      run: docker images cwvj-mega-frontend

    # Scan the container image for HIGH and CRITICAL vulnerabilities.
    - name: Scan frontend container image with Trivy
      uses: aquasecurity/trivy-action@v0.36.0
      with:
        scan-type: image
        image-ref: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
        severity: HIGH,CRITICAL
        exit-code: '1'
```

#### Explanation

The first lines define our new job:

```yaml
frontend-image-build-scan-job:
  name: Build and Scan Frontend Container Image
  runs-on: ubuntu-26.04
  needs: frontend-job
```

- **`frontend-image-build-scan-job`** is the unique job ID used to reference this job elsewhere in the workflow.
- **`name`** provides a readable name displayed in the GitHub Actions UI.
- **`runs-on: ubuntu-26.04`** provides a fresh GitHub-hosted runner.
- **`needs: frontend-job`** ensures that containerization starts only after `frontend-job` completes successfully.

The `needs` dependency establishes the execution order. The frontend build is transferred separately through the GitHub Actions artifact.

---

The first step after checkout retrieves the frontend build produced by `frontend-job`:

```yaml
- name: Download frontend build
  uses: actions/download-artifact@v8
  with:
    name: frontend-dist
    path: cwvj-3tier-mega-project/frontend/dist
```

- **`actions/download-artifact@v8`** downloads an artifact uploaded earlier in the same workflow run.
- **`name: frontend-dist`** must match the artifact name used by `actions/upload-artifact` in the previous task.
- **`path`** specifies where the artifact is downloaded. We place the compiled frontend files inside the `dist` directory expected by our Dockerfile.

Because this job runs on a **fresh runner**, the original `dist` directory is not automatically available. The artifact provides the handoff mechanism between the two jobs.

---

Before building the image, we verify that the expected files are available:

```yaml
- name: Verify frontend build
  working-directory: cwvj-3tier-mega-project/frontend
  run: ls -lah dist
```

- **`working-directory`** sets the frontend directory as the working directory for the command.
- **`ls -lah dist`** lists the contents of `dist`, including file sizes and hidden files.
- If the directory is missing, the command fails and the job stops before attempting the Docker build.

**Production Insight:** This check helps identify artifact handoff problems immediately, rather than discovering later that Docker cannot find the frontend files.

---

We want the container image tag to identify both **the application version** and **the source code revision**. We read the version directly from `package.json` in this job, then combine it with the short Git commit SHA.

First, read the application version:

```yaml
- name: Read application version
  id: app-version
  working-directory: cwvj-3tier-mega-project/frontend
  run: |
    VERSION=$(node -p "require('./package.json').version")

    echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`node -p`** evaluates a JavaScript expression and prints its result.
- **`require('./package.json').version`** reads the `version` property from the frontend's `package.json`. In our project, the current value is `0.1.0`.
- **`VERSION`** stores the application version in a shell variable.
- **`$GITHUB_OUTPUT`** is a special file provided by GitHub Actions. Writing `version=$VERSION` to it creates a **Step Output** named `version`.
- Because the step has **`id: app-version`**, the value can be referenced using `${{ steps.app-version.outputs.version }}`.

Unlike the backend, which uses Maven to retrieve the version from `pom.xml`, the frontend uses Node.js to read it from `package.json`. Node.js is already available on the GitHub-hosted runner, so no additional tool installation is required.

---

Next, generate the image tag:

```yaml
- name: Generate image tag
  id: image-tag
  env:
    APP_VERSION: ${{ steps.app-version.outputs.version }}
  run: |
    IMAGE_TAG="${APP_VERSION}-${GITHUB_SHA::7}"
    echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"
```

- **`APP_VERSION`:** Receives the frontend application version extracted from `package.json` by the previous step.
- **`GITHUB_SHA`:** Uses GitHub's predefined environment variable containing the full commit SHA. `${GITHUB_SHA::7}` extracts its first seven characters.
- **Image tag:** Combines both values to generate a tag such as `0.1.0-a1b2c3d`.
- **Step Output:** Writes the generated tag to `$GITHUB_OUTPUT`, making it available to subsequent steps through `${{ steps.image-tag.outputs.image_tag }}`.

The complete flow is:

```text
package.json → APP_VERSION ─┐
                            ├→ Image Tag → Build Image → Trivy Scan
GITHUB_SHA → Short SHA ─────┘
```

> **Production Insight:** As explained in the backend implementation, combining the application version with the commit SHA provides **traceability between the container image, application release, and source code revision**, making image promotion and rollback easier.

---

We can now build the image using the **Docker Build and Push Action**:

```yaml
- name: Build frontend container image
  uses: docker/build-push-action@v7
  with:
    context: cwvj-3tier-mega-project/frontend
    file: cwvj-3tier-mega-project/frontend/Dockerfile
    tags: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
    load: true
```

- **`context`** specifies the directory Docker uses as the build context. It includes the downloaded `dist` directory and the files needed by the Docker build.
- **`file`** identifies the Dockerfile that defines how the frontend application is containerized.
- **`tags`** assigns the image the version and commit-based tag generated in the previous step.
- **`load: true`**: Loads the built image into the runner's **local Docker image store**, making it available for subsequent verification and Trivy scanning.
  > **If omitted**, the image will not automatically be loaded into the local image store when using the `docker-container` builder. Consequently, `docker images` will not show the newly built image, and the subsequent Trivy scan using the local `image-ref` will not be able to find it.

Our frontend Dockerfile uses Nginx to serve the compiled frontend files. Its `COPY dist /usr/share/nginx/html` instruction places the validated frontend build in Nginx's web root. The Dockerfile also includes the security and runtime configuration we established earlier.

---

Before scanning, we verify that Docker has created the image:

```yaml
- name: Verify frontend container image
  run: docker images cwvj-mega-frontend
```

This command lists locally available images matching `cwvj-mega-frontend`, allowing us to check that the image exists and has the expected tag.

---

Finally, we scan the image for security vulnerabilities:

```yaml
- name: Scan frontend container image with Trivy
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    scan-type: image
    image-ref: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
    severity: HIGH,CRITICAL
    exit-code: '1'
```

- **`scan-type: image`:** Explicitly tells Trivy to use **container image scanning mode**. Although `image` is the action's default, specifying it makes our scanning intention clear and self-documenting.
- **`image-ref`:** Identifies the exact **locally built container image** to scan, including its generated tag. This ensures we scan the image produced by our preceding Docker build step.
- **`severity: HIGH,CRITICAL`:** Limits the findings that trigger this security gate to **High and Critical vulnerabilities**.
- **`exit-code: '1'`:** Makes the Trivy step return a **non-zero exit code** if vulnerabilities matching the configured severity levels are found, causing the step and consequently the job to fail.

Trivy is therefore not just reporting vulnerabilities for later review. It acts as a **security gate** in our workflow.

Although we expect the image to pass because we have upgraded the available Alpine packages, the scan remains strict. **Package upgrades do not guarantee that all vulnerabilities are eliminated.** If a matching vulnerability is identified in a future build, the job will fail rather than silently allowing the image to progress.

**Production Insight:** A successfully built image should not automatically proceed toward a registry or deployment. It must first pass the required security checks. Our validation boundary is **Build → Verify → Scan**.

---

We have now established the frontend containerization flow:

```text
Validated Frontend Build → Download → Verify Build → Read Version + Generate Image Tag → Build Image → Verify Image → Trivy Scan
```

The key architectural principle remains **build once, validate, and package the same artifact**. We containerize the frontend build that was already tested and validated in the earlier stages, rather than rebuilding the application during containerization.

---

### Task 3: Push the Changes and Observe

We have completed the changes required to **build and scan the frontend container image**. Before moving forward, we will run the workflow and observe the security gate in action.

Unlike the backend, where Trivy identified HIGH and CRITICAL vulnerabilities that required dependency updates, the frontend Dockerfile already incorporates the remediation for the previously identified image vulnerabilities. Therefore, **we expect the frontend image scan to pass without detecting HIGH or CRITICAL vulnerabilities**.

Push the changes to the `feature/initial-ci` branch:

```bash
# Check the files that have been modified.
git status

# Stage the updated files.
git add .

# Commit the frontend containerization changes.
git commit -m "ci: build and scan frontend container image"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

Once the changes are pushed, GitHub Actions automatically triggers the workflow because our `push` configuration includes **`feature/**` branches**.

**Important:** Before committing, review the output of `git status` and ensure that you are staging only the intended changes. The `git add .` command stages all changes under the current directory, not just the workflow file.

---

#### Observe the Workflow

When the workflow runs, observe the new **`frontend-image-build-scan-job`** and verify that it completes the following steps:

| Step | What to verify |
|---|---|
| **Download frontend build** | Downloads the `frontend-dist` artifact uploaded by `frontend-job`. |
| **Verify frontend build** | Confirms that the expected production files are available in the `dist` directory. |
| **Generate image tag** | Combines the application version from `package.json` with the short Git commit SHA. |
| **Build frontend container image** | Builds the image using the existing frontend Dockerfile and loads it into the runner's local Docker image store using `load: true`. |
| **Verify frontend container image** | Displays the locally available `cwvj-mega-frontend` image and its generated tag. |
| **Trivy image scan** | Scans the built image for **HIGH and CRITICAL vulnerabilities** using `scan-type: image`. |

The Trivy scan is configured with:

- **`severity: HIGH,CRITICAL`:** Limits the findings that trigger the security gate to High and Critical vulnerabilities.
- **`exit-code: '1'`:** Makes Trivy return a non-zero exit code when matching vulnerabilities are found, causing the **Trivy step and container image job to fail**.

Because the frontend Dockerfile incorporates the intended Alpine package vulnerability remediation, we **expect the image to pass the scan**. However, this is an expectation, not a guarantee. The actual result depends on the vulnerabilities identified in the resulting image and Trivy's vulnerability database.

> **Important:** The **security gate remains strict**. We are not disabling Trivy, lowering the severity threshold, or changing the exit code to hide vulnerabilities. If a **HIGH or CRITICAL vulnerability** is detected, the job will **fail as intended**.

---

#### Why Do We Need Both Repository and Container Image Scans?

Our workflow performs two Trivy scans at different stages. They inspect different targets and serve complementary purposes:

| Scan | What It Examines | Purpose |
|---|---|---|
| **Repository scan (`scan-type: repo`)** | Supported repository files, particularly dependency manifests and lockfiles. | Identifies known dependency vulnerabilities and exposed secrets early in the workflow. |
| **Container image scan (`scan-type: image`)** | The actual built image, including operating-system packages and supported application components. | Identifies vulnerabilities in the final container artifact that we intend to publish and deploy. |

The key differences are:

- **Repository scan:** Helps identify security issues in supported dependency definitions before containerization. However, it does **not inspect packaged binaries such as JAR files or operating-system packages inside the image**.
- **Container image scan:** Validates the **actual built image**, including its base image packages and supported application artifacts. For example, our backend image scan can identify vulnerabilities in the packaged Java application that the repository scan may not detect.

> **Production Insight:** Repository and container image scans are **complementary security checks**. The repository scan helps identify issues early, while the image scan validates the actual artifact produced by the container build. **Passing the repository scan does not guarantee that the final container image is vulnerability-free.**

---

## Stage 9: Publish and Promote Container Images

- In Stage 7, we built our backend and frontend container images and scanned them for HIGH and CRITICAL vulnerabilities using Trivy. In this stage, we will publish both images to **Amazon Elastic Container Registry (ECR)**, which will serve as our container image registry.
- We will work with both backend and frontend workflows, but **take a deeper dive into the backend first**, explaining each configuration and step in detail. We will then apply the same approach to the frontend, highlighting only the necessary differences, such as job names, artifact names, and image repository references.
- Our objective is to publish the **exact images that passed our security scans without rebuilding them**. This follows our **build once, promote many** principle, which we will extend as we deploy the application to Dev and later promote the same images to Prod.
---

### Task 1: Prepare AWS

Before making any additions to our GitHub Actions workflow, let's prepare AWS. We will complete three activities:

1. **Create ECR repositories:** These will store our backend and frontend container images so that our deployment environment can pull them when required.
2. **Create an OIDC identity provider:** This establishes GitHub as a trusted identity provider for AWS, allowing GitHub Actions to request temporary AWS credentials without storing long-lived AWS access keys in GitHub.
3. **Create an IAM role and ECR permissions policy:** The role's trust policy determines which GitHub identities can assume it, while the permissions policy determines which AWS actions the assumed role can perform. We will restrict these permissions to publishing images to our two ECR repositories.

---

#### 1. Create ECR repositories

Amazon ECR is a managed container image registry that allows us to store and manage container images. We need separate repositories for our backend and frontend images so that each application component can be versioned and published independently.

Open the AWS Console, navigate to **Amazon ECR → Repositories → Create repository**, and create the backend repository with the following configuration:

- **Repository name:** `cwvj-mega-backend`
- **Visibility:** Private
- **Image tag mutability:** Immutable
- **Encryption:** AES-256 (default)

Keep the remaining settings at their defaults for this project and create the repository.

Next, create the **frontend** repository using the same settings, changing only the repository name to **`cwvj-mega-frontend`**.

We will publish images using our existing application-version and Git commit SHA tags, for example, `cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`. Later, we will capture the image digest from ECR and use it to identify the exact image deployed across environments.

> **Production Insight:** Prefer **immutable image tags** to prevent an existing tag from being overwritten. Our tags combine the application version with a Git commit SHA, so different commits normally produce different tags. However, the SHA-based naming convention alone does not make a tag immutable; ECR must enforce that protection.
>
> When we manually trigger the workflow, GitHub uses the commit at the tip of the **selected branch** (or the selected tag). Running the workflow again for the same commit generates the same image tag. With **tag immutability enabled in Amazon ECR**, a subsequent attempt to publish an image using that existing tag cannot overwrite it. Our workflow must therefore reuse the existing image or handle the existing-tag condition appropriately.
>
> **Tag immutability prevents tag overwrites, while the image digest identifies the exact image content** that we promote across DEV and PROD. Tags help us identify images; digests ensure we deploy the exact same image.

---

#### 2. Create an IAM OIDC Identity Provider for GitHub Actions

Before configuring GitHub Actions to access AWS, let's understand **IAM identities, federation, and why we are using OpenID Connect (OIDC)**.

- **IAM identities:** AWS provides two relevant IAM identity types:

  | Identity | Description |
  |---|---|
  | **IAM user** | An identity created within AWS IAM. It can have a console password, long-term access keys for programmatic access, or both. |
  | **IAM role** | An identity that can be assumed by authorized principals, including IAM users, AWS services, and federated identities. Roles do not have their own long-term passwords or access keys. When assumed, **Amazon STS issues temporary security credentials**. |

- **Federation:** Allows identities managed by an external identity provider (IdP) to access another system without creating separate identities in that system. Two commonly used federation standards are:
  - **SAML 2.0:** Commonly used for corporate workforce identity federation.
  - **OIDC:** Commonly used for applications and workloads, including GitHub Actions, to establish trust with cloud providers.

  These are common use cases, not exclusive rules. AWS supports both standards for appropriate federation scenarios.

- **Our approach:** We will configure **OIDC federation between GitHub Actions and AWS IAM**. Instead of storing long-lived AWS access keys in GitHub Secrets, we will allow GitHub Actions to request an OIDC token from GitHub and exchange it for **temporary AWS credentials** through Amazon STS.

- **Create the AWS IAM OIDC identity provider:** We need to register GitHub's OIDC issuer in our AWS account. This involves creating an **IAM OIDC identity provider resource** that tells AWS which external issuer to trust and which audience to accept.

  The configuration requires:

  | Setting | Value |
  |---|---|
  | Provider type | OpenID Connect |
  | Provider URL | `https://token.actions.githubusercontent.com` |
  | Audience | `sts.amazonaws.com` |
  >**Reference**: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws


  **Understanding what AWS calls an IAM OIDC identity provider:**

  GitHub is the **actual OIDC provider and token issuer**. It generates and signs the JWT requested by our GitHub Actions workflow.

  The **IAM OIDC identity provider** is an AWS-side trust configuration. It registers GitHub's issuer URL and audience so that Amazon STS can recognize and validate tokens issued by GitHub.

  > **Important:** AWS IAM does not generate or issue the GitHub OIDC token. Creating this provider resource only establishes the trust configuration; it does not, by itself, grant GitHub Actions access to AWS resources. We must also create an IAM role with a trust policy specifying which GitHub Actions identities can assume it.

- **Authentication and authorization flow:** Once the IAM OIDC provider and IAM role are configured, the process works as follows:

  1. **Request an OIDC token:** The GitHub Actions workflow uses the `id-token: write` permission to request a **JSON Web Token (JWT)** from GitHub's OIDC provider. This permission only allows the workflow to request an OIDC token; it does not grant access to AWS resources.

  2. **Obtain the token and request role assumption:** The `aws-actions/configure-aws-credentials` action obtains the GitHub-issued OIDC token and presents it to **Amazon STS**, requesting to assume the IAM role specified through `role-to-assume`.

  3. **Validate the token and trust relationship:** Amazon STS validates the token using the registered **IAM OIDC identity provider configuration**, including the issuer and audience. It then evaluates the IAM role's **trust policy**, including conditions such as the token's `aud` and `sub` claims. These conditions restrict which GitHub repositories, branches, or environments are permitted to assume the role.

  4. **Issue temporary credentials:** If the token and trust-policy conditions are valid, Amazon STS returns **temporary AWS security credentials**, consisting of an access key ID, secret access key, and session token.

  5. **Authorize AWS operations:** GitHub Actions uses these credentials to make AWS API calls. The IAM role's **permissions policies** determine which AWS actions and resources are allowed.

  > **Note:** The complete authentication and authorization flow can be summarized as:
  >
  > **GitHub Actions Workflow** (`id-token: write`) → **configure-aws-credentials** (requests OIDC token) → **GitHub OIDC Provider** (issues signed JWT) → **configure-aws-credentials** (presents JWT to Amazon STS using `role-to-assume`) → **Amazon STS** (validates token using the registered IAM OIDC provider and evaluates the IAM role's trust policy) → **Assumed IAM Role** (temporary AWS credentials) → **GitHub Actions Workflow** (uses temporary credentials) → **AWS Services** (access governed by IAM permissions policies).

- **Understanding the OIDC provider, issuer, and identity:**

  It is important to distinguish between the **external OIDC provider**, the **AWS IAM OIDC identity provider resource**, and the **OIDC identity provider configuration associated directly with an EKS cluster**.

  - **External OIDC provider / issuer:** The external system that generates and signs OIDC tokens. For example, GitHub, Amazon EKS, or Okta.
  - **IAM OIDC identity provider:** An AWS IAM resource that registers an external OIDC issuer and its accepted audiences. This allows AWS STS to trust and validate tokens issued by that provider when a user or workload requests to assume an IAM role.
  - **EKS OIDC identity provider configuration:** A configuration associated directly with an EKS cluster that allows its Kubernetes API server to authenticate users using tokens issued by an external OIDC provider, such as Okta.

  Neither the AWS IAM OIDC identity provider resource nor the EKS OIDC identity provider configuration issues tokens. The **external OIDC provider is the actual token issuer**.

  An OIDC token contains three important claims:

  - **`iss` (Issuer):** Identifies who issued the token.
  - **`sub` (Subject):** Identifies the entity represented by the token.
  - **`aud` (Audience):** Identifies the intended recipient of the token.

  Consider these four scenarios:

  | Scenario | Where the OIDC provider is configured | External OIDC Provider / Issuer (`iss`) | Subject (`sub`), Whose Identity? | Audience (`aud`), Intended Recipient |
  |---|---|---|---|---|
  | **Kubernetes Pod accessing AWS (IRSA)** | AWS IAM → Identity Providers | Amazon EKS cluster's OIDC issuer | Kubernetes ServiceAccount associated with the Pod | AWS STS (`sts.amazonaws.com`) |
  | **GitHub Actions accessing AWS** | AWS IAM → Identity Providers | GitHub (`https://token.actions.githubusercontent.com`) | GitHub Actions workflow identity, including repository and applicable branch or environment context | AWS STS (`sts.amazonaws.com`) |
  | **Okta user accessing AWS** | AWS IAM → Identity Providers | Okta's OIDC issuer | Okta-authenticated user represented by the token | Audience/client ID registered with the IAM OIDC provider and checked by the IAM role's trust policy |
  | **Okta user accessing Kubernetes (EKS)** | EKS → Access → OIDC identity providers | Okta's OIDC issuer | Okta-authenticated user. EKS maps a configured token claim, such as `sub` or `email`, to the Kubernetes username and can also map a groups claim. | Client ID configured when associating the OIDC provider with EKS |

  Notice that the **issuer identifies who generated the token, not whose identity the token represents**. The `sub` claim identifies the subject, while `aud` identifies the intended recipient.

  **Understanding the difference between AWS IAM and EKS OIDC configurations:**

  For **IRSA, GitHub Actions federation, and Okta-to-AWS federation**, AWS IAM has an IAM OIDC identity provider resource registered for the respective external issuer:

  - For IRSA, it registers the **EKS cluster's OIDC issuer**.
  - For GitHub Actions, it registers **GitHub's OIDC issuer**.
  - For Okta-to-AWS federation, it registers **Okta's OIDC issuer**.

  In these scenarios, **AWS STS validates the external OIDC token and evaluates the IAM role's trust policy**. If the conditions are satisfied, STS issues temporary AWS credentials. The IAM role's permissions policies determine which AWS resources the identity can access.

  The EKS OIDC identity provider configuration shown under **EKS → Access → OIDC identity providers** serves a different purpose. Here, we associate an external provider such as Okta directly with the EKS cluster. The Kubernetes API server validates the token, maps the configured username and groups claims, and **Kubernetes RBAC determines what the user can do inside the cluster**.

  Unlike AWS IAM federation, this direct EKS OIDC authentication does not issue AWS credentials or grant the user permissions to access AWS services through an IAM role.

  > **Important – Our Project:** We are not using the direct Okta-to-EKS OIDC authentication approach. Instead, we use **GitHub OIDC → AWS STS → IAM Role → EKS Access Entry → Kubernetes RBAC**. First, GitHub Actions assumes an IAM role to access AWS. We then associate that IAM role with our EKS cluster through an Access Entry, map it to a Kubernetes group, and use Kubernetes RBAC to grant the required permissions.

  > **Important – GitHub Subject Claims:** GitHub's `sub` claim format can vary depending on the workflow context and whether immutable subject claims are enabled. Repositories created after **15 July 2026**, or those that have opted into immutable subject claims, use a format that includes immutable organization and repository IDs. Repository renames or transfers after this date also move to the immutable format. Ensure that the IAM role's trust-policy conditions match the actual `sub` claim emitted by your repository.

---

#### Configure the identity provider

In the AWS Console, navigate to **IAM → Access Management → Identity providers → Add provider** and configure:

- **Provider type:** OpenID Connect
- **Provider URL:** `https://token.actions.githubusercontent.com`
- **Audience:** `sts.amazonaws.com`

Reference: [GitHub documentation: Configuring OIDC with AWS](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws).

This step **registers GitHub as a trusted identity provider** in AWS IAM. It does not automatically grant GitHub Actions permission to access ECR, EKS, or any other AWS resource.

We still need to create an **IAM role** that trusts this identity provider and configure its trust policy to allow only the intended GitHub Actions identities.

When we configure the role in our GitHub Actions workflow using `role-to-assume`, we are specifying which IAM role the workflow should request access to. Amazon STS then evaluates the role's trust policy before issuing temporary credentials.

> **Important:** The OIDC provider establishes the federation relationship, but **the role's trust policy determines which external identities are allowed to assume it**. The role's permissions policies determine what those identities can do in AWS after successfully assuming it.

---

#### Why Do You See an EKS OIDC Provider in IAM?

You may notice another OIDC provider with a URL similar to `oidc.eks.ap-south-1.amazonaws.com/...`. This is separate from the GitHub provider. It was created earlier when we configured our EKS cluster with `withOIDC: true` in `eks-config.yaml`.

The two providers serve different purposes:

- **EKS OIDC:** Establishes trust for EKS workloads to obtain AWS permissions through mechanisms such as IAM Roles for Service Accounts (IRSA).
- **GitHub OIDC:** Establishes trust for GitHub Actions workflows to assume IAM roles without storing long-lived AWS access keys.

The common patterns are:

`EKS Pods → EKS OIDC → IAM Role → AWS Services`

`GitHub Actions → GitHub OIDC → IAM Role → AWS Services`

> **Important:** Both providers establish **federated trust**, but they serve different identity sources. The EKS provider is used by workloads running inside our cluster, whereas the GitHub provider is used by GitHub Actions workflows running on GitHub-hosted or self-hosted runners.

In our project, we will use GitHub OIDC to allow our workflows to assume appropriately configured IAM roles. We will configure each role's **trust policy** to restrict which GitHub Actions identities can assume it and its **permissions policies** to limit access to the AWS resources and operations required by that workflow, such as **publishing images to our ECR repositories** or **deploying applications to EKS**.

---

#### 3. Create the IAM Role and ECR Permissions Policy

We have created the GitHub OIDC provider. Next, we need an IAM role and a permissions policy to control access to our ECR repositories.

- **IAM Role + Trust Policy:** Defines which identities can assume the role.
- **IAM Permissions Policy:** Defines which AWS actions the role can perform after it is assumed.

Let's create the permissions policy first, then create the role and associate the policy with it.

---

##### 3.1 Create the IAM Permissions Policy

Navigate to **IAM → Policies → Create policy → JSON** and use the following configuration.

**Policy name:** `CWVJGitHubActionsECRPushPolicy`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ECRAuthentication",
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    },
    {
      "Sid": "PushApplicationImages",
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:BatchGetImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": [
        "arn:aws:ecr:ap-south-1:497613475050:repository/cwvj-mega-backend",
        "arn:aws:ecr:ap-south-1:497613475050:repository/cwvj-mega-frontend"
      ]
    }
  ]
}
```

Review the policy and create it.

**Why are we using this policy?**

- **`ecr:GetAuthorizationToken`:** Allows the IAM role to request an ECR authorization token. The AWS CLI retrieves this token using `aws ecr get-login-password` and passes it to `docker login`, allowing Docker to authenticate with our private ECR registry. **This action does not support repository-level resource scoping**, so `"Resource": "*"` is required. Actual image push and pull permissions are controlled separately through repository-scoped IAM permissions.
- The remaining actions allow the workflow to upload image layers and publish images, scoped to our **backend and frontend repositories**.
- This follows the principle of **least privilege**, avoiding broad ECR access or administrator permissions.

---

##### 3.2 Create the IAM Role

Navigate to **IAM → Roles → Create role → Custom trust policy**.

**Role name:** `CWVJGitHubActionsECRPushRole`

Use the following trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::497613475050:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": [
            "repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280:ref:refs/heads/feature/*",
            "repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280:ref:refs/heads/bugfix/*",
            "repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280:ref:refs/heads/hotfix/*"
          ]
        }
      }
    }
  ]
}
```

**How to find the Default subject claim prefix:** Go to your **GitHub repository** → **Settings → Actions → OIDC**. You will find a value similar to the following:

`repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280`

Use this value as the base for the `sub` condition in your IAM role's trust policy, followed by the appropriate branch reference, such as `:ref:refs/heads/feature/*`.

**Why are we restricting the trust policy this way?**

Our GitHub Actions workflows run on the `feature/*`, `bugfix/*` and `hotfix/*` branch patterns in the `mega-project-demo` repository. We want to ensure that **only eligible workflow jobs from this specific repository and these approved branches can assume our IAM role**.

---

**How does a workflow job get permission to assume the role?**

Our GitHub Actions job will include the following **job-level permissions block**:

```yaml
permissions:
  id-token: write
```

- **`id-token: write`:** Grants the job permission to request an OIDC token from GitHub. It does not grant access to AWS resources by itself.
- **Runner:** Provides the execution environment for the job. It is not the identity AWS trusts.
- **Workflow job:** Runs on the runner and uses `aws-actions/configure-aws-credentials` to obtain the GitHub-issued OIDC token and request role assumption through AWS STS.

> **Note:** We will explore GitHub Actions permissions, the `id-token: write` setting, and its role in OIDC authentication in more detail as we progress through the workflow configuration.

---

**What does AWS validate?**

- **OIDC provider:** Identifies GitHub as the trusted external token issuer.
- **`aud` condition:** Requires the token's audience to be `sts.amazonaws.com`, indicating that it is intended for AWS STS.
- **`sub` condition:** Restricts role assumption to our specific repository and approved branch patterns.

Notice that the subject uses the repository's **immutable owner and repository IDs**, rather than relying only on repository names. We verified this format when troubleshooting the OIDC authentication failure earlier.

---

##### 3.3 Associate the Permissions Policy with the Role

After creating the role, open `CWVJGitHubActionsECRPushRole`, navigate to its permissions section, and attach the policy we created in Step 3.1: `CWVJGitHubActionsECRPushPolicy`.

The role now has both parts of the access model:

- **Trust policy:** Determines which GitHub identities can assume the role.
- **Permissions policy:** Allows the assumed role to authenticate with ECR and push images to our two specified repositories.

> **Important Point:** We are using temporary AWS credentials through GitHub OIDC instead of storing long-lived AWS access keys in GitHub. The trust policy controls who can assume the role, while the permissions policy limits what the role can do.

---

### Task 2: Make Changes to the Existing `backend-image-build-scan-job`

We need to make two related changes to the existing `backend-image-build-scan-job`:

1. **Expose the generated image tag as a Job Output** so the publishing job can retrieve it.
2. **Save and upload the scanned container image** as a GitHub Actions artifact so a later job can publish the same image to Amazon ECR without rebuilding it.

**Expose the image tag as a Job Output**

Add the following `outputs` block inside `backend-image-build-scan-job`, at the same indentation level as `name`, `runs-on`, `needs`, and `steps`. **Do not place it inside `steps:`.**

```yaml
outputs:
  image-tag: ${{ steps.image-tag.outputs.image_tag }}
```

This exposes the `image_tag` output generated by the existing `Generate image tag` step as a **Job Output** named `image-tag`. The publishing job retrieves it using:

`${{ needs.backend-image-build-scan-job.outputs.image-tag }}`

**Save and upload the scanned image**

Add the following steps to the existing `backend-image-build-scan-job`, **immediately after the Trivy image scan step**. We are showing only the additions, not repeating the existing workflow.

```yaml
# Save the exact image that passed the security scan as a Docker archive.
- name: Save backend container image
  env:
    IMAGE_TAG: ${{ steps.image-tag.outputs.image_tag }}
  run: |
    docker save \
      -o cwvj-mega-backend.tar \
      "cwvj-mega-backend:${IMAGE_TAG}"

# Upload the exact scanned image so a later job can use the same image.
- name: Upload backend container image
  uses: actions/upload-artifact@v7
  with:
    name: backend-container-image
    path: cwvj-mega-backend.tar
    if-no-files-found: error
```

These steps run **only after the Trivy scan succeeds**. Because the scan is configured to fail when HIGH or CRITICAL vulnerabilities are detected, the image is saved and uploaded only after passing the security gate.

---

#### Explanation

The first step saves the container image that passed the Trivy scan as a Docker archive.

```yaml
# Save the exact image that passed the security scan as a Docker archive.
- name: Save backend container image
  env:
    IMAGE_TAG: ${{ steps.image-tag.outputs.image_tag }}
  run: |
    docker save \
      -o cwvj-mega-backend.tar \
      "cwvj-mega-backend:${IMAGE_TAG}"
```

- **`env`:** Defines an environment variable named `IMAGE_TAG` and assigns it the output generated by the earlier `image-tag` step. We use this intermediate environment variable instead of directly interpolating the GitHub expression inside the shell script, following GitHub's recommended approach for handling potentially untrusted values.
- **`docker save`:** Exports a Docker image, including its layers and image metadata, into an archive that can later be loaded back into Docker.
- **`-o cwvj-mega-backend.tar`:** Specifies the output archive file, created in the runner's current working directory.
- **`"cwvj-mega-backend:${IMAGE_TAG}"`:** Identifies the exact image to save. The shell expands `IMAGE_TAG` at runtime, reusing the tag generated by the earlier `image-tag` step rather than generating a new tag. Quoting ensures the expanded value is treated as a single argument.
- **`|`:** YAML's literal block scalar indicator, which allows the `run` field to contain a multiline shell script.
- **Trailing `\`:** A shell line-continuation character that allows the Docker command to span multiple lines.

For example, if the generated tag is `0.0.1-SNAPSHOT-8048730`, Docker saves the image `cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`.

At this point, the archive exists only in the current runner's workspace. **It has not yet been transferred to another job.** The next step uploads the archive as a GitHub Actions artifact so the publishing job can retrieve the same scanned image.

---

The second step uploads the Docker archive as a GitHub Actions artifact so another job can download it.

```yaml
# Upload the exact scanned image so a later job can use the same image.
- name: Upload backend container image
  uses: actions/upload-artifact@v7
  with:
    name: backend-container-image
    path: cwvj-mega-backend.tar
    if-no-files-found: error
```

- **`actions/upload-artifact@v7`** uploads a file produced during the workflow run so another job can access it, even when that job runs on a different runner.
- **`name: backend-container-image`** assigns the artifact its name. The next job uses this name to download it.
- **`path: cwvj-mega-backend.tar`** specifies the Docker archive created by the preceding `docker save` command.
- **`if-no-files-found: error`** fails the step if the archive is missing, preventing the workflow from silently continuing without the image required by the next job.

> **Note:** Notice that we are using a **full relative directory path** when uploading the backend JAR, but only the **filename** when uploading the Docker archive. This is because Maven generates the JAR inside the backend project's `target` directory, whereas `docker save` creates the TAR archive in the runner's **current working directory (`GITHUB_WORKSPACE`)** because we haven't specified another output directory.

**Important:** `cwvj-mega-backend.tar` is the **filename**, while `backend-container-image` is the **GitHub Actions artifact name**.

The next job can download the artifact using the same name:

```yaml
- name: Download backend container image
  uses: actions/download-artifact@v8
  with:
    name: backend-container-image
    path: .
```

- **`name: backend-container-image`** identifies the artifact uploaded by the previous job.
- **`path: .`** downloads the archive into the current working directory.

The next job can then restore the Docker image:

```bash
docker load -i cwvj-mega-backend.tar
```

This loads the image from the archive into the local Docker image store. The workflow can then tag it for Amazon ECR and push it **without rebuilding the image**.

> **Production Insight:** Files created in one GitHub Actions job are not automatically available to another job. Use **Job Outputs for small pieces of metadata**, such as image tags, and **Artifacts for files**, such as Docker archives and build packages.

The overall flow is:

**Build Image → Scan Image → Save Docker Archive → Upload Artifact → Download Artifact → Load Image → Push to Amazon ECR**

This prepares us for the next task, where we will create a separate job to authenticate with AWS using OIDC and publish the **same container image that passed the Trivy scan** to Amazon ECR.

---

### Task 3: Create `backend-ecr-push-job`

In the previous task, we saved the backend container image that passed the Trivy security scan and uploaded it as a GitHub Actions artifact. We will now create a separate job to download that artifact, authenticate with AWS, and publish the image to Amazon ECR.

This job performs five main activities:

1. **Download and restore the scanned image** from the artifact created by `backend-image-build-scan-job`.
2. **Configure AWS credentials using GitHub OIDC**, allowing the workflow to assume the IAM role created earlier without storing long-lived AWS access keys.
3. **Authenticate Docker with Amazon ECR**, so Docker can push images to our private registry.
4. **Tag the image for the ECR repository**, preserving the application version and commit SHA generated earlier.
5. **Push the image to Amazon ECR**, making it available for subsequent deployment stages.

---

#### Configure GitHub Repository Variables

Before running this job, ensure that the following **repository variables** are configured under **GitHub Repository → Settings → Secrets and variables → Actions → Variables**.

| Variable | Example value |
|---|---|
| `AWS_REGION` | `ap-south-1` |
| `AWS_ACCOUNT_ID` | `497613475050` |
| `AWS_ROLE_ARN` | `arn:aws:iam::497613475050:role/CWVJGitHubActionsECRPushRole` |

> **Note:** Replace the example values with your **actual AWS region, account ID, and IAM role ARN**.

These are **repository variables, not secrets**. They contain configuration values rather than long-lived credentials. AWS authentication is handled securely through **OIDC and the IAM role**.

---

Add the following job to the workflow, at the same level as the existing `backend-job` and `backend-image-build-scan-job`. Do not place it inside another job's `steps:` block.

```yaml
backend-ecr-push-job:
  name: Push Backend Image to Amazon ECR
  runs-on: ubuntu-26.04
  needs: backend-image-build-scan-job
  if: github.event_name == 'push'

  permissions:
    id-token: write

  steps:
    - name: Download backend container image
      uses: actions/download-artifact@v8
      with:
        name: backend-container-image
        path: .

    # Load the exact Docker image produced and scanned by the previous job.
    - name: Load backend container image
      run: docker load -i cwvj-mega-backend.tar

    # Verify that the expected image and tag are available.
    - name: Verify backend container image
      env:
        IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
      run: docker image inspect "cwvj-mega-backend:${IMAGE_TAG}"

    # Authenticate to AWS using GitHub OIDC and the IAM role created earlier.
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v6
      with:
        role-to-assume: ${{ vars.AWS_ROLE_ARN }}
        aws-region: ${{ vars.AWS_REGION }}

    # Authenticate Docker with the Amazon ECR registry.
    - name: Login to Amazon ECR
      run: |
        aws ecr get-login-password \
          --region "${{ vars.AWS_REGION }}" \
          | docker login \
              --username AWS \
              --password-stdin \
              "${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

    # Tag the local image with its ECR repository name while preserving the existing image tag.
    - name: Tag backend image for Amazon ECR
      env:
        IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
      run: |
        ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

        docker tag \
          "cwvj-mega-backend:${IMAGE_TAG}" \
          "${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}"

    # Push the exact image that was built and scanned earlier.
    - name: Push backend image to Amazon ECR
      env:
        IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
      run: |
        ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

        docker push \
          "${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}"
```



---

#### Explanation


```yaml
backend-ecr-push-job:
  name: Push Backend Image to Amazon ECR
  runs-on: ubuntu-26.04
  needs: backend-image-build-scan-job
  if: github.event_name == 'push'
```

- **`backend-ecr-push-job`** is the unique job ID used to reference this job in workflow expressions.
- **`name`** defines the human-readable name displayed in the GitHub Actions interface.
- **`runs-on: ubuntu-26.04`** provisions a **fresh GitHub-hosted runner**, separate from the runner used by `backend-image-build-scan-job`.
- **`needs: backend-image-build-scan-job`** ensures this job runs only after the image-build-and-scan job succeeds. If that job fails or is skipped, the publishing job is also skipped by default.
- **`if: github.event_name == 'push'`** restricts this job to workflow runs triggered by a **push event**. This includes commits pushed from a **local Git repository** as well as commits made directly through the **GitHub UI**. The job is skipped for other events, including `pull_request` and `workflow_dispatch`.

We do not need to list `backend-job` in `needs` because `backend-image-build-scan-job` already depends on it. GitHub Actions respects the existing dependency chain, ensuring that the publishing job runs only after all upstream dependencies have completed successfully.

---

Before the job can authenticate with AWS using GitHub OIDC, it needs permission to **request an OIDC token**.

```yaml
permissions:
  id-token: write
```

- **`permissions`:** Defines the permissions available to the job, including those granted to `GITHUB_TOKEN` and the ability to request an OIDC token. When permissions are explicitly specified, any permission not listed is set to `none`.
- **`id-token: write`:** Allows the job to request a **GitHub OIDC token**. The `Configure AWS credentials` step presents this token to Amazon STS to assume the IAM role `CWVJGitHubActionsECRPushRole` and obtain temporary AWS credentials.

> **Important:** `id-token: write` only allows GitHub Actions to **request an OIDC token**. It does **not** grant permission to access or modify AWS resources. AWS access depends on the IAM role's **trust policy** (who can assume it) and **permissions policies** (what the assumed role can do).

---

**Why Configure Permissions at the Job Level?**

GitHub supports two approaches:

- **Workflow-level permissions:** Establish permissions for the workflow, which apply to its jobs unless overridden at the job level.
- **Job-level permissions (our approach):** Specify permissions only for the job that requires them.

We use **job-level permissions** to follow the **principle of least privilege**, ensuring each job receives only the permissions it needs.

Since `backend-ecr-push-job` does not check out the repository or require repository content access, it only needs `id-token: write`. There is no need to grant `contents: read`.

---

```yaml
- name: Download backend container image
  uses: actions/download-artifact@v8
  with:
    name: backend-container-image
    path: .
```

- **`actions/download-artifact@v8`** downloads an artifact uploaded earlier in the workflow.
- **`name: backend-container-image`** identifies the artifact. It must match the name used in the previous job's `actions/upload-artifact` step.
- **`path: .`** specifies the destination directory for the downloaded artifact. The dot (`.`) represents the current working directory, which resolves to the job's workspace (`${{ github.workspace }}` or `$GITHUB_WORKSPACE`) by default. Therefore, the Docker archive is extracted directly into the job's workspace.

Each job normally runs on a **separate runner with its own workspace**. Uploading an artifact in one job does not automatically make it available in another, so we use this step to transfer the Docker archive.

**Remember the distinction:**
- **Artifact name:** `backend-container-image`, used by GitHub Actions to locate the artifact.
- **File inside the artifact:** `cwvj-mega-backend.tar`, used by the subsequent Docker command.

The next step loads this archive into Docker so the image can be tagged for Amazon ECR and pushed **without rebuilding it**.

---

```yaml
# Load the exact Docker image built and scanned by the previous job.
- name: Load backend container image
  run: docker load -i cwvj-mega-backend.tar
```

- **`name`** identifies the step in the GitHub Actions workflow logs.
- **`docker load`** imports a Docker image archive into the runner's local Docker image store.
- **`--input` (`-i`)** specifies the archive created by the previous job's `docker save` command.

After loading, the image is available locally with its **original repository name and tag**, for example:

`cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

We can now tag and push this image to Amazon ECR **without rebuilding it**.

**Image transfer flow:**

**Scanned Image → `docker save` → GitHub Actions Artifact → `docker load` → Local Docker Image**

> **Production Insight:** This follows the **build once, scan, and promote the same artifact** approach. We publish the already-built and scanned image, avoiding separate builds for different environments and ensuring that the image we deploy is the same image that was scanned.

---

```yaml
# Verify that the expected image and tag are available.
- name: Verify backend container image
  env:
    IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
  run: docker images cwvj-mega-backend:${IMAGE_TAG}
```

- **`docker images`** lists Docker images available in the runner's local image store.
- **`cwvj-mega-backend:${IMAGE_TAG}`** specifies the exact repository and tag we want to display, using the tag generated in the previous job.

If the image exists, Docker displays its **repository, tag, image ID, creation time, and size**.

> **Important:** Providing both the repository and tag filters the output to the **specific image reference** we are looking for. However, `docker images` is a listing command, not a strict assertion. If the image or tag does not exist, it displays no matching result but **does not return a non-zero exit status**.

This provides a convenient way to verify visually in the GitHub Actions logs that the **expected image was restored from the downloaded artifact** before proceeding with AWS authentication and publishing it to Amazon ECR.

---

```yaml
# Authenticate to AWS using GitHub OIDC and the IAM role created earlier.
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v6
  with:
    role-to-assume: ${{ vars.AWS_ROLE_ARN }}
    aws-region: ${{ vars.AWS_REGION }}
```

- **`aws-actions/configure-aws-credentials@v6`** uses GitHub OIDC to request temporary AWS credentials by assuming the specified IAM role.
- **`role-to-assume`** specifies the IAM role GitHub Actions should assume. `${{ vars.AWS_ROLE_ARN }}` reads the `AWS_ROLE_ARN` repository variable configured under **Settings → Secrets and variables → Actions → Variables**. In our setup, its value is `arn:aws:iam::497613475050:role/CWVJGitHubActionsECRPushRole`.
- **`aws-region`** specifies the AWS region in which the workflow will operate. `${{ vars.AWS_REGION }}` reads the `AWS_REGION` repository variable, set to `ap-south-1` (Mumbai).
- Once the step succeeds, the action makes the temporary credentials available to subsequent steps, allowing the AWS CLI to interact with AWS services according to the IAM role's permissions.

> **Important:** This step configures AWS credentials; it does **not** log Docker into Amazon ECR. In the next step, we will use these credentials to obtain an ECR authentication token and log Docker into the registry.

> **Production Insight:** OIDC avoids storing **long-lived AWS access keys** in GitHub. However, keep the IAM role's trust policy restricted to the intended repository and branches, and grant only the AWS permissions required by the workflow.

---

In the previous step, we configured AWS credentials using GitHub OIDC. However, **AWS authentication and Docker registry authentication are two separate steps**. The AWS CLI can now call AWS APIs, but Docker must also authenticate with Amazon ECR before pushing our container image.

Add the following step to `backend-ecr-push-job`:

```yaml
# Authenticate Docker with the Amazon ECR registry.
- name: Login to Amazon ECR
  run: |
    aws ecr get-login-password \
      --region "${{ vars.AWS_REGION }}" \
      | docker login \
          --username AWS \
          --password-stdin \
          "${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"
```

The command has **two parts connected by a pipe (`|`)**.

- **`aws ecr get-login-password`** retrieves an authentication password for Amazon ECR. The AWS CLI uses the temporary credentials configured in the previous step.
- **`--region "${{ vars.AWS_REGION }}"`** specifies the AWS region. Our `AWS_REGION` repository variable resolves to `ap-south-1` (Mumbai).
- **`docker login`** authenticates Docker with the specified container registry.
- **`--username AWS`** specifies the username required by Amazon ECR's Docker authentication mechanism.
- **`--password-stdin`** tells Docker to read the password from standard input instead of passing it directly as a command-line argument.
- **`${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com`** constructs the ECR registry endpoint using our AWS account ID and region.

In our setup, the resulting registry endpoint is:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com`

**How does the pipe (`|`) work?**

The pipe sends the output of the first command directly to the input of the second:

**`aws ecr get-login-password` → `docker login --password-stdin`**

This passes the authentication password directly to Docker without saving it to a separate file or hardcoding it in the workflow.

> **Important:** Configuring AWS credentials does **not automatically authenticate Docker with ECR**. The AWS credentials action establishes the workflow's AWS identity, while `docker login` authenticates Docker to the registry.

The IAM role must also have the required ECR permissions:
- **`ecr:GetAuthorizationToken`** allows the workflow to obtain the authentication token. This action requires `"Resource": "*"`.
- The remaining ECR permissions allow the workflow to upload image layers and publish images to our **backend and frontend repositories**.

---

```yaml
# Tag the local image with its ECR repository name while preserving the existing image tag.
- name: Tag backend image for Amazon ECR
  env:
    IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
  run: |
    ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

    docker tag \
      "cwvj-mega-backend:${IMAGE_TAG}" \
      "${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}"
```

Before pushing the local image to ECR, we must **tag it with the destination registry and repository name**.

- **`IMAGE_TAG`** retrieves the `image-tag` Job Output from `backend-image-build-scan-job` using the `needs` context. This value originates from the `image-tag` step in the upstream job and is reused here rather than generated again.
- **`ECR_REGISTRY`** constructs the ECR registry endpoint using the `AWS_ACCOUNT_ID` and `AWS_REGION` repository variables. In our setup, the resulting endpoint is `497613475050.dkr.ecr.ap-south-1.amazonaws.com`.
- **`docker tag`** adds a new name to the existing local image. It does **not rebuild the image or modify its filesystem**.
- **Source image:** `cwvj-mega-backend:${IMAGE_TAG}` identifies the image restored from the Docker archive.
- **Destination image:** `${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}` adds the ECR registry endpoint and repository name while preserving the same tag.

For example, if `IMAGE_TAG` is `0.0.1-SNAPSHOT-8048730`, the destination reference becomes:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com/cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

> **Important:** We reuse the tag generated by the upstream job so the image published to ECR retains the same application version and commit SHA as the image that was built and scanned.

The application version identifies the release, while the short commit SHA identifies the source revision used to build the image.

**A Docker tag is a reference, not a guarantee of image content.** We will address the distinction between tags and immutable image digests when implementing image promotion.

---

### Push the Backend Image to Amazon ECR

```yaml
# Push the exact image built and scanned by the previous job.
- name: Push backend image to Amazon ECR
  env:
    IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
  run: |
    ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

    docker push \
      "${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}"
```

- **`IMAGE_TAG`** retrieves the **Job Output** from `backend-image-build-scan-job`. This passes the tag generated during the original build to the publishing job, ensuring we use the same tag rather than generating it again.
- **`ECR_REGISTRY`** constructs the ECR registry endpoint using our AWS account ID and region.
- **`docker push`** uploads the image layers (when required) and publishes the image manifest to the specified ECR repository.
- **Image reference:** Identifies the destination registry, repository, and image tag.

For example, Docker pushes:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com/cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

> **How do we ensure it is the same image?** The previous job uses `docker save` to package the built and scanned image into an artifact. This job downloads that artifact and uses `docker load` to restore the image, including its original tag. The **artifact carries the actual image**, while the **Job Output carries the tag generated during the build**. Together, they ensure that we push the previously built and scanned image using its original tag, without rebuilding it.

**For this operation to succeed:**
- Docker must be authenticated to the correct ECR registry.
- The IAM role must have the required ECR upload permissions for `cwvj-mega-backend`.
- The repository must exist in the specified AWS account and region.

We configured the repository and IAM permissions during the earlier Stage 8 setup.

> **Important – Immutable Image Tags:** Both ECR repositories use **Image Tag Mutability: Immutable**. An existing tag cannot be overwritten with a different image.
>
> Since our tags combine the application version and short Git commit SHA, different commits will normally produce different tags. However, rerunning the workflow for the same commit generates the same tag. If that tag already exists in ECR, the push will fail rather than overwrite the existing image.
>
> For safe retries, we can check whether the tag already exists and verify that its **image digest matches the expected image** before treating the operation as successful. We should not simply ignore the error or weaken tag immutability.

> **Production Insight:** Immutable tags help prevent accidental image replacement, but the **image digest is the stronger identifier of exact image content**. In our deployment and promotion stages, we capture the ECR image digest and use it to deploy the same image across environments.

---

### Task 4: Update the Frontend Workflow to Publish Images to Amazon ECR

We have completed the backend workflow, including building, scanning, and publishing the container image to Amazon ECR. Now, we will apply the **same approach to the frontend**.

The overall process remains the same. The main differences are the **job names, artifact names, ECR repository, and application version source**. The frontend uses the validated build (`dist`) and obtains its application version from `package.json`, rather than using the backend JAR and Maven's `pom.xml`.

We need to make two changes:

---

#### 1. Update the Existing `frontend-image-build-scan-job`

We need to make two changes to the existing job:

1. **Expose the generated image tag as a Job Output** so `frontend-ecr-push-job` can access it.
2. **Save and upload the scanned container image** so the publishing job can download and push the same image without rebuilding it.

**Expose the image tag as a Job Output**

Add the following `outputs` block inside `frontend-image-build-scan-job`, at the same indentation level as `name`, `runs-on`, `needs`, and `steps`. **Do not place it inside `steps:`.**

```yaml
outputs:
  image-tag: ${{ steps.image-tag.outputs.image_tag }}
```

This exposes the `image_tag` output generated by the existing `Generate image tag` step as a **Job Output** named `image-tag`. The publishing job can then retrieve it using:

`${{ needs.frontend-image-build-scan-job.outputs.image-tag }}`

**Save and upload the scanned image**

Add the following steps **immediately after the Trivy image scan step**, so the image is saved and uploaded only after the scan succeeds.

```yaml
# Save the exact image that passed the security scan as a Docker archive.
- name: Save frontend container image
  env:
    IMAGE_TAG: ${{ steps.image-tag.outputs.image_tag }}
  run: |
    docker save \
      -o cwvj-mega-frontend.tar \
      "cwvj-mega-frontend:${IMAGE_TAG}"

# Upload the exact scanned image so a later job can use the same image.
- name: Upload frontend container image
  uses: actions/upload-artifact@v7
  with:
    name: frontend-container-image
    path: cwvj-mega-frontend.tar
    if-no-files-found: error
```

These additions allow `frontend-ecr-push-job` to retrieve **both the image tag (Job Output) and the scanned image (GitHub Actions artifact)** for publishing to Amazon ECR.

---

#### 2. Create `frontend-ecr-push-job`

Add the following new job at the same level as `frontend-job` and `frontend-image-build-scan-job`.

```yaml
  frontend-ecr-push-job:
    name: Push Frontend Image to Amazon ECR
    runs-on: ubuntu-26.04
    needs: frontend-image-build-scan-job
    if: github.event_name == 'push'

    permissions:
      id-token: write

    steps:
      - name: Download frontend container image
        uses: actions/download-artifact@v8
        with:
          name: frontend-container-image
          path: .

      # Load the exact Docker image produced and scanned by the previous job.
      - name: Load frontend container image
        run: docker load -i cwvj-mega-frontend.tar

      # Verify that the expected image and tag are available.
      - name: Verify frontend container image
        run: docker images cwvj-mega-frontend

      # Authenticate to AWS using GitHub OIDC and the IAM role created earlier.
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_ROLE_ARN }}
          aws-region: ${{ vars.AWS_REGION }}

      # Authenticate Docker with the Amazon ECR registry.
      - name: Login to Amazon ECR
        run: |
          aws ecr get-login-password \
            --region "${{ vars.AWS_REGION }}" \
            | docker login \
                --username AWS \
                --password-stdin \
                "${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

      # Tag the local image for the frontend ECR repository.
      - name: Tag frontend image for Amazon ECR
        env:
          IMAGE_TAG: ${{ needs.frontend-image-build-scan-job.outputs.image-tag }}
        run: |
          ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

          docker tag \
            "cwvj-mega-frontend:${IMAGE_TAG}" \
            "${ECR_REGISTRY}/cwvj-mega-frontend:${IMAGE_TAG}"

      # Push the exact image that was built and scanned earlier.
      - name: Push frontend image to Amazon ECR
        env:
          IMAGE_TAG: ${{ needs.frontend-image-build-scan-job.outputs.image-tag }}
        run: |
          ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

          docker push \
            "${ECR_REGISTRY}/cwvj-mega-frontend:${IMAGE_TAG}"
```

Both jobs reuse the repository variables configured earlier: `AWS_ROLE_ARN`, `AWS_REGION`, and `AWS_ACCOUNT_ID`. No additional AWS credentials or IAM role are required, provided the existing role's trust policy permits the frontend workflow to assume it and its permissions policy allows pushing to `cwvj-mega-frontend`.

After these changes, the frontend workflow follows the same pattern as the backend:

**Build and Validate Frontend → Build and Scan Image → Save and Upload Artifact → Download and Load Image → Authenticate to AWS → Push to ECR**

---

### Task 4: Push Changes and Verify Both Images in Amazon ECR

We have updated the workflow to build, scan, and publish both the backend and frontend container images to Amazon ECR. We will now push the changes, verify the complete workflow, and confirm that both images are available in ECR.

#### 1. Push the Changes to GitHub

Ensure you are working on the correct feature branch, then commit and push the changes:

```bash
# Check the current branch.
git branch --show-current

# Review the modified files.
git status

# Stage the intended changes.
git add .

# Commit the changes.
git commit -m "ci(backend-frontend): publish container images to Amazon ECR"

# Push the changes to GitHub.
git push origin feature/initial-ci
```

- **Verify the branch:** It should be `feature/initial-ci`.
- **Review `git status`:** Ensure you are committing only the intended changes. Remember, `git add .` stages all changes under the current directory.
- **Push:** Our workflow triggers on pushes to `feature/**` branches.

If Git reports that there is nothing to commit, check whether the changes have already been committed.

---

#### 2. Observe the GitHub Actions Workflow

Open your GitHub repository, navigate to **Actions**, and inspect the workflow run triggered by the push.

Verify the following job sequences:

- **Backend:** `backend-job` → `backend-image-build-scan-job` → `backend-ecr-push-job`
- **Frontend:** `frontend-job` → `frontend-image-build-scan-job` → `frontend-ecr-push-job`

For each application, verify that:

- The application build, tests, and SonarQube analysis complete successfully.
- The container image builds and passes the **Trivy security scan**.
- The scanned image is saved as a Docker archive and uploaded as a GitHub Actions artifact.
- The publishing job downloads and restores that image, authenticates to AWS using **OIDC**, logs Docker into ECR, and pushes the image to the correct repository.

> **Important:** Each publishing job depends on its corresponding image-build-and-scan job. If a Trivy scan fails, the publishing job is skipped by default.

---

#### 3. Verify Both Images in Amazon ECR

Once the workflow succeeds, navigate to **Amazon ECR → Private registry → Repositories** in the AWS Console and open both repositories.

| Verification | Backend | Frontend |
|---|---|---|
| Repository | `cwvj-mega-backend` | `cwvj-mega-frontend` |
| Image tag | Application version + short commit SHA | Application version + short commit SHA |
| Image digest | Verify the published digest | Verify the published digest |
| Push timestamp | Check the latest image | Check the latest image |

For example, the backend tag might be `0.0.1-SNAPSHOT-8048730`, while the frontend tag might be `0.1.0-8048730`. These are examples only. Verify the actual tags generated by your workflow run.

> **Note:** Alongside the tagged **Image Index**, you may see two additional entries in ECR:
> - **Image Manifest:** Represents the actual container image, including its configuration and references to image layers required to run the application.
> - **Provenance Attestation:** Contains build metadata generated by Docker Buildx, providing information about how the image was built and supporting software supply-chain traceability.
>
> These are expected when Buildx generates provenance attestations by default. They are not duplicate application images or additional releases.

You can also inspect both repositories using the AWS CLI, provided your local AWS CLI has suitable permissions.

**Backend:**

```bash
aws ecr describe-images \
  --repository-name cwvj-mega-backend \
  --region ap-south-1 \
  --query 'imageDetails[*].[imageTags,imageDigest,imagePushedAt]' \
  --output table
```

**Frontend:**

```bash
aws ecr describe-images \
  --repository-name cwvj-mega-frontend \
  --region ap-south-1 \
  --query 'imageDetails[*].[imageTags,imageDigest,imagePushedAt]' \
  --output table
```

These commands display the image tags, digests, and push timestamps for the respective repositories.

> **Important:** Both repositories use **immutable image tags**. If you rerun the workflow for a commit whose image tag already exists, the push may fail because ECR will not allow that tag to be overwritten. This is expected behavior and protects existing image references from being replaced.

---

#### 4. Verify Security and Artifact Handling

A green workflow status is useful, but we should also verify that the intended security and artifact-handling controls work correctly.

- **OIDC authentication:** Both publishing jobs assume the configured IAM role without storing long-lived AWS access keys in GitHub.
- **IAM permissions:** The role's trust policy restricts which identities can assume it, while its permissions policy allows the required ECR operations on both repositories.
- **Artifact transfer:** `backend-container-image` and `frontend-container-image` are uploaded and downloaded using matching artifact names.
- **Image identity:** Each publishing job reuses the image tag generated by its upstream job. It does not rebuild the image or generate a replacement tag.
- **Security scans:** Each Trivy scan succeeds before its image is saved, uploaded, and published.
- **ECR publication:** Both images appear in their correct repositories with their expected tags and digests.

These checks validate the complete process, from **application build and validation to image scanning, artifact transfer, and registry publication**.

---

#### 5. Troubleshoot Workflow Failures

If a step fails, open the failed job in GitHub Actions and inspect its logs.

| Failure | What to check |
|---|---|
| **AWS credential configuration** | GitHub OIDC provider, IAM role trust policy, `AWS_ROLE_ARN`, and repository or branch restrictions. |
| **ECR login** | `AWS_REGION`, `AWS_ACCOUNT_ID`, and the role's `ecr:GetAuthorizationToken` permission. |
| **Backend image push** | `cwvj-mega-backend` repository, upload permissions, generated tag, and whether the immutable tag already exists. |
| **Frontend image push** | `cwvj-mega-frontend` repository, upload permissions, generated tag, and whether the immutable tag already exists. |
| **Artifact download or image loading** | Matching artifact names, successful artifact uploads, and the expected archive filenames: `cwvj-mega-backend.tar` or `cwvj-mega-frontend.tar`. |
| **Trivy scan** | Review the findings and resolve the relevant vulnerabilities before publishing. |

> **Important:** Do not weaken IAM permissions or disable tag immutability simply to make a failed run succeed. Identify the actual cause and apply the appropriate fix.

**Expected outcome:** Both publishing workflows complete successfully, and the backend and frontend container images that passed their respective Trivy scans are available in their corresponding Amazon ECR repositories with their generated version-and-commit tags.

---

# **Phase 3: AWS & EKS Foundation**

- Prepare the **AWS infrastructure** required to host the application, including Amazon EKS, RDS, networking, and supporting services.
- Establish secure GitHub Actions access to EKS using **OIDC, dedicated IAM roles, EKS access entries, and Kubernetes RBAC**.

---

## Stage 10: Allow GitHub Actions to Deploy onto Our EKS Cluster

In this stage, we configure **AWS IAM, EKS access, and Kubernetes RBAC** so that GitHub Actions can deploy our application to Amazon EKS.

We will use **GitHub OIDC** for AWS authentication, separate **DEV and PROD IAM roles**, EKS access entries to map each role to its corresponding Kubernetes group, and **Kubernetes RBAC** to control which resources each deployment workflow can manage.

> **Note:** This stage establishes the foundation for deploying to EKS directly from GitHub Actions. Later in the course, we will introduce **GitOps using Argo CD**, explore how it changes the deployment workflow, and understand the role of GitHub Actions in a GitOps-based delivery model.

---

### Task 1: Create the IAM Policy and Deployment Roles

GitHub Actions needs **AWS identity and permissions** before it can interact with our EKS cluster during deployment. We will create two dedicated IAM roles, one for DEV and one for PROD, and attach the required IAM policy to each role.

- **IAM roles:** `CWVJGitHubActionsEKSDeployDevRole` and `CWVJGitHubActionsEKSDeployProdRole` provide separate AWS identities for the DEV and PROD deployment workflows through **GitHub OIDC**, without requiring long-lived AWS access keys.
- **IAM policy:** Defines which AWS API actions each role can perform. In this task, it grants access to EKS cluster metadata and ECR image metadata.
- **EKS access and Kubernetes RBAC:** Control how each authenticated role accesses the Kubernetes API and which Kubernetes resources it can manage. We configure these separately in the following tasks, keeping DEV and PROD access appropriately scoped.

---

#### 1.1 Create the IAM Policy

**Why do we need this policy?**

The deployment workflows need to identify the target EKS cluster and resolve the container images published by our CI workflow. The policy contains **two statements**, each serving a specific purpose:

- **Statement 1, `DescribeEKSCluster`:** Grants `eks:DescribeCluster` on our specific EKS cluster. The deployment workflow uses this permission to retrieve the cluster details required to configure its Kubernetes connection.
- **Statement 2, `ReadPublishedECRImageMetadata`:** Grants `ecr:DescribeImages` on our backend and frontend ECR repositories. The deployment workflow uses this permission to look up published image tags and their corresponding digests before deployment.

Since both DEV and PROD use the **same EKS cluster and ECR repositories**, we can create **one shared IAM policy** and attach it to both deployment roles.

Create an IAM policy named **`CWVJGitHubActionsEKSDeployPolicy`** with the following JSON:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DescribeEKSCluster",
      "Effect": "Allow",
      "Action": "eks:DescribeCluster",
      "Resource": "arn:aws:eks:ap-south-1:497613475050:cluster/cwvj-mega-demo-eks"
    },
    {
      "Sid": "ReadPublishedECRImageMetadata",
      "Effect": "Allow",
      "Action": "ecr:DescribeImages",
      "Resource": [
        "arn:aws:ecr:ap-south-1:497613475050:repository/cwvj-mega-backend",
        "arn:aws:ecr:ap-south-1:497613475050:repository/cwvj-mega-frontend"
      ]
    }
  ]
}
```

**Understand the policy configuration:**

- **`Version`:** Specifies the IAM policy language version.
- **`Sid`:** Provides a readable identifier for each statement.
- **`Effect: Allow`:** Allows the specified action, subject to other applicable authorization controls.
- **`Action`:** Defines the AWS API operation being permitted.
- **`Resource`:** Restricts each permission to the specified EKS cluster or ECR repositories rather than granting access to all resources.

> **Production Insight:** Keep permissions scoped to the specific cluster and repositories the deployment workflows need. This follows the **principle of least privilege** and limits the impact of a compromised workflow or role.

> **Important:** This policy grants permission to retrieve **AWS resource and image metadata**. It does not grant permission to create or modify Kubernetes resources. Access to the Kubernetes API is established through **EKS access entries** and constrained using **Kubernetes RBAC** in the subsequent tasks. We will configure separate access entries and RBAC permissions for the DEV and PROD deployment roles.

---

#### 1.2 Create the IAM Roles and Trust Policies

**Why do we need a trust policy?**

The IAM policy created in the previous step defines **what a role can do in AWS**. The trust policy defines **who can assume that role**.

- **Trust policy:** Allows GitHub Actions to authenticate with AWS using **OpenID Connect (OIDC)** without storing long-lived AWS access keys in GitHub Secrets.
- **OIDC provider:** Establishes the trust relationship between AWS IAM and GitHub's OIDC identity provider.
- **Trust conditions:** Restrict role assumption to the intended GitHub repository and deployment environment.

We will create two dedicated IAM roles so that DEV and PROD deployments use **separate AWS identities and trust policies**:

- **DEV role:** `CWVJGitHubActionsEKSDeployDevRole`
- **PROD role:** `CWVJGitHubActionsEKSDeployProdRole`

Both roles will use the shared **`CWVJGitHubActionsEKSDeployPolicy`** created in the previous step. However, each role's trust policy will permit assumption only through its corresponding GitHub Environment.

##### Create the DEV role

Create an IAM role named **`CWVJGitHubActionsEKSDeployDevRole`** and configure its trust policy as follows:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::497613475050:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280:environment:dev"
        }
      }
    }
  ]
}
```

##### Create the PROD role

Create another IAM role named **`CWVJGitHubActionsEKSDeployProdRole`** and configure its trust policy as follows:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::497613475050:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280:environment:prod"
        }
      }
    }
  ]
}
```

**Before creating the roles, replace the repository-specific OIDC values with your own.**

- Open your GitHub repository and navigate to **Settings → Actions → OIDC** to inspect your OIDC configuration and subject details.
- Replace `CloudWithVarJosh`, `146525273`, and `mega-project-demo@1386577280` with the corresponding owner name, owner ID, repository name, and repository ID for your repository.
- Replace AWS account ID `497613475050` in each `Federated` ARN with your own AWS account ID. Ensure the corresponding GitHub OIDC identity provider exists in IAM.
- Keep the audience value as `sts.amazonaws.com` when using the standard Amazon STS audience.
- Use the exact subject format shown by your repository's OIDC configuration. The examples use GitHub's immutable subject format, which includes the owner and repository IDs.

> **Important:** Both examples use **environment-based OIDC subjects** because our deployment jobs declare `environment: dev` or `environment: prod`. Consequently, each role trusts its corresponding environment rather than a list of branch-based subjects.

**Understand the two trust conditions:**

- **Audience (`aud`):** `sts.amazonaws.com` identifies Amazon STS as the intended audience of the OIDC token.
- **Subject (`sub`):** Restricts which GitHub repository and environment identity can assume the role. The DEV role permits the `dev` environment subject, while the PROD role permits the `prod` environment subject.

> **Production Insight:** An environment-based trust policy does not, by itself, restrict which branches can deploy. Configure **GitHub Environment protection rules and deployment branch restrictions** for `dev` and `prod`. This allows the DEV environment to accept the intended feature, bugfix, and hotfix branches while applying stricter controls to production deployments.

Finally, attach **`CWVJGitHubActionsEKSDeployPolicy`** to both IAM roles. The roles now share the required AWS-level permissions while maintaining **separate trust relationships** for DEV and PROD.


---

#### 1.3 Associate the Policy with Both Roles

- Attach **`CWVJGitHubActionsEKSDeployPolicy`** to both **`CWVJGitHubActionsEKSDeployDevRole`** and **`CWVJGitHubActionsEKSDeployProdRole`**. Each role can then use the AWS permissions defined in the shared policy when assumed by its respective GitHub Actions workflow.

> **Production Insight:** Keep the **trust policy** and **permissions policy** separate. The trust policy defines *who can assume the role*, while the permissions policy defines *what the role can do in AWS*.

- Keep both deployment roles separate from **`CWVJGitHubActionsECRPushRole`**, which publishes container images to ECR in Stage 8. The deployment roles only need to read published image metadata, not push images. This maintains **separation of responsibilities** and the **principle of least privilege**.

---

### Task 2: Configure EKS Access Using Access Entries

**Why do we need to configure EKS access?**

In Task 1, we created separate IAM roles for DEV and PROD and attached the shared IAM permissions policy. However, **AWS permissions alone do not establish which Kubernetes resources each role can access**.

We must configure how EKS recognizes each IAM role and maps it to a Kubernetes identity.

- **EKS access entry:** Maps an IAM role to a Kubernetes identity.
- **Kubernetes group:** Provides an identity to which we can assign permissions through Kubernetes RBAC.
- **Kubernetes RBAC:** Defines which resources and operations each group can access within the `dev` and `prod` namespaces.

We will create separate EKS access entries for our deployment roles and map them to distinct Kubernetes groups:

- **DEV role:** `CWVJGitHubActionsEKSDeployDevRole` → `cwvj-github-actions-deployer-dev`
- **PROD role:** `CWVJGitHubActionsEKSDeployProdRole` → `cwvj-github-actions-deployer-prod`

This separation allows us to assign DEV permissions exclusively to the DEV group and PROD permissions exclusively to the PROD group. We will configure those permissions separately using `deployer-rbac.yaml`.

---

#### 2.1 Understand EKS Access Entries vs. `aws-auth`

Amazon EKS supports two mechanisms for mapping IAM identities to Kubernetes identities:

- **`aws-auth` ConfigMap:** The legacy mechanism, where IAM roles and users are mapped to Kubernetes usernames or groups through a Kubernetes ConfigMap.
- **EKS access entries:** The AWS-managed mechanism, where IAM identities are registered through the EKS API, AWS CLI, or console. An access entry can map an IAM role to a Kubernetes group or be associated with an AWS-managed EKS access policy.

**Why are we using EKS access entries?**

- They provide an AWS-managed way to configure cluster access without maintaining IAM identity mappings in `aws-auth`.
- They allow us to map each deployment role to its own Kubernetes group.
- They let us define deployment permissions explicitly through **Kubernetes RBAC**, rather than associating an AWS-managed EKS access policy with each role.

> **Production Insight:** Prefer EKS access entries for new implementations. Existing clusters using `aws-auth` can continue using it, and migration can be handled separately. In `API_AND_CONFIG_MAP` mode, if the same IAM role has mappings in both mechanisms, the **access-entry mapping takes precedence**. See the [AWS documentation on access-entry migration](https://docs.aws.amazon.com/eks/latest/userguide/migrating-access-entries.html).

---

#### 2.2 Check the EKS Authentication Mode

Before creating access entries, we must verify that our cluster supports this mechanism. The **authentication mode** determines which methods EKS can use to map IAM identities to Kubernetes identities.

1. Open the [Amazon EKS Console](https://console.aws.amazon.com/eks/home?region=ap-south-1#/clusters).
2. Select `cwvj-mega-demo-eks`.
3. Open the **Access** tab and check the authentication mode.

Our cluster uses **`API_AND_CONFIG_MAP`**, which supports both EKS access entries and the `aws-auth` ConfigMap. We can therefore create access entries without changing the existing cluster configuration.

> **Important:** The supported methods depend on the authentication mode:
> - **`API`:** Uses EKS access entries.
> - **`API_AND_CONFIG_MAP`:** Supports both methods.
>
> Changing the authentication mode is a cluster-level change. Once the EKS access-entry API is enabled, you cannot switch back to a mode that disables it. Since our cluster already supports access entries, **no authentication-mode change is required**.

---

#### 2.3 Create the DEV and PROD Access Entries

Now that we have confirmed the authentication mode, we can map each deployment IAM role to its corresponding Kubernetes group.

We will create **two separate access entries** so that DEV and PROD use different Kubernetes identities.

1. In the cluster's **Access** tab, open **Access entries** and click **Create access entry**.
2. Create the DEV access entry with these values:

   - **IAM principal ARN:** `arn:aws:iam::497613475050:role/CWVJGitHubActionsEKSDeployDevRole`
   - **Type:** `Standard`
   - **Kubernetes groups:** `cwvj-github-actions-deployer-dev`

3. Repeat the process to create the PROD access entry:

   - **IAM principal ARN:** `arn:aws:iam::497613475050:role/CWVJGitHubActionsEKSDeployProdRole`
   - **Type:** `Standard`
   - **Kubernetes groups:** `cwvj-github-actions-deployer-prod`

4. Replace AWS account ID `497613475050` with your own account ID if you are using a different AWS account.
5. Leave other optional settings at their defaults unless your environment requires otherwise, then create both access entries.

**Understand the configuration:**

- **IAM principal ARN:** Identifies the environment-specific IAM role that GitHub Actions will assume.
- **Type `Standard`:** Appropriate for our deployment roles, which are not worker-node identities.
- **Kubernetes groups:** Map each IAM role to its corresponding group, allowing Kubernetes RBAC resources to grant that group permissions.

We use **separate Kubernetes groups** so that the DEV role can be granted permissions in the `dev` namespace and the PROD role can be granted permissions in the `prod` namespace. We will configure these permissions through our own Kubernetes `Role` and `RoleBinding` resources in `deployer-rbac.yaml`.

> **Important:** Creating an access entry maps an IAM role to a Kubernetes group, but **does not grant Kubernetes permissions by itself**. The group names must match exactly in the corresponding RBAC configuration.

At the end of this task, EKS will have separate access entries for `CWVJGitHubActionsEKSDeployDevRole` and `CWVJGitHubActionsEKSDeployProdRole`. We have established the identity mappings, but we still need to configure and validate their Kubernetes permissions before using them for deployments.

---

### Task 3: Prepare the Kubernetes DEV and PROD Environments

Before deploying the application, we need to create the **DEV and PROD namespaces** and configure namespace-scoped RBAC for both deployment roles.

---

#### Configure Namespaces and RBAC

Run the following commands from the `project-files` directory using an appropriately privileged Kubernetes identity.

```bash
# 1. Create the DEV and PROD namespaces.
kubectl create namespace dev
kubectl create namespace prod

# 2. Apply RBAC for both environments.
kubectl apply -f kubernetes/deployer-rbac.yaml

# 3. Verify the namespaces and RBAC resources.
kubectl get namespaces dev prod
kubectl get clusterroles cwvj-github-actions-deployer-cluster-role
kubectl get rolebindings -n dev
kubectl get rolebindings -n prod
```

The `kubernetes/deployer-rbac.yaml` file defines a **ClusterRole** containing the permissions required by our GitHub Actions deployment workflows, along with separate **RoleBindings** for `dev` and `prod`.

Kubernetes supports both **Roles** and **ClusterRoles** for defining permissions. A Role is namespace-scoped, whereas a ClusterRole can define a reusable set of permissions that can be bound at either namespace or cluster scope. We use a **single ClusterRole with two RoleBindings** because both environments require the same permissions. This avoids duplicating the RBAC rules while keeping DEV and PROD access isolated.

> **Important:** Although a ClusterRole defines reusable permissions, referencing it through a **RoleBinding** restricts those permissions to the namespace in which the RoleBinding exists. We deliberately use separate RoleBindings so the DEV deployment identity can manage resources in `dev`, while the PROD deployment identity can manage resources in `prod`.

Apply this RBAC configuration manually using an appropriately privileged identity. The application manifests under `kubernetes/dev/` and `kubernetes/prod/` will be applied by their respective GitHub Actions deployment workflows.

---

#### Validate RBAC Permissions

Use `kubectl auth can-i` to verify that each deployment group has the intended permissions within its own namespace and cannot deploy across environments.

```bash
# 1. Verify that the DEV deployment group can create deployments in DEV.
kubectl auth can-i create deployments \
  --as=github-actions-deployer-dev-test \
  --as-group=cwvj-github-actions-deployer-dev -n dev

# 2. Verify that the PROD deployment group can create deployments in PROD.
kubectl auth can-i create deployments \
  --as=github-actions-deployer-prod-test \
  --as-group=cwvj-github-actions-deployer-prod -n prod

# 3. Verify that the DEV deployment group cannot create deployments in PROD.
kubectl auth can-i create deployments \
  --as=github-actions-deployer-dev-test \
  --as-group=cwvj-github-actions-deployer-dev -n prod

# 4. Verify that the PROD deployment group cannot create deployments in DEV.
kubectl auth can-i create deployments \
  --as=github-actions-deployer-prod-test \
  --as-group=cwvj-github-actions-deployer-prod -n dev
```

**Expected results:**

- **Checks 1 and 2** return `yes`, confirming that each deployment group can create deployments in its designated namespace.
- **Checks 3 and 4** return `no`, confirming that neither deployment group can deploy into the other environment.

> **Important:** We use `--as` and `--as-group` to **simulate the respective deployment identities**. The Kubernetes identity executing these commands must have permission to **impersonate** the specified users and groups.

> **Note:** Our **ClusterRole deliberately does not grant permissions to create or modify Kubernetes Secrets**. This keeps database credentials outside the deployment role's permissions. We are keeping the validation focused on **namespace isolation** rather than testing every individual RBAC rule.

> **Production Insight:** Kubernetes RBAC permissions are **additive**. A RoleBinding restricts the permissions it grants to its namespace, but another binding could grant the same identity additional access. Always consider an identity's **effective permissions**, not just one RoleBinding.

> **Important – Cluster Creator Administrator Access:** Amazon EKS automatically grants **Kubernetes cluster-admin permissions** to the IAM principal (user or role) that creates the cluster. This is enabled by default through `bootstrapClusterCreatorAdminPermissions`. In our case, I created the cluster using my IAM user, `varun.joshi`, so this identity has administrator access to the Kubernetes cluster. This is an **EKS bootstrap behavior**, not an IAM `AdministratorAccess` permission.
>
> You can identify the AWS principal currently being used by running `Amazon STS get-caller-identity`. The current Kubernetes context and its configured user entry can be viewed using `kubectl config get-contexts`. In the AWS Console, you can inspect the creator's access under **EKS → Clusters → <your-cluster> → Access → Access entries**, provided the cluster uses an authentication mode that supports access entries.

---

# **Phase 4: Continuous Delivery & Release Management**

- Prepare DEV and PROD environments and implement **automated deployment and Pull Request workflows**, promoting the same **immutable container images** across environments.
- Establish **human-controlled code reviews and production approvals**, bootstrap the completed workflows, and validate the **end-to-end developer-to-production release process**.

---

## Stage 11: Prepare DEV Environment and Configure Deployment Automation

In this stage, we will prepare the **DEV database and Kubernetes environment** and build the GitHub Actions workflow responsible for deploying the application to DEV. The workflow will be configured to run after successful CI for eligible development branches, reuse the container images already published to **Amazon ECR**, and deploy them to Amazon EKS using **immutable image digests**, without rebuilding the application or its container images.

**We will not push or execute this workflow at this stage.** We are first building the automation logic across Stages 11, 12, and 13. Once the DEV deployment, automated PR creation, and PROD deployment workflows are all configured, we will push the changes and demonstrate the complete end-to-end process.

The intended release flow will be: a successful DEV deployment triggers automated PR creation targeting `main`. After human review, approval, and merging, the PROD deployment workflow takes over and deploys the same application images to production.

> **Production Insight:** Separating CI from deployment allows us to **build, test, scan, and publish an application image once, then deploy that same artifact** into different environments. By using immutable image digests, we preserve artifact identity and establish the foundation for promoting the same tested application from DEV to PROD.

---

### Task 1: Prepare the DEV Database in Amazon RDS

Before deploying our backend application to Amazon EKS, we need to prepare its database in **Amazon RDS for PostgreSQL**. The backend will use this database to **store user records persistently**, while **Flyway** will manage the database schema through the application's migration scripts.

We will use the following database configuration:

| Component | Value |
|---|---|
| **RDS instance** | `cwvj-mega-postgres` |
| **Database** | `cwvj_dev_db` |
| **Application user** | `cwvj_dev_app_user` |
| **PostgreSQL port** | `5432` |

We will connect to RDS using the **master account** to perform the initial database setup, then create a **dedicated application user** and configure the required **database and schema privileges**. The application will use this dedicated user rather than the **RDS master credentials**, following the principle of least privilege.

Connect to the RDS instance from your **EC2 instance** and execute the following commands in sequence:

- The initial `psql` command runs in the **EC2 terminal** and establishes a connection to RDS.
- All subsequent commands run inside the **`psql` prompt** to create the database user and database, configure privileges, and verify the setup.

```sql
# 1. Connect to the RDS PostgreSQL instance.
# Replace the hostname, port, and username according to your RDS configuration.
# This example uses postgres as the master username.
psql \
  --host=cwvj-mega-postgres.c7m8gq4y4w13.ap-south-1.rds.amazonaws.com \
  --port=5432 \
  --username=postgres \
  --dbname=postgres \
  --password

# The following commands run inside the psql prompt.

# 2. Verify the current PostgreSQL user.
SELECT current_user;

# 3. Create the DEV application user.
CREATE ROLE cwvj_dev_app_user LOGIN;

# 4. Set the application user's password securely.
# Enter and confirm the password when prompted.
\password cwvj_dev_app_user

# 5. Temporarily grant the master user membership in the application role.
# Replace postgres with the username returned by SELECT current_user, if different.
GRANT cwvj_dev_app_user TO postgres;

# 6. Create the DEV database and assign ownership to the application user.
CREATE DATABASE cwvj_dev_db OWNER cwvj_dev_app_user;

# 7. Remove the temporary role membership granted in Step 5.
REVOKE cwvj_dev_app_user FROM postgres;

# 8. Connect to the newly created DEV database.
\connect cwvj_dev_db

# 9. Grant the privileges required for Flyway schema migrations.
GRANT USAGE, CREATE ON SCHEMA public TO cwvj_dev_app_user;

# 10. Verify the database connection and database ownership.
\conninfo
\l cwvj_dev_db

# 11. Verify that the application role exists and can log in.
\du cwvj_dev_app_user

# 12. Exit PostgreSQL.
\q
```

> **Important:** Replace the **RDS hostname, port, and master username** with the values configured in your environment. If your master username differs from `postgres`, update the username in the `GRANT` and `REVOKE` commands as well. Set the **application password interactively** and **never commit it to Git**.

**Expected outcome:** The DEV database `cwvj_dev_db` is created and owned by `cwvj_dev_app_user`. The application user has a **configured password** and the **required schema privileges for Flyway migrations**. We can now proceed to configure **connectivity between RDS and our EKS environment**.

---

### Task 2: Configure RDS Connectivity from EKS

Our backend running on EKS needs to connect to PostgreSQL on RDS. We will update the **RDS security group's inbound rules** to allow traffic on port `5432` from the EKS node security group.

1. Navigate to **EC2 → Security Groups** and select `cwvj-rds-sg`.
2. Under **Inbound rules**, click **Edit inbound rules → Add rule** and configure:

   | Setting | Value |
   |---|---|
   | Type | PostgreSQL |
   | Port | `5432` |
   | Source | EKS node security group |

3. Select `eks-cluster-sg-cwvj-mega-demo-eks-1221592647` as the source and save the rule.

> **Note:** Your EKS security group name may differ, particularly the numeric suffix. Identify the correct security group associated with your cluster before configuring the rule.

> **Production Insight:** Use **security-group references** instead of broad CIDR ranges to restrict database access to the intended infrastructure. Never expose PostgreSQL to `0.0.0.0/0`.

> **Production Insight – Security Groups for Pods:** Our demo EKS cluster currently hosts only this application, and our node group is used for its workloads. Therefore, using the **EKS node security group** to allow connectivity to RDS is a reasonable and straightforward approach for this project.
>
> In a production environment, however, an EKS cluster can host **dozens or even hundreds of applications**, depending on the architecture and scale. Multiple applications may share the same node group to optimize compute utilization, while applications with specific resource requirements, operational boundaries, or isolation needs may be scheduled onto dedicated node groups. Critical or sensitive workloads, for example, may have their own dedicated node groups.
>
> This distinction is important because, by default, Pods use the security groups associated with the worker node's network interface. Consequently, when the RDS inbound rule references the **EKS node security group**, other Pods using that security group may also have network-level connectivity to RDS, not just our backend Pods.
>
> Amazon EKS also supports **Security Groups for Pods**, which allow us to associate dedicated security groups with selected Pods rather than relying entirely on the security groups attached to worker nodes. We could use this feature to associate a dedicated security group with our backend Pods and reference that security group in the RDS inbound rule. This provides **finer-grained network isolation**, ensuring that only the intended workloads have network-level access to the database, even when multiple applications share the same node group.
>
> In our current approach, network connectivity to RDS does not automatically grant database access. Our PostgreSQL databases are **password-protected**, and the database credentials are supplied to the **backend workload** through its Kubernetes Secret. This provides an additional layer of **database-level authentication and access control**, even though we don't have Pod-level network isolation.
>
> **Note:** Kubernetes Secrets must also be protected through appropriate RBAC and workload-creation restrictions. A principal with permission to create Pods in a namespace can potentially create a Pod that references Secrets in that namespace.
>
> For this project, we've deliberately chosen the **node security group approach** to keep the infrastructure setup straightforward and maintain our primary focus on GitHub Actions. It remains a reasonable approach when workloads sharing the node security group are within the same intended network trust boundary. **Security Groups for Pods** would be a further enhancement worth exploring for production environments where finer-grained network isolation is required.

---

### Task 3: Create Database Secrets for DEV and PROD

Before deploying the application, we need to create the **Kubernetes Secrets** containing the database credentials required by the DEV and PROD environments.

---

#### Create the DEV and PROD Database Secrets

The `project-files` root contains `dev-backend-db-secret.yaml` and `prod-backend-db-secret.yaml`. Open each file and replace `PASSWORD-HERE` with the password configured for its respective RDS application user.

```bash
# Apply the DEV and PROD database Secrets.
kubectl apply -f dev-backend-db-secret.yaml
kubectl apply -f prod-backend-db-secret.yaml

# Verify that both Secrets exist.
kubectl get secret backend-db-secret -n dev
kubectl get secret backend-db-secret -n prod
```

> **Important:** Use the **correct database password** for each environment. We will commit these YAML files with the `PASSWORD-HERE` placeholders, not actual database credentials. After applying the Secrets, restore the placeholders in both files and verify that no actual credentials are included in the changes being committed. **Never commit actual database credentials to Git.**

> **Production Insight – External Secrets Management:** In production environments, organizations typically use dedicated secrets management solutions such as **AWS Secrets Manager** or **HashiCorp Vault** to securely store, manage, and rotate sensitive credentials. These solutions can be integrated with Kubernetes so that applications retrieve their secrets without hardcoding credentials in manifests or application configurations. For example, Amazon EKS supports the **AWS Secrets and Configuration Provider (ASCP)** with the Secrets Store CSI Driver to retrieve secrets from AWS Secrets Manager and mount them directly into Pods.

> **For this project:** We are using native Kubernetes Secrets and applying them through YAML manifests to keep the demonstration straightforward and focused on GitHub Actions. This is a simplified implementation, not a recommendation to store production credentials in source-controlled manifests.

---

**Can we create Kubernetes Secrets without putting passwords in YAML manifests?**

Yes. Kubernetes provides a simpler alternative through **`kubectl create secret generic`** with the **`--from-literal`** option. We can combine this with an interactive password prompt (`read -s`) to enter the password without displaying it on the terminal or storing it in a manifest file.

For example:

```bash
read -r -s -p "Enter DEV database password: " DB_PASSWORD
printf '\n'

kubectl create secret generic backend-db-secret \
  --namespace=dev \
  --from-literal=password="$DB_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

unset DB_PASSWORD
```

The same approach can be used for PROD by changing the namespace and supplying its respective database password.

> **Security Note:** `--from-literal` passes the password as a command-line argument to `kubectl`, so it may be visible to other sufficiently privileged local processes. For production implementations, prefer **AWS Secrets Manager**, **HashiCorp Vault**, or another dedicated secrets management solution.

Reference: [Kubernetes documentation: Managing Secrets using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/).

---

### Task 4: Understand the Kubernetes DEV Manifests

Before applying our Kubernetes manifests, let's understand what we're deploying and how the different resources fit together. We'll walk through the **backend.yaml** and **rds.yaml** files, explaining their important sections step by step. The objective isn't to teach Kubernetes YAML end to end, but to give you a good understanding of our application deployment architecture.

Our Kubernetes directory has the following structure:

```text
kubernetes/
├── dev/
│   ├── backend.yaml
│   ├── frontend.yaml
│   └── rds.yaml
├── prod/
│   ├── backend.yaml
│   ├── frontend.yaml
│   └── rds.yaml
└── deployer-rbac.yaml
```
---

#### 1. Backend Deployment – `backend.yaml`

Our backend manifest defines two Kubernetes resources: a **Deployment** and a **Service**. Let's understand the Deployment first.

---

**API Version, Resource Type and Metadata**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cwvj-backend
  namespace: dev
  labels:
    app.kubernetes.io/name: cwvj-mega-project
    app.kubernetes.io/instance: cwvj-mega-project-dev
    app.kubernetes.io/component: backend
    app.kubernetes.io/part-of: cwvj-mega-project
    app.kubernetes.io/managed-by: github-actions
  annotations:
    description: "Spring Boot backend API"
```

- **`apiVersion: apps/v1`** specifies the Kubernetes API version used to create this resource.
- **`kind: Deployment`** tells Kubernetes that we're creating a Deployment resource.
- **`metadata.name` and `namespace`** identify the Deployment. We're creating `cwvj-backend` in the `dev` namespace.
- **`labels`** attach key-value metadata to the resource. We use these labels to identify the application, its environment, and its component. They also help us organize and select Kubernetes resources.
- **`annotations`** attach additional descriptive metadata to the resource. Unlike labels, annotations are not used for selecting resources.

> **Note:** You might have noticed that our labels use the `app.kubernetes.io/` prefix, for example, `app.kubernetes.io/name`. This is a **recommended Kubernetes naming convention for application-related labels and annotations**. It provides a consistent namespace for application metadata so that Kubernetes tools and other automation can interpret these labels consistently.
>
> Other prefixes you may encounter include:
>
> - **`kubernetes.io/`** and **`k8s.io/`**: Reserved for Kubernetes core components. For example, `kubernetes.io/arch` identifies a node's architecture, while `kubernetes.io/os` identifies its operating system.
> - **`topology.kubernetes.io/`**: Used for topology-related labels, such as `topology.kubernetes.io/zone`, which we also use in our Deployment to distribute Pods across availability zones.
> - **Organization-specific prefixes:** You can use your own DNS domain as a prefix for custom labels, for example, `example.com/team`. This helps avoid naming conflicts with Kubernetes and other tools.
>
> **Important:** The `kubernetes.io/` and `k8s.io/` namespaces are reserved. Do not use them for custom labels. You can also omit the prefix for labels that are private to your own use.
>
> Refer to the official Kubernetes documentation:
> - [Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)
> - [Well-Known Labels, Annotations and Taints](https://kubernetes.io/docs/reference/labels-annotations-taints/)
> - [Labels and Selectors – Syntax and Character Set](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)

---

**Deployment Specification and Pod Template**

```yaml
spec:
  replicas: 2
  selector:
    matchLabels:
      app.kubernetes.io/name: cwvj-mega-project
      app.kubernetes.io/instance: cwvj-mega-project-dev
      app.kubernetes.io/component: backend
  template:
    metadata:
      labels:
        app.kubernetes.io/name: cwvj-mega-project
        app.kubernetes.io/instance: cwvj-mega-project-dev
        app.kubernetes.io/component: backend
        app.kubernetes.io/part-of: cwvj-mega-project
      annotations:
        description: "Spring Boot backend API"
```

- **`replicas: 2`** instructs Kubernetes to maintain two backend Pod replicas. If a Pod fails, the Deployment Controller attempts to create another Pod to maintain the desired replica count.
- **`selector.matchLabels`** defines how the Deployment identifies the Pods it manages. These labels must match the corresponding labels defined under `template.metadata.labels`.
- **`template`** defines the Pod specification that Kubernetes uses when creating backend Pods.
- **`template.metadata.labels`** attaches labels to the Pods themselves. Notice that the labels used by the Deployment selector are also present here. We additionally use `app.kubernetes.io/part-of` to identify the larger application to which this component belongs.

---

**Pod-Level Security Context**

```yaml
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 10001
    runAsGroup: 10001
    seccompProfile:
      type: RuntimeDefault
```

- **`securityContext`** defines security settings at the Pod level, which apply to its containers unless overridden at the container level.
- **`runAsNonRoot: true`** ensures that containers do not run as the root user. `runAsUser: 10001` and `runAsGroup: 10001` specify the Linux user ID and primary group ID.
- **`seccompProfile: RuntimeDefault`** applies the default seccomp (Secure Computing Mode) profile provided by the container runtime.
  - **What is seccomp?** Seccomp is a Linux kernel security feature that filters the **system calls (syscalls)** a process can make to the kernel. System calls allow applications to request operations from the underlying operating system.
  - **How is it different from Linux capabilities?** Both restrict what a process can do, but at different levels:
    - **Linux capabilities (`capabilities.drop: ALL`)** remove specific privileges from a process, such as the ability to modify network settings or perform certain administrative operations.
    - **Seccomp** restricts which system calls the process can make in the first place, regardless of the capabilities it holds.
  - **Why `RuntimeDefault`?** Instead of defining our own custom syscall filter, we use the security profile maintained by the container runtime. It provides a sensible set of restrictions while allowing the system calls commonly required by containers. The exact restrictions can vary between container runtimes and their versions.
  - **Together, capabilities and seccomp provide complementary security layers**, reducing the privileges available to the container and limiting its access to potentially dangerous system calls.

> **Defense in Depth:** The Dockerfile specifies the default user for the image, while the Kubernetes `securityContext` independently enforces the **non-root user and group at runtime**. Since developers typically maintain Dockerfiles and DevOps teams maintain Kubernetes manifests, enforcing this in both places provides an additional layer of protection. **Even if the Dockerfile misses the non-root `USER` instruction, the Kubernetes manifest still enforces UID `10001` and GID `10001` and prevents the container from running as root.**

---

**Topology Spread Constraints**

```yaml
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: cwvj-mega-project
        app.kubernetes.io/instance: cwvj-mega-project-dev
        app.kubernetes.io/component: backend
```

- **`topologySpreadConstraints`** helps distribute backend Pod replicas across different availability zones.
- **`topologyKey: topology.kubernetes.io/zone`** tells the scheduler to consider availability zones when distributing Pods.
- **`maxSkew: 1`** allows a maximum difference of one Pod between eligible zones. For example:

  | Total Replicas | AZ-1 | AZ-2 | Difference |
  |---:|---:|---:|---:|
  | 2 | 1 | 1 | 0 |
  | 3 | 2 | 1 | 1 |
  | 5 | 3 | 2 | 1 |

  **`whenUnsatisfiable: DoNotSchedule`** makes this a hard scheduling constraint. If Kubernetes cannot maintain the permitted distribution, the additional Pod remains unscheduled.

- **`labelSelector`** identifies which Pods are considered when calculating the distribution. Here, we select Pods belonging to our backend component using the labels defined in the Deployment's Pod template.

---

**Init Container – Wait for PostgreSQL**

Before starting the backend application, we use an init container to check whether PostgreSQL is reachable.

```yaml
initContainers:
  - name: wait-for-postgres
    image: busybox:1.37.0
    imagePullPolicy: IfNotPresent
    command:
      - sh
      - -c
      - |
        timeout=300
        elapsed=0

        until nc -z -w 2 cwvj-postgres 5432; do
          if [ "$elapsed" -ge "$timeout" ]; then
            echo "PostgreSQL endpoint did not become reachable within 300 seconds"
            exit 1
          fi

          sleep 5
          elapsed=$((elapsed + 5))
        done

        echo "PostgreSQL endpoint is reachable"
```

- **`initContainers`** defines containers that must complete successfully before the main application containers start. We use one init container to check whether PostgreSQL is reachable.
- **`image: busybox:1.37.0`** uses a lightweight BusyBox image that provides the `nc` (netcat) utility required for our connectivity check.
- **`command`** executes a shell script that repeatedly checks whether the `cwvj-postgres` endpoint is reachable on port `5432`.
  - **`cwvj-postgres`** is the Kubernetes `ExternalName` Service defined in our `rds.yaml` manifest. It acts as a DNS alias pointing to our Amazon RDS PostgreSQL endpoint.
  - **`nc -z -w 2`** attempts to establish a TCP connection to the PostgreSQL endpoint on port `5432`. This ensures the database endpoint is reachable before starting the backend container. **nc=Netcat**.
  - The script retries every five seconds for up to **300 seconds**. If the connection cannot be established within that time, the init container exits with an error, preventing the backend container from starting.

  > **Important:** This is only a **TCP connectivity check**. It does not verify database authentication or whether the specific database configured in `DB_URL` exists. For example, if the RDS instance is reachable but the required database hasn't been created, this check will still succeed, and the backend application may subsequently fail to establish its database connection.
- The script retries at five-second intervals and uses a configured **300-second timeout**. If PostgreSQL remains unreachable, the script exits with an error, preventing the backend container from starting until the init container completes successfully.

---

**Init Container Security Context and Resources**

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 10001
  runAsGroup: 10001
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
  seccompProfile:
    type: RuntimeDefault
resources:
  requests:
    cpu: 10m
    memory: 16Mi
  limits:
    cpu: 100m
    memory: 32Mi
```

- **`securityContext`** applies security restrictions specifically to the init container.
  - **`runAsNonRoot: true`** ensures that the container does not run as the root user.
  - **`runAsUser: 10001` and `runAsGroup: 10001`** specify the Linux user ID (UID) and primary group ID (GID) used by the container processes.
  - **`allowPrivilegeEscalation: false`** prevents processes inside the container from gaining additional privileges, for example, through setuid or setgid executables.
  - **`capabilities.drop: ALL`** removes all Linux capabilities from the container. Capabilities provide specific privileges that would otherwise generally be associated with the root user.
  - **`seccompProfile: RuntimeDefault`** applies the default seccomp profile provided by the container runtime.
    - **What is seccomp?** It is a Linux kernel security feature that filters the system calls (syscalls) a process can make to the kernel.
    - **How is it different from capabilities?** Capabilities restrict specific privileged operations, whereas seccomp restricts which system calls a process can execute. Both provide complementary layers of security.
- **`resources.requests`** specifies the CPU and memory resources requested by the init container. Kubernetes considers these values when determining whether a node has sufficient resources to schedule the Pod.
  - **`cpu: 10m`** requests 10 millicores (0.01 CPU core).
  - **`memory: 16Mi`** requests 16 Mebibytes of memory.
- **`resources.limits`** defines the maximum CPU and memory the init container can consume.
  - **`cpu: 100m`** limits the container to 100 millicores (0.1 CPU core). If it attempts to consume more, CPU usage is throttled.
  - **`memory: 32Mi`** sets the maximum memory limit. If the container exceeds this limit, it can be terminated with an `OOMKilled` status.

> **Note:** Init containers run **sequentially** and complete before the application containers start. Kubernetes therefore calculates the Pod's effective resource requirements by considering the **highest resource request among its init containers** and the **combined requests of its application containers**, rather than simply adding them together. In our case, the **backend container's resource requests are higher** than those of the init container.

---

**Backend Container**

Once the init container completes successfully, Kubernetes starts our main backend container.

```yaml
containers:
  - name: backend
    image: __BACKEND_IMAGE__
    imagePullPolicy: IfNotPresent
    ports:
      - name: http
        containerPort: 8080
        protocol: TCP
```

- **`name: backend`** assigns a name to the container within the Pod.
- **`image`** specifies the container image to run. Our deployment workflow replaces `__BACKEND_IMAGE__` with the actual ECR image reference before applying the manifest.
- **`imagePullPolicy: IfNotPresent`** instructs Kubernetes to pull the image only if it is not already available on the worker node.
- **`ports`** declares the ports used by the container. We name port `8080` as `http` and specify TCP as the communication protocol. Other Kubernetes configurations, such as Services and health probes, can refer to this port by its name.

---

**Container Security Context**

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 10001
  runAsGroup: 10001
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
  seccompProfile:
    type: RuntimeDefault
```

- **`securityContext`** defines security-related settings that control how the backend container runs.
- **`runAsNonRoot: true`** ensures the container does not run as the root user. `runAsUser: 10001` and `runAsGroup: 10001` specify the Linux user ID and primary group ID.
- **`allowPrivilegeEscalation: false`** prevents processes inside the container from gaining additional privileges.
- **`capabilities.drop: ALL`** removes all Linux capabilities from the container, following the principle of least privilege.
- **`seccompProfile: RuntimeDefault`** applies the default seccomp profile provided by the container runtime.

---

**Environment Variables and Database Connectivity**

```yaml
env:
  - name: SERVER_PORT
    value: "8080"
  - name: DB_URL
    value: "jdbc:postgresql://cwvj-postgres:5432/__DB_NAME__"
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: backend-db-secret
        key: username
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: backend-db-secret
        key: password
```

- **`env`** defines the environment variables made available to the backend container.
- **`SERVER_PORT`** specifies the port on which our Spring Boot application listens.
- **`DB_URL`** defines the JDBC connection URL used by the application to connect to PostgreSQL. It uses the `cwvj-postgres` Kubernetes Service name and port `5432`, with `__DB_NAME__` replaced by the actual database name during deployment.
- **`DB_USER` and `DB_PASSWORD`** retrieve the database credentials from the Kubernetes Secret named `backend-db-secret`. The `secretKeyRef` field specifies which Secret and key to retrieve the values from. This avoids hardcoding database credentials in our manifest.

---

**Resource Requests and Limits**

```yaml
resources:
  requests:
    cpu: 100m
    memory: 256Mi
  limits:
    cpu: 500m
    memory: 768Mi
```

- **`resources.requests`** specifies the minimum CPU and memory resources requested by the container. Kubernetes uses these values when scheduling the Pod onto a suitable node.
- **`resources.limits`** defines the maximum CPU and memory the container can consume. CPU usage is throttled when it reaches its limit, while exceeding the memory limit can result in the container being terminated with an `OOMKilled` status.
- In our configuration, the backend requests `100m` CPU and `256Mi` memory, with limits of `500m` CPU and `768Mi` memory.

---

**Startup, Liveness and Readiness Probes**

```yaml
startupProbe:
  httpGet:
    path: /actuator/health/liveness
    port: http
  periodSeconds: 5
  failureThreshold: 30

livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: http
  periodSeconds: 10
  timeoutSeconds: 2
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: http
  periodSeconds: 5
  timeoutSeconds: 2
  failureThreshold: 3
```

Kubernetes uses **health probes** to periodically check whether our application has started, is functioning correctly, and is ready to receive traffic. These checks are performed by the **kubelet** running on the worker node.

We have configured all three types of probes:

- **`startupProbe`** checks whether our Spring Boot application has successfully started.
  - **`httpGet`** instructs Kubernetes to perform an HTTP GET request against the specified endpoint.
  - **`path: /actuator/health/liveness`** uses the Spring Boot Actuator liveness endpoint to verify that the application has started successfully.
  - **`periodSeconds: 5`** instructs Kubernetes to perform the check every five seconds.
  - **`failureThreshold: 30`** allows up to 30 consecutive failed checks before considering the startup probe unsuccessful. This gives our application approximately **150 seconds (5 × 30)** to start successfully.
  - Once the startup probe **succeeds**, Kubernetes begins executing the liveness and readiness probes. Until then, both remain inactive.

- **`livenessProbe`** determines whether our application is still running and healthy.
  - We use the same Actuator liveness endpoint (`/actuator/health/liveness`) to check whether the application is functioning.
  - **`periodSeconds: 10`** instructs Kubernetes to perform the check every 10 seconds.
  - **`timeoutSeconds: 2`** specifies how long Kubernetes waits for a response before considering the check failed.
  - **`failureThreshold: 3`** allows three consecutive failed checks. If all three fail, Kubernetes considers the container unhealthy and **restarts it**.

- **`readinessProbe`** determines whether our application is ready to receive traffic.
  - **`path: /actuator/health/readiness`** uses the Spring Boot Actuator readiness endpoint to check whether the application is ready to serve requests.
  - **`periodSeconds: 5`** instructs Kubernetes to perform the check every five seconds.
  - **`timeoutSeconds: 2`** specifies how long Kubernetes waits for a response before considering the check failed.
  - **`failureThreshold: 3`** allows three consecutive failed checks. If all three fail, Kubernetes marks the Pod as **NotReady** and removes it from the endpoints of Services that select it. This prevents traffic from being routed to an application that is not ready.
  - Unlike a liveness probe, a failed readiness probe **does not restart the container**. Kubernetes continues checking it and makes the Pod available for traffic again once it becomes ready.

- **Named port:** Notice that all three probes use `port: http`. This refers to the named container port `http` that we defined earlier, which maps to container port `8080`.

> **Production Insight – Choosing the Right Health Probes:** In production Kubernetes environments, you'll commonly encounter liveness and readiness probes, while startup probes are generally used for applications that take longer to initialize. Choosing the right probe is important because **each probe serves a different purpose and triggers a different Kubernetes action**.
>
> - **Liveness Probe – Should the container be restarted?**
>   - Use it to detect situations where an application becomes unresponsive or stuck, such as a deadlock, and restarting it can potentially recover the application.
>   - If the liveness probe fails consecutively beyond the configured `failureThreshold`, Kubernetes terminates the container and restarts it according to the Pod's restart policy.
>
> - **Readiness Probe – Should the application receive traffic?**
>   - Use it to determine whether the application is ready to serve requests. This is particularly useful during application initialization, temporary overload, or when a required dependency is unavailable.
>   - If the readiness probe fails, Kubernetes marks the Pod as **NotReady** and removes it from the endpoints of Services that select it. **The container continues running and is not restarted.** Kubernetes keeps checking the probe and restores traffic when the application becomes ready again.
>
> - **Startup Probe – Has the application finished starting?**
>   - Use it for **slow-starting applications** that require additional time to initialize, such as applications loading large datasets, performing migrations, or initializing caches.
>   - While the startup probe is running, Kubernetes does not execute the liveness and readiness probes. Once it succeeds, the other probes take over. If it fails beyond the configured threshold, Kubernetes terminates the container and applies the Pod's restart policy.
>
> **Important:** Choosing the right **probe mechanism and health-check endpoint** is equally important. Kubernetes supports four probe mechanisms:
>
> | Probe Mechanism | How It Works | What It Checks |
> |---|---|---|
> | **HTTP GET** | Sends an HTTP GET request to a specified endpoint and checks the response status. | Whether the application responds successfully over HTTP. |
> | **TCP Socket** | Attempts to establish a TCP connection to a specified port. | Whether the application is listening on that port. |
> | **Exec** | Executes a specified command inside the container and checks its exit code. | Whether the command completes successfully (exit code `0`). |
> | **gRPC** | Calls the standard gRPC health-checking service on a specified port. | Whether the application reports itself as healthy through gRPC. |
>
> Select the mechanism based on how your application exposes its health information and what you actually need to verify.
>
> **Example:** An application URL might respond successfully even when its database is unavailable. Therefore, a successful HTTP response does not necessarily mean the application can perform its business operations. The health-check endpoint must reflect the condition we're trying to verify.
>
> **Be particularly careful with liveness checks:** Do not make them dependent on external systems such as databases. If a shared database becomes unavailable, you don't want Kubernetes restarting all application instances unnecessarily. Whether database availability should affect readiness is a separate decision based on whether the application can meaningfully serve requests without it.
>
> The objective is to configure probes that **accurately reflect application health, avoid unnecessary restarts, and prevent traffic from reaching workloads that cannot serve requests**.

---

#### 2. Backend Service – `backend.yaml`

Our backend manifest also defines a Service. While the Deployment manages our Pods, the Service provides a stable network endpoint through which other components can communicate with them.

---

**Backend Service Specification**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: cwvj-backend
  namespace: dev
spec:
  type: ClusterIP
  selector:
    app.kubernetes.io/name: cwvj-mega-project
    app.kubernetes.io/instance: cwvj-mega-project-dev
    app.kubernetes.io/component: backend
  ports:
    - name: http
      port: 8080
      targetPort: http
      protocol: TCP
```

- **`kind: Service`** tells Kubernetes that we're creating a Service resource named `cwvj-backend` in the `dev` namespace.
- **`type: ClusterIP`** creates an internal Service endpoint that can be accessed from within the Kubernetes cluster. This is appropriate for our backend because it is intended to receive traffic from other application components rather than being directly exposed externally.
- **`selector`** identifies the backend Pods that this Service should send traffic to. Notice that these labels match the labels defined in our backend Deployment's Pod template.
- **`port: 8080`** is the port exposed by the Service, while **`targetPort: http`** forwards traffic to the container port named `http` (8080). Kubernetes automatically distributes traffic across the matching ready Pods.

---

#### 3. RDS Service – `rds.yaml`

Our database is hosted on **Amazon RDS for PostgreSQL**, not inside the EKS cluster. We therefore use an `ExternalName` Service to provide an internal DNS alias for the RDS endpoint.

**RDS Service Specification**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: cwvj-postgres
  namespace: dev
spec:
  type: ExternalName
  externalName: cwvj-mega-postgres.c7m8gq4y4w13.ap-south-1.rds.amazonaws.com
```

- **`kind: Service`** creates a Kubernetes Service named `cwvj-postgres` in the `dev` namespace.
- **`type: ExternalName`** configures the Service as a DNS alias for an external hostname.
  - Kubernetes DNS returns a **CNAME record** that points to the external hostname.
  - Unlike a `ClusterIP` Service, it does not create a virtual IP, select Pods, or proxy traffic. The connection is made directly to the external database endpoint after DNS resolution.
- **`externalName`** specifies the actual Amazon RDS endpoint to which the alias points.
- This allows our backend application to connect to PostgreSQL using `cwvj-postgres` rather than hardcoding the lengthy RDS endpoint in its database connection URL. The PostgreSQL port (`5432`) is specified separately in the application's JDBC URL.

> **Production Insight – Decoupling Application Configuration from Infrastructure Endpoints:**
>
> One of the biggest advantages of using an `ExternalName` Service is that it **decouples our application configuration from the actual database endpoint**.
>
> Consider a scenario where we need to replace our existing RDS instance, restore a database into a new instance, or rename an existing instance. The new RDS instance may have a different endpoint. Without an abstraction, we would need to update the database endpoint in our application configuration and potentially rebuild or redeploy the application.
>
> With our current approach, the backend continues connecting through the same internal DNS name:
>
> `jdbc:postgresql://cwvj-postgres:5432/<DB_NAME>`
>
> We only need to **update the `externalName` field in `rds.yaml`** to point to the new RDS endpoint and apply the updated Service manifest. The backend application configuration and container image can remain unchanged.
>
> **Important:** This does not mean that existing database connections automatically migrate to the new instance. Applications must establish new connections, and DNS caching and connection-pool behavior must be considered during the transition.
>
> **Note:** A routine RDS Multi-AZ failover generally does not require changing the `ExternalName` Service. RDS retains the database endpoint and updates its DNS record to point to the new primary. The abstraction is particularly useful when the actual endpoint hostname changes, such as during an instance replacement or rename.
>
> Also, remember that `ExternalName` is a **DNS-level alias, not a network proxy**. If the application uses strict TLS hostname verification (for example, PostgreSQL JDBC `sslmode=verify-full`), the internal alias may not match the hostname in the RDS server certificate. This needs to be addressed when designing the database TLS configuration rather than simply disabling certificate verification.
>
> In our project, the DEV and PROD manifests currently define separate `ExternalName` Services, but both point to the same RDS endpoint. In a production environment, these could point to separate RDS instances or database endpoints depending on the required environment isolation.

---

#### 4. What About the Frontend and PROD Manifests?

We won't repeat the same explanation for the remaining manifests because they follow essentially the same structure.

- **Frontend (`frontend.yaml`):** Similar to the backend, it defines a Deployment and a Service. The Deployment runs two NGINX frontend replicas, while the Service uses `NodePort` to expose the frontend. In DEV, we use NodePort `30080`. The frontend does not require the database connectivity configuration or PostgreSQL init container used by the backend.
- **PROD manifests:** Follow the same overall structure as DEV, with environment-specific namespaces, labels, and configuration. The frontend NodePort is `30081` in PROD, compared with `30080` in DEV. Both environments reference the same Amazon RDS endpoint in this project.

> **Production Insight – Separating Cluster Administration from Application Deployment:**
>
> Earlier in this project, we manually created the **DEV and PROD namespaces**, configured **namespace-scoped RBAC**, and created the **database Secrets** required by each environment. These are foundational resources that must exist before our application manifests can be deployed.
>
> These resources could also be provisioned through automation, such as **Infrastructure as Code (IaC)** or a separate infrastructure/bootstrap workflow. However, in most existing enterprise environments, these resources are typically already provisioned and managed by the platform or Kubernetes administration teams. Application deployment pipelines are expected to consume these existing resources rather than manage the underlying cluster configuration.
>
> We've deliberately followed this architecture to demonstrate **separation of duties**:
>
> - **Platform / Kubernetes Administrators:** Own cluster administration and foundational resources, including namespaces, access configuration, RBAC, and database Secrets.
> - **CI/CD Engineers:** Own application build and deployment workflows. Their IAM roles and Kubernetes permissions allow them to perform only the operations explicitly authorized by the administrators.
>
> In our implementation, the EKS access entry maps the GitHub Actions IAM role to a Kubernetes group, and the namespace-scoped RoleBinding associates that group with the permissions defined in the corresponding Role. This ensures that our deployment workflow can manage application resources within its authorized namespace without requiring **cluster-admin privileges**.
>
> **Important:** Kubernetes Secrets require particular care. Permission to create workloads in a namespace can potentially allow a principal to indirectly access Secrets in that namespace by referencing them in Pods. Therefore, Secret creation and access should be restricted to trusted identities, and deployment permissions should follow the **principle of least privilege**.
>
> There are multiple ways to structure these responsibilities depending on the organization's operating model. For this project, we've chosen to keep **infrastructure provisioning and application deployment separate**, which better reflects how many enterprise EKS environments are operated.

---

### Task 5: Configure GitHub Actions Variables for DEV Deployment

Before configuring the DEV deployment workflow, we need to create GitHub repository and environment variables that identify our Amazon EKS cluster, database, and the IAM role that GitHub Actions will assume for deployment.

**1. Create the repository-level variable**

Navigate to **GitHub Repository → Settings → Secrets and variables → Actions → Variables** and create the following repository variable:

| Variable Name | Value |
|---|---|
| `EKS_CLUSTER_NAME` | `cwvj-mega-demo-eks` |

We keep this as a **repository-level variable** because our DEV and PROD workloads use the same EKS cluster.

We can reference it in our workflows using the `vars` context:

`${{ vars.EKS_CLUSTER_NAME }}`

---

**2. Create the DEV environment variables**

Our DEV deployment workflow needs to know which database to connect to and which IAM role to assume. Since these values are specific to the DEV environment, we configure them as **environment-level variables**.

Navigate to **GitHub Repository → Settings → Environments → dev → Environment variables** and create:

| Variable Name | Value |
|---|---|
| `DB_NAME` | `cwvj_dev_db` |
| `AWS_EKS_DEPLOY_ROLE_ARN` | `arn:aws:iam::497613475050:role/CWVJGitHubActionsEKSDeployDevRole` |

Since our DEV deployment job references `environment: dev`, GitHub makes these environment variables available through the `vars` context.

We can reference them using:

- `${{ vars.DB_NAME }}`
- `${{ vars.AWS_EKS_DEPLOY_ROLE_ARN }}`

> **Note:** When configuring the PROD environment, we will create the same variable names under **Settings → Environments → prod**, but with production-specific values:
>
> | Variable Name | PROD Value |
> |---|---|
> | `DB_NAME` | `cwvj_prod_db` |
> | `AWS_EKS_DEPLOY_ROLE_ARN` | `arn:aws:iam::497613475050:role/CWVJGitHubActionsEKSDeployProdRole` |
>
> This allows both deployment workflows to use the same variable references. GitHub supplies the appropriate values based on the environment declared by each job.

> **Important:** Ensure that the deployment jobs declare the correct environment (`dev` or `prod`). Environment-level variables become available through the `vars` context after the job declares its environment. These are **configuration variables, not secrets**. Replace the example AWS account ID with your own.

---

### Task 6: Create the Automated DEV Deployment Workflow

In this task, we will create `.github/workflows/02-deploy-dev.yaml` to deploy our application to DEV automatically after successful completion of the CI workflow.

The deployment workflow will authenticate to AWS using **GitHub OIDC**, locate the existing ECR images, resolve their **immutable image digests**, and deploy them to EKS.

**Why are we creating a separate workflow instead of adding deployment jobs to `ci.yaml`?**

There are multiple ways to design CI/CD workflows. We could have included the deployment jobs directly in our existing CI workflow, used reusable workflows, or maintained separate workflow files for different responsibilities.

For this project, we've deliberately chosen **separate workflow files** to establish a clear distinction between CI, deployment, and release management. This provides better separation of responsibilities and allows us to manage each workflow independently, including its **triggers, permissions, concurrency controls, and environment-specific configurations**.

As we progress through the project, we will introduce additional workflow files:

- **`01-ci.yaml`:** Already created in an **earlier stage**. Builds and tests the application, performs security and code-quality checks, builds container images, scans them, and publishes them to Amazon ECR.
- **`02-deploy-dev.yaml`:** Will be created in **this stage**. Deploys the successfully published container images to our DEV environment.
- **`03-create-pr.yaml`:** Will be introduced in a **later stage**. Handles Pull Request creation after a successful DEV deployment.
- **`04-deploy-prod.yaml`:** Will be introduced in a **later stage**. Handles production deployment after the Pull Request is merged and the required production approval is obtained.

This structure keeps each workflow focused on a specific responsibility and makes the overall CI/CD process easier to understand, maintain, troubleshoot, and extend.

> **Important:** Separate workflow files help establish a clear operational boundary, but they do not automatically provide security isolation. Actual access control is enforced through **GitHub Actions permissions, environment protection rules, IAM trust policies, and Kubernetes RBAC**.

Our objective is to **separate CI from deployment** and reuse the container images produced by CI without rebuilding the application or its images. This also ensures that the same validated image can be promoted across DEV and PROD.

**File: `.github/workflows/02-deploy-dev.yaml`**

```yaml
name: CWVJ Deploy | DEV

on:
  workflow_run:
    workflows:
      - "CWVJ CI | Build, Scan and Publish"
    types:
      - completed
    branches:
      - "feature/**"
      - "bugfix/**"
      - "hotfix/**"

concurrency:
  group: cwvj-deploy-dev
  cancel-in-progress: false

jobs:
  deploy-to-dev-job:
    name: Deploy to DEV
    runs-on: ubuntu-26.04
    timeout-minutes: 15
    environment: dev

    if: >-
      github.event.workflow_run.conclusion == 'success'

    permissions:
      contents: read
      id-token: write

    steps:
      - name: Check out deployment manifests
        uses: actions/checkout@v7
        with:
          ref: ${{ github.event.workflow_run.head_sha }}

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_EKS_DEPLOY_ROLE_ARN }}
          aws-region: ${{ vars.AWS_REGION }}

      - name: Find the published image digests
        env:
          CI_SHA: ${{ github.event.workflow_run.head_sha }}
        run: |
          set -euo pipefail

          SHORT_SHA="${CI_SHA::7}"

          BACKEND_DIGEST=$(aws ecr describe-images \
            --repository-name cwvj-mega-backend \
            --filter tagStatus=TAGGED \
            --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
            --output json | tr -d '"')

          FRONTEND_DIGEST=$(aws ecr describe-images \
            --repository-name cwvj-mega-frontend \
            --filter tagStatus=TAGGED \
            --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
            --output json | tr -d '"')

          if [[ -z "$BACKEND_DIGEST" || "$BACKEND_DIGEST" == "null" || \
                -z "$FRONTEND_DIGEST" || "$FRONTEND_DIGEST" == "null" ]]; then
            echo "Could not find both published images for commit ${CI_SHA}"
            exit 1
          fi

          echo "BACKEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-backend@${BACKEND_DIGEST}" >> "$GITHUB_ENV"

          echo "FRONTEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-frontend@${FRONTEND_DIGEST}" >> "$GITHUB_ENV"

      - name: Configure kubectl
        run: |
          aws eks update-kubeconfig \
            --name "${{ vars.EKS_CLUSTER_NAME }}" \
            --region "${{ vars.AWS_REGION }}"

      - name: Prepare DEV manifests
        run: |
          sed -i \
            -e "s|__BACKEND_IMAGE__|${BACKEND_IMAGE}|g" \
            -e "s|__DB_NAME__|${{ vars.DB_NAME }}|g" \
            kubernetes/dev/backend.yaml

          sed -i \
            -e "s|__FRONTEND_IMAGE__|${FRONTEND_IMAGE}|g" \
            kubernetes/dev/frontend.yaml

      - name: Deploy to DEV
        run: kubectl apply -f kubernetes/dev/

      - name: Wait for deployments
        run: |
          kubectl rollout status deployment/cwvj-backend -n dev --timeout=5m
          kubectl rollout status deployment/cwvj-frontend -n dev --timeout=5m

      - name: Show deployed resources
        run: kubectl get deployments,pods,services -n dev -o wide

      - name: Smoke test DEV frontend
        run: |
          kubectl port-forward -n dev service/cwvj-frontend 18080:80 &
          PORT_FORWARD_PID=$!
          trap 'kill "$PORT_FORWARD_PID" 2>/dev/null || true' EXIT

          curl --fail --silent --show-error \
            --retry 10 --retry-connrefused \
            --max-time 10 \
            http://127.0.0.1:18080/
```

#### Explanation

```yaml
name: CWVJ Deploy | DEV

on:
  workflow_run:
    workflows:
      - "CWVJ CI | Build, Scan and Publish"
    types:
      - completed
    branches:
      - "feature/**"
      - "bugfix/**"
      - "hotfix/**"

concurrency:
  group: cwvj-deploy-dev
  cancel-in-progress: false
```

- **`name`:** Defines the workflow's display name in GitHub Actions. This name is also used by other workflows when referencing it through the `workflow_run` event.
- **`on`:** Defines the events that trigger this workflow.
- **`workflow_run`:** Triggers a workflow based on the lifecycle events of another workflow. We use it to initiate DEV deployment after our CI workflow completes, keeping CI and deployment independently managed.

  **What if we only specified `workflow_run` without the `workflows` filter?** The deployment workflow could be triggered by runs of **any workflow in the repository** that match the configured activity types and other filters. We explicitly restrict it to our CI workflow to avoid unrelated workflows triggering DEV deployments.

- **`workflows`:** Identifies the upstream workflow to monitor. The name `CWVJ CI | Build, Scan and Publish` must match the `name` defined in our `01-ci.yaml` file.
- **`types: completed`:** Specifies the **activity type** that triggers this workflow. The `workflow_run` event supports three activity types: `requested`, `in_progress`, and `completed`. We use `completed` because deployment should only be considered after CI has finished, rather than while it is still running.

  **Reference:** [GitHub documentation – Events that trigger workflows (`workflow_run`)](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#workflow_run).

  > **Important:** `completed` triggers when CI finishes, regardless of whether it succeeds, fails, or is cancelled. Our job-level `if` condition handles the outcome and allows deployment only when CI succeeds.

- **`branches`:** Restricts the trigger to upstream workflow runs associated with branches matching `feature/**`, `bugfix/**`, or `hotfix/**`. This ensures that **only CI runs associated with our intended development branches can trigger DEV deployment**.

  This is particularly relevant because our CI workflow also supports `workflow_dispatch`, which allows users to **manually select a branch** when triggering CI. For example, even if someone manually runs CI against `main`, this `branches` filter **prevents that run from triggering the DEV deployment workflow**.

  > **Event Filters vs. Activity Types:** In `01-ci.yaml`, we use **event filters** such as `branches` and `paths` to determine which code pushes should trigger CI. Here, we use the `workflow_run` event with **activity types** (`types: completed`) to determine when the upstream workflow should trigger deployment. We also use `workflows` and `branches` to narrow down which upstream runs we want to process.

- **`concurrency`:** Controls how multiple instances of this deployment workflow execute. We use it to ensure that DEV deployments do not run simultaneously and potentially interfere with one another.
- **`group: cwvj-deploy-dev`:** Assigns all DEV deployment runs to the same concurrency group, ensuring they are subject to the same concurrency controls.
- **`cancel-in-progress: false`:** Prevents a new deployment run from cancelling an already running deployment. This is important because interrupting a deployment midway could leave the environment in an unexpected state.

> **Important – `workflow_run` and the Default Branch:** In our project, `CWVJ CI | Build, Scan and Publish` is the **upstream workflow**, while `CWVJ Deploy | DEV` is the **downstream workflow** triggered through `workflow_run`.
>
> GitHub requires the downstream workflow (`02-deploy-dev.yaml`) to exist on the repository's **default branch (`main`)** for the `workflow_run` event to trigger it.
>
> **Our Current Situation:** At this stage, `main` contains only an incomplete version of our CI workflow (`01-ci.yaml`). Our completed CI and DEV deployment workflows are still being developed on the feature branch. Since `02-deploy-dev.yaml` does not yet exist on `main`, **the DEV deployment workflow will not be triggered**, even when our upstream CI workflow completes successfully. We will observe this during our demonstration.
>
> **Our Project Plan:** Once we have completed all the workflows, we will temporarily disable branch protection on `main` and push the completed workflows and project changes directly to it. We will then re-enable branch protection. This ensures that the latest workflow definitions and their dependencies are available on the default branch.
>
> After this bootstrap, we can trigger a new CI run from an eligible feature branch to demonstrate the complete CI-to-DEV deployment flow.
>
> **Which workflow version does GitHub execute?** For a `workflow_run` event, GitHub uses the downstream workflow definition associated with the default-branch commit selected for that run. The event's `GITHUB_SHA` represents the **latest commit on the default branch**, while `GITHUB_REF` points to the default branch.
>
> We use `github.event.workflow_run.head_sha` in the downstream workflow to check out the exact commit that triggered the upstream CI run. This means:
> - **Workflow definition:** From the default-branch commit associated with the downstream run.
> - **Application code and deployment manifests:** From the exact upstream CI commit on the feature branch.
>
> **Note:** Any local reusable workflows referenced by the downstream workflow must also exist in the same commit as the calling workflow on the default branch.

> **Production Insight:** With `cancel-in-progress: false`, an active deployment is allowed to finish before another run starts. However, GitHub's default concurrency behaviour permits only **one running and one pending run** in a concurrency group. If another run becomes pending, a newer pending run can replace it. Consider this when deciding whether every deployment request must be processed.

> **Optional Safeguards – Restricting Manual CI Execution**
>
> **1. Prevent manual execution against `main`:**
>
> If you want to prevent jobs from executing when someone manually triggers the workflow (`workflow_dispatch`) against the `main` branch, you can add the following **job-level condition** to each job:
>
> ```yaml
> if: >-
>   github.event_name != 'workflow_dispatch' ||
>   github.ref != 'refs/heads/main'
> ```
>
> This skips the jobs only when CI is **manually triggered against `main`**. Push-triggered executions and manual executions against other branches remain unaffected.
>
> **For this project:** We haven't added this condition because we want to retain the flexibility to **manually execute CI against any branch, including `main`**. Our separate DEV deployment workflow already prevents CI runs on `main` from triggering DEV deployments through its `workflow_run.branches` filter.
>
> **2. Restrict manual execution to selected administrators:**
>
> GitHub provides **Workflow Execution Protections**, available under **Repository Settings → Actions → Policies**. These protections allow administrators to control who can trigger workflows and which events are permitted.
>
> Two relevant controls are:
>
> - **Restrict actors:** Allow only selected users, teams, GitHub Apps, or repository roles (such as `Admin`) to trigger specified workflows.
> - **Restrict events:** Allow only selected events, such as `workflow_dispatch`, `push`, or `pull_request`, to trigger specified workflows.
>
> **Important:** Actor restrictions apply to the targeted workflow, not just its manual executions. Applying an Admin-only restriction directly to our existing CI workflow could also prevent non-admin developers from triggering CI through their pushes.
>
> For larger implementations, a better approach is to introduce a **separate manually triggered workflow**, restrict that workflow to selected administrators, and have it invoke a reusable CI workflow. GitHub also supports **workflow file targeting**, allowing different execution policies to be applied to different workflow files within the same repository.
>
> **Reference:** [GitHub documentation – Governing execution of GitHub Actions workflows](https://docs.github.com/en/actions/how-tos/administer/control-workflow-execution).

---

```yaml
jobs:
  deploy-to-dev-job:
    name: Deploy to DEV
    runs-on: ubuntu-26.04
    timeout-minutes: 15
    environment: dev

    if: >-
      github.event.workflow_run.conclusion == 'success'
```

- **`deploy-to-dev-job`:** The unique identifier for this job within the workflow. It can be referenced by other jobs when defining dependencies.
- **`name: Deploy to DEV`:** Provides the human-readable name displayed in the GitHub Actions UI.
- **`runs-on: ubuntu-26.04`:** Selects a GitHub-hosted runner using Ubuntu 26.04. Unlike `ubuntu-latest`, this pins the **OS release**, avoiding an automatic switch to a newer Ubuntu release when GitHub updates the `latest` label. However, the underlying runner image and its preinstalled software can still be updated by GitHub.
- **`timeout-minutes: 15`:** Sets the maximum execution time for this job. If deployment takes longer than 15 minutes, GitHub terminates the job and marks it as failed.
- **`environment: dev`:** Associates the job with the DEV GitHub Environment, making its **environment-specific variables and secrets** available and enforcing any configured protection rules.
- **`if`:** Defines the conditions that must be satisfied before the job can execute. The `>-` YAML indicator folds the multiline condition into a single expression.
  - **`conclusion == 'success'`:** Ensures deployment starts only when the triggering CI workflow completes successfully. The `workflow_run` activity type `completed` also fires when CI fails or is cancelled, so this check is essential.
    > **Note:** The properties available after `github.event` depend on the event configured under the `on` keyword. To identify the available properties, first refer to GitHub's [Triggering a workflow](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow#viewing-all-properties-of-an-event) documentation, specifically the **Viewing all properties of an event** section. From there, navigate to the [Webhook events and payloads](https://docs.github.com/en/webhooks/webhook-events-and-payloads) documentation and explore the payload structure of the relevant event. You can also inspect the actual payload by printing `toJSON(github.event)` in a workflow step.

---

```yaml
permissions:
  contents: read
  id-token: write
```

- **`permissions`:** Defines the permissions granted to the job's automatically generated `GITHUB_TOKEN` and controls its ability to request an OIDC token. We explicitly configure only the required permissions, following the **principle of least privilege**. Any permission not listed is set to `none`.
- **`contents: read`:** Allows `GITHUB_TOKEN` to **read repository contents**, enabling `actions/checkout` to retrieve our deployment manifests.

  > **Note:** In our earlier workflows, we didn't explicitly specify `contents: read` because GitHub applied the **default `GITHUB_TOKEN` permissions** configured for our repository. Those defaults already allowed repository checkout. However, once we explicitly define a `permissions` block, **any permission not listed is set to `none`**. Therefore, we must now explicitly include `contents: read`.

- **`id-token: write`:** Allows GitHub Actions to **request an OIDC token (JWT)** from GitHub's OIDC provider. The AWS Credentials action uses this token to authenticate with Amazon STS and assume the DEV deployment IAM role created in Stage 10.

> **Important:** These two permissions serve different purposes. `contents: read` controls what the **GITHUB_TOKEN can access within GitHub**, whereas `id-token: write` allows the job to **request a separate OIDC token for external authentication**. It does not grant write access to GitHub repository resources or AWS resources by itself. AWS access depends on the IAM role's **trust policy** and the **permissions policies** attached to that role.

---

```yaml
    steps:
      - name: Check out deployment manifests
        uses: actions/checkout@v7
        with:
          ref: ${{ github.event.workflow_run.head_sha }}

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_EKS_DEPLOY_ROLE_ARN }}
          aws-region: ${{ vars.AWS_REGION }}
```

- **`name: Check out deployment manifests`** gives the step a descriptive name in the workflow execution logs.
- **`uses: actions/checkout@v7`** invokes the Checkout action to retrieve the repository contents onto the runner. We need this because the deployment workflow must access the Kubernetes manifests stored in our repository.
- **`ref: ${{ github.event.workflow_run.head_sha }}`** explicitly checks out the **exact commit SHA associated with the completed upstream CI run**. This is important because, unlike a push-triggered workflow, a `workflow_run` workflow defaults to the repository's **default branch** if no `ref` is specified. We use `head_sha` to ensure that deployment uses the Kubernetes manifests from the **same source revision** that was tested by the CI run, even if the development branch has advanced in the meantime.

  > **Note:** For workflows triggered by the `workflow_run` event, GitHub sets the default branch as the workflow's reference:
  >
  > - **`GITHUB_SHA`:** Points to the last commit on the repository's default branch.
  > - **`GITHUB_REF`:** Points to the repository's default branch.
  >
  > This is why we explicitly use `github.event.workflow_run.head_sha` in `actions/checkout` rather than relying on the default checkout behaviour. This ensures that we retrieve the **exact source commit associated with the upstream CI run**, rather than the version currently available on the default branch.
  >
  > **Note:** We could also use `github.event.workflow_run.head_branch` to check out the source branch. However, this would resolve to the commit currently pointed to by that branch when the checkout takes place. If additional commits have been pushed since the upstream CI run, we could end up checking out a newer commit that was not tested by that run. Using `head_sha` ensures **commit-level consistency between CI and deployment**.

  > **Note:** How do we know which properties are available after `github.event`? These properties depend on the **event that triggered the workflow**. Since we're using `workflow_run`, we refer to its corresponding webhook payload documentation to identify the available fields.

  | Part | Meaning |
  |---|---|
  | `github` | GitHub Actions context. |
  | `.event` | Contains the **payload of the event** that triggered the workflow. |
  | `.workflow_run` | The upstream workflow run object within that payload. |
  | `.head_sha` | The **commit SHA** associated with that upstream workflow run. |

  **Reference:** [GitHub documentation: Webhook events and payloads](https://docs.github.com/en/webhooks/webhook-events-and-payloads).
- **`Configure AWS credentials`** identifies the step that establishes AWS access for the subsequent ECR and EKS operations.
- **`uses: aws-actions/configure-aws-credentials@v6`** invokes the AWS Credentials action, which uses **GitHub OIDC** to request temporary AWS credentials through Amazon STS. This avoids storing long-lived AWS access keys in GitHub.
- **`role-to-assume`** specifies the **DEV deployment IAM role** to assume, with its ARN retrieved from the GitHub Actions variable `AWS_EKS_DEPLOY_ROLE_ARN`. The role's **OIDC trust policy** determines whether this workflow is authorised to assume it, while its attached IAM policies determine the AWS permissions granted.
- **`aws-region`** specifies the AWS region, retrieved from the `AWS_REGION` GitHub Actions variable. The action makes the region available to subsequent AWS CLI and SDK operations.

> **Important:** The job-level `id-token: write` permission configured earlier allows GitHub Actions to request an OIDC token. It does not grant AWS access by itself. AWS must first validate the token against the IAM role's **trust policy** before issuing temporary credentials.
---

```yaml
- name: Find the published image digests
  env:
    CI_SHA: ${{ github.event.workflow_run.head_sha }}
  run: |
    set -euo pipefail

    SHORT_SHA="${CI_SHA::7}"

    BACKEND_DIGEST=$(aws ecr describe-images \
      --repository-name cwvj-mega-backend \
      --filter tagStatus=TAGGED \
      --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
      --output json | tr -d '"')

    FRONTEND_DIGEST=$(aws ecr describe-images \
      --repository-name cwvj-mega-frontend \
      --filter tagStatus=TAGGED \
      --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
      --output json | tr -d '"')

    if [[ -z "$BACKEND_DIGEST" || "$BACKEND_DIGEST" == "null" || \
          -z "$FRONTEND_DIGEST" || "$FRONTEND_DIGEST" == "null" ]]; then
      echo "Could not find both published images for commit ${CI_SHA}"
      exit 1
    fi

    echo "BACKEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-backend@${BACKEND_DIGEST}" >> "$GITHUB_ENV"

    echo "FRONTEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-frontend@${FRONTEND_DIGEST}" >> "$GITHUB_ENV"
```

- **`env: CI_SHA: ${{ github.event.workflow_run.head_sha }}`:** Makes the **full commit SHA** associated with the completed CI run available to this step as an environment variable. We use a **step-level `env` block** to keep the GitHub Actions expression separate from the shell script, allowing us to reference the value using `$CI_SHA` rather than embedding `${{ }}` directly inside the script. This also follows GitHub's recommended security practice of passing potentially untrusted values through environment variables instead of interpolating them directly into shell commands. **Keeping it at the step level also limits its scope** to the step that needs it.

  > **Security Note:** In our current example, `CI_SHA` is a **GitHub-generated, fixed-format commit SHA**, so directly interpolating it into the shell script would not pose a realistic injection risk. However, values such as **branch names, PR titles, and commit messages** can contain untrusted input. Directly embedding such values into shell scripts could lead to **script injection**, allowing malicious input to execute unintended commands.
  >
  > We use the environment variable approach here to **build the habit of keeping GitHub Actions expressions separate from shell scripts** and avoiding direct interpolation of potentially untrusted values. This makes our workflows safer and easier to maintain.
- **`set -euo pipefail`:** Enables stricter Bash error handling:
  - **`-e`** exits the script when a command fails.
  - **`-u`** treats references to undefined variables as errors.
  - **`-o pipefail`** ensures a pipeline fails if any command within it fails, rather than only checking the last command.
- **`SHORT_SHA="${CI_SHA::7}"`:** Extracts the first seven characters of the full commit SHA using **Bash substring syntax**. Our CI workflow includes this short SHA in the tags assigned to the published images, allowing us to identify images built from this specific commit.
- **`aws ecr describe-images`:** Retrieves metadata about the published images in the specified ECR repository, including their tags and **image digests**. We execute it separately for the backend and frontend repositories.
- **`--filter tagStatus=TAGGED`:** Limits the lookup to images that currently have at least one tag.
- **`--query`:** Uses **JMESPath** to filter the returned image metadata and retrieve the matching image digest.
  - **`imageDetails`** contains the image metadata returned by ECR.
  - **`imageTags[?ends_with(@, '-${SHORT_SHA}')]`** checks the image's tags and retains those ending with our expected commit SHA.
  - **`imageDigest`** retrieves the digest associated with the matching image.
  - **`[0]`** selects the first matching image digest.

- **`--output json | tr -d '"'`:** Returns the digest in JSON format and removes the surrounding quotation marks, leaving a clean digest value for use in subsequent commands.
- **Digest validation:** The `if` condition checks whether either digest is empty or `null`. If either image cannot be found, the script exits with a **non-zero status**, preventing deployment with an incomplete set of images. If an AWS CLI command itself fails, `set -euo pipefail` also stops the script.
- **`vars.AWS_ACCOUNT_ID` and `vars.AWS_REGION`:** Retrieve the AWS account ID and region from GitHub Actions variables. Combined with the repository name and resolved digest, they form the complete ECR image reference.
- **`GITHUB_ENV`:** We write the resolved backend and frontend image references to this special GitHub Actions environment file. Unlike the `env` block above, which makes an existing value available to the current step, writing to `GITHUB_ENV` makes **dynamically generated values available to subsequent steps in the same job**.
  > **Note:** `GITHUB_ENV` is a **special environment file provided by GitHub Actions**. Writing a `NAME=VALUE` entry to this file makes that environment variable available to **all subsequent steps in the same job**. It is useful for passing dynamically generated values between steps without having to repeat their definitions. The value is **not available in the step that writes it**, only in subsequent steps.
  > echo "BACKEND_IMAGE=123456789.dkr.ecr.ap-south-1.amazonaws.com/cwvj-mega-backend@sha256:..." >> "$GITHUB_ENV"

  > **Note:** We could also use **step outputs (`GITHUB_OUTPUT`)** to pass these dynamically generated image references to subsequent steps instead of using `GITHUB_ENV`. Since we've already covered how to define and consume outputs in our CI workflow, I wanted to demonstrate another approach here.
  >
  > However, `GITHUB_ENV` is limited to **subsequent steps within the same job**. It cannot be used to share values across jobs. If another job needs these values, use **Job Outputs** by exposing the step outputs through `jobs.<job_id>.outputs` and consuming them through the `needs` context.

For example, a complete backend image reference follows this format:

```text
ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/cwvj-mega-backend@sha256:...
```

The actual account ID, region, and digest are populated by the workflow.

> **Production Insight:** Image tags help us **locate** an artifact, while its **digest identifies its exact content**. By deploying images using their digests rather than tags, we preserve artifact identity across environments and follow our **build-once, promote-the-same-artifact** approach.

---

```yaml
      - name: Configure kubectl
        run: |
          aws eks update-kubeconfig \
            --name "${{ vars.EKS_CLUSTER_NAME }}" \
            --region "${{ vars.AWS_REGION }}"

      - name: Prepare DEV manifests
        run: |
          sed -i \
            -e "s|__BACKEND_IMAGE__|${BACKEND_IMAGE}|g" \
            -e "s|__DB_NAME__|${{ vars.DB_NAME }}|g" \
            kubernetes/dev/backend.yaml

          sed -i \
            -e "s|__FRONTEND_IMAGE__|${FRONTEND_IMAGE}|g" \
            kubernetes/dev/frontend.yaml
```

- **`Configure kubectl`** identifies the step that prepares the runner to communicate with our EKS cluster.

- **Preinstalled tools:** Our `ubuntu-26.04` GitHub-hosted runner already includes both the **AWS CLI** and **kubectl**, which is why we can execute these commands without installing them separately. GitHub maintains the software included in its runner images.

- **`aws eks update-kubeconfig`** retrieves the cluster connection details from Amazon EKS and **creates or updates** the runner's local Kubernetes configuration file (`~/.kube/config`). This file contains the cluster endpoint, certificate authority data, and authentication configuration required by `kubectl`. It also creates a Kubernetes context and sets it as the current context, which subsequent `kubectl` commands use to communicate with the specified cluster.

- **AWS credentials and permissions:** The AWS CLI uses the **temporary AWS credentials issued by STS** when our `configure-aws-credentials` action assumed the deployment IAM role earlier in the workflow. Our role's permissions policy includes the **`eks:DescribeCluster`** action, which allows the AWS CLI to retrieve the cluster connection details.

- **`--name` and `--region`** identify the EKS cluster and the AWS region in which it resides. Both values are retrieved directly from GitHub Actions variables.

  > **Note:** The `aws eks update-kubeconfig` command succeeds because the IAM role assumed by our GitHub Actions workflow has the required **`eks:DescribeCluster` permission** in its permissions policy. One of the policy statements explicitly allows this action against our EKS cluster:
  >
  > ```json
  > {
  >   "Sid": "DescribeEKSCluster",
  >   "Effect": "Allow",
  >   "Action": "eks:DescribeCluster",
  >   "Resource": "arn:aws:eks:ap-south-1:497613475050:cluster/cwvj-mega-demo-eks"
  > }
  > ```
  >
  > This permission allows the AWS CLI to retrieve the EKS cluster's connection details and configure the local kubeconfig. However, it does **not** grant permission to create or modify Kubernetes resources. When `kubectl` communicates with the cluster, EKS authenticates the IAM role using AWS IAM credentials. Our previously configured **EKS Access Entry** maps this role to the Kubernetes deployment group, while the **namespace-scoped RBAC configuration** determines which Kubernetes operations that group is authorized to perform.

  > **Note:** If the kubeconfig file does not already exist, `aws eks update-kubeconfig` creates it at `~/.kube/config` by default. If an existing file is present, it merges or updates the configuration instead. On our fresh GitHub-hosted runner, we would normally expect this file to be created during this step.


- **`Prepare DEV manifests`** identifies the step that populates our Kubernetes manifests with environment-specific values before deployment.
- **`sed -i`** performs in-place replacements in the specified manifest files on the runner. The `-e` options allow us to apply multiple replacement expressions in a single command. We use `|` as the delimiter instead of `/` because container image references contain forward slashes.
- **Backend manifest:** Replaces `__BACKEND_IMAGE__` with the digest-based image reference resolved in the previous step, and `__DB_NAME__` with the database name from the DEV GitHub Environment.
- **Frontend manifest:** Replaces `__FRONTEND_IMAGE__` with the corresponding digest-based frontend image reference.
- **`${BACKEND_IMAGE}` and `${FRONTEND_IMAGE}`** are available because the previous step wrote these values to `GITHUB_ENV`. GitHub Actions makes them available as environment variables to subsequent steps in the same job.
- **`${{ vars.DB_NAME }}`** resolves to `cwvj_dev_db` because this job references `environment: dev`. This allows the same deployment workflow to use environment-specific database configuration.

> **Important:** These modifications happen only on the GitHub-hosted runner. They do not change or commit the original files in the repository. The database credentials remain in the `backend-db-secret` Kubernetes Secret created in Task 3. The workflow substitutes only the database name, not the username or password.

> **Production Insight:** Keep environment-specific configuration separate from the application manifests wherever possible. This allows us to reuse the same deployment structure across DEV and PROD while supplying different image references and database configuration for each environment.

---

```yaml
      - name: Deploy to DEV
        run: kubectl apply -f kubernetes/dev/

      - name: Wait for deployments
        run: |
          kubectl rollout status deployment/cwvj-backend -n dev --timeout=5m
          kubectl rollout status deployment/cwvj-frontend -n dev --timeout=5m

      - name: Show deployed resources
        run: kubectl get deployments,pods,services -n dev -o wide
```

- **`Deploy to DEV`** identifies the step that submits the prepared Kubernetes manifests to the EKS cluster.
- **`kubectl apply -f kubernetes/dev/`** applies the manifest files in the specified directory. Kubernetes creates the resources if they do not exist or updates them if they already exist. The Kubernetes controllers then work towards bringing the actual cluster state in line with the desired state declared in these manifests.
- **`Wait for deployments`** ensures that the deployment process does not proceed until both application Deployments have completed their rollouts.
- **`kubectl rollout status`** monitors the progress of a Deployment until its new version is successfully rolled out. We execute it separately for the backend and frontend, targeting the `dev` namespace using `-n dev`.
- **`--timeout=5m`** sets the maximum time to wait for each rollout. If either Deployment fails to complete within five minutes, the command returns an error and the workflow job fails.
- **`Show deployed resources`** provides a snapshot of the resources created or updated by the deployment.
- **`kubectl get deployments,pods,services -n dev -o wide`** retrieves the Deployments, Pods, and Services in the DEV namespace. The `-o wide` option displays additional information, such as Pod IPs and the nodes on which Pods are running, which is useful for troubleshooting.

> **Important:** **Namespace creation**, **database Secret creation**, and **deployment RBAC configuration** are handled separately during environment preparation. This workflow only deploys **application resources** using the permissions granted to the **DEV deployment role**. A successful rollout confirms that the Deployments have progressed successfully, but **application-level functionality** is verified separately by the smoke test in the next step.

---

```yaml
      - name: Smoke test DEV frontend
        run: |
          kubectl port-forward -n dev service/cwvj-frontend 18080:80 &
          PORT_FORWARD_PID=$!
          trap 'kill "$PORT_FORWARD_PID" 2>/dev/null || true' EXIT

          curl --fail --silent --show-error \
            --retry 10 --retry-connrefused \
            --max-time 10 \
            http://127.0.0.1:18080/
```

- **`Smoke test DEV frontend`** identifies the step that performs a basic application-level connectivity check after the Kubernetes Deployments have completed their rollouts.
- **`kubectl port-forward -n dev service/cwvj-frontend 18080:80`** establishes a temporary connection between **port 18080 on the GitHub-hosted runner** and **port 80 of the frontend Service** in the `dev` namespace. This allows the runner to access the frontend without exposing the Service publicly.
- **`&`** runs the port-forward command in the **background**, allowing the script to continue executing while the connection remains active.
- **`PORT_FORWARD_PID=$!`** captures the process ID of the background port-forward command. We need this ID to terminate the process after the smoke test.
- **`trap 'kill "$PORT_FORWARD_PID" 2>/dev/null || true' EXIT`:** Registers a **cleanup command** that executes when the shell exits, whether the step completes successfully or encounters a failure.
  - **`trap`** registers a command to be executed when a specified event occurs.
  - **`EXIT`** specifies that the cleanup command should run when the shell exits.
  - **`kill "$PORT_FORWARD_PID"`** sends a termination signal (`SIGTERM` by default) to the background `kubectl port-forward` process. `PORT_FORWARD_PID` contains the process ID captured earlier using `$!`.
  - **`2>/dev/null`** redirects error messages to `/dev/null`, preventing unnecessary error output if the process has already terminated.
  - **`|| true`** ensures the cleanup command returns a successful exit status even if `kill` fails, preventing a cleanup failure from unnecessarily marking the step as failed.

  > **Important:** This ensures the background port-forward process is terminated when the shell exits normally or exits because of a command failure. It is not a guarantee of cleanup if the runner or shell is forcibly terminated without executing its exit trap.
- **`curl`** sends an HTTP request to `http://127.0.0.1:18080/`, which reaches the frontend Service through the port-forward.
- **`--fail`** makes `curl` return a failure for HTTP error responses (status codes 400 and above), allowing GitHub Actions to mark the step as failed.
- **`--silent --show-error`** suppresses the usual progress output while still displaying error messages when a request fails.
- **`--retry 10 --retry-connrefused`** allows up to 10 retries when the initial request fails, including when the port-forward is not yet accepting connections. This helps handle the short delay between starting the port-forward and making the HTTP request.
- **`--max-time 10`** limits each HTTP request to a maximum of 10 seconds, preventing the smoke test from waiting indefinitely.

**This smoke test verifies that the frontend Service responds to an HTTP request.** It does not independently validate backend connectivity or database operations. We will verify those separately in Task 5.

> **Production Insight:** A successful Kubernetes rollout confirms that the Deployments have progressed successfully, but it does not necessarily mean the application is reachable. A smoke test adds a basic **runtime connectivity check** after deployment. In this implementation, we use port-forwarding for validation; a production release may also require testing the application through its actual ingress or load balancer endpoint.

> **Production Insight:** Separating CI from deployment lets us **build, test, scan, and publish an image once, then deploy that same artifact** into an environment. Immutable image digests preserve artifact identity, while the deployment workflow handles environment-specific configuration and release validation.

> **`&&` (AND):** Executes the second command **only if the first command succeeds** (exit code `0`).
>
> **`||` (OR):** Executes the second command **only if the first command fails** (non-zero exit code).

---

## Stage 12: Automate Pull Request Creation

In Stage 11, we configured the DEV deployment workflow, but deliberately held off pushing the changes to GitHub. We are following a **build-first, push-later approach**, where we will complete the automation logic for DEV deployment, PR creation, and PROD deployment before pushing the workflow files.

In this stage, we will automate the transition from a successful DEV deployment to a Pull Request targeting `main`. A PR will be created only after the DEV deployment and automated smoke test succeed. The automation will preserve the identity of the deployed commit, avoid rebuilding application images, and leave **review, approval, and merging to humans**.

Once the PR is approved and merged into `main`, the PROD deployment workflow configured in Stage 13 will take over and deploy the same application images to production.

---

### Task 1: Create the Reusable Pull Request Workflow

Create `.github/workflows/03-create-pr.yaml` using the `workflow_call` trigger. Define inputs for the source branch and the exact commit SHA that was successfully deployed to DEV, and configure the minimum GitHub token permissions required to create a Pull Request.

**File:** `.github/workflows/03-create-pr.yaml`

```yaml
name: CWVJ PR | Create Pull Request (Reusable)

on:
  workflow_call:
    inputs:
      head_branch:
        required: true
        type: string
      head_sha:
        required: true
        type: string

jobs:
  create-pull-request-job:
    name: Create Pull Request
    runs-on: ubuntu-26.04

    permissions:
      contents: read
      pull-requests: write

    steps:
      - name: Check out the deployed branch
        uses: actions/checkout@v7
        with:
          ref: ${{ inputs.head_branch }}

      - name: Verify deployed commit
        env:
          DEPLOYED_SHA: ${{ inputs.head_sha }}
        run: test "$(git rev-parse HEAD)" = "$DEPLOYED_SHA"

      - name: Create or update Pull Request
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          HEAD_BRANCH: ${{ inputs.head_branch }}
          HEAD_SHA: ${{ inputs.head_sha }}
        run: |
          gh pr create --head "$HEAD_BRANCH" --base main --title "Promote $HEAD_BRANCH to main" --body "DEV deployment succeeded for commit $HEAD_SHA. Please review the changes before merging." \
            || gh pr edit "$HEAD_BRANCH" --body "DEV deployment succeeded for commit $HEAD_SHA. Please review the changes before merging."
```

---

#### Explanation

```yaml
name: CWVJ PR | Create Pull Request (Reusable)

on:
  workflow_call:
    inputs:
      head_branch:
        required: true
        type: string
      head_sha:
        required: true
        type: string
```

- **`name`** defines the workflow's display name in the GitHub Actions UI.
- **`workflow_call`** makes this workflow a **reusable workflow**. Unlike our CI workflow, which is triggered by qualifying `push` events or a `workflow_dispatch` event (initiated through the GitHub UI, CLI, or REST API), and our DEV deployment workflow, which is triggered when the CI workflow completes using `workflow_run`, this workflow is designed to be invoked explicitly by another GitHub Actions workflow. This allows us to separate PR creation logic into its own workflow and reuse it wherever required.
- **`inputs`** defines the information that must be supplied by the **calling workflow** when invoking this reusable workflow. These inputs act as parameters, allowing the reusable workflow to operate on the branch and commit supplied by its caller.
- **`head_branch`** represents the source feature branch that triggered the upstream CI workflow. In our project, this is `feature/initial-ci`. It is the branch from which the Pull Request will be created.

- **`head_sha`** represents the **exact commit SHA associated with the upstream CI run** and deployed to DEV. We pass it separately so the reusable workflow can verify the deployed commit before creating the Pull Request.
- **`required: true`** ensures that the calling workflow must provide both inputs. The reusable workflow cannot be invoked without them.
- **`type: string`** specifies that both inputs must be supplied as strings.

> **Important:** A reusable workflow does not run independently when a developer pushes code. It needs another workflow to call it. We will configure that integration in **Task 2**, where our DEV deployment workflow will invoke this reusable workflow after a successful deployment and smoke test.

---

```yaml
jobs:
  create-pull-request-job:
    name: Create Pull Request
    runs-on: ubuntu-26.04

    permissions:
      contents: read
      pull-requests: write
```


- **`jobs`** defines the jobs that make up this reusable workflow. In our case, we have one job responsible for validating the deployed commit and creating the Pull Request.

- **`create-pull-request-job`** is the unique identifier for this job. It can be referenced by other jobs within the same workflow when defining dependencies.

- **`name`** provides the human-readable name displayed for the job in the GitHub Actions UI.

- **`runs-on: ubuntu-26.04`** selects a GitHub-hosted runner using Ubuntu 26.04. Specifying the OS release keeps it consistent with our other workflows instead of relying on the moving `ubuntu-latest` label. The hosted runner image itself can still receive updates.

- **`permissions`** defines the access permissions granted to the automatically generated **`GITHUB_TOKEN`** for this job:
  - **`contents: read`** allows the token to read repository contents. This is required by `actions/checkout` to check out the source branch.
  - **`pull-requests: write`** allows the token to create and update Pull Requests through the GitHub API. We need this permission because the job uses the GitHub CLI (`gh`) to create or update the PR.

  > **Important:** When we explicitly specify individual permissions, all permissions that are not listed are automatically set to **`none`**. Therefore, our job receives only the two permissions it needs, following the **principle of least privilege**.

  > **Why job-level permissions?** We define these permissions within the job rather than at the workflow level because **only this job needs them**. This allows different jobs to have different permission levels without granting unnecessary access to other jobs.

  > **GitHub Token vs. OIDC:** Here, we use **`GITHUB_TOKEN`**, not GitHub OIDC. Both are used in GitHub Actions, but they serve different purposes. In our earlier AWS authentication workflow, `id-token: write` allowed the job to request a GitHub OIDC token, which Amazon STS exchanged for temporary AWS credentials. Here, the job uses `GITHUB_TOKEN` to authenticate directly with GitHub and perform repository operations permitted by its assigned permissions.

  > **Important:** These permissions do not restrict the Ubuntu runner itself or give it unrestricted access. They define what the job's **`GITHUB_TOKEN` can do**. Steps running on the runner can use this token to perform the permitted GitHub operations. We explicitly provide it to the GitHub CLI through the `GH_TOKEN` environment variable.

  > **Caller workflow:** Because this is a reusable workflow, the calling workflow must grant the required permissions through the permissions block of the job that invokes it. The called workflow **cannot elevate permissions beyond those granted by its caller**; it can only retain or reduce them. In our implementation, we explicitly declare the required permissions in both places to make the permission requirements clear and maintain least-privilege access.

  > **Repository setting:** GitHub also provides a repository-level setting that controls whether workflows can create or approve Pull Requests. Navigate to **Repository Settings → Actions → General → Workflow permissions** and enable **Allow GitHub Actions to create and approve pull requests**. Without this setting, `pull-requests: write` alone may not be sufficient to create a PR using `GITHUB_TOKEN`.


---

```yaml
steps:
  - name: Check out the deployed branch
    uses: actions/checkout@v7
    with:
      ref: ${{ inputs.head_branch }}
```

- **`steps`** defines the sequence of operations performed by the job. Steps execute sequentially on the same runner. Here, we first check out the source branch before performing subsequent verification or PR creation operations.

- **`name: Check out the deployed branch`** provides a human-readable name for this step, displayed in the GitHub Actions interface.

- **`uses: actions/checkout@v7`** invokes the official Checkout action to retrieve the repository contents onto the runner, under `${{ github.workspace }}`. By default, the action uses the automatically generated **`GITHUB_TOKEN`** (available through `${{ github.token }}`) to authenticate the checkout operation. This requires the token to have **`contents: read`** permission.

- **`ref: ${{ inputs.head_branch }}`** specifies which branch to check out. The value comes from the **`head_branch` input** supplied by the calling DEV deployment workflow. Since we're passing a branch name, the action checks out the branch's **latest commit at the time of checkout**.

> **Important:** Checking out `head_branch` retrieves the branch's **current commit**, not necessarily the commit that was successfully deployed to DEV. We must compare the checked-out commit SHA (`git rev-parse HEAD`) with the **original deployed commit SHA** passed by the calling workflow (for example, through a separate `head_sha` input). If they differ, the source branch has advanced since deployment. This distinction allows us to verify that we're creating a PR from the same source revision that was successfully deployed to DEV.

---

```yaml
- name: Verify deployed commit
  env:
    DEPLOYED_SHA: ${{ inputs.head_sha }}
  run: test "$(git rev-parse HEAD)" = "$DEPLOYED_SHA"
```

- **`Verify deployed commit`** identifies the step that validates whether the source branch still points to the commit successfully deployed to DEV.
- **`DEPLOYED_SHA`** receives the full commit SHA passed through the `head_sha` input by the calling DEV deployment workflow. We store it in an environment variable so we can use it safely in our shell command.
- **`git rev-parse HEAD`** retrieves the full commit SHA of the commit currently checked out on the runner.
  - **`HEAD`** refers to the commit currently checked out.
  - **`git rev-parse`** retrieves the SHA of the specified commit.
- **`test "$(git rev-parse HEAD)" = "$DEPLOYED_SHA"`** compares the checked-out commit SHA with the SHA received from the DEV deployment workflow.
  - If both SHAs match, the command succeeds and the workflow proceeds.
  - If they differ, the command fails, and subsequent steps in the job are skipped.

> **Production Insight – Ensuring Deployment-to-PR Consistency:** We want to create or update a Pull Request only when the **checked-out source revision matches the exact commit that successfully passed CI and was deployed to DEV**. However, GitHub Pull Requests reference **branches, not individual commit SHAs**. The `gh pr create` command we use in the next step accepts a branch through its `--head` argument; it does not provide an option to supply a specific commit SHA.
>
> Therefore, we verify that the **checked-out commit matches the deployed commit** before creating or updating the PR. This allows us to retain the original feature branch without introducing another branch-management mechanism. A **dedicated promotion branch** pointing to the deployed SHA is another possible approach, but it introduces additional branch creation and management. For our project, SHA verification provides a **simpler, production-oriented safeguard** while keeping the workflow straightforward.

> **Important:** This is a **point-in-time verification**; it does not lock the remote feature branch. A new commit pushed after checkout can advance the branch and subsequently appear in the PR. For stricter production controls, enforce the required **CI status checks and successful deployment of the latest PR head commit** before allowing it to merge.

---

**What happens if the deployed commit doesn't match the checked-out commit?**

Consider the following scenario:

1. **Commit A** is pushed to the development branch. It successfully passes CI and is deployed to DEV.
2. Before the PR workflow executes, a developer pushes **Commit B** to the same branch.
3. This new push triggers another CI run, provided it matches our configured branch and path filters.
4. Meanwhile, the PR workflow triggered by the successful DEV deployment of Commit A checks out the latest branch state, which is now Commit B.
5. However, `DEPLOYED_SHA` still contains Commit A because that is the commit successfully deployed to DEV.
6. The comparison fails because the two commit SHAs don't match. Consequently, the current PR workflow run fails at the verification step and skips the subsequent PR creation or update steps.

**What happens next?**

- Commit B continues through its own CI execution.
- If CI succeeds, the DEV deployment workflow is triggered and deploys Commit B.
- Once DEV deployment succeeds, it invokes the reusable PR workflow again, passing the new `head_branch` and `head_sha`.
- This time, both `git rev-parse HEAD` and `DEPLOYED_SHA` resolve to **Commit B**, so the comparison succeeds and the workflow proceeds with PR creation or update.
- If CI or DEV deployment fails, Commit B does not proceed to the PR creation stage.

> **Important:** This validation ensures that our PR workflow proceeds only when the **checked-out branch matches the exact commit successfully deployed to DEV**. If the branch advances before verification, the workflow fails rather than creating or updating a PR based on a newer, unverified revision. The newer commit must complete its own CI and DEV deployment cycle before the workflow proceeds again.

> **Note:** This check does not lock the source branch. GitHub automatically includes subsequent commits pushed to the same branch in an existing Pull Request. Therefore, if a PR already exists, a newer commit can appear in that PR even before completing its CI and DEV deployment cycle. Our verification controls when this workflow creates or updates a PR, but it does not pin an existing PR to a particular commit. For stricter production controls, enforce successful CI checks and DEV deployment requirements for the **latest PR head commit** before allowing it to merge.

---

```yaml
- name: Create or update Pull Request
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    HEAD_BRANCH: ${{ inputs.head_branch }}
    HEAD_SHA: ${{ inputs.head_sha }}
  run: |
    gh pr create --head "$HEAD_BRANCH" --base main --title "Promote $HEAD_BRANCH to main" --body "DEV deployment succeeded for commit $HEAD_SHA. Please review the changes before merging." \
      || gh pr edit "$HEAD_BRANCH" --body "DEV deployment succeeded for commit $HEAD_SHA. Please review the changes before merging."
```


- **`Create or update Pull Request`** identifies the step responsible for creating a Pull Request targeting `main` after the deployed commit has been successfully validated. We use the GitHub CLI to automate this operation rather than creating a PR manually.

- **`GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}`** makes the automatically generated **`GITHUB_TOKEN`** available to the GitHub CLI through the `GH_TOKEN` environment variable. The CLI recognizes this variable and uses the token to **authenticate with GitHub** when performing Pull Request operations.
  - We do not need to create or maintain a separate **Personal Access Token (PAT)**.
  - The effective permissions assigned to the token determine what it can do. In our case, **`contents: read`** allows `actions/checkout` to retrieve repository contents, while **`pull-requests: write`** allows the workflow to create and update Pull Requests.

- **`HEAD_BRANCH` and `HEAD_SHA`** receive the **source branch** and **exact commit SHA** from the reusable workflow inputs. We expose them as **step-level environment variables** so they can be referenced inside the shell commands without directly embedding GitHub expressions in the script. We also quote these variables when using them in commands.
  - **`HEAD_BRANCH`** identifies the source branch used to create or update the PR.
  - **`HEAD_SHA`** identifies the commit successfully deployed to DEV. We include it in the PR description for traceability; it is not used to select the PR's source revision.

- **`gh pr create`** uses the **GitHub CLI** to create a Pull Request. It needs the following arguments:
  - **`--head`** specifies the source branch containing the application changes.
  - **`--base`** specifies `main` as the target branch. In other words, we want to merge the changes from the source branch into `main`.
  - **`--title`** defines the Pull Request title using the source branch name.
  - **`--body`** provides the Pull Request description. We record the **commit SHA successfully deployed to DEV** so reviewers can identify which revision passed the deployment process. The description also asks reviewers to review the changes before merging. This is a message in the description, not a formal reviewer assignment.

- **`|| gh pr edit`** provides a fallback when the PR creation command fails. Its purpose is to handle situations where an **open PR already exists for the same source branch**, rather than creating a duplicate PR.

  - **Example 1: A subsequent commit to the same branch.** A developer pushes changes to `feature/payment`. After successful DEV deployment, the workflow creates a PR from `feature/payment` to `main`. Later, another commit is pushed to **the same branch** (possibly by another developer). Once it also passes CI and DEV deployment, the workflow attempts to create a PR again. Since an open PR for `feature/payment` already exists, the creation command fails and the fallback updates the existing PR.

  - **Example 2: An existing PR is still awaiting review.** A PR for `feature/payment` is already open, but nobody has reviewed it yet. Another commit is pushed to the same branch and successfully completes CI and DEV deployment. The workflow updates the existing PR instead of creating another one.

  - **What if the commit is on a different branch?** For example, if the next changes are pushed to `feature/user-profile`, the workflow creates a **new PR** because there is no existing PR for that source branch.

  - **`gh pr edit "$HEAD_BRANCH"`** identifies the existing PR using its source branch.
  - **`--body`** replaces the existing PR description with the updated deployment information; it does not append to the existing description.

  - **Important: The `||` operator executes the fallback whenever `gh pr create` returns a non-zero exit code, not exclusively when a PR already exists.** Other possible causes include:
    - **Insufficient permissions:** `GITHUB_TOKEN` does not have `pull-requests: write` permission, or the repository settings do not allow GitHub Actions to create pull requests.
    - **Branch issues:** The source branch has been deleted or is unavailable, or the target branch does not exist.
    - **No changes to compare:** There are no commits between the source and target branches to include in a PR.
    - **Authentication or API errors:** GitHub CLI cannot authenticate, the GitHub API request fails, or a network issue interrupts the request.

    The fallback is attempted in all these cases too. If `gh pr edit` also fails, the workflow step fails. However, **if the edit succeeds, the overall step reports success**, potentially hiding the original PR creation error.

> **How does this work?** GitHub associates a Pull Request with its **source branch**. Any new commits pushed to that branch automatically appear in the existing PR; a new PR is not required. Our workflow updates the PR description with the **SHA of the commit that successfully completed DEV deployment**.

> **Production Insight:** Since an existing PR automatically follows its source branch, a **new commit can appear in the PR before its DEV deployment completes**. Before merging, ensure the **latest PR commit** has passed CI and DEV deployment. Use branch protection and required status checks to prevent unvalidated commits from being merged; checks must pass against the latest commit.

---


### Task 2: Integrate PR Creation with the DEV Deployment Workflow

In Task 1, we created a **reusable workflow** (`03-create-pr.yaml`) containing the logic to verify the deployed commit and create or update a Pull Request. We made it reusable by defining the **`workflow_call` trigger**, allowing another workflow to invoke it.

In this task, we will integrate that reusable workflow into our DEV deployment workflow, `02-deploy-dev.yaml`. We will add a **calling job** that invokes the reusable workflow **only after the DEV deployment job succeeds**.

This introduces an important GitHub Actions concept:

- **Reusable workflow (called workflow):** Contains the actual implementation that can be reused by other workflows. In our case, it handles commit verification and PR creation.
- **Calling workflow (caller workflow):** The workflow that invokes a reusable workflow. Here, `02-deploy-dev.yaml` becomes the caller because it contains a job that invokes `03-create-pr.yaml`.
- **Calling job:** The specific job within the caller workflow that makes the call. It uses the `uses` keyword at the **job level**, not inside individual steps.

The calling job is responsible for deciding **when the reusable workflow runs** and **which inputs it receives**. The reusable workflow contains the execution logic, so we do not need to duplicate its steps in the DEV deployment workflow.

**File:** `.github/workflows/02-deploy-dev.yaml`

```yaml
# Calling job
create-pull-request-job:
  name: Create Pull Request
  needs: deploy-to-dev-job

  permissions:
    contents: read
    pull-requests: write

  uses: ./.github/workflows/03-create-pr.yaml

  with:
    head_branch: ${{ github.event.workflow_run.head_branch }}
    head_sha: ${{ github.event.workflow_run.head_sha }}
```

#### Explanation

- **`create-pull-request-job`** is the unique identifier for this job within the DEV deployment workflow. It is the **calling job** responsible for invoking our reusable PR creation workflow.

- **`name`** provides the human-readable name displayed for this job in the GitHub Actions UI.

- **`needs: deploy-to-dev-job`** establishes a **job dependency** on the DEV deployment job. The PR creation job waits until `deploy-to-dev-job` completes successfully before it can run.

  Remember, our DEV deployment job already includes the **Kubernetes rollout checks and application smoke test**. Therefore, the PR creation workflow is invoked only after the deployment and smoke test succeed. If the deployment job **fails or is skipped**, this job is also skipped by default.

- **`permissions`** defines the access granted to the automatically generated **`GITHUB_TOKEN`** for this job and the reusable workflow it invokes. Although the calling job does not perform the repository checkout or PR operations itself, GitHub **passes its token permissions to the called workflow**. We explicitly define these permissions here to ensure that the reusable workflow receives **only the access it needs**.
  - **`contents: read`** allows the `actions/checkout` step inside the reusable workflow to access the repository contents. This is required to check out the source branch and verify the deployed commit.
  - **`pull-requests: write`** allows the reusable workflow to **create and update Pull Requests** through the GitHub API.

  > **Important:** The called workflow **cannot increase the permissions granted by the calling job**. Any permissions not explicitly listed here are set to `none`.

  > The same permissions are also defined in the reusable workflow. **This duplicate permissions block is optional and can be removed** because the calling workflow already grants the required permissions. We retain it to explicitly document the permissions required by the reusable workflow.

  > **GitHub Token vs. OIDC:** We are using **`GITHUB_TOKEN`**, not GitHub OIDC, for this operation. Unlike our earlier AWS authentication, which used OIDC to obtain temporary AWS credentials through Amazon STS, this job authenticates directly with GitHub using **`GITHUB_TOKEN`** to perform repository operations.

- **`uses: ./.github/workflows/03-create-pr.yaml`** invokes the **reusable workflow** created in Task 1. The relative path points to the workflow file within the same repository.

  Notice that we use **`uses` directly at the job level**, rather than defining individual steps. This is because the execution logic, including the runner and steps, is already defined inside the reusable workflow. The calling job does not need its own `runs-on` or `steps` configuration.

- **`with`** supplies the **input values** required by the reusable workflow. The input names and their values must match the inputs defined under `on.workflow_call.inputs` in Task 1.

  - **`head_branch`** receives the original development branch from `${{ github.event.workflow_run.head_branch }}`. This identifies the **feature, bugfix, or hotfix branch** from which the application was built and deployed.

  - **`head_sha`** receives the full commit SHA from `${{ github.event.workflow_run.head_sha }}`. This identifies the **exact commit associated with the completed CI run** and ensures that the reusable workflow can verify the same commit that was successfully deployed to DEV.

> **Important:** Notice that we have not duplicated the PR creation commands in our DEV deployment workflow. The **calling workflow controls when the reusable workflow runs and which inputs it receives**, while the **reusable workflow contains the actual implementation** for validating the deployed commit and creating or updating the PR.

> **Production Insight:** Separating reusable automation logic from the workflows that invoke it promotes **modularity, maintainability, and reusability**. The same PR creation workflow can be called by other workflows in the repository without duplicating its implementation.


---

### Task 3: Enable GitHub Actions to Create Pull Requests

Our reusable workflow uses the automatically provided `GITHUB_TOKEN` through the GitHub CLI to create and update Pull Requests. We have already configured the required token permissions in the reusable workflow and its calling job (`contents: read` and `pull-requests: write`).

However, GitHub has an additional repository-level setting that controls whether workflows are allowed to create and approve Pull Requests using `GITHUB_TOKEN`. We need to enable this setting for our automation to work.

To enable it, update the repository settings:

1. Open the repository: `CloudWithVarJosh/mega-project-demo`.
2. Go to **Settings → Actions → General**.
3. Scroll down to **Workflow permissions**.
4. Enable **Allow GitHub Actions to create and approve pull requests**.
5. Click **Save**.



- **Workflow-level permissions:** In Task 1, we configured `contents: read` and `pull-requests: write` in the reusable workflow. In Task 2, we also granted these permissions to the calling job. This ensures the reusable workflow receives the required permissions from its caller.
- **`GITHUB_TOKEN`:** GitHub automatically generates this token for workflow jobs. We use it through the GitHub CLI (`gh`) to authenticate and perform Pull Request operations, avoiding the need to create and maintain a separate Personal Access Token.
- **Repository-level setting:** This is an additional control that allows or prevents workflows from creating and approving Pull Requests using `GITHUB_TOKEN`. Even when the required permissions are specified in YAML, this repository setting must allow PR creation.

> **Important:** This setting enables GitHub Actions to create and approve Pull Requests, but our workflow only uses it to **create or update** PRs. The actual review, approval, and merging remain manual and are governed by our `main` branch protection rules.

---

## Stage 13: Prepare PROD Environment and Configure Deployment Automation

In this stage, we will prepare the **PROD database and Kubernetes environment** and build the GitHub Actions workflow responsible for deploying the application to production.

The workflow will be triggered only after an automated Pull Request has been **reviewed, approved, and merged into `main`**. It will retrieve the same container images already published to **Amazon ECR** and successfully deployed to DEV, using their **immutable image digests** without rebuilding the application or its container images.

**We will not push or execute this workflow at this stage.** As planned, we will first complete the automation logic across Stages 11, 12, and 13. In Stage 14, we will configure the required GitHub repository governance, branch protection, collaborators, and production environment approvals, push the completed workflows, and demonstrate the **complete end-to-end release process**.

> **Production Insight:** Our release strategy follows **build once, promote the same artifact**. The application images that pass CI and are deployed to DEV are the exact same artifacts promoted to PROD. This ensures artifact consistency across environments and avoids rebuilding application images during production releases.

---

### Task 1: Prepare the PROD Database in Amazon RDS

Before deploying our backend application to Amazon EKS, we need to prepare its production database in **Amazon RDS for PostgreSQL**. The backend will use this database to **store production user records persistently**, while **Flyway** will manage the database schema through the application's migration scripts.

We will use the following database configuration:

| Component | Value |
|---|---|
| **RDS instance** | `cwvj-mega-postgres` |
| **Database** | `cwvj_prod_db` |
| **Application user** | `cwvj_prod_app_user` |
| **PostgreSQL port** | `5432` |

We will reuse the existing RDS instance but create a **separate PROD database and application user**. This ensures that production data remains isolated from DEV data and that each environment uses its own database credentials.

We will connect to RDS using the **master account** to perform the initial database setup, then create a **dedicated production application user** and configure the required **database and schema privileges**. The application will use this dedicated user rather than the **RDS master credentials**, following the principle of least privilege.

Connect to the RDS instance from your **EC2 instance** and execute the following commands in sequence:

- The initial `psql` command runs in the **EC2 terminal** and establishes a connection to RDS.
- All subsequent commands run inside the **`psql` prompt** to create the production database user and database, configure privileges, and verify the setup.

```sql
# 1. Connect to the RDS PostgreSQL instance.
# Replace the hostname, port, and username according to your RDS configuration.
# This example uses postgres as the master username.
psql \
  --host=cwvj-mega-postgres.c7m8gq4y4w13.ap-south-1.rds.amazonaws.com \
  --port=5432 \
  --username=postgres \
  --dbname=postgres \
  --password

# The following commands run inside the psql prompt.

# 2. Verify the current PostgreSQL user.
SELECT current_user;

# 3. Create the PROD application user.
CREATE ROLE cwvj_prod_app_user LOGIN;

# 4. Set the application user's password securely.
# Enter and confirm the password when prompted.
\password cwvj_prod_app_user

# 5. Temporarily grant the master user membership in the application role.
# Replace postgres with the username returned by SELECT current_user, if different.
GRANT cwvj_prod_app_user TO postgres;

# 6. Create the PROD database and assign ownership to the application user.
CREATE DATABASE cwvj_prod_db OWNER cwvj_prod_app_user;

# 7. Remove the temporary role membership granted in Step 5.
REVOKE cwvj_prod_app_user FROM postgres;

# 8. Connect to the newly created PROD database.
\connect cwvj_prod_db

# 9. Grant the privileges required for Flyway schema migrations.
GRANT USAGE, CREATE ON SCHEMA public TO cwvj_prod_app_user;

# 10. Verify the database connection and database ownership.
\conninfo
\l cwvj_prod_db

# 11. Verify that the application role exists and can log in.
\du cwvj_prod_app_user

# 12. Exit PostgreSQL.
\q
```

> **Important:** Replace the **RDS hostname, port, and master username** with the values configured in your environment. If your master username differs from `postgres`, update the username in the `GRANT` and `REVOKE` commands as well. Set the **application password interactively** and **never commit it to Git**. Use a different password from the DEV application user.

**Expected outcome:** The PROD database `cwvj_prod_db` is created and owned by `cwvj_prod_app_user`. The application user has a **configured password** and the **required schema privileges for Flyway migrations**. We can now proceed to configure **connectivity between RDS and our EKS environment**.

---

### Task 2: Configure GitHub Actions Variables for PROD Deployment

Before configuring the PROD deployment workflow, we need to create two **GitHub environment variables** that identify the production database and the IAM role GitHub Actions will assume for production deployment.

**1. Create the PROD environment variables**

Navigate to **GitHub Repository → Settings → Environments → prod → Environment variables** and create the following variables:

| Variable Name | Value |
|---|---|
| `DB_NAME` | `cwvj_prod_db` |
| `AWS_EKS_DEPLOY_ROLE_ARN` | `arn:aws:iam::497613475050:role/CWVJGitHubActionsEKSDeployProdRole` |

Since our PROD deployment job references `environment: prod`, GitHub makes these variables available through the `vars` context.

We can reference them using:

- `${{ vars.DB_NAME }}`
- `${{ vars.AWS_EKS_DEPLOY_ROLE_ARN }}`

> **Note:** The `EKS_CLUSTER_NAME` and `AWS_REGION` variables configured at the repository level during DEV setup are shared with the PROD workflow. Both environments use the same EKS cluster and AWS region, so there is no need to create these variables again.
>
> Replace the example AWS account ID (`497613475050`) in the IAM role ARN with your own AWS account ID.

---

### Task 3: Create the Automated PROD Deployment Workflow

Create `.github/workflows/04-deploy-prod.yaml` to automate application deployment to PROD after an eligible Pull Request targeting `main` is successfully merged. The workflow will validate that the PR was created by our automated PR workflow and that its latest commit matches the commit successfully deployed to DEV.

It will retrieve the existing backend and frontend images from **Amazon ECR** using their immutable digests, prepare the production Kubernetes manifests, and deploy the application to **Amazon EKS**. Finally, it will verify the deployment through rollout checks and an automated frontend smoke test.

We will use the `prod` GitHub Environment to introduce an independent production deployment approval gate, which will be configured in Stage 14.

**File:** `.github/workflows/04-deploy-prod.yaml`

```yaml
name: CWVJ Deploy | PROD

on:
  pull_request:
    types:
      - closed
    branches:
      - main

concurrency:
  group: cwvj-deploy-prod
  cancel-in-progress: false

jobs:
  deploy-to-prod-job:
    name: Deploy to PROD
    runs-on: ubuntu-26.04
    timeout-minutes: 20
    environment: prod

    # Deploy only when an automated DEV-approved PR is merged.
    if: >-
      github.event.pull_request.merged == true &&
      github.event.pull_request.user.login == 'github-actions[bot]' &&
      contains(github.event.pull_request.body, github.event.pull_request.head.sha)

    permissions:
      contents: read
      id-token: write

    steps:
      # Check out the merged main revision for production manifests.
      - name: Check out merged main
        uses: actions/checkout@v7
        with:
          ref: ${{ github.event.pull_request.merge_commit_sha }}

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_EKS_DEPLOY_ROLE_ARN_PROD }}
          aws-region: ${{ vars.AWS_REGION }}

      - name: Find the published image digests
        env:
          CI_SHA: ${{ github.event.pull_request.head.sha }}
        run: |
          set -euo pipefail

          SHORT_SHA="${CI_SHA::7}"

          BACKEND_DIGEST=$(aws ecr describe-images \
            --repository-name cwvj-mega-backend \
            --filter tagStatus=TAGGED \
            --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
            --output json | tr -d '"')

          FRONTEND_DIGEST=$(aws ecr describe-images \
            --repository-name cwvj-mega-frontend \
            --filter tagStatus=TAGGED \
            --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
            --output json | tr -d '"')

          if [[ -z "$BACKEND_DIGEST" || "$BACKEND_DIGEST" == "null" || \
                -z "$FRONTEND_DIGEST" || "$FRONTEND_DIGEST" == "null" ]]; then
            echo "Could not find both published images for commit ${CI_SHA}"
            exit 1
          fi

          echo "BACKEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-backend@${BACKEND_DIGEST}" >> "$GITHUB_ENV"
          echo "FRONTEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-frontend@${FRONTEND_DIGEST}" >> "$GITHUB_ENV"

      - name: Configure kubectl
        run: |
          aws eks update-kubeconfig \
            --name "${{ vars.EKS_CLUSTER_NAME }}" \
            --region "${{ vars.AWS_REGION }}"

      - name: Prepare PROD manifests
        run: |
          sed -i \
            -e "s|__BACKEND_IMAGE__|${BACKEND_IMAGE}|g" \
            -e "s|__DB_NAME__|${{ vars.DB_NAME }}|g" \
            kubernetes/prod/backend.yaml

          sed -i \
            -e "s|__FRONTEND_IMAGE__|${FRONTEND_IMAGE}|g" \
            kubernetes/prod/frontend.yaml

      - name: Deploy to PROD
        run: kubectl apply -f kubernetes/prod/

      - name: Wait for deployments
        run: |
          kubectl rollout status deployment/cwvj-backend -n prod --timeout=5m
          kubectl rollout status deployment/cwvj-frontend -n prod --timeout=5m

      - name: Show deployed resources
        run: kubectl get deployments,pods,services -n prod -o wide

      - name: Smoke test PROD frontend
        run: |
          kubectl port-forward -n prod service/cwvj-frontend 18080:80 &
          PORT_FORWARD_PID=$!
          trap 'kill "$PORT_FORWARD_PID" 2>/dev/null || true' EXIT

          curl --fail --silent --show-error \
            --retry 10 --retry-connrefused \
            --max-time 10 \
            http://127.0.0.1:18080/
```

#### Explanation

```yaml
name: CWVJ Deploy | PROD

on:
  pull_request:
    types:
      - closed
    branches:
      - main

concurrency:
  group: cwvj-deploy-prod
  cancel-in-progress: false
```

- **`name`** defines the workflow's display name in the GitHub Actions UI.

- **`pull_request`** triggers the workflow in response to Pull Request activity. Unlike our DEV deployment workflow, which listens for the completion of CI, the PROD workflow listens for Pull Request events because production deployment should happen only after changes have gone through our PR-based review and approval process.

- **`types: closed`** triggers the workflow when a Pull Request is closed. This includes both merged and unmerged PRs. We distinguish between these outcomes through the job-level `if` condition.

- **`branches: main`** restricts the trigger to Pull Requests whose **target branch is `main`**. This ensures that closing or merging Pull Requests targeting other branches does not initiate our production deployment workflow.

- **`concurrency`**, **`group`**, and **`cancel-in-progress`** work exactly as explained in the DEV deployment workflow. The only difference is that we use a separate concurrency group, `cwvj-deploy-prod`, to manage production deployments independently.

  > **Production Insight:** Production deployments should not overlap or be interrupted unnecessarily. We use a dedicated concurrency group to control execution and allow an active deployment to finish before another one starts. Remember that GitHub's default concurrency behaviour still permits only **one running and one pending run** in a group. A newer pending run can replace an older pending run.

---

```yaml
jobs:
  deploy-to-prod-job:
    name: Deploy to PROD
    runs-on: ubuntu-26.04
    timeout-minutes: 20
    environment: prod

    # Deploy only when an automated DEV-approved PR is merged.
    if: >-
      github.event.pull_request.merged == true &&
      github.event.pull_request.user.login == 'github-actions[bot]' &&
      contains(github.event.pull_request.body, github.event.pull_request.head.sha)
```

- **`jobs`** defines the individual jobs that make up this workflow.

- **`deploy-to-prod-job`** is the unique identifier for our production deployment job.

- **`name`** provides the human-readable name displayed for the job in the GitHub Actions UI.

- **`runs-on: ubuntu-26.04`** selects a GitHub-hosted Ubuntu 26.04 runner, keeping the OS release consistent with our DEV deployment workflow.

- **`timeout-minutes: 20`** sets the maximum execution time for this job. If the job exceeds this limit, GitHub terminates it and marks it as failed. We allow **20 minutes** for production deployment, compared with 15 minutes for DEV.

- **`environment: prod`** associates the job with the PROD GitHub Environment. The same environment mechanism we used for DEV now provides access to **production-specific variables and secrets** and enforces the configured deployment protection rules.

  We will configure the **required production reviewer**, prevent self-review, and restrict deployment branches in Stage 14.

- **`if`** defines the conditions that must be satisfied before the production deployment job can execute. The `>-` YAML indicator folds the multiline condition into a single expression.

  All three conditions joined by **`&&`** must evaluate to `true` for the job to run.

  Let's understand each condition.

  **A. Verify that the Pull Request was merged**

  ```yaml
  github.event.pull_request.merged == true
  ```

  - **`github.event`** contains the payload of the event that triggered the workflow.
  - **`pull_request`** identifies the Pull Request object within that payload.
  - **`merged`** indicates whether the Pull Request was successfully merged.

  Since our workflow is triggered by `types: closed`, it can also run when someone simply closes a Pull Request without merging it.

  This condition ensures that **production deployment happens only when the Pull Request is actually merged into `main`**.

  **B. Verify that the Pull Request was created by our automation**

  ```yaml
  github.event.pull_request.user.login == 'github-actions[bot]'
  ```

  - **`user.login`** identifies the GitHub account that created the Pull Request.
  - **`github-actions[bot]`** is the GitHub Actions bot account.

  Remember that our Stage 12 workflow automatically creates the Pull Request after a successful DEV deployment.

  We use this condition to ensure that the PROD deployment workflow processes **Pull Requests created by our automation** rather than manually created Pull Requests.

  **C. Verify that the deployed commit is recorded in the Pull Request description**

  ```yaml
  contains(
    github.event.pull_request.body,
    github.event.pull_request.head.sha
  )
  ```

  Our Stage 12 PR creation workflow records the **exact commit SHA deployed to DEV** in the Pull Request description. Here, we verify that the recorded SHA matches the current source branch's latest commit.

  - **`github.event.pull_request.body`**: Contains the Pull Request description.
  - **`github.event.pull_request.head.sha`**: Contains the latest commit SHA of the PR's source branch.
  - **`contains()`**: Checks whether the PR description includes that commit SHA.

  **How does this help?**

  - **SHA matches:** The current source commit has been recorded as successfully deployed to DEV.
  - **SHA does not match:** New commits may have been pushed after DEV deployment. The PR description still contains the previously deployed SHA, so the condition remains `false` until the updated commit passes through DEV and the PR description is updated.

  > **Important:** An existing Pull Request automatically incorporates new commits pushed to its source branch. Therefore, a PR can contain newer changes even though those changes have not yet passed through DEV. This SHA validation prevents such changes from being promoted to PROD based on an earlier successful DEV deployment.

  > **Production Insight:** We are using the Pull Request description as a record of the **commit that successfully passed through DEV**. By comparing it with the latest source commit SHA, we ensure that our production deployment workflow does not proceed with changes that have not completed the DEV deployment process.

---

```yaml
permissions:
  contents: read
  id-token: write

steps:
  # Check out the merged main revision for production manifests.
  - name: Check out merged main
    uses: actions/checkout@v7
    with:
      ref: ${{ github.event.pull_request.merge_commit_sha }}
```

The **`permissions`** configuration and the purpose of `contents: read` and `id-token: write` have already been covered in the DEV deployment workflow. We retain the same permissions because this workflow also needs to retrieve repository contents and authenticate with AWS through OIDC.

The important difference here is how we check out the repository.

- **`Check out merged main`** identifies the step that retrieves the repository revision containing the changes merged into `main`.

- **`uses: actions/checkout@v7`** invokes the Checkout action to retrieve the repository contents onto the runner. The Checkout action itself was covered in the earlier stages.

- **`ref: ${{ github.event.pull_request.merge_commit_sha }}`** specifies the SHA of the commit resulting from the PR merge. We use this reference to retrieve the exact merged revision containing our production Kubernetes manifests.

---

**Why are we using `merge_commit_sha` instead of `head.sha`?**

The DEV and PROD workflows need to check out different commits because they serve different purposes.

- **DEV deployment:** We use `github.event.workflow_run.head_sha` to check out the exact feature branch commit that passed CI. We need its Kubernetes manifests to deploy the application to DEV.

- **PROD deployment:** After the Pull Request is merged, we need the **merged code from `main`**, including the changes integrated into the production branch. Therefore, we use `github.event.pull_request.merge_commit_sha`.

The two properties serve different purposes:

- **`github.event.pull_request.merge_commit_sha`** identifies the resulting merge commit. We use it to check out the merged production code and its Kubernetes manifests.
- **`github.event.pull_request.head.sha`** identifies the commit from the original feature branch. We use it to identify the application revision that was successfully deployed to DEV.

**Key takeaway:** `head.sha` identifies the original feature branch commit, whereas `merge_commit_sha` identifies the resulting merged revision used for production deployment.

> **Important:** We use two different commit references deliberately. `merge_commit_sha` identifies the merged revision containing our production manifests, while `head.sha` identifies the original application commit whose images were successfully deployed to DEV. With our configured squash-merge strategy, these two SHAs are expected to be different.

---

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v6
  with:
    role-to-assume: ${{ vars.AWS_EKS_DEPLOY_ROLE_ARN_PROD }}
    aws-region: ${{ vars.AWS_REGION }}
```

The purpose of this step, the AWS Credentials action, OIDC authentication, and the `aws-region` variable have already been explained in the DEV deployment workflow.

The important difference is the IAM role we assume.

- **`role-to-assume`** specifies the PROD deployment IAM role, with its ARN retrieved from the GitHub Actions variable `AWS_EKS_DEPLOY_ROLE_ARN_PROD`.

- In DEV, we used `AWS_EKS_DEPLOY_ROLE_ARN`. Here, we use a **separate production role** to maintain environment-specific AWS access.

  > **Important:** Using separate IAM roles helps establish an independent security boundary between DEV and PROD. The DEV deployment role should not be used to deploy application resources into the production namespace. The respective IAM permissions, EKS access entries, and Kubernetes RBAC configurations determine the access granted to each role.

---

```yaml
- name: Find the published image digests
  env:
    CI_SHA: ${{ github.event.pull_request.head.sha }}
  run: |
    set -euo pipefail

    SHORT_SHA="${CI_SHA::7}"

    BACKEND_DIGEST=$(aws ecr describe-images \
      --repository-name cwvj-mega-backend \
      --filter tagStatus=TAGGED \
      --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
      --output json | tr -d '"')

    FRONTEND_DIGEST=$(aws ecr describe-images \
      --repository-name cwvj-mega-frontend \
      --filter tagStatus=TAGGED \
      --query "imageDetails[?imageTags[?ends_with(@, '-${SHORT_SHA}')]].imageDigest | [0]" \
      --output json | tr -d '"')

    if [[ -z "$BACKEND_DIGEST" || "$BACKEND_DIGEST" == "null" ||
          -z "$FRONTEND_DIGEST" || "$FRONTEND_DIGEST" == "null" ]]; then
      echo "Could not find both published images for commit ${CI_SHA}"
      exit 1
    fi

    echo "BACKEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-backend@${BACKEND_DIGEST}" >> "$GITHUB_ENV"

    echo "FRONTEND_IMAGE=${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com/cwvj-mega-frontend@${FRONTEND_DIGEST}" >> "$GITHUB_ENV"
```

The image resolution process, ECR commands, JMESPath expressions, digest validation, and use of `GITHUB_ENV` have already been explained in the DEV deployment workflow.

The important difference is **the source of the commit SHA**.

- **`CI_SHA: ${{ github.event.pull_request.head.sha }}`** retrieves the full SHA of the original development commit associated with the merged Pull Request.

  In our DEV workflow, we obtained this SHA from `github.event.workflow_run.head_sha`, because the triggering event was `workflow_run`.

  Here, the triggering event is `pull_request`, so we obtain the commit SHA from `github.event.pull_request.head.sha`.

- **`SHORT_SHA="${CI_SHA::7}"`** extracts the first seven characters of the full commit SHA. This is the same short SHA that our CI workflow incorporated into the published image tags.

- **`aws ecr describe-images`** retrieves the backend and frontend image metadata from their respective ECR repositories.

- **`--query`** uses JMESPath to identify the image whose tags end with our expected commit SHA and retrieve its `imageDigest`.

- **Digest validation** ensures that both published images can be located before proceeding with production deployment.

  If either digest is missing, the script exits with a non-zero status and stops the deployment.

The remaining commands work exactly as explained in the DEV deployment workflow.

> **Production Insight:** Notice that we are not rebuilding the application images during production deployment. We retrieve the **same immutable image digests** that were successfully deployed to DEV. This preserves artifact identity and implements our **build-once, promote-the-same-artifact** approach.

---

```yaml
- name: Configure kubectl
  run: |
    aws eks update-kubeconfig \
      --name "${{ vars.EKS_CLUSTER_NAME }}" \
      --region "${{ vars.AWS_REGION }}"
```

The purpose of `aws eks update-kubeconfig` and how it configures the runner to communicate with EKS have already been explained in the DEV deployment workflow.

The same EKS cluster is used for both environments. The difference is that the AWS credentials configured earlier belong to the PROD deployment role.

The IAM role, EKS access entry, and Kubernetes RBAC configuration prepared in Stage 10 together determine whether the workflow can deploy to the **`prod` namespace**.

---

```yaml
- name: Prepare PROD manifests
  run: |
    sed -i \
      -e "s|__BACKEND_IMAGE__|${BACKEND_IMAGE}|g" \
      -e "s|__DB_NAME__|${{ vars.DB_NAME }}|g" \
      kubernetes/prod/backend.yaml

    sed -i \
      -e "s|__FRONTEND_IMAGE__|${FRONTEND_IMAGE}|g" \
      kubernetes/prod/frontend.yaml
```

The purpose of `sed -i`, the replacement expressions, and the use of `GITHUB_ENV` to pass image references between steps have already been covered in the DEV deployment workflow.

The important difference is the **environment-specific configuration and manifest location**.

- **`kubernetes/prod/backend.yaml`** points to the production backend manifest rather than the DEV backend manifest.

- **`kubernetes/prod/frontend.yaml`** points to the production frontend manifest.

- **`${BACKEND_IMAGE}` and `${FRONTEND_IMAGE}`** contain the immutable image references resolved from ECR in the previous step.

- **`${{ vars.DB_NAME }}`** retrieves the database name associated with the PROD GitHub Environment. In our configuration, this resolves to `cwvj_prod_db`.

  Since this job references `environment: prod`, GitHub Actions provides the variables configured for that environment.

> **Important:** These modifications happen only on the GitHub-hosted runner. They do not change or commit the original files in the repository. The database credentials remain in the `backend-db-secret` Kubernetes Secret created during environment preparation. The workflow substitutes only the database name, not the username or password.

> **Production Insight:** We can reuse the same application deployment structure across environments while supplying different image references and database configuration. This keeps the deployment process consistent while maintaining **environment-specific configuration and credentials**.

---

```yaml
- name: Deploy to PROD
  run: kubectl apply -f kubernetes/prod/

- name: Wait for deployments
  run: |
    kubectl rollout status deployment/cwvj-backend -n prod --timeout=5m
    kubectl rollout status deployment/cwvj-frontend -n prod --timeout=5m

- name: Show deployed resources
  run: kubectl get deployments,pods,services -n prod -o wide
```

The purpose of `kubectl apply`, `kubectl rollout status`, and `kubectl get` has already been explained in the DEV deployment workflow.

The differences are limited to the **environment-specific manifest directory and Kubernetes namespace**:

- **`kubectl apply -f kubernetes/prod/`** applies the production Kubernetes manifests.

- **`-n prod`** targets the production namespace when checking the rollout status of the backend and frontend Deployments.

- **`kubectl get deployments,pods,services -n prod -o wide`** displays the deployed resources in the production namespace.

> **Important:** Namespace creation, database Secret creation, and deployment RBAC configuration are handled separately during environment preparation. This workflow only deploys **application resources** using the permissions granted to the PROD deployment role.

---

```yaml
- name: Smoke test PROD frontend
  run: |
    kubectl port-forward -n prod service/cwvj-frontend 18080:80 &
    PORT_FORWARD_PID=$!
    trap 'kill "$PORT_FORWARD_PID" 2>/dev/null || true' EXIT

    curl --fail --silent --show-error \
      --retry 10 --retry-connrefused \
      --max-time 10 \
      http://127.0.0.1:18080/
```

The purpose of `kubectl port-forward`, background execution, process ID capture, `trap`, and the `curl` options has already been explained in the DEV deployment workflow.

The only difference is that we now target the frontend Service in the **`prod` namespace**.

**This smoke test verifies that the PROD frontend Service responds to an HTTP request.** It does not independently validate backend connectivity or database operations. Those require separate application-level testing.

> **Production Insight:** A successful Kubernetes rollout confirms that the Deployments have progressed successfully, but it does not necessarily mean the application is reachable. A smoke test adds a basic **runtime connectivity check** after deployment. In this implementation, we use port-forwarding for validation; a production release may also require testing the application through its actual ingress or load balancer endpoint.

---

**Overall PROD Deployment Flow**

```text
Automated DEV Deployment → Successful DEV Deployment and Smoke Test → Automated PR Creation → Human Review and Approval → PR Merged into main → PROD Deployment Workflow Triggered → Validate PR Merge, Author and Deployed Commit SHA → Checkout Merged main Revision → Assume PROD Deployment IAM Role through OIDC → Retrieve Existing ECR Image Digests → Prepare PROD Kubernetes Manifests → Deploy to EKS PROD Namespace → Verify Deployment Rollouts → Frontend Smoke Test → PROD Deployment Successful
```

> **Production Insight:** Our deployment strategy ensures that production receives the **same application images** that were successfully deployed to DEV. The production workflow checks out the merged revision from `main` for its Kubernetes manifests, while retrieving the original application image digests using the source commit SHA recorded in the Pull Request. This maintains **artifact consistency** while allowing production configuration to remain independently managed.

---

## Stage 14: Push, Configure and Validate the Complete Automation

In this final stage of the GitHub Actions DevSecOps Mega-Project, we will bring together the automation built across the previous stages and configure it on GitHub. We will review repository security, configure **repository governance and branch protection**, enable the required GitHub Actions permissions, establish independent access and production deployment approvals, and push our completed workflows to the default branch.

Since our event-triggered workflows must be available on the default branch, we will perform a **one-time bootstrap** before initiating the complete release process. We will then use our existing `feature/initial-ci` branch to demonstrate the journey from CI execution and automated DEV deployment to Pull Request creation, independent review, merging into `main`, and finally, production deployment.

After validating the first release, we will clean up the completed short-lived feature branch and demonstrate the **normal developer workflow** by creating a new feature branch, making a small application change, and pushing it to GitHub. This will allow us to verify that the complete automation works as intended without requiring further workflow configuration.

> **Production Insight:** The objective of this stage is to move beyond building individual workflows and establish a **repeatable, controlled release process**. Developers should be able to push changes to their feature branches and rely on the configured automation to handle CI, deployment, promotion, and production release approvals.

---

### Task 1: Review Repository Security and Configure Repository Governance

Before making the repository public, review its contents and complete Git history for sensitive information. This includes AWS credentials, database passwords, access tokens, private keys, `.env` files, and any other confidential information. Remember that deleting a sensitive file from the latest commit does not remove it from earlier commits. Any exposed credentials must be revoked or rotated, and the Git history must be cleaned before proceeding.

We will make the repository public to demonstrate GitHub Free's repository governance capabilities, including required Pull Request reviews and branch protection rules.

#### 1.1 Make the Repository Public

1. Open the repository: `CloudWithVarJosh/mega-project-demo`.
2. Go to **Settings → General**.
3. Scroll down to the **Danger Zone** section.
4. Click **Change visibility**.
5. Select **Public**, acknowledge the confirmation, and complete the visibility change.

> **Important:** A public repository makes its source code and Git history accessible to everyone. Anyone can also fork the repository, and its GitHub Actions workflow history and logs become publicly visible. Complete the security review before changing visibility.

---

#### 1.2 Verify the `protect-main` Ruleset

1. Go to **Settings → Rules → Rulesets**.
2. Open the existing `protect-main` ruleset.
3. Verify that its **Enforcement status** is set to `Active` and that its target branch is `main`.
4. Verify that the following protections are configured:
   - Require a Pull Request before merging.
   - Require at least one approving review.
   - Dismiss stale Pull Request approvals when new commits are pushed.
   - Require approval of the most recent reviewable push.

5. We will configure the required CI status checks once they become available. After the first CI execution in Task 4, return to the ruleset, enable **Require status checks to pass before merging**, and select the actual check names reported by our CI workflow. Complete this configuration before merging the Pull Request in Task 5.

Also verify that **squash merging** is enabled:

1. Go to **Settings → General**.
2. Scroll down to **Pull Requests**.
3. Ensure **Allow squash merging** is enabled.
4. If the `protect-main` ruleset restricts merge methods, ensure squash merging is permitted.

> **Important:** `main` is our **production code line**. These rules ensure that changes cannot be introduced directly into it without going through the required review and validation process.

---

#### 1.3 Add the Independent Reviewer as a Collaborator

We will use a separate GitHub account to demonstrate independent Pull Request review and approval. For this demonstration, we will use our personal GitHub account, `varunjoshi0404`, while `cloudwithvarjosh` remains the repository owner.

> **Note:** You will need access to two separate GitHub accounts to demonstrate independent code review. If you only have one account, you can invite another GitHub user who has access to a separate account.

Using the repository owner account, `cloudwithvarjosh`:

1. Navigate to **Settings → Collaborators**.
2. Click **Add people**.
3. Search for the GitHub username `varunjoshi0404`.
4. Select the correct account and click **Add to repository**.
5. Grant **Write access** if prompted and send the invitation.

The invitation is now sent to the personal GitHub account.

**Accept the invitation using the personal account:**

1. Sign out of `cloudwithvarjosh` and sign in using `varunjoshi0404`.
2. Check the email account associated with `varunjoshi0404`. You should receive an email notification from GitHub about the repository invitation.
3. Alternatively, search for the repository `cloudwithvarjosh/mega-project-demo` on GitHub and open it.
4. Click **View invitation** when the invitation is displayed.
5. Review the invitation and click **Accept invitation**.

**Verify collaborator access using the repository owner account:**

1. Sign back in using `cloudwithvarjosh`.
2. Navigate to **Settings → Collaborators**.
3. Verify that `varunjoshi0404` appears in the collaborator list with **Write access** and that the invitation is no longer pending.

The personal account is now available as an independent reviewer for Pull Requests targeting `main`. We will use it later when reviewing and approving the automatically created Pull Request.

> **Important:** Pull Request approvals required by our branch protection rules must come from reviewers with **Write access**. Simply sending a collaborator invitation is not sufficient. Ensure the invitation has been accepted and the account has the appropriate repository access.

---

### Task 2: Configure GitHub Actions Permissions and PROD Environment Protection

Our reusable Pull Request workflow uses the automatically provided `GITHUB_TOKEN` through the GitHub CLI to create and update Pull Requests. Although we have already configured the required token permissions in our reusable workflow and its calling job, GitHub has an additional repository-level setting that controls whether Actions can create Pull Requests using this token.

We also need to configure the `prod` GitHub Environment to introduce an independent approval gate before production deployment. This ensures that **merging code into `main` and authorising a production deployment remain two separate decisions**.

---

#### 2.1 Allow GitHub Actions to Create Pull Requests

1. Open the repository: `CloudWithVarJosh/mega-project-demo`.
2. Navigate to **Settings → Actions → General**.
3. Scroll down to the **Workflow permissions** section.
4. Enable **Allow GitHub Actions to create and approve pull requests**.
5. Click **Save**.

> **Important:** The `pull-requests: write` permission configured in our workflow determines what the `GITHUB_TOKEN` can access. This repository-level setting separately allows Actions to use that token to create and approve Pull Requests. Both configurations are required for our automated PR creation to work. Our workflow only creates or updates PRs; review, approval, and merging remain human responsibilities.

---

**2.2 Configure the PROD GitHub Environment**

Our PROD deployment workflow references the `prod` GitHub Environment using `environment: prod`. We will use its protection rules to introduce a separate approval gate before the production deployment can proceed.

1. Navigate to **Settings → Environments**.
2. Open the existing `prod` environment.
3. Under **Deployment protection rules**, configure the following:

   - **Required reviewers:** Add `CloudWithVarJosh` as the required reviewer. This account will approve the **production deployment**, not the Pull Request itself.

     The Pull Request is reviewed and merged separately using the `varunjoshi0404` account. When this account merges the PR, the `pull_request: closed` event triggers the PROD workflow. The workflow then pauses at the environment approval gate until `CloudWithVarJosh` approves the pending deployment.

   - **Prevent self-review:** Enable this option to ensure that the account that initiated the workflow run cannot approve its own deployment. In our demonstration, this means `varunjoshi0404` cannot approve the production deployment.

   - **Allow administrators to bypass configured protection rules:** Disable this option by deselecting it, ensuring that administrators cannot bypass the configured deployment approval requirement.

4. Under **Deployment branches and tags**, select **Selected branches and tags**.
5. Add the following allowed reference:

   `refs/pull/*/merge`

6. Save the protection rules.

> **Important:** When initially configuring the PROD environment during an earlier stage, I deliberately added `main` as an allowed deployment branch. However, let's understand why we don't need it for our current implementation.
>
> We are not deploying to PROD through a workflow triggered by a direct push to `main`. Our deployment workflow is triggered by a `pull_request: closed` event targeting `main`. For environment deployment restrictions, GitHub evaluates the **execution reference** of this PR-triggered workflow, which is `refs/pull/<PR_NUMBER>/merge`, rather than the source branch or the target branch.
>
> Therefore, we only need `refs/pull/*/merge` in the PROD Environment's allowed deployment references. The `branches: main` condition in our PROD workflow already ensures that only Pull Requests targeting `main` can trigger this workflow.

---

**Why are we using two different GitHub accounts?**

There are **three activities** in our production release process:

- **PR review and approval:** `varunjoshi0404` independently reviews and approves the Pull Request.
- **PR merge:** Both accounts technically have permission to merge the approved PR into `main`.
- **Production deployment approval:** `cloudwithvarjosh` approves the deployment through the `prod` GitHub Environment.

> **Important:** The account that merges the PR triggers the PROD workflow through the `pull_request: closed` event. Since we have enabled **Prevent self-review**, that same account cannot approve the resulting production deployment.
>
> Therefore, based on our current configuration, **`varunjoshi0404` must merge the PR** so that `cloudwithvarjosh` can independently approve the production deployment. If `cloudwithvarjosh` merges the PR, they trigger the PROD workflow but cannot approve its deployment because we have enabled **Prevent self-review** in the `prod` environment. Since `cloudwithvarjosh` is also our **only configured required reviewer**, the deployment will remain pending until an eligible reviewer is available.

> **Production Insight:** GitHub Environments provide an additional approval gate between a successful code merge and an actual production deployment. This allows us to enforce **independent release authorisation**, even after the code has passed CI and received the required Pull Request approval.

---

### Task 3: Observe the Default Branch Requirement and Bootstrap the Completed Workflows

We have now completed the DEV deployment, automated PR creation, and PROD deployment workflows locally. Before demonstrating the complete release process, we need to make these workflow definitions available on our GitHub repository's default branch, `main`.

Rather than pushing directly to `main immediately`, we will first push our completed changes to the existing `feature/initial-ci` branch and observe how GitHub Actions behaves. This will help us understand an important requirement associated with the **default branch**.

---

#### 3.1 Commit and Push the Completed Changes to the Feature Branch

We will continue using our existing `feature/initial-ci` branch, which we have been using throughout the project.

From your project directory, execute the following commands:

```bash
# 1. Verify the current branch and working tree.
git status
git branch --show-current

# 2. Stage the completed project changes.
git add .

# 3. Review the files staged for commit.
git diff --cached --name-only

# 4. Review the staged changes before committing.
git diff --cached

# 5. Commit the completed deployment automation.
git commit -m "Deploy: Complete DEV and PROD deployment automation"

# 6. Push the feature branch to GitHub.
git push origin feature/initial-ci
```

> **Important:** Before committing, ensure that the DEV and PROD database Secret manifests contain only placeholder passwords, not actual database credentials. Never commit real credentials, access keys, or other sensitive information.

---

#### 3.2 Observe the GitHub Actions Execution

After pushing the feature branch:

1. Open the repository on GitHub.
2. Navigate to the **Actions** tab.
3. Locate the workflow runs associated with the latest push.

You should observe that only our **`CWVJ CI | Build, Scan and Publish`** workflow executes. The DEV deployment workflow will not run, even though its YAML file is present in our feature branch.

This is expected behaviour. Let's understand why.

---

#### 3.3 Why Are the Other Workflows Not Visible?

Currently, the **Actions** tab shows only `CWVJ CI | Build, Scan and Publish` because it is the only workflow we have added to `main`. The remaining workflows are still on `feature/initial-ci`.

- **DEV deployment (`02-deploy-dev.yaml`):** Uses `workflow_run`, which requires the downstream workflow file to exist on the **default branch (`main`)** before it can be triggered.
- **Reusable PR (`03-create-pr.yaml`):** Uses `workflow_call` and is not triggered independently. It runs only when called by the DEV deployment workflow. Since the DEV workflow is not running yet, this workflow is not being called either.
- **PROD deployment (`04-deploy-prod.yaml`):** Uses `pull_request: closed`. Unlike `workflow_run`, this event has no equivalent documented default-branch-only restriction. We will exercise it when our Pull Request is merged into `main`.

> **Our Project:** Once all workflows are complete, we will temporarily disable branch protection on `main`, push the completed workflows and project changes directly to it, and then re-enable branch protection. We can then demonstrate the complete CI-to-DEV-to-PROD pipeline.

> **Production Insight:** In an established repository, these workflow definitions would normally be introduced through the **standard Pull Request review and merge process** and already be available in `main` before subsequent feature, bugfix, and hotfix changes go through the deployment workflow.

---

#### 3.4 Configure the Required CI Status Checks

Our `protect-main` ruleset already requires Pull Request reviews, but we also want to ensure that CI succeeds before changes can be merged into `main`.

The feature branch push we just performed should have generated the actual CI check names. We can now use these names to configure required status checks.

1. Navigate to **Settings → Rules → Rulesets**.
2. Open the existing `protect-main` ruleset.
3. Under **Branch rules**, enable **Require status checks to pass before merging**.
4. Add the relevant check names generated by our successful CI workflow.
5. Save the ruleset.

Do not guess or manually construct the check names. Select the actual checks reported by GitHub Actions.

> **Important:** Once configured, GitHub will require these **CI status checks to pass** before a Pull Request can be merged into `main`. We will **verify that these protections are enforced** when we review and merge our demonstration Pull Request.

---

#### 3.5 Bootstrap the Completed Workflows into `main`

Now that we understand why the DEV deployment workflow did not execute, we can resolve the issue by making all completed workflow definitions available on the default branch.

Since our `protect-main` ruleset prevents direct pushes, we will temporarily disable its enforcement for this one-time bootstrap.

1. Navigate to **Settings → Rules → Rulesets**.
2. Open the existing `protect-main` ruleset.
3. Change its **Enforcement status** from `Active` to `Disabled`.
4. Save the changes.

With the ruleset temporarily disabled, push the current feature branch commit to the remote `main` branch.

From your project directory, execute:

```bash
# Push the current feature branch commit to the remote main branch.
git push origin HEAD:main
```

This updates remote `main` to the commit currently checked out in your local repository. The push must be a valid fast-forward update. If Git rejects it because the remote branch has advanced, reconcile the branch history first. Do not use `--force` to bypass the restriction.

Once the push succeeds, immediately restore the `protect-main` ruleset:

1. Navigate back to **Settings → Rules → Rulesets**.
2. Open `protect-main`.
3. Change its **Enforcement status** back to `Active`.
4. Save the changes.

Finally, open the remote `main` branch and verify that the completed workflow files are available:

- `.github/workflows/01-ci.yaml`
- `.github/workflows/02-deploy-dev.yaml`
- `.github/workflows/03-create-pr.yaml`
- `.github/workflows/04-deploy-prod.yaml`

Also verify that the supporting Kubernetes manifests are present under `kubernetes/dev/` and `kubernetes/prod/`.

> **Important:** Disabling `protect-main` is a **temporary exception for this initial bootstrap only**. Re-enable it immediately after the push. We are **not establishing direct pushes to `main` as our normal development practice**. All subsequent application and workflow changes will follow our configured **Pull Request process**.

**Expected Outcome:** All completed workflow definitions and their supporting Kubernetes manifests are now available in the remote `main` branch. The `protect-main` ruleset is **active again**, and GitHub is ready to execute the complete automation.

> **Important:** The earlier CI run will **not be replayed automatically** just because we have now added the DEV deployment workflow to `main`. The `workflow_run` event has already occurred. In the next task, we will push a **fresh commit** to the existing `feature/initial-ci` branch. This will trigger a new CI execution, and GitHub will now be able to find and execute the DEV deployment workflow from the **default branch**.

---

#### 3.6 Trigger the CI and DEV Deployment Workflows

Now that all completed workflow definitions are available in `main` and the `protect-main` ruleset is active again, we can trigger the automation with a fresh commit.

Our CI workflow uses both **branch filters and path filters**. Therefore, the new commit must target a supported branch and modify at least one file matching the configured `paths` filters.

1. Switch to the existing feature branch and make a small, harmless change to a file under `frontend/` or `backend/`. For example, update a text element in the frontend.

   > **Important:** Do not modify only files outside the CI workflow's configured `paths` filters, such as the root `README.md`, because the CI workflow may not be triggered.

2. Review, commit, and push your changes:

   ```bash
   # Switch to the existing feature branch.
   git switch feature/initial-ci

   # Review the changes before committing.
   git status
   git diff

   # Stage the modified file (replace with the actual file path).
   git add <changed-file>

   # Commit the changes.
   git commit -m "chore: trigger CI after workflow bootstrap"

   # Push the new commit to the remote feature branch.
   git push origin feature/initial-ci
   ```

3. Navigate to **Actions** in GitHub and verify the execution:
   - **CI workflow:** The fresh push triggers `01-ci.yaml` on `feature/initial-ci`.
   - **DEV deployment workflow:** After CI completes successfully, GitHub triggers `02-deploy-dev.yaml` from the default branch.
   - **Reusable PR workflow:** After the DEV deployment and application smoke tests succeed, the DEV workflow invokes `03-create-pr.yaml` to create a Pull Request targeting `main`.

**Expected Outcome:** The fresh push triggers CI, followed by the DEV deployment. Once the deployment and smoke tests succeed, the automation **creates a Pull Request targeting `main`**.

---

#### 3.7 Observe and Fix the DEV Deployment Failure

After pushing the new commit, the CI workflow completed successfully and triggered our DEV deployment workflow. However, the **Deploy to DEV** job failed.

1. Navigate to **Actions** in GitHub and open the failed `CWVJ Deploy | DEV` run.

2. Under **Annotations**, you will find the following error:

   `Branch "main" is not allowed to deploy to dev due to environment protection rules.`

   **Why did this happen?**

   Our CI workflow ran on `feature/initial-ci`, but GitHub handles workflows triggered by `workflow_run` differently. It runs the downstream workflow using the **default branch (`main`) as its branch reference**.

   Our `dev` GitHub Environment only allows deployments from selected branches, and `main` was not included. GitHub therefore blocked the deployment.

   > **Important:** This does not mean we are deploying application code from `main`. Our DEV workflow still checks out the exact commit from the original CI run using `github.event.workflow_run.head_sha`. We only need to allow `main` in the environment settings.

    > **Remember:** This is also why, in the code checkout section of `02-deploy-dev.yaml`, we explicitly set `ref: ${{ github.event.workflow_run.head_sha }}`. Since GitHub runs the downstream workflow using `main` as its branch reference, we use this expression to ensure that **the application code is checked out from the original feature-branch commit**, not from `main`. The environment rule controls which branch is allowed to deploy; the checkout reference controls which application code gets deployed.

3. Update the DEV environment's allowed deployment branches:

   - Navigate to **Settings → Environments**.
   - Open the `dev` environment.
   - Under **Deployment branches and tags**, select **Selected branches and tags**.
   - Add `main` to the allowed branches.
   - Save the protection rules.

4. Return to the failed DEV workflow run and select **Re-run all jobs** to retry the deployment with the updated environment rules.

**Expected Outcome:** The DEV deployment job should now be allowed to proceed. The workflow will check out the original feature-branch commit and continue with the DEV deployment.

---

### Task 4: Review and Merge the Pull Request

Once the DEV deployment, automated PR creation, and PROD deployment workflows are configured and pushed to GitHub, we will perform a fresh end-to-end demonstration using a feature branch.

The automated PR creation workflow will open a Pull Request targeting `main` after the application has been successfully deployed to DEV.

---

#### 4.1 Review the Pull Request

1. Sign in to GitHub using the personal account `varunjoshi0404`.
2. Open the repository and navigate to the **Pull requests** tab.
3. Open the Pull Request automatically created by our GitHub Actions workflow.
4. Verify that the source branch is the expected development branch and the target branch is `main`.
5. Open the **Files changed** tab and review the proposed changes.
6. Review the associated commits and confirm that the PR description contains the commit SHA successfully deployed to DEV.
7. Verify that the required CI status checks have passed and that all repository protection requirements are satisfied.

**Why is Pull Request review important?**

A Pull Request is more than just a mechanism for merging code. It provides an opportunity for another developer to **review, understand, and validate the proposed changes** before they become part of the production code line.

The reviewer can approve the changes, request modifications, or provide feedback. The objective is to ensure that the proposed changes meet the required standards for **correctness, security, maintainability, and production readiness**.

In our current project, most of the changes being reviewed are infrastructure-related, including **GitHub Actions workflow YAMLs, deployment configurations, and Kubernetes manifests**. We are setting up the repository and its release automation, rather than introducing significant application-level changes.

In a regular application development environment, this same process would be used to review actual application code changes. **Senior developers and designated reviewers** would examine the implementation, identify potential issues, and ensure that the changes meet the team's engineering standards before approving them.

---

#### 4.2 Approve and Merge the Pull Request

1. Open the **Review changes** option.
2. Select **Approve** and submit the review.
3. Once all required checks and approvals are satisfied, select **Squash and merge**.
4. Confirm the merge into `main`.

> **Important:** We are using `varunjoshi0404` to perform the independent Pull Request review, separate from the account that pushed the changes. This demonstrates how **independent code review** helps prevent unreviewed changes from entering the production code line.

> **Production Insight:** Our release process has **two separate human approval gates**:
>
> - **Pull Request approval:** A reviewer examines the proposed changes, understands the implementation, and approves them before they are merged into `main`. This helps ensure that changes meet the required engineering standards and are suitable for the production code line.
> - **PROD Environment approval:** After the PR is merged, the PROD deployment workflow reaches the `prod` GitHub Environment and waits for an authorised reviewer to approve it. This approval allows the workflow job to proceed and access the **production environment's protected secrets**, such as deployment credentials, database passwords, and other sensitive configuration required for production operations.
>
> **Why is this important?** Even after code has been reviewed and merged, we do not want every workflow execution to automatically gain access to production resources and credentials. An additional approval ensures that **production access is explicitly authorised before the deployment job proceeds**. This protects sensitive production resources from accidental deployments and unauthorised workflow execution.
>
> In our implementation, `varunjoshi0404` independently reviews and merges the Pull Request, while `cloudwithvarjosh` approves the subsequent PROD deployment through the GitHub Environment. With **Prevent self-review** enabled, the account that initiates the deployment cannot approve that same deployment.

---

### Task 5: Validate the PROD Deployment

Once the production deployment is approved through the `prod` GitHub Environment, the workflow will resume and execute the remaining deployment steps. We will verify that the application has been successfully deployed to Amazon EKS and that the expected container images are running.

---

#### 5.1 Verify the Deployment in GitHub Actions

1. Navigate to the repository's **Actions** tab.
2. Open the latest `CWVJ Deploy | PROD` workflow run.
3. Verify that the deployment completed successfully, including both rollout checks and the automated frontend smoke test.
4. Review the logs to confirm that the backend and frontend images were retrieved from ECR using their **immutable digests**.

---

#### 5.2 Verify the Application in Amazon EKS

Connect to the EKS cluster and verify the resources deployed in the `prod` namespace:

```bash
kubectl get deployments,pods,services -n prod -o wide
```

**Verify the following:**

1. **Verify Deployment and Pod Health:** Confirm that both backend and frontend Deployments have their desired number of replicas available, all Pods are in the `Running` state, and their readiness checks are passing.

2. **Verify Container Images:** Confirm that the expected **digest-based images** are deployed:

   ```bash
   kubectl get pods -n prod \
     -o custom-columns=NAME:.metadata.name,READY:.status.containerStatuses[*].ready,IMAGE:.spec.containers[*].image
   ```

3. **Verify Frontend Service and NodePort:** Check the frontend Service and its NodePort configuration:

   ```bash
   kubectl get service cwvj-frontend -n prod -o wide
   kubectl get endpoints cwvj-frontend -n prod
   ```

   Confirm that the frontend Service is of type `NodePort`, exposes port **30081 (PROD)**, and has healthy endpoints associated with the frontend Pods.

4. **Configure Worker Node Security Group:** Identify the **public IP address** of any accessible EKS worker node from the Amazon EC2 console. Locate the security group associated with the EKS worker nodes (typically named `eks-cluster-sg-cwvj-mega-demo-eks-1221592647`).

   Under **Inbound rules**, allow the following **TCP ports**:

   - **30080:** DEV application NodePort.
   - **30081:** PROD application NodePort.

   You can restrict the **Source** to **your public IP address (/32)** rather than allowing access from anywhere (`0.0.0.0/0`).

5. **Access the Production Application:** Open the production application in a browser using the following URL:

   ```text
   http://<WORKER-NODE-PUBLIC-IP>:30081
   ```

   Verify that the **frontend application loads successfully** and that the user management interface is accessible.

6. **Perform End-to-End Application Testing:** Verify application functionality by performing the following **CRUD operations**:
   - **Create:** Create a new user.
   - **Read:** Retrieve and view the user record.
   - **Update:** Modify the user's details.
   - **Delete:** Delete the user record.

   Verify that the frontend successfully communicates with the backend API and that the corresponding **database operations** complete successfully.

7. **Inspect Backend Logs:** Finally, inspect the backend logs for any application or database connectivity errors:

   ```bash
   kubectl logs deployment/cwvj-backend -n prod --tail=50
   ```

> **Expected Outcome:** The PROD workflow completes successfully, the application is running in the `prod` namespace, and the **same immutable container images** used in DEV are deployed to production. The frontend application is accessible through the **NodePort Service**, backend connectivity is established, and database operations are successfully verified through end-to-end CRUD testing.

> **Production Insight:** A successful deployment is more than applying Kubernetes manifests or getting healthy Pods. We must also verify **artifact identity, application availability, service accessibility, and end-to-end functionality** to establish confidence in a production release.

---

### Task 6: Clean Up the Completed Feature Branch

Now that the production deployment has been successfully completed, we can clean up the feature branch used for this release.

In our branching strategy, `feature/*`, `bugfix/*`, and `hotfix/*` branches are intended to be **short-lived branches**. They exist to isolate individual changes while development, testing, and review are in progress. Once the changes have been merged into `main` and the release is complete, these branches should be deleted.

This keeps the repository clean, avoids accumulating stale branches, and ensures that future development starts from the latest `main` branch.

---

#### 6.1 Delete the Remote Feature Branch

1. Open the merged Pull Request in GitHub.
2. Scroll to the bottom of the Pull Request.
3. Click **Delete branch** to remove the remote `feature/initial-ci` branch.

> **Important:** Deleting the remote branch does not delete your local copy. We need to remove the local branch separately.

---

#### 6.2 Delete the Local Feature Branch

Switch to `main` and synchronize your local repository with the remote before removing the completed feature branch.

Execute the following commands from your project directory:

```bash
# 1. Switch to the main branch.
git switch main

# 2. Synchronize local main with the remote.
git pull origin main

# 3. Remove stale remote-tracking references.
git fetch --prune

# 4. Delete the completed local feature branch.
git branch -D feature/initial-ci

# 5. Verify the remaining local branches.
git branch
```

**Why are we using `git branch -D` instead of `git branch -d`?**

We are using **squash merging** in our project. With squash merging, Git creates a new commit on `main` containing the combined changes rather than merging the original feature branch history. As a result, Git may not recognise the original feature branch commits as merged when using `git branch -d`.

Since we have already verified that the Pull Request was successfully merged and the changes are present in `main`, we can safely remove the local branch reference using `-D`.

> **Important:** Use `git branch -D` only after confirming that the branch's required changes have been merged and are available in `main`. It force-deletes the local branch reference, so do not use it to discard unmerged work.

**Expected Outcome:** The remote and local `feature/initial-ci` branches are deleted. Our repository retains `main` as the production code line, ready for the next development cycle.

> **Production Insight:** Short-lived feature, bugfix, and hotfix branches help teams keep development isolated and organised. Once their changes are reviewed, merged, and released, deleting them reduces repository clutter and encourages developers to create new branches from the latest `main`.

---

### Task 7: Demonstrate the Normal Developer Workflow

With the complete automation configured and validated, we can now demonstrate how developers will use it during their regular development cycle.

We will create a new feature branch from the latest `main`, make a small application change (for this demonstration, we will simply add a comment to an existing application file), and push the changes to GitHub.

Unlike our initial bootstrap, we will not need to modify or configure any GitHub Actions workflows. The existing automation will automatically handle CI, DEV deployment, and Pull Request creation. After the required human review, approval, and merge, the PROD deployment workflow will take over.

---

#### 7.1 Create a New Feature Branch

From your project directory, execute:

```bash
# 1. Switch to the main branch.
git switch main

# 2. Synchronize local main with the remote.
git pull origin main

# 3. Create a new feature branch from the latest main.
git switch -c feature/normal-developer-workflow
```

We create the new branch from the latest `main` to ensure that our changes are based on the most recent version of the production code line.

---

#### 7.2 Make and Push an Application Change

For this demonstration, make a harmless change to an existing application file, such as adding a code comment. This gives us a new commit to trigger the automation without changing the application's actual functionality.

Once the change is made, execute:

```bash
# 1. Review the modified files.
git status

# 2. Review the changes before committing.
git diff

# 3. Stage the modified application file.
# Replace the path with the file you modified.
git add <path-to-modified-file>

# 4. Commit the change.
git commit -m "Demonstrate normal developer workflow"

# 5. Push the feature branch to GitHub.
# The -u option establishes the upstream tracking relationship.
git push -u origin feature/normal-developer-workflow
```

---

#### 7.3 Observe the End-to-End Automation

Once the feature branch is pushed, navigate to the repository's **Actions** tab and observe the complete release process.

The following sequence should take place:

`Feature Branch Push → CI → DEV Deployment → Smoke Test → Automated PR Creation → Human Review and Merge → PROD Deployment Approval → PROD Deployment`

We have already covered the individual workflow executions, review requirements, and approval gates in the previous tasks. Here, the objective is to observe how they work together without any additional workflow configuration.

**Expected Outcome:** A new application change successfully travels through our complete release process, from a feature branch to production. CI, DEV deployment, and PR creation execute automatically, while the required human approvals govern promotion into `main` and the subsequent production deployment.

> **Production Insight:** This is how a developer should interact with a well-configured CI/CD workflow in an established engineering environment. Developers focus on **writing code and pushing changes**, while the automation handles building, testing, security scanning, deployment, and release preparation. Human approvals remain in place at critical stages to maintain control over changes entering the production code line and being released to production.

---

## Further Exploring and Evolving the Project

Before we conclude, I want to emphasize that **the project we have built is already a production-grade DevSecOps and Continuous Delivery implementation within its intended scope**. We have incorporated several engineering practices commonly used in production environments, covering **CI/CD automation, security, quality gates, artifact management, AWS authentication, Kubernetes deployments, and controlled production releases**.

However, there is always room to improve. **Nothing is perfect, and there is no single definition of the best production environment.** Architecture and engineering decisions depend on application requirements, infrastructure scale, security policies, availability objectives, operational complexity, and cost.

Since the primary focus of this project is **GitHub Actions**, I have tried to cover its integration with other important technologies while bringing in relevant best practices from **AWS, Kubernetes, DevSecOps, and cloud infrastructure**. It is simply not possible to demonstrate every tool, technology, and production practice in one project without losing focus.

The following suggestions are therefore **not gaps or mandatory additions** to consider our implementation production-grade. Think of them as possible directions in which you can take this project further. Explore them based on your requirements, and understand the trade-offs before introducing additional tools.

I hope this project gives you a strong foundation, helps you approach **technical interviews with confidence**, and proves useful when working on **real-world production environments**.

> **Note:** The enhancements listed here are **indicative, not exhaustive**. There are many other improvements, tools, and technologies that you can explore depending on your application's requirements and environment. Consider this list a **starting point**, and don't hesitate to explore additional approaches that can further improve your infrastructure and application.d


---

**1. Introduce Kustomize or Helm for Kubernetes Deployments**

- **Kustomize:** Introduce a common Kubernetes base with **environment-specific overlays** for DEV and PROD. This reduces duplicated manifests and eliminates manual placeholder replacements.
- **Helm:** Package Kubernetes resources into **reusable, versioned charts** with configurable values, making application deployment and configuration management easier across multiple environments.

> **Production Insight:** Both Kustomize and Helm help manage Kubernetes configurations, but they approach the problem differently. **Kustomize** is particularly useful when you want to maintain standard YAML manifests with environment-specific overlays, whereas **Helm** provides templating and package management capabilities. Choose based on your application's complexity and deployment requirements.

---

**2. Introduce GitOps Using Argo CD**

- Replace direct Kubernetes deployments through `kubectl apply` with a **GitOps-based deployment model**, where Git becomes the **source of truth** for the desired cluster state.
- Introduce **Argo CD** for automated synchronization, configuration drift detection, self-healing, and environment-based application deployments.

> **Production Insight:** GitOps is a natural continuation of this project. We have already established the **CI and artifact publishing foundation**. In the next mega-project, we can extend this implementation using Argo CD and explore how **GitHub Actions and GitOps complement each other**.

---

**3. Introduce Self-Hosted GitHub Actions Runners**

- Deploy **ephemeral self-hosted runners** within AWS to enable secure connectivity to private infrastructure, including private EKS API endpoints and internal services.
- Explore **Actions Runner Controller (ARC)**, runner scale sets, dedicated runner groups, and automated runner provisioning to manage execution environments.

> **Production Insight:** Self-hosted runners provide greater control over the execution environment but also introduce additional responsibilities around **security, patching, scaling, and maintenance**. Prefer **ephemeral runners** for isolated execution, particularly when handling sensitive deployment workloads. Avoid running untrusted pull request code on privileged runners.

Reference: [GitHub Self-Hosted Runners](https://docs.github.com/en/actions/reference/runners/self-hosted-runners)

---

**4. Improve Kubernetes Scalability and Availability**

- Introduce **Horizontal Pod Autoscaler (HPA)** to automatically scale application Pods based on workload metrics, and **PodDisruptionBudgets (PDBs)** to help maintain application availability during voluntary disruptions.
- Explore node autoscaling using **Karpenter or Kubernetes Cluster Autoscaler** to dynamically provision and remove worker nodes based on workload requirements and available cluster capacity.

> **Production Insight:** Remember that these components solve different problems. **HPA scales application Pods**, **Karpenter and Cluster Autoscaler manage worker-node capacity**, while **PDBs help protect application availability** during voluntary disruptions. These mechanisms complement each other and should be configured according to workload requirements.

Reference: [Amazon EKS Cluster Autoscaling Best Practices](https://docs.aws.amazon.com/eks/latest/best-practices/cluster-autoscaling.html)

---

**5. Strengthen Secrets Management**

- Integrate **AWS Secrets Manager or HashiCorp Vault** to centrally manage sensitive information such as database passwords, API keys, and application credentials instead of manually maintaining static credentials in Kubernetes Secrets.
- Integrate the **Secrets Store CSI Driver and AWS Secrets and Configuration Provider (ASCP)** to retrieve and mount secrets into Pods, or use **External Secrets Operator** to synchronize secrets from an external secrets manager into Kubernetes Secret resources.

> **Production Insight:** Kubernetes Secrets provide a Kubernetes-native mechanism for storing sensitive configuration, but they should not automatically be treated as a complete secrets-management solution. An external secrets manager provides **centralized storage, access control, and rotation capabilities**. Use **IAM Roles for Service Accounts (IRSA)** or **EKS Pod Identity** to restrict which workloads can retrieve specific secrets.

References: [AWS Secrets Manager with EKS](https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrate_eks.html), [External Secrets Operator](https://external-secrets.io/)

---

**6. Strengthen Container Supply Chain Security**

- Generate a **Software Bill of Materials (SBOM)** for each container image to maintain visibility into its components, libraries, and dependencies.
- Introduce container image signing using **Cosign or AWS Signer**, along with **build provenance and signature verification** before deployment.

> **Production Insight:** Vulnerability scanning tells us about **known security issues**, while image signing helps establish **artifact authenticity** and provenance helps establish **where and how an artifact was built**. These are complementary supply-chain security controls. You can also enable **Amazon ECR Enhanced Scanning** through Amazon Inspector to continuously identify newly discovered vulnerabilities in published images.

Reference: [Amazon ECR Enhanced Scanning](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning-enhanced.html)

---

**7. Introduce Infrastructure as Code**

- Use **Terraform or AWS CDK** to provision infrastructure components such as VPCs, subnets, security groups, EKS, RDS, IAM roles, and ECR repositories.
- Maintain infrastructure configurations in **version control**, enabling repeatable deployments, consistent environments, and controlled infrastructure changes.

> **Production Insight:** Infrastructure as Code makes infrastructure easier to **reproduce, review, maintain, and version**. You can also introduce **remote state management, infrastructure change plans, drift detection, and separate configurations for DEV and PROD**. Avoid adopting IaC simply for the sake of using another tool; focus on making infrastructure changes predictable and repeatable.

---


**8. Enhance Application Testing and Validation**

- Introduce **integration testing** using tools such as **Testcontainers** to validate backend interactions with PostgreSQL and other application dependencies.
- Extend application smoke tests using **Playwright or API testing tools** to validate complete user journeys, backend connectivity, database operations, and application functionality after deployment.

> **Production Insight:** Designing and maintaining **unit, integration, and end-to-end tests is predominantly the responsibility of application development teams**. DevOps and platform teams enable these tests within CI/CD workflows and establish the necessary quality gates.
>
> In our project, we initially configured SonarQube Quality Gates with an **80% code coverage threshold** for both applications. We later reduced it to **60% for the backend and 40% for the frontend** to demonstrate how changing Quality Gate thresholds affects pipeline execution. This was a **demonstration-specific adjustment**, not a recommended production practice.
>
> In production, **do not lower quality thresholds simply to make pipelines pass**. Establish coverage requirements based on application complexity, risk, and engineering standards, and improve the test suite to meet those requirements. Remember that **code coverage alone does not guarantee effective testing or application quality**.

---

**9. Introduce Observability and Monitoring**

- Integrate **Amazon CloudWatch Container Insights** for monitoring EKS workloads, resource consumption, application logs, and cluster health.
- Introduce **centralized logging, distributed tracing using OpenTelemetry, application metrics, dashboards, and actionable alerts** to improve troubleshooting and operational visibility.

> **Production Insight:** Monitoring tells us whether individual resources are healthy, while **observability helps us understand why an application behaves in a particular way**. Consider defining **Service Level Indicators (SLIs), Service Level Objectives (SLOs), and meaningful alerts** rather than simply collecting metrics and logs without an operational purpose.

---

**10. Explore Advanced Deployment Strategies**

- Introduce **Blue-Green and Canary deployments** to gradually expose application changes to users while reducing deployment risk.
- Implement **automated deployment verification, health-based promotion, and rollback strategies** to improve release reliability.

> **Production Insight:** Rolling updates are sufficient for many applications, but systems with stricter availability requirements may benefit from **progressive delivery strategies**. Evaluate deployment approaches based on application architecture, traffic patterns, database migration compatibility, and acceptable release risk. Tools such as **Argo Rollouts and Flagger** can help implement advanced deployment strategies.

---

## Conclusion

We have now completed the **GitHub Actions Production-Grade DevSecOps and Continuous Delivery Mega-Project**, building an end-to-end workflow that takes an application change from a development branch through CI validation and controlled production deployment.

Throughout this project, we have implemented **automated builds and testing, code quality analysis, security scanning, container image publishing, and Kubernetes deployments**. We have also established secure GitHub Actions access to AWS using **OIDC and dedicated IAM roles**, configured **EKS access entries and Kubernetes RBAC**, and separated DEV and PROD deployment environments.

One of the key engineering principles demonstrated throughout this implementation is **Build Once, Promote the Same Artifact**. We build and scan our container images once, publish them to Amazon ECR, and use their **immutable image digests** to promote the exact same artifacts across DEV and PROD. This maintains artifact identity throughout the release process.

We have also automated DEV deployment and Pull Request creation while retaining **human control over code reviews, approvals, merging, and production releases**. This demonstrates how automation and governance can work together to deliver software reliably without removing critical human decision points.

The result is a **production-grade DevSecOps and Continuous Delivery workflow within the scope of this project**, bringing together GitHub Actions, AWS, Docker, Trivy, SonarQube, and Kubernetes.

I hope this project has helped you understand how individual CI/CD components fit together, strengthened your practical knowledge of GitHub Actions, and given you a foundation that you can apply when designing and implementing **real-world production workflows**.

Thank you for following along, and congratulations on completing the project!

---

## References

**GitHub Actions and Repository Governance**

- [GitHub Repository Rulesets: Available Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)  
  URL: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets
- [Managing Repository Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets)  
  URL: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets
- [GitHub Actions: Events that Trigger Workflows](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#workflow_run)  
  URL: https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#workflow_run
- [Controlling Workflow Execution](https://docs.github.com/en/actions/how-tos/administer/control-workflow-execution)  
  URL: https://docs.github.com/en/actions/how-tos/administer/control-workflow-execution
- [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)  
  URL: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
- [GitHub Webhook Events and Payloads](https://docs.github.com/en/webhooks/webhook-events-and-payloads)  
  URL: https://docs.github.com/en/webhooks/webhook-events-and-payloads
- [GitHub Actions Self-Hosted Runners](https://docs.github.com/en/actions/reference/runners/self-hosted-runners)  
  URL: https://docs.github.com/en/actions/reference/runners/self-hosted-runners

**GitHub Actions and Security Tools**

- [Aqua Security Trivy Action](https://github.com/marketplace/actions/aqua-security-trivy)  
  URL: https://github.com/marketplace/actions/aqua-security-trivy
- [GitHub Actions Setup Java](https://github.com/marketplace/actions/setup-java-jdk)  
  URL: https://github.com/marketplace/actions/setup-java-jdk

**AWS and Amazon EKS**

- [Amazon EKS: Migrating to Access Entries](https://docs.aws.amazon.com/eks/latest/userguide/migrating-access-entries.html)  
  URL: https://docs.aws.amazon.com/eks/latest/userguide/migrating-access-entries.html
- [Amazon EKS Cluster Autoscaling Best Practices](https://docs.aws.amazon.com/eks/latest/best-practices/cluster-autoscaling.html)  
  URL: https://docs.aws.amazon.com/eks/latest/best-practices/cluster-autoscaling.html
- [AWS Secrets Manager Integration with Amazon EKS](https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrate_eks.html)  
  URL: https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrate_eks.html
- [Amazon ECR Enhanced Image Scanning](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning-enhanced.html)  
  URL: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning-enhanced.html

**Kubernetes and Secrets Management**

- [Kubernetes: Managing Secrets Using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)  
  URL: https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/
- [External Secrets Operator Documentation](https://external-secrets.io/)  
  URL: https://external-secrets.io/

---
