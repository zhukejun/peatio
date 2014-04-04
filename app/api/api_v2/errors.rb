module APIv2

  module ExceptionHandlers

    def self.included(base)
      base.instance_eval do
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          Rack::Response.new({
            error: {
              code: 1001,
              message: e.message
            }
          }.to_json, e.status)
        end
      end
    end

  end

  class Error < Grape::Exceptions::Base
    attr :code, :text

    # code: api error code defined by Peatio, errors originated from
    # subclasses of Error have code start from 2000.
    # text: human readable error message
    # status: http status code
    def initialize(opts={})
      @code    = opts[:code]   || 2000
      @text    = opts[:text]   || ''

      @status  = opts[:status] || 400
      @message = {error: {code: @code, message: @text}}
    end
  end

  class AuthorizationError < Error
    def initialize
      super code: 2001, text: 'Authorization failed', status: 401
    end
  end

end