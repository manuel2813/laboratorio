class AgendaLaboratorista < ApplicationRecord
  belongs_to :laboratorista, class_name: "User"
end
