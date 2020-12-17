module Api
  class TranslationsController < BaseController

    skip_before_action :verify_authenticity_token

    rescue_from StandardError do |e|
      logger.warn "Unhandled exception: #{e.inspect}"
      logger.info e.backtrace.join("\n")
      render json: { message: 'Internal server error' }, status: :bad_request
    end

    def create
      request = TranslationRequest.from_params(params)

      if request.valid?
        request.save!
        api_response = request.perform_translate
        response = TranslationResponse.from_api_response(request.id, api_response)

        if response.valid?
          response.save!
          render json: {
            request_text: request.text,
            response_text: response.text,
            source_lang: request.source_lang,
            target_lang: request.target_lang,
            detected_source_language: response.detected_source_language
          }
        else
          logger.warn "Response validation error: #{response.errors.full_messages}"
          render json: { message: 'Invalid translation response' }, status: :bad_request
        end
      else
        logger.warn "Request validation error: #{request.errors.full_messages}"
        render json: { message: 'Invalid translation request' }, status: :bad_request
      end
    end
  end
end
