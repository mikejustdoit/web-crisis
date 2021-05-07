require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift(File.expand_path("app"))

ASSETS = File.absolute_path(File.join(File.dirname(__FILE__), "..", "assets"))

PLACEHOLDER_IMAGE = File.absolute_path(
  File.join(File.dirname(__FILE__), "..", "app", "broken.png")
)
