{
 # config,
  ...
}:
# with config;
{
  services.rabbitmq.enable = true;
  services.rabbitmq.managementPlugin.enable = true;
}
