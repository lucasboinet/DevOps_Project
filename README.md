# Devops Project

This project will deploy a java app with jenkins, terraform & ansible

## Structure

* [Jenkins](jenkins/) -> Composed with 3 pipeline :
    - The first one, get the java files from a repo and compile it to a .jar file
    - The second one, start an terraform aws instance
    - The third one start an ansible playbook in the terraform instance that will install java & deploy the app

* [Terraform](terraform/) -> All necessary files to start the aws instance

* [Ansible](ansible/) -> All necessary files to run the the ansible playbook and deploy java app

## How to use it ?

* Clone the repo
* Go in the jenkins folder
* Start jenkins with `docker-compose up --build`
* Go to localhost in your browser
* And then start the CI pipeline : Git_Job