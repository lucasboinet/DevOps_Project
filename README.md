# Devops Project

This project will deploy a java app with jenkins, terraform & ansible

## Structure

* Composed with 3 pipeline :
    1. [Jenkins](jenkins/) The first one, get the java files from a repo and compile it to a .jar file
    2. [Terraform](terraform/) The second one, start an terraform aws instance
    3. [Ansible](ansible/) The third one start an ansible playbook in the terraform instance that will install java & deploy the app

## How to use it ?

* Clone the repo
* Go in the jenkins folder
* Start jenkins with `docker-compose up --build`
* Go to localhost
* And then start the CI pipeline : Git_Job