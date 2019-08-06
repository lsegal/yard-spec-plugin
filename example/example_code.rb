# Run `yardoc -e ../lib/yard-rspec example_code.rb`


class String
  # Pig latin of a String
  def pig_latin
    self[1..-1] + self[0] + "ay"
  end
end

#
# Specs
#
describe String do
  describe '#pig_latin' do
    it "should be a pig!" do
      expect("hello".pig_latin).to eq("ellohay")
     end

    it "should fail to be a pig!" do
      expect("hello".pig_latin).not_to eq("hello")
    end
  end

  describe 'Some context' do
    describe '#pig_latin' do
      it 'should still be a pig!' do
        expect("food".pig_latin).to eq('oodfay')
      end
    end
  end

  describe '#pig_latin' do
    context 'Some other context' do
      it 'should still be a pig in some other context!' do
        expect("avocado".pig_latin).to eq('vocadoaay')
      end
    end
  end
end
