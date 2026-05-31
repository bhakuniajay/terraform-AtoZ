locals {
  #converting file into map {[firstname , lastname , department ]}
  users = csvdecode(file("users.csv"))
}