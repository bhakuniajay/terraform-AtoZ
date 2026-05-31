output "formatted_project_Name" {
  value = local.formatted_project_name
}
output "port_list" {
    value = local.portlist
  
}
output "sg_rule" {
  value = local.sg_rule
}
output "instance_size" {
  value = local.instance_sizes
}

output "credentials" {
  value = var.credentials
  sensitive = true
}
output "all_loc" {
  value = local.all_locaitons
}
output "positive_cost" {
  value = local.possitive_cost
}
output "maxcost" {
  value = local.maxcost
}
output "mincost" {
  value = local.min_cost
}
output "sum" {
  value = local.total_cost
}

output "time" {
  value = local.current_timestamp
}

output "config" {
  value = local.config_data
}