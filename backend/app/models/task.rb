class Task < ApplicationRecord
    validates :name, presence: true, acceptance: { message: 'タスク名が未入力です' }
end
