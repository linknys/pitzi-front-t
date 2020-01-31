class User < ApplicationRecord
    validates :cpf, presence: true
end
