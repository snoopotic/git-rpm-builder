# git-rpm-builder
This is a docker based RPM builder for GIT that also deploys to Bintray.

More infos soon. You will be enabled to build this yourself and then deploy the rpms to your own rpm repository or something else. I dunno. My first goal is achieved: I want git-rpm files in a rpm-repo to install most actual git via yum on most machines I/we run \o/.


Use the built rpms as follows in your /etc/yum.repos.d/git.repo
```
#bintray-snoopotic-git-centos 
[bintray-snoopotic-git-centos]
name=bintray-snoopotic-git-centos
baseurl=https://dl.bintray.com/snoopotic/git-centos
gpgcheck=1
gpgkey=https://bintray.com/user/downloadSubjectPublicKey?username=snoopotic
repo_gpgcheck=1
enabled=1
```

