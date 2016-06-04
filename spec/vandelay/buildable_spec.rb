describe Vandelay::Buildable do
  let(:builder_class) { Class.new do
      include Vandelay::Buildable
      composed_of :wheels,
                  :doors,
                  :engine,
                  :gasoline,
                  :seatbelts

      composed_of :stero, default: :cassette_player
    end
  }

  let(:car_builder) { builder_class.new }

  describe '#composed_of' do
    it 'adds setters to class' do
      expect(car_builder).to respond_to :set_wheels
      expect(car_builder).to respond_to :set_doors
      expect(car_builder).to respond_to :set_engine
      expect(car_builder).to respond_to :set_gasoline
      expect(car_builder).to respond_to :set_seatbelts
    end
  end

  describe '#set_*' do
    it 'returns itself' do
      expect(car_builder.set_doors(4).object_id).to eq(car_builder.object_id)
    end
  end

  describe '#build' do
    it 'returns the attributes set on the builder' do
      car_builder.set_wheels(4)

      expect(car_builder.build).to eq({
        wheels: 4,
        doors: nil,
        engine: nil,
        gasoline: nil,
        seatbelts: nil,
        stereo: :cassette_player
      })
    end
  end
end

