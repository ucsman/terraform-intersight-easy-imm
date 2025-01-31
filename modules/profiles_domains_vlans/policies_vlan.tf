#_________________________________________________________________________
#
# Intersight VLAN Policy Variables
# GUI Location: Configure > Policies > Create Policy > VLAN > Start
#_________________________________________________________________________

variable "policies_vlan" {
  default = {
    default = {
      auto_allow_on_uplinks = true
      description           = ""
      multicast_policy      = ""
      organization          = "default"
      tags                  = []
      vlan_list             = null
      vlan_map              = []
      vlan_native           = null
      vlan_prefix           = "{organization}"
    }
  }
  description = <<-EOT
  key - Name of the VLAN Policy.
  * auto_allow_on_uplinks =
  * description - Description to Assign to the Policy.
  * multicast_policy - Name of the Multicast Policy to Assign to the VLAN Group.
  * organization - Name of the Intersight Organization to assign this Policy to.
    - https://intersight.com/an/settings/organizations/
  * tags - List of Key/Value Pairs to Assign as Attributes to the Policy.
  * vlan_list - List of VLANs to assign to the VLAN Policy.  The VLAN list will use the vlan_prefix-vl{vlan_id} as the name of the vlan.
  * vlan_map - This VLAN Map should contain key/value pairs of prefix and vlan_id.  In Example:
  vlan_map = [
    {
      prefix  = "test"
      vlan_id = 123
    },
    {
      prefix  = "test"
      vlan_id = 124
    }
  ]
  This will be configured as test-vl0123 and test-vl0124 in intersight.
  * vlan_native - The Native VLAN to assign to the policy.
  * vlan_prefix - Prefix to Assign to the VLANs in the VLAN Map.
  EOT
  type = map(object(
    {
      auto_allow_on_uplinks = optional(bool)
      description           = optional(string)
      multicast_policy      = string
      organization          = optional(string)
      tags                  = optional(list(map(string)))
      vlan_list             = optional(string)
      vlan_map              = optional(list(map(string)))
      vlan_native           = optional(number)
      vlan_prefix           = optional(string)
    }
  ))
}

#_________________________________________________________________________
#
# Intersight VLAN Policy
# GUI Location: Create > Policy > Create Policy > VLAN > Start
#_________________________________________________________________________

module "policies_vlan" {
  depends_on = [
    local.org_moids,
    local.profiles_ucs_domain
  ]
  source      = "terraform-cisco-modules/imm/intersight//modules/domain_vlan_policy"
  for_each    = local.policies_vlan
  description = each.value.description != "" ? each.value.description : "${each.key} VLAN Policy."
  name        = each.key
  org_moid    = local.org_moids[each.value.organization].moid
  tags        = length(each.value.tags) > 0 ? each.value.tags : local.tags
  profiles = flatten([
    for s in sort(keys(local.ucs_domain_profiles)) :
    [local.ucs_domain_profiles_a[s], local.ucs_domain_profiles_b[s]]
    if local.profiles_ucs_domain[s].profile.policies_vlan == each.key
  ])
}

#______________________________________________
#
# Assign a Native VLAN to VLAN Policies
#______________________________________________

module "policies_vlan_native" {
  depends_on = [
    local.org_moids,
    module.policies_multicast,
    module.policies_vlan
  ]
  source = "terraform-cisco-modules/imm/intersight//modules/domain_vlan"
  for_each = {
    for k, v in local.policies_vlan : k => v
    if v.vlan_native != null
  }
  auto_allow_on_uplinks = each.value.auto_allow_on_uplinks
  is_native             = true
  multicast_moid        = module.policies_multicast[each.value.multicast_policy].moid
  vlan                  = each.value.vlan_native
  vlan_policy_moid      = module.policies_vlan[each.key].moid
  vlan_prefix           = each.value.vlan_prefix
}

#______________________________________________
#
# Assign VLAN List to VLAN Policies
#______________________________________________

module "policies_vlan_list" {
  depends_on = [
    local.org_moids,
    module.policies_multicast,
    module.policies_vlan
  ]
  source = "terraform-cisco-modules/imm/intersight//modules/domain_vlan_list"
  for_each = {
    for k, v in local.policies_vlan : k => v
    if v.vlan_list != ""
  }
  auto_allow_on_uplinks = each.value.auto_allow_on_uplinks
  is_native             = false
  multicast_moid        = module.policies_multicast[each.value.multicast_policy].moid
  vlan_list             = each.value.vlan_list
  vlan_policy_moid      = module.policies_vlan[each.key].moid
  vlan_prefix           = each.value.vlan_prefix
}


#______________________________________________
#
# Assign VLAN Map to VLAN Policies
#______________________________________________

module "policies_vlan_map" {
  depends_on = [
    local.org_moids,
    module.policies_multicast,
    module.policies_vlan
  ]
  source = "terraform-cisco-modules/imm/intersight//modules/domain_vlan_map"
  for_each = {
    for k, v in local.policies_vlan : k => v
    if length(v.vlan_map) > 0
  }
  auto_allow_on_uplinks = each.value.auto_allow_on_uplinks
  is_native             = false
  multicast_moid        = module.policies_multicast[each.value.multicast_policy].moid
  vlan_map              = each.value.vlan_map
  vlan_policy_moid      = module.policies_vlan[each.key].moid
}
