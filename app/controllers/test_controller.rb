class TestController < ApplicationController
    def hello
        render json: {data: "test data"}
    end
end
