require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/resources_api_client"
require "lita/handlers/actions_handler"

Lita::Handlers::ResourcesApiClient.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
