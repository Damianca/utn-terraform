
# Realizar el apply

# Conectarse a la instancia ec2 (comando listo en el output)


# Agregar los broker como variable de entorno (tomarlos desde el output)
BROKERS="b-1.maltamirandamskcluste.flz00t.c11.kafka.us-east-1.amazonaws.com:9094,b-2.maltamirandamskcluste.flz00t.c11.kafka.us-east-1.amazonaws.com:9094"
  

# Crear un topico de prueba (prueba-topic-max en el nombre del topico)

/opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server $BROKERS \
  --command-config <(echo -e "security.protocol=SSL") \
  --create \
  --topic prueba-topic-max \
  --partitions 3 \
  --replication-factor 2




# listar topicos
/opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server $BROKERS \
  --command-config <(echo -e "security.protocol=SSL") \
  --list


# Salir de la intancia

# Realizar el destroy
