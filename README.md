# Terraform Project
🙋‍♂️ **To all IOT Terraform Coders** 🚀

Establishing standards in our Terraform projects is essential for ensuring consistency, security, and scalability. Standards enable us to automate workflows, integrate seamlessly into CI/CD pipelines, and enforce security best practices. By adhering to these standards, we can build a robust and resilient infrastructure that supports our organization's growth.

- [Terraform Project](#terraform-project)
  - [Terramate  ](#terramate--)
    - [Why do we need terramate ? ](#why-do-we-need-terramate--)
    - [How should i use terramate ? ](#how-should-i-use-terramate--)
    - [Terramate Commands ](#terramate-commands-)
  - [Standard File Structure ](#standard-file-structure-)
  - [CLIOT ](#cliot-)


## Terramate  <a name="terramate"></a>
[Terramate](https://terramate.io/docs/) is not a CI/CD platform. It integrates with your existing CI/CD such as GitHub Actions, GitLab CI/CD, Jenkins and others, allowing you to automate and orchestrate your IaC using GitOps workflow in a secure and cost-effective manner!

### Why do we need terramate ? <a name="why_terramate"></a>
We want to stay away from [Terralihts](https://masterpoint.io/updates/terralith-monolithic-terraform-architecture/). As Terraform offer no standard pattern on how to organize code efficiently, projects quickly sprawl out of control. The consequences are code complexity, long-running pipelines, large blast radius, drift, and poor governance.
Terramate CLI enables a new approach to eliminating the root cause of these consequences: using a modular and efficient approach called Terramate Stacks. A stack is a combination of infrastructure code, state and configuration, which can be nested to split state further.

### How should i use terramate ? <a name="how_terramate"></a>
To avoid locking ourselves (more than needed) to Terramate, we should only use it for what it is needed: **deployment orchestration**. It is important to keep our Terraform code versioned under Terraform native modules (centrally or locally) and only use Terramate for the deployment/environment layer. Please don't use Terramate's code generation feature for things that can be accomplished natively with modules and variables. The aim is to take full advantage of this stack orchestrator while still using Terraform in its raw format whenever possible.

### Terramate Commands <a name="commands_terramate"></a>
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

terramate experimental clone stacks/dev stacks/prod # 
```

## Standard File Structure <a name="file_structure"></a>
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
 ┗ 📜terramate.tm.hcl   ▪️ Main terramate configurations
```

## CLIOT <a name="CLIOT"></a>
🛠 To help following standards and speed recurrent tasks we develop a command line tool called **cliot**.

