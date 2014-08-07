require 'rspec_helper'

describe Table_Butler do
  before do
    create_test_objects
  end

  it "deletes a table class instance from the database" do
    @test_doctor.delete
    expect(Doctor.all).to eq []
  end

end
