Spree::Admin::TaxonsController.class_eval do

  def update
    successful = @taxon.transaction do
      parent_id = params[:taxon][:parent_id]
      set_position
      set_parent(parent_id)

      @taxon.save!

      # regenerate permalink
      regenerate_permalink if parent_id

      set_permalink_params

      # check if we need to rename child taxons if parent name or permalink changes
      @update_children = true if params[:taxon][:name] != @taxon.name || params[:taxon][:permalink] != @taxon.permalink

      @taxon.create_icon(attachment: taxon_params[:icon]) if taxon_params[:icon]
      @taxon.create_hero(attachment: taxon_params[:hero]) if taxon_params[:hero]

      @taxon.update_attributes(taxon_params.except(:icon, :hero))
    end
    if successful
      flash[:success] = flash_message_for(@taxon, :successfully_updated)

      # rename child taxons
      rename_child_taxons if @update_children

      respond_with(@taxon) do |format|
        format.html { redirect_to edit_admin_taxonomy_url(@taxonomy) }
        format.json { render json: @taxon.to_json }
      end
    else
      respond_with(@taxon) do |format|
        format.html { render :edit }
        format.json { render json: @taxon.errors.full_messages.to_sentence, status: 422 }
      end
    end
  end

  def taxon_params
    params.require(:taxon).permit(:name, :permalink, :description, :color, :icon, :hero, :meta_title, :meta_description, :meta_keywords)
  end
end