
################################################################
#Creating the AKS Cluster with RBAC Enabled and AAD integration

resource "azurerm_kubernetes_cluster" "AKS" {

  lifecycle {
    ignore_changes = [
      #Ignore change for node count since it is autoscaling
      default_node_pool[0].node_count,
      default_node_pool[0].orchestrator_version,
      #Ignore change for some default node pool block
      default_node_pool[0].kubelet_config,
      default_node_pool[0].linux_os_config,
      #Ignore change on kubernetes version.
      kubernetes_version,
      linux_profile,
      network_profile,
      key_management_service[0].key_vault_key_id,
      microsoft_defender


    ]
  }

  name                = local.AKSClusterName
  location            = var.AKSLocation
  resource_group_name = var.AKSRGName

  default_node_pool {
    name                          = substr(local.AKSDefaultNodePoolName, 0, 12)
    vm_size                       = var.AKSNodeInstanceType
    zones                         = var.AKSLBSku == "Standard" ? var.AKSAZ : null
    auto_scaling_enabled          = var.EnableAKSAutoScale
    capacity_reservation_group_id = var.AKSCapacityReservationGroupId
    host_encryption_enabled       = var.EnableHostEncryption
    node_public_ip_enabled        = var.EnableNodePublicIP
    node_public_ip_prefix_id      = var.NodePublicIpPrefixId
    fips_enabled                  = var.NodePoolWithFIPSEnabled
    max_pods                      = var.AKSMaxPods
    node_labels                   = var.AKSNodeLabels
    os_disk_size_gb               = var.AKSNodeOSDiskSize
    os_disk_type                  = var.AKSNodeOSDiskType
    vnet_subnet_id                = var.AKSSubnetId
    max_count                     = var.MaxAutoScaleCount
    min_count                     = var.MinAutoScaleCount
    node_count                    = var.AKSNodeCount
    orchestrator_version          = var.KubeVersion
    pod_subnet_id                 = var.AKSNodePodSubnetId
    ultra_ssd_enabled             = var.AKSNodeUltraSSDEnabled
    gpu_instance                  = var.GPUInstance
    host_group_id                 = var.HostGroupId

    kubelet_config {

      allowed_unsafe_sysctls    = var.KubeletAllowedUnsafeSysctls
      container_log_max_line    = var.KubeletContainerLogMaxLine
      container_log_max_size_mb = var.KubeletContainerLogMaxSize
      cpu_cfs_quota_enabled     = var.KubeletCpuCfsQuotaEnabled
      cpu_cfs_quota_period      = var.KubeletCpuCfsQuotaPeriod
      cpu_manager_policy        = var.KubeletCpuManagerPolicy
      image_gc_high_threshold   = var.KubeletImageGcHighThreshold
      image_gc_low_threshold    = var.KubeletImageGcLowThreshold
      pod_max_pid               = var.KubeletPodMaxPid
      topology_manager_policy   = var.KubeletTopologyManagerPolicy

    }

    kubelet_disk_type = var.KubeletDiskType
    linux_os_config {

      swap_file_size_mb             = var.LinuxOSConfigSwapFileSize
      transparent_huge_page_defrag  = var.LinuxOSConfigTransparentHugePageDefrag
      transparent_huge_page_enabled = var.LinuxOSConfigTransparentHugePageEnabled
      sysctl_config {
        fs_aio_max_nr                      = var.SysCtlFsAioMaxNr
        fs_file_max                        = var.SysCtlFsFileMax
        fs_inotify_max_user_watches        = var.SysCtlFsInotifyMaxUserWatches
        fs_nr_open                         = var.SysCtlFsNrOpen
        kernel_threads_max                 = var.SysCtlKernelThreadsMax
        net_core_netdev_max_backlog        = var.SysCtlNetCoredevMaxBacklog
        net_core_optmem_max                = var.SysCtlNetCoreOptmemMax
        net_core_rmem_default              = var.SysCtlNetCoreRmemDefault
        net_core_rmem_max                  = var.SysCtlNetCoreRmemMax
        net_core_somaxconn                 = var.SysCtlNetCoreSomaxconn
        net_core_wmem_default              = var.SysCtlNetCoreWmemDefault
        net_core_wmem_max                  = var.SysCtlNetCoreWmemMax
        net_ipv4_ip_local_port_range_max   = var.SysCtlNetIpv4IpLocalPortRangeMax
        net_ipv4_ip_local_port_range_min   = var.SysCtlNetIpv4IpLocalPortRangeMin
        net_ipv4_neigh_default_gc_thresh1  = var.SysCtlNetIpv4NeighDefaultGcThreshold1
        net_ipv4_neigh_default_gc_thresh2  = var.SysCtlNetIpv4NeighDefaultGcThreshold2
        net_ipv4_neigh_default_gc_thresh3  = var.SysCtlNetIpv4NeighDefaultGcThreshold3
        net_ipv4_tcp_fin_timeout           = var.SysCtlNetIpv4NTcpFinTimeOut
        net_ipv4_tcp_keepalive_intvl       = var.SysCtlNetIpv4NTcpKeepAliveIntvl
        net_ipv4_tcp_keepalive_probes      = var.SysCtlNetIpv4NTcpKeepAliveProbes
        net_ipv4_tcp_keepalive_time        = var.SysCtlNetIpv4NTcpKeepAliveTime
        net_ipv4_tcp_max_syn_backlog       = var.SysCtlNetIpv4NTcpMaxSynBacklog
        net_ipv4_tcp_max_tw_buckets        = var.SysCtlNetIpv4NTcpMaxTwBuckets
        net_ipv4_tcp_tw_reuse              = var.SysCtlNetIpv4NTcpMaxTwReuse
        net_netfilter_nf_conntrack_buckets = var.SysCtlNetfilterNfConntrackBuckets
        net_netfilter_nf_conntrack_max     = var.SysCtlNetfilterNfConntrackMax
        vm_max_map_count                   = var.SysCtlVmMaxMapCount
        vm_swappiness                      = var.SysCtlVmSwapiness
        vm_vfs_cache_pressure              = var.SysCtlVmVfsCachePressure
      }
    }

    only_critical_addons_enabled = var.TaintCriticalAddonsEnabled

    node_network_profile {

      application_security_group_ids = local.NodePoolAsgList
      dynamic "allowed_host_ports" {
        for_each = var.NodePoolAllowedPorts

        content {
          port_start = allowed_host_ports.PortStart
          port_end   = allowed_host_ports.PortEnd
        }
      }

    }

    upgrade_settings {

      max_surge                     = var.AKSUpgradeMaxSurge
      drain_timeout_in_minutes      = var.AKSUpgradeDrainTimeOut
      node_soak_duration_in_minutes = var.AKSUpgradeNodeSoakDuration


    }


    tags = local.Tags

  }

  dns_prefix                          = local.IsBYOPrivateDNSZone ? null : local.DNSPrefix
  dns_prefix_private_cluster          = var.IsAKSPrivate && local.IsBYOPrivateDNSZone ? local.DNSPrefix : null
  node_resource_group                 = var.UseAKSNodeRGDefaultName ? local.DefaultNodeRGName : local.CustomNodeRGName
  private_cluster_enabled             = var.IsAKSPrivate
  private_dns_zone_id                 = local.PrivateDNSZoneId
  private_cluster_public_fqdn_enabled = local.PrivateClusterPublicFqdn
  local_account_disabled              = var.LocalAccountDisabled

  automatic_upgrade_channel = var.AutoUpgradeChannelConfig


  #api_server_authorized_ip_ranges = var.APIAccessList

  dynamic "api_server_access_profile" {

    for_each = var.ApiAllowedIps != [] ? ["fake"] : []

    content {

      authorized_ip_ranges = var.ApiAllowedIps
      #subnet_id                = var.ApiSubnetId
      #vnet_integration_enabled = var.EnableApiVnetIntegration      
    }

  }


  auto_scaler_profile {

    balance_similar_node_groups      = var.AutoScaleProfilBalanceSimilarNdGP
    expander                         = var.AutoScaleProfilExpander
    max_graceful_termination_sec     = var.AutoScaleProfilMaxGracefullTerm
    max_node_provisioning_time       = var.AutoscaleProfilMaxNodeProvTime
    max_unready_nodes                = var.AutoscaleProfilMaxUnreadyNodes
    max_unready_percentage           = var.AutoscaleProfilMaxUnreadyPercentage
    new_pod_scale_up_delay           = var.AutoscaleProfilNewPodScaleUpDelay
    scale_down_delay_after_add       = var.AutoScaleProfilScaleDownAfterAdd
    scale_down_delay_after_delete    = var.AutoScaleProfilScaleDownAfterDelete
    scale_down_delay_after_failure   = var.AutoScaleProfilScaleDownAfterFail
    scan_interval                    = var.AutoScaleProfilScanInterval
    scale_down_unneeded              = var.AutoScaleProfilScaleDownUnneeded
    scale_down_unready               = var.AutoScaleProfilScaleDownUnready
    scale_down_utilization_threshold = var.AutoScaleProfilScaleDownUtilThreshold
    empty_bulk_delete_max            = var.AutoscaleProfilEmptyBulkDeleteMax
    skip_nodes_with_local_storage    = var.AutoscaleProfilSkipNodesWLocalStorage
    skip_nodes_with_system_pods      = var.AutoscaleProfilSkipNodeWithSystemPods

  }



  disk_encryption_set_id = var.AKSDiskEncryptionId

  oidc_issuer_enabled = var.IsOIDCIssuerEnabled

  workload_identity_enabled = var.IsWorkloadIdentityEnabled

  run_command_enabled = var.IsRunCommandEnabled

  identity {
    type         = var.AKSIdentityType
    identity_ids = var.UAIIds
  }

  kubernetes_version = var.KubeVersion

  dynamic "kubelet_identity" {

    for_each = var.IsKubeletUsingUAI ? ["fake"] : []

    content {
      client_id                 = var.KubeletClientId
      object_id                 = var.KubeletObjectId
      user_assigned_identity_id = var.KubeletUAIId
    }

  }

  dynamic "key_management_service" {

    for_each = var.IsAKSKMSEnabled ? ["fake"] : []

    content {
      key_vault_key_id         = var.KmsKeyVaultKeyId
      key_vault_network_access = var.KmsKeyvaultNtwAccess
    }

  }


  linux_profile {
    admin_username = var.AKSAdminName

    ssh_key {
      key_data = var.PublicSSHKey
    }
  }

  network_profile {
    network_plugin      = var.AKSNetworkPlugin
    network_policy      = var.AKSNetPolProvider
    dns_service_ip      = var.AKSNetworkDNS
    network_data_plane  = var.AKSEbpfDataplane
    network_plugin_mode = var.AKSNetworkPluginMode
    outbound_type       = var.AKSOutboundType
    service_cidr        = var.AKSSVCCIDR
    pod_cidr            = var.AKSPodCIDR
    load_balancer_sku   = var.AKSLBSku


    dynamic "load_balancer_profile" {
      for_each = var.AKSLBSku == "Standard" ? ["fake"] : []

      content {

        outbound_ports_allocated  = var.AKSLBOutboundPortsAllocated
        idle_timeout_in_minutes   = var.AKSLBIdleTimeout
        managed_outbound_ip_count = var.AKSLBOutboundIPCount
        outbound_ip_prefix_ids    = var.AKSLBOutboundIPPrefixIds
        outbound_ip_address_ids   = var.AKSLBOutboundIPAddressIds

      }

    }

  }

  role_based_access_control_enabled = true

  storage_profile {
    blob_driver_enabled         = var.IsBlobDriverEnabled
    disk_driver_enabled         = var.IsDiskDriverEnabled
    file_driver_enabled         = var.IsFileDriverEnabled
    snapshot_controller_enabled = var.IsSnapshotControllerEnabled

  }

  azure_active_directory_role_based_access_control {
    tenant_id              = var.EntraIdTenantId
    azure_rbac_enabled     = var.AzureRBACEnabled
    admin_group_object_ids = var.AKSClusterAdminsIds

  }



  sku_tier = var.AKSControlPlaneSku

  azure_policy_enabled             = var.IsAzPolicyEnabled
  http_application_routing_enabled = var.IshttproutingEnabled

  dynamic "key_vault_secrets_provider" {

    for_each = var.IsCSIKVAddonEnabled ? ["fake"] : []

    content {

      secret_rotation_enabled  = var.CSIKVSecretRotationEnabled
      secret_rotation_interval = var.CSIKVSecretRotationInterval

    }

  }

  dynamic "oms_agent" {
    for_each = local.IsOMSAgentEnabled ? ["fake"] : []

    content {
      log_analytics_workspace_id = local.LawOMSId
    }

  }

  dynamic "microsoft_defender" {
    for_each = local.IsDefenderEnabled ? ["fake"] : []

    content {
      log_analytics_workspace_id = local.LawDefenderId
    }

  }

  open_service_mesh_enabled = var.IsOpenServiceMeshEnabled

  dynamic "ingress_application_gateway" {
    for_each = var.IsAGICEnabled ? ["fake"] : []

    content {
      gateway_id   = var.AGWId
      gateway_name = var.AGWName
      subnet_cidr  = var.AGWSubnetCidr
      subnet_id    = var.AGWSubnetId

    }

  }

  tags = local.Tags

}
