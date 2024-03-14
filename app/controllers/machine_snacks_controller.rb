class MachineSnacksController < ApplicationController
    def create
        machine_snack = MachineSnack.new(machine_snacks_params)
        if machine_snack.save
            redirect_to machine_path(params[:machine_id])
        else
            flash[:notice] = "Fill in all fields."
        end
    end

    private

    def machine_snacks_params
        params.permit(:snack_id, :machine_id)
    end
end