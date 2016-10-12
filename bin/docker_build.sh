mvn clean
mvn dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=target/lib
mvn -U package  -DskipTests=true -s settings-1.0.xml
