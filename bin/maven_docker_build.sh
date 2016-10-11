mvn clean
rm -rf src/main/docker/lib
mvn dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=target/lib
mvn -U package -Pdocker  -DskipTests=true -s settings.xml