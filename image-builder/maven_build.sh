mvn clean dependency:copy-dependencies -DincludeScope=runtime  -s settings-1.0.xml -DoutputDirectory=target/lib 
mvn -U package  -DskipTests=true -s settings-1.0.xml
