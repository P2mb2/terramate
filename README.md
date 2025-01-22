# Terraform Project
🙋‍♂️ **To all Terraform Coders** 🚀

Establishing standards in our Terraform projects is essential for ensuring **consistency**, **security**, and **scalability**. Standards enable us to **automate workflows**, integrate seamlessly into **CI/CD pipelines**, and enforce security best practices. By adhering to these standards, we can build a robust and resilient infrastructure that supports our organization's growth.

- [Terraform Project](#terraform-project)
  - [Terramate](#terramate)
    - [Why do we need terramate ?](#why-do-we-need-terramate-)
    - [How should we use terramate ?](#how-should-we-use-terramate-)
    - [Terramate Commands](#terramate-commands)
  - [Standard File Structure](#standard-file-structure)
  - [CLIOT](#cliot)


## Terramate
[Terramate](https://terramate.io/docs/) is not a CI/CD platform. It integrates with your existing CI/CD such as GitHub Actions, GitLab CI/CD, Jenkins and others, allowing you to automate and orchestrate your IaC using GitOps workflow in a secure and cost-effective manner!

### Why do we need terramate ?
We want to stay away from [Terralihts](https://masterpoint.io/updates/terralith-monolithic-terraform-architecture/). As Terraform offer no standard pattern on how to organize code efficiently, projects quickly sprawl out of control. The consequences are code complexity, long-running pipelines, large blast radius, drift, and poor governance.
Terramate CLI enables a new approach to eliminating the root cause of these consequences: using a modular and efficient approach called Terramate Stacks. A stack is a combination of infrastructure code, state and configuration, which can be nested to split state further.

### How should we use terramate ?
To avoid locking ourselves (more than needed) to Terramate, we should only use it for what it is needed: **deployment orchestration**. It is important to keep our Terraform code versioned under Terraform native modules (centrally or locally) and only use Terramate for the deployment/environment layer. Please don't use Terramate's code generation feature for things that can be accomplished natively with modules and variables. The aim is to take full advantage of this stack orchestrator while still using Terraform in its raw format whenever possible.

### Terramate Commands
📟 Most common used commands 📟

```bash
terramate create stacks/dev/example --name example --description "my example stack" --tags dev # create new stack

terramate generate # force a refresh on code automatically genereated by terramate

terramate list --run-order # show stack order

terramate run -C stacks/dev pwd # change directory before run
terramate run --changed pwd # run only changed stacks
terramate run --tags dev pwd # run only dev stacks
terramate run --no-tags dev pwd # run all stacks except dev tagged ones
terramate run --reverse pwd # run stacks in reverse order. Used for terraform destroy

terramate fmt # format terramate code
```

## Standard File Structure
New terraform projects should be created from our template. This will guarantee you have the structure that automation and pipelines needs to run successfully.

```bash
gh repo create my-new-project_name --template OWNER/REPO --clone
```

Root should contain the following folders:
```
📦repo_name
 ┣ 📂.github            ▪️ contains pipeline definition
 ┣ 📂imports            ▪️ contains terramate mixins for boilerplate code
 ┣ 📂modules            ▪️ contains all locally defined terraform modules (code layer)
 ┣ 📂scripts            ▪️ contains scripts intended to streamline and automate tasks
 ┣ 📂stacks             ▪️ contains environments and stacks (deployments layer)
 ┣ 📜config.tm.hcl      ▪️ Terramate project level configurations
 ┗ 📜terramate.tm.hcl   ▪️ Main terramate settings (Should not be changed)
```

Inside stacks folder there should be a folder per envioronment your project needs.
> [!NOTE]
> Environments must be named with one of the following options: dev, lit, e2e, stg, prd.

```
📦repo_name
 ┣ 📂stacks           
    ┗ 📂dev
       ┗ 📜config.tm.hcl          ▪ Environment terramate configurations
       ┗ 📂random
          ┣ 📜_backend.tf         ▪️ Managed by terramate so that we follow backends standard
          ┣ 📜_provider.tf        ▪️ Managed by terramate to dynamically upgrade providers per env
          ┣ 📜main.tf             ▪ Terraform code pointing to modules (local or remote)
          ┣ 📜terraform.tfvars    ▪ Variable values for the environment (loaded automatically)
          ┣ 📜variables.tfvars    ▪ Variable definition
          ┗ 📜stack.tm.hcl        ▪ Stack terramate configurations
       ┗ 📂file
          ┣ 📜_backend.tf         ▪️ Managed by terramate so that we follow backends standard
          ┣ 📜_provider.tf        ▪️ Managed by terramate to dynamically upgrade providers per env
          ┣ 📜main.tf             ▪ Terraform code pointing to modules (local or remote)
          ┣ 📜terraform.tfvars    ▪ Variable values for the environment (loaded automatically)
          ┣ 📜variables.tfvars    ▪ Variable definition
          ┗ 📜stack.tm.hcl        ▪ Stack terramate configurations
```
> [!IMPORTANT]
> All environments should be created via CLIOT.


## CLIOT
🛠 To help you follow this standards and speed up recurrent tasks we develop a command line tool called **cliot**.

