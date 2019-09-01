FROM centos:7 as builder
LABEL maintainer=snoopotic@gmail.com

ARG GITVERSION="2.23.0"

ADD SPECS/git.spec.in /tmp/
ADD SOURCES /home/rpm/rpmbuild/SOURCES/
ADD bin/start.sh /start.sh

RUN yum -y install epel-release \
    && yum -y upgrade \
    && yum -y install rpm-build redhat-rpm-config rpmdevtools \
       yum-utils bash-completion tar gcc make sudo asciidoc cvs \
       cvsps desktop-file-utils emacs expat-devel gettext highlight \
       httpd libcurl-devel libsecret-devel mod_dav_svn openssl-devel \
       pcre2-devel perl-CGI perl-DBD-SQLite perl-Digest-MD5 perl-Error \
       perl-HTTP-Date perl-IO-Tty perl-MailTools perl-Test-Harness \
       perl-Test-Simple python-devel subversion subversion-perl tcl \
       time tk xmlto zlib-devel jq \
    && sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers \
    && mkdir -p /home/rpm/rpmbuild/{BUILD,SRPMS,SPECS,RPMS/noarch} \
    && sed s/@@GITVERSION@@/${GITVERSION}/g /tmp/git.spec.in > /home/rpm/rpmbuild/SPECS/git.spec \
    && yum-builddep -y /home/rpm/rpmbuild/SPECS/git.spec \
    && useradd -s /bin/bash -G adm,wheel -m rpm \
    && chmod 755 /start.sh \
    && chown -R rpm: /home/rpm 

WORKDIR /home/rpm
USER rpm
RUN /start.sh

FROM docker.bintray.io/jfrog/jfrog-cli-go:latest as copymaster
LABEL maintainer=snoopotic@gmail.com

ARG GITVERSION="2.23.0"
ARG BTUSER
ARG BTKEY
ARG BTORG
ARG BTDEST="snoopotic/git-centos/7/${GITVERSION}"

RUN mkdir /rpmfiles
COPY --from=builder /home/rpm/rpmbuild/RPMS/ /rpmfiles/
ENV JFROG_CLI_OFFER_CONFIG false
ENV CI true
# jfrog bt u --user $(BTUSER) --key ${BTKEY} /rpmfiles/ snoopotic/git-centos/ [target path]
#CMD jfrog bt u --user ${BTUSER} --key ${BTKEY} "/rpmfiles/*" ${BTDEST}
#RUN echo "VERSION: ${GITVERSION} jfrog bt u --user ${BTUSER} --key ${BTKEY} /rpmfiles/ ${BTDEST}"
RUN jfrog bt u --user ${BTUSER} --key ${BTKEY} --publish --vcs-url "https://github.com/snoopotic/git-rpm-builder.git" --pub-dn "/rpmfiles/*" ${BTDEST}

