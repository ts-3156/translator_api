module Api
  class LicensesController < BaseController

    def show
      # TODO Check id
      if params[:id] && params[:key] && (license = License.find_by(key: params[:key]))
        render json: { license.type => true }
      else
        head :not_found
      end
    end
  end
end
