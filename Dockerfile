FROM ubuntu:12.04

# Install pre-requisites
RUN apt-get update && apt-get install -y bzip2 build-essential libc6-dev-i386 ia32-libs lib32z1-dev libncurses5 libncurses5-dev u-boot-tools vim squashfs-tools gettext git zip subversion bc pkg-config bison flex autoconf

# Add local files to the container
COPY toolchains /tmp/toolchains

# Run the install scripts for each version of the toolchain
WORKDIR "/tmp/toolchains/arm-hisiv100nptl-linux"
RUN chmod +x cross.install
RUN ./cross.install
WORKDIR "/tmp/toolchains/arm-hisiv200-linux"
RUN chmod +x cross.install
RUN ./cross.install
RUN rm -rf /tmp/toolchains

# Add toolchains to the PATH
ENV PATH $PATH:/opt/hisi-linux-nptl/arm-hisiv100-linux/bin
ENV PATH $PATH:/opt/hisi-linux/x86-arm/arm-hisiv200-linux/target/bin

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Clean up
RUN apt-get -y clean
