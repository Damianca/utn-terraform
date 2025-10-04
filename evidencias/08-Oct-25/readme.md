ejemplo una evidencia

Destrui todo

dcanovas@dcanovas:~/Documentos/per/training/tf/ejercicios/c3/e1$ terraform destroy
Acquiring state lock. This may take a few moments...
aws_vpc.ejemplo_vpc: Refreshing state... [id=vpc-0194f42fac67ae8a0]
aws_internet_gateway.ejemplo_igw: Refreshing state... [id=igw-068c9adbc43b2d4de]
aws_subnet.public_subnet: Refreshing state... [id=subnet-0e45f1f22b4645509]
aws_security_group.sg_acceso_restringido: Refreshing state... [id=sg-01a9490ab106835d2]
aws_security_group.sg_acceso_total: Refreshing state... [id=sg-0f74628663f0e3ae5]
aws_route_table.public_rt: Refreshing state... [id=rtb-0163f37acc8099ebf]
aws_instance.instancia_acceso_restringido: Refreshing state... [id=i-0388918608787061a]
aws_route_table_association.public_assoc: Refreshing state... [id=rtbassoc-05cdddbd1d1c6fe4e]
aws_instance.instancia_acceso_total: Refreshing state... [id=i-0dc9b6c4ab6948c77]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.instancia_acceso_restringido will be destroyed
  - resource "aws_instance" "instancia_acceso_restringido" {
      - ami                                  = "ami-052064a798f08f0d3" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:025066285535:instance/i-0388918608787061a" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1a" -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - force_destroy                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0388918608787061a" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "damiankp" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0395ebccd931eb2ed" -> null
      - private_dns                          = "ip-10-0-1-221.ec2.internal" -> null
      - private_ip                           = "10.0.1.221" -> null
      - public_dns                           = "ec2-18-205-27-252.compute-1.amazonaws.com" -> null
      - public_ip                            = "18.205.27.252" -> null
      - region                               = "us-east-1" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0e45f1f22b4645509" -> null
      - tags                                 = {
          - "Name" = "EC2-Sin-SSH-ni-Ping"
        } -> null
      - tags_all                             = {
          - "Name" = "EC2-Sin-SSH-ni-Ping"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-01a9490ab106835d2",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - primary_network_interface {
          - delete_on_termination = true -> null
          - network_interface_id  = "eni-0395ebccd931eb2ed" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-084867ab7fd0d6b42" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

  # aws_instance.instancia_acceso_total will be destroyed
  - resource "aws_instance" "instancia_acceso_total" {
      - ami                                  = "ami-052064a798f08f0d3" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:025066285535:instance/i-0dc9b6c4ab6948c77" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1a" -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - force_destroy                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0dc9b6c4ab6948c77" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "damiankp" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-06fff3ccfea267753" -> null
      - private_dns                          = "ip-10-0-1-27.ec2.internal" -> null
      - private_ip                           = "10.0.1.27" -> null
      - public_dns                           = "ec2-35-175-153-222.compute-1.amazonaws.com" -> null
      - public_ip                            = "35.175.153.222" -> null
      - region                               = "us-east-1" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0e45f1f22b4645509" -> null
      - tags                                 = {
          - "Name" = "EC2-Con-SSH-y-Ping"
        } -> null
      - tags_all                             = {
          - "Name" = "EC2-Con-SSH-y-Ping"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0f74628663f0e3ae5",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - primary_network_interface {
          - delete_on_termination = true -> null
          - network_interface_id  = "eni-06fff3ccfea267753" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0907d0c7f0adaffbb" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

  # aws_internet_gateway.ejemplo_igw will be destroyed
  - resource "aws_internet_gateway" "ejemplo_igw" {
      - arn      = "arn:aws:ec2:us-east-1:025066285535:internet-gateway/igw-068c9adbc43b2d4de" -> null
      - id       = "igw-068c9adbc43b2d4de" -> null
      - owner_id = "025066285535" -> null
      - region   = "us-east-1" -> null
      - tags     = {
          - "Name" = "IGW-Ejemplo"
        } -> null
      - tags_all = {
          - "Name" = "IGW-Ejemplo"
        } -> null
      - vpc_id   = "vpc-0194f42fac67ae8a0" -> null
    }

  # aws_route_table.public_rt will be destroyed
  - resource "aws_route_table" "public_rt" {
      - arn              = "arn:aws:ec2:us-east-1:025066285535:route-table/rtb-0163f37acc8099ebf" -> null
      - id               = "rtb-0163f37acc8099ebf" -> null
      - owner_id         = "025066285535" -> null
      - propagating_vgws = [] -> null
      - region           = "us-east-1" -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - gateway_id                 = "igw-068c9adbc43b2d4de"
                # (11 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "Name" = "Ruta-Publica"
        } -> null
      - tags_all         = {
          - "Name" = "Ruta-Publica"
        } -> null
      - vpc_id           = "vpc-0194f42fac67ae8a0" -> null
    }

  # aws_route_table_association.public_assoc will be destroyed
  - resource "aws_route_table_association" "public_assoc" {
      - id             = "rtbassoc-05cdddbd1d1c6fe4e" -> null
      - region         = "us-east-1" -> null
      - route_table_id = "rtb-0163f37acc8099ebf" -> null
      - subnet_id      = "subnet-0e45f1f22b4645509" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_security_group.sg_acceso_restringido will be destroyed
  - resource "aws_security_group" "sg_acceso_restringido" {
      - arn                    = "arn:aws:ec2:us-east-1:025066285535:security-group/sg-01a9490ab106835d2" -> null
      - description            = "Bloquea todo el trafico de entrada incluido SSH y PING." -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - id                     = "sg-01a9490ab106835d2" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - name                   = "sg_acceso_restringido" -> null
      - owner_id               = "025066285535" -> null
      - region                 = "us-east-1" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {} -> null
      - tags_all               = {} -> null
      - vpc_id                 = "vpc-0194f42fac67ae8a0" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_security_group.sg_acceso_total will be destroyed
  - resource "aws_security_group" "sg_acceso_total" {
      - arn                    = "arn:aws:ec2:us-east-1:025066285535:security-group/sg-0f74628663f0e3ae5" -> null
      - description            = "Permite SSH 22 y PING ICMP desde cualquier lugar." -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - id                     = "sg-0f74628663f0e3ae5" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "ICMP (Ping)"
              - from_port        = -1
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "icmp"
              - security_groups  = []
              - self             = false
              - to_port          = -1
            },
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "SSH Access"
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
            },
        ] -> null
      - name                   = "sg_acceso_total" -> null
      - owner_id               = "025066285535" -> null
      - region                 = "us-east-1" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {} -> null
      - tags_all               = {} -> null
      - vpc_id                 = "vpc-0194f42fac67ae8a0" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_subnet.public_subnet will be destroyed
  - resource "aws_subnet" "public_subnet" {
      - arn                                            = "arn:aws:ec2:us-east-1:025066285535:subnet/subnet-0e45f1f22b4645509" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1a" -> null
      - availability_zone_id                           = "use1-az2" -> null
      - cidr_block                                     = "10.0.1.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0e45f1f22b4645509" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = true -> null
      - owner_id                                       = "025066285535" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "us-east-1" -> null
      - tags                                           = {
          - "Name" = "Subnet-Publica"
        } -> null
      - tags_all                                       = {
          - "Name" = "Subnet-Publica"
        } -> null
      - vpc_id                                         = "vpc-0194f42fac67ae8a0" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_vpc.ejemplo_vpc will be destroyed
  - resource "aws_vpc" "ejemplo_vpc" {
      - arn                                  = "arn:aws:ec2:us-east-1:025066285535:vpc/vpc-0194f42fac67ae8a0" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-0891928f717f8f61c" -> null
      - default_route_table_id               = "rtb-032073d4d8672ac21" -> null
      - default_security_group_id            = "sg-039130724c8772acd" -> null
      - dhcp_options_id                      = "dopt-01f9351d4e5ab7a6b" -> null
      - enable_dns_hostnames                 = true -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-0194f42fac67ae8a0" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-032073d4d8672ac21" -> null
      - owner_id                             = "025066285535" -> null
      - region                               = "us-east-1" -> null
      - tags                                 = {
          - "Name" = "VPC-Ejemplo-Publica-Damian"
        } -> null
      - tags_all                             = {
          - "Name" = "VPC-Ejemplo-Publica-Damian"
        } -> null
        # (4 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 9 to destroy.

Changes to Outputs:
  - ip_instancia_bloqueada = "18.205.27.252" -> null
  - ip_instancia_ssh_ping  = "35.175.153.222" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_route_table_association.public_assoc: Destroying... [id=rtbassoc-05cdddbd1d1c6fe4e]
aws_instance.instancia_acceso_restringido: Destroying... [id=i-0388918608787061a]
aws_instance.instancia_acceso_total: Destroying... [id=i-0dc9b6c4ab6948c77]
aws_route_table_association.public_assoc: Destruction complete after 2s
aws_route_table.public_rt: Destroying... [id=rtb-0163f37acc8099ebf]
aws_route_table.public_rt: Destruction complete after 1s
aws_internet_gateway.ejemplo_igw: Destroying... [id=igw-068c9adbc43b2d4de]
aws_instance.instancia_acceso_total: Still destroying... [id=i-0dc9b6c4ab6948c77, 00m10s elapsed]
aws_instance.instancia_acceso_restringido: Still destroying... [id=i-0388918608787061a, 00m10s elapsed]
aws_internet_gateway.ejemplo_igw: Still destroying... [id=igw-068c9adbc43b2d4de, 00m10s elapsed]
aws_instance.instancia_acceso_total: Still destroying... [id=i-0dc9b6c4ab6948c77, 00m20s elapsed]
aws_instance.instancia_acceso_restringido: Still destroying... [id=i-0388918608787061a, 00m20s elapsed]
aws_internet_gateway.ejemplo_igw: Still destroying... [id=igw-068c9adbc43b2d4de, 00m20s elapsed]
aws_internet_gateway.ejemplo_igw: Destruction complete after 21s
aws_instance.instancia_acceso_restringido: Still destroying... [id=i-0388918608787061a, 00m30s elapsed]
aws_instance.instancia_acceso_total: Still destroying... [id=i-0dc9b6c4ab6948c77, 00m30s elapsed]
aws_instance.instancia_acceso_total: Destruction complete after 35s
aws_security_group.sg_acceso_total: Destroying... [id=sg-0f74628663f0e3ae5]
aws_instance.instancia_acceso_restringido: Destruction complete after 36s
aws_security_group.sg_acceso_restringido: Destroying... [id=sg-01a9490ab106835d2]
aws_subnet.public_subnet: Destroying... [id=subnet-0e45f1f22b4645509]
aws_security_group.sg_acceso_total: Destruction complete after 1s
aws_security_group.sg_acceso_restringido: Destruction complete after 1s
aws_subnet.public_subnet: Still destroying... [id=subnet-0e45f1f22b4645509, 00m10s elapsed]
aws_subnet.public_subnet: Still destroying... [id=subnet-0e45f1f22b4645509, 00m20s elapsed]
aws_subnet.public_subnet: Destruction complete after 22s
aws_vpc.ejemplo_vpc: Destroying... [id=vpc-0194f42fac67ae8a0]
aws_vpc.ejemplo_vpc: Destruction complete after 2s
Releasing state lock. This may take a few moments...

Destroy complete! Resources: 9 destroyed.
dcanovas@dcanovas:~/Documentos/per/training/tf/ejercicios/c3/e1$ 
