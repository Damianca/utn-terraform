#!/bin/bash

#  Actualiza el sistema y prepara Java
yum update -y
amazon-linux-extras enable corretto11
yum install -y java-11-amazon-corretto wget unzip

#  Descarga y extrae Kafka 3.8.0
cd /opt
wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz
tar -xzf kafka_2.13-3.8.0.tgz
ln -s kafka_2.13-3.8.0 kafka

#  Agrega Kafka al PATH para futuras sesiones
echo 'export KAFKA_HOME=/opt/kafka' >> /etc/profile
echo 'export PATH=$PATH:$KAFKA_HOME/bin' >> /etc/profile

#  Exporta las variables para el script actual
export KAFKA_HOME=/opt/kafka
export PATH=$PATH:$KAFKA_HOME/bin

#  Crea alias útil (opcional)
echo "alias kafka-brokers='echo \$BOOTSTRAP_BROKERS'" >> /etc/profile

# Crea script para listar tópicos usando TLS (SSL)
cat <<EOF > /usr/local/bin/kafka-list-topics
#!/bin/bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server "\$1" --command-config <(echo -e "security.protocol=SSL") --list
EOF

chmod +x /usr/local/bin/kafka-list-topics
