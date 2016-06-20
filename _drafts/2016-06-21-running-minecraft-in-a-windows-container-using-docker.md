nicholasdille/javaruntime:8u91

docker run -d --name minecraft -v C:\Users\Administrator\Documents\minecraft:c:\minecraft -p 25565:25565 -p 25575:25575 -w c:\minecraft nicholasdille/javaruntime:8u91 'C:\Program Files\Java\jre1.8.0_91\bin\java.exe' -jar spigot-1.9.2.jar -W .\worlds

docker logs -f minecraft
