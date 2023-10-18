class TestController < ApplicationController
    before_action :authenticate_request
    def hello
        render json: {data: "test data"}
    end
end
