class ApplicationController < ActionController::Base
    include ApplicationHelper
    before_action :get_current_meta_version

    private
        def get_current_meta_version
            @current_meta_version = current_meta_version
        end
        
end
