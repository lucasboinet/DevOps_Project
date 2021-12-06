#!groovy
println('------------------------------------------------------------------Import Job CI/Git_Job')
def pipelineScript = new File('/var/jenkins_config/jobs/git-job-pipeline.groovy').getText("UTF-8")

pipelineJob('CI/Git_Job') {
    description("Tasks linked to git repository")
    parameters {
        stringParam {
            name('BRANCH')
            defaultValue('master')
            description("Branch à cloner depuis le repository")
            trim(true)
        }
        booleanParam {
            name('SKIP_TESTS')
            defaultValue(false)
            description("Ne pas lancer les tests")
        }
        choice {
            name('VERSION_TYPE')
            choices(['SNAPSHOT', 'RELEASE'])
            description("Type de version")
        }
        stringParam {
            name('VERSION')
            description('Nom de la version')
            trim(true)
        }
    }
    definition {
        cps {
            script(pipelineScript)
            sandbox()
        }
    }
}