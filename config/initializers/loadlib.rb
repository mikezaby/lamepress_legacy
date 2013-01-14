Dir["lib/**/*.rb"].each do |path|
 require_dependency "#{Rails.root}/#{path}"
end
