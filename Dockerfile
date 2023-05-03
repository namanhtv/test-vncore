FROM python:3.7-slim

RUN mkdir /app
WORKDIR /app

# Install java
RUN mkdir -p /usr/share/man/man1
RUN apt update
RUN apt install -y default-jre

COPY VnCoreNLP-1.1.1.jar .
COPY models /app/models

RUN pip3 install vncorenlp

CMD ["vncorenlp", "-Xmx2g", "./VnCoreNLP-1.1.1.jar", "-i", "0.0.0.0", "-p", "9000", "-a", "wseg,pos,ner,parse"]
EXPOSE 9000
