FROM ubuntu:14.04

MAINTAINER sdearn<540797670@qq.com>

RUN sudo rm -f /etc/localtime \
    && sudo ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN sudo apt-get update --fix-missing
RUN sudo apt-get install -y wget \
    && sudo apt-get install -y zip \
    && sudo apt-get install -y vim \
    && sudo apt-get install -y xvfb

RUN sudo apt-get update --fix-missing
RUN sudo apt-get install -y subversion

ADD file/ work/

WORKDIR /work

RUN echo "export JAVA_HOME=/work/jdk1.8.0_231">>/etc/profile
RUN echo "export JRE_HOME=$JAVA_HOME/jre">>/etc/profile
RUN echo "export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH">>/etc/profile
RUN echo "export JAVA_PATH=$JAVA_HOME/bin:$JRE_HOME/bin">>/etc/profile
RUN echo "export PATH=$PATH:$JAVA_PATH">>/etc/profile

RUN mkdir -p /root/.m2/ && mv settings.xml /root/.m2/
    
#RUN mv java.security /work/jdk1.8.0_231/jre/lib/security/

RUN ["chmod", "+x", "/work/docker-entrypoint.sh"]

RUN unzip apache-tomcat*.zip && rm -f apache-tomcat*.zip && mv apache-tomcat* tomcat

RUN unzip apache-maven*.zip && rm -f apache-maven*.zip && mv apache-maven* maven

RUN echo "export M2_HOME=/work/maven">>/etc/profile
RUN echo "export PATH=$M2_HOME/bin:$PATH">>/etc/profile


WORKDIR /work

EXPOSE 8080

ENTRYPOINT ["/work/docker-entrypoint.sh"]
