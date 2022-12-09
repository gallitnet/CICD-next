FROM gcr.io/labs-370214/env:1.0.1
RUN mkdir /files 
COPY ./ /files
COPY entrypoint.sh /

COPY deployment_files.sh /files/
RUN chmod +x /entrypoint.sh
RUN chmod +x /files/deployment_files.sh

ENTRYPOINT [ "/entrypoint.sh" ]