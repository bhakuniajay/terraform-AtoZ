locals {
 formatted_project_name = lower(replace(var.project_name," ", "_"))
 new_tag = merge(var.default_tags,var.environment_tags)
 formatted_bucket_name = replace(substr(lower(var.bucket_name),0,63)," ","-")
}


resource "aws_s3_bucket" "Demo" {
  bucket = local.formatted_bucket_name
  tags = local.new_tag
}

# string 
locals {
  portlist = split(",",var.allowed_ports)
  sg_rule = [for port in local.portlist :
  {
    name = "port-${port}"
    port = port
    description = "allowed traffic on port ${port}"
  }
  ]
}

locals {
  instance_sizes=lookup(var.instance_sizes,var.environment,"t2.micro" )

  all_locaitons=concat(var.user_loations , var.default_location)
  uniquie_location = toset(local.all_locaitons)

  possitive_cost = [ for cost in var.monthly_costs : abs(cost) ]
  #not working
  # list_cost=split(",",local.possitive_cost)
  
  maxcost = max(local.possitive_cost...)
  min_cost=min(local.possitive_cost...)
  total_cost=sum(local.possitive_cost)
  avg_cost = local.total_cost / length(local.possitive_cost)

  current_timestamp = timestamp()
  format1= formatdate("yyyyMMdd", local.current_timestamp)
  format2=formatdate("YYYY-MM-DD" , local.current_timestamp)
  timestamp_name ="backup-${local.format1}"
  config_file_exists=fileexists("./config.json")
  config_data = local.config_file_exists ? jsondecode(file("./config.json")) : {}
}