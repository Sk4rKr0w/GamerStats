# app/controllers/patch_notes_controller.rb
class PatchNotesController < ApplicationController
  def index
    @patch_notes = PatchNote.all
  end
end
