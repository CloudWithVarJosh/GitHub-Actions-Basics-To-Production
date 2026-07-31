# GitHub JavaScript & Docker Actions Explained | Hands-on Demos

## Video reference for this lecture is the following:

[![Watch the video](https://img.youtube.com/vi/sjSmSzMJL5s/maxresdefault.jpg)](https://www.youtube.com/watch?v=sjSmSzMJL5s&ab_channel=CloudWithVarJosh)

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
- [Types of GitHub Actions](#types-of-github-actions)  
  - [1. Composite Actions](#1-composite-actions)  
  - [2. JavaScript Actions](#2-javascript-actions)  
  - [3. Docker Actions](#3-docker-actions)   
- [**Demo 1:** Creating Your First JavaScript Action](#demo-1-creating-your-first-javascript-action)  
  - [Step 1: Repository Setup and Authentication](#step-1-repository-setup-and-authentication)  
  - [Step 2: Preparing the Directory Structure for the JavaScript Action](#step-2-preparing-the-directory-structure-for-the-javascript-action)  
  - [Step 3: Understanding `package.json`](#step-3-understanding-packagejson)  
  - [Step 4: Understanding `index.js`](#step-4-understanding-indexjs)  
  - [Step 5: Creating the Calling Workflow](#step-5-creating-the-calling-workflow)  
  - [Step 6: Commit and Push the Changes](#step-6-commit-and-push-the-changes)  
  - [Step 7: Running the Workflow](#step-7-running-the-workflow)  
  - [Step 8: Observing Workflow Execution](#step-8-observing-workflow-execution)  
- [**Demo 2:** Creating a Docker Action](#demo-2-creating-a-docker-action)  
  - [Step 1: Repository Setup and Authentication](#step-1-repository-setup-and-authentication-1)  
  - [Step 2: Preparing the Docker Action](#step-2-preparing-the-docker-action)  
  - [Step 3: Creating the Dockerfile](#step-3-creating-the-dockerfile)  
  - [Step 4: Creating the Entrypoint Script](#step-4-creating-the-entrypoint-script)  
  - [Step 5: Creating the Action Metadata](#step-5-creating-the-action-metadata)  
  - [Step 6: Creating the Calling Workflow](#step-6-creating-the-calling-workflow)  
  - [Step 7: Commit and Push the Changes](#step-7-commit-and-push-the-changes-1)  
  - [Step 8: Running the Workflow](#step-8-running-the-workflow-1)  
  - [Step 9: Observing Workflow Execution](#step-9-observing-workflow-execution)  
- [Which **Custom Action** Should You Use?](#which-custom-action-should-you-use) 
- [Conclusion](#conclusion)  
- [References](#references)  

---

## Introduction

In **Lecture 11**, we explored **Composite Actions**, learning how to build reusable GitHub Actions by orchestrating existing GitHub Actions, shell commands, and scripts. We also covered **Action metadata (`action.yml`)**, **Action Inputs and Outputs**, **Local Actions**, and the best practices for designing reusable Composite Actions. 

In this lecture, we will complete our study of **GitHub Custom Actions** by exploring the remaining two Action types:

* **JavaScript Actions**, which allow us to implement **custom automation logic** using the **Node.js runtime**.
* **Docker Actions**, which package both the **automation logic** and the **entire execution environment** inside a **Docker container**.  

Through two hands-on demonstrations, you will learn **when to use each Action type**, **how they are structured**, **how they execute**, and **how they differ from Composite Actions**. By the end of this lecture, you will understand all **three GitHub Custom Action types** and know how to choose the most appropriate one for your automation requirements. 

---

## Types of GitHub Actions

GitHub supports **three types of Custom Actions**, each designed for different use cases:

1. **Composite Actions**, which allow you to build reusable Actions by orchestrating existing GitHub Actions and shell commands.

2. **JavaScript Actions**, which execute custom automation logic using the Node.js runtime and are commonly used for GitHub API interactions, dynamic data processing, and other advanced automation scenarios.

3. **Docker Actions**, which package automation inside a Docker container, making them suitable for custom runtime environments and complex dependencies.

> **Lecture Roadmap:** In the previous lecture (**Lecture 11**), we explored **Composite Actions** in detail. In this lecture, we will focus on **JavaScript Actions** and **Docker Actions**, understand when to use each, and build hands-on examples.

---

#### 1. Composite Actions

Composite Actions were covered in detail in **Lecture 11**, where we learned how to build reusable Actions by orchestrating existing GitHub Actions and shell commands. We also explored Action metadata (`action.yml`), Action Inputs and Outputs, Local Actions, and best practices for designing reusable Composite Actions.

> **Note:** Since Composite Actions have already been covered, we will not revisit them in this lecture. Instead, we will focus on the remaining two Action types: **JavaScript Actions** and **Docker Actions**.

---


#### 2. JavaScript Actions

* Implemented using **JavaScript** or **TypeScript**, JavaScript Actions allow developers to write **custom automation logic** that goes beyond orchestrating existing workflow steps. Unlike **Composite Actions**, whose primary purpose is to combine existing GitHub Actions, shell commands, and scripts, JavaScript Actions can implement entirely new functionality tailored to your specific use case.

  > **What is TypeScript?** **TypeScript** is a **superset of JavaScript** (**meaning every valid JavaScript program is also valid TypeScript**) that adds features such as **static type checking**, **interfaces**, **classes**, **generics**, and improved **IDE support** (for example, better code completion, navigation, and error detection). These features make large applications easier to develop, maintain, and refactor. Before execution, TypeScript is **compiled into standard JavaScript**, which is then executed by the **Node.js runtime**. Throughout this lecture, we will use **JavaScript** to keep the implementation simple, although many production-grade GitHub Actions are developed using **TypeScript**.

  > **Understanding the Node.js Runtime:** Since **JavaScript Actions** are implemented using **JavaScript**, they require a **Node.js runtime** for execution. Consequently, any runner executing a JavaScript Action must have a compatible **Node.js runtime** available.
  >
  > This is why every JavaScript Action specifies the Node.js runtime that GitHub should use:
  >
  > ```yaml
  > runs:
  >   using: node24
  > ```
  >
  > When GitHub encounters this configuration, it starts the specified **Node.js runtime** on the runner and uses it to execute the JavaScript file referenced by the **`main`** property in the **`action.yml`** file.
  >
  > **Note:** Every programming language requires an execution environment. For languages such as **JavaScript**, **Python**, **Java**, and **C#**, this is typically provided by a language runtime. In contrast, languages such as **Go**, **Rust**, and **C++** are generally compiled into standalone executables, allowing them to run without requiring a separately installed language runtime.


* They are particularly well suited for automating **GitHub itself**. GitHub exposes **REST** and **GraphQL APIs**, which allow applications to programmatically interact with GitHub resources such as **Repositories**, **Pull Requests**, **Issues**, **Releases**, **Workflows**, **Branches**, and many others. Using these APIs, a JavaScript Action can retrieve information, create or update resources, process the response, and make decisions dynamically during workflow execution.

  Since JavaScript is a **general-purpose programming language**, it provides language features such as variables, loops, functions, modules, exception handling, and access to a rich ecosystem of libraries. These capabilities make JavaScript Actions well suited for implementing complex automation such as automatically labeling Pull Requests, generating Release Notes, creating GitHub Releases, managing repository settings, validating workflow inputs, processing workflow data, and generating dynamic outputs.

  > **Note:** Many of these tasks can also be implemented using **shell scripts** orchestrated by a **Composite Action**. However, as the automation becomes more complex, implementing and maintaining the logic in a **programming language** such as **JavaScript** is generally simpler, more structured, and easier to extend. **Shell scripting** and **programming languages** both have their place, and the right choice depends on the complexity of your automation requirements.

* Many of the most widely used GitHub Actions are implemented as **JavaScript Actions**. Examples include **`actions/checkout`**, **`actions/setup-node`**, **`actions/setup-java`**, **`actions/setup-python`**, **`actions/cache`**, **`actions/upload-artifact`**, **`actions/download-artifact`**, **`aws-actions/configure-aws-credentials`**, and **`docker/login-action`**. Although millions of developers use these Actions every day, most simply consume them without needing to understand their underlying implementation.

> **Mental Model:** Unlike **Composite Actions**, which primarily reuse and orchestrate existing workflow steps, **JavaScript Actions** allow you to implement entirely new automation logic using a programming language.

```text
Reuse Existing Workflow Steps → Composite Action

Write New Automation Logic → JavaScript Action
```

> **Recommendation:** Choose a **JavaScript Action** when your automation requires **custom programming logic**, **GitHub API interactions**, **dynamic data processing**, or functionality that would become difficult or cumbersome to implement using only shell scripts or Composite Actions.

> **Production Insight:** JavaScript Actions execute directly on the **GitHub-hosted Node.js runtime**, making them **lighter than Docker Actions** because they do not need to build or start a container. They are commonly used for GitHub-centric automation such as managing **Pull Requests**, **Issues**, **Releases**, **Repository settings**, generating **Release Notes**, implementing approval workflows, and building internal developer platform capabilities.

For example:

```text
Read Workflow Inputs → Call GitHub REST API → Process Response → Generate Outputs
```

```text
Automatically Label Pull Requests → Generate Release Notes → Create GitHub Releases → Update Issues
```

> **Note:** Although many of these tasks can also be implemented using **shell scripts** orchestrated by a **Composite Action**, a **programming language** such as **JavaScript** generally provides a cleaner, more structured, and more maintainable approach as the automation becomes more complex. Both approaches have their place, and the right choice depends on the complexity of your automation requirements.

**Common Characteristics:**

* Every JavaScript Action is defined using an **`action.yml`** metadata file and executes JavaScript or TypeScript code using the **Node.js runtime**. We will explore the structure of this metadata file during the hands-on demonstration.

* Like Composite Actions, JavaScript Actions can be maintained as **Local Actions** within the same repository or as **Remote Actions** that are versioned and shared across multiple repositories.

> **Key Takeaway:** You do **not** need to be a JavaScript developer to use GitHub Actions effectively. Most Cloud and DevOps engineers primarily **consume JavaScript Actions** published by others rather than building them from scratch. Understanding how JavaScript Actions are structured and executed will enable you to confidently use, customize, and, when required, build your own.

---

#### 3. Docker Actions

* Packaged inside a **Docker container**, Docker Actions execute within their own isolated execution environment. Unlike **JavaScript Actions**, which rely on the **Node.js runtime** available on the runner, Docker Actions package the **operating system**, **runtime**, **tools**, **libraries**, and **application code** together inside a Docker image.

* They are best suited for automation that requires a **custom runtime**, **specialized software dependencies**, **operating system utilities**, or programming languages other than **JavaScript**, particularly when those dependencies are difficult or undesirable to install directly on the runner.

> **Mental Model:** Unlike **Composite Actions**, which reuse existing workflow steps, and **JavaScript Actions**, which execute custom JavaScript code using the **Node.js runtime**, **Docker Actions** package the **entire execution environment** together with the automation logic. As a result, the Action executes with the same operating system, runtime, tools, and dependencies regardless of the runner configuration.

```text
Reuse Existing Workflow Steps → Composite Action

Write New Automation Logic → JavaScript Action

Package the Entire Execution Environment → Docker Action
```

> **Recommendation:** Choose a **Docker Action** only when your automation requires a **custom execution environment**, **specialized software dependencies**, **operating system utilities**, or programming languages that cannot be conveniently supported using Composite or JavaScript Actions.

> **Production Insight:** Docker Actions package the **operating system**, **runtime**, **tools**, **libraries**, and **application code** into a single Docker image. Instead of installing and configuring these dependencies during every workflow execution, they are packaged once into the image and reused whenever the Action executes. This makes Docker Actions ideal for building consistent, portable, and reproducible automation.

For example, a Docker Action can package an entire software stack:

```text
Ubuntu → Python → Terraform → kubectl → Helm → Custom Application
```

or

```text
Alpine Linux → Java → Maven → Trivy → Custom Application
```

Regardless of the runner, the Action always executes inside the same containerized environment.

> **Performance Consideration:** Docker Actions generally take **longer to start** than **JavaScript Actions** because GitHub may need to **build** or **pull** the Docker image before the Action can execute.

> **Platform Limitation:** Docker Actions execute **only on Linux runners** because the container runtime is Linux-based. They cannot execute directly on **Windows** or **macOS** runners. For **self-hosted runners**, Docker must be installed and properly configured on the Linux host.

**Common Characteristics:**

* Every Docker Action is defined using an **`action.yml`** metadata file and executes inside a **Docker container**. As with the other Action types, we will explore the structure of this metadata file during the hands-on demonstration.

* Like **Composite Actions** and **JavaScript Actions**, Docker Actions can be maintained as **Local Actions** within the same repository or as **Remote Actions** that are versioned and shared across multiple repositories.

> **Key Takeaway:** Docker Actions provide the **greatest flexibility** because they package **both the automation logic and the complete execution environment**. In practice, they should generally be the **last choice**, used only when **Composite Actions** or **JavaScript Actions** cannot satisfy the runtime, dependency, or operating system requirements.

---

## Demo 1: Creating Your First JavaScript Action

As we learned in the theory section, **JavaScript Actions** allow us to implement **custom automation logic** using **JavaScript** or **TypeScript**. Unlike Composite Actions, which primarily orchestrate existing workflow steps, JavaScript Actions execute application code on the **Node.js runtime**, enabling us to interact with the GitHub Actions Toolkit, GitHub APIs, and workflow context.

In this demo, we will build our first **JavaScript Action** that accepts an input, reads information about the current workflow execution, and displays it in the workflow logs. The goal of this demo is not to learn JavaScript programming, but rather to understand how a JavaScript Action is structured, packaged, and executed within GitHub Actions.

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

> **Operational Note:** GitHub automatically discovers workflow files placed under the **`.github/workflows`** directory. When a workflow is triggered, GitHub provisions a runner, downloads the repository, and executes the workflow steps, including any Local or Remote Actions referenced by the workflow.

---

### Step 2: Preparing the Directory Structure for the JavaScript Action

For this demo, we will create a **Local JavaScript Action** inside the repository. Unlike Composite Actions, a JavaScript Action contains application code that GitHub executes using the **Node.js runtime**.

Create the following directory structure.

```text
.github
├── actions
│   └── workflow-summary
│       ├── action.yml
│       ├── index.js
│       └── package.json
└── workflows
    └── javascript-action-demo.yml
```

* Every subdirectory inside **`.github/actions`** represents a **single Local Action**. Since each Action must contain an **`action.yml`** metadata file describing how the Action should execute, organizing every Action into its own directory makes them easier to maintain, version, and reuse.

* Unlike Composite Actions, JavaScript Actions also contain one or more **JavaScript source files**. In this demo, our entire implementation resides inside **`index.js`**, which serves as the Action's entry point.
  > **Note:** Throughout this course, we'll use **`index.js`** as the **entry point** for our JavaScript Actions. **Production-grade JavaScript Actions** may use a different filename or a compiled file such as **`dist/index.js`**, but the **underlying concept remains the same**.

* We also include a **`package.json`** file, which describes the JavaScript project and lists any external libraries required by the Action.
  > **Note:** Although **very simple JavaScript Actions** can execute **without a `package.json` file**, it is considered **standard practice** to include one. Throughout this course, we will include a **`package.json`** in our JavaScript Actions so that our project structure **aligns with what you will encounter in production environments and open-source GitHub Actions**.

* For simplicity, our Action consists of only **`action.yml`**, **`package.json`**, and **`index.js`**. Production-grade JavaScript Actions often include additional files and directories, for example:

  * **`src/`**: Contains the Action's source code.
  * **`dist/`**: Contains the compiled JavaScript that GitHub executes.
  * **Additional JavaScript files**: Larger projects often split the implementation into multiple files (for example, `utils.js`, `helpers.js`, or `logger.js`) to improve organization and maintainability.
  * **`README.md`**: Documents how to use the Action.
  * **`.gitignore`**: Specifies files and directories that Git should ignore.
  * **`LICENSE`**: Defines the licensing terms for the Action.

> **Note:** Regardless of how many files a JavaScript Action contains, GitHub always begins execution from the entry point specified in the Action's metadata file.

> **Note:** Throughout this demo, we will focus on understanding how GitHub executes a JavaScript Action rather than learning JavaScript programming. The JavaScript code itself has been intentionally kept simple so that we can concentrate on the GitHub Actions concepts.

---

### Step 3: Understanding `package.json`

Before writing any JavaScript code, let's first create the **`package.json`** file.

**`package.json`**

```json
{
  "name": "workflow-summary-action",
  "version": "1.0.0",
  "description": "Simple GitHub JavaScript Action",
  "main": "index.js",
  "dependencies": {
    "@actions/core": "^1.11.1",
    "@actions/github": "^6.0.1"
  }
}
```

As discussed earlier, a JavaScript Action is essentially a **Node.js project**. Most Node.js projects contain a **`package.json`** file that describes the project and declares any external libraries that it depends on.

Let's briefly understand each property.

* **`name`** uniquely identifies the project.

* **`version`** specifies the current version of the project.

* **`description`** provides a short summary describing the purpose of the Action.

* **`main`** specifies the application's entry point. In our demo, execution begins from **`index.js`**.

* **`dependencies`** declares the external libraries that our Action requires.

For this demo, we declare two libraries from the **GitHub Actions Toolkit**. The **GitHub Actions Toolkit (`actions/toolkit`)** is a collection of libraries provided by GitHub that simplify common tasks such as reading Action inputs, setting outputs, writing log messages, accessing the GitHub Actions Context, and interacting with the GitHub API. Rather than implementing these capabilities from scratch, JavaScript Actions can leverage these libraries to build automation more efficiently.

* **`@actions/core`** provides commonly used functionality such as reading Action inputs, writing log messages, setting outputs, and marking an Action as failed.

* **`@actions/github`** provides access to the **GitHub Actions Context** and the **GitHub REST API**, allowing us to retrieve information about the current workflow execution, such as the repository, workflow, actor, event, branch, and commit SHA, as well as interact programmatically with GitHub resources.

> **Note:** The **`package.json`** file only **declares** the project's dependencies. Later in this demo, we will use **`npm install`** to download these libraries before executing our JavaScript Action.

> **Production Insight:** Most production-grade JavaScript Actions rely on one or more libraries from the **GitHub Actions Toolkit**. Rather than implementing common functionality from scratch, these libraries provide a simple and consistent interface for interacting with GitHub Actions.
---

### Step 4: Understanding `index.js`

Next, create the following JavaScript file.

**`index.js`**

```javascript
const core = require("@actions/core");
const github = require("@actions/github");

try {

    const name = core.getInput("name");

    core.info("========================================");
    core.info("GitHub JavaScript Action");
    core.info("========================================");

    core.info("");
    core.info(`Hello ${name}!`);
    core.info("");

    core.info("Workflow Information");
    core.info("----------------------------------------");
    core.info(`Repository : ${github.context.repo.owner}/${github.context.repo.repo}`);
    core.info(`Workflow   : ${github.context.workflow}`);
    core.info(`Actor      : ${github.context.actor}`);
    core.info(`Event      : ${github.context.eventName}`);
    core.info(`Branch     : ${github.context.ref}`);
    core.info(`Run Number : ${github.context.runNumber}`);
    core.info(`SHA        : ${github.context.sha}`);

}
catch (error) {
    core.setFailed(error.message);
}
```

#### Explanation

Although this file contains JavaScript code, there are only a few GitHub Actions concepts that we need to understand. Throughout this demo, focus on **how the Action receives inputs, interacts with the GitHub Actions Toolkit, accesses workflow information, and handles failures** rather than the JavaScript syntax itself.

---

The first two statements import the GitHub Actions Toolkit libraries that we declared in **`package.json`**.

```javascript
const core = require("@actions/core");
const github = require("@actions/github");
```

Before understanding these libraries, let's briefly understand the syntax.

* **`const`** declares a variable. Here, **`core`** and **`github`** are simply variable names that we use to access the functionality provided by the imported libraries.

* **`require()`** imports an external library so that its functionality becomes available to our JavaScript Action.

We import two libraries from the **GitHub Actions Toolkit**.

* **`@actions/core`** provides helper functions for interacting with the workflow, such as reading inputs, writing log messages, setting outputs, and reporting failures.

* **`@actions/github`** provides access to the **GitHub Actions Context**, which contains metadata about the current workflow execution, along with helper functions for interacting with the **GitHub REST API**.

---

Next, we read the Action input.

```javascript
const name = core.getInput("name");
```

The **`getInput()`** function retrieves the value of the input named **`name`**, which is supplied by the calling workflow. If you've previously used expressions such as **`${{ inputs.name }}`** in **Composite Actions**, this serves the same purpose but through the **GitHub Actions Toolkit**.

---

We then write informational messages to the workflow logs.

```javascript
core.info(...)
```

The **`info()`** function writes informational messages that appear in the GitHub Actions workflow logs. In this demo, we use it to display a greeting along with details about the current workflow execution.

---

Next, we retrieve information from the **GitHub Actions Context**.

```javascript
github.context
```

The **`context`** object provides metadata about the current workflow execution. In this demo, we retrieve information such as:

* Repository
* Workflow
* Actor
* Event
* Branch
* Run Number
* Commit SHA

If you've been following this course, these values should already look familiar. Earlier, we accessed them directly in workflow YAML using expressions such as **`${{ github.actor }}`** and **`${{ github.repository }}`**. In a JavaScript Action, we access the same information programmatically through the **GitHub Actions Toolkit**.

---

Finally, notice the **`try-catch`** block surrounding the implementation.

```javascript
catch (error) {
    core.setFailed(error.message);
}
```

If an unexpected error occurs while the Action is executing, **`core.setFailed()`** marks the Action as failed and displays the error message in the workflow logs. This is a common error-handling pattern used by production-grade JavaScript Actions.

> **Key Takeaway:** The JavaScript code itself is intentionally simple. The objective of this demo is to understand **how a JavaScript Action is organized**, **how it uses the GitHub Actions Toolkit**, **how it receives inputs**, **how it writes logs**, **how it accesses the GitHub Actions Context**, and **how it handles failures**. Once these concepts are understood, building more advanced JavaScript Actions becomes much easier.

---

### Step 5: Creating the Calling Workflow

Now that our **JavaScript Action** is ready, the final step is to create a workflow that invokes it.

Create the following workflow.

**`.github/workflows/javascript-action-demo.yaml`**

```yaml
name: JavaScript Action Demo

on:
  workflow_dispatch:

jobs:
  demo:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v5

      - name: Install Action Dependencies
        working-directory: ./.github/actions/workflow-summary
        run: npm install

      - name: Execute JavaScript Action
        uses: ./.github/actions/workflow-summary
        with:
          name: Cloud With VarJosh
```

#### Explanation

Most of this workflow should already be familiar from the previous lectures. Let's focus only on the new concepts.

---

```yaml
- name: Install Action Dependencies
  working-directory: ./.github/actions/workflow-summary
  run: npm install
```

Earlier, we declared our JavaScript libraries inside **`package.json`**. However, declaring dependencies alone does not install them.

The **`npm install`** command downloads all the libraries listed in **`package.json`** and stores them inside the **`node_modules`** directory. These libraries are then available when our JavaScript Action executes.

The **`working-directory`** property ensures that the command executes inside the directory containing our JavaScript Action, allowing **npm** to locate the appropriate **`package.json`** file.

> **Note:** Defining dependencies in **`package.json`** does **not** automatically install them. Initially, our Action contains only the source code and the dependency declarations:
>
> ```text
> .github/actions/workflow-summary/
> ├── action.yml
> ├── index.js
> └── package.json
> ```
>
> During development, we execute **`npm install`**, which reads the **`package.json`** file, downloads the required libraries, and stores them inside the **`node_modules`** directory:
>
> ```text
> .github/actions/workflow-summary/
> ├── action.yml
> ├── index.js
> ├── package.json
> └── node_modules/
>     ├── @actions/core
>     ├── @actions/github
>     └── ...
> ```
>
> At this point, the Action has access to all the libraries it depends on and can execute successfully. Many **production-grade JavaScript Actions** do not require this step because their authors **bundle the Action together with its dependencies before publishing**. As a result, consumers can simply reference the Action using **`uses:`** without installing any dependencies themselves.

---

```yaml
- name: Execute JavaScript Action
  uses: ./.github/actions/workflow-summary

  with:
    name: Cloud With VarJosh
```

This step invokes the **Local JavaScript Action** that we created earlier. Notice that the syntax is identical to invoking a **Composite Action**.

The **`uses`** keyword specifies the location of the Action, while the **`with`** block supplies the Action inputs.

In this demo, we provide the value **`Cloud With VarJosh`** for the **`name`** input. Inside the Action, this value is retrieved using:

```javascript
const name = core.getInput("name");
```

This demonstrates the complete flow of data:

```text
Calling Workflow (with.name) → JavaScript Action (core.getInput("name")) → Workflow Logs
```

> **Observation:** From the perspective of the calling workflow, invoking a **JavaScript Action** is no different from invoking a **Composite Action** or a **Remote Action**. The implementation details remain encapsulated within the Action itself, allowing workflows to remain simple and focused on orchestration.

---

### Step 6: Commit and Push the Changes

Commit the changes and push them to your GitHub repository.

```bash
git add .
git commit -m "Demo: Add JavaScript Action demo"
git remote add origin git@github.com:CloudWithVarJosh/cwvj-gha-practice.git
git push -u origin main
```

Once the workflow YAML is pushed, GitHub automatically discovers the workflow and makes it available under the **Actions** tab of your repository.

---

### Step 7: Running the Workflow

Navigate to your repository on GitHub and open the **Actions** tab.

Since this workflow is configured with the **`workflow_dispatch`** trigger, it must be started manually.

Select the **JavaScript Action Demo** workflow and click **Run workflow**.

After a few seconds, GitHub schedules the workflow on a GitHub-hosted runner and begins executing each step in sequence.

---

### Step 8: Observing Workflow Execution

Once the workflow completes successfully, open the workflow run and examine the execution logs.

Notice that the workflow first executes **Checkout Repository**, followed by **Install Action Dependencies**, and finally our **Execute JavaScript Action** step.

Expand the **Execute JavaScript Action** step. You should see output similar to the following:

```text
========================================
GitHub JavaScript Action
========================================

Hello Cloud With VarJosh!

Workflow Information
----------------------------------------
Repository : CloudWithVarJosh/cwvj-gha-practice
Workflow   : JavaScript Action Demo
Actor      : CloudWithVarJosh
Event      : workflow_dispatch
Branch     : refs/heads/main
Run Number : 1
SHA        : <commit-sha>
```

Observe how the Action successfully:

* Read the **`name`** input supplied by the calling workflow.
* Retrieved workflow metadata from the **GitHub Actions Context**.
* Wrote informational messages to the workflow logs using the **GitHub Actions Toolkit**.

> **Observation:** From the workflow's perspective, invoking a **JavaScript Action** is no different from invoking a **Composite Action** or any other GitHub Action. The workflow simply references the Action using **`uses:`**, while the Action encapsulates all of its implementation details. This abstraction allows workflows to remain simple, readable, and focused on orchestration rather than implementation.

> **Exercise:** Try changing the value supplied for the **`name`** input in the calling workflow, commit the changes, and run the workflow again. Observe how the updated value is retrieved using **`core.getInput("name")`** and displayed in the workflow logs. This simple experiment reinforces how data flows from the **calling workflow** into a **JavaScript Action**.

---

## Demo 2: Creating a Docker Action

As we learned in the theory section, **Docker Actions** package both the **automation logic** and the **entire execution environment** into a Docker image. Unlike **Composite Actions**, which reuse existing workflow steps, and **JavaScript Actions**, which execute JavaScript code using the **Node.js runtime**, Docker Actions execute inside their own **Docker container**.

In this demo, we will create our first **Docker Action**. Rather than performing a complex real-world task, our Action will simply display information about the container in which it is executing. This allows us to focus entirely on understanding **how Docker Actions are structured**, **how they execute**, and **how they differ from the other Custom Action types**.

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

> **Operational Note:** Docker Actions execute as part of a GitHub Actions workflow. Whenever workflow YAML files are pushed into the repository, GitHub automatically discovers them and evaluates whether they should execute based on their configured workflow triggers.

---

### Step 2: Preparing the Docker Action

Create the following directory structure.

```text
Demo-02

├── .github
│   ├── actions
│   │   └── docker-system-info
│   │       ├── action.yml
│   │       ├── Dockerfile
│   │       └── entrypoint.sh
│   └── workflows
│       └── docker-action-demo.yaml
```

* Every subdirectory inside **`.github/actions`** represents a **single Local Action**. Since every Docker Action must define an **`action.yml`** metadata file, organizing each Action into its own directory makes them easier to maintain, version, and reuse.

* Unlike **Composite Actions** and **JavaScript Actions**, Docker Actions also include a **Dockerfile**, which defines the Docker image used to execute the Action.

* Every Docker Action must define a **Docker `ENTRYPOINT`**, which represents the starting point of the Action. The `ENTRYPOINT` contains the **automation logic** that GitHub executes after starting the Docker container. In this demo, our `ENTRYPOINT` is the **`entrypoint.sh`** shell script. In production, the `ENTRYPOINT` could instead execute a **Python application** (`python app.py`), a **Java application** (`java -jar app.jar`), a **Go executable** (`./my-application`), a **Node.js application** (`node app.js`), or any other executable packaged inside the Docker image.

* Unlike **JavaScript Actions**, which always execute on the **Node.js runtime**, Docker Actions are **language-agnostic**. Since the Docker image packages the complete execution environment, the Action can be implemented using **Bash**, **Python**, **Java**, **Go**, **Node.js**, **Ruby**, **PHP**, **Rust**, **C++**, or virtually any other language or executable, provided the Docker image contains the required runtime, libraries, and dependencies.

> **Note:** For simplicity, our Docker Action consists of only **`action.yml`**, **`Dockerfile`**, and **`entrypoint.sh`**. Production-grade Docker Actions may include additional files such as shell scripts, Python programs, configuration files, documentation, or other application resources. Regardless of the project's size, GitHub always starts by building the Docker image defined in the **Dockerfile**, launching a container, and executing the configured entry point.

---

### Step 3: Creating the Dockerfile

Create the following **Dockerfile**.

**`Dockerfile`**

```dockerfile
FROM alpine:3.22

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

#### Explanation

The **Dockerfile** defines the Docker image that GitHub builds before executing the Docker Action.

Although Dockerfiles can become very sophisticated, our example uses only four instructions.

```dockerfile
FROM alpine:3.22
```

The **`FROM`** instruction specifies the base image from which our Docker image is created. In this demo, we use **Alpine Linux**, a lightweight Linux distribution commonly used for building Docker images.

---

```dockerfile
COPY entrypoint.sh /entrypoint.sh
```

The **`COPY`** instruction copies files from the repository into the Docker image. Here, we copy the **`entrypoint.sh`** script, which contains the automation logic that will execute when the container starts.

---

```dockerfile
RUN chmod +x /entrypoint.sh
```

The **`RUN`** instruction executes commands while the Docker image is being built.

Here, we make the **`entrypoint.sh`** script executable so that Linux can execute it after the container starts.

---

```dockerfile
ENTRYPOINT ["/entrypoint.sh"]
```

The **`ENTRYPOINT`** instruction specifies the command that executes automatically whenever a container is started from this image.

For our Docker Action, GitHub eventually launches a container from this image, causing **`entrypoint.sh`** to execute.

The overall execution flow therefore becomes:

```text
Build Docker Image → Start Container → Execute ENTRYPOINT
```

> **Observation:** Unlike **JavaScript Actions**, which execute directly on the **Node.js runtime** available on the runner, Docker Actions first **build a Docker image**, then **start a container**, and finally execute the configured **ENTRYPOINT**.

---

### Step 4: Creating the Entrypoint Script

Next, create the following shell script.

**`entrypoint.sh`**

```bash
#!/bin/sh

NAME="$1"

echo "========================================"
echo "GitHub Docker Action"
echo "========================================"

echo
echo "Hello ${NAME}!"
echo

echo "Container Information"
echo "----------------------------------------"
echo "OS Information"
cat /etc/os-release
echo
echo "Current User     : $(whoami)"
echo "Working Directory: $(pwd)"
```

> **Note:** In this demo, we intentionally use a very simple **`entrypoint.sh`** script so that we can focus on understanding **how Docker Actions are structured and executed** rather than the automation logic itself. In production environments, the Docker `ENTRYPOINT` often performs much more sophisticated automation. Depending on the use case, it might execute a **Python application**, **Java application**, **Node.js application**, **Go executable**, or a complex shell script that orchestrates multiple tools and performs tasks such as provisioning cloud infrastructure, building and publishing container images, deploying applications to Kubernetes, running security or compliance scans, generating reports, interacting with external APIs, or implementing organization-specific automation workflows.

#### Explanation

Unlike **Composite Actions** and **JavaScript Actions**, a Docker Action executes **inside a Docker container**. Once GitHub starts the container, it executes the script specified by the **`ENTRYPOINT`** instruction in the **Dockerfile**.

The first line specifies the shell interpreter.

```bash
#!/bin/sh
```

This instructs Linux to execute the script using the **Bourne Shell (`sh`)**.

---

```bash
NAME="$1"
```

The **`$1`** variable represents the **first command-line argument** passed to the script. Here, we store that value in a variable named **`NAME`** so that it can be referenced more easily throughout the script.

Later, when we create the **`action.yml`** file, GitHub passes the value supplied by the calling workflow as the first command-line argument. For this demo, the flow is:

```text
Calling Workflow (with.name) → action.yml (args) → entrypoint.sh ($1) → NAME
```

---

The remaining commands simply display information about the running container.

```bash
echo "OS Information"
echo "Current User     : ..."
echo "Working Directory: ..."
```

These commands retrieve information directly from the **Docker container**, demonstrating that the Action is executing inside its own isolated environment rather than directly on the GitHub runner.

> **Key Takeaway:** The shell script itself is intentionally simple. The objective of this demo is to understand **how a Docker Action executes inside a container** and **how it receives inputs from the calling workflow**.

---

### Step 5: Creating the Action Metadata

Now that our **Dockerfile** and **entrypoint script** are ready, let's create the Action metadata.

**`action.yml`**

```yaml
name: Docker System Info
description: Demonstrates a simple Docker Action

inputs:
  name:
    description: Name to display
    required: true

runs:
  using: docker
  image: Dockerfile

  args:
    - ${{ inputs.name }}
```

#### Explanation

Most of this file should already look familiar because its structure is very similar to the **Composite Action** and **JavaScript Action** metadata files. Let's focus only on the Docker-specific configuration.

---
```yaml
runs:
  using: docker
  image: Dockerfile
```

The **`using: docker`** property tells GitHub that this is a **Docker Action**.

The **`image`** property specifies the Docker image that should be used when executing the Action. Since we reference **`Dockerfile`**, GitHub automatically builds a Docker image from this file **on the GitHub-hosted runner** and then starts a Docker container from that image.

Execution Flow:

```text
GitHub Workflow → GitHub-hosted Runner (runs-on, from workflow yaml) → Build Docker Image (Dockerfile) → Start Docker Container → Execute Docker ENTRYPOINT
```

> **Important:** A Docker Action does **not** replace the GitHub-hosted runner. GitHub still provisions the **runner (virtual machine)** specified by the **`runs-on`** property. The **runner orchestrates the workflow** by building the Docker image and starting the Docker container, while the **container executes the Action's automation logic**.

---

Next, notice the **`args`** section.

```yaml
args:
  - ${{ inputs.name }}
```

The **`args`** property passes command-line arguments to the container.

In this demo, the value supplied for **`inputs.name`** becomes the **first command-line argument** received by the **`entrypoint.sh`** script.

Inside the script, we retrieve this value using:

```bash
NAME="$1"
```

This demonstrates the complete flow of data.

```text
Calling Workflow (with.name) → Action Input → Docker Container → entrypoint.sh ($1)
```

> **Observation:** Regardless of whether you create a **Composite Action**, **JavaScript Action**, or **Docker Action**, inputs are always supplied by the calling workflow. The only difference is **how the Action consumes those inputs internally**.

---

### Step 6: Creating the Calling Workflow

Now that our **Docker Action** is ready, the final step is to create a workflow that invokes it.

Create the following workflow.

**`.github/workflows/docker-action-demo.yaml`**

```yaml
name: Docker Action Demo

on:
  workflow_dispatch:

jobs:
  demo:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v5

      - name: Execute Docker Action
        uses: ./.github/actions/docker-system-info

        with:
          name: Cloud With VarJosh
```

#### Explanation

Most of this workflow should already be familiar from the previous lectures. Let's focus only on the new concepts.

---

```yaml
- name: Execute Docker Action
  uses: ./.github/actions/docker-system-info

  with:
    name: Cloud With VarJosh
```

This step invokes the **Local Docker Action** that we created earlier.

The **`uses`** keyword specifies the location of the Docker Action, while the **`with`** block supplies the Action inputs.

Unlike the JavaScript Action demo, we do **not** execute **`npm install`** because Docker Actions package everything they need inside the Docker image.

GitHub performs the following operations automatically:

```text
Build Docker Image → Start Container → Execute ENTRYPOINT
```

The value supplied through the **`with`** block is passed to the container as a command-line argument, where it is received by the **`entrypoint.sh`** script.

```text
Calling Workflow (with.name) → Docker Action → entrypoint.sh ($1) → Workflow Logs
```

> **Observation:** From the perspective of the calling workflow, invoking a **Docker Action** is no different from invoking a **Composite Action** or a **JavaScript Action**. The workflow simply references the Action using **`uses:`**, while GitHub takes care of building the Docker image, starting the container, and executing the Action.

---

### Step 7: Commit and Push the Changes

Commit the changes and push them to your GitHub repository.

```bash
git add .
git commit -m "Demo: Add Docker Action demo"
git push origin main
```

Once the workflow YAML files are pushed, GitHub automatically discovers the workflow and makes it available under the **Actions** tab of your repository.

---
### Step 8: Running the Workflow

Navigate to your repository on GitHub and open the **Actions** tab.

Since this workflow is configured with the **`workflow_dispatch`** trigger, it must be started manually.

Select the **Docker Action Demo** workflow and click **Run workflow**.

GitHub first builds the Docker image defined by the **Dockerfile**, starts a container from that image, and then executes the **`entrypoint.sh`** script.

---

### Step 9: Observing Workflow Execution

Once the workflow completes successfully, open the workflow run and examine the execution logs.

Notice that GitHub first checks out the repository, builds the Docker image, starts a container, and finally executes our Docker Action.

Expand the **Execute Docker Action** step. You should see output similar to the following:

```text
========================================
GitHub Docker Action
========================================

Hello Cloud With VarJosh!

Container Information
----------------------------------------
OS Information
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.22.5
PRETTY_NAME="Alpine Linux v3.22"
HOME_URL="https://alpinelinux.org/"
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"

Current User     : root
Working Directory: /github/workspace
```

Observe how the Action successfully:

* Retrieved the **`name`** input supplied by the calling workflow.
* Executed inside a **Docker container** rather than directly on the GitHub runner.
* Retrieved information about the **container's execution environment**.

> **Note:** The **`/github/workspace`** directory is the **working directory** inside the Docker container. GitHub automatically mounts the checked-out repository from the **GitHub-hosted runner** into this location, allowing the Docker Action to access the repository files. Although the Action executes inside the container, it can still read and modify the repository contents through this mounted workspace.

> **Observation:** Although **Composite Actions**, **JavaScript Actions**, and **Docker Actions** are implemented differently, they are all consumed by workflows using the same **`uses:`** syntax. The primary difference is that a **Docker Action** executes inside its own **containerized execution environment**, packaging its operating system, runtime, tools, and application code together. This is the key advantage of Docker Actions and the reason they are commonly used when complete control over the execution environment is required.

---

### Which Custom Action Should You Use?

Although all three Action types allow you to build **reusable GitHub Actions**, they solve different problems. As a general rule, choose the **simplest Action type** that satisfies your requirement. Most organizations naturally progress from **Composite Actions** to **JavaScript Actions** and finally **Docker Actions** only when additional capabilities become necessary.

The three Action types can be summarized as follows:

```text
Composite Action  → Reuse Existing GitHub Actions, Shell Commands & Scripts

JavaScript Action → Write New Automation Logic using the Node.js Runtime

Docker Action     → Package Your Own Runtime, Tools & Dependencies
```

Another useful way to think about them is from the perspective of **what is actually being executed**.

| Action Type           | What You Write                                           | What Executes                                                                               |
| --------------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **Composite Action**  | Workflow steps (GitHub Actions, shell commands, scripts) | Existing workflow steps execute directly on the **GitHub-hosted runner**                    |
| **JavaScript Action** | JavaScript or TypeScript                                 | JavaScript executes using the **Node.js runtime** available on the **GitHub-hosted runner** |
| **Docker Action**     | Any executable (Shell, Python, Java, Go, Node.js, etc.)  | The executable runs **inside a Docker container** created on the **GitHub-hosted runner**   |

The following table summarizes the most common decision criteria.

| Requirement                                                                  | Recommended Action    |
| ---------------------------------------------------------------------------- | --------------------- |
| Reuse existing GitHub Actions, shell commands, or scripts                    | **Composite Action**  |
| Standardize common CI/CD workflows across multiple workflows or repositories | **Composite Action**  |
| Implement custom programming logic                                           | **JavaScript Action** |
| Perform complex data processing or implement advanced automation logic       | **JavaScript Action** |
| Build automation using the GitHub Actions Toolkit or GitHub APIs             | **JavaScript Action** |
| Package custom runtimes, tools, or specialized software dependencies         | **Docker Action**     |
| Use programming languages other than Node.js                                 | **Docker Action**     |
| Require a consistent and isolated execution environment                      | **Docker Action**     |

As a general rule:

```text
Need to reuse existing workflow steps?
        ↓
Composite Action

Need to write new automation logic?
        ↓
JavaScript Action

Need your own runtime, tools or execution environment?
        ↓
Docker Action
```

> **Rule of Thumb:** **Start with a Composite Action** because it is the simplest to author and maintain. Move to a **JavaScript Action** when your automation requires **custom programming logic** that cannot be cleanly implemented by combining existing workflow steps. Choose a **Docker Action** only when your automation depends on a **custom runtime**, **specialized tools**, or an **execution environment** that cannot be provided by the GitHub-hosted runner.

---

## Conclusion

In this lecture, we completed our journey through **GitHub Custom Actions** by exploring **JavaScript Actions** and **Docker Actions**.

We first learned how **JavaScript Actions** enable us to implement **custom automation logic** using the **Node.js runtime**, interact with the **GitHub Actions Toolkit**, access the **GitHub Actions Context**, and build automation that goes beyond simply orchestrating existing workflow steps. We then built our first JavaScript Action from scratch and integrated it into a workflow. 

Next, we explored **Docker Actions**, learning how they package the **automation logic**, **runtime**, **tools**, and **dependencies** into a Docker image. Through a simple Docker Action, we saw how GitHub builds the Docker image, starts a container on the runner, and executes the Action inside that isolated environment. 

You should now be able to confidently choose the appropriate Custom Action type for your automation:

* **Composite Actions** for **reusing existing GitHub Actions, shell commands, and scripts**.
* **JavaScript Actions** for **implementing custom programming logic** and **GitHub API automation**.
* **Docker Actions** for **packaging custom runtimes, tools, and specialized dependencies**. 

In the upcoming lectures, we will continue building on these concepts as we explore more advanced GitHub Actions capabilities.

---

## References

* **GitHub Documentation**

  * GitHub Actions: [https://docs.github.com/actions](https://docs.github.com/actions)
  * Creating a Composite Action: [https://docs.github.com/actions/sharing-automations/creating-actions/creating-a-composite-action](https://docs.github.com/actions/sharing-automations/creating-actions/creating-a-composite-action)
  * Creating a JavaScript Action: [https://docs.github.com/actions/sharing-automations/creating-actions/creating-a-javascript-action](https://docs.github.com/actions/sharing-automations/creating-actions/creating-a-javascript-action)
  * Creating a Docker Action: [https://docs.github.com/actions/sharing-automations/creating-actions/creating-a-docker-container-action](https://docs.github.com/actions/sharing-automations/creating-actions/creating-a-docker-container-action)
  * GitHub Actions Toolkit: [https://github.com/actions/toolkit](https://github.com/actions/toolkit)

* **Docker Documentation**

  * Dockerfile Reference: [https://docs.docker.com/reference/dockerfile/](https://docs.docker.com/reference/dockerfile/)
  * Docker Overview: [https://docs.docker.com/get-started/docker-overview/](https://docs.docker.com/get-started/docker-overview/)

---
