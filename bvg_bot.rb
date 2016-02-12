require_relative 'lib/modular_bot'
require_relative 'lib/invites'
require_relative 'lib/mentions'
require_relative 'lib/fuck_you_steve'
require_relative 'lib/google_images'

class BVGBot < BVG::ModularBot
  include BVG::FuckYouSteve
  include BVG::Invites
  include BVG::Mentions
  include BVG::GoogleImages
end
