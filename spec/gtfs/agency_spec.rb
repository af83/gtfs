require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Agency do
  describe 'Agency.parse_agencies' do
    let(:header_line) {"agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone,agency_email\n"}
    let(:invalid_header_line) {"agency_id,agency_url,agency_timezone,agency_lang,agency_phone\n"}
    let(:valid_line) {"1,Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n"}
    let(:invalid_line) {"1,,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n"}

    subject {GTFS::Agency.parse_agencies(source_text, opts)}

    include_examples 'models'
  end

  describe 'Agency.write_agencies' do


    it "should produce the correct csv output" do
      csv = GTFS::Agency.generate_agencies do |agencies|
        agencies << {
          id: 1,
          name: 'Maryland Transit Administration',
          url: 'http://www.mta.maryland.gov',
          timezone: 'America/New_York',
          lang: 'en',
          phone: '410-539-5000'
        }
      end
      csv.should eq("id,name,url,timezone,lang,phone\n1,Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n")
    end

    #     has_optional_attrs :id, :lang, :phone, :fare_url, :email

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Agency.generate_agencies do |agencies|
        agencies << {
          name: 'Maryland Transit Administration',
          url: 'http://www.mta.maryland.gov',
          timezone: 'America/New_York',
          phone: '410-539-5000'
        }
        agencies << {
          id: 1,
          name: 'Maryland Transit Administration',
          url: 'http://www.mta.maryland.gov',
          timezone: 'America/New_York'
        }
        agencies << {
          id: 2,
          name: 'Maryland Transit Administration',
          url: 'http://www.mta.maryland.gov',
          timezone: 'America/New_York',
          phone: '410-539-5000'
        }
      end
      #:id, :name, :url, :timezone, :lang, :phone, :fare_url, :email
      csv.should eq("id,name,url,timezone,phone\n"+
      ",Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,410-539-5000\n"+
      "1,Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,\n"+
      "2,Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,410-539-5000\n"
      )
    end

  end
end
