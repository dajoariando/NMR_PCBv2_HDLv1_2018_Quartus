#!/bin/bash

quartus_cpf -c ../QUARTUS-SoC/output_files/DE1_SOC_Linux_FB.sof ./soc_system.rbf
scp ./soc_system.rbf root@192.168.100.1:/media/root/5459-A1D62/soc_system.rbf
#scp ./soc_system.rbf root@dajo-de1soc:/media/root/5459-A1D63/soc_system.rbf
