# GitHub Actions: Production-Grade DevSecOps & GitOps Pipeline
## Video reference for this lecture is the following:



---

## ⭐ Support the Project  

If this **repository** helps you, give it a ⭐ to show your support and help others discover it! 

---

## Need Personalized Guidance on Cloud & DevOps?

Whether you're starting your Cloud & DevOps journey, preparing for interviews, pursuing certifications, designing cloud architectures, enhancing your resume, or planning your next career move, I'm here to help. Book a personalized 1:1 mentoring session tailored to your goals.

👉 **[Book a 1:1 Mentoring Session](https://topmate.io/cloudwithvarjosh)**

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
| **Docker** | Basic understanding of container images, Dockerfiles, building images, and running containers | The required concepts will be introduced during the relevant stage of this project. |
| **Kubernetes** | Basic Kubernetes concepts such as Pods, Deployments, Services, namespaces, configuration, and application deployment | **YouTube:** [CKA Course Preparation](https://lnkd.in/g-7UEQfk) <br> **YouTube:** [Kubernetes Projects Playlist](https://lnkd.in/gg4tFfTD) |
| **AWS** | Basic understanding of AWS services, IAM, ECR, EKS, and AWS authentication | The AWS concepts required for each stage will be introduced during the project. |
| **Argo CD & GitOps** | Basic understanding of GitOps, declarative deployments, Git as the source of truth, and how Argo CD synchronizes applications with Kubernetes | **YouTube:** [Argo CD Tutorial Series](https://youtu.be/m4lDTQwK1T8) |

> **Note:** You do not need to master all of these technologies before starting. The goal is to have a **basic understanding of the technologies that GitHub Actions will integrate with** throughout this project. We will introduce the specific concepts required at each stage, and deeper knowledge will be called out whenever necessary.

---

## GitHub Actions: Production-Grade DevSecOps & GitOps Pipeline

### What are we going to do?

In this demo, we build a **production-grade DevSecOps pipeline** using **GitHub Actions**, **Maven**, **SonarQube**, **Trivy**, **AWS ECR**, **Amazon EKS**, and **Argo CD**. We integrate **automated testing, code quality, security scanning, containerization, artifact promotion, and environment-based deployments**, while using **OIDC-based AWS authentication**, **immutable image tags**, and **GitOps** for production delivery.

---

## Stage 1: Create the Git Repository and Workflow Structure

In this stage, we will create the initial project structure, create our GitHub repository, and establish the foundation of our GitHub Actions workflow.

### Task 1: Create the Project Directory Structure

* Create a local directory named **`project-files`**.
* This directory will contain all the files that we **create or modify throughout the Mega Project**.
* Inside `project-files`, create the following directory structure:

```text
project-files/
├── java-maven/
│   ├── src/
│   └── pom.xml
│
└── .github/
    └── workflows/
        └── mega-demo.yaml
```

* The `java-maven` directory will contain our **Java application and Maven configuration**.
* The `.github/workflows` directory will contain our **GitHub Actions workflow**.
* The contents of `project-files` will eventually be **pushed to the root of the `mega-project-demo` repository**.

> **Production Insight:** Keeping the application code and GitHub Actions workflow in the same repository provides **a single source of truth for both the application and the automation that builds, tests, and delivers it**.


---

### Task 2: Create the GitHub Repository

* Create a new GitHub repository with the following configuration:

  * **Repository Name:** `mega-project-demo`
  * **Visibility:** Private

* Do not initialize the repository with a README, `.gitignore`, or license, as we already have the project structure locally.

* We will configure **SSH-based Git authentication** when we initialize the local repository and push the project to GitHub in the next task.



---

### Task 3: Create the Initial GitHub Actions Workflow

* Create the `mega-demo.yaml` workflow under `.github/workflows/`.
* Add the following initial workflow configuration:

```yaml
name: Mega Demo

on:
  push:
    branches:
      - 'feature/**'
      - 'bugfix/**'
      - 'hotfix/**'
    paths:
      - 'java-maven/**'
      - '.github/workflows/**'

  pull_request:
    branches:
      - main
    paths:
      - 'java-maven/**'
      - '.github/workflows/**'

  workflow_dispatch:
```

* The `name` property defines the **display name of the workflow** in GitHub Actions.
* The `push` trigger runs the workflow when changes are pushed to:

  * `feature/**`
  * `bugfix/**`
  * `hotfix/**`
* The `pull_request` trigger runs the workflow when a Pull Request targets **`main`**.
* The `paths` filters ensure that the workflow runs only when changes are made to:

  * `java-maven/**`
  * `.github/workflows/**`
* There is intentionally **no `push` trigger for `main`**. Direct pushes to `main` will be blocked through repository governance, and changes will reach `main` through Pull Requests.
* **`workflow_dispatch` allows us to manually trigger the workflow** when we need to test or demonstrate a specific stage without making an unnecessary code change.


The initial development flow is:

```text
Feature/Bugfix/Hotfix Branch → Pull Request → main
```

> **Production Insight:** Keeping `main` outside the direct `push` trigger reinforces the principle that **production code should enter the protected branch through a controlled Pull Request process**, rather than through direct developer pushes.


---

## Stage 2: Establish Repository Governance and Environments

In this stage, we will establish how changes are allowed to enter our production code line and create the DEV and PROD environments that will be used later in the workflow.

### Task 1: Establish the Branching Strategy and Branch Protection

* Adopt a **trunk-based development** approach with `main` as the primary branch representing our production code. Development will happen through short-lived `feature/*`, `bugfix/*`, and `hotfix/*` branches.
* Configure repository rules to **protect `main` and prevent direct pushes**. Changes must reach `main` through a Pull Request, with Pull Requests targeting `main` requiring **at least one approval** before they can be merged. Where supported, the Pull Request author should not be allowed to approve their own Pull Request.
* We will configure **required status checks** later, once our GitHub Actions workflow contains meaningful CI checks. This allows repository governance to evolve alongside the automation rather than configuring checks that do not yet exist.

The development flow will therefore be:

```text
Feature/Bugfix/Hotfix Branch → Pull Request → Review → main
```

> **Production Insight:** Treating `main` as the production code line and requiring reviewed Pull Requests creates **a controlled and auditable path for changes to reach production**.

---

### Task 2: Create GitHub Environments

* Create two GitHub Environments, **`dev`** and **`prod`**, with `dev` used for development deployments and `prod` used for production deployments.
* Configure the **`prod` environment to require approval** before a production deployment can proceed.
* Keep the environment configuration minimal for now. Environment-specific variables, secrets, AWS access, and deployment configuration will be introduced when those capabilities are added in later stages.

Our eventual deployment flow will be:

```text
main → DEV → Validation → PROD → Approval
```

> **Production Insight:** GitHub Environments allow us to separate deployment targets and apply different controls to each environment. In production, successful workflow execution and authorization to deploy should be treated as two separate concerns.

---


## Stage 3: Establish the GitHub Actions Workflow Foundation

In this stage, we will create the **first GitHub Actions workflow** for our three-tier application and establish the basic execution flow. We will intentionally start with a single **checkout step**, allowing us to understand how a workflow is triggered, how GitHub provisions a runner, and how the repository source code becomes available to that runner. We will progressively extend this foundation with build, test, quality, security, containerization, and deployment capabilities in the upcoming stages.

**Initial flow:**

`GitHub Event → Workflow → Runner → Checkout Source Code → Success`

---

### Task 1: Prepare the Application Repository

Add the working **three-tier application** to the repository, including the React frontend, Spring Boot backend, database migration, container definitions, documentation, and the GitHub Actions workflow.

Expected structure:

```text
project-files/
├── cwvj-3tier-mega-project/
│   ├── frontend/
│   │   ├── src/
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   ├── Dockerfile
│   │   └── .gitignore
│   │
│   ├── backend/
│   │   ├── src/
│   │   ├── pom.xml
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   └── .gitignore
│   │
│   └── README.md
│
└── .github/
    └── workflows/
        └── mega-demo.yaml
```

The purpose of this stage is to establish the initial GitHub Actions execution flow, with build and test capabilities introduced progressively in later stages.

> **Production Insight:** Keep **source code and automation definitions in Git**, but do not commit generated build artifacts such as Maven `target/` directories or frontend build output. CI should generate these artifacts from the source code during each workflow execution, providing a reproducible build from a clean runner.

---

### Task 2: Configure the Initial CI Workflow

Update `.github/workflows/mega-demo.yaml` with the initial CI workflow:

```yaml
name: GitHub Actions Mega Project

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

  pull_request:
    branches:
      - main
    paths:
      - 'cwvj-3tier-mega-project/frontend/**'
      - 'cwvj-3tier-mega-project/backend/**'
      - '.github/workflows/**'

  workflow_dispatch:

jobs:
  backend-job:
    name: Backend Build, Test and Quality Analysis
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source code
        uses: actions/checkout@v7
```

The workflow now follows:

`Trigger → Checkout`

At this point, we have **defined the workflow but have not executed it yet**. We will execute it after pushing the project to GitHub.

* `push` triggers CI for changes pushed to `feature/**`, `bugfix/**`, and `hotfix/**`.

* `pull_request` triggers CI when a Pull Request targets `main`.

* `workflow_dispatch` allows us to **manually trigger the workflow** when testing or demonstrating a specific stage without making an unnecessary code change.

* `actions/checkout` makes the repository source code available on the GitHub-hosted runner.

The remaining CI capabilities, including **Java setup, Maven caching, compilation, and unit testing**, will be introduced progressively in later tasks as we build the workflow.


---

### Task 3: Create the Private GitHub Repository and Configure SSH Authentication

Now that the application and initial workflow are ready locally, we need to create the remote GitHub repository and authenticate our local Git client.

---

#### Step 1: Create a Private Repository

Since enterprise applications commonly use private repositories, we will use a private repository for this project as well.

Create a new repository with:

* **Repository Name:** `mega-project-demo`
* **Visibility:** Private

Do not initialize the repository with:

* README
* `.gitignore`
* License

We already have the required project files locally and will push them to GitHub manually.

---

#### Step 2: Generate an SSH Key Pair

We will use SSH authentication for Git operations.

Generate a dedicated SSH key for this project:

```bash
ssh-keygen -t ed25519 \
  -C "cloudwithvarjosh@gmail.com" \
  -f ~/.ssh/cwvj_mega_project_ed25519
```

This creates:

```text
~/.ssh/cwvj_mega_project_ed25519
~/.ssh/cwvj_mega_project_ed25519.pub
```

The **private key must remain on your machine** and must never be shared. The public key will be added to GitHub.

* `-t ed25519` specifies the key algorithm.
* `-C` adds an identification comment to the key.
* `-f` specifies the key file and location.

The value supplied with `-C` is only metadata for identification and does not participate in authentication.

---

### Step 3: Configure the SSH Agent

We have generated an SSH key pair, but Git needs access to the private key when communicating with GitHub. The SSH agent securely keeps the private key available in memory so SSH-based Git operations can use it without repeatedly specifying the key.

Before loading our project-specific key, we will **remove any existing keys from the SSH agent** so that only the intended key is used.

Run the following commands in sequence:

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Remove all keys currently loaded in the SSH agent
ssh-add -D

# Load the project's private key into the SSH agent
ssh-add ~/.ssh/cwvj_mega_project_ed25519

# Verify that only the project's key is loaded
ssh-add -l
```

If successful, `ssh-add -l` displays the fingerprint of the loaded project key.

> **Why do we need this?** The SSH key pair establishes trust between our local machine and GitHub, while the **SSH agent provides access to the private key during authentication**. Removing existing keys first ensures that the SSH agent uses the intended project key rather than another key already loaded in memory. The private key remains on the local machine and is never uploaded to GitHub.

---

#### Step 4: Add the Public Key to GitHub

Display the public key:

```bash
cat ~/.ssh/cwvj_mega_project_ed25519.pub
```

Copy the complete output and navigate to:

`GitHub → Profile Picture → Settings → SSH and GPG Keys → New SSH Key`

Provide:

* **Title:** `cwvj-mega-project`
* **Key:** Paste the public key

GitHub can now authenticate Git operations originating from this machine using the corresponding private key.

---

### Task 4: Push the Project to GitHub

Now that the remote repository and SSH authentication are ready, we will initialize Git locally, create the initial `main` branch, push the project to GitHub, and then create a feature branch to trigger our first CI workflow.

From the `project-files` directory, run the following commands in sequence:

```bash id="7g8k8u"
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

# Push main to GitHub, establish origin/main as the upstream branch, and allow future pushes from main to use simply "git push".
git push -u origin main
```

At this point, the initial project structure exists on GitHub, but **the workflow will not run yet** because our workflow does not trigger on pushes to `main`.

Since the workflow currently contains **only checkout**, the feature-branch section and verification should also reflect that. There is one important change: because the feature branch is created from the same commit as `main`, **the push event will be generated, but the workflow will be skipped by the `paths` filter**. We then use `workflow_dispatch` for the first actual execution.

Now create a feature branch for the first CI execution:

```bash
# Create and switch to a feature branch
git checkout -b feature/initial-ci

# Push the local feature branch to GitHub, creating the remote branch if it
# does not already exist, and establish it as the upstream branch so future
# pushes can use simply "git push"
git push -u origin feature/initial-ci
```

> **Tip:** The local and remote branch names do not have to be the same. The syntax is `git push -u origin <local-branch>:<remote-branch>`. For example, `git push -u origin feature/initial-ci:feature/ci-demo` pushes the local `feature/initial-ci` branch to a remote branch named `feature/ci-demo`.

This push matches the **branch** condition in our workflow:

```yaml
push:
  branches:
    - 'feature/**'
```

However, the workflow also has a **`paths` filter**:

```yaml
paths:
  - 'cwvj-3tier-mega-project/frontend/**'
  - 'cwvj-3tier-mega-project/backend/**'
  - '.github/workflows/**'
```

Because `feature/initial-ci` was created from the same commit as `main` and no new changes were introduced under these paths, the **push event occurs, but the workflow is skipped by the `paths` filter**.

This is exactly why we added `workflow_dispatch` to the workflow. It allows us to **manually trigger the workflow from the GitHub Actions UI without making an unnecessary code change just to trigger CI**.

The current flow is therefore:

`Local main → GitHub main → feature/initial-ci → Push → Branch filter matches → Paths filter finds no matching changes → Workflow skipped → Manually trigger via workflow_dispatch → GitHub Actions → Checkout → Success`

> **Production Insight:** Path filters help avoid unnecessary CI executions when a change cannot affect the application or workflow. At the same time, `workflow_dispatch` provides a controlled way to run the workflow on demand for testing, troubleshooting, or operational purposes.

---

### Task 5: Verify the Workflow Execution

* **Open the workflow:** Go to **GitHub → Repository → Actions → GitHub Actions Mega Project**, select the `feature/initial-ci` branch if required, and click **Run workflow** to manually start the workflow. This demonstrates the purpose of `workflow_dispatch` without creating an unnecessary code change just to trigger CI.

* **Inspect the execution:** Verify the **workflow status**, `Workflow Foundation` job, **runner operating system**, `Checkout source code` step, execution logs, and overall execution duration.

* **Expected execution flow:** `GitHub → Runner → Checkout → Success`

* **CI checkpoint:** A successful execution confirms that GitHub Actions can **trigger the workflow, provision a GitHub-hosted runner, and check out the repository source code**. We can now progressively introduce the actual build and test capabilities.

> **Production Insight:** A CI workflow should be built incrementally. Establishing and verifying the workflow foundation first gives us a known-good starting point before adding compilation, testing, code quality, security scanning, containerization, and deployment.

---

## Stage 4: Integrate Trivy Filesystem Security Scanning

In this stage, we extend the existing GitHub Actions workflow from Stage 3 by introducing **Trivy filesystem scanning as a dedicated job**. This separates repository-wide security scanning from application-specific build and test jobs, making the workflow easier to maintain and extend.

**Initial flow:** `Trivy Repository Scan ∥ Backend Build, Test and Quality Analysis ∥ Frontend Build`

---

### Task 1: Add a Dedicated Trivy Security Scanning Job

Update `.github/workflows/mega-demo.yaml` by adding a new `trivy-scan-job` job under the existing `jobs:` section. **Keep the existing `backend` and `frontend` jobs unchanged.**

```yaml
  trivy-scan-job:
    name: Repository Filesystem Security Scan
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source code
        uses: actions/checkout@v7

      - name: Run Trivy repository filesystem scan
        uses: aquasecurity/trivy-action@v0.36.0
        with:
          scan-type: fs
          scan-ref: ${{ github.workspace }}
          severity: HIGH,CRITICAL
          exit-code: '1'
```

#### Explanation

- **Dedicated job:** `trivy-scan-job` separates repository security scanning from backend and frontend responsibilities. Because no job dependencies are defined, GitHub Actions can run the three jobs **in parallel**.
- **Repository-wide target:** `scan-ref: ${{ github.workspace }}` targets the checked-out repository, including frontend, backend, and workflow files.
- **Failure behavior:** `severity: HIGH,CRITICAL` selects findings at those severity levels, while `exit-code: '1'` fails the Trivy step when matching findings are detected.
- **Independent execution:** A Trivy failure **will not automatically stop the backend and frontend jobs**. We can introduce job dependencies later if security scanning must pass before builds or deployments proceed.

> **Production Insight:** Separate jobs by responsibility, then use `needs` to define dependencies when one job's successful completion must be required before another can proceed.

---

### Task 2: Push the Changes and Verify the Scan

Commit and push the updated workflow to your existing feature branch:

```bash
# Stage the updated workflow
git add .github/workflows/mega-demo.yaml

# Commit the Trivy integration
git commit -m "ci: add Trivy filesystem security scan"

# Push the changes and trigger the workflow
git push
```

Navigate to **GitHub → Repository → Actions → GitHub Actions Mega Project** and inspect the latest execution. Verify that the **Repository Filesystem Security Scan** job runs and review the Trivy logs for the scan summary and findings.

**Expected execution:** `Push → (Trivy Repository Scan ∥ Backend Build and Test ∥ Frontend Build)`

If Trivy detects matching **HIGH or CRITICAL findings**, its job should fail while the other jobs may still complete.

---

### Task 3: Simulate Security Findings

Since the repository currently passes the scan, temporarily introduce test findings to demonstrate Trivy's detection capabilities.

**A. Add a vulnerable dependency** to the existing `<dependencies>` section in `cwvj-3tier-mega-project/backend/pom.xml`:

```xml
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.14.0</version>
</dependency>
```

Log4j 2.14.0 is an intentionally outdated version with known vulnerabilities. This provides a test case for Trivy's dependency scanning.

**B. Add a synthetic credential pattern** by creating `secrets.txt` in the repository root, alongside the root `README.md`:

```text
AWS_ACCESS_KEY_ID=AKIAAAAAAAAAAAAAAAAA
```

This is a **synthetic test value, not a real AWS credential**. Trivy's secret detection rules may flag it depending on their matching rules.

**C. Commit and push the test changes**

We are working on the **`feature/initial-ci`** branch. Commit and push the intentional test findings to this branch:

```bash
# Confirm the current branch
git branch --show-current

# Stage the test files
git add cwvj-3tier-mega-project/backend/pom.xml secrets.txt

# Commit the test changes
git commit -m "test: simulate Trivy security findings"

# Push to the feature branch
git push origin feature/initial-ci
```
Inspect the **Repository Filesystem Security Scan** job in GitHub Actions. Confirm which findings Trivy reports and whether they meet the configured **HIGH or CRITICAL severity threshold**.

---

### Task 4: Remove the Test Findings

After reviewing the results, remove the Log4j dependency from `pom.xml` and delete `secrets.txt`. Continue working on **`feature/initial-ci`** so the cleanup triggers another workflow run.

```bash
# Confirm the current branch
git branch --show-current

# Stage the dependency cleanup
git add cwvj-3tier-mega-project/backend/pom.xml

# Delete and stage removal of the synthetic secret file
git rm secrets.txt

# Commit the cleanup
git commit -m "chore: remove intentional Trivy test findings"

# Push the cleanup to the feature branch
git push origin feature/initial-ci
```

Verify that the next workflow run passes the Trivy scan.

---

## Stage 5: Build and Validate the Application

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

#### Backend Job

```yaml
jobs:
  backend-job:
    name: name: Backend Build, Test and Quality Analysis
    runs-on: ubuntu-latest
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
```
#### Explanation

```yaml
jobs:
  backend-job:
    name: Backend Build and Test
    runs-on: ubuntu-latest
    needs: trivy-scan-job
```

* The **`jobs`** block defines the individual jobs that make up a GitHub Actions workflow.
* **`backend-job`** is the unique identifier for this job, which can be referenced later when defining dependencies between jobs.
* **`name`** provides the human-readable name displayed for the job in the GitHub Actions UI.
* **`runs-on: ubuntu-latest`** tells GitHub Actions to provision an Ubuntu runner for this job.
* **`needs: trivy-scan-job`** establishes a dependency on the Trivy repository filesystem scan. The backend job runs only after the scan succeeds, and is skipped by default if the scan fails. Once Trivy succeeds, the backend job can run in parallel with the frontend job.

> **Production Insight:** GitHub-hosted runner labels such as `ubuntu-latest` are managed by GitHub and can move to newer OS versions over time. This provides access to supported runner environments, but production workflows with strict OS compatibility requirements may benefit from a specific runner image or a controlled, versioned self-hosted runner environment.


---

```yaml
defaults:
  run:
    working-directory: cwvj-3tier-mega-project/backend
```

* The **`defaults.run`** block defines default settings for commands executed using `run` within this job.
* **`working-directory`** sets the backend directory as the default location for those commands.
* As a result, commands such as `mvn test` can be executed directly without repeatedly specifying the complete backend path.
* This is important for our project because the backend is located inside **`cwvj-3tier-mega-project/backend`**, rather than at the repository root.

> **Production Insight:** Job-level working directories are particularly useful in **monorepos**, where multiple applications can live in the same repository while using different build systems and directory structures. 
> In a **multi-repository architecture**, such as separate repositories for the frontend and each microservice, each repository can have its own GitHub Actions workflow and build configuration, allowing different teams to independently build, test, release, and deploy their applications.
>
> ```text
> Monorepo:
> Frontend + Backend + Services → One Repository → One or More → working-directory Separates Components (like backend & frontend)
>
> Multi-repo:
> Frontend Repo → Frontend Workflow
> Backend Repo  → Backend Workflow
> Service A Repo → Service A Workflow
> Service B Repo → Service B Workflow
> ```
>
> A multi-repository architecture does **not** necessarily mean that every repository must maintain completely independent workflow logic. When multiple repositories require common CI/CD behavior, **Reusable Workflows** can centralize that common logic and allow individual repositories to invoke it with their own inputs and configuration. This provides a balance between **team independence** and **standardized CI/CD practices** across an organization.



> **Note:** If a single workflow needs to coordinate applications stored in multiple repositories, GitHub Actions can be designed to do so, but that introduces additional considerations around **repository access, authentication, triggers, artifacts, and cross-repository dependencies**. For independently owned services, separate repository workflows with reusable workflows for common CI/CD logic are often a cleaner model.


---

```yaml
steps:
  - name: Checkout source code
    uses: actions/checkout@v7
```

* The **`steps`** block contains the individual operations performed by the job.
* Steps execute in the order in which they are defined.
* The **Checkout source code** step uses GitHub's official `actions/checkout` action to make the repository source code available on the runner.
* GitHub provisions the runner as a clean environment, so the repository contents are not automatically available to the job.
* The checkout must therefore happen before the workflow can access the backend's `pom.xml`, Java source code, or other project files.

---

```yaml
- name: Set up Java
  uses: actions/setup-java@v6
  with:
    distribution: temurin
    java-version: '21'
    cache: maven
```

* This step configures the **Java environment** required by our Spring Boot backend.
* **`actions/setup-java@v6`** is GitHub's official action for configuring Java on the runner.
* **`distribution: temurin`** selects the Eclipse Temurin Java distribution.

  > **Why we chose it:** Temurin provides a widely used, production-ready OpenJDK distribution and gives us a consistent Java runtime for the CI environment.
* **`java-version: '21'`** ensures that CI uses Java 21, matching the Java version configured for our application.

  > **Why we chose it:** Our Spring Boot backend is built and tested against Java 21, so explicitly defining the version prevents the workflow from depending on the Java version preinstalled on the GitHub-hosted runner.
* **`cache: maven`** enables Maven dependency caching through `setup-java`.

  > **Why we chose it:** Maven dependencies do not need to be downloaded from scratch on every workflow run when the dependency definition has not changed, which can significantly reduce CI execution time.


> **Production Insight:** Explicitly defining the runtime version in CI prevents builds from depending on whatever version happens to be available on the runner. This reduces **environment drift** and makes builds more reproducible.

---

```yaml
- name: Verify Java version
  run: java --version
```

* This step displays the Java version configured on the GitHub Actions runner.
* It provides an immediate verification that the workflow is using the expected **Java 21** runtime.
* Because the output is available directly in the workflow logs, it can also help troubleshoot unexpected runtime-version issues during CI execution.

> **Operational Tip:** Simple environment verification steps are inexpensive but useful during workflow development and troubleshooting. They make the runtime environment visible directly in the CI logs.

---

### Task 2: Build, Test, and Package the Backend

The Java environment is now ready. We can use Maven to compile the Spring Boot application, execute its unit tests, generate the code coverage report, and package the application into a JAR file.

```yaml
- name: Build, test, and package backend
  run: mvn --batch-mode clean verify
```

- This step uses **Maven** to execute the `verify` phase of Maven's **default lifecycle**. Maven executes the preceding phases in sequence, including compilation, testing, and packaging.
- A **lifecycle is a logical sequence of build phases**, such as `validate`, `compile`, `test`, `package`, and `verify`. The lifecycle itself does not perform the compilation or testing.
- A **phase** represents a specific stage within that lifecycle. When Maven reaches a phase, it invokes the appropriate **plugins and their goals** bound to that phase.
- For our Java project, the **Maven Compiler Plugin** compiles the source code, the **Maven Surefire Plugin** executes unit tests, the **Spring Boot Maven Plugin** packages the application, and the **JaCoCo Maven Plugin** generates the code coverage report.

The conceptual flow is:

```text
mvn --batch-mode clean verify
                ↓
       Maven Default Lifecycle
                ↓
       Compile source code
                ↓
         Run unit tests
                ↓
        Package application
                ↓
       Generate coverage report
                ↓
          Verify phase
```

- The `clean` phase removes output from previous builds, helping ensure that the build starts with fresh artifacts. Maven then executes the lifecycle phases leading up to `verify`.
- **Unit tests** are typically executed by the **Maven Surefire Plugin** during the `test` phase. For integration tests, Maven commonly uses the **Maven Failsafe Plugin**, typically with the `integration-test` and `verify` phases. We are focusing on unit tests in this project for now.
- **Code coverage** is collected by tools such as the **JaCoCo Maven Plugin**. With our JaCoCo configuration, the coverage report is generated during the `verify` phase and can be imported by SonarQube in the next step.
- **Packaging** produces the application JAR, which we will use later when building the backend's Docker image. The exact JAR filename depends on the Maven project configuration.

```text
Backend Build Outputs
────────────────────────────────────────────
Unit Test Results → Surefire reports
Code Coverage    → target/site/jacoco/jacoco.xml
Packaged JAR     → target/*.jar
```

- **`--batch-mode`** runs Maven in non-interactive mode, which is appropriate for automated CI environments.
- If compilation or a unit test fails, Maven returns a non-zero exit code and GitHub Actions marks the step and job as failed. Because the build stops on failure, the workflow will not proceed to subsequent steps in that job.

**Production Insight:** A Maven lifecycle is a logical build model, while plugins perform the actual work through their goals. By choosing the appropriate lifecycle phase, we can compile, test, package, and verify the application in a single command rather than maintaining separate commands for each activity.


---

### Task 3: Configure the Frontend CI Job

The frontend uses a different technology stack from the backend. Instead of Java and Maven, the React application requires **Node.js and npm**.

We will therefore create a separate job with its own runtime and dependency cache.

### Frontend Job

```yaml
frontend-job:
  name: Frontend Build
  runs-on: ubuntu-latest
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
```

### Explanation

```yaml
frontend-job:
  name: Frontend Build
  runs-on: ubuntu-latest
  needs: trivy-scan-job
```

* **`frontend-job`** is the unique job ID for the React frontend.
* **`needs: trivy-scan-job`** establishes a job dependency, ensuring the frontend job runs only after the Trivy repository filesystem scan completes successfully. If the scan fails, the frontend job is skipped by default.
* **`name`** provides the display name shown in the GitHub Actions UI.
* **`runs-on`** provisions a fresh Ubuntu runner for the frontend job. GitHub Actions jobs execute independently by default, so this job has its own runner and can configure its runtime without depending on the backend's Java environment.

---

```yaml
defaults:
  run:
    working-directory: cwvj-3tier-mega-project/frontend
```

* This sets the frontend directory as the default working directory for commands executed using `run`.
* Commands such as `npm ci` and `npm run build` can therefore be executed without specifying the frontend path each time.
* Notice that the backend and frontend have different working directories because they are separate application components.

---

```yaml
- name: Checkout source code
  uses: actions/checkout@v7
```

* The frontend job also requires the repository source code on its runner.
* Jobs use separate runners, so the checkout performed by the backend job is **not shared** with the frontend job.
* Each job therefore performs its own checkout.

> **Production Insight:** GitHub Actions jobs should be treated as **independent execution environments** unless data is deliberately shared through mechanisms such as artifacts, caches, outputs, or external storage.

---

```yaml
- name: Set up Node.js
  uses: actions/setup-node@v6
  with:
    node-version: '22'
    cache: npm
    cache-dependency-path: cwvj-3tier-mega-project/frontend/package-lock.json
```

* This step configures **Node.js** for the React frontend.
* **`actions/setup-node@v6`** is GitHub's official action for configuring Node.js.
* **`node-version: '22'`** explicitly selects Node.js 22 for the CI environment.
* **`cache: npm`** enables npm dependency caching through `setup-node`.
* **`cache-dependency-path`** specifies the dependency lockfile that should be used when generating the cache key.

> **What is `package-lock.json`?** `package-lock.json` is an npm-generated lockfile that records the **exact versions of the dependencies** required by the project, including their dependency relationships. It allows CI and other developers to reproduce the same dependency installation instead of resolving potentially different versions each time.

> **Why we chose it:** Our frontend `package-lock.json` is located inside `cwvj-3tier-mega-project/frontend`, rather than at the repository root. Explicitly providing `cache-dependency-path` ensures that `setup-node` uses the **correct frontend lockfile** when generating the dependency cache key.

* The `package-lock.json` itself is **not what gets cached**. Its contents are used to generate the cache key.

* If the lockfile remains unchanged, the same cache key can result in a **cache hit**, allowing npm to reuse the cached package data.

* If the lockfile changes, its hash changes and a **new cache key** is generated. The required dependency data can then be downloaded and cached for subsequent workflow runs.

* The actual npm package data is stored in the **GitHub Actions dependency cache**. `node_modules` is not cached by `setup-node`.

* Notice that the frontend uses **npm caching and `package-lock.json`**, while the backend uses **Maven caching and `pom.xml`**. Both serve the same purpose, but each uses the dependency-management mechanism native to its technology stack.

> **Production Insight:** Different application components can require completely different build ecosystems. A production CI workflow should configure each component using its **native tooling and dependency-management mechanism** rather than trying to standardize everything around one build system.


---

```yaml
- name: Verify Node.js and npm versions
  run: |
    node --version
    npm --version
```

* This step displays the Node.js and npm versions available on the runner.
* Both commands are grouped into a single `run` block because they validate the same frontend build environment.
* The versions are visible directly in the workflow logs, which makes runtime troubleshooting easier.

---

```yaml
- name: Install frontend dependencies
  run: npm ci
```

* This step installs the frontend dependencies defined by `package.json` and locked in **`package-lock.json`**.
* **`npm ci`** is designed for clean, automated environments such as CI runners.
* It installs the dependency versions recorded in the lockfile rather than resolving a potentially different set of versions during every workflow execution.
* The command also ensures that the CI environment starts from a clean dependency installation.

> **Production Insight:** Lockfiles and deterministic dependency installation help ensure that repeated CI executions use the **same dependency versions**, reducing unexpected differences between builds.

---

```yaml
- name: Build frontend application
  run: npm run build
```

* This step executes the **`build` script** defined in the frontend's `package.json`.
* Vite compiles and bundles the React application into production-ready static assets.
* The build output is generated on the GitHub Actions runner.
* At this stage, we are only validating that the frontend can be successfully built. Docker image creation will be introduced later.

> **Production Insight:** CI should verify that an application can successfully produce its **deployable artifact** before the delivery process moves into quality validation, security scanning, image publishing, or deployment.

---

### Task 5: Review the Initial CI Workflow

At this point, the workflow has evolved from the simple checkout foundation into a basic CI workflow that validates both application tiers.

The complete workflow is now:

```yaml
name: GitHub Actions Mega Project

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

  pull_request:
    branches:
      - main
    paths:
      - 'cwvj-3tier-mega-project/frontend/**'
      - 'cwvj-3tier-mega-project/backend/**'
      - '.github/workflows/**'

  workflow_dispatch:

jobs:

  trivy-scan-job:
    name: Repository Filesystem Security Scan
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source code
        uses: actions/checkout@v7

      - name: Run Trivy repository filesystem scan
        uses: aquasecurity/trivy-action@v0.36.0
        with:
          scan-type: fs
          scan-ref: ${{ github.workspace }}
          severity: HIGH,CRITICAL
          exit-code: '1'

  backend-job:
    name: Backend Build, Test and Quality Analysis
    runs-on: ubuntu-latest
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

      - name: Verify Java version
        run: java --version

      - name: Run backend tests
        run: mvn --batch-mode test

  frontend-job:
    name: Frontend Build
    runs-on: ubuntu-latest
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
```

**Execution flow:**

```text
                         ┌→ Backend
                         │   ↓
GitHub Event → Workflow ─┤   Java 21
                         │   ↓
                         │   Maven Test
                         │
                         └→ Frontend
                             ↓
                           Node.js 22
                             ↓
                           npm ci
                             ↓
                           npm build
```

The two jobs execute independently, which means the frontend and backend can be validated separately and can run in parallel.

> **Production Insight:** Separating independent components into dedicated CI jobs provides **clear failure boundaries** and creates a foundation for parallel execution. As the project evolves, these jobs can feed into later stages such as **SonarQube analysis, Trivy scanning, Docker image creation, ECR publishing, and deployment** without turning the entire workflow into one large sequential job.

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

Let's understand some of the important configuration options:

- **`metadata`** defines the cluster name, AWS Region, Kubernetes version, and tags associated with the cluster. We are deploying the cluster in `ap-south-1` (Mumbai).
- **`availabilityZones`** specifies two Availability Zones for the cluster's networking infrastructure, helping distribute resources across separate zones.
- **`iam.withOIDC: true`** enables the cluster's OpenID Connect (OIDC) provider, which we can use later to configure IAM Roles for Service Accounts and integrate Kubernetes workloads with AWS IAM.
- **`managedNodeGroups`** defines the worker nodes that will run our application workloads. We are creating two nodes using the `c7i-flex.large` instance type, with the desired, minimum, and maximum capacity all set to two.
- **`volumeSize`, `volumeType`, and `volumeEncrypted`** configure the worker nodes' root EBS volumes, using 20 GiB `gp3` volumes with encryption enabled.
- **`privateNetworking: false`** means the worker nodes will use public subnets created by `eksctl`. This simplifies our lab setup, but production environments commonly place worker nodes in private subnets and control access through appropriate networking and security controls.
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
- **AWS infrastructure:** Open the **VPC** and **EC2** consoles to inspect the VPC, subnets, route tables, security groups, worker instances, and associated EBS volumes created during provisioning.
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

Let's understand the purpose of these subnets:

- **DevOps public subnets:** These subnets are intended for our DevOps tooling, such as SonarQube. The `public` designation depends on the associated route table having a route to an Internet Gateway. Automatically assigning a public IP does not, by itself, make a subnet public. We will configure access controls separately.
- **Database private subnets:** These subnets are intended for Amazon RDS. They do not automatically assign public IP addresses to resources, and their route tables should not provide direct Internet Gateway access. We will configure the database's security group in the next lab to restrict which resources can connect to it.
- **Two Availability Zones:** We are creating subnets in `ap-south-1a` and `ap-south-1b` to distribute resources across Availability Zones. For Amazon RDS, a DB subnet group generally needs subnets in at least two Availability Zones, even if the initial deployment uses a single-AZ DB instance.

> **Production Insight:** Keep databases in **private subnets** and expose only the endpoints that genuinely need external access. DevOps tools may also be deployed in private subnets behind a load balancer or accessed through a VPN, bastion host, or other controlled access mechanism. The correct design depends on your security requirements, availability needs, and operational model.

---

#### Why are we using the same VPC?

For this project, we will keep **EKS, SonarQube, and Amazon RDS in the same VPC**. This allows us to establish private network connectivity between these resources without introducing additional VPCs and inter-VPC connectivity mechanisms.

We have one application in this lab, so we will use **one Amazon RDS instance** to keep the setup simple and cost-effective. Within this RDS instance, we will create two databases:

- **SonarQube database:** Stores the information SonarQube needs to operate.
- **Application database:** Stores data for our application.

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
# Grant execute permission to the networking setup script.
chmod +x setup-mega-project-network.sh

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

#### Create a security group for SonarQube

Create a security group for our SonarQube instance in the **same VPC as our EKS cluster**.

Configure the following rules:

| Direction | Protocol | Port | Source/Destination | Purpose |
|---|---|---:|---|---|
| Inbound | TCP | 9000 | `0.0.0.0/0` and `::/0` | Allow access over IPv4 and IPv6 |
| Outbound | Default rules | All | Default destinations | Allow outbound connectivity |

SonarQube uses **port 9000** by default for its web interface. For this lab, we will allow inbound access from all IPv4 and IPv6 addresses.

> **Production Insight:** Allowing everyone to access port 9000 is a **lab-only simplification**. In production, restrict access to trusted networks, a VPN, or an approved load balancer or reverse proxy. Use HTTPS and appropriate authentication controls.

---

#### Allow GitHub Actions to access SonarQube

Our GitHub Actions workflow needs to communicate with SonarQube to submit code analysis results. The network configuration depends on the runner executing the workflow.

| Option | Network access | Considerations |
|---|---|---|
| **Self-hosted runner in your VPC** | Allow the runner's security group to access SonarQube on port 9000 | Supports private connectivity, but you must manage and secure the runner |
| **GitHub larger runner with static IP** | Allowlist its static IP range | Requires an eligible GitHub plan and appropriate configuration |
| **Standard GitHub-hosted runner** | Allowlist relevant GitHub Actions IP ranges | Requires ongoing maintenance and potentially many rules |

GitHub publishes its IP address ranges through its Meta API: [https://api.github.com/meta](https://api.github.com/meta).

- Look for the `actions` ranges in the response when configuring an allowlist for GitHub-hosted runners.
- These ranges can change, so allowlists require maintenance.
- **Network access and authentication are separate controls.** The security group controls connectivity, while the SonarQube token authenticates the analysis request.

> **Production Insight:** Prefer private connectivity through a self-hosted runner or a runner with static IPs where appropriate, rather than maintaining a large and changing allowlist.

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
| Description | `db-subnet-group` |
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

> **Production Insight:** Never use a weak or hardcoded password in production. Consider **AWS Secrets Manager** for managed credential storage and rotation, and restrict access to database credentials.

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

```bash
# Refresh the local package index.
sudo apt-get update

# Install the Java 21 runtime.
sudo apt-get install -y openjdk-21-jre

# Verify the installed Java version.
java -version
```

Confirm that the output shows **Java 21** before proceeding.

---

### Install the PostgreSQL client and create the SonarQube database

Our PostgreSQL database is hosted on **Amazon RDS**, so we only need the **PostgreSQL client** on the EC2 instance to connect to RDS and create the SonarQube database. We do not need to install a PostgreSQL database server locally.

> **Why are we installing the PostgreSQL client here?** We are using this EC2 instance as a **thin client** to connect to our RDS database and perform the initial database setup. We could have used **any EC2 instance** with network access to the RDS instance for this purpose. Having the PostgreSQL client on the SonarQube EC2 instance is **not a prerequisite for running SonarQube**.

```bash
# Refresh the package index before installing software.
sudo apt-get update

# Install the PostgreSQL client tools.
sudo apt-get install -y postgresql-client

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

Enter the master password configured when you created the RDS instance. Once connected, execute the following SQL statements:

```sql
-- Create a dedicated database user for SonarQube.
CREATE USER sonar WITH PASSWORD 'replace-with-a-strong-password';

-- Grant the sonar role to the postgres user so postgres can manage the SonarQube database user.
GRANT sonar TO postgres;

-- Create the SonarQube database and assign ownership to the sonar user.
CREATE DATABASE sonarqube OWNER sonar;

-- List the databases to verify that sonarqube was created.
\l

-- List the database roles to verify that sonar exists.
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

# Download the SonarQube 26.9.0 distribution archive.
curl -L -o sonarqube.zip \
  'https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.9.0.129388.zip'

# Refresh the package index before installing the archive extraction utility.
sudo apt-get update

# Install unzip so that we can extract the downloaded archive.
sudo apt-get install -y unzip

# Extract SonarQube into /opt, a standard location for manually installed
# third-party software that is not managed by the system package manager.
sudo unzip sonarqube.zip -d /opt

# Rename the version-specific directory to a stable path.
sudo mv /opt/sonarqube-26.9.0.129388 /opt/sonarqube-current
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
sudo chown -R sonar:sonar /opt/sonarqube-current

# Ensure the SonarQube startup script is executable.
sudo chmod +x /opt/sonarqube-current/bin/linux-x86-64/sonar.sh

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

**Important:** The EC2 instance's security group must be able to reach the RDS instance on TCP port `5432`. In Lab 3, we allowed this traffic from the SonarQube security group. The RDS instance must also be associated with the security group and private DB subnet group configured in Lab 4.

---

#### Create a systemd service for SonarQube

We will configure SonarQube as a **systemd service** so that we can start, stop, and monitor it using standard Linux service commands.

```bash
# Create the systemd service definition for SonarQube.
sudo vim /etc/systemd/system/sonarqube.service
```

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
# Display recent systemd logs for the SonarQube service.
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

#### Configure Frontend Coverage Reporting

The frontend test setup already generates the LCOV coverage report at:

`cwvj-3tier-mega-project/frontend/coverage/lcov.info`

We will configure the GitHub Actions workflow to pass this report to SonarQube during frontend analysis.

The report provides coverage data from the tests that were executed. It does not automatically increase coverage or create additional tests.

With the current frontend coverage below 80%, we expect the **frontend Quality Gate to fail** during the demonstration.

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
| **Variable** | `SONAR_HOST_URL` | `http://<sonarqube-ec2-public-ip>:9000` |

The GitHub Actions workflow will use these values to connect to SonarQube and submit analysis results.

---

#### Why Are We Using Overall Code Coverage?

SonarQube supports coverage conditions for both **Overall Code** and **New Code**.

- **Overall Code:** Measures test coverage across the entire codebase, including existing and newly added code. It helps us understand how much of the project is exercised by tests.
- **New Code:** Measures coverage for code introduced or changed within the configured new-code period or baseline. It helps teams improve coverage incrementally without having to fix every existing coverage gap immediately.

**Why are we using Overall Code for this project?**

- **Our demo project is being built from scratch**, so there is no significant legacy codebase to account for.
- **It makes the demonstration easier to understand**, as we can see how the coverage threshold applies to the entire project.
- **For established production projects, New Code coverage is often more practical**, as teams can enforce standards for new changes while gradually improving coverage across the existing codebase.

**Why have we chosen 80% coverage?**

- **80% is our demonstration target**, not a universal standard. The appropriate threshold depends on the application, the criticality of the code, and the team's testing standards.
- **Code coverage measures how much code is executed by tests**, but it does not guarantee that the tests are effective or that the code is free from defects.
- **Our Quality Gate requires coverage to be greater than 80%**. Therefore, exactly 80% coverage will fail the condition.

> **Production Insight:** Quality Gates can evaluate multiple conditions, including coverage, bugs, vulnerabilities, and code smells. Choose thresholds based on your application's needs and engineering standards. For established projects, consider enforcing coverage on New Code first, then gradually improving overall coverage.

---

#### How Does the Quality Gate Affect GitHub Actions?

The flow will work as follows:

1. GitHub Actions runs the application tests and generates the coverage report.
2. The SonarQube scanner submits the code analysis and coverage information to SonarQube.
3. SonarQube evaluates the analysis against the project's Quality Gate.
4. The workflow uses `-Dsonar.qualitygate.wait=true`, so the analysis step waits for the Quality Gate result.
5. **If the Quality Gate fails, the SonarQube analysis step fails**, causing the GitHub Actions workflow to fail as well.

> **Production Insight:** This is the point where code quality becomes an actual CI/CD control. The pipeline does not simply report the Quality Gate result: it can use that result to prevent the workflow from proceeding when the defined quality standards are not met.

> **Production Insight:** This lab uses HTTP and a public IP for simplicity. In production, restrict access to SonarQube and use HTTPS through an appropriately configured reverse proxy or load balancer.

---

## Stage 6: Performing Analysis of the Code

In the previous stages, we built and tested our backend and frontend applications and added a Trivy filesystem security scan. In this stage, we will integrate **SonarQube** into our GitHub Actions workflow.

SonarQube is a **code quality and code security platform** that can analyze several aspects of an application, including **code coverage, bugs, vulnerabilities, security hotspots, code smells, code duplication, and maintainability**.

For this project, we will focus specifically on **code coverage** and use a **Quality Gate** to determine whether the analyzed code meets our defined coverage requirement.

Because our backend and frontend use different technology stacks, the way we generate coverage and integrate SonarQube is slightly different:

- **Backend:** Maven is used to build and test the Java application, so we use the **SonarQube Maven plugin** for analysis.
- **Frontend:** npm and Vitest are used for the React application, so we generate an **LCOV coverage report** and use the **SonarQube Scan Action** for analysis.

#### Maven vs. Node.js

The following table summarizes how the two application stacks handle testing, coverage, and SonarQube analysis in our project:

| Concept | Java Backend | React Frontend |
|---|---|---|
| **Dependency management** | Maven | npm |
| **Dependency definition** | `pom.xml` | `package.json` |
| **Dependency lockfile** | Maven dependency resolution | `package-lock.json` |
| **Run tests** | `mvn clean verify` | `npm test` |
| **Generate coverage** | JaCoCo | Vitest with V8 coverage |
| **Coverage report** | `target/site/jacoco/jacoco.xml` | `coverage/lcov.info` |
| **SonarQube analysis** | SonarQube Maven plugin | SonarQube Scan Action |
| **Coverage integration** | SonarQube reads JaCoCo coverage | SonarQube reads the LCOV report |

The key takeaway is that **SonarQube remains the common code analysis platform, while each application uses the tooling native to its technology stack to generate the coverage data**.

---

### Task 1: Analyze Backend Code with SonarQube

Our backend application uses **Java and Maven**. Maven already handles the backend build and test lifecycle, so we can integrate SonarQube directly into the Maven workflow.

Add the following step after the backend tests:

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

#### Explanation

```yaml
env:
  SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
  SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
```

The SonarQube scanner needs to know **where SonarQube is running** and **how to authenticate with it**.

- **`SONAR_TOKEN`** retrieves the authentication token we created earlier from GitHub Actions Secrets.
- **`SONAR_HOST_URL`** retrieves the SonarQube server URL from GitHub Actions Variables.
- We use a **Secret** for the token because it is sensitive information.
- We use a **Variable** for the SonarQube URL because the URL itself is not sensitive.

This allows the workflow to authenticate with SonarQube without hardcoding credentials or configuration directly into the workflow.

---

```yaml
run: |
  mvn --batch-mode org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
    -Dsonar.projectKey=cwvj-mega-backend \
    -Dsonar.qualitygate.wait=true
```

This command invokes the **SonarQube Maven Scanner**.

- **`mvn`** invokes Maven, which is already available on the GitHub-hosted runner.
- **`--batch-mode`** runs Maven in non-interactive mode, which is appropriate for CI/CD environments.
- **`org.sonarsource.scanner.maven:sonar-maven-plugin:sonar`** invokes the SonarQube Maven plugin and performs the code analysis.
- **`-Dsonar.projectKey=cwvj-mega-backend`** tells SonarQube which project should receive the analysis results.

The project key must match the **backend project** we created earlier in SonarQube.

---


```yaml
-Dsonar.qualitygate.wait=true
```

This property is particularly important for our CI/CD pipeline.

Normally, SonarQube can receive the analysis and process the Quality Gate asynchronously. With this property set to `true`, the Maven SonarQube analysis **waits for SonarQube to complete the Quality Gate evaluation**.

The workflow therefore knows whether the analysis **passed or failed the Quality Gate**.

If the Quality Gate fails, the SonarQube analysis step fails, which causes the GitHub Actions job to fail.

> **Production Insight:** A Quality Gate becomes useful in CI/CD when its result can **influence the pipeline**. Waiting for the Quality Gate allows GitHub Actions to treat **code quality as an actual pipeline control**, rather than simply generating a report that someone must inspect manually.

At this point, our backend pipeline performs the following sequence:

```text
Checkout → Set up Java → Run Maven tests + generate coverage → Send analysis to SonarQube → Wait for Quality Gate → Pass / fail the GitHub Actions job
```

The important point is that **the coverage report is generated during the Maven build and test process**, and the SonarQube Maven plugin then uses the available project information to perform the analysis.

---

### Task 2: Analyze Frontend Code with SonarQube

The frontend uses **React, Node.js, npm, and Vitest**, so the SonarQube integration is different from the backend. We first run the frontend tests and generate the coverage report, then use the SonarQube Scan Action to analyze the code and submit the results to SonarQube.

### Explanation

First, run the frontend tests and generate the coverage report:

```yaml
- name: Run frontend tests and generate coverage
  run: npm run test:coverage
```

- `npm run test:coverage` executes the `test:coverage` script defined in the frontend `package.json`.
- The script runs Vitest with coverage enabled.
- The tests generate the LCOV coverage report at `coverage/lcov.info`.
- This report will be consumed by SonarQube in the next step.

> **Production Insight:** SonarQube does not generate the frontend test coverage for us. The application test framework generates the coverage report, and SonarQube consumes that report during code analysis.

Next, add the SonarQube analysis step:

```yaml
- name: Analyze frontend code with SonarQube
  uses: SonarSource/sonarqube-scan-action@v7
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

The first part configures the **SonarQube Scan Action** and its authentication:

```yaml
- name: Analyze frontend code with SonarQube
  uses: SonarSource/sonarqube-scan-action@v7
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ vars.SONAR_HOST_URL }}
```

- **`uses: SonarSource/sonarqube-scan-action@v7`** uses the official SonarQube Scan Action to perform the analysis.
- **`SONAR_TOKEN`** retrieves the authentication token stored in GitHub Actions Secrets.
- **`SONAR_HOST_URL`** retrieves the SonarQube server URL stored in GitHub Actions Variables.

The `with` block contains the configuration passed to the SonarQube scanner:

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

- **`projectBaseDir: cwvj-3tier-mega-project/frontend`**: Sets the frontend directory as the base directory for the SonarQube analysis.

- **`-Dsonar.projectKey=cwvj-mega-frontend`**: Specifies the SonarQube project that should receive the analysis results. This must match the project key created earlier in SonarQube.

- **`-Dsonar.sources=src`**: Specifies the location of the frontend application source code. Because the project base directory is already set to the frontend directory, `src` refers to `cwvj-3tier-mega-project/frontend/src`.

- **`-Dsonar.tests=src`**: Specifies where the frontend test files are located. Our tests are stored inside the same `src` directory as the application code.

- **`-Dsonar.test.inclusions=**/*.test.jsx`**: Tells SonarQube which files inside the test directory should be treated as test files. In our project, files following the `.test.jsx` naming convention are test files.

- **`-Dsonar.exclusions=**/*.test.jsx,src/test-setup.js`**: Excludes the test files and the Vitest setup file from the application source-code analysis. The test files are already identified separately through `sonar.test.inclusions`.

- **`-Dsonar.javascript.lcov.reportPaths=coverage/lcov.info`**: Tells SonarQube where to find the LCOV coverage report generated by Vitest. This is what allows SonarQube to include our frontend test coverage in its analysis.

- **`-Dsonar.qualitygate.wait=true`**: Makes the scanner wait for the SonarQube Quality Gate result. If the Quality Gate fails, the SonarQube analysis step fails and the GitHub Actions job fails as well.

The overall frontend flow is therefore:

```text
Run Vitest → Generate coverage/lcov.info → Run SonarQube Scanner → Analyze frontend source code → Read LCOV coverage report → Evaluate Quality Gate → Pass / fail the GitHub Actions job
```
---

### Task 3: Push the Changes

We have now added SonarQube analysis for both the backend and frontend. Before running the workflow, push these changes to the `feature/initial-ci` branch.

```bash
# Check the files that have been modified.
git status

# Stage the updated GitHub Actions workflow and frontend coverage configuration.
git add .

# Commit the SonarQube integration changes.
git commit -m "Add SonarQube code coverage analysis"

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

## Stage 7: Containerize and Scan the Application

In the previous stages, we built and tested our backend and frontend applications, added a Trivy filesystem security scan, and integrated SonarQube for code quality analysis and Quality Gates.

In this stage, we will **containerize our applications and scan the resulting container images for vulnerabilities**.

We will also introduce an important production concept, **build once, test once, and package the same validated artifact**. For the backend, we will use the JAR produced by our existing Maven build and tests to create the container image. We will not rebuild the application during the Docker image creation process.

Since our project contains both a **Java backend** and a **React frontend**, and their containerization processes are different, we will divide this stage into two broader sections:

- **Backend:** Build the tested backend JAR, transfer it between GitHub Actions jobs, build the backend container image, generate an immutable image tag, verify the image, and scan it with Trivy.
- **Frontend:** Build the React application, package it into a container image, generate an immutable image tag, verify the image, and scan it with Trivy.

We will now dive deeper into both sections and understand the tasks involved.

---

### Backend

In **Stage 6**, our `backend-job` built the Java application, ran the tests, generated the coverage report, and completed the SonarQube analysis. At the end of that process, we already have a **validated JAR file**.

Now, in Stage 7, our goal is to **containerize this application and scan the resulting container image with Trivy**. The important question is: **Do we need to build the JAR again to do that?**

No. We already have the artifact we need.

In Stage 7, we therefore have **two main changes** to make:

1. **Modify the existing `backend-job`** to expose the application version and upload the already-tested JAR as a GitHub Actions artifact.
2. **Create a separate job** that downloads this exact JAR, builds the backend container image, verifies it, and performs the Trivy container image scan.

> **Important Point:** Why are we uploading the JAR as an artifact? Because our second job will run on a **different GitHub-hosted runner**. The JAR created by `backend-job` will not automatically exist on that new runner. The GitHub Actions artifact acts as the handoff mechanism between the two jobs.

This gives us the following flow:

```text
Build + Test + Quality Analysis → Upload JAR → Build Container Image → Verify Image → Trivy Image Scan
```

> **Production Insight:** We do **not** run `mvn clean verify` again in the second job just to generate another JAR. That would rebuild the application we have already built, tested, and validated in Stage 6, increasing workflow execution time and potentially producing a different artifact. Instead, we carry the **same validated JAR** forward.

Now another question naturally comes up: **Why are we creating a separate job at all? Why not build the container image and run the Trivy scan inside the existing `backend-job`?**

Technically, we could do that. However, our existing `backend-job` and the new containerization job have **different responsibilities**:

- **`backend-job`** takes the source code and **builds and validates the application**.
- **`backend-image-build-scan-job`** takes the validated JAR and **packages and security-scans the deployment artifact**.

This gives us a clear boundary between the two responsibilities:

```text
Source Code → Build & Validate → JAR Artifact → Containerize & Scan → Container Image
```

> **Production Insight:** Separating jobs around clear responsibilities gives us better failure boundaries, cleaner artifact handoffs, easier maintenance, and the ability to apply different permissions, tooling, and controls to different parts of the workflow.

There is also a practical benefit. Each GitHub-hosted job runs on a **fresh runner**. By explicitly downloading the JAR artifact into the second job, we know exactly which application artifact is being containerized. The containerization process does not depend on anything left behind by the previous runner.

As the project grows, this separation becomes even more useful. Later, the container image can be **published to Amazon ECR and promoted toward deployment** without changing the application build and validation job.

So our backend architecture becomes:

```text
backend-job
Build + Test + Quality Analysis → Upload JAR
                                      ↓
backend-image-build-scan-job
Download JAR → Build Image → Verify Image → Trivy Scan
```

The key idea we are introducing here is:

> **Build once, validate the application, and package the same validated artifact.**

That is the natural continuation from **Stage 6**, rather than rebuilding the application simply because we have moved to the containerization part of the workflow.

---

### Task 1: Make Changes to the Existing `backend-job`

We need to make three related changes to the existing `backend-job`:

1. Expose the application version as a **job output** so that a later job can use it while generating the container image tag.
2. Read the application version from `pom.xml` and make it available as a **step output**.
3. Upload the tested JAR as a **GitHub Actions artifact** so that another job can download and use it.

Add the following changes to the existing `backend-job`. The complete workflow is available separately for reference, so here we are showing **only what needs to be added** and not repeating the existing workflow.

```yaml
# Job-level output, add this alongside runs-on, needs, defaults and steps.
outputs:
  app-version: ${{ steps.app-version.outputs.version }}

steps:

  # Read the application version from pom.xml.
  - name: Read application version
    id: app-version
    run: |
      VERSION=$(mvn --batch-mode help:evaluate \
        -Dexpression=project.version \
        -q \
        -DforceStdout)

      echo "version=$VERSION" >> "$GITHUB_OUTPUT"

  # ... existing build, test and SonarQube steps ...

  # Upload the tested JAR for the image-build job.
  - name: Upload backend JAR
    uses: actions/upload-artifact@v7
    with:
      name: backend-jar
      path: cwvj-3tier-mega-project/backend/target/user-management-api.jar
      if-no-files-found: error
```

The `outputs` block should be added at the **job level**, alongside `runs-on`, `needs`, `defaults`, and `steps`. **It is not a step and therefore cannot be placed between individual steps inside the `steps:` block.** All individual actions, including the `Read application version` and `Upload backend JAR` steps, must remain inside `steps:`.

The **Read application version** step should be added after Java has been set up and before the Maven build. The **Upload backend JAR** step should be added after the SonarQube analysis, so the artifact is uploaded only after the backend has successfully completed its existing validation.

This also makes the relationship clear: **Step Output → Job Output → later Job**.

#### Explanation

The first part reads the application version from our Maven project:

```yaml
- name: Read application version
  id: app-version
  run: |
    VERSION=$(mvn --batch-mode help:evaluate \
      -Dexpression=project.version \
      -q \
      -DforceStdout)

    echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`mvn help:evaluate`** asks Maven to evaluate a project property.
- **`-Dexpression=project.version`** tells Maven to return the version defined in `pom.xml`, which is currently `0.0.1-SNAPSHOT`.
- **`-q`** reduces unnecessary Maven output, while **`-DforceStdout`** ensures the evaluated value is written directly to standard output.
- The returned value is stored in the shell variable **`VERSION`**.

We then make this value available to GitHub Actions as a **Step Output**:

```yaml
echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`$GITHUB_OUTPUT`** is a special file provided by GitHub Actions. Writing `version=$VERSION` to this file creates an output named **`version`** for the current step.
- Because the step has `id: app-version`, the output can be referenced as **`${{ steps.app-version.outputs.version }}`**.
- The value therefore flows as **`pom.xml → Maven → VERSION → $GITHUB_OUTPUT → Step Output`**.

However, a **Step Output is available only within the current job**. Our requirement is different: the application version needs to be used by the **separate job that will build the backend container image**.

To pass this value from one job to another, we need to perform **two stages**: first create a **Step Output**, and then expose that Step Output as a **Job Output**.

We do this using:

```yaml
outputs:
  app-version: ${{ steps.app-version.outputs.version }}
```

- **`app-version`** is the name of the **Job Output**.
- **`${{ steps.app-version.outputs.version }}`** takes the `version` output produced by the `app-version` step and exposes it at the job level.
- The next job can then consume this value using **`${{ needs.backend-job.outputs.app-version }}`**.
- The complete flow is therefore **Step Output → Job Output → another Job**.

In our use case, the application version originates in `pom.xml`, becomes a **Step Output**, is then exposed as a **Job Output**, and is finally consumed by the **backend image build job** to generate the container image tag.

This is the same **Job Outputs** concept we learned earlier in the GitHub Actions course. Here, we are applying it to a real requirement in our Mega Project rather than using it as an isolated example.

> **Production Insight:** Use **Job Outputs for small pieces of metadata**, such as application versions, image tags, or deployment identifiers. Use **Artifacts for files**, such as JARs, binaries, test reports, or packaged application bundles.

---

#### Why Do We `Read application version` Here?

You must be wondering why we added the **application version** step here when the next job is responsible for building the container image. Ideally, we could have generated the version there, where everything related to the image is handled.

The reason for keeping it here is:

- **The application version comes from the application itself**, in our case from `pom.xml`. Since `backend-job` is already setting up Java and Maven to build and validate the application, we can read the version here without setting up Maven again in the image-build job just to retrieve one piece of metadata.
- We expose the version as a **Job Output**, which allows `backend-image-build-scan-job` to consume it when generating the final image tag. The image job therefore does not need to know how or where the application version is defined.
- The responsibilities remain clearly separated: `backend-job` handles **application build + application metadata + artifact creation**, while `backend-image-build-scan-job` handles **image metadata + image build + image scanning**.
- We could have used a **shell command or another lightweight approach** to extract the version directly from `pom.xml`, but that would mean manually parsing the Maven project file and duplicating logic that Maven already understands. Since Maven is already available in `backend-job`, using `mvn help:evaluate` is more reliable, easier to maintain, and avoids introducing unnecessary parsing logic just to retrieve the application version.

The overall flow is:

`backend-job: Build Application + Produce Metadata + Upload Artifact`
`backend-image-build-scan-job: Generate Image Tag + Build Image + Scan Image`

> **Important Point:** The `backend-job` owns the **application build and its metadata**, while the `backend-image-build-scan-job` owns the **container image lifecycle**. The application version is passed between the jobs as metadata, while the final `version + commit SHA` image tag is generated in the image-build job.

---

The final change uploads the JAR produced by our existing Maven build:

```yaml
- name: Upload backend JAR
  uses: actions/upload-artifact@v7
```

- **`actions/upload-artifact@v7`** stores a file produced by one job so that another job can download it later in the same workflow run.
- **`name: backend-jar`** gives the artifact a name that the next job will use when downloading it.
- **`path:`** points to the exact JAR generated by `mvn clean verify`.
- **`if-no-files-found: error`** makes the workflow fail if the expected JAR does not exist.

The artifact is uploaded **after the SonarQube analysis**, which means we only make the JAR available for containerization after the backend has successfully completed its existing build, test, and quality validation.

This gives us the key architecture for the next task:

**The application is built and validated first. The container image is created later from that exact validated artifact.**

> **Production Insight:** This approach supports **build once, test once, package the same artifact**. Rebuilding the application during a later stage could potentially produce a different artifact. Using the exact JAR that already passed testing and quality checks gives us a stronger and more predictable promotion model.

At the end of this task, the `backend-job` provides two things to the next part of the workflow:

- **Application version**, exposed as a Job Output.
- **Tested backend JAR**, stored as a GitHub Actions Artifact.

In the next task, we will create a separate job that downloads this exact JAR and uses it to **build the backend container image**.

---

### Task 2: Create a New Job to Build and Scan the Backend Container Image

In the previous task, we modified the existing `backend-job` so that it now provides everything we need for containerization:

- The **tested JAR** is stored as a GitHub Actions artifact named `backend-jar`.
- The **application version** is available as a Job Output named `app-version`.

We can now create a separate job that consumes these values and takes the next step in our workflow, **building and scanning the backend container image**. Pasted markdown

Add the following new job after the existing `backend-job`:

```yaml
backend-image-build-scan-job:
  name: Build and Scan Backend Container Image
  runs-on: ubuntu-latest
  needs: backend-job

  steps:

    # Checkout the repository so the Dockerfile is available.
    - name: Checkout source code
      uses: actions/checkout@v7

    # Download the exact JAR produced and validated by the backend job.
    - name: Download backend JAR
      uses: actions/download-artifact@v8
      with:
        name: backend-jar
        path: cwvj-3tier-mega-project/backend

    # Verify that the JAR downloaded from the previous job is available.
    - name: Verify backend JAR
      working-directory: cwvj-3tier-mega-project/backend
      run: ls -lh user-management-api.jar

    # Generate a readable image tag using the application version and short commit SHA.
    - name: Generate image tag
      id: image-tag
      env:
        APP_VERSION: ${{ needs.backend-job.outputs.app-version }}
        GITHUB_SHA: ${{ github.sha }}
      run: |
        SHORT_SHA="${GITHUB_SHA::7}"
        IMAGE_TAG="${APP_VERSION}-${SHORT_SHA}"

        echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"

    # Build the backend container image using the exact JAR validated by the backend job.
    - name: Build backend container image
      uses: docker/build-push-action@v7
      with:
        context: cwvj-3tier-mega-project/backend
        file: cwvj-3tier-mega-project/backend/Dockerfile
        tags: cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}
        load: true

    # Display the locally built container image for verification.
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

#### Explanation

The first three lines define our new job:

```yaml
backend-image-build-scan-job:
  name: Build and Scan Backend Container Image
  runs-on: ubuntu-latest
  needs: backend-job
```

- **`backend-image-build-scan-job`** is the unique job ID that we will use when referring to this job elsewhere in the workflow.
- **`name`** provides a more readable name that appears in the GitHub Actions UI.
- **`runs-on: ubuntu-latest`** gives the job a fresh GitHub-hosted runner.
- **`needs: backend-job`** creates the dependency between the two jobs. The containerization job will start only after `backend-job` completes successfully.

> **Important Point:** `needs: backend-job` is important for more than just controlling the execution order. It also allows this job to consume the **Job Output** created in the previous task using `${{ needs.backend-job.outputs.app-version }}`.

---

The first step we need after checkout is to retrieve the JAR that was produced by `backend-job`:

```yaml
- name: Download backend JAR
  uses: actions/download-artifact@v8
  with:
    name: backend-jar
    path: cwvj-3tier-mega-project/backend
```

- **`actions/download-artifact@v8`** downloads an artifact that was uploaded earlier in the same workflow run.
- **`name: backend-jar`** must match the artifact name we used in the previous task with `actions/upload-artifact`.
- **`path:`** specifies where the artifact should be downloaded. We place it directly inside the backend directory because the Dockerfile expects the JAR to be available there.

The flow is therefore:

```text
backend-job → Upload backend-jar → Download backend-jar → Container Build
```

> **Important Point:** The second job is running on a **new runner**, so the JAR from `backend-job` is not already present. The artifact is what allows us to transfer the exact JAR from one job to another.

---

Before building the image, we verify that the expected JAR is actually present:

```yaml
- name: Verify backend JAR
  working-directory: cwvj-3tier-mega-project/backend
  run: ls -lh user-management-api.jar
```

- **`working-directory`** changes into the backend directory before running the command.
- **`ls -lh`** displays the JAR along with its file size and other useful information.
- If the JAR is missing, this command fails and the job stops before we attempt to build the container image.

> **Production Insight:** A small verification step like this makes failures easier to understand. Instead of discovering later that the Docker build cannot find the JAR, we immediately know that the artifact handoff failed.

---


Next, we need a **container image tag**. The tag should tell us two important things: **which application version** we are packaging and **which source code revision** produced that image.

```yaml
- name: Generate image tag
  id: image-tag
  env:
    APP_VERSION: ${{ needs.backend-job.outputs.app-version }}
    GITHUB_SHA: ${{ github.sha }}
  run: |
    SHORT_SHA="${GITHUB_SHA::7}"
    IMAGE_TAG="${APP_VERSION}-${SHORT_SHA}"

    echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"
```

The `Generate image tag` step receives two values through environment variables:

- **`APP_VERSION`** receives the Job Output created in Task 1, `${{ needs.backend-job.outputs.app-version }}`. This gives us the application version from `pom.xml`.
- **`GITHUB_SHA`** contains the full commit SHA associated with the workflow run. We use this to identify the exact source code revision.

We then use `${GITHUB_SHA::7}` to take the first seven characters of the commit SHA and store them in `SHORT_SHA`. For example, a commit such as `a1b2c3d4e5f6...` becomes `a1b2c3d`.

The two values are then combined to create the image tag: **`${APP_VERSION}-${SHORT_SHA}`**. If the application version is `0.0.1-SNAPSHOT` and the short commit SHA is `a1b2c3d`, the resulting image tag will be `0.0.1-SNAPSHOT-a1b2c3d`.

Finally, we write `image_tag=$IMAGE_TAG` to **`$GITHUB_OUTPUT`**, making the generated tag a **Step Output**. Because the step has `id: image-tag`, the value can later be accessed using `${{ steps.image-tag.outputs.image_tag }}` when we build and scan the image.

The complete flow is:

```text
pom.xml → APP_VERSION
                    ↘
                      Image Tag → Step Output → Build Image → Trivy Scan
                    ↗
GITHUB_SHA → SHORT_SHA
```

> **Production Insight:** We deliberately avoid using a generic tag such as `latest`. A version and commit-based tag gives us a clear association between the **container image, application version, and source code revision**, which becomes important when tracing, promoting, or rolling back images.

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

Here we are using the official **Docker Build and Push Action** rather than manually running `docker build`.

- **`context`** specifies the directory that Docker can use as the build context.
- **`file`** points to the Dockerfile that defines how our backend application should be containerized.
- **`tags`** gives the image the version and commit-based tag generated in the previous step.
- **`load: true`** loads the resulting image into the local Docker image store of the GitHub-hosted runner.

The `load: true` option is particularly important here because we are **not pushing the image to a registry yet**. We need the image to exist locally so that the next steps can inspect it and scan it with Trivy.

> **Important Point:** Stage 7 is about **building and validating the container image**. We are not publishing it to Amazon ECR yet. That will come later when we introduce the container image publishing stage.

---

Before scanning the image, we verify that Docker has successfully created it:

```yaml
- name: Verify backend container image
  run: docker images cwvj-mega-backend
```

This displays the locally available images matching `cwvj-mega-backend`, allowing us to confirm that the image was created with the expected tag.

At this point our flow is:

```text
Download JAR → Verify JAR → Generate Image Tag → Build Image → Verify Image
```

Finally, we scan the container image for security vulnerabilities:

```yaml
- name: Scan backend container image with Trivy
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    image-ref: cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}
    severity: HIGH,CRITICAL
    exit-code: '1'
```

- **`image-ref`** tells Trivy exactly which local container image to scan.
- **`severity: HIGH,CRITICAL`** limits the scan to vulnerabilities with High or Critical severity.
- **`exit-code: '1'`** tells the workflow to fail if vulnerabilities matching the configured severity are found.

This means Trivy is not simply reporting vulnerabilities for us to look at later. It becomes a **quality and security gate** in our workflow.

> **Production Insight:** A container image should not automatically move toward a registry or deployment simply because it was successfully built. The image should first pass the required security checks. Here, **Build → Verify → Scan** creates that validation boundary.

We have now completed the backend containerization flow:

```text
Validated JAR → Download → Build Image → Verify Image → Trivy Scan
```

The important architectural point is that the container image is built from the **same JAR that was already tested and validated in Stage 6**, rather than rebuilding the application during containerization. This is the **build once, validate, package the same artifact** approach we established at the beginning of Stage 7. Pasted markdown

---


### Task 3: Push the Changes and Observe

We have now completed the changes required to **build and scan the backend container image**. Before we fix anything, we want to run the workflow and **observe the security gate in action**.

This is an important part of the exercise. Rather than simply configuring Trivy and assuming it works, we want to see what happens when the scanner actually finds vulnerabilities.

Before running the workflow, push these changes to the **`feature/initial-ci`** branch.

```bash
# Check the files that have been modified.
git status

# Stage the updated GitHub Actions workflow and frontend coverage configuration.
git add .

# Commit the SonarQube integration changes.
git commit -m "Add SonarQube code coverage analysis"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

Once the changes are pushed, GitHub Actions automatically triggers the workflow because our `push` configuration includes `feature/**` branches.

#### Observe the Workflow

When the workflow runs, the **backend container image Trivy scan will fail**. This is expected because we have configured Trivy to act as a security gate rather than simply reporting vulnerabilities.

- **`severity: HIGH,CRITICAL`** tells Trivy to report vulnerabilities classified as **HIGH** or **CRITICAL**.
- **`exit-code: '1'`** tells Trivy to return a failure exit code when matching vulnerabilities are found.
- GitHub Actions treats this non-zero exit code as a failed step, which causes the **container image job to fail**.

The scan reports:

```text
Total: 8 (HIGH: 5, CRITICAL: 3)
```

More importantly, Trivy tells us **where those vulnerabilities were found**:

```text
app/app.jar    jar    8
```

The other components of the image were clean in this scan:

```text
ubuntu 26.04    0
usr/bin/pebble  0
```

> **Important Point:** The failure is **expected at this stage**. We deliberately want the security gate to stop an image containing HIGH or CRITICAL vulnerabilities rather than allowing it to progress further through the workflow.

The scan has now given us a concrete problem to investigate: **8 HIGH/CRITICAL vulnerabilities exist in the Java application packaged inside our container image**.

In **Task 4**, we will investigate these vulnerabilities, identify the affected dependencies, update their versions, and run the workflow again to verify that the container image passes the Trivy security gate.

---

#### But Didn't Our Earlier Trivy Scan Pass?

At this point, you might wonder:

**"If our application has HIGH and CRITICAL vulnerabilities, why didn't the Trivy filesystem scan at the beginning of the workflow catch them?"**

The answer becomes clearer when we look at how our Java dependencies are resolved:

- Our `pom.xml` directly declares dependencies such as `spring-boot-starter-web`, but **Jackson and Tomcat are not explicitly declared**. They come into our application through the **transitive dependency tree** managed by Spring Boot.
- Trivy **can** analyze a Maven `pom.xml` and resolve its dependency tree. However, it needs to determine the versions of those dependencies and obtain the required Maven metadata to continue following the dependency chain. [Trivy](https://www.trivy.dev/docs/latest/guide/coverage/language/java/)
- In our workflow, Trivy gave us an important warning during the filesystem scan:

```text id="3v1q0f"
Dependency version cannot be determined.
Child dependencies will not be found.
```

- This means Trivy could not determine the version of one of the dependencies in the chain, so it **stopped following its child dependencies**. As a result, the vulnerable transitive dependencies further down that chain were not available for the vulnerability scan.
- That is why the filesystem scan reported `0` vulnerabilities for our `pom.xml`. **It does not mean that Trivy proved the complete dependency tree was clean.**

> **Important Point:** Always pay attention to scanner warnings, not just the final vulnerability count. A result of `0` is meaningful only when the scanner had enough information to perform the required analysis.

Later in the workflow, Maven resolves the application's dependencies and produces the JAR. That JAR is then copied into our container image:

```text id="1l3zq9"
pom.xml → Maven Dependency Resolution → JAR → Container Image
```

When we run Trivy against the container image, it can inspect the **actual packaged JAR**. Trivy has dedicated support for scanning Java JAR files for vulnerabilities. [Trivy](https://www.trivy.dev/docs/latest/guide/coverage/language/java/?utm_source=chatgpt.com)

And this is exactly what happened in our workflow:

```text id="m6p3g4"
Container Image → app/app.jar → 8 vulnerabilities
                → Ubuntu     → 0 vulnerabilities
                → pebble     → 0 vulnerabilities
```

The result was:

```text id="p8c7w2"
Total: 8
HIGH: 5
CRITICAL: 3
```

So the two scans are serving different purposes and happen at different points in the workflow:

```text id="v6n2qa"
Checkout → Trivy FS Scan → Build + Test → JAR → Containerize → Trivy Image Scan
```

- **Filesystem Scan:** Gives us an **early security checkpoint** and can analyze supported dependency definitions such as `pom.xml`. In our run, however, Trivy could not fully resolve the dependency chain, as shown by the warning.
- **Container Image Scan:** Runs against the **actual packaged application inside the container**, giving us a security check of the artifact we are preparing to run.

> **Production Insight:** These scans are **complementary, not redundant**. The earlier scan helps us identify security issues as early as possible, while the image scan validates the **actual deployment artifact**. A clean result from an early scan should not be treated as proof that the final container image is clean, particularly when the scanner reports dependency-resolution warnings.

In our case, the second scan has now identified **8 HIGH and CRITICAL vulnerabilities in `app/app.jar`**. This gives us a concrete problem to investigate before the image can move further through the workflow.

In the next task, we will investigate these vulnerabilities and update the affected backend dependency versions so that the container image can pass the Trivy security gate.

This is exactly why we added the second scan: **we are not only checking whether the repository looks safe; we are also validating the actual application artifact that we are putting into a container.**

---

### Task 4: Fix

In the previous task, Trivy identified **8 HIGH/CRITICAL vulnerabilities** in the Java application packaged inside our backend container image. We now know that these vulnerabilities are coming from the **Jackson and Tomcat dependencies** used by the application.

Open `cwvj-3tier-mega-project/backend/pom.xml`. You will find the following `properties` section:

```xml
<properties>
    <java.version>21</java.version>
</properties>
```

Add the two dependency version properties so that it looks like this:

```xml
<properties>
    <java.version>21</java.version>
    <jackson-bom.version>3.2.3</jackson-bom.version>
    <tomcat.version>11.0.25</tomcat.version>
</properties>
```

#### Explanation

We are **not adding Jackson or Tomcat as direct dependencies**. These libraries are already being brought into the application through Spring Boot's dependency management. By defining these properties, we are overriding the versions used for those dependencies.

This gives us a simple flow:

`Spring Boot Dependency Management → Jackson/Tomcat Versions → Maven Build → JAR → Container Image → Trivy Scan`

The important part is that the fix happens **before the JAR is built**. When the backend job runs again, Maven uses the updated versions while resolving dependencies, and the resulting JAR is then uploaded and passed to the container image job.

Now push the change to GitHub:

```bash
# Check the updated pom.xml.
git status

# Stage the dependency version changes.
git add .

# Commit the vulnerability fixes.
git commit -m "Fix container image vulnerabilities"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

The push will trigger the workflow again.

This time, the workflow should progress through the backend build, container image build, and Trivy scan successfully.

> **Important Point:** We are fixing the vulnerability at the **dependency level**, not by changing the Trivy configuration. We still scan for `HIGH,CRITICAL` vulnerabilities and keep `exit-code: '1'`, so the security gate remains active.

Once the workflow succeeds, we have completed an important production pattern: **build the application, validate it, package the validated artifact, scan the final container image, and only then allow the image to move forward**.

---

### Frontend

In **Stage 6**, our `frontend-job` built the frontend application, ran the tests, generated the coverage report, and completed the SonarQube analysis. At the end of that process, we already have a **validated frontend build** in the `dist` directory.

Now, in Stage 7, our goal is to **containerize this application and scan the resulting container image with Trivy**. The important question is: **Do we need to build the frontend application again to do that?**

No. We already have the build artifact we need.

In Stage 7, we therefore have **two main changes** to make:

1. **Modify the existing `frontend-job`** to expose the application version and upload the already-tested frontend build as a GitHub Actions artifact.
2. **Create a separate job** that downloads this exact frontend build, builds the frontend container image, verifies it, and performs the Trivy container image scan.

> **Important Point:** Why are we uploading the frontend build as an artifact? Because our second job will run on a **different GitHub-hosted runner**. The `dist` directory created by `frontend-job` will not automatically exist on that new runner. The GitHub Actions artifact acts as the handoff mechanism between the two jobs.

This gives us the following flow:

```text
Build + Test + Quality Analysis → Upload Frontend Build → Build Container Image → Verify Image → Trivy Image Scan
```

> **Production Insight:** We do **not** run `npm run build` again in the second job just to generate another frontend build. That would rebuild the application we have already built, tested, and validated in Stage 6, increasing workflow execution time and potentially producing a different artifact. Instead, we carry the **same validated frontend build** forward.

Now another question naturally comes up: **Why are we creating a separate job at all? Why not build the container image and run the Trivy scan inside the existing `frontend-job`?**

Technically, we could do that. However, our existing `frontend-job` and the new containerization job have **different responsibilities**:

- **`frontend-job`** takes the source code and **builds and validates the frontend application**.
- **`frontend-image-build-scan-job`** takes the validated frontend build and **packages and security-scans the deployment artifact**.

This gives us a clear boundary between the two responsibilities:

```text
Source Code → Build & Validate → Frontend Build Artifact → Containerize & Scan → Container Image
```

> **Production Insight:** Separating jobs around clear responsibilities gives us better failure boundaries, cleaner artifact handoffs, easier maintenance, and the ability to apply different permissions, tooling, and controls to different parts of the workflow.

There is also a practical benefit. Each GitHub-hosted job runs on a **fresh runner**. By explicitly downloading the frontend build artifact into the second job, we know exactly which application artifact is being containerized. The containerization process does not depend on anything left behind by the previous runner.

As the project grows, this separation becomes even more useful. Later, the container image can be **published to Amazon ECR and promoted toward deployment** without changing the application build and validation job.

So our frontend architecture becomes:

```text
frontend-job
Build + Test + Quality Analysis → Upload Frontend Build
                                         ↓
frontend-image-build-scan-job
Download Build → Build Image → Verify Image → Trivy Scan
```

The key idea we are introducing here is:

> **Build once, validate the application, and package the same validated artifact.**

That is the natural continuation from **Stage 6**, rather than rebuilding the application simply because we have moved to the containerization part of the workflow.

---

### Task 1: Make Changes to the Existing `frontend-job`

We need to make three related changes to the existing `frontend-job`:

1. Expose the application version as a **job output** so that a later job can use it while generating the container image tag.
2. Read the application version from `package.json` and make it available as a **step output**.
3. Upload the validated frontend build as a **GitHub Actions artifact** so that another job can download and use it.

Add the following changes to the existing `frontend-job`. The complete workflow is available separately for reference, so here we are showing **only what needs to be added** and not repeating the existing workflow.

```yaml
# Job-level output, add this alongside runs-on, needs, defaults and steps.
outputs:
  app-version: ${{ steps.app-version.outputs.version }}

steps:

  # ... existing checkout, Node.js setup, build, test and SonarQube steps ...

  # Read the application version from package.json.
  - name: Read application version
    id: app-version
    run: |
      VERSION=$(node -p "require('./package.json').version")

      echo "version=$VERSION" >> "$GITHUB_OUTPUT"

  # Upload the validated frontend build for the image-build job.
  - name: Upload frontend build
    uses: actions/upload-artifact@v7
    with:
      name: frontend-dist
      path: cwvj-3tier-mega-project/frontend/dist
      if-no-files-found: error
```

The `outputs` block should be added at the **job level**, alongside `runs-on`, `needs`, `defaults`, and `steps`. It is not a step and therefore cannot be placed between individual steps inside the `steps:` block.

The **Read application version** step should be added after the existing Node.js setup and build validation steps, alongside the other application metadata and artifact-handling steps. In our current workflow, it follows the SonarQube analysis. The **Upload frontend build** step should also remain after the SonarQube analysis, so the artifact is uploaded only after the frontend has successfully completed its existing validation.

This also makes the relationship clear: **Step Output → Job Output → later Job**.

#### Explanation

The first part reads the application version from our frontend project:

```yaml
- name: Read application version
  id: app-version
  run: |
    VERSION=$(node -p "require('./package.json').version")

    echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`node -p`** executes a JavaScript expression and prints its result.
- **`require('./package.json').version`** reads the `version` property from the frontend's `package.json` file. In our project, this value is currently `0.1.0`.
- **`VERSION`** is a shell variable that stores the returned application version.

Unlike the backend, which uses Maven to read the version from `pom.xml`, the frontend uses Node.js to read it from `package.json`. Node.js is already available in `frontend-job`, so we do not need to install another tool or parse the file manually.

We then make this value available to GitHub Actions as a **Step Output**:

```yaml
echo "version=$VERSION" >> "$GITHUB_OUTPUT"
```

- **`$GITHUB_OUTPUT`** is a special file provided by GitHub Actions. Writing `version=$VERSION` to this file creates an output named `version` for the current step.
- Because the step has `id: app-version`, the output can be referenced as **`${{ steps.app-version.outputs.version }}`**.
- The value therefore flows as **`package.json → Node.js → VERSION → $GITHUB_OUTPUT → Step Output`**.

However, a **Step Output is available only within the current job**. Our requirement is different: the application version needs to be used by the **separate job that will build the frontend container image**.

To pass this value from one job to another, we need to perform **two stages**: first create a **Step Output**, and then expose that Step Output as a **Job Output**.

We do this using:

```yaml
outputs:
  app-version: ${{ steps.app-version.outputs.version }}
```

- **`app-version`** is the name of the **Job Output**.
- **`${{ steps.app-version.outputs.version }}`** takes the `version` output produced by the `app-version` step and exposes it at the job level.
- The next job can then consume this value using **`${{ needs.frontend-job.outputs.app-version }}`**.
- The complete flow is therefore **Step Output → Job Output → another Job**.

In our use case, the application version originates in `package.json`, becomes a **Step Output**, is then exposed as a **Job Output**, and is finally consumed by the **frontend image build job** to generate the container image tag.

This applies the same **Job Outputs** concept we used for the backend, with the difference that the frontend obtains its version from `package.json` rather than `pom.xml`.

> **Production Insight:** Use **Job Outputs for small pieces of metadata**, such as application versions, image tags, or deployment identifiers. Use **Artifacts for files**, such as JARs, binaries, test reports, or packaged frontend builds.

---

#### Why Do We Read the Application Version Here?

You might wonder why we read the application version in `frontend-job` when the next job is responsible for building the container image. Ideally, we could generate the version there, where everything related to the image is handled.

The reason for keeping it here is:

- **The application version comes from the application itself**, in our case from `package.json`. Since `frontend-job` already sets up Node.js to build and validate the application, we can read the version here without requiring the image-build job to retrieve it separately.
- We expose the version as a **Job Output**, which allows `frontend-image-build-scan-job` to consume it when generating the final image tag. The image job therefore does not need to know how or where the application version is defined.
- The responsibilities remain clearly separated: `frontend-job` handles **application build + application metadata + artifact creation**, while `frontend-image-build-scan-job` handles **image metadata + image build + image scanning**.
- We use Node.js to read the version directly from `package.json`, avoiding unnecessary file-parsing logic or additional tools.

The overall flow is:

`frontend-job: Build Application + Produce Metadata + Upload Artifact`

`frontend-image-build-scan-job: Generate Image Tag + Build Image + Scan Image`

> **Important Point:** The `frontend-job` owns the **application build and its metadata**, while the `frontend-image-build-scan-job` owns the **container image lifecycle**. The application version is passed between the jobs as metadata, while the final `version + commit SHA` image tag is generated in the image-build job.

---

The final change uploads the frontend build produced by our existing build process:

```yaml
- name: Upload frontend build
  uses: actions/upload-artifact@v7
  with:
    name: frontend-dist
    path: cwvj-3tier-mega-project/frontend/dist
    if-no-files-found: error
```

- **`actions/upload-artifact@v7`** stores files produced by one job so that another job can download them later in the same workflow run.
- **`name: frontend-dist`** gives the artifact a name that the next job will use when downloading it.
- **`path: cwvj-3tier-mega-project/frontend/dist`** points to the frontend build output generated by `npm run build`. This directory contains the static files that will be packaged into the frontend container image.
- **`if-no-files-found: error`** makes the workflow fail if the expected build output does not exist.

The artifact is uploaded **after the SonarQube analysis**, which means we only make the frontend build available for containerization after the frontend has successfully completed its existing build, test, and quality validation.

This gives us the key architecture for the next task:

**The frontend is built and validated first. The container image is created later from that exact validated build.**

> **Production Insight:** This approach supports **build once, test once, package the same artifact**. Rebuilding the frontend during a later stage could potentially produce different output. Using the exact build that already passed the existing validation gives us a more predictable promotion model.

At the end of this task, the `frontend-job` provides two things to the next part of the workflow:

- **Application version**, exposed as a Job Output.
- **Validated frontend build**, stored as a GitHub Actions Artifact.

In the next task, we will create a separate job that downloads this exact frontend build and uses it to **build the frontend container image**.

---

### Task 2: Create a New Job to Build and Scan the Frontend Container Image

In the previous task, we modified the existing `frontend-job` so that it now provides everything we need for containerization:

- The **validated frontend build** is stored as a GitHub Actions artifact named `frontend-dist`.
- The **application version** is available as a Job Output named `app-version`.

We can now create a separate job that consumes these values and takes the next step in our workflow, **building and scanning the frontend container image**.

Add the following new job after the existing `frontend-job`:

```yaml
frontend-image-build-scan-job:
  name: Build and Scan Frontend Container Image
  runs-on: ubuntu-latest
  needs: frontend-job

  steps:

    # Checkout the repository so the Dockerfile is available.
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

    # Generate a readable image tag using the application version and short commit SHA.
    - name: Generate image tag
      id: image-tag
      env:
        APP_VERSION: ${{ needs.frontend-job.outputs.app-version }}
        GITHUB_SHA: ${{ github.sha }}
      run: |
        SHORT_SHA="${GITHUB_SHA::7}"
        IMAGE_TAG="${APP_VERSION}-${SHORT_SHA}"

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
        image-ref: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
        severity: HIGH,CRITICAL
        exit-code: '1'
```

#### Explanation

The first three lines define our new job:

```yaml
frontend-image-build-scan-job:
  name: Build and Scan Frontend Container Image
  runs-on: ubuntu-latest
  needs: frontend-job
```

- **`frontend-image-build-scan-job`** is the unique job ID that we will use when referring to this job elsewhere in the workflow.
- **`name`** provides a more readable name that appears in the GitHub Actions UI.
- **`runs-on: ubuntu-latest`** gives the job a fresh GitHub-hosted runner.
- **`needs: frontend-job`** creates the dependency between the two jobs. The containerization job will start only after `frontend-job` completes successfully.

> **Important Point:** `needs: frontend-job` is important for more than just controlling the execution order. It also allows this job to consume the **Job Output** created in the previous task using `${{ needs.frontend-job.outputs.app-version }}`.

---

The first step we need after checkout is to retrieve the frontend build produced by `frontend-job`:

```yaml
- name: Download frontend build
  uses: actions/download-artifact@v8
  with:
    name: frontend-dist
    path: cwvj-3tier-mega-project/frontend/dist
```

- **`actions/download-artifact@v8`** downloads an artifact that was uploaded earlier in the same workflow run.
- **`name: frontend-dist`** must match the artifact name we used in the previous task with `actions/upload-artifact`.
- **`path:`** specifies where the artifact should be downloaded. We place it inside the frontend directory because the Dockerfile expects the compiled frontend files to be available in the `dist` directory.

The flow is therefore:

```text
frontend-job → Upload frontend-dist → Download frontend-dist → Container Build
```

> **Important Point:** The second job is running on a **new runner**, so the frontend build from `frontend-job` is not already present. The artifact allows us to transfer the exact build from one job to another.

---

Before building the image, we verify that the expected frontend build is available:

```yaml
- name: Verify frontend build
  working-directory: cwvj-3tier-mega-project/frontend
  run: ls -lah dist
```

- **`working-directory`** changes into the frontend directory before running the command.
- **`ls -lah dist`** lists the contents of the `dist` directory, including file sizes and hidden files.
- If the `dist` directory is missing, the command fails and the job stops before we attempt to build the container image.

> **Production Insight:** A small verification step like this makes failures easier to understand. Instead of discovering later that the Docker build cannot find the frontend files, we immediately know that the artifact handoff failed.

---

Next, we need a **container image tag**. The tag should tell us two important things: **which application version** we are packaging and **which source code revision** produced that image.

```yaml
- name: Generate image tag
  id: image-tag
  env:
    APP_VERSION: ${{ needs.frontend-job.outputs.app-version }}
    GITHUB_SHA: ${{ github.sha }}
  run: |
    SHORT_SHA="${GITHUB_SHA::7}"
    IMAGE_TAG="${APP_VERSION}-${SHORT_SHA}"

    echo "image_tag=$IMAGE_TAG" >> "$GITHUB_OUTPUT"
```

The `Generate image tag` step receives two values through environment variables:

- **`APP_VERSION`** receives the Job Output created in Task 1, `${{ needs.frontend-job.outputs.app-version }}`. This gives us the application version from `package.json`.
- **`GITHUB_SHA`** contains the full commit SHA associated with the workflow run. We use this to identify the source code revision.

We then use `${GITHUB_SHA::7}` to take the first seven characters of the commit SHA and store them in `SHORT_SHA`. For example, a commit such as `a1b2c3d4e5f6...` becomes `a1b2c3d`.

The two values are then combined to create the image tag: **`${APP_VERSION}-${SHORT_SHA}`**. If the application version is `0.1.0` and the short commit SHA is `a1b2c3d`, the resulting image tag will be `0.1.0-a1b2c3d`.

Finally, we write `image_tag=$IMAGE_TAG` to **`$GITHUB_OUTPUT`**, making the generated tag a **Step Output**. Because the step has `id: image-tag`, the value can later be accessed using `${{ steps.image-tag.outputs.image_tag }}` when we build and scan the image.

The complete flow is:

```text
package.json → APP_VERSION
                    ↘
                      Image Tag → Step Output → Build Image → Trivy Scan
                    ↗
GITHUB_SHA → SHORT_SHA
```

> **Production Insight:** We deliberately avoid using a generic tag such as `latest`. A version and commit-based tag gives us a clear association between the **container image, application version, and source code revision**, which becomes important when tracing, promoting, or rolling back images.

---

We can now build the frontend container image:

```yaml
- name: Build frontend container image
  uses: docker/build-push-action@v7
  with:
    context: cwvj-3tier-mega-project/frontend
    file: cwvj-3tier-mega-project/frontend/Dockerfile
    tags: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
    load: true
```

Here we are using the official **Docker Build and Push Action** rather than manually running `docker build`.

- **`context`** specifies the directory that Docker can use as the build context. This makes the frontend files, Dockerfile-related resources, and downloaded `dist` directory available to the build.
- **`file`** points to the Dockerfile that defines how our frontend application should be containerized.
- **`tags`** gives the image the version and commit-based tag generated in the previous step.
- **`load: true`** loads the resulting image into the local Docker image store of the GitHub-hosted runner.

Our frontend Dockerfile uses Nginx to serve the compiled frontend files. The `COPY dist /usr/share/nginx/html` instruction copies the validated frontend build into the image. The image also includes the security and runtime configuration we established in the Dockerfile.

In particular, the following instruction updates the Alpine packages included in the base image:

```dockerfile
RUN apk upgrade --no-cache
```

This addresses the package vulnerabilities identified during our earlier frontend image checks. The Dockerfile also configures Nginx to run as a non-root user and prepares the required directories and PID file for that user.

> **Important Point:** The Dockerfile remediation is already part of our frontend image build. We do not need to add backend-specific vulnerability fixes to this task. Trivy will scan the resulting frontend image, and the expected result is that no HIGH or CRITICAL vulnerabilities are detected.

The `load: true` option is particularly important here because we are **not pushing the image to a registry yet**. We need the image to exist locally so that the next steps can inspect it and scan it with Trivy.

> **Important Point:** Stage 7 is about **building and validating the container image**. We are not publishing it to Amazon ECR in this task. Publishing both application images is handled separately in Stage 8.

---

Before scanning the image, we verify that Docker has successfully created it:

```yaml
- name: Verify frontend container image
  run: docker images cwvj-mega-frontend
```

This displays the locally available images matching `cwvj-mega-frontend`, allowing us to check that the image was created with the expected tag.

At this point our flow is:

```text
Download Frontend Build → Verify Build → Generate Image Tag → Build Image → Verify Image
```

Finally, we scan the container image for security vulnerabilities:

```yaml
- name: Scan frontend container image with Trivy
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    image-ref: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
    severity: HIGH,CRITICAL
    exit-code: '1'
```

- **`image-ref`** tells Trivy exactly which local container image to scan.
- **`severity: HIGH,CRITICAL`** limits the scan to vulnerabilities with High or Critical severity.
- **`exit-code: '1'`** tells the workflow to fail if vulnerabilities matching the configured severity are found.

This means Trivy is not simply reporting vulnerabilities for us to look at later. It becomes a **quality and security gate** in our workflow.

Because we have already updated the Alpine packages in the Dockerfile, we expect the frontend image to pass this scan without detecting HIGH or CRITICAL vulnerabilities. The workflow configuration remains strict, however, so if a matching vulnerability is detected in a future build, the job will fail.

> **Production Insight:** A container image should not automatically move toward a registry or deployment simply because it was successfully built. The image should first pass the required security checks. Here, **Build → Verify → Scan** creates that validation boundary.

---

We have now completed the frontend containerization flow:

```text
Validated Frontend Build → Download → Build Image → Verify Image → Trivy Scan
```

The important architectural point is that the container image is built from the **same frontend build that was already tested and validated in Stage 6**, rather than rebuilding the application during containerization. This is the **build once, validate, package the same artifact** approach we established at the beginning of Stage 7.

---

### Task 3: Push the Changes and Observe

We have now completed the changes required to **build and scan the frontend container image**. Before moving forward, we want to run the workflow and **observe the security gate in action**.

Unlike the backend, where Trivy identified HIGH and CRITICAL vulnerabilities that required dependency updates, we have already addressed the frontend image vulnerabilities in the Dockerfile. Therefore, **we expect the frontend container image scan to pass without detecting HIGH or CRITICAL vulnerabilities**.

Before running the workflow, push these changes to the **`feature/initial-ci`** branch.

```bash
# Check the files that have been modified.
git status

# Stage the updated GitHub Actions workflow and frontend Dockerfile, if modified.
git add .

# Commit the frontend containerization changes.
git commit -m "Add frontend container build and security scan"

# Push the changes to the feature/initial-ci branch.
git push origin feature/initial-ci
```

Once the changes are pushed, GitHub Actions automatically triggers the workflow because our `push` configuration includes `feature/**` branches.

> **Important Point:** Before committing, review the output of `git status` and ensure that you are staging only the intended changes. The `git add .` command stages all changes under the current directory, not just the workflow file.

#### Observe the Workflow

When the workflow runs, observe the new **`frontend-image-build-scan-job`** and verify that it completes the following steps successfully:

- **Download frontend build:** Downloads the `frontend-dist` artifact uploaded by `frontend-job`.
- **Verify frontend build:** Confirms that the expected files are available in the `dist` directory.
- **Generate image tag:** Combines the application version from `package.json` with the short commit SHA.
- **Build frontend container image:** Builds the image using the existing frontend Dockerfile.
- **Verify frontend container image:** Displays the locally available `cwvj-mega-frontend` image and its tag.
- **Scan frontend container image with Trivy:** Scans the image for HIGH and CRITICAL vulnerabilities.

Our Trivy configuration is:

```yaml
- name: Scan frontend container image with Trivy
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    image-ref: cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }}
    severity: HIGH,CRITICAL
    exit-code: '1'
```

- **`severity: HIGH,CRITICAL`** tells Trivy to report vulnerabilities classified as HIGH or CRITICAL.
- **`exit-code: '1'`** tells Trivy to return a failure exit code when matching vulnerabilities are found.
- GitHub Actions treats this non-zero exit code as a failed step, which causes the container image job to fail.

Because our frontend Dockerfile already includes the package update instruction, `RUN apk upgrade --no-cache`, we expect the image to pass this scan without detecting vulnerabilities at the configured severity levels.

> **Important Point:** The security gate remains strict even though we expect the scan to pass. We are not disabling Trivy, lowering the severity threshold, or changing the exit code to hide vulnerabilities. If a HIGH or CRITICAL vulnerability is detected, the job will fail as intended.

---

#### Why Did We Update the Frontend Dockerfile?

The frontend uses Nginx to serve the compiled application. Its container image is based on Alpine Linux, so vulnerabilities can originate from the operating system packages included in the base image.

Our Dockerfile already contains the following instruction:

```dockerfile
# Update Alpine packages to include the latest security fixes.
RUN apk upgrade --no-cache
```

- **`apk upgrade`** updates installed Alpine packages to the versions available from the configured package repositories.
- **`--no-cache`** avoids retaining the package index cache, helping keep the resulting image smaller.

This instruction was added to address the package vulnerabilities identified during our earlier frontend image checks. The Dockerfile also configures Nginx to run as a non-root user and prepares the required directories for that user.

The relevant part of our frontend containerization flow is:

```text
Frontend Build → Nginx Container Image → Update Alpine Packages → Trivy Image Scan
```

The important distinction is that we have already made the required frontend Dockerfile changes. **We do not need to repeat the backend's dependency-remediation task**, which involved updating Jackson and Tomcat versions in the Java application's `pom.xml`.

The backend and frontend have different technology stacks and therefore require different remediation approaches.

> **Production Insight:** Fix vulnerabilities at the appropriate layer. In the backend, we updated application dependencies. In the frontend, we updated Alpine packages in the container image. The security gate remains the same, but the remediation depends on where the vulnerability originates.

---

#### But Didn't We Already Run a Trivy Filesystem Scan?

Our workflow already runs a Trivy filesystem scan near the beginning:

```text
Checkout → Trivy Filesystem Scan → Build + Test → Containerize → Trivy Image Scan
```

These scans serve different purposes:

- **Filesystem scan:** Performs an early security check against the repository files and supported dependency definitions.
- **Container image scan:** Inspects the built container image, including its operating system packages and supported application components.

The frontend image scan is particularly useful because it checks the actual Nginx-based container image that we intend to publish and deploy. A successful filesystem scan alone does not establish that the final container image is free of vulnerabilities.

> **Production Insight:** Filesystem and container image scans are complementary security checks. The first helps identify issues early, while the second validates the artifact produced by the container build.

---

Once the workflow succeeds, we have completed the frontend containerization flow:

```text
Validated Frontend Build → Download Artifact → Build Image → Verify Image → Trivy Scan
```

The key outcome is that the frontend container image is built from the **same frontend build that was already tested and validated**, and the resulting image must pass the configured security gate.

Unlike the backend, which required a separate dependency-remediation task after its initial image scan, the frontend Dockerfile already contains the package update instruction intended to address the identified vulnerabilities.

**At the end of this task, both the backend and frontend have completed their Stage 7 containerization and security scanning workflows.** Stage 8 then takes the next step by publishing the exact scanned images to Amazon ECR, without rebuilding them.

---


## Stage 8: Publish and Promote Container Images

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

> **Production Insight:** Prefer immutable image tags to prevent an existing tag from being overwritten by a subsequent push. Our tags combine the application version with a short Git commit SHA, so different commits will normally produce different tags. If we rerun the workflow for the same commit, the tag remains the same, and ECR will reject an attempt to overwrite it. This protects images that have already passed security scans or been deployed. **Tag immutability prevents tag overwrites, while the image digest identifies the exact image content** that we promote across Dev and Prod.

---

#### 2. Create a GitHub OIDC identity provider

Next, we need to register GitHub as a trusted identity provider in AWS. This allows GitHub Actions to authenticate with AWS **without storing long-lived AWS access keys in GitHub**.

In the AWS Console, navigate to **IAM → Access Management → Identity providers → Add provider** and configure the following:

- **Provider type:** OpenID Connect
- **Provider URL:** `https://token.actions.githubusercontent.com`
- **Audience:** `sts.amazonaws.com`

Reference: [GitHub documentation: Configuring OIDC with AWS](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws).

Think of this as registering GitHub as a trusted identity provider. We're not granting GitHub any ECR permissions yet. We're simply telling AWS to recognize identity tokens issued by GitHub's OIDC service.

**Why do you see an EKS OIDC provider in IAM?**

You may notice another OIDC provider with a URL similar to `oidc.eks.ap-south-1.amazonaws.com/...`. This is separate from the GitHub provider. It was created earlier when we configured our EKS cluster with `withOIDC: true` in `eks-config.yaml`.

The two providers serve different purposes:

- **EKS OIDC:** Establishes trust between EKS workloads and AWS IAM, allowing Kubernetes workloads to obtain AWS permissions through mechanisms such as IAM Roles for Service Accounts (IRSA).
- **GitHub OIDC:** Establishes trust between GitHub Actions and AWS IAM, allowing workflows to assume IAM roles without storing long-lived AWS access keys.

**The common pattern:**
`EKS Pods → EKS OIDC → IAM Role → AWS Services;`
`GitHub Actions → GitHub OIDC → IAM Role → AWS Services.`

> **Important Point:** OIDC itself does not grant permissions. It establishes a trusted identity source. An identity from that source can assume an IAM role **only if the role's trust policy allows it**. Once the role is assumed, the **permissions policy attached to the role** determines which AWS resources and actions are allowed.

In our case, AWS will validate the GitHub OIDC token, check the role's trust policy, and allow the workflow to assume the role only if the conditions match. The role's permissions policy will then restrict what the workflow can do, in our case, publishing images to our ECR repositories.

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

Create the policy after reviewing it.

**Why are we using this policy?**

- `ecr:GetAuthorizationToken` allows the workflow to authenticate Docker with ECR. This action requires `"Resource": "*"`.
- The remaining actions allow the workflow to upload image layers and publish images, but only to our **backend and frontend repositories**.
- We are following the principle of **least privilege** instead of granting broad ECR access or administrator permissions.

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

**How to find the Default subject claim prefix:** Go to your GitHub repository → **Settings → Actions → OIDC**. You will find a value similar to the following:

`repo:CloudWithVarJosh@146525273/mega-project-demo@1386577280`

Use this value as the base for the `sub` condition in your IAM role's trust policy, followed by the appropriate branch reference, such as `:ref:refs/heads/feature/*`.

**Why are we restricting the trust policy this way?**

Our workflow runs on the `feature/*`, `bugfix/*` and `hotfix/*` branch patterns. We do not want an unrelated repository or an unapproved branch to be able to assume this role.

- **OIDC provider:** Specifies the trusted identity provider, GitHub.
- **`aud` condition:** Requires the token's audience to be `sts.amazonaws.com`.
- **`sub` condition:** Restricts role assumption to our specific GitHub repository and the specified branch patterns.

Notice that the subject uses the repository's **immutable owner and repository IDs**, rather than only its name. We verified this format when troubleshooting the OIDC authentication failure earlier.

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

1. **Save the container image that passed the Trivy security scan** as a Docker archive.
2. **Upload that archive as a GitHub Actions artifact** so that a later job can download and publish the same image to Amazon ECR.

Add the following steps to the existing `backend-image-build-scan-job`, **immediately after the Trivy image scan step**. We are showing only the new steps, not repeating the existing workflow.

```yaml
      # Save the exact image that passed the security scan as a Docker archive.
      - name: Save backend container image
        run: |
          docker save \
            cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }} \
            -o cwvj-mega-backend.tar

      # Upload the exact scanned image so a later job can use the same image.
      - name: Upload backend container image
        uses: actions/upload-artifact@v7
        with:
          name: backend-container-image
          path: cwvj-mega-backend.tar
          if-no-files-found: error
```

These steps must run **after the Trivy scan succeeds**. Since the job fails if the scan detects vulnerabilities at the configured severity levels, the image is saved and uploaded only after it passes the scan.

#### Explanation

The first step saves the scanned container image as a Docker archive.

```yaml
      # Save the exact image that passed the security scan as a Docker archive.
      - name: Save backend container image
        run: |
          docker save \
            cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }} \
            -o cwvj-mega-backend.tar
```

- **`name: Save backend container image`** gives the step a readable name in the GitHub Actions workflow logs.
- **`run: |`** tells GitHub Actions to execute the following lines as a shell script. The `|` allows us to write a multi-line command.
- **`docker save`** exports a local Docker image into an archive file. Unlike exporting a container filesystem, it preserves the image information needed to load the image back into Docker later, including its layers and tags.
- **`cwvj-mega-backend:${{ steps.image-tag.outputs.image_tag }}`** identifies the image to save. The repository name is `cwvj-mega-backend`, and the tag is obtained from the `image-tag` step's `image_tag` output.

  For example, if the generated tag is `0.0.1-SNAPSHOT-8048730`, the complete image reference becomes:

  `cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

  The expression `${{ steps.image-tag.outputs.image_tag }}` retrieves the tag generated earlier in the same job. We reuse this output rather than generating a new tag, ensuring that we save the image that was built and scanned.

- **`\`** at the end of each command line is a shell line-continuation character. It allows us to split the command across multiple lines for readability.
- **`-o cwvj-mega-backend.tar`** specifies the output file. Docker writes the image archive to `cwvj-mega-backend.tar` in the current working directory.

At this point, the image has been saved to a file, but it has **not yet been transferred to another job**. The archive exists only in the runner's workspace.

The next step makes it available to another job.

---

The second step uploads the Docker archive as a GitHub Actions artifact.

```yaml
      # Upload the exact scanned image so a later job can use the same image.
      - name: Upload backend container image
        uses: actions/upload-artifact@v7
        with:
          name: backend-container-image
          path: cwvj-mega-backend.tar
          if-no-files-found: error
```

- **`name: Upload backend container image`** gives the step a readable name in the workflow logs.
- **`uses: actions/upload-artifact@v7`** uses GitHub's official artifact action to upload a file produced during the workflow run. This allows another job to download the file, even though each job normally runs on a separate runner with its own workspace.
- **`with:`** contains the inputs passed to the artifact action.
- **`name: backend-container-image`** assigns a name to the GitHub Actions artifact. The next job uses this same name to identify and download the artifact.
- **`path: cwvj-mega-backend.tar`** specifies the file to upload. It must match the filename created by the preceding `docker save` command.
- **`if-no-files-found: error`** makes the step fail if the expected archive does not exist. This prevents the workflow from silently continuing without the image required by the next job.

Notice that the Docker archive filename and the artifact name are different. **`cwvj-mega-backend.tar` is the file, while `backend-container-image` is the name under which GitHub Actions stores that file as an artifact.**

The next job can download the artifact using the same name:

```yaml
      - name: Download backend container image
        uses: actions/download-artifact@v8
        with:
          name: backend-container-image
          path: .
```

Here, `name: backend-container-image` identifies the artifact uploaded by the previous job, while `path: .` tells the action to download it into the current working directory. The next job can then restore the Docker image using:

```bash
docker load -i cwvj-mega-backend.tar
```

This reconstructs the local Docker image from the archive, allowing the workflow to tag it for Amazon ECR and push it without rebuilding the image.

> **Production Insight:** GitHub Actions jobs can run on different runners, so files created in one job are not automatically available in another. Use **Job Outputs for small pieces of metadata**, such as image tags, and **Artifacts for files**, such as Docker archives and build packages.

The overall flow is:

**Build Image → Scan Image → Save Docker Archive → Upload Artifact → Download Artifact → Load Image → Push to Amazon ECR**

This gives us the foundation for the next task, where we will create a separate job to authenticate with AWS using OIDC and publish the **same container image that passed the Trivy scan** to Amazon ECR.

---

## Task 3: Create `backend-ecr-push-job`

In the previous task, we saved the backend container image that passed the Trivy security scan and uploaded it as a GitHub Actions artifact. We will now create a separate job to download that artifact, authenticate with AWS, and publish the image to Amazon ECR.

This job performs five main activities:

1. **Download and restore the scanned image** from the artifact created by `backend-image-build-scan-job`.
2. **Configure AWS credentials using GitHub OIDC**, allowing the workflow to assume the IAM role created earlier without storing long-lived AWS access keys.
3. **Authenticate Docker with Amazon ECR**, so Docker can push images to our private registry.
4. **Tag the image for the ECR repository**, preserving the application version and commit SHA generated earlier.
5. **Push the image to Amazon ECR**, making it available for subsequent deployment stages.

Add the following job to the workflow, at the same level as the existing `backend-job` and `backend-image-build-scan-job`. Do not place it inside another job's `steps:` block.

```yaml
  backend-ecr-push-job:
    name: Push Backend Image to Amazon ECR
    runs-on: ubuntu-latest
    needs: backend-image-build-scan-job

    permissions:
      id-token: write
      contents: read

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
        run: docker images cwvj-mega-backend

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

Before running this job, ensure that the repository variables used below have been configured under **GitHub repository → Settings → Secrets and variables → Actions → Variables**.

| Variable | Example value |
|---|---|
| `AWS_REGION` | `ap-south-1` |
| `AWS_ACCOUNT_ID` | `497613475050` |
| `AWS_ROLE_ARN` | `arn:aws:iam::497613475050:role/CWVJGitHubActionsECRPushRole` |

These are **repository variables**, not secrets. They contain configuration values rather than long-lived credentials. AWS authentication is handled through OIDC and the IAM role.

#### Explanation

### 1. Define the job and its dependency

```yaml
  backend-ecr-push-job:
    name: Push Backend Image to Amazon ECR
    runs-on: ubuntu-latest
    needs: backend-image-build-scan-job
```

- **`backend-ecr-push-job`** is the unique job ID. Other jobs can refer to this job using its ID in expressions such as `needs.backend-ecr-push-job`.
- **`name: Push Backend Image to Amazon ECR`** is the human-readable name displayed in the GitHub Actions workflow interface. The job ID is used in YAML expressions, while the name is used for display.
- **`runs-on: ubuntu-latest`** specifies the type of GitHub-hosted runner on which the job executes. GitHub provisions a fresh Ubuntu runner for this job, separate from the runner used by `backend-image-build-scan-job`.
- **`needs: backend-image-build-scan-job`** establishes a dependency on the previous image-build-and-scan job. This job starts only after that job succeeds.

The `needs` keyword is important because we want to publish an image only after the previous job has successfully built and scanned it. If the previous job fails, this publishing job is skipped by default.

Notice that we do not need to specify `backend-job` in `needs`. The dependency on `backend-image-build-scan-job` is sufficient because that job already depends on `backend-job`. GitHub Actions therefore respects the existing dependency chain.

The workflow relationship is:

**`backend-job` → `backend-image-build-scan-job` → `backend-ecr-push-job`**

This creates a clear separation of responsibilities: application validation, container image build and scanning, and image publishing.

---

### 2. Configure the Job Permissions

Before the job can authenticate with AWS using GitHub OIDC, we need to give it permission to request an OIDC token.

Add the following block inside `backend-ecr-push-job`, at the **job level**, alongside `runs-on`, `needs`, and `steps`.

```yaml
    permissions:
      id-token: write
      contents: read
```

#### Explanation

**`permissions:`**

- Controls the permissions available to the job. When we explicitly specify permissions, **any permission we do not list is set to `none`**. This helps us follow the principle of least privilege.

**`id-token: write`**

- Allows the job to request an **OpenID Connect (OIDC) token** from GitHub. Our `Configure AWS credentials` step uses this token to request temporary AWS credentials by assuming the IAM role `CWVJGitHubActionsECRPushRole`.

> **Important Point:** `id-token: write` only allows GitHub Actions to request an OIDC token. It does not grant permission to modify AWS resources or push images to ECR. AWS must trust the token through the IAM role's trust policy, and the role must have the required ECR permissions.

**`contents: read`**

- Allows the job to read repository contents through GitHub's `GITHUB_TOKEN`. This permission is commonly needed by `actions/checkout` to download source code.
- **Our current publishing job does not check out the repository**, so `contents: read` is not required by the steps shown. We can remove it to keep the permissions minimal, unless a later step needs repository access.

**How the OIDC Authentication Flow Works?**

**GitHub Actions → Request OIDC token from GitHub → Receive OIDC token → Present token to AWS STS → Validate token against the IAM role's trust policy → Assume the IAM role and receive temporary AWS credentials → Perform AWS operations allowed by the role's permissions policy.**

The trust policy determines **who can assume the IAM role**, while the permissions policy determines **what the assumed role can do**.

**Why Configure Permissions at the Job Level?**

GitHub supports two approaches:

- **Job-level permissions (our approach):** Apply permissions only to `backend-ecr-push-job`. This is suitable because this job needs AWS authentication, while the other jobs do not.
- **Workflow-level permissions:** Define permissions at the top level of the workflow. These permissions apply across jobs unless overridden, so they require careful consideration to avoid granting unnecessary access.

For our project, we will use **job-level permissions** to keep access limited to the job that needs it.

---

### 3. Download the backend container image artifact

```yaml
      - name: Download backend container image
        uses: actions/download-artifact@v8
        with:
          name: backend-container-image
          path: .
```

The previous job uploaded `cwvj-mega-backend.tar` as an artifact named `backend-container-image`. We now download that artifact into the new job's workspace.

- **`name: Download backend container image`** is the step's display name.
- **`uses: actions/download-artifact@v8`** invokes GitHub's official artifact download action. The version shown here is `v8`.
- **`with:`** contains the inputs passed to the action.
- **`name: backend-container-image`** identifies the artifact to download. This must match the artifact name specified in the previous job's `actions/upload-artifact` step.
- **`path: .`** tells the action to download the artifact into the current working directory of the GitHub Actions runner. For a standard GitHub-hosted runner, this is normally the job's workspace, available through the `$GITHUB_WORKSPACE` environment variable. Since this job does not change its working directory, the archive will be available as `cwvj-mega-backend.tar` in that directory.

Remember that each job normally runs on a separate runner with its own workspace. Uploading an artifact in one job does not automatically make the file available in another job. We use the artifact to transfer the file between these jobs.

The distinction is:

- **Artifact name:** `backend-container-image`
- **File inside the artifact:** `cwvj-mega-backend.tar`

The artifact name is used by the GitHub Actions download action, while the filename is used by the subsequent Docker command.

---

### 4. Load the Docker image from the archive

```yaml
      # Load the exact Docker image produced and scanned by the previous job.
      - name: Load backend container image
        run: docker load -i cwvj-mega-backend.tar
```

Downloading the archive gives us a file. Before we can tag or push the image, we need to load that file into Docker on the current runner.

- **`name: Load backend container image`** identifies the step in the workflow logs.
- **`run:`** executes a shell command on the runner.
- **`docker load`** imports the Docker image archive into the runner's local Docker image store. After this command succeeds, you can run `docker image ls` to verify that the image and its tag are available locally.
- **`-i cwvj-mega-backend.tar`** specifies the archive file from which Docker should load the image. The filename matches the archive created by the `docker save` command in the previous job.

After the command succeeds, the image is available locally under the repository name and tag stored in the archive. For example:

`cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

We can now use this image in subsequent Docker commands without rebuilding the application or container image.

The flow is:
**Scanned Image → `docker save` → GitHub Actions Artifact → `docker load` → Local Docker Image**

> **Production Insight:** The artifact allows us to transfer the already-built image between jobs without rebuilding it. This supports a **build once, scan once, promote the same artifact** approach. Later, we can promote the published image to different environments without creating a new image for each environment.

---

### 5. Verify that the image is available locally

```yaml
      # Verify that the expected image and tag are available.
      - name: Verify backend container image
        run: docker images cwvj-mega-backend
```

This step lists the locally available Docker images whose repository name matches `cwvj-mega-backend`.

- **`docker images`** displays information about images stored in the local Docker image store.
- **`cwvj-mega-backend`** filters the displayed results to the backend image repository name.

The output includes details such as the repository, tag, image ID, and image size. We can use it to check that the expected image was restored and that its tag is available before proceeding.

For example, the output might contain:

```text
REPOSITORY           TAG                         IMAGE ID
cwvj-mega-backend    0.0.1-SNAPSHOT-8048730      abc123...
```

The image ID shown here is illustrative.

This is a useful diagnostic step, but note that **`docker images` is a listing command, not a strict assertion that a particular tag exists**. If we wanted the workflow to fail explicitly when the expected image is missing, we could add a check using `docker image inspect` with the exact image reference.

For our current workflow, this step provides a convenient way to verify the loaded image in the GitHub Actions logs.

---

### 6. Configure AWS Credentials Using GitHub OIDC

```yaml
      # Authenticate to AWS using GitHub OIDC and the IAM role created earlier.
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_ROLE_ARN }}
          aws-region: ${{ vars.AWS_REGION }}
```

This step configures AWS credentials for the remaining steps in the job. We use GitHub OIDC to obtain **temporary AWS credentials** instead of storing long-lived AWS access keys in GitHub.

- **`name: Configure AWS credentials`** gives the step a readable name in the GitHub Actions logs.
- **`uses: aws-actions/configure-aws-credentials@v6`** runs the AWS credentials action, which exchanges the GitHub OIDC token for temporary AWS credentials by assuming the configured IAM role.
- **`with:`** contains the inputs passed to the action.

**`role-to-assume: ${{ vars.AWS_ROLE_ARN }}`**

- Specifies the IAM role that GitHub Actions should assume.
- `${{ vars.AWS_ROLE_ARN }}` reads the `AWS_ROLE_ARN` repository variable configured under **Settings → Secrets and variables → Actions → Variables**.
- In our setup, its value is `arn:aws:iam::497613475050:role/CWVJGitHubActionsECRPushRole`, which identifies the IAM role we created earlier.

**`aws-region: ${{ vars.AWS_REGION }}`**

- Specifies the AWS region in which the workflow will operate.
- `${{ vars.AWS_REGION }}` reads the `AWS_REGION` repository variable. In our setup, its value is `ap-south-1`, the Mumbai region.

Once this step succeeds, the AWS credentials action makes the temporary credentials available to subsequent steps in the job. The AWS CLI can then use them to interact with AWS services, subject to the IAM role's permissions.

> **Important Point:** This step does not log Docker into Amazon ECR. It configures AWS credentials. We will use these credentials in the next step to obtain an ECR authentication token and log Docker into the registry.

> **Production Insight:** OIDC avoids the need to store long-lived AWS access keys in GitHub. However, continue to restrict the IAM role's trust policy to the intended repository and branches, and grant only the AWS permissions required by the workflow.

---

### 7. Authenticate Docker with Amazon ECR

In the previous step, we configured AWS credentials using GitHub OIDC. However, **AWS authentication and Docker registry authentication are two separate steps**. The AWS CLI can now call AWS APIs, but Docker must also log in to Amazon ECR before it can push our container image.

Add the following step to the job:

```yaml id="7j8m2w"
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

#### Explanation

The command contains two parts, connected by a pipe (`|`).

**1. Retrieve an ECR authentication token**

```bash id="8b6g8v"
aws ecr get-login-password \
  --region "${{ vars.AWS_REGION }}"
```

- **`aws ecr get-login-password`** retrieves an authentication password that Docker can use to log in to Amazon ECR. The AWS CLI uses the temporary credentials configured in the previous step.
- **`--region "${{ vars.AWS_REGION }}"`** specifies the AWS region. In our setup, the `AWS_REGION` repository variable resolves to `ap-south-1`, the Mumbai region.

The returned password is used for ECR registry authentication. It is not a permanent AWS access key.

**2. Pass the password to Docker**

```bash id="v4g2px"
docker login \
  --username AWS \
  --password-stdin \
  "${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"
```

- **`docker login`** authenticates Docker with the specified container registry.
- **`--username AWS`** specifies the username required by Amazon ECR's Docker authentication mechanism.
- **`--password-stdin`** tells Docker to read the password from standard input rather than passing it directly as a command-line argument.
- **`${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com`** constructs the ECR registry endpoint using our AWS account ID and region.

In our setup, the resulting registry endpoint is:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com`

**How does the pipe (`|`) work?**

The pipe sends the output of the first command directly to the input of the second command:

**`aws ecr get-login-password` → `docker login --password-stdin`**

This allows us to pass the password directly to Docker without saving it to a separate file or writing it into the workflow configuration.

> **Important Point:** Successfully configuring AWS credentials does not automatically log Docker into ECR. The AWS credentials action establishes the workflow's AWS identity, while `docker login` authenticates Docker to the registry.

The IAM role also needs the appropriate ECR permissions. In our setup, `ecr:GetAuthorizationToken` allows the workflow to retrieve the authentication token, while separate ECR permissions allow it to upload images to the backend and frontend repositories.

---

### 8. Tag the backend image for Amazon ECR

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

Before we can push the local image to ECR, we need to tag it with the correct registry and repository name.

First, notice the `env` block:

```yaml
        env:
          IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
```

- **`env:`** defines environment variables available to the commands executed by this step.
- **`IMAGE_TAG`** is the environment variable we are defining.
- **`${{ needs.backend-image-build-scan-job.outputs.image-tag }}`** retrieves the image tag exposed as a job output by `backend-image-build-scan-job`.

Earlier, we configured that job to expose the image tag generated by its `image-tag` step. This is how the value is passed from one job to another.

The expression follows this path:

**`image-tag` step output → `backend-image-build-scan-job` job output → `backend-ecr-push-job` environment variable**

The `needs` context makes the output of the required upstream job available to the current job. The output name is `image-tag`, as defined in the upstream job's `outputs` block.

For example, if the upstream job generated:

`0.0.1-SNAPSHOT-8048730`

then `IMAGE_TAG` will contain that value.

Next, we construct the registry endpoint:

```bash
ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"
```

- **`ECR_REGISTRY`** is a shell variable used to store the ECR registry endpoint.
- **`${{ vars.AWS_ACCOUNT_ID }}`** resolves to `497613475050`.
- **`${{ vars.AWS_REGION }}`** resolves to `ap-south-1`.
- The remaining text forms the standard ECR registry hostname.

The resulting value is:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com`

We store it in a shell variable so that we can reuse it in the Docker commands without repeating the full registry hostname.

Now, let's examine the tagging command:

```bash
docker tag \
  "cwvj-mega-backend:${IMAGE_TAG}" \
  "${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}"
```

- **`docker tag`** assigns an additional name to an existing local Docker image. It does not rebuild or modify the image's filesystem.
- **`cwvj-mega-backend:${IMAGE_TAG}`** is the source image that was loaded from the archive. For example, it could be `cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`.
- **`${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}`** is the new image reference, containing the ECR registry endpoint, repository name, and the same tag.

For our example, the command creates the following ECR-qualified image reference:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com/cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

The source image and destination image reference point to the same local image content. Docker simply adds the ECR-qualified name, which tells Docker where the image should be pushed.

**Why do we reuse the existing image tag?**

The tag was generated earlier using the application version and a short Git commit SHA. For example:

`0.0.1-SNAPSHOT-8048730`

The application version helps identify the application release, while the short commit SHA helps identify the source revision used to build the image.

We reuse the tag generated by the upstream job rather than generating a new tag in this publishing job. This ensures that the image we publish has the same tag as the image that was built and scanned.

Also note that a Docker tag is a reference to an image, not a cryptographic guarantee of its contents. We will address the distinction between tags and immutable image digests when we implement the image-promotion workflow.

---

### 9. Push the backend image to Amazon ECR

```yaml
      # Push the exact image that was built and scanned earlier.
      - name: Push backend image to Amazon ECR
        env:
          IMAGE_TAG: ${{ needs.backend-image-build-scan-job.outputs.image-tag }}
        run: |
          ECR_REGISTRY="${{ vars.AWS_ACCOUNT_ID }}.dkr.ecr.${{ vars.AWS_REGION }}.amazonaws.com"

          docker push \
            "${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}"
```

This is the final step in the job. We now have the scanned image loaded locally, AWS credentials configured, Docker authenticated to ECR, and the image tagged with the correct ECR repository reference.

- **`name: Push backend image to Amazon ECR`** identifies the publishing step.
- **`env:`** makes the image tag available to the shell command. We use the same upstream job output as in the previous step.
- **`ECR_REGISTRY=...`** constructs the registry endpoint using the account ID and region stored in repository variables.
- **`docker push`** uploads the image referenced by the supplied name to the configured container registry.
- **`${ECR_REGISTRY}/cwvj-mega-backend:${IMAGE_TAG}`** identifies the exact image reference to publish.

For example, Docker pushes:

`497613475050.dkr.ecr.ap-south-1.amazonaws.com/cwvj-mega-backend:0.0.1-SNAPSHOT-8048730`

Docker uploads the image's required layers and publishes the image manifest to the specified ECR repository. Once the push succeeds, the image is available in the private `cwvj-mega-backend` repository in Amazon ECR.

For this operation to succeed, three conditions must be satisfied:

- Docker must be authenticated to the correct ECR registry.
- The IAM role must have the necessary ECR upload permissions for `cwvj-mega-backend`.
- The repository must exist in the specified AWS account and region.

We created the repository and configured the role permissions in the earlier Stage 8 setup task.

**One important consideration: our ECR repositories use immutable tags.**

We configured both ECR repositories with **Image tag mutability set to Immutable**. This prevents an existing tag from being overwritten with a different image.

Because our tag includes the application version and short commit SHA, a new source commit will normally produce a different tag. However, running the workflow again for the same commit will produce the same tag. If that tag already exists in ECR, the push will fail rather than overwrite the existing image.

This behavior is intentional. It protects existing image references from being silently replaced. If we later need to support safe workflow retries, we can explicitly handle an already-published tag and verify the existing image rather than weakening tag immutability.

> **Production Insight:** Immutable tags help prevent accidental image replacement, but **the image digest is the stronger identifier for the exact image content**. As we build out the deployment and promotion stages, we should capture the ECR image digest and use it to deploy the same image across environments.

---

### 10. Understand the complete job

Let's bring the steps together.

The job starts by downloading the Docker archive produced by `backend-image-build-scan-job`. It then restores the image with `docker load` and lists the local image to help verify that it is available.

Next, the job uses GitHub OIDC to assume `CWVJGitHubActionsECRPushRole`. The role provides temporary AWS credentials, and the workflow uses those credentials to obtain an ECR authentication token and log Docker into the registry.

Finally, the job reuses the image tag generated by the upstream job, adds the ECR registry and repository to the image reference, and pushes it to Amazon ECR.

The complete flow is:

**Download Artifact → Load Image → Verify Image → Assume IAM Role via OIDC → Authenticate Docker to ECR → Tag Image → Push Image**

This design separates image creation from image publishing. The build-and-scan job owns **image creation and validation**, while the ECR push job owns **AWS authentication and image publishing**.

At the end of Task 3, the backend image is available in Amazon ECR under the `cwvj-mega-backend` repository. We have also established the pattern that we can reuse for the frontend image, with the appropriate artifact name, repository name, and upstream job output.

The key architectural principle remains:

**Build once → Scan the image → Publish the same image → Promote that image to later environments.**

We will build on this foundation in the remaining Stage 8 tasks, including publishing the frontend image and preparing the images for deployment and promotion.

---

## Task 4: Update the Frontend Workflow to Publish Images to Amazon ECR

We have completed the backend workflow, including building the container image, scanning it for vulnerabilities, and publishing it to Amazon ECR. Now, we will make similar changes to the frontend workflow.

The overall approach remains the same. The main differences are the **job names, artifact names, image repository, and application version source**. Instead of using the backend JAR and Maven version, we will use the frontend build output (`dist`) and the application version defined in `package.json`.

We need to make two changes:

### 1. Update the Existing `frontend-image-build-scan-job`

Add the following changes to the existing `frontend-image-build-scan-job`.

**First, expose the generated image tag as a job output.** Add the `outputs` block at the job level, alongside `runs-on`, `needs`, and `steps`.

```yaml
    outputs:
      image-tag: ${{ steps.image-tag.outputs.image_tag }}
```

**Next, add the following steps immediately after the Trivy image scan step**, so the image is saved and uploaded only after the scan succeeds.

```yaml
      # Save the exact image that passed the security scan as a Docker archive.
      - name: Save frontend container image
        run: |
          docker save \
            cwvj-mega-frontend:${{ steps.image-tag.outputs.image_tag }} \
            -o cwvj-mega-frontend.tar

      # Upload the exact scanned image so a later job can use the same image.
      - name: Upload frontend container image
        uses: actions/upload-artifact@v7
        with:
          name: frontend-container-image
          path: cwvj-mega-frontend.tar
          if-no-files-found: error
```

### 2. Create `frontend-ecr-push-job`

Add the following new job at the same level as `frontend-job` and `frontend-image-build-scan-job`.

```yaml
  frontend-ecr-push-job:
    name: Push Frontend Image to Amazon ECR
    runs-on: ubuntu-latest
    needs: frontend-image-build-scan-job

    permissions:
      id-token: write
      contents: read

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

### Task 4: Push Changes to GitHub and Observe the Workflow

Now that we have updated the workflow to publish the backend container image to Amazon ECR, we need to push the changes to GitHub and verify that the complete workflow executes successfully.

---

#### 1. Push the changes to GitHub

First, ensure that you are working on the correct feature branch.

```bash
# Check the current branch.
git branch --show-current

# Check the changes made to the workflow.
git status

# Stage the workflow changes.
git add .

# Commit the changes.
git commit -m "Publish backend image to Amazon ECR"

# Push the changes to GitHub.
git push origin feature/initial-ci
```

- **Verify the branch before committing.** The current branch should be `feature/initial-ci`. If you are on another branch, switch to the correct branch before staging and committing.
- **Review `git status` before staging.** Ensure that you are committing the intended workflow and configuration changes. If unrelated files appear, avoid staging them accidentally.
- **`git add .`** stages all changes in the current directory and its subdirectories. Use specific file paths with `git add` instead if you want to stage only the workflow files.
- **`git commit`** creates a commit containing the staged changes.
- **`git push origin feature/initial-ci`** pushes the local feature branch to the remote repository.

If Git reports that there is nothing to commit, check whether the changes have already been committed before proceeding.

---

#### 2. Observe the GitHub Actions workflow

After pushing the changes, open your GitHub repository and navigate to **Actions**. Open the workflow run triggered by the push to `feature/initial-ci`.

Observe the jobs in the workflow and verify the following:

- **`backend-job`** completes successfully, including the existing build, test, and SonarQube analysis steps.
- **`backend-image-build-scan-job`** builds the backend image, completes the Trivy scan, saves the scanned image as `cwvj-mega-backend.tar`, and uploads the `backend-container-image` artifact.
- **`backend-ecr-push-job`** downloads the artifact, loads the image, configures AWS credentials using OIDC, logs in to Amazon ECR, tags the image, and pushes it successfully.

The expected dependency flow is:

`backend-job` → `backend-image-build-scan-job` → `backend-ecr-push-job`

The ECR publishing job should not run before the image-build-and-scan job succeeds.

---

#### 3. Verify the image in Amazon ECR

Once the workflow succeeds, open the AWS Console and navigate to **Amazon ECR → Private registry → Repositories**.

Open the `cwvj-mega-backend` repository and verify that the newly published image is present.

Check the following:

- **Repository:** `cwvj-mega-backend`
- **Image tag:** The version and short commit SHA generated by the workflow, for example `0.0.1-SNAPSHOT-8048730`. Your actual tag will depend on the commit being built.
- **Image digest:** Confirm that ECR displays an image digest for the published image.
- **Image details:** Verify the image's push timestamp and other available metadata to confirm that this workflow run published the expected image.

You can also verify the repository from the AWS CLI, provided your local AWS CLI is configured with suitable permissions:

```bash
aws ecr describe-images \
  --repository-name cwvj-mega-backend \
  --region ap-south-1 \
  --query 'imageDetails[*].[imageTags,imageDigest,imagePushedAt]' \
  --output table
```

This command lists the image tags, digests, and push timestamps in the backend repository.

**Important:** Our ECR repositories use immutable tags. If you rerun the workflow for the same commit after its image has already been published, the push may fail because that tag already exists. This is expected behavior and prevents an existing tag from being overwritten.

---

#### 4. Verify the workflow's security and artifact handling

In addition to checking that the workflow succeeds, review these points:

- **OIDC authentication:** Confirm that the AWS credentials step succeeds without requiring long-lived AWS access keys stored in GitHub.
- **IAM permissions:** Ensure that the role used by GitHub Actions has only the required ECR permissions and is restricted by the intended trust policy.
- **Artifact transfer:** Confirm that the image artifact is uploaded by the image-build-and-scan job and downloaded by the ECR publishing job.
- **Image identity:** Confirm that the publishing job reuses the tag generated by the upstream job instead of building a new image or generating another tag.
- **Scan result:** Verify that the Trivy scan passed before the workflow saved and uploaded the image.

These checks confirm more than a green workflow status. They help validate that the image was built, scanned, transferred, and published through the intended process.

#### 5. What should you do if the workflow fails?

If any step fails, open the failed job and inspect the logs for the specific step.

- If **AWS credential configuration fails**, review the GitHub OIDC provider, IAM role trust policy, `AWS_ROLE_ARN` variable, and the branch restrictions in the trust policy.
- If **ECR login fails**, verify `AWS_REGION`, `AWS_ACCOUNT_ID`, and the role's `ecr:GetAuthorizationToken` permission.
- If **image tagging or pushing fails**, check the image tag output, repository name, repository region, ECR upload permissions, and whether the immutable tag already exists.
- If **artifact download or image loading fails**, verify that the artifact name matches, the archive was uploaded successfully, and the filename is `cwvj-mega-backend.tar`.

Do not change the IAM policy or disable tag immutability simply to make a failed run succeed. Identify the actual cause and fix it.

**Expected outcome:** The workflow completes successfully, and the backend container image that passed the Trivy scan is available in the `cwvj-mega-backend` ECR repository with its generated version-and-commit tag.

---

## Task 5: Push Changes to GitHub and Observe the Workflow

Now that we have updated the workflow to publish both the backend and frontend container images to Amazon ECR, we need to push the changes to GitHub and verify that both images are built, scanned, and published successfully.

---

#### 1. Push the changes to GitHub

First, ensure that you are working on the correct feature branch.

```bash
# Check the current branch.
git branch --show-current

# Check the changes made to the workflow.
git status

# Stage the workflow changes.
git add .

# Commit the changes.
git commit -m "Publish backend and frontend images to Amazon ECR"

# Push the changes to GitHub.
git push origin feature/initial-ci
```

- **Verify the branch before committing.** The current branch should be `feature/initial-ci`. If you are on another branch, switch to the correct branch before staging and committing.
- **Review `git status` before staging.** Ensure that you are committing the intended workflow changes. If unrelated files appear, avoid staging them accidentally.
- **`git add .`** stages all changes in the current directory and its subdirectories. Use specific file paths if you want to stage only the workflow files.
- **`git commit`** creates a commit containing the staged changes.
- **`git push origin feature/initial-ci`** pushes the local feature branch to the remote repository.

If Git reports that there is nothing to commit, check whether the changes have already been committed before proceeding.

---

#### 2. Observe the GitHub Actions workflow

After pushing the changes, open your GitHub repository and navigate to **Actions**. Open the workflow run triggered by the push to `feature/initial-ci`.

Observe the jobs and verify the following:

- **Backend:** `backend-job` completes the build, tests, and SonarQube analysis; `backend-image-build-scan-job` builds the image, passes the Trivy scan, and uploads the `backend-container-image` artifact; `backend-ecr-push-job` downloads and restores the image, authenticates to AWS using OIDC, and pushes it to ECR.
- **Frontend:** `frontend-job` completes the build, tests, and SonarQube analysis; `frontend-image-build-scan-job` builds the image, passes the Trivy scan, and uploads the `frontend-container-image` artifact; `frontend-ecr-push-job` downloads and restores the image, authenticates to AWS using OIDC, and pushes it to ECR.

The expected job dependencies are:

**Backend:** `backend-job` → `backend-image-build-scan-job` → `backend-ecr-push-job`

**Frontend:** `frontend-job` → `frontend-image-build-scan-job` → `frontend-ecr-push-job`

Both publishing jobs should run only after their respective image-build-and-scan jobs succeed. If either Trivy scan fails, the corresponding publishing job should be skipped by default.

---

#### 3. Verify both images in Amazon ECR

Once the workflow succeeds, open the AWS Console and navigate to **Amazon ECR → Private registry → Repositories**.

Open each repository and verify that the expected image has been published.

| Verification | Backend | Frontend |
|---|---|---|
| Repository | `cwvj-mega-backend` | `cwvj-mega-frontend` |
| Image tag | Application version + short commit SHA | Application version + short commit SHA |
| Image digest | Confirm that ECR displays a digest | Confirm that ECR displays a digest |
| Push timestamp | Check the latest image's timestamp | Check the latest image's timestamp |

For example, the backend tag might be `0.0.1-SNAPSHOT-8048730`, while the frontend tag might be `0.1.0-8048730`. These are examples only. Verify the actual tags generated by your workflow run.

You can also verify both repositories using the AWS CLI, provided your local AWS CLI is configured with suitable permissions.

**Check the backend repository:**

```bash
aws ecr describe-images \
  --repository-name cwvj-mega-backend \
  --region ap-south-1 \
  --query 'imageDetails[*].[imageTags,imageDigest,imagePushedAt]' \
  --output table
```

**Check the frontend repository:**

```bash
aws ecr describe-images \
  --repository-name cwvj-mega-frontend \
  --region ap-south-1 \
  --query 'imageDetails[*].[imageTags,imageDigest,imagePushedAt]' \
  --output table
```

These commands list the available image tags, digests, and push timestamps for the respective repositories.

**Important:** Both ECR repositories use immutable tags. If you rerun the workflow for a commit whose image tag already exists, the push may fail because ECR will not allow that tag to be overwritten. This is expected behavior and protects existing image references from being replaced.

---

#### 4. Verify the workflow's security and artifact handling

In addition to checking that both images are published, review the following:

- **OIDC authentication:** Confirm that both publishing jobs successfully assume the configured IAM role without requiring long-lived AWS access keys stored in GitHub.
- **IAM permissions:** Verify that the role's trust policy restricts which repository and branches can assume it, and that its permissions policy allows the required ECR operations on both application repositories.
- **Artifact transfer:** Confirm that the backend artifact `backend-container-image` and frontend artifact `frontend-container-image` are uploaded and downloaded using matching names.
- **Image identity:** Confirm that each publishing job uses the image tag generated by its corresponding image-build-and-scan job, rather than rebuilding the image or generating a different tag.
- **Security scans:** Verify that both Trivy scans succeed before their respective images are saved, uploaded, and published.
- **ECR repositories:** Confirm that the backend and frontend images appear in their correct repositories, with the expected tags and digests.

These checks validate the complete process for both application components, from building and scanning the images to transferring and publishing them.

---

#### 5. What should you do if the workflow fails?

If any step fails, open the failed job in GitHub Actions and inspect the logs for the specific step.

- **AWS credential configuration fails:** Review the GitHub OIDC provider, IAM role trust policy, `AWS_ROLE_ARN` variable, and branch restrictions. Both publishing jobs must be allowed to assume the role.
- **ECR login fails:** Verify `AWS_REGION`, `AWS_ACCOUNT_ID`, and the role's `ecr:GetAuthorizationToken` permission.
- **Backend image push fails:** Check the `cwvj-mega-backend` repository, its upload permissions, the generated image tag, and whether that immutable tag already exists.
- **Frontend image push fails:** Check the `cwvj-mega-frontend` repository and the corresponding image tag and upload permissions.
- **Artifact download or image loading fails:** Verify that the correct artifact was uploaded, that its name matches the download step, and that the expected archive exists: `cwvj-mega-backend.tar` or `cwvj-mega-frontend.tar`.
- **Trivy scan fails:** Review the scan output to identify the reported vulnerabilities. Resolve the relevant issues before attempting to publish the image.

Do not change IAM permissions or disable tag immutability simply to make a failed run succeed. Identify the cause and apply the appropriate fix.

**Expected outcome:** Both the backend and frontend workflows complete successfully, and their scanned container images are available in the respective Amazon ECR repositories with their generated version-and-commit tags.

---





| Stage | What we'll do | Main concepts |
|---|---|---|
| **Stage 6** | **Integrate SonarQube Quality Analysis** | Backend + frontend analysis, test coverage, LCOV, Quality Gates, pipeline failure on failed gate |
| **Stage 7** | **Containerize the Application** | Dockerfiles, frontend/backend images, image tagging, Docker build in GitHub Actions |
| **Stage 8** | **Publish Images to Amazon ECR** | ECR repositories, authentication, image push, immutable image tags, artifact handling |
| **Stage 9** | **Introduce GitHub OIDC Authentication** | GitHub → AWS federation, IAM role, temporary credentials, removing long-lived AWS access keys |
| **Stage 10** | **Deploy the Application to DEV on EKS** | Kubernetes manifests, deployments, services, configuration, image deployment, GitHub Actions → EKS |
| **Stage 11** | **Artifact Promotion and PROD Deployment** | Promote the same image, DEV validation, GitHub Environments, PROD approval, environment-based deployment |
| **Stage 12** | **Introduce Argo CD and GitOps** | Git as deployment source of truth, Argo CD, synchronization, GitOps-based production deployment |
| **Stage 13** | **Build the Complete DevSecOps + GitOps Pipeline** | End-to-end flow, PR controls, security gates, quality gates, immutable artifacts, DEV → PROD → GitOps |