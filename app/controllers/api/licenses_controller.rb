module Api
  class LicensesController < BaseController

    def show
      if params[:id] && params[:key] && !params[:key].match?(/\Alk_trial_/) && (license = License.not_revoked.find_by(key: params[:key]))
        render json: { pro: !!license.pro? }
      else
        head :not_found
      end
    end
  end
end
