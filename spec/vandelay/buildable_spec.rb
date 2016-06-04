describe Vandelay::Buildable do
  let(:builder_class) { Class.new do
      include Vandelay::Buildable
      composed_of :engine,
                  :doors

      composed_of :stereo, default: :cassette_player
    end
  }

  let(:car_builder) { builder_class.new }

  describe '#composed_of' do
    it 'adds setters to class' do
      expect(car_builder).to respond_to :set_engine
      expect(car_builder).to respond_to :set_doors
    end
  end

  describe '#set_*' do
    it 'returns itself' do
      expect(car_builder.set_doors(4).object_id).to eq(car_builder.object_id)
    end
  end

  describe '#build' do
    it 'returns the attributes set on the builder' do
      expect(car_builder.build).to eq({
        doors: nil,
        engine: nil,
        stereo: :cassette_player
      })
    end

    context 'does not over write defaults from other builders' do
      let(:other_builder_class) { Class.new do
          include Vandelay::Buildable
          composed_of :engine,
                      :doors

          composed_of :stereo, default: :mp3
        end
      }

      let(:other_car_builder) { other_builder_class.new }

      it 'does not overwrite the different defaults' do
        expect(car_builder.build).to eq({
          doors: nil,
          engine: nil,
          stereo: :cassette_player
        })

        expect(other_car_builder.build).to eq({
          doors: nil,
          engine: nil,
          stereo: :mp3
        })
      end
    end

    context 'subclassed builders' do
      let(:subclassed_builder) {
        class SubBuilder < builder_class
          composed_of :stereo, default: :sirius_xm
        end

        SubBuilder
      }

      it 'does not override defaults from subclass' do
        expect(car_builder.build).to eq({
          doors: nil,
          engine: nil,
          stereo: :cassette_player
        })

        expect(subclassed_builder.new.build).to eq({
          doors: nil,
          engine: nil,
          stereo: :sirius_xm
        })
      end
    end
  end
end

