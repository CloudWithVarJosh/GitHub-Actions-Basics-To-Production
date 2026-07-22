# GitHub Custom Actions Explained | Composite Actions with 2 Demos

## Video reference for this lecture is the following:


---

## ⭐ Support the Project  

If this **repository** helps you, give it a ⭐ to show your support and help others discover it! 

---

## Table of Contents

- [Introduction](#introduction)  
- [Why GitHub Custom Actions](#why-github-custom-actions)  
- [Challenge 1: Organization-specific Automation](#challenge-1-organization-specific-automation)  
- [Challenge 2: Repetitive Workflow Logic](#challenge-2-repetitive-workflow-logic)  
- [What are GitHub Custom Actions?](#what-are-github-custom-actions)  
- [Types of GitHub Custom Actions](#types-of-github-custom-actions)  
  - [Composite Actions](#1-composite-actions)  
  - [JavaScript Actions (To be discussed in next lecture)](#2-javascript-actions-to-be-discussed-in-next-lecture)  
  - [Docker Actions (To be discussed in next lecture)](#3-docker-actions-to-be-discussed-in-next-lecture)  
- [**Demo 1:** Creating a Composite Action by Chaining Existing GitHub Actions](#demo-1-creating-a-composite-action-by-chaining-existing-github-actions)  
  - [Step 1: Repository Setup and Authentication](#step-1-repository-setup-and-authentication)  
  - [Step 2: Preparing the Application](#step-2-preparing-the-application)  
    - [Step 2.1: Create the Flask Application](#step-21-create-the-flask-application)  
    - [Step 2.2: Create the Dockerfile](#step-22-create-the-dockerfile)  
    - [Step 2.3: Create the Requirements File](#step-23-create-the-requirements-file)  
  - [Step 3: Preparing Docker Hub for Authentication and Image Publishing](#step-3-preparing-docker-hub-for-authentication-and-image-publishing)  
    - [Step 3.1: Creating a Private Docker Hub Repository](#step-31-creating-a-private-docker-hub-repository) 
    - [Step 3.2: Creating a Docker Hub Personal Access Token (PAT)](#step-32-creating-a-docker-hub-personal-access-token-pat)  
  - [Step 4: Configuring Repository Variables & Secrets](#step-4-configuring-repository-variables--secrets)  
  - [Step 5: Creating a Composite Action](#step-5-creating-a-composite-action)  
  - [Step 6: Commit and Push the Changes](#step-6-commit-and-push-the-changes)  
  - [Step 7: Running the Workflow](#step-7-running-the-workflow)  
  - [Step 8: Observing Workflow Execution](#step-8-observing-workflow-execution)  
  - [Demo 1 Key Takeaways](#demo-1-key-takeaways) 
- [**Demo 2:** Creating a Composite Action by Chaining Multiple Shell Commands](#demo-2-creating-a-composite-action-by-chaining-multiple-shell-commands)  
  - [Repository Structure](#repository-structure)  
  - [Step 1: Create the Composite Action](#step-1-create-the-composite-action)  
  - [Step 2: Create the Workflow](#step-2-create-the-workflow)  
  - [Step 3: Commit and Push the Changes](#step-3-commit-and-push-the-changes)  
  - [Step 4: Execute the Workflow](#step-4-execute-the-workflow)  
  - [Step 5: Observe the Workflow Execution](#step-5-observe-the-workflow-execution)  
  - [Demo 2 Key Takeaways](#demo-2-key-takeaways) 
- [Conclusion](#conclusion)  
- [References](#references)  

---

## Introduction

Welcome to **Lecture 11** of the **GitHub Actions: Basics to Production** course.

In the previous lectures, we learned how to build complete CI/CD workflows by consuming **GitHub** and **third-party Actions** from the GitHub Marketplace. In this lecture, we take the next logical step by learning how to create our own **GitHub Custom Actions**.

We begin by understanding **why GitHub Custom Actions are needed**, **what they are**, and the challenges they solve. We then introduce the **three types of GitHub Custom Actions**, with our primary focus on **Composite Actions**, the simplest and most commonly used type of Custom Action.

Through **two hands-on demonstrations**, we will learn how to build Composite Actions by packaging both **existing GitHub Actions** and **multiple shell commands** into reusable components, making workflows simpler, more maintainable, and easier to reuse across projects.

> To keep this lecture focused and avoid overwhelming you with multiple implementation approaches at once, we will cover only **Composite Actions** in depth. The remaining two types, **JavaScript Actions** and **Docker Actions**, along with their **hands-on demonstrations**, will be covered in the **next lecture**. 

---

### Why GitHub Custom Actions?

Throughout this course, we have been using GitHub Actions authored by both **GitHub** and **third-party publishers**.

For example, GitHub provides several commonly used Actions:

```yaml
- uses: actions/checkout@v7
- uses: actions/upload-artifact@v7
- uses: actions/download-artifact@v8
- uses: actions/cache@v6
```

These Actions simplify common workflow tasks such as **checking out source code**, **sharing artifacts between jobs**, and **caching dependencies** to improve workflow performance.

Similarly, many organizations publish their own Actions through the **GitHub Marketplace** for the platforms and tools they maintain.

Some common examples include:

| Publisher         | Example Action                             | Common Use Case                                                    |
| ----------------- | ------------------------------------------ | ------------------------------------------------------------------ |
| **Docker**        | `docker/login-action@v4`                   | Authenticate with Docker registries.                               |
| **Docker**        | `docker/build-push-action@v7`              | Build and publish Docker images.                     |
| **AWS**           | `aws-actions/configure-aws-credentials@v6` | Authenticate with AWS using IAM credentials or OIDC. |
| **Azure**         | `azure/login@v2`                           | Authenticate with Azure subscriptions.               |
| **HashiCorp**     | `hashicorp/setup-terraform@v3`             | Install and configure Terraform.                                   |
| **Aqua Security** | `aquasecurity/trivy-action`                | Scan container images and repositories for vulnerabilities.        |
| **SonarSource**   | `SonarSource/sonarqube-scan-action@v6`     | Perform code quality and security analysis.                        |

Notice that, throughout this course, we have been accomplishing complex tasks by simply referencing these Actions using the **`uses`** keyword.

For example, instead of writing dozens of commands to:

```text
Authenticate to Docker Hub → Build Container Image → Push Container Image
```

we simply use the appropriate Docker Actions.

Likewise, instead of writing Git commands to clone a repository, configure the working directory, and checkout the required commit, we simply write:

```yaml
- uses: actions/checkout@v7
```

These reusable Actions save workflow authors from writing, testing, and maintaining lengthy shell scripts for many common CI/CD tasks.

However, **GitHub Marketplace cannot provide an Action for every possible use case.**

Every organization has its own **internal platforms**, **deployment processes**, **security validations**, **compliance requirements**, **notification systems**, and **operational workflows** that are unique to that organization.

For example:

```text
Authenticate with Internal Platform → Validate Organization Policies → Build → Deploy Application → Update Internal CMDB → Notify Internal Systems
```

Actions for such organization-specific workflows typically do not exist in the GitHub Marketplace.

As a result, engineers often end up copying the same shell scripts and commands across multiple workflows and repositories, making them increasingly difficult to **maintain**, **standardize**, and **reuse**.

Let's understand these challenges in more detail.

> **Note:** I've used the **latest stable Action versions** available at the time of writing this guide. Since GitHub Actions are updated over time, always check the Action's **official documentation** or GitHub repository to confirm that you're using the **latest recommended version** before implementing it in production.
---


### Challenge 1: Organization-specific Automation

Although the **GitHub Marketplace** contains thousands of Actions, every organization eventually encounters tasks that are **unique to its business**, **platform**, or **engineering practices**. These organization-specific processes often cannot be implemented using existing GitHub or Marketplace Actions alone.

For example, an organization may need to:

```text
Authenticate with Internal Platform → Validate Organization Policies → Build Application → Deploy Application → Update Internal CMDB → Notify Internal Systems
```

Since these workflows are **specific to the organization**, an appropriate Action may not already exist in the GitHub Marketplace.

As a result, engineers often implement the required logic directly inside workflow YAML files using lengthy **Python**, **Shell**, or **Bash** scripts. In this example, we're using **Python** scripts, but the same concept applies to **Shell (Bash)** scripts and scripts written for other shells.

```yaml
run: |
  python authenticate.py
  python validate.py
  python build.py
  python deploy.py
  python update_cmdb.py
  python notify.py
```

While this approach works for an individual workflow, the same organization-specific implementation is often required across **multiple workflows** and **multiple repositories**. Teams therefore end up copying the same scripts and commands throughout their CI/CD pipelines.

This introduces several maintenance challenges:

* **Duplicate implementation** across workflows and repositories.
* **Multiple repositories** must be updated whenever the implementation changes.
* **Inconsistent implementations** across development teams.
* **Long, complex, and difficult-to-maintain** workflows.

> **Note:** A **Shell script** is the generic term for a script written to run in a Unix/Linux shell. A **Bash script** is a specific type of Shell script written for the **Bourne Again Shell (Bash)**. Similarly, there are Shell scripts written for other shells such as **Zsh (Z Shell)**, **Ksh (Korn Shell)**, and **Sh (POSIX/Bourne Shell)**. Throughout this course, we use **Bash**, as it is the most widely used shell in Linux and CI/CD environments.

---


### Challenge 2: Repetitive Workflow Logic

Not every challenge involves **organization-specific automation**. In many cases, the required functionality already exists as **GitHub Actions**, **Marketplace Actions**, or **Shell/Bash scripts**. However, the same implementation is often repeated across multiple workflows.

For example, multiple workflows may repeatedly implement the same CI/CD pipeline:

```text
Checkout Code → Login to Docker → Build & Push Image → Security Scan → Publish Artifact
```

which is typically implemented using the following GitHub Actions:

```yaml
- uses: actions/checkout@v7
- uses: docker/login-action@v4
- uses: docker/build-push-action@v7
- uses: aquasecurity/trivy-action@v0
- uses: actions/upload-artifact@v4
```

Similarly, they may repeatedly execute the same set of shell commands:

```yaml
run: |
  npm install
  npm test
  npm run lint
  npm run build
  npm audit
```

While implementing these steps directly within a workflow may seem reasonable, the same implementation is often copied across **multiple workflows** and **repositories** as projects grow.

This introduces several maintenance challenges:

* **Duplicate workflow logic** across multiple workflows.
* **Multiple workflow files** must be updated whenever the implementation changes.
* **Long, verbose, and difficult-to-maintain** workflow definitions.
* **Reduced readability**, making it harder to understand the high-level purpose of a workflow.

Whether the challenge is **organization-specific automation** or **repetitive workflow logic**, organizations need a way to package commonly used implementation into **reusable building blocks** that can be shared across **multiple workflows** and **repositories**. This is exactly the problem that **GitHub Custom Actions** are designed to solve.

---


### What are GitHub Custom Actions?

A **GitHub Custom Action** is a **reusable unit of automation** that encapsulates one or more **workflow steps**, **existing GitHub Actions**, **shell commands**, or **scripts** into a **reusable component** that can be consumed by one or more **GitHub Actions workflows**.

Throughout this course, we have been creating **GitHub Actions Workflows**.

A workflow defines **when automation should run**, **which jobs should execute**, and the **overall CI/CD pipeline**.

For example:

```yaml
on:
  push:
    branches:
      - main

jobs:
  build:
    ...
```

Within each workflow, every job consists of one or more **steps**.

Some steps execute shell commands using the **`run`** keyword:

```yaml
- name: Install Dependencies
  run: npm install
```

while others execute reusable Actions using the **`uses`** keyword:

```yaml
- uses: actions/checkout@v7
- uses: docker/login-action@v4
```

Conceptually:

```text
Workflow → Jobs → Steps → run / uses
```

Notice that **`run`** and **`uses`** serve different purposes.

| Keyword  | Purpose                                                         |
| -------- | --------------------------------------------------------------- |
| **run**  | Execute shell commands or scripts directly within the workflow. |
| **uses** | Execute reusable logic packaged as a GitHub Action.             |

For example, suppose multiple workflows contain the following commands:

```yaml
run: |
  python authenticate.py
  python validate.py
  python deploy.py
  python notify.py
```

Rather than copying these commands into every workflow, they can be packaged into a **GitHub Custom Action**.

The workflow then becomes much simpler.

Instead of:

```text
Workflow → 40 Lines of Commands
```

we simply write:

```yaml
- uses: my-org/deploy-action@v1
```

Conceptually:

```text
Workflow → uses → GitHub Custom Action → Execute Reusable Logic
```

> **Key Observation:** Like any other GitHub Action, a **GitHub Custom Action** is referenced using the **`uses`** keyword. The only difference is that, instead of consuming an Action published by **GitHub** or another **third-party publisher**, you create, package, and maintain the Action yourself.

---

## Types of GitHub Custom Actions

GitHub supports **three types of Custom Actions**. Although all three are referenced using the **`uses`** keyword and ultimately achieve the same goal of creating reusable automation, they differ in how they are implemented, the level of flexibility they provide, and the types of problems they are designed to solve.

| Type                     | Implementation          | Best Suited For                                              |
| ------------------------ | ----------------------- | ------------------------------------------------------------ |
| **1. Composite Action**  | YAML                    | Reusing existing workflow steps.                             |
| **2. JavaScript Action** | JavaScript / TypeScript | Custom automation logic and GitHub API interactions.         |
| **3. Docker Action**     | Docker Container        | Custom runtimes, dependencies, and any programming language. |

Regardless of the implementation, every GitHub Action is built around an **`action.yml`** metadata file. This file acts as the **entry point** of the Action, describing its metadata, inputs, outputs, execution method, and other configuration required by GitHub.

When a workflow references an Action using the **`uses`** keyword, GitHub first reads the **`action.yml`** file to determine **how the Action should be executed**. Based on the information in this metadata file, GitHub identifies whether it is a **Composite Action**, a **JavaScript Action**, or a **Docker Action**, and then invokes the appropriate execution mechanism.

In other words, while the implementation differs, all GitHub Actions share the same fundamental structure and are discovered through their **`action.yml`** metadata file.

---

#### 1. Composite Actions

* Implemented entirely using **YAML**, Composite Actions package one or more **reusable execution steps**, including existing **GitHub Actions**, shell commands, and scripts, into a single reusable component, making them the **simplest** type of Custom Action to create.

* Best suited for eliminating duplicated workflow logic across multiple workflows and repositories when the required automation can be achieved **without writing custom application code**.

> **Mental Model:** Think of a Composite Action as a reusable collection of existing workflow steps. Instead of copying the same sequence of commands and GitHub Actions into multiple workflows, you package them once and invoke them wherever required using the **`uses`** keyword.

```text
Repeated Workflow Steps
        │
        ▼
Package Once as a Composite Action
        │
        ▼
Reuse Across Multiple Workflows
```

> **Recommendation:** Start with a **Composite Action** whenever possible. If your automation can be implemented using existing GitHub Actions, shell commands, or scripts, a Composite Action is typically the simplest and most maintainable solution.

> **Production Insight:** **Composite Actions are by far the most commonly authored Custom Actions** in enterprise DevOps environments. Most organizations use them to standardize common CI/CD operations such as application builds, testing, security scans, artifact publishing, cloud authentication, deployments, and notifications while keeping workflows simple, consistent, and easy to maintain.

For example, rather than every workflow implementing the same deployment process independently:

```text
Authenticate to Cloud → Configure CLI → Build Application → Run Tests → Deploy Application → Send Notification
```

organizations typically package the entire sequence into a single **Composite Action** that can be reused across dozens or even hundreds of workflows.

> **Limitation:** Composite Actions primarily orchestrate existing **GitHub Actions**, shell commands, and scripts. If your automation requires **custom programming logic**, **GitHub API interactions**, or advanced data processing, a **JavaScript Action** or **Docker Action** is usually a better choice.

**Common Characteristics:**

* Every Composite Action is defined using an **`action.yml`** metadata file, which describes the Action's metadata, inputs, outputs, reusable execution steps, and other configuration required by GitHub. We will examine the structure of this file in detail during the hands-on demonstration.

* Composite Actions can be stored **within the same repository** as the workflow (**Local Action**) or in a **dedicated repository** (**Remote Action**). *(This storage model applies to all GitHub Custom Action types.)*

  * With **Local Actions**, both the **Action** and the **workflows** reside in the same repository, allowing multiple workflows within that repository to reuse the Action.

  * With **Remote Actions**, the Action is maintained in a dedicated repository, versioned independently, and can be consumed by workflows in **one or more repositories**.

The following diagram illustrates the difference.

```text
Local Action

Repository A
├── .github/actions/build/
├── .github/workflows/ci.yml
├── .github/workflows/release.yml
└── .github/workflows/deploy.yml

Multiple Workflows (in Repository A)
        │
        ▼
Reuse the Same Local Action
```

versus

```text
Remote Action

Action Repository
└── my-org/build-action

Repository A ─┐
Repository B ─┼── uses: my-org/build-action@v1
Repository C ─┘

One or More Repositories
        │
        ▼
Reuse the Same Remote Action
```


> **Note:** A **Remote Action** does **not** require a GitHub Organization. The Action can reside in a repository owned by an **individual GitHub user** or a **GitHub Organization**. The only requirement is that the workflow has permission to access the repository containing the Action.


> **Note:** The concepts of **Local Actions** and **Remote Actions** are **not limited to Composite Actions**. They apply equally to **Composite Actions**, **JavaScript Actions**, and **Docker Actions**. The distinction is based on **where the Action is stored**, not **how it is implemented**.

> **Key Takeaway:** Composite Actions are designed to **reuse existing automation**, not create entirely new execution environments or implement complex application logic. Whenever existing GitHub Actions, shell commands, or scripts can solve the problem, a Composite Action is usually the simplest, most maintainable, and most widely adopted solution.

---


### **2. JavaScript Actions (To be discussed in next lecture)**

JavaScript Actions allow you to build **fully customized GitHub Actions** using JavaScript or TypeScript. They are ideal when your automation requires **programmatic logic**, API integrations, or functionality beyond shell scripting.

Since the primary objective of this lecture is to build a strong foundation in **Composite Actions** through hands-on demonstrations, we will cover **JavaScript Actions** in the next lecture and explore their architecture, implementation, and real-world use cases in detail.

---

### **3. Docker Actions (To be discussed in next lecture)**

Docker Actions package both the automation logic and its execution environment into a Docker container, ensuring the Action runs **consistently across different runners**. They are commonly used when automation depends on **specific tools, libraries, or runtime environments** that are not available on the GitHub runner by default.

To keep this lecture focused entirely on **Composite Actions**, we will discuss **Docker Actions** in the next lecture, where we will understand how they work, when to use them, and implement them through practical examples.


---

## Demo 1: Creating a Composite Action by Chaining Existing GitHub Actions

As we learned in the theory section, **Composite Actions** package one or more reusable execution steps, including **existing GitHub Actions**, **shell commands**, and **scripts**, into a single reusable component.

In this demo, we will create our first **Composite Action** by packaging multiple existing GitHub Actions into a reusable component. In the next demo, we will package multiple shell commands and scripts, demonstrating another common use case for Composite Actions.

---

### Step 1: Repository Setup and Authentication

Before starting this demo, ensure that you already:

* have a GitHub repository created
* are authenticated with GitHub
* can push code successfully using Git

These concepts were covered extensively in **Lecture 01**.

* [Lecture 01 Video](https://youtu.be/w4c_NIjO3XI)
* [Lecture 01 GitHub Notes](https://github.com/CloudWithVarJosh/GitHub-Actions-Basics-To-Production/tree/main/01-GitHub-Actions)

For this lecture, we will use the following repository:

* **Repository Name:** `cwvj-gha-practice`
* **Visibility:** Private

> **Operational Note:** GitHub Actions workflows execute directly inside repositories. Whenever workflow YAML files are pushed into the repository, GitHub automatically discovers them and evaluates whether they should execute based on their configured workflow triggers.

---

### Step 2: Preparing the Application

Throughout this course, we have been using the same **containerized Flask application** to demonstrate various GitHub Actions concepts. We will continue using the same application in this lecture so that we can focus entirely on understanding **GitHub Custom Actions** rather than introducing a new application.

Create the following directory structure:

```text
Demo-01
├── .github
│   ├── actions
│   │   └── docker-build-push
│   │       └── action.yml
│   └── workflows
│       └── refactored-workflow.yaml
├── app.py
├── Dockerfile
├── original-workflow.yaml
└── requirements.txt
```

* Every subdirectory inside **`.github/actions`** represents a **single Local Action**. Since every Custom Action must define an **`action.yml`** metadata file, organizing each Action in its own directory makes them easier to identify, maintain, and reuse.

* **`original-workflow.yaml`** is included only for comparison and is **not executed**. The actual workflow used in this demo is **`refactored-workflow.yaml`**, which resides under **`.github/workflows`**.

---

#### Step 2.1: Create the Flask Application

Create the following Flask application.

**`app.py`**

```python
from flask import Flask, jsonify
import os

app = Flask(__name__)

print("Cloud With VarJosh Flask Application Started")


@app.get("/")
def home():
    print("Home endpoint invoked")

    return jsonify(
        message="Welcome to Cloud With VarJosh",
        platform="GitHub Actions",
        runtime="Docker + Flask"
    )


@app.get("/health")
def health():
    print("Health endpoint invoked")

    return jsonify(status="healthy"), 200


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.getenv("PORT", 5000))
    )
```

> **Note:** This is the same application that we have been using throughout this course. If you have been following the course sequentially, simply reuse the existing `app.py` file.

---

#### Step 2.2: Create the Dockerfile

Create the following Dockerfile.

**`Dockerfile`**

```dockerfile
FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

> **Note:** The Dockerfile remains unchanged from the previous lectures. If you have already created it, simply reuse the existing Dockerfile.

---

#### Step 2.3: Create the Requirements File

Create the following dependency file.

**`requirements.txt`**

```text
flask==3.1.1
```

> **Note:** This is the same dependency file used throughout the course. Simply reuse the existing `requirements.txt` if you have already created it.

---

### Step 3: Preparing Docker Hub for Authentication and Image Publishing

Our workflow will build a Docker image and publish it to **Docker Hub**. Before that can happen, we need:

* a **Docker Hub Repository** to store the container images
* a **Docker Hub Personal Access Token (PAT)** to allow GitHub Actions to securely authenticate with Docker Hub

---

#### Step 3.1: Creating a Private Docker Hub Repository

Before the workflow can publish Docker images, we need a repository to store them.

Navigate to:

```text
Docker Hub → Repositories → Create Repository
```

Configure the repository using the following settings.

| Setting             | Value         |
| ------------------- | ------------- |
| **Repository Name** | `python-demo` |
| **Visibility**      | **Private**   |

Once created, the repository URL should resemble:

```text
docker.io/<your-dockerhub-username>/python-demo
```

Later in this lecture, our workflow will publish Docker images to this repository using image tags similar to:

```text
<your-dockerhub-username>/python-demo:<github-run-number>
```

> **Operational Note:** We are using a **private repository** because it more closely reflects how organizations manage container images in production. Private repositories help prevent unauthorized access and allow organizations to control who can **pull**, **push**, or **manage** container images.

---

#### Step 3.2: Creating a Docker Hub Personal Access Token (PAT)

We already know from previous lectures that:

* every GitHub Actions job executes on its own runner
* **GitHub-hosted runners** must authenticate with external systems whenever protected resources are accessed

In this demo, our workflow authenticates with **Docker Hub** before pushing the Docker image. Instead of using a Docker Hub account password, we will create a **Docker Hub Personal Access Token (PAT)**.

> **Important:** Never use your Docker Hub account password inside CI/CD workflows. Always authenticate using a **Personal Access Token (PAT)**.

Navigate to:

```text
Docker Hub → Profile Icon → Account Settings → Personal Access Tokens → Generate New Token
```

Configure the token as follows.

| Setting         | Value          |
| --------------- | -------------- |
| **Description** | `gha-demo`     |
| **Expiration**  | `1 Day`        |
| **Permissions** | `Read & Write` |

After creating the token:

* copy it immediately
* Docker Hub displays the token only once

We will configure this token as a **Repository Secret** in the next step.

> **Operational Note:** Docker Hub Personal Access Tokens are created at the **account level**. Any workflow, runner, or automation using the token inherits the permissions assigned to that token.

> **Production Insight:** Most organizations use **private container registries** such as **Amazon ECR**, **GitHub Container Registry (GHCR)**, **Azure Container Registry (ACR)**, **Google Artifact Registry (GAR)**, **JFrog Artifactory**, or **Harbor** instead of public repositories. Similarly, production environments typically avoid long-lived credentials by adopting **short-lived credentials**, **credential rotation**, **least-privilege access**, and **centralized secret management** to improve security and reduce operational risk.

---

### Step 4: Configuring Repository Variables & Secrets

Before the workflow can authenticate with Docker Hub and publish Docker images, we need to configure the required **Repository Variables** and **Repository Secret**.

| Name | Type | Value to Configure |
|------|------|--------------------|
| `DOCKERHUB_USERNAME` | Repository Variable | Your Docker Hub username (e.g., `cloudwithvarjosh`). |
| `DOCKER_IMAGE_NAME` | Repository Variable | The Docker image repository name in the format `<username>/<repository>` (e.g., `cloudwithvarjosh/python-demo`). |
| `DOCKERHUB_TOKEN` | Repository Secret | Your Docker Hub Personal Access Token (PAT). |

> **Note:** We covered **Repository Variables** and **Repository Secrets** in detail in the previous lectures. In this demo, we are simply reusing those concepts to configure our Composite Action.

> **Production Insight:** Avoid hardcoding configuration values such as usernames, repository names, and image names directly inside workflows. Store **non-sensitive values** as **Repository Variables** and **sensitive values** as **Repository Secrets** so that workflows remain reusable, easier to maintain, and more secure.

---

### Step 5: Creating a Composite Action

As we learned in the theory section, a **Composite Action** packages one or more reusable execution steps into a single reusable component. In this step, we will create our first **Local Composite Action** by moving the Docker authentication and image publishing steps out of the workflow and into an **`action.yml`** file.

Create the following file.

**`.github/actions/docker-build-push/action.yml`**

```yaml
name: Docker Build & Push

description: Reusable Composite Action for building and pushing Docker images to Docker Hub.

inputs:

  dockerhub-username:
    description: Docker Hub Username
    required: true

  dockerhub-token:
    description: Docker Hub Personal Access Token
    required: true

  image-name:
    description: Docker Image Name
    required: true

  image-tag:
    description: Docker Image Tag
    required: false
    default: latest

runs:
  using: composite

  steps:

    - name: Login to Docker Hub
      uses: docker/login-action@v4
      with:
        username: ${{ inputs.dockerhub-username }}
        password: ${{ inputs.dockerhub-token }}

    - name: Build & Push Docker Image
      uses: docker/build-push-action@v7
      with:
        context: .
        push: true
        tags: ${{ inputs.image-name }}:${{ inputs.image-tag }}
```

---

#### Explanation

---

```yaml
name: Docker Build & Push

description: Reusable Composite Action for building and pushing Docker images to Docker Hub.
```

This block defines the **metadata** of the Custom Action.

* **`name`** specifies the name displayed whenever the Action executes inside a workflow.
* **`description`** provides a short summary describing the purpose of the Action. Although optional, it is considered a best practice because it makes the Action easier to understand, especially when it is reused across multiple workflows or repositories.

Unlike workflow names, which identify an entire workflow execution, the **Action name** identifies the reusable component being executed within that workflow.

---

```yaml
inputs:
  dockerhub-username:
    description: Docker Hub Username
    required: true

  dockerhub-token:
    description: Docker Hub Personal Access Token
    required: true

  image-name:
    description: Docker Image Name
    required: true

  image-tag:
    description: Docker Image Tag
    required: false
    default: latest
```

Every **GitHub Custom Action** exposes configurable parameters through the **`inputs`** section. These inputs define **what values the calling workflow can pass to the Action** using the **`with`** block.

In the previous lectures, we used the **`with`** block to customize GitHub Actions. The values that can be specified in the **`with`** block are defined by the Action author in the **`inputs`** section of the **`action.yml`** file.

Conceptually:

```text
Workflow
    │
    └── with
            │
            ▼
     action.yml (inputs)
            │
            ▼
     Composite Action
```

Each input consists of three important attributes.

| Attribute | Purpose |
|-----------|---------|
| **description** | Documents the purpose of the input. |
| **required** | Specifies whether the workflow must provide a value. |
| **default** | Provides a default value when the workflow does not supply one. |

In this example, all four values are passed through the **`with`** block. However, only the first three inputs are marked as:

```yaml
required: true
```

This means the calling workflow **must** provide values for these inputs. If any required input is omitted, GitHub validates the Action configuration and fails the workflow before the Action begins execution.

The **`image-tag`** input is configured as:

```yaml
image-tag:
  required: false
  default: latest
```

making it an **optional input**. If the workflow omits `image-tag` from the **`with`** block, GitHub automatically uses the default value:

```text
latest
```

In our demo, we explicitly provide **all four inputs**, so the default value is never used.

> **Note:** In **Lecture 6**, we introduced the three types of **Inputs** supported by GitHub Actions: **Workflow Inputs**, **Reusable Workflow Inputs**, and **Action Inputs**. While discussing **Action Inputs**, we mentioned that we would revisit them once we started building our own GitHub Custom Actions. In this demo, we are implementing **Action Inputs**, where the **`inputs`** section of the **`action.yml`** file defines the parameters that the calling workflow can pass through the **`with`** block.
>
> Both **Action Inputs** and **Reusable Workflow Inputs** are conceptually similar, as they allow the calling workflow to pass values through the **`with`** block. The key difference lies in where those inputs are defined. **Reusable Workflow Inputs** are defined under **`on.workflow_call.inputs`** inside a reusable workflow, whereas **Action Inputs** are defined in the **`inputs`** section of the **`action.yml`** file for a GitHub Custom Action.

> **Production Insight:** Well-designed Custom Actions avoid hardcoding environment-specific values. Instead, they expose configurable values as **inputs**, allowing the same Action to be customized through the **`with`** block and reused across multiple workflows, repositories, and deployment environments.

---

```yaml
runs:
  using: composite
```

The **`runs`** section defines **how GitHub should execute the Custom Action**.

When GitHub encounters:

```yaml
using: composite
```

it recognizes the Action as a **Composite Action** and executes the sequence of GitHub Actions and Shell/Bash scripts defined under the **`steps`** section. GitHub simply runs each step one after another, similar to executing steps within a workflow.

Earlier in this lecture, we learned that GitHub supports three execution mechanisms for GitHub Custom Actions.

```text
Composite Action  → using: composite
JavaScript Action → using: node20
Docker Action     → using: docker
```

The value specified in **`using`** tells GitHub **which execution engine to use**:

- **`using: composite`** executes the steps defined under the **`steps`** section.
- **`using: node20`** loads a Node.js runtime and executes the JavaScript entry point specified by the Action.
- **`using: docker`** builds or pulls a Docker image and executes the Action inside a Docker container.

Although all three Action types are invoked using the **`uses`** keyword, GitHub executes them differently based on the value of **`using`**.

> **Note:** In this lecture, we are implementing a **Composite Action**, so GitHub executes the steps defined in the **`steps`** section. In the next lecture, we'll see how **JavaScript Actions** and **Docker Actions** use different execution mechanisms.

---

```yaml
runs:
  using: composite

  steps:
    - name: Login to Docker Hub
      uses: docker/login-action@v4
      with:
        username: ${{ inputs.dockerhub-username }}
        password: ${{ inputs.dockerhub-token }}
```

> **Note:** One important difference you may have noticed is that the **`action.yml`** file does **not** contain a **`jobs`** section. Throughout this course, every workflow we've created followed the structure **`jobs → job(s) → steps`**. The **`jobs`** section defines one or more jobs (for example, **`build-job`**, **`test-job`**, or **`deploy-job`**), and each job contains its own sequence of **steps**.
>
> A **GitHub Custom Action**, however, is **not** a workflow and therefore does **not** define its own jobs. Instead, it is **invoked from a step within a job** defined by the calling workflow. Once invoked, the Custom Action executes the logic defined in its **`runs`** section, which may consist of **one or more steps**.

Conceptually:

```text
Calling Workflow
──────────────────────────────────────────────
jobs
└── build-job
    └── steps
        └── Composite Action
            └── runs
                └── steps
```

* The **`steps`** section defines the sequence of operations performed by the Composite Action. Just like a workflow, each step can execute Shell/Bash commands using **`run`** or invoke another GitHub Action using the **`uses`** keyword.

* In this example, the first step authenticates with **Docker Hub** before the Docker image is built and pushed. Notice that we are **not implementing the authentication logic ourselves**. Instead, we are simply reusing the official GitHub Action:

```yaml
docker/login-action@v4
```

which we have already used throughout this course.

* More importantly, notice that the Composite Action does **not** directly reference the Repository Variable or Repository Secret:

```yaml
${{ vars.DOCKERHUB_USERNAME }}
${{ secrets.DOCKERHUB_TOKEN }}
```

Instead, it consumes the following **Action Inputs**:

```yaml
${{ inputs.dockerhub-username }}
${{ inputs.dockerhub-token }}
```

* These inputs are supplied by the calling workflow through the **`with`** block.

Conceptually:

```text
Repository Variables / Secrets → Calling Workflow (with) → Composite Action (inputs) → docker/login-action
```

* This design keeps the Composite Action **independent of its execution environment**. The Action simply defines **what values it requires**, while the calling workflow decides **where those values come from**.

* The calling workflow can provide these values from a variety of sources, including:
  * **Repository Variables**
  * **Repository Secrets**
  * **Organization Variables**
  * **Organization Secrets**
  * **Environment Variables**
  * **Environment Secrets**
  * **GitHub Contexts**
  * **Outputs** from previous jobs or steps
  * **Hardcoded values** (generally not recommended)

> **Production Insight:** A well-designed Composite Action should define **what values it requires**, not **where those values come from**. The calling workflow is responsible for obtaining the required values and passing them through the **`with`** block, while the Composite Action simply consumes those inputs and performs its reusable logic. This separation of **workflow orchestration** from **reusable execution logic** is one of the primary benefits of GitHub Custom Actions.

---

```yaml
- name: Build & Push Docker Image
  uses: docker/build-push-action@v7
  with:
    context: .
    push: true
    tags: ${{ inputs.image-name }}:${{ inputs.image-tag }}
```

* Once authentication succeeds, the next step builds the Docker image and publishes it to **Docker Hub**. Rather than implementing the build and push logic ourselves, we simply reuse the official GitHub Action:

```yaml
docker/build-push-action@v7
```

* Notice that only the **image name** and **image tag** are configurable through **Action Inputs**, allowing the calling workflow to determine which image should be built and how it should be tagged.

```text
Image Name + Image Tag → cloudwithvarjosh/python-demo:15
```

where:
  * **Image Name** is supplied by the calling workflow.
  * **Image Tag** is also supplied by the calling workflow (in this demo, using **`${{ github.run_number }}`**).

* In contrast, the remaining parameters are **hardcoded** within the Composite Action:

```yaml
context: .
push: true
```

Since these values are **not** exposed as **Action Inputs**, the calling workflow cannot modify them. Consequently, the Docker build context will always be the repository root (`.`), and the Docker image will always be pushed to the registry after it has been built.

* If we wanted the calling workflow to control either of these behaviors, we would expose additional **Action Inputs** (for example, **`build-context`** or **`push-image`**) and pass those values to **`docker/build-push-action`** instead of hardcoding them.

* This demonstrates an important design principle of Composite Actions. The Action author decides **which parameters should remain configurable** and **which should remain fixed**. The calling workflow can customize only those values that have been intentionally exposed as **Action Inputs**, while the remaining implementation details stay encapsulated within the Action.

> **Key Observation:** Notice that we did **not** write any new automation logic while creating this Composite Action. Instead, we simply packaged two existing GitHub Actions, **`docker/login-action`** and **`docker/build-push-action`**, into a reusable component. This is precisely what Composite Actions are designed for, **encapsulating existing workflow steps while exposing only the configuration that consumers need**.

---

Now create the following workflow.

**`.github/workflows/refactored-workflow.yaml`**

```yaml
name: Docker Build & Push (Composite Action)

on:
  workflow_dispatch:

jobs:
  docker-build-push-job:
    name: Docker Build & Push (Composite Action)

    runs-on: ubuntu-latest

    env:
      IMAGE_NAME: ${{ vars.DOCKER_IMAGE_NAME }}
      IMAGE_TAG: ${{ github.run_number }}

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Build & Push Docker Image
        uses: ./.github/actions/docker-build-push
        with:
          dockerhub-username: ${{ vars.DOCKERHUB_USERNAME }}
          dockerhub-token: ${{ secrets.DOCKERHUB_TOKEN }}
          image-name: ${{ env.IMAGE_NAME }}
          image-tag: ${{ env.IMAGE_TAG }}
```

---

#### Explanation

---

```yaml
name: Docker Build & Push (Composite Action)
```

* This block defines the **workflow name** displayed in the **GitHub Actions UI**. We have discussed this in previous lectures, and it simply helps identify workflow runs.

---

```yaml
on:
  workflow_dispatch:
```

* This workflow is configured to execute only when it is **manually triggered** from the GitHub Actions UI.

* We have discussed **workflow triggers** extensively in previous lectures. Using **`workflow_dispatch`** allows us to repeatedly execute this demo without making unnecessary commits to the repository.

---

```yaml
jobs:
  docker-build-push-job:
```

This block defines the single job executed by the workflow.

Its responsibility is to:

```text
Checkout Repository → Execute Composite Action (Login to Docker Hub → Build Docker Image → Push Docker Image)
```

Notice that the workflow itself no longer contains the Docker authentication and image publishing logic. Those responsibilities have now been delegated to the Composite Action.

---

```yaml
runs-on: ubuntu-latest
```

* This job executes on a **GitHub-hosted Ubuntu runner**.

* We have discussed runners extensively throughout this course. Since our Composite Action uses official Docker Actions, the runner provides the required Docker runtime and tooling needed to build and publish container images.

---

```yaml
env:
  IMAGE_NAME: ${{ vars.DOCKER_IMAGE_NAME }}
  IMAGE_TAG: ${{ github.run_number }}
```

This block defines **job-level environment variables**.

Unlike **Repository Variables**, which are configured outside the workflow, these variables exist only for the lifetime of this job.

Notice that the values originate from different sources.

```text
Repository Variable → IMAGE_NAME
GitHub Context      → IMAGE_TAG
```

The workflow consolidates those values into **job-level environment variables**, making them easier to reference throughout the workflow.

Later, these values are passed to the Composite Action using the **`with`** block.

> **Production Insight:** Environment variables can be defined at the **workflow**, **job**, or **step** level. Defining them at the **job level** limits their scope to only the jobs that require them, improving readability while avoiding unnecessary exposure to other jobs.

---

```yaml
- name: Checkout Repository
  uses: actions/checkout@v4
```

* Before the Composite Action can build the Docker image, the workflow must first download the repository contents onto the runner.

* We have used **`actions/checkout`** throughout this course, so there is nothing new here. This step simply prepares the runner by making the application source code available to the subsequent steps.

---

```yaml
- name: Build & Push Docker Image
  uses: ./.github/actions/docker-build-push
```

* This is the **most important configuration** in the calling workflow, as it instructs GitHub which **GitHub Custom Action** should be executed.

* Unlike the GitHub and Docker Actions we have been consuming throughout this course, this Composite Action resides **within the same repository** as the calling workflow.

* The path:

```yaml
./.github/actions/docker-build-push
```

begins with:

```text
./
```

which instructs GitHub to locate the Action **relative to the repository root**, rather than downloading it from another repository.

Conceptually:

```text
Repository
├── .github
│   ├── actions
│   │   └── docker-build-push
│   │       └── action.yml
│   └── workflows
│       └── refactored-workflow.yaml
```

* GitHub automatically locates the **`action.yml`** file within the specified directory and executes the Composite Action.

* Actions referenced using a relative path are known as **Local Actions**, because both the workflow and the Action reside in the same repository.

* Earlier, we learned that **Remote Actions** are maintained in dedicated repositories and consumed by one or more repositories.

* For example, if the Action were hosted in a repository named **`remote-action-repo`** owned by the GitHub user **`cloudwithvarjosh`**, the calling workflow would reference it as:

```yaml
- name: Build & Push Docker Image
  uses: cloudwithvarjosh/remote-action-repo@v1
```

* Similarly, if the Action were maintained in a repository owned by a GitHub Organization named **`cwvj-org`**, the reference would become:

```yaml
- name: Build & Push Docker Image
  uses: cwvj-org/remote-action-repo@v1
```

* Unlike a **Local Action**, where we provide a **relative directory path**, a **Remote Action** is referenced using the format:

```text
OWNER/REPOSITORY@VERSION
```

where:

* **OWNER** is the GitHub user or GitHub Organization.
* **REPOSITORY** is the repository containing the Custom Action.
* **VERSION** is the Git tag, branch, or commit SHA to consume.

* GitHub downloads the specified repository at the requested version, automatically locates the **`action.yml`** file in the repository's root directory, and executes the Action defined within it.

Conceptually:

```text
Local Action
Workflow Repository
        │
        ▼
Relative Path
(./.github/actions/docker-build-push)
        │
        ▼
Locate action.yml

---

Remote Action
Workflow Repository
        │
        ▼
OWNER/REPOSITORY@VERSION
        │
        ▼
Download Repository
        │
        ▼
Locate action.yml
```

> **Production Insight:** Local Actions are ideal when reusable automation is required only within a single repository. When the same Action needs to be shared across multiple repositories, teams typically move it into a dedicated repository and consume it as a **Remote Action**. Hosting the Action under a **GitHub Organization** is a common enterprise practice, as it enables centralized versioning, governance, and reuse across multiple repositories.

---

```yaml
with:
  dockerhub-username: ${{ vars.DOCKERHUB_USERNAME }}
  dockerhub-token: ${{ secrets.DOCKERHUB_TOKEN }}
  image-name: ${{ env.IMAGE_NAME }}
  image-tag: ${{ env.IMAGE_TAG }}
```

Earlier in this course, while working with **Reusable Workflows**, we learned that the calling workflow passes values to the reusable workflow through the **`with`** block.

The same concept applies to **GitHub Custom Actions**. The calling workflow supplies values through the **`with`** block, and the Composite Action receives those values as **Action Inputs**.

Conceptually:

```text
Calling Workflow (with) → Composite Action (inputs)
```

GitHub automatically maps each value supplied under the **`with`** block to the **Action Input with the same name** defined in the **`action.yml`** file.

For example:

```yaml
with:
  image-name: ${{ env.IMAGE_NAME }}
```

is automatically mapped to:

```yaml
inputs:
  image-name:
```

Similarly:

```text
Workflow (with)                     Composite Action (inputs)
────────────────────────────────────────────────────────────────
dockerhub-username   ───────────►   inputs.dockerhub-username
dockerhub-token      ───────────►   inputs.dockerhub-token
image-name           ───────────►   inputs.image-name
image-tag            ───────────►   inputs.image-tag
```

Notice that the names under the **`with`** block must exactly match the corresponding input names defined in the **`action.yml`** file. GitHub uses these names to automatically map each supplied value to the appropriate Action Input.

Although all four values are passed through the **`with`** block, they originate from different sources:

* **Repository Variables**
* **Repository Secrets**
* **Job-level Environment Variables**

The Composite Action has **no knowledge** of where these values originated. It simply receives the values through its inputs and performs its reusable logic.

Conceptually:

```text
Repository Variables / Secrets / Environment Variables
                           │
                           ▼
                Calling Workflow (with)
                           │
                           ▼
              Composite Action (inputs)
```

> **Key Observation:** A well-designed Composite Action should define **what values it requires**, not **where those values come from**. The calling workflow is responsible for obtaining values from **Repository Variables**, **Repository Secrets**, **Environment Variables**, **GitHub Contexts**, workflow outputs, or any other source, and passing them through the **`with`** block. The Composite Action simply consumes those inputs and performs its reusable logic. This separation of **workflow orchestration** from **reusable execution logic** is one of the primary benefits of GitHub Custom Actions.

---


### Step 6: Commit and Push the Changes

Once all the files have been created, commit and push them to your GitHub repository.

```bash
# Initialize the current directory as a new Git repository (one-time setup)
git init

# Associate the local repository with the remote GitHub repository (one-time setup)
git remote add origin git@github.com:CloudWithVarJosh/cwvj-gha-practice.git

# Stage all new and modified files for the next commit
git add .

# Create a commit containing the staged changes
git commit -m "Demo: Add Docker Build & Push Composite Action"

# Push the commit to the main branch and set the upstream tracking branch
git push -u origin main
```

Since this workflow uses the following trigger:

```yaml
on:
  workflow_dispatch:
```

pushing the code **does not automatically execute the workflow**. Instead, GitHub simply discovers the new workflow and makes it available in the **GitHub Actions** tab.

> **Note:** GitHub automatically discovers workflow files located under **`.github/workflows`** whenever they are pushed to the repository. Custom Actions, on the other hand, are simply files within the repository and are executed only when referenced from a workflow using the **`uses`** keyword.

---

### Step 7: Running the Workflow

Navigate to:

```text
Repository → Actions → Docker Build & Push (Composite Action) → Run workflow
```

Select the desired branch and click **Run workflow**.

GitHub provisions a **GitHub-hosted runner**, downloads the repository, and begins executing the workflow.

Conceptually:

```text
Run Workflow → Provision Runner → Checkout Repository → Execute Composite Action
```

> **Note:** Every workflow execution runs on a **fresh GitHub-hosted runner**. This ensures that each execution starts from a clean environment without relying on artifacts or state left behind by previous workflow runs.

---

### Step 8: Observing Workflow Execution

Once the workflow begins execution, open the workflow run and observe each step.

You should notice the following execution flow:

```text
Checkout Repository → Build & Push Docker Image (Composite Action)
```

Unlike the original workflow, the Docker authentication and image publishing logic no longer appear directly within the workflow YAML. Instead, GitHub executes them from the referenced Composite Action.

Expand the **Build & Push Docker Image** step.

GitHub automatically displays the individual steps packaged inside the Composite Action.

Conceptually:

```text
Build & Push Docker Image (Composite Action)
        ├── Login to Docker Hub
        └── Build & Push Docker Image
```

This demonstrates that a Composite Action behaves like any other GitHub Action. Although the workflow references only a single Action using the **`uses`** keyword, GitHub transparently executes every step defined inside the corresponding **`action.yml`** file.

Also verify that:

* the Docker image is successfully pushed to **Docker Hub**
* the image tag matches the current **`${{ github.run_number }}`**
* the workflow completes successfully without any modifications to the underlying Docker Actions

> **Key Observation:** Notice that we did **not** create any new deployment or containerization logic. We simply packaged two existing GitHub Actions into a reusable Composite Action. From the workflow author's perspective, multiple execution steps have now been replaced by a single **`uses`** statement, making the workflow significantly simpler while preserving exactly the same behavior.

> **Production Insight:** Composite Actions help organizations eliminate duplicated workflow logic without changing how the underlying automation works. Instead of copying the same sequence of GitHub Actions, shell commands, or scripts across multiple workflows, engineers package them into a reusable component that can be consumed consistently throughout the organization.

---

### Demo 1 Key Takeaways

Through this demo, we learned how to build our first **Composite Action** by packaging multiple **existing GitHub Actions** into a single reusable component.

More importantly, we saw how a Composite Action can:

* Package multiple **GitHub Actions** into a reusable unit of automation.
* Accept configurable **inputs** from the calling workflow.
* Consume **Repository Variables**, **Repository Secrets**, **Environment Variables**, and **GitHub Context** values through those inputs.
* Be stored as a **Local Action** within the same repository.
* Be invoked from a workflow using the **`uses`** keyword.
* Simplify workflows by replacing multiple execution steps with a single reusable Action.

These capabilities make Composite Actions an excellent choice for eliminating duplicated workflow logic while improving **reusability**, **maintainability**, and **standardization** across workflows.

Although this demo packaged existing **Docker GitHub Actions**, the same pattern is widely used in production environments. Organizations commonly create Composite Actions for tasks such as **application builds**, **testing**, **security scans**, **cloud authentication**, **artifact publishing**, **container image creation**, **deployments**, and **notifications**.

Instead of duplicating the same sequence of GitHub Actions across dozens or hundreds of workflows, organizations package the implementation into a **Composite Action**. Development teams simply invoke the Action whenever required, ensuring that CI/CD processes are implemented in a **consistent**, **maintainable**, and **standardized** manner across the organization.

---

## Demo 2: Creating a Composite Action by Chaining Multiple Shell Commands

In the previous demo, we created a Composite Action by combining multiple **GitHub Actions** into a reusable component. While that demonstrated one way of building Composite Actions, they are **not limited to invoking other Actions**.

A Composite Action can also execute one or more **shell commands**, making it an excellent choice for automating repetitive scripting tasks such as generating configuration files, preparing deployment artifacts, validating inputs, collecting build metadata, or performing custom automation before or after a build.

In this demo, we will create a Composite Action that generates **build metadata** using information available from the **GitHub Context**. The generated metadata will be stored inside a file named **build-info.txt**, which can later be archived as a workflow artifact or consumed by downstream workflow steps.

By the end of this demo, you will understand how Composite Actions can encapsulate multiple shell commands into a reusable automation component.

---

### Repository Structure

Since we already created the **gha-practice-demo** repository and configured GitHub authentication in the previous demo, we will continue using the same repository.

Our repository structure will now look as follows:

```text
└── .github
    ├── actions
    │   └── generate-build-info
    │       └── action.yml
    └── workflows
        └── build-information-demo.yml
```

Unlike the previous demo, this Composite Action does not perform Docker builds or publish container images. Instead, it focuses entirely on executing multiple shell commands to generate build metadata.

---

### Step 1: Create the Composite Action

Inside the existing repository, create the following directory.

```text
.github/actions/generate-build-info
```

Inside this directory, create a file named:

```text
action.yml
```

Add the following content.

```yaml
name: Generate Build Information
description: Generates build metadata using GitHub Context.

inputs:
  application-name:
    description: Name of the application.
    required: true

  environment:
    description: Deployment environment.
    required: true

outputs:
  build-info-path:
    description: Path to the generated build information file.
    value: output/build-info.txt

runs:
  using: composite

  steps:
    - name: Generate Build Information
      shell: bash
      run: |
        set -e

        mkdir -p output

        BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

        cat <<EOF > output/build-info.txt
        Application : ${{ inputs.application-name }}
        Environment : ${{ inputs.environment }}
        Repository  : ${{ github.repository }}
        Branch      : ${{ github.ref_name }}
        Commit SHA  : ${{ github.sha }}
        Run Number  : ${{ github.run_number }}
        Workflow    : ${{ github.workflow }}
        Triggered By: ${{ github.actor }}
        Build Time  : ${BUILD_TIME}
        EOF

        echo "======================================"
        echo "Build Information"
        echo "======================================"
        cat output/build-info.txt
```

#### Explanation

---

```yaml
name: Generate Build Information
```

* This block defines the **name of the Composite Action**.

* The name appears in the **GitHub Actions execution logs** whenever this Composite Action is invoked, making it easier to identify during workflow execution.

---

```yaml
description: Generates build metadata using GitHub Context.
```

* This block provides a brief description of the Composite Action.

* Although this field is optional, providing meaningful descriptions makes Actions easier to understand and maintain, especially when they are shared across multiple repositories.

---

```yaml
inputs:
  application-name:
    description: Name of the application.
    required: true

  environment:
    description: Deployment environment.
    required: true
```

* This Composite Action accepts **two input parameters** from the calling workflow.

* The **application-name** input specifies the name of the application for which build metadata will be generated.

* The **environment** input specifies the deployment environment, such as **Development**, **Testing**, or **Production**.

* Since both inputs are marked as **required**, GitHub will fail the workflow if either value is not supplied.

* These values are passed by the calling workflow using the **with** keyword, which we will see shortly.

---
```yaml
outputs:
  build-info-path:
    description: Path to the generated build information file.
    value: output/build-info.txt
```

* Recall that in **Lecture 7**, we introduced the three types of **Outputs** supported by GitHub Actions:
  * **Step Outputs**, used to pass values between steps within the same job.
  * **Job Outputs**, used to pass values from one job to another within the same workflow.
  * **Reusable Workflow Outputs**, used to return values from a reusable workflow back to the calling workflow.

* In this demo, we are introducing the fourth concept, **Action Outputs**, which allow a **GitHub Custom Action** to return values back to the calling workflow, similar to how a reusable workflow exposes outputs.

* During execution, this Composite Action generates a build metadata file named **`build-info.txt`** containing information such as the application name, environment, repository, branch, commit SHA, workflow name, actor, build time, and run number.

```text
GitHub Workspace
└── output/
    └── build-info.txt
```

* The **GitHub Workspace** is a directory created on the **GitHub Actions runner** for every job. After the repository is checked out, all workflow steps and Composite Actions execute from this workspace and share the same filesystem. Any files created by the Composite Action are therefore immediately accessible to subsequent steps in the calling workflow.

* Rather than returning the file itself, the Composite Action returns the **relative path** to the generated file as an output.

```text
build-info-path → output/build-info.txt
```

* The calling workflow can retrieve this output using:

```yaml
${{ steps.build-info.outputs.build-info-path }}
```

* Since both the calling workflow and the Composite Action execute within the **same job** on the **same GitHub Actions runner**, they share the same **GitHub Workspace**. As a result, the output **`build-info-path`** points to a file that already exists in the shared workspace, allowing subsequent steps in the calling workflow to access it directly.

For example:

```bash
cat ${{ steps.build-info.outputs.build-info-path }}
```

* In our demo, rather than simply reading the file, we will use this output in a later step of the calling workflow to upload **`build-info.txt`** as a **GitHub Actions Artifact** using **`actions/upload-artifact`**. This preserves the file beyond the workflow execution and makes it available for download from the **Artifacts** section of the workflow run.

> **Important:** The GitHub Workspace exists only for the lifetime of the current job. Once the job completes, the GitHub-hosted runner is terminated and its workspace is deleted. Consequently, any files created by the Composite Action are also removed unless they are explicitly persisted, for example, by uploading them as a workflow artifact or copying them to external storage.

* This approach improves **reusability** because the calling workflow does not need to know where or how the Composite Action generates its files. The Action simply exposes the required information through an **Action Output**, while keeping its internal implementation hidden. If the internal directory structure changes in the future, only the Composite Action needs to be updated, leaving the calling workflows unchanged.

---

```yaml
runs:
  using: composite
```

* This block tells GitHub that we are creating a **Composite Action**.

* Unlike **JavaScript Actions** or **Docker Actions**, a Composite Action executes one or more workflow steps directly on the runner.

* Each step inside the Composite Action behaves similarly to a step inside a normal GitHub Actions workflow.

---

```yaml
steps:
```

* This block defines the sequence of steps executed by the Composite Action.

* In the previous demo, our Composite Action invoked multiple **GitHub Actions**.

* In this demo, the Composite Action executes **multiple shell commands**, demonstrating another common way of implementing reusable automation.

---

```yaml
- name: Generate Build Information
  shell: bash
```

* This step executes the enclosed commands using the **Bash shell**.

* Since GitHub-hosted Ubuntu runners include Bash by default, no additional configuration is required.

* Every command inside the **run** block will execute sequentially within the same shell session.

---

```bash
set -e
```

* This command instructs Bash to **immediately terminate execution** if any command returns a non-zero exit code.

* Without this setting, the script could continue executing even after encountering an error, potentially producing incomplete or incorrect results.

* Using **set -e** is considered a **best practice** when writing shell scripts for CI/CD pipelines.

---

```bash
mkdir -p output
```

* This command creates a directory named **output**, where the generated build metadata file will be stored.

* The **-p** option ensures that the command succeeds even if the directory already exists.

* This makes the script **idempotent**, allowing it to be executed multiple times without producing unnecessary errors.

---

```bash
BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
```

* This command executes the **`date`** command using **command substitution** (`$(...)`) and stores the resulting timestamp in a **shell variable** named **`BUILD_TIME`**.

* Since **`BUILD_TIME`** is a **shell variable**, it is available only within the current shell script. It is **not** a GitHub Actions Environment Variable and is **not** accessible from subsequent workflow steps.

* The **`-u`** option instructs the **`date`** command to use **Coordinated Universal Time (UTC)** instead of the runner's local timezone.

* The generated timestamp follows the **ISO 8601** format, the industry standard used across cloud platforms, APIs, logging systems, and CI/CD pipelines.

* Using **UTC** ensures that timestamps remain consistent regardless of where the workflow executes.

---

```bash
cat <<EOF > output/build-info.txt
...
EOF
```

* This block uses a **Here Document (Heredoc)** to create the **build-info.txt** file.

* Instead of writing multiple **echo** statements, a Here Document allows us to write an entire file in a clean and readable format.

* The generated file contains both **user-provided inputs** and **GitHub Context variables**, making it a useful build manifest.

* The values enclosed within **`${{ }}`** are evaluated by **GitHub Actions** before the script executes.

* The value enclosed within **`${BUILD_TIME}`** is expanded by the **Bash shell** because it is a shell variable created during script execution.

* This is an important distinction:

  * **`${{ ... }}`** represents **GitHub Expressions**, which GitHub evaluates before executing the step.
  * **`${...}`** represents **Shell Variables**, which Bash evaluates while the script is running.

---

The following GitHub Context variables are used while generating the build metadata.

| Variable                       | Description                     |
| ------------------------------ | ------------------------------- |
| **`${{ github.repository }}`** | Repository name                 |
| **`${{ github.ref_name }}`**   | Branch name                     |
| **`${{ github.sha }}`**        | Commit SHA                      |
| **`${{ github.run_number }}`** | Workflow execution number       |
| **`${{ github.workflow }}`**   | Workflow name                   |
| **`${{ github.actor }}`**      | User who triggered the workflow |

These values are automatically populated by GitHub at runtime, allowing the Composite Action to collect useful information about the current workflow execution without requiring any additional configuration.

---

```bash
echo "======================================"
echo "Build Information"
echo "======================================"

cat output/build-info.txt
```

* Finally, the Composite Action prints the generated **build-info.txt** file to the workflow logs.

* Displaying the file in the logs allows us to immediately verify that the metadata has been generated correctly without downloading the artifact.

* In the next step, we will create a workflow that invokes this Composite Action, reads its output variable, and uploads the generated file as a workflow artifact.

---

### Step 2: Create the Workflow

Inside the **.github/workflows** directory, create a file named:

```text
build-information-demo.yml
```

Add the following content.

```yaml
name: Build Information Demo

on:
  workflow_dispatch:

jobs:
  build-information:

    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v7

      - name: Generate Build Information
        id: build-info

        uses: ./.github/actions/generate-build-info

        with:
          application-name: Cloud With VarJosh
          environment: Development

      - name: Upload Build Information
        uses: actions/upload-artifact@v4

        with:
          name: build-information
          path: ${{ steps.build-info.outputs.build-info-path }}
```

#### Explanation

---

```yaml
name: Build Information Demo
```

* This block defines the **workflow name** displayed in the **GitHub Actions UI**.

* Similar to our previous demos, the workflow name helps us easily identify the workflow execution from the Actions tab.

---

```yaml
on:
  workflow_dispatch:
```

* This workflow is configured to execute only when it is **manually triggered** from the GitHub Actions UI.

* We have discussed workflow triggers extensively in previous lectures. Using **workflow_dispatch** allows us to execute this demo repeatedly without making unnecessary commits to the repository.

---

```yaml
jobs:
  build-information:
```

This block defines the single job executed by the workflow.

Its responsibility is to:

```text
Checkout Repository
        ↓
Execute Composite Action
        ↓
Display Output Variable
        ↓
Upload Build Information
```

Notice that the workflow itself does **not** contain any shell commands for generating the build metadata.

Instead, that entire implementation has been delegated to the **Composite Action**, allowing the workflow to remain simple and focused on orchestration.

---

```yaml
runs-on: ubuntu-latest
```

* This job executes on a **GitHub-hosted Ubuntu runner**.

* As discussed throughout this course, GitHub provisions a fresh virtual machine for every workflow execution.

* Since our Composite Action executes **Bash shell commands**, Ubuntu provides everything required without any additional setup.

---

```yaml
- name: Checkout Repository
  uses: actions/checkout@v7
```

* This step checks out the repository onto the GitHub-hosted runner.

* At first glance, it might appear unnecessary because this workflow is not building an application or compiling source code.

* However, our Composite Action is stored **inside this repository**.

```text
.github/actions/generate-build-info
```

* When the workflow references the Composite Action using a **relative path**, GitHub must first download the repository contents onto the runner.

* Without checking out the repository, GitHub would not be able to locate the local Composite Action, causing the workflow to fail.

* This is an important concept to remember. **actions/checkout** is not only required for application source code, it is also required whenever a workflow references a **local Action** stored inside the repository.

---

```yaml
- name: Generate Build Information
  id: build-info

  uses: ./.github/actions/generate-build-info

  with:
    application-name: Cloud With VarJosh
    environment: Development
```

* This step executes the **Composite Action** we created in the previous step.

* Notice that the Action is referenced using a **relative path**.

```yaml
uses: ./.github/actions/generate-build-info
```

* This tells GitHub to execute the Composite Action located inside the current repository instead of downloading an Action from GitHub Marketplace.

* We also assign an **id** to this step.

```yaml
id: build-info
```

* The step ID allows subsequent workflow steps to reference any **outputs** exposed by this Composite Action.

* Finally, the **with** block passes the required input parameters.

```yaml
with:
  application-name: Cloud With VarJosh
  environment: Development
```

* These values are received by the Composite Action through the **inputs** block that we defined inside **action.yml**.

* During execution, these values become available as:

```yaml
${{ inputs.application-name }}

${{ inputs.environment }}
```

inside the Composite Action.

---

```yaml
- name: Upload Build Information
  uses: actions/upload-artifact@v4

  with:
    name: build-information
    path: ${{ steps.build-info.outputs.build-info-path }}
```

* The final step uploads the generated **build-info.txt** file as a **workflow artifact**.

* Instead of hardcoding the file path, the workflow again uses the output exposed by the Composite Action.

```yaml
path: ${{ steps.build-info.outputs.build-info-path }}
```

* This demonstrates another advantage of exposing outputs.

* If the Composite Action ever changes the internal location of the generated file, only the Action needs to be updated. Any workflows consuming the output can continue working without modification.

* Once the workflow completes successfully, the uploaded artifact appears in the **Artifacts** section of the workflow run.

* Users can download this artifact directly from GitHub Actions without accessing the runner or repository.

---

### Step 3: Commit and Push the Changes

Once the Composite Action and workflow have been created, commit the changes and push them to the GitHub repository.

```bash
git add .

git commit -m "Add Composite Action for generating build information"

git push origin main
```

After the changes have been pushed successfully, GitHub automatically updates the repository, making the new Composite Action and workflow available for execution.

---

### Step 4: Execute the Workflow

Navigate to your GitHub repository and open the **Actions** tab.

From the list of available workflows, select **Build Information Demo**.

Click **Run workflow**, choose the desired branch if prompted, and then click **Run workflow** once again.

GitHub provisions a new runner and starts executing the workflow.

Since this workflow uses the **workflow_dispatch** trigger, it will only execute when manually started.

---

### Step 5: Observe the Workflow Execution

Once the workflow starts, the execution flow should resemble the following.

```text
Checkout Repository
        ↓
Generate Build Information
        ↓
Display Output Variable
        ↓
Upload Build Information
```

Unlike the previous demo, this Composite Action does not invoke other GitHub Actions internally. Instead, it executes a series of **Bash shell commands** to generate the build metadata.

Expand the **Generate Build Information** step to view its execution logs.

You should see output similar to the following.

```text
======================================
Build Information
======================================
Application : Cloud With VarJosh
Environment : Development
Repository  : CloudWithVarJosh/gha-practice-demo
Branch      : main
Commit SHA  : 4dbbbfe44d5e2a4d...
Run Number  : 8
Workflow    : Build Information Demo
Triggered By: CloudWithVarJosh
Build Time  : 2026-07-21T01:28:52Z
```

Notice that the Composite Action automatically populated several values from the **GitHub Context**, while the **Application** and **Environment** values came from the workflow inputs.

This clearly demonstrates how a Composite Action can combine **workflow inputs**, **GitHub Context variables**, and **shell variables** to generate useful artifacts during workflow execution.

---

After the Composite Action completes successfully, the workflow executes the next step.

```text
Build information generated at:
output/build-info.txt
```

This output confirms that the workflow successfully consumed the **output variable** exposed by the Composite Action.

Rather than hardcoding the file location, the workflow simply reads the value returned by the Action.

This is one of the key advantages of exposing **outputs**, as it allows workflows to consume information without needing to understand the internal implementation of the Composite Action.

---

Finally, the workflow uploads the generated **build-info.txt** file as a workflow artifact.

Open the **Artifacts** section of the completed workflow run.

You should see an artifact named:

```text
build-information
```

Download and extract the artifact.

Inside the downloaded archive, you will find the generated **build-info.txt** file.

Its contents should resemble the following.

```text
Application : Cloud With VarJosh
Environment : Development
Repository  : CloudWithVarJosh/gha-practice-demo
Branch      : main
Commit SHA  : 4dbbbfe44d5e2a4d...
Run Number  : 8
Workflow    : Build Information Demo
Triggered By: CloudWithVarJosh
Build Time  : 2026-07-21T01:28:52Z
```

Notice that the information stored inside the artifact is exactly the same as the information displayed in the workflow logs.

This is a common practice in CI/CD pipelines, where build metadata is both **logged for immediate visibility** and **stored as an artifact** for future reference.

---


### Demo 2 Key Takeaways

Through this demo, we learned how to build a **Composite Action** that executes **multiple shell commands** instead of invoking existing GitHub Actions.

More importantly, we saw how a Composite Action can:

* Accept **inputs** from a workflow.
* Access **GitHub Context** values.
* Execute multiple **Bash commands**.
* Generate files during workflow execution.
* Expose **outputs** back to the calling workflow.
* Share generated files using **workflow artifacts**.

These capabilities make Composite Actions an excellent choice for packaging **reusable automation** that can be shared across multiple workflows while keeping workflow definitions clean, maintainable, and easy to understand.

Although this demo generated a simple **build-info.txt** file, the same pattern is widely used in production CI/CD pipelines. Most organizations generate **build metadata** during every pipeline execution to improve **traceability**, **auditing**, **troubleshooting**, and **release management**.

Instead of manually investigating deployments, teams can inspect the generated metadata to answer questions such as:

* **Which repository produced this build?**
* **Which branch was used?**
* **Which commit was deployed?**
* **Who triggered the deployment?**
* **Which workflow generated the artifact?**
* **When was the build created?**

Large organizations typically generate metadata files such as:

```text
build-info.txt
manifest.json
build.properties
version.properties
release.yaml
metadata.json
```


**These files commonly include information such as:** **application name**, **version number**, **repository**, **branch**, **commit SHA**, **build timestamp**, **pipeline number**, **workflow name**, **triggering user**, **build environment**, **Docker image tag**, and **artifact version**.


Rather than duplicating the same shell scripts across dozens or hundreds of repositories, organizations package this logic into a **Composite Action**. Development teams simply invoke the Action whenever required, ensuring that build metadata is generated in a **consistent format** across the organization. This reduces duplication, improves maintainability, and promotes standardization throughout the CI/CD platform.

---

## Conclusion

In this lecture, we learned **why GitHub Custom Actions exist**, **what they are**, and how they help organizations eliminate duplicated workflow logic by packaging reusable automation into a single component.

We then explored **Composite Actions**, understanding where they fit within GitHub Actions and why they are the **recommended starting point** for creating reusable automation. Through two practical demonstrations, we created Composite Actions by combining **existing GitHub Actions** as well as **multiple shell commands**, learned how to work with **inputs**, **outputs**, and the **GitHub Context**, and saw how workflows consume Custom Actions using the **`uses`** keyword.

In the next lecture, we will build upon this foundation by exploring **JavaScript Actions** and **Docker Actions**, understand when each type should be used, and implement them through practical demonstrations. 

---

## References

* **GitHub Documentation**

  * [https://docs.github.com/en/actions](https://docs.github.com/en/actions)

* **Creating Composite Actions**

  * [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action)

* **Creating JavaScript Actions**

  * [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-javascript-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-javascript-action)

* **Creating Docker Actions**

  * [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-docker-container-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-docker-container-action)

* **GitHub Marketplace**

  * [https://github.com/marketplace?type=actions](https://github.com/marketplace?type=actions)

---
