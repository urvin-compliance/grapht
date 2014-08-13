require 'spec_helper'

describe Grapht::Shell do
  describe '.exec' do
    let(:type)       { Grapht::Type::BAR_HORIZONTAL }
    let(:format)     { "" }
    let(:json_data)  {
      <<-json
      [
        { "name": "foo", "value": 20 },
        { "name": "bar", "value": 40 },
        { "name": "baz", "value": 35 }
      ]
      json
    }

    subject { Grapht::Shell.exec type, json_data, '-f' => format }

    context 'when given a known type' do
      it { should match(/^<svg/) }
    end

    context 'when given an unknown type' do
      let(:type) { 'some-invalid-graph-type' }

      it "should raise a Grapht::Shell::Error" do
        expect { subject }.to raise_error(Grapht::Shell::Error, /No graph definition could be found/)
      end
    end

    context 'when a known type is provided with a leading forward-slash' do
      let(:type) { "/#{Grapht::Type::BAR_HORIZONTAL}" }
      it { should match(/^<svg/) }
    end

    context 'when a naughty types are provided' do
      [ "../buck-wild/corn-dogs",
        "../../born-wild/chicken-skin",
        "innocent-path/../../rootpath"
      ].each do |path|
        context "for path: '#{path}'" do
          let(:type) { path }

          it 'should raise a Grapht::Shell::Error' do
            expect { subject }.to raise_error(
              Grapht::Shell::Error,
              /Naughty! There will be no backing out of the definition directory!/)
          end
        end
      end
    end

    context 'when well-formed data is provided' do
      it { should match(/^<svg/) }
    end

    context 'when malformed data is provided' do
      let(:json_data) { "{} <this is not JSON>" }

      it "should raise a Grapht::Shell::Error" do
        expect { subject }.to raise_error(Grapht::Shell::Error, /Unable to parse JSON string/)
      end
    end

    context 'when no data is provided' do
      let(:json_data) { "" }

      it "should raise a Grapht::Shell::Error" do
        expect { subject }.to raise_error(Grapht::Shell::Error, /No graph data was received/)
      end
    end

    context 'when no format is provided' do
      it { should match(/^<svg/) }
    end

    context 'when an unknown format is provided' do
      let(:format) { 'some-crazy-invalid-format' }
      it { should be_empty }
    end

    context "when a binary format is provided" do
      before { subject.force_encoding('binary') }

      context "when a format of 'png' is provided" do
        let(:format) { 'png' }
        it { should start_with("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A".force_encoding('binary')) }
      end

      context "when a format of 'jpg' is provided" do
        let(:format) { 'jpg' }
        it { should start_with("\xFF\xD8\xFF\xE0\x00\x10JFIF\x00".force_encoding('binary')) }
      end

      context "when a format of 'gif' is provided" do
        let(:format) { 'gif' }
        it { should start_with("\x47\x49\x46\x38\x37\x61".force_encoding('binary')) }
      end
    end
  end
end
