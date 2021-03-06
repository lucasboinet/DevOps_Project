#!groovy
println('------------------------------------------------------------------Import Job IaC/Terraform_Job')
def pipelineScript = new File('/var/jenkins_config/jobs/terraform-job-pipeline.groovy').getText("UTF-8")

pipelineJob('Iac/Terraform_Job') {
    description("Tasks linked to terraform instance")
    parameters {
        choice {
            name('INSTANCE_ACTION')
            choices(['apply', 'destroy'])
            description("Action a effectuer sur l'instance aws")
        }
    }
    definition {
        cps {
            script(pipelineScript)
            sandbox()
        }
    }
}