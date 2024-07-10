class PatchNotesController < ApplicationController
  def index
    @patch_notes = PatchNote.all
  end
end
