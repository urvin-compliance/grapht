require 'spec_helper'

describe Grapht::Shell do
  context 'benchmarks' do
    describe '.exec' do
      let(:type) { Grapht::Type::BAR_HORIZONTAL }
      let(:data) do
        [
          { name: "foo", value: 20 },
          { name: "bar", value: 40 },
          { name: "baz", value: 35 }
        ].to_json
      end

      before do
        RubyProf.pause if RubyProf.running?

        Grapht::Shell.exec type, data

        RubyProf.resume if RubyProf.running?
      end

      it { should be_true }
    end
  end
end
