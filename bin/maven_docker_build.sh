source "$HOME/.jenv/bin/jenv-init.sh"
jenv use java 1.8.0_71
mvn clean
rm -rf src/main/docker/lib
mvn dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=target/lib
mvn -U package -Pdocker  -DskipTests=true -s /etc/maven/settings.xml