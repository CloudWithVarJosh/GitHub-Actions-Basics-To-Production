# GitHub Actions Concurrency Explained | Prevent Overlapping Runs & Control Workflow Execution.

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
- [Why Concurrency?](#why-concurrency)  
  - [When Can Multiple Workflow Runs Occur?](#when-can-multiple-workflow-runs-occur)  
  - [Are Concurrent Workflow Runs Always a Problem?](#are-concurrent-workflow-runs-always-a-problem)  
  - [When Concurrent Execution Is Beneficial](#when-concurrent-execution-is-beneficial)  
  - [When Concurrent Execution Can Become a Problem](#when-concurrent-execution-can-become-a-problem)  
- [What is GitHub Actions Concurrency?](#what-is-github-actions-concurrency)  
- [**Demo:** Understanding GitHub Actions Concurrency](#demo-understanding-github-actions-concurrency)  
  - [Step 1: Repository Setup and Authentication](#step-1-repository-setup-and-authentication)  
  - [Step 2: Create a Long-Running Workflow](#step-2-create-a-long-running-workflow)  
  - [Step 3: Push and Observe the Default Behavior](#step-3-push-and-observe-the-default-behavior)  
  - [Step 4: Add a Concurrency Group](#step-4-add-a-concurrency-group)  
    - [Understanding the Concurrency Block](#understanding-the-concurrency-block)  
    - [When `cancel-in-progress: true` Can Be Useful](#when-cancel-in-progresstrue-can-be-useful)  
    - [Where Can We Define Concurrency?](#where-can-we-define-concurrency)  
      - [Workflow-Level Concurrency](#1-workflow-level-concurrency)  
      - [Job-Level Concurrency](#2-job-level-concurrency)  
      - [Shared Concurrency Across Multiple Workflows](#3-shared-concurrency-across-multiple-workflows)  
    - [Understanding Dynamic Concurrency Groups](#understanding-dynamic-concurrency-groups)  
      - [Understanding the Dynamic Group](#understanding-the-dynamic-group)  
  - [Step 5: Re-trigger the Workflow After Adding the Concurrency Block](#step-5-re-trigger-the-workflow-after-adding-the-concurrency-block)  
    - [1. Push the Updated Workflow](#1-push-the-updated-workflow)  
    - [2. Trigger the Workflow Again](#2-trigger-the-workflow-again)  
    - [3. Trigger the Workflow One More Time](#3-trigger-the-workflow-one-more-time)  
  - [Demo Summary and Key Takeaways](#demo-summary-and-key-takeaways)
- [Using Dynamic Concurrency Groups](#using-dynamic-concurrency-groups)
  - [Understanding the Dynamic Group](#understanding-the-dynamic-group)
- [Conclusion](#conclusion)  
- [References](#references)  

---

### Introduction

In the previous lectures, we explored several GitHub Actions features that help us build more flexible and reusable workflows. However, there is another important aspect of workflow execution that we need to understand.

A workflow can be triggered **multiple times before an earlier execution has completed**. Depending on the workflow triggers, this can happen because of multiple pushes, Pull Requests, manual executions, scheduled executions, or other GitHub events.

In many cases, allowing these executions to run at the same time is completely fine. However, there are situations where **overlapping executions can cause duplicate work, conflicting changes, race conditions, or processing of outdated changes**.

In this lecture, we will understand how **GitHub Actions Concurrency** helps us control how related workflow runs or jobs behave when their executions overlap. We will explore **concurrency groups**, understand the behavior of `cancel-in-progress`, see the difference between **workflow-level and job-level concurrency**, and learn how multiple workflows can share the same concurrency group.

Finally, through a hands-on demo, we will observe the default behavior of overlapping workflow runs and then use concurrency to control them. We will also look at **dynamic concurrency groups**, which allow us to apply concurrency independently based on contexts such as branches, environments, or Pull Requests. 

---

### Why GitHub Actions Concurrency?

A workflow does not necessarily run only once at a time. Depending on how we configure its triggers, **a new workflow run can be triggered while an earlier run is still executing**. Multiple workflow runs are normal and, in many cases, allowing them to execute concurrently is exactly what we want.

However, the need for concurrency control is **not limited to multiple runs of the same workflow**. In some situations, executions from **different workflows may also interact with the same resource, infrastructure, or environment**, making it undesirable for them to overlap.

For example:

```text
Workflow 1 → Modify Production Infrastructure → Running
Workflow 2 → Deploy Application to Production → Running
```

Here, **Workflow 2 starts while Workflow 1 is still in progress**, meaning the two executions can overlap even though they originate from different workflows.

Depending on what these workflows are doing, allowing their executions to overlap may or may not be desirable.

More broadly, overlapping executions can lead to **unnecessary work, conflicting changes, race conditions, or the processing of outdated changes**. These are some of the situations that create the need to manage how workflow and job executions overlap.


---

### When Can Multiple Workflow Runs Occur?

Some common situations where a new run of the **same workflow** can occur before an earlier run has completed include:

**1. Multiple pushes**: If a workflow is triggered on every `push`, multiple developers can push changes within a short period. This can result in multiple runs of the same workflow executing at the same time.

```text
Developer A Push → Workflow Run A → Running
Developer B Push → Workflow Run B → Running
Developer C Push → Workflow Run C → Running
```

**2. Multiple Pull Requests**: If a workflow is triggered by Pull Request events, multiple Pull Requests can result in multiple runs of the same workflow executing at the same time.

```text
Pull Request A → Workflow Run A → Running
Pull Request B → Workflow Run B → Running
Pull Request C → Workflow Run C → Running
```

**3. Repeated workflow triggers**: A workflow can also be triggered by **scheduled executions, manual `workflow_dispatch` runs, or other GitHub events** while a previous run is still in progress.

The important point is that **a new event can result in a new workflow run even when an earlier run has not yet finished**. As a result, multiple runs of the same workflow can be **running at the same time**.


---

### Are Concurrent Workflow Runs Always a Problem?

The answer is **no**. Concurrent execution is not inherently a problem. Whether multiple executions should run concurrently depends entirely on **what they are doing** and whether they are independent or interact with the same resources.

In some situations, concurrent execution is beneficial because it allows multiple developers and independent operations to make progress simultaneously and receive faster feedback. In other situations, overlapping executions can perform unnecessary work, interfere with each other, or produce unexpected results.

Depending on the use case, concurrent execution can be broadly divided into two categories:

* **1. Concurrent Execution Is Beneficial**: Multiple executions can run at the same time without interfering with each other.

* **2. Concurrent Execution Can Become a Problem**: Multiple executions may perform unnecessary work, modify the same resources, or produce unexpected results when they overlap.

Let's discuss each of them in detail.

---

#### **Category 1: When Concurrent Execution Is Beneficial**

Concurrent execution can be beneficial when multiple runs of the **same workflow** operate independently and do not interfere with each other. In these situations, allowing each run to execute concurrently provides faster feedback and avoids unnecessary waiting.

**1. Different Branches or Pull Requests**: The same CI workflow may be triggered by pushes to different feature branches or by multiple Pull Requests. Each workflow run validates a different commit or set of changes, so builds, tests, linting, and code scanning can often execute concurrently.

```text
feature-a → CI Workflow → Build + Test + Code Scan → Running
feature-b → CI Workflow → Build + Test + Code Scan → Running
feature-c → CI Workflow → Build + Test + Code Scan → Running
```

**2. Isolated Test Environments**: The same workflow may create a separate temporary environment, container, or other isolated resource for each run. Since each workflow run operates within its own isolated environment, multiple runs can execute concurrently without affecting each other.

```text
Workflow Run A → Test Environment A → Build + Test → Running
Workflow Run B → Test Environment B → Build + Test → Running
Workflow Run C → Test Environment C → Build + Test → Running
```

**3. Independent Validation of Different Commits**: A workflow may simply validate the code associated with each trigger without modifying any shared resource. For example, **unit tests, linting, static code analysis, and code scanning** can often run concurrently for different commits.

The core principle is:

```text
Independent Executions + No Shared Resource or Dependency → Concurrent Execution Is Beneficial
```

Although the examples above focus on **multiple runs of the same workflow**, the same principle also applies to executions from **different workflows**. If those executions are independent and do not interact with the same resources or environments, there is generally no reason to prevent them from running concurrently.

> **Key Idea:** Concurrent execution is beneficial when the executions are **independent**. Whether they originate from the **same workflow or different workflows** is less important than whether they **share resources, depend on each other, or can interfere with each other's results**.


---

#### **Category 2: When Concurrent Execution Can Become a Problem**

Concurrent execution can become problematic when multiple executions are **not truly independent**. This can happen when newer executions make older ones unnecessary, multiple executions modify the same resource, or the order in which they complete affects the final result.

Although the examples below focus primarily on **multiple runs of the same workflow**, the same challenges can also occur when executions from **different workflows** interact with the same resources or environments.

**1. Duplicate or unnecessary work**: Imagine a long-running CI workflow that builds an application and performs code and image scanning. While the workflow triggered by Commit A is still running, Commit B and Commit C are pushed, triggering additional runs of the same workflow.

  ```text
  Commit A → Build + Code Scan + Image Scan → Running
  Commit B → Build + Code Scan + Image Scan → Running
  Commit C → Build + Code Scan + Image Scan → Running
  ```

  All three runs consume **runner resources and compute time**, even though the latest commit may be the only version we are ultimately interested in processing.


**2. Conflicting operations**: Multiple executions may attempt to modify the **same underlying resource or environment** at the same time.

**AWS Security Group**: One workflow run is modifying an AWS Security Group while another execution starts modifying the **same Security Group**. Both may make changes based on different assumptions about the current state, potentially creating conflicts.

**Kubernetes Resources**: One workflow run is updating a Kubernetes Deployment or ConfigMap while another execution simultaneously modifies the **same resource**. The executions can overwrite or interfere with each other's changes.

**Infrastructure Changes**: Two executions run Terraform changes against the **same infrastructure state or resources** at the same time. Both may attempt to modify the same resources, potentially resulting in state conflicts or unexpected infrastructure changes.

The common problem is:

```text
Workflow Run A → Modify Resource X → Running
Workflow Run B → Modify Resource X → Running
                         ↓
                 Conflicting Changes
```

**3. Race conditions**: Multiple executions may operate on the same target, but the order in which they complete may not match the order in which they were triggered. For example, two runs may deploy different versions of an application to the same environment.

```text
Commit A → Workflow Run A → Deploy Version 1 → Started First → Completes Second
Commit B → Workflow Run B → Deploy Version 2 → Started Later → Completes First
```

If the newer version is deployed first but the older execution finishes afterward, **Version 1 could overwrite Version 2**, leaving the environment in an unexpected state.

**4. Processing outdated changes**: A workflow run triggered by an older commit may continue executing even after a newer commit triggers another run.

```text
Commit A → Workflow Run A → Still Running
Commit B → Workflow Run B → Triggered
```

Depending on the use case, we may no longer want to continue spending resources processing **Commit A**, because **Commit B represents a newer version of the code** and may have effectively superseded the earlier run.

> **Key Idea:** The goal is **not to prevent concurrent execution**. When executions are independent, concurrent execution can provide faster feedback and improve efficiency. However, when newer executions make older ones unnecessary, multiple executions modify shared resources, or the completion order can affect the final outcome, we may need to control how those executions overlap. This can apply to **multiple runs of the same workflow or related executions from different workflows**. **GitHub Actions Concurrency** provides a mechanism to handle these situations.

---

Absolutely. Since **"Where Can We Define Concurrency?"** is already covered later, we should keep this section focused only on answering:

**What is concurrency, why is it needed, what is a concurrency group, and how does GitHub handle overlapping executions?**

Here is the revised version:

---

### What is GitHub Actions Concurrency?

**GitHub Actions Concurrency ensures that executions belonging to the same concurrency group are not allowed to run concurrently.**

By default, GitHub Actions can run **multiple workflow runs or jobs at the same time**. For example, if a workflow is triggered again while an earlier run is still executing, both workflow runs can execute concurrently.

```text
Workflow Run A → Running

Workflow Run B → Running
```

GitHub Actions Concurrency allows us to control this behavior by defining **which executions should be controlled together**.

---

#### Concurrency Groups

To do this, GitHub Actions uses a **concurrency group**.

A concurrency group defines **which executions belong together for concurrency control**. Executions that use the same concurrency group are subject to the **same concurrency rules**, while executions in different groups are controlled independently.

Conceptually:

```text
Execution A ─┐
             │
Execution B ─┼──→ Same Concurrency Group
             │
Execution C ─┘
```

For example:

```text
Execution A ─┐
Execution B ─┼──→ production-changes
Execution C ─┘
```

Since these executions use the same concurrency group, `production-changes`, GitHub Actions applies the configured concurrency behavior between them.

The concurrency configuration can then determine what happens when executions in the same group overlap.

---

#### Handling Overlapping Executions

Broadly, there are two common behaviors:

```text
Allow Current Execution to Finish → New Execution Waits

OR

Cancel Current Execution → Newer Execution Proceeds
```

This behavior is configured using the `concurrency` keyword:

```yaml
concurrency:
  group: my-workflow
  cancel-in-progress: false
```

Here:

```text
group               → Defines which executions are controlled together
cancel-in-progress  → Determines whether an in-progress execution
                      should be cancelled when a newer execution enters the group
```

With:

```yaml
cancel-in-progress: false
```

an execution that is already running is **allowed to continue**, while a newer execution in the same concurrency group does not run concurrently with it and is handled according to the group's pending-run behavior.

With:

```yaml
cancel-in-progress: true
```

a newer execution can **cancel an existing in-progress execution** in the same concurrency group.

> **Important:** A concurrency group does **not** define the sequence in which executions should run or create a dependency between them. It controls **whether executions using the same group are allowed to overlap**, not the business sequence in which they should execute.

> **Key Idea:** GitHub Actions Concurrency allows us to control **overlapping executions**. The **concurrency group defines which executions are controlled together**, while the concurrency configuration determines **how GitHub Actions handles those executions when they overlap**.


---

## Demo: Understanding GitHub Actions Concurrency

In this demo, we will progressively configure and observe **GitHub Actions Concurrency** using a single workflow. We will first observe the default behavior when multiple runs of the same workflow overlap, and then introduce a **concurrency group** to control how those executions are handled.

As we progress through the demo, we will also explore how `cancel-in-progress` changes the behavior of overlapping workflow runs.

---

### Step 1: Repository Setup and Authentication

Before starting this demo, ensure that you already:

* have a GitHub repository created
* are authenticated with GitHub
* can push code successfully using Git

These concepts were covered extensively in **Lecture 01**.

* [Lecture 01 Video](https://youtu.be/w4c_NIjO3XI?)
* [Lecture 01 GitHub Notes](https://github.com/CloudWithVarJosh/GitHub-Actions-Basics-To-Production/tree/main/01-GitHub-Actions?)

For this lecture, we will use the following repository:

* **Repository Name:** `cwvj-gha-practice`
* **Visibility:** Private

> **Operational Note:** GitHub Actions workflows execute directly inside repositories. Whenever workflow YAML files are pushed into the repository, GitHub automatically detects and evaluates them based on the configured workflow triggers.

---

### Step 2: Create a Long-Running Workflow

To demonstrate GitHub Actions Concurrency, the workflow must remain running long enough for us to trigger additional workflow runs while an earlier run is still executing.

Create the following workflow file:

**`.github/workflows/01-concurrency-demo.yaml`**

Add the following workflow:

```yaml
name: GitHub Actions Concurrency Demo

on:
  push:
    branches:
      - main

  workflow_dispatch:

jobs:
  concurrency-demo-job:
    runs-on: ubuntu-latest

    steps:
      - name: Start Workflow
        run: |
          echo "Workflow started"
          echo "Run ID: ${{ github.run_id }}"
          echo "Commit SHA: ${{ github.sha }}"

      - name: Simulate a Long-Running Task
        run: |
          echo "Long-running task started"
          sleep 120
          echo "Long-running task completed"

      - name: Complete Workflow
        run: |
          echo "Workflow completed successfully"
```

At this stage, we have **not configured concurrency**. Our goal is first to observe what happens when the same workflow is triggered multiple times while an earlier run is still executing.

---

```yaml
on:
  push:
    branches:
      - main

  workflow_dispatch:
```

* This block defines the events that can trigger our workflow.

* The `push` trigger ensures that the workflow runs whenever changes are pushed to the `main` branch.

* The `workflow_dispatch` trigger allows us to manually trigger the workflow from the GitHub Actions interface.

* For this demo, having both triggers is useful because we can create additional workflow runs either by pushing new commits or by manually triggering the workflow.

* Our objective is to trigger the **same workflow multiple times before an earlier workflow run completes** and observe how GitHub Actions handles those overlapping executions when concurrency is not configured.

---

```yaml
jobs:
  concurrency-demo-job:
    runs-on: ubuntu-latest
```

* This workflow contains a single job named `concurrency-demo-job`, which runs on a GitHub-hosted Ubuntu runner.

* At this stage, we have **not configured concurrency**. Therefore, every workflow trigger, whether triggered manually using `workflow_dispatch` or automatically through a push to the `main` branch, can create a new workflow run regardless of the status of any previous run.

For example:

```text
Run A → Running
Run B → Triggered → Running
Run C → Triggered → Running
```

* In the next steps, we will introduce concurrency and observe how this behavior changes.

---

```yaml
steps:
  - name: Start Workflow
    run: |
      echo "Workflow started"
      echo "Run ID: ${{ github.run_id }}"
      echo "Commit SHA: ${{ github.sha }}"

  - name: Simulate a Long-Running Task
    run: |
      echo "Long-running task started"
      sleep 120
      echo "Long-running task completed"

  - name: Complete Workflow
    run: |
      echo "Workflow completed successfully"
```

* The first step prints the workflow's **Run ID** and **Commit SHA**, helping us distinguish between different workflow runs during the demo.

* The `sleep 120` command keeps each workflow run active for **two minutes**, giving us enough time to trigger additional runs while a previous run is still executing.

* The final step confirms that the workflow completed successfully.

At this stage, our objective is simply to observe the default behavior when multiple runs of the same workflow overlap. We will then add the `concurrency` configuration to the same workflow and observe how GitHub Actions handles those overlapping runs differently.

---

### Step 3: Push and Observe the Default Behavior

Commit and push the workflow:

```bash
# Add all changes to the Git staging area
git add .

# Create a commit containing the GitHub Actions Concurrency demo
git commit -m "feat: add concurrency demo"

# Associate the local repository with the remote GitHub repository (one-time setup)
git remote add origin git@github.com:CloudWithVarJosh/cwvj-gha-practice.git

# Push the code to GitHub and configure the local branch to track origin/main
git push -u origin main
```

The push triggers the first workflow run:

```text
Commit A
    ↓
Workflow Run A
    ↓
Running
```

While **Run A** is still running, manually trigger the same workflow using the **Run workflow** option in the GitHub Actions UI. This creates **Run B**.

Then, trigger the workflow one more time to create **Run C**.

Now observe the GitHub Actions interface.

Since we have **not configured concurrency**, each trigger creates a new workflow run even if a previous run is still executing:

```text
Run A → Running
Run B → Running
Run C → Running
```

All three runs can execute concurrently.

This demonstrates the default behavior we discussed earlier. When a new trigger occurs before an earlier run has completed, **multiple runs of the same workflow can overlap and execute concurrently**.

> **Observation:** In our example, three executions of the same workflow are running simultaneously. Depending on the type of workflow and the operations it performs, this concurrent execution may be acceptable, beneficial, or something we may want to control.

---

### Step 4: Add a Concurrency Group

We have now observed the default behavior. Each trigger created a new workflow run, and all three runs were allowed to execute concurrently.

We will now modify the same workflow and introduce a **concurrency group**.

Update the workflow as follows:

```yaml
name: GitHub Actions Concurrency Demo

on:
  push:
    branches:
      - main

  workflow_dispatch:

concurrency:
  group: concurrency-demo
  cancel-in-progress: false

jobs:
  concurrency-demo-job:
    runs-on: ubuntu-latest

    steps:
      - name: Start Workflow
        run: |
          echo "Workflow started"
          echo "Run ID: ${{ github.run_id }}"
          echo "Commit SHA: ${{ github.sha }}"

      - name: Simulate a Long-Running Task
        run: |
          echo "Long-running task started"
          sleep 120
          echo "Long-running task completed"

      - name: Complete Workflow
        run: |
          echo "Workflow completed successfully"
```

The new configuration added to the workflow is:

---

### Understanding the Concurrency Block

```yaml
concurrency:
  group: concurrency-demo
  cancel-in-progress: false
```

* The `concurrency` block allows us to **control how overlapping executions are handled**.

* In this example, concurrency is configured at the **workflow level**, so the rule applies to the **entire workflow run**.

* The `group` property identifies which workflow runs should be **controlled together**. Since every run of this workflow uses `concurrency-demo`, all of them belong to the **same concurrency group**.

* The `cancel-in-progress` property determines whether an **already running execution should be cancelled** when a new execution enters the same group.

For our demo:

```text
concurrency
     │
     ├── group: concurrency-demo
     │
     └── cancel-in-progress: false
```

Since all runs of this workflow belong to the **same concurrency group**:

```text
Workflow Run A ─┐
                ├──→ concurrency-demo
Workflow Run B ─┘
```

With `cancel-in-progress: false`, an execution that is already running is **allowed to continue**. A new execution belonging to the same concurrency group will **not execute concurrently with it**.

Conceptually, the execution looks like this:

```text
Run A → Running → Completes → Run B Starts → Completes
```

In other words, the concurrency group allows us to **prevent overlapping execution** of related workflow runs. If **Run A is already executing**, Run B will **not run concurrently with Run A**. Instead, Run B becomes **pending** and can start after Run A completes.

> **Important:** By default, a concurrency group can have **at most one running and one pending execution**. If another run is triggered while one execution is already running and another is pending, the **newly triggered run replaces the existing pending run**.

> GitHub Actions also supports `queue: max`, which allows **multiple pending executions, up to 100**, to wait within the concurrency group. More on this later.

> **Key Idea:** By placing related workflow runs in the **same concurrency group**, we can prevent them from executing concurrently. In our example, `cancel-in-progress: false` ensures that the **currently running workflow is allowed to finish**, while a new execution waits as **pending** before it can proceed.

---

### When `cancel-in-progress: true` Can Be Useful

There are situations where an **older workflow run is no longer relevant** once a newer run has been triggered.

For example, imagine a controlled development environment where a **single developer or a small coordinated team** is frequently pushing changes to the same branch. If the workflow is triggered for every push, we may only be interested in processing the **latest version of the code**.

```text
Commit A → Workflow Run A → Running

Commit B → Workflow Run B → Triggered
```

If processing Commit A is no longer useful after Commit B has been pushed, we can configure:

```yaml
concurrency:
  group: concurrency-demo
  cancel-in-progress: true
```

With `cancel-in-progress: true`, the newer execution can cancel the **currently running execution** in the same concurrency group.

Conceptually:

```text
Run A → Running
             ↓
Run B Triggered → Cancel Run A → Run B Starts
```

This approach can be useful when **only the latest state matters**, such as a CI workflow for a frequently updated branch, where continuing to build, test, or scan an older commit provides little value after a newer commit has superseded it.

> **Key Idea:** Use `cancel-in-progress: true` when **newer executions should supersede older in-progress executions**. However, this should be used carefully for operations that modify infrastructure or shared environments, where cancelling an operation midway may leave the target in an incomplete or undesirable state.


---

### Where Can We Define Concurrency?

GitHub Actions allows us to define concurrency depending on **which executions we want to control together**.

Broadly, concurrency can be defined at two levels:

**1. Workflow-Level Concurrency:** Controls the **entire workflow run**.

* **a. Within the Same Workflow:** Controls multiple runs of the same workflow.
* **b. Across Different Workflows:** Workflow runs from different workflows in the **same repository** can be controlled together when they use the same concurrency group.

**2. Job-Level Concurrency:** Controls a **specific job**, rather than the entire workflow.

* **a. Within the Same Workflow:** Controls the same job across multiple runs of a workflow.
* **b. Across Different Workflows:** Specific jobs from different workflows in the **same repository** can be controlled together when they use the same concurrency group.

Let's discuss each of these in more detail.

---

### **1. Workflow-Level Concurrency**

Concurrency can be configured at the **workflow level** by defining the `concurrency` block at the top level of the workflow:

```yaml
concurrency:
  group: concurrency-demo
  cancel-in-progress: false

jobs:
  concurrency-demo-job:
    runs-on: ubuntu-latest
```

When configured at this level, the concurrency rule applies to the **entire workflow run**. If the workflow contains multiple jobs, the workflow execution as a whole is controlled by the configured concurrency behavior.

There are two common ways this can be used:

#### **a. Controlling Multiple Runs of the Same Workflow**

Consider a workflow with multiple jobs:

```text
Job 1 + Job 2 + Job 3
```

If the workflow is triggered multiple times and all workflow runs use the same concurrency group:

```text
Workflow Run A → Job 1 + Job 2 + Job 3 ─┐
                                         ├──→ concurrency-demo
Workflow Run B → Job 1 + Job 2 + Job 3 ─┘
```

With:

```yaml
concurrency:
  group: concurrency-demo
  cancel-in-progress: false
```

if **Workflow Run A is already running**, Workflow Run B will not execute concurrently with it. Instead, the newer workflow run becomes **pending** and can proceed after the current execution completes, subject to the concurrency group's pending-run behavior.

This is useful when we want to control whether **multiple executions of the same workflow** can overlap.

---

#### **b. Controlling Workflow Runs Across Different Workflows**

Workflow-level concurrency is not limited to multiple runs of the same workflow. Different workflows in the **same repository** can also use the same concurrency group.

For example:

```text
Infrastructure Workflow Run ─┐
                             ├──→ production-changes
Deployment Workflow Run ─────┘
```

If both workflows define:

```yaml
concurrency:
  group: production-changes
  cancel-in-progress: false
```

their workflow runs belong to the **same concurrency group**.

With `cancel-in-progress: false`, if the **Infrastructure Workflow** is already running, a new execution of the **Deployment Workflow** using the same group will not run concurrently with it.

Conceptually:

```text
Infrastructure Workflow → Running
Deployment Workflow     → Pending
```

This is useful when the **entire execution of multiple workflows** should not overlap, such as when those workflows interact with the same environment or shared infrastructure.

> **Key Idea:** At the workflow level, the concurrency group controls the **entire workflow run**. Workflow runs can belong to the **same workflow or different workflows**, as long as they use the same concurrency group.


> **Note:** A shared concurrency group applies to executions within the **same repository**. Using the same concurrency group name in a different repository does **not** cause those executions to be controlled together.


> **Important:** Sharing a concurrency group does **not** define a sequence or dependency between workflows. If multiple workflows use the same concurrency group, GitHub Actions can control **whether their executions are allowed to overlap**, but it does not create a predefined order such as `Workflow 1 → Workflow 2 → Workflow 3`.
>
> If you need to define **which execution should run first or depend on another**, use an appropriate dependency or orchestration mechanism, such as **`needs` for jobs within the same workflow**, workflow triggering mechanisms for separate workflows, or other orchestration patterns depending on the requirement. **Concurrency should not be used as a workflow sequencing mechanism, as execution ordering is not guaranteed.**



---

### **2. Job-Level Concurrency**

Concurrency can also be configured directly inside a specific job:

```yaml
jobs:
  deploy-job:
    runs-on: ubuntu-latest

    concurrency:
      group: production-changes
      cancel-in-progress: false
```

When concurrency is defined inside a job, GitHub Actions applies the concurrency rules to **that specific job**, rather than to the entire workflow.

There are two common ways this can be used:

#### **a. Controlling the Same Job Across Multiple Runs of a Workflow**

Consider a workflow with three jobs:

```text
Build Job → Test Job → Deploy Job
```

Assume that only the **Deploy Job** has a concurrency configuration.

If the workflow is triggered twice, the two workflow runs can execute their other jobs independently:

```text
Workflow Run A → Build → Test → Deploy
Workflow Run B → Build → Test → Deploy
```

Since concurrency is **not applied at the workflow level**, the workflow runs themselves are not prevented from executing concurrently.

For example:

```text
Workflow Run A → Build → Running
Workflow Run B → Build → Running

Workflow Run A → Test  → Running
Workflow Run B → Test  → Running
```

However, when both workflow runs reach the job that uses the same concurrency group:

```text
Workflow Run A → Deploy Job → Running

Workflow Run B → Deploy Job → Pending
```

With:

```yaml
concurrency:
  group: production-changes
  cancel-in-progress: false
```

the **Deploy Job from Run B does not execute concurrently** with the Deploy Job from Run A.

Once the Deploy Job from Run A completes, the pending Deploy Job can proceed, subject to the concurrency group's pending-run behavior.

This is useful when **only a specific operation should not overlap**. For example:

```text
Build  → Can Execute Concurrently
Test   → Can Execute Concurrently
Deploy → Controlled Using Concurrency
```

---

#### **b. Controlling Jobs Across Different Workflows**

Job-level concurrency can also be used when **specific jobs from different workflows** should not execute concurrently.

For example:

```text
Infrastructure Workflow → Infrastructure Job
Deployment Workflow     → Deployment Job
```

Both jobs can define the same concurrency group:

```yaml
concurrency:
  group: production-changes
  cancel-in-progress: false
```

Conceptually:

```text
Infrastructure Workflow → Infrastructure Job ─┐
                                              ├──→ production-changes
Deployment Workflow     → Deployment Job ─────┘
```

The rest of the jobs in both workflows are **not automatically restricted by this configuration**. Only the jobs that use the same concurrency group are controlled together.

For example:

```text
Infrastructure Workflow
Validate → Running
Plan     → Running
Apply    → Running

Deployment Workflow
Build    → Running
Test     → Running
Deploy   → Pending
```

Here, the Build and Test jobs can execute while the infrastructure workflow is running. However, if the **Apply Job** and **Deploy Job** share the same concurrency group, those specific operations will not execute concurrently.

This can be useful when two different workflows perform operations against the **same environment or shared infrastructure**.

For example:

```text
Infrastructure Workflow → Modify Production Infrastructure
Deployment Workflow     → Deploy Application to Production
```

If these two operations should not overlap:

```text
Infrastructure Job ─┐
                    ├──→ production-changes → Controlled Together
Deployment Job ─────┘
```

> **Key Idea:** With job-level concurrency, the **workflow itself can continue executing independently**, while only the specific jobs that use the same concurrency group are prevented from overlapping. Those jobs can belong to **different runs of the same workflow or to entirely different workflows in the same repository**.

For our current demo, we are using **workflow-level concurrency** because it makes the behavior easier to observe.

> **Note:** A shared concurrency group applies to executions within the **same repository**. Using the same concurrency group name in a different repository does **not** cause those executions to be controlled together.

---

> **Key Idea:** GitHub Actions Concurrency can control an **entire workflow run** or a **specific job**. Executions from the **same or different workflows in the same repository** can also be controlled together when they use the same concurrency group. The **concurrency group identifies which executions are controlled together**, while the concurrency configuration determines **how overlapping executions are handled**.

---

### Step 5: Re-trigger the Workflow After Adding the Concurrency Block

Now that the workflow uses the following concurrency configuration:

```yaml
concurrency:
  group: concurrency-demo
  cancel-in-progress: false
```

#### 1. Push the Updated Workflow

Save the changes and push the updated workflow to the repository:

```bash
git add .
git commit -m "feat: Add concurrency configuration"
git push
```

Since our workflow is configured to trigger on `push`, this creates the first workflow execution:

```text
Run A → Running
```

Navigate to the **Actions** tab and ensure that Run A is still running before proceeding.

---

#### 2. Trigger the Workflow Again

While **Run A is still running**, manually trigger the workflow again using `workflow_dispatch` from the GitHub Actions UI.

You should now observe:

```text
Run A → Running

Run B → Pending
```

Because:

```yaml
cancel-in-progress: false
```

GitHub Actions does **not cancel the currently running execution** when a new execution enters the same concurrency group.

Instead:

```text
Current Execution → Continues Running

New Execution     → Becomes Pending
```

In our example, the execution flow is:

```text
Run A → Running → Completes
                    ↓
              Run B → Starts
                    ↓
              Run B → Completes
```

This is the key behavior we wanted to demonstrate. By placing both workflow runs in the **same concurrency group**, GitHub Actions prevents them from executing concurrently. **Run B does not begin execution while Run A is still running.**

---

#### 3. Trigger the Workflow One More Time

Now, while **Run A is still running and Run B is pending**, manually trigger the workflow one more time from the GitHub Actions UI.

With the default concurrency queue behavior, you should observe that the newly triggered run replaces the existing pending run:

```text
Run A → Running
Run B → Cancelled
Run C → Pending
```

Once Run A completes:

```text
Run A → Completed
Run C → Starts
```

Therefore, the overall behavior is:

```text
Run A → Running → Completes
Run B → Pending → Replaced / Cancelled
Run C → Pending → Starts After Run A
```

This happens because, by default, a concurrency group allows **only one running execution and one pending execution**. When another execution enters the same group, the **new execution replaces the existing pending execution**.

> **Observation:** With `cancel-in-progress: false`, the **currently running execution is allowed to finish**. However, this does not mean that every newly triggered execution waits in an unlimited queue. By default, only **one pending execution** is retained, and a newer execution replaces the existing pending one.

> **Note:** If the requirement is to retain multiple pending executions and process them one at a time, GitHub Actions also supports `queue: max`, which allows **up to 100 executions to wait** in the concurrency group. We will focus on the default behavior in this demo.

At this point, we have demonstrated how a concurrency group can prevent **multiple executions of the same workflow from running concurrently** while still allowing the currently running execution to complete.


---

### Demo Summary and Key Takeaways

In this demo, we observed how GitHub Actions handles overlapping workflow runs **before and after configuring concurrency**.

```text
Without Concurrency

Run A → Running
Run B → Running

Both Runs Can Execute Concurrently
```

After adding a concurrency group:

```text
concurrency:
  group: concurrency-demo
  cancel-in-progress: false
```

The behavior changed:

```text
Run A → Running
Run B → Pending

Run A Completes → Run B Starts
```

We also observed the default pending behavior:

```text
Run A → Running
Run B → Pending
Run C Triggered → Run B Replaced → Run C Pending
```

The key takeaways are:

* **Without concurrency**, multiple workflow runs can execute concurrently.

* A **concurrency group** identifies which executions should be controlled together.

* With `cancel-in-progress: false`, the **currently running execution is allowed to finish**, while a newer execution becomes pending.

* By default, a concurrency group allows **one running and one pending execution**. A newly triggered execution can replace the existing pending execution.

* Concurrency can be applied to **workflow runs, specific jobs, or executions from multiple workflows that share the same concurrency group**.

> **Final Takeaway:** GitHub Actions Concurrency allows us to control **which related executions can overlap and how newer executions are handled when another execution is already in progress**.

---

### Using Dynamic Concurrency Groups

So far, we have used a static concurrency group:

```yaml
concurrency:
  group: concurrency-demo
  cancel-in-progress: false
```

With this configuration, **every workflow run using this concurrency configuration belongs to the same group**:

```text
Any Trigger → concurrency-demo → Controlled Together
```

This means that runs triggered from different branches would also affect each other because they all use the same concurrency group.

In many real-world scenarios, however, we do not want **all workflow runs** to be controlled together. Instead, we may want concurrency to apply independently to each **branch, environment, Pull Request, or another workflow context**.

For this, we can create **dynamic concurrency groups using expressions**.

In our branch-based example, we can use `${{ github.ref_name }}` to dynamically include the branch name in the concurrency group.

Update the configuration:

```yaml
concurrency:
  group: concurrency-demo-${{ github.ref_name }}
  cancel-in-progress: true
```

Now, GitHub Actions generates the concurrency group dynamically based on the branch that triggered the workflow.


---

### Understanding the Dynamic Group

The `${{ github.ref_name }}` expression represents the **short name of the branch or tag** that triggered the workflow. GitHub Actions evaluates this expression for each workflow run and dynamically generates the concurrency group name. ([GitHub Docs][1])

For example:

```text
main branch → concurrency-demo-main
```

Similarly:

```text
feature-a branch → concurrency-demo-feature-a
```

As a result, runs from the **same branch** belong to the same concurrency group:

```text
main branch runs      → concurrency-demo-main → Controlled Together
feature-a branch runs → concurrency-demo-feature-a → Controlled Together
```

However, because the generated group names are different, runs from different branches do not affect each other:

```text
main branch      → concurrency-demo-main
feature-a branch → concurrency-demo-feature-a
Different Groups → Can Execute Independently
```

This means a workflow run from `main` can execute at the same time as a workflow run from `feature-a`, while multiple runs from the **same branch** are handled according to the configured concurrency behavior.

With our current configuration:

```yaml
cancel-in-progress: true
```

a newer run from the same branch can cancel an older run that is still in progress.

Conceptually:

```text
main branch

Run A → Running
Run B → Triggered → Cancel Run A → Run B Starts
```

At the same time, a run from another branch belongs to a different concurrency group:

```text
main branch      → concurrency-demo-main
feature-a branch → concurrency-demo-feature-a
Different Groups → Can Run Independently
```

This is generally more practical than placing every workflow run into one static concurrency group.

```text
Static Group

All Branches → One Group → All Runs Affect Each Other
```

With dynamic groups:

```text
Branch / Environment / Pull Request
              ↓
     Dynamic Concurrency Group
              ↓
   Control Only Related Runs
```

> **Key Idea:** A concurrency group does not have to be a static value. By using **GitHub Actions expressions**, we can generate the group name dynamically based on the context of each workflow run. This allows us to ensure that **only related executions affect each other**, while unrelated executions can continue independently.

---

### Conclusion

In this lecture, we learned that **multiple workflow runs or jobs can overlap**, and that concurrent execution is not always a problem. Whether executions should run at the same time depends on whether they are **independent or interact with the same resources, environments, or infrastructure**.

We then explored **GitHub Actions Concurrency**, which allows us to identify related executions using a **concurrency group** and control how overlapping executions are handled.

We saw that concurrency can be defined at two levels:

* **Workflow-Level Concurrency**: Controls the execution of the **entire workflow run**.

* **Job-Level Concurrency**: Controls the execution of a **specific job**.

In both cases, executions from **different workflows in the same repository** can also be controlled together when they use the **same concurrency group**.

We also observed the difference between allowing an existing execution to continue using `cancel-in-progress: false` and allowing a newer execution to cancel an older in-progress execution using `cancel-in-progress: true`.

Finally, we explored **dynamic concurrency groups**, which allow us to create more practical concurrency boundaries based on the **branch, environment, Pull Request, or other workflow context**.

> **Key Takeaway:** *GitHub Actions Concurrency is not about forcing every workflow or job to run sequentially. It allows us to **control only the executions that are related**, while independent executions can continue running concurrently.*

---

### References

* [GitHub Actions Documentation: Control Workflow Concurrency](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/control-workflow-concurrency)
* [GitHub Actions Documentation: Contexts Reference](https://docs.github.com/en/actions/learn-github-actions/contexts)
* [GitHub Actions Documentation: Using Jobs in a Workflow](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-jobs)
* [GitHub Actions Documentation: Reusing Workflow Configurations](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)
* [GitHub Actions Documentation: Events That Trigger Workflows](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)

---
