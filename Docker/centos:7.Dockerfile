FROM centos:7
LABEL CODENAME="N/A"
LABEL EOL="2024-06-30"
LABEL STATUS="Builds through mythplugins!"
RUN yum install --assumeyes epel-release
RUN yum install --assumeyes ansible git vim-enhanced

WORKDIR /root/source/ansible
COPY . ./
RUN ./mythtv.yml --limit=localhost

WORKDIR /root/source
RUN git clone https://github.com/MythTV/mythtv.git

WORKDIR /root/source/mythtv
RUN git checkout fixes/35
RUN cmake --preset qt5
RUN cmake --build build-qt5
