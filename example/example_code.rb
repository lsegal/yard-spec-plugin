# Run `yardoc -e ./lib/yard-rspec.rb ./example/example_code.rb`

class String
  # Pig latin of a String
  def pig_latin(switch = true)
    "#{self[1..-1]}#{self[0, 1]}ay"
  end
end

# 
# Specs
# 
describe String do
  describe '#pig_latin' do
    it "should be a pig!" do
      "hello".pig_latin.should == "ellohay"
    end

    context "on an empty string" do
      it "should fail to be a pig!" do
        "".pig_latin.should == ""
      end
    end

    it "works with RSpec metadata", :see => "yep" do
      "xyz".pig_latin.length.should == "xyz".length + 2
    end

    it "works on multi-lingual strings" # pending
  end

  context "under circumstances" do
    describe "#pig_latin(true)" do
      subject { %w(i can count on you).map(&:pig_latin).join(" ") }

      its(:length) { should == 28 }
      its(:"length") { should == 28 }
      its('length') { should == 28 }
      its "length" do; should == 28 end

      specify { should == "iay ancay ountcay onay ouyay" }
    end
  end
end
