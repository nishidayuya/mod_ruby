FROM centos:centos6

RUN yum -y upgrade && \
  yum install -y \
    apr \
    apr-devel \
    apr-util \
    apr-util-devel \
    autoconf \
    automake \
    bison \
    bzip2 \
    gcc-c++ \
    httpd \
    httpd-devel \
    iconv-devel \
    libffi-devel \
    libtool \
    libyaml-devel \
    make \
    openssl-devel \
    patch \
    readline \
    readline-devel \
    sqlite-devel \
    zlib \
    zlib-devel

# Install rvm
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L get.rvm.io | bash -s stable

# Change the shell to load RVM from profile
SHELL ["/bin/bash", "-l", "-c"]

# RVM requirements
RUN rvm requirements

# ruby 2.3.3
RUN rvm install ruby-2.3.3

WORKDIR /usr/src/mod_ruby
COPY . /usr/src/mod_ruby

RUN ruby configure.rb \
    --with-apr-includes=/usr/include/apr-1 \
    --with-apxs=/usr/sbin/apxs \
    # Force mod_ruby.so to statically link ruby interpreter
    && sed 's/LIBRUBYARG = $(LIBRUBYARG_SHARED)/LIBRUBYARG = $(LIBRUBYARG_STATIC)/' -i Makefile \
    && make




