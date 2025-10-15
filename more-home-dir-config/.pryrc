# This file is loaded by the rails console automatically
# https://stackoverflow.com/questions/3860297/irbrc-file-not-loaded-by-rails-console#comment71574906_3860297

puts "Running ~/.pryrc..."

class Object
  def meths
    (methods - Object.instance_methods).sort
  end
end

