resource_group_name = "RG-App"
service_plan_name   = "Plan-App"
environment         = "DEV1"
custom_app_settings = {
  APP = "1"
}

nb_webapp = 2

tags = {
  ENV          = "DEV1"
  CODE_PROJECT = "DEMO"
}

app_settings = {
  KEY1 = "VAL1"
}
