require 'spec_helper'

describe Character do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:strength) }
  it { should validate_presence_of(:dexterity) }
  it { should validate_presence_of(:constitution) }
  it { should validate_presence_of(:intelligence) }
  it { should validate_presence_of(:wisdom) }
  it { should validate_presence_of(:charisma) }

  describe "#generate_characteristics" do
    let(:character) { Character.new }

    subject { character.generate_characteristics }

    it 'will assign attributes' do
      subject

      expect(character.name).to be_present

      expect(character.strength).to be_present
      expect(character.dexterity).to be_present
      expect(character.constitution).to be_present
      expect(character.intelligence).to be_present
      expect(character.wisdom).to be_present
      expect(character.charisma).to be_present
    end
  end
end

