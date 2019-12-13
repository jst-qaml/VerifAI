FROM ubuntu:18.04
RUN apt update -qq
RUN apt install -y axel wget curl git python3.7 python3.7-dev python3.7-distutils software-properties-common
RUN axel -q -n 8 https://github.com/cyberbotics/webots/releases/download/R2019b-rev1/webots_2019b-rev1_amd64.deb
RUN apt install -y ./webots_2019b-rev1_amd64.deb
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.7 get-pip.py
RUN apt install -y libxkbcommon-x11-0 sudo
ENV QT_DEBUG_PLUGINS 1
RUN apt install -y libgl1-mesa-glx
ENV LIBGL_ALWAYS_SOFTWARE 1
 
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN pip install --upgrade tensorflow-gpu
RUN git clone https://github.com/BerkeleyLearnVerify/VerifAI.git
RUN cd /VerifAI ; pip install .

# Change user
RUN useradd -m ubuntu
RUN echo "ubuntu ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -G sudo ubuntu
USER ubuntu
WORKDIR /home/ubuntu

#xauth list
#xauth nextract - "Your DISPLAY environment" > xauth.info

COPY xauth.info .
RUN xauth nmerge - < xauth.info

#Try this command.
#> docker run --gpus all --net=host -e DISPLAY="$DISPLAY" -it verifai bash
