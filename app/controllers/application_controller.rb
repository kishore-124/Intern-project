class ApplicationController < ActionController::Base
 http_basic_authenticate_with name: "kishore", password: "kishore", except: [:index, :show]
end
