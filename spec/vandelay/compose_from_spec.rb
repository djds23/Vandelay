describe Vandelay::ComposeFrom do
  describe '#composed_from' do
    let(:foo) {
      class Foo
        def bar
          'quux'
        end
      end

      Foo.new
    }

    let(:composable) {
      class FooBuilder
        extend Vandelay::ComposeFrom
        attr_reader :bar
        compose_from 'Foo', [:bar]

        def set_bar(bar)
          @bar = bar
        end
      end

      FooBuilder.new
    }

    it 'writes compose_from_* instance methods' do
      expect(composable).to respond_to :compose_from_foo
    end

    it 'pulls values off the provided instance' do
      composed_from_foo = composable.compose_from_foo(foo)
      expect(composed_from_foo).to equal composable
      expect(composed_from_foo.bar).to eq foo.bar
    end
  end
end

