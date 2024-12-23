{
 # config,
  ...
}:
# with config;
{
  services.rabbitmq.enable = true;
  services.rabbitmq.managementPlugin.enable = true;
  services.rabbitmq.listenAddress = "0.0.0.0";
}
