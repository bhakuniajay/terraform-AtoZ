
resource aws_s3_bucket "bucket1"{
    count = 2
    # bucket =  var.bucket_names[count.index]
  #  bucket = var.bucket_names_set[count.index] #it will give error becuse set did not use count.index (set did not have index)
    
    tags = var.tags

}

resource aws_s3_bucket "bucket2" {
  for_each = var.bucket_names_set
  bucket = each.value  # we can use each.key in list and set there is no key value but map have so difference come there #order does not matter it was traverse the lenght of for_each
  tags = var.tags 
}

#for_each -- set or map
#count -- list