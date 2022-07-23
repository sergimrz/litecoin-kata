# litecoin-kata

On this kata are training the following concepts

## Dockerization
We dockerized the Litecoin 0.18.1 validating the binaries with PGP and running the application with a normal user. We also validated that this build is safe scanning the result image with anchore following some DevSecOps good practices. Some remarkable notes on this point are the next:
* We weren't able to run the release litecoin-0.18.1-x86_64-linux-gnu in a lightweight distribution as alpine so we used a debian to not fight with distributions incompatibilities.
* Also we found that the command "gpg --recv-key FE3348877809386C" specified in the litecoin PGP Instructions (https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt) returns timeout ocasionally so we copied manually the public key. This is not the best scenario as someone could compromise the key.

## Kubernetes 
Following this kata we also built a statefulset with resource limits and persistent volume claims. To do so, we created some resource definitions on the kubernetes/base/ folder adding some kustomize layer to be able to deploy slightly different resources on different environments.
To test this exercice we set up a local minikube environment and deployed manually the manifests with kustomize: kubectl apply -k kubernetes/overlays/dev (you can also deploy the resources in the kubernetes/base/ folder without kustomize).

## CI/CD
Finally we mixed up the first exercices creating a CI/CD pipeline with Jenkins.
Here we started three approaches for build the Jenkinsfile but only developed one of them to focus on other stuff:
* **ci/Jenkinsfile_full** contains a full abstracted pipeline with groovy using a function from a shared library: https://github.com/sergimrz/shared-library/blob/master/vars/pipeline.groovy. This pipeline allow the delivery teams to focus on the development as all the ci process is abstracted, but also reduces their possibilities to contribute on the release process.
* **ci/Jenkinsfile_raw** is the most simple pipeline where we just set the raw sh commands there to get our purpose. This allows to the delivery team to fully contribute in the release process and take control over it. We will work with this methond on the kata as we don't need for abstractions right now.
* **ci/Jenkinsfile_funcs** contains a Jenkinsfile that is mixed. It have the jenkins pipeline squeleton but it have functions abstracted with groovy which purpose is reduce the duplication of code and share common ideas across the delivery teams.

### Actions
This pipeline perform the following actions:
* Build the docker image with a dev version and pass a security scan with Anchore and storing the results in an artifact.
* If success, print the kubernetes manifests with the new dev image applied. !! We don't have the deploy because we couldn't link the Jenkins server to the local minikube
* Print a message saying that now comes the step to perform the tests to dev.
* Promote the image removing a dev identier in the image.
* Print the kubernetes manifests with the live image applied. Again we don't have the minikube connected so we are not doing the deploy

![Untitled Diagram drawio](https://user-images.githubusercontent.com/18615945/180611849-57f1450e-746f-41cd-9a12-240862ab9f71.png)
####
![Screenshot from 2022-07-23 17-33-56](https://user-images.githubusercontent.com/18615945/180611922-8665759d-213d-4d82-a5cb-73a9b1cad71b.png)
