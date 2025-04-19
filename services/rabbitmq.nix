{
  ...
}:
{
  services.rabbitmq.enable = false; # Change this to true to enable rabbitmq
  services.rabbitmq.managementPlugin.enable = true;
  services.rabbitmq.listenAddress = "0.0.0.0";
  services.rabbitmq.configItems = {
    "loopback_users.guest" = "false";
  };
}
