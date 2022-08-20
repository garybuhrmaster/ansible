FROM ubuntu:20.04 
LABEL CODELAME="Focal Fossa" EOL="25.04"
RUN apt-get update && apt-get install --yes ansible git mlocate python3-apt vim 
 
# This only works with the devel/2022 branch!!!
WORKDIR /root/source/ansible
COPY ansible.cfg hosts.yml mythtv.yml ./
COPY roles ./roles/
RUN ./mythtv.yml --limit=localhost 

WORKDIR /root/source 
RUN git clone https://github.com/MythTV/mythtv.git 
WORKDIR /root/source/mythtv/mythtv 
RUN git checkout fixes/31 

RUN ./configure \
    --enable-libx264 \
    --enable-libmp3lame \
    --enable-nonfree \
    --enable-proc-opt 
# ADJUST THE NEXT LINE. Don't use $(nproc)
RUN make --jobs=4
RUN make install

WORKDIR /root/source/mythtv/mythplugins 
RUN ./configure 
# ADJUST THE NEXT LINE. Don't use $(nproc)
RUN make --jobs=8
RUN make install
