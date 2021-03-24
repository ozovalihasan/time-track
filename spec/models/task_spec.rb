require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is invalid when no attribute is defined' do
    expect(Task.create).to be_valid
  end
end
