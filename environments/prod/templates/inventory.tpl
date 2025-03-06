[master]
%{ for index, master in master_nodes ~}
${master.hostname} ansible_host=${master.ip_address}
%{ endfor ~}

[worker]
%{ for index, worker in worker_nodes ~}
${worker.hostname} ansible_host=${worker.ip_address}
%{ endfor ~}

[k3s_cluster:children]
master
worker
