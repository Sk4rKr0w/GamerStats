# app/controllers/admin/patch_notes_controller.rb
class Admin::PatchNotesController < ApplicationController
    before_action :set_patch_note, only: [:show, :edit, :update, :destroy]
  
    def index
      @patch_notes = PatchNote.all
    end
  
    def show
    end
  
    def new
      @patch_note = PatchNote.new
    end
  
    def create
      @patch_note = PatchNote.new(patch_note_params)
      if @patch_note.save
        redirect_to admin_patch_notes_path, notice: 'Patch note was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @patch_note.update(patch_note_params)
        redirect_to admin_patch_notes_path, notice: 'Patch note was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @patch_note.destroy
      redirect_to admin_patch_notes_path, notice: 'Patch note was successfully destroyed.'
    end
  
    private
  
    def set_patch_note
      @patch_note = PatchNote.find(params[:id])
    end
  
    def patch_note_params
      params.require(:patch_note).permit(:title, :description, :image_path, :game, :link_path)
    end
  end
  