class MachineSnacksController < ApplicationController
    def create
        machine_snack = MachineSnack.new(machine_snacks_params)
        if machine_snack.save
            redirect_to machine_path(params[:machine_id])
        else
            flash[:notice] = "Fill in all fields."
        end
    end

    def destroy
        machine_snack = MachineSnack.find_by(snack_id: params[:id], machine_id: params[:machine_id])
        machine_snack.destroy
        redirect_to machine_path(params[:machine_id])
    end

    private

    def machine_snacks_params
        params.permit(:snack_id, :machine_id)
    end
end