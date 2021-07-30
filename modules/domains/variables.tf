terraform {
  experiments = [module_variable_optional_attrs]
}

#__________________________________________________________
#
# Intersight Provider Variables
#__________________________________________________________

variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}


#__________________________________________________________
#
# Global Variables
#__________________________________________________________

variable "organizations" {
  default     = "[\"default\"]"
  description = "Intersight Organization Names to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "tags" {
  default     = "[]"
  description = "Tags to be Associated with Objects Created in Intersight."
  type        = string
}


#__________________________________________________________
#
# Intersight UCS Domain Profile Variables
#__________________________________________________________

variable "assign_switches" {
  default     = false
  description = "Setting this Flag to True will Assign Switches to Profile."
  type        = bool
}

variable "assign_domain" {
  default     = false
  description = "Flag to Assign Policies to Domain or not."
  type        = bool
}

variable "configure_fibre_channel" {
  default     = false
  description = "Flag to Specify if Fibre-Channel should be configured."
  type        = bool
}

variable "configure_snmp" {
  default     = false
  description = "Flag to Specify if the SNMP Policy should be configured."
  type        = bool
}

variable "configure_syslog" {
  default     = false
  description = "Flag to Specify if the Syslog Policy should be configured."
  type        = bool
}

variable "snmp_community" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "snmp_user_1_auth_password" {
  default     = ""
  description = "Authorization password for the user."
  sensitive   = true
  type        = string
}

variable "snmp_user_1_privacy_password" {
  default     = ""
  description = "Privacy password for the user."
  sensitive   = true
  type        = string
}

variable "snmp_user_2_auth_password" {
  default     = ""
  description = "Authorization password for the user."
  sensitive   = true
  type        = string
}

variable "snmp_user_2_privacy_password" {
  default     = ""
  description = "Privacy password for the user."
  sensitive   = true
  type        = string
}


variable "ucs_domain_profile" {
  description = "Please Refer to the ucs_domain_profile variable information in the tfe module.  In the domains module the variable is accepted as a string from terraform cloud in the terraform.auto.tfvars and extracted using locals."
  type        = string
}
