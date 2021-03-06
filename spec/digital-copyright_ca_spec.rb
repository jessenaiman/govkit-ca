require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gov_kit-ca/postal_code/strategy/digital-copyright_ca'

describe GovKit::CA::PostalCode::Strategy::DigitalCopyrightCa do
  describe '#electoral_districts' do
    it 'should return the electoral districts within a postal code' do
      { 'G0C2Y0' => [24019, 24039], # differs from all
        'T5S2B9' => [48012, 48013, 48014, 48015, 48017, 48018], # differs from all
        'K0A1K0' => [35025, 35052, 35063],
        'B0J2L0' => [12002, 12007, 12008],
      }.each do |postal_code,electoral_districts|
        GovKit::CA::PostalCode::Strategy::DigitalCopyrightCa.new(postal_code).electoral_districts.should == electoral_districts
      end
    end

    it 'should return false if a postal code contains no electoral districts' do
      GovKit::CA::PostalCode::Strategy::DigitalCopyrightCa.new('H0H0H0').electoral_districts.should be_false
    end

    it 'should return false if a postal code does not exist' do
      GovKit::CA::PostalCode::Strategy::DigitalCopyrightCa.new('X1B1B1').electoral_districts.should be_false
    end
  end
end
