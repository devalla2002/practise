FROM tomcat:8
ARG url
RUN wget --user admin --password admin1234 $url
RUN mv *.war gameoflife.war
RUN cp *.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh" ,"run"]
