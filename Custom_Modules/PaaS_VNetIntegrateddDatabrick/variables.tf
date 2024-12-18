######################################################
# Module dtbs Variables
######################################################

######################################################
# Diagnostic settngs variable

variable "STALogId" {
  type        = string
  description = "The storage account used for the diag settings"

}

variable "LawLogId" {
  type        = string
  description = "The log analytics used for the diag settings"

}

variable "LawLogLocation" {
  type        = string
  description = "The log analytics used for the diag settings"

}

variable "LawLogWorkspaceId" {
  type        = string
  description = "The log analytics used for the diag settings"

}

######################################################
#Network watcher variables

variable "NetworkWatcherName" {
  type        = string
  default     = "NetworkWatcher_westeurope"
  description = "The name of the network watcher, in the appropriate region"
}

variable "NetworkWatcherRGName" {
  type        = string
  default     = "NetworkWatcherRG"
  description = "The name of the network watcher resource group"
}

######################################################
#Resource Group variables

variable "TargetRG" {
  type        = string
  description = "The Resource Group containing all the resources for this module"

}

variable "AzureRegion" {
  type        = string
  description = "The Azure location"
  default     = "westeurope"

}

######################################################
#VNet variables

variable "VNetSuffix" {
  type        = string
  description = "VNet name"
  default     = "dtbws"


}

variable "VNetAddressSpace" {
  type        = list(any)
  description = "The VNet IP Range"
  default = [
    "192.168.102.0/24"
  ]

}

######################################################
#Subnets variables

variable "SubnetNames" {
  type        = list(any)
  description = "List of subnet names"
  default = [
    "pub-dtbs",
    "priv-dtbs"

  ]

}

variable "Subnetaddressprefix" {
  type        = list(any)
  description = "List of subnet range"
  default     = ["default"]

}

variable "SVCEP" {
  type        = list(any)
  description = "The list of service endpoint for the subnets"
  default     = null
}



######################################################
#Databricks workspace variables

variable "DTBWSSuffix" {
  type        = string
  description = "A suffix for the Databricks workspace"
  default     = "1"

}

variable "DTBWSSku" {
  type        = string
  description = "The sku of the Databricks workspace"
  default     = "standard"

}

variable "DTBWSPIP" {
  type        = string
  description = "Define the dtbws param no_public_ip, default to false to have public ip"
  default     = false
}


variable "logcategories" {
  type        = map(any)
  description = "A map used to feed the dynamic blocks of the gw configuration"
  default = {

    "logcat1" = {
      LogCatName         = "dbfs"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat2" = {
      LogCatName         = "jobs"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat3" = {
      LogCatName         = "notebook"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat4" = {
      LogCatName         = "ssh"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat5" = {
      LogCatName         = "workspace"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat6" = {
      LogCatName         = "secrets"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat7" = {
      LogCatName         = "sqlPermissions"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat8" = {
      LogCatName         = "instancePools"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat9" = {
      LogCatName         = "sqlanalytics"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat10" = {
      LogCatName         = "genie"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat11" = {
      LogCatName         = "globalInitScripts"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat12" = {
      LogCatName         = "iamRole"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat13" = {
      LogCatName         = "mlflowExperiment"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat14" = {
      LogCatName         = "featureStore"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat15" = {
      LogCatName         = "RemoteHistoryService"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat16" = {
      LogCatName         = "mlflowAcledArtifact"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat17" = {
      LogCatName         = "clusters"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

    "logcat18" = {
      LogCatName         = "accounts"
      IsLogCatEnabled    = true
      IsRetentionEnabled = true
      RetentionDay       = 365
    }

  }
}

######################################################
#Tag related variables and naming convention section

variable "ResourceOwnerTag" {
  type        = string
  description = "Tag describing the owner"
  default     = "That would be me"
}

variable "CountryTag" {
  type        = string
  description = "Tag describing the Country"
  default     = "fr"
}

variable "CostCenterTag" {
  type        = string
  description = "Tag describing the Cost Center"
  default     = "lab"
}

variable "Project" {
  type        = string
  description = "The name of the project"
  default     = "tfmodule"
}

variable "Environment" {
  type        = string
  description = "The environment, dev, prod..."
  default     = "lab"
}