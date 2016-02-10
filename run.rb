require 'rubygems'
require 'bundler/setup'

require 'yaml'

require_relative 'bvg_bot'

settings = YAML.load_file 'bvg_bot.yml'

email = settings['email']
password = settings['password']

bot = BVGBot.instance(email, password)

bot.run :async

bot.game = 'AWSOMESAUCE'

bot.sync
