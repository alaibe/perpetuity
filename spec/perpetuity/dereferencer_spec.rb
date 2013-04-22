require 'perpetuity/dereferencer'
require 'perpetuity/reference'

module Perpetuity
  describe Dereferencer do
    let(:mapper) { double('ObjectMapper') }
    let(:first) { double('Object', class: Object) }
    let(:second) { double('Object', class: Object) }
    let(:first_ref) { Reference.new(Object, 1) }
    let(:second_ref) { Reference.new(Object, 2) }
    let(:objects) { [first, second] }
    let(:registry) { { Object => mapper } }
    let(:derefer) { Dereferencer.new(registry) }

    context 'with one reference' do
      it 'loads objects based on the specified objects and attribute' do
        mapper.should_receive(:id_for).with(first) { 1 }
        mapper.should_receive(:find).with(1) { first }

        derefer.load first_ref
        derefer[first_ref].should == first
      end
    end

    context 'with no references' do
      it 'returns an empty array' do
        derefer.load(nil).should == []
      end
    end

    context 'with multiple references' do
      before do
        mapper.should_receive(:select) { objects }
        mapper.should_receive(:id_for).with(first) { 1 }
        mapper.should_receive(:id_for).with(second) { 2 }
      end

      it 'returns the array of dereferenced objects' do
        derefer.load([first_ref, second_ref]).should == objects
      end
    end
  end
end
