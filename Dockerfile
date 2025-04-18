# Use the official Tomcat base image
FROM tomcat:9.0

# Remove the default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into the Tomcat webapps directory
COPY target/jpetstore.war /usr/local/tomcat/webapps/jpetstore.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
