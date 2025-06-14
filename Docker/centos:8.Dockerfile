FROM quay.io/centos/centos:stream
ARG NOBUILD=0
LABEL EOL="31 Dec 2021"
LABEL DERIVEDFROM="RHEL 8 Public Upstream Development Branch"
RUN sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && dnf makecache \
    && dnf --assumeyes install epel-release \
    && dnf makecache \
    && dnf --assumeyes distribution-synchronization \
    && dnf --assumeyes install ansible git mlocate python3-dnf tree vim-enhanced
    #&& ln --force --symbolic /usr/bin/python3 /usr/bin/python
    #&& pip3 --quiet install packaging setuptools-rust

WORKDIR /root/source/ansible
COPY . ./
#  RUN ./mythtv.yml --limit=localhost --extra-vars='{"venv_active": true}' --extra-vars='{"use_old_roles": false}'
#
#  WORKDIR /root/source
#  RUN git clone https://github.com/MythTV/mythtv.git
#
#  # buld fails because FFmpeg can't find libiec61883 (even though it and
#  # libiec61883-devel are installed
#  WORKDIR /root/source/mythtv
#
#  RUN if [ "${NOBUILD}" -eq 1 ]; then \
#          echo "Not doing a build." ;\
#      else \
#          git checkout fixes/35 \
#          && cmake --preset qt5 \
#          && VIRTUAL_ENV=/usr/local/dist cmake --build build-qt5 ;\
#      fi
