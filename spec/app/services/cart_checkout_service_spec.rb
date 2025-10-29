RSpec.describe CartCheckoutService do
  describe '.call' do
    context 'with input_1.txt fixture' do
      let(:input_file) { 'spec/fixtures/input_1.txt' }
      let(:expected_output_file) { 'spec/fixtures/output_1.txt' }
      let(:expected_output) { File.read(expected_output_file).strip }

      it 'produces the expected output' do
        output = capture_stdout do
          described_class.call(input_file)
        end

        expect(output.strip).to eq(expected_output)
      end
    end

    context 'with input_2.txt fixture (imported products)' do
      let(:input_file) { 'spec/fixtures/input_2.txt' }
      let(:expected_output_file) { 'spec/fixtures/output_2.txt' }
      let(:expected_output) { File.read(expected_output_file).strip }

      it 'produces the expected output' do
        output = capture_stdout do
          described_class.call(input_file)
        end

        expect(output.strip).to eq(expected_output)
      end
    end

    context 'with input_3.txt fixture (mixed products)' do
      let(:input_file) { 'spec/fixtures/input_3.txt' }
      let(:expected_output_file) { 'spec/fixtures/output_3.txt' }
      let(:expected_output) { File.read(expected_output_file).strip }

      it 'produces the expected output' do
        output = capture_stdout do
          described_class.call(input_file)
        end

        expect(output.strip).to eq(expected_output)
      end
    end

    context 'with invalid product line' do
      let(:input_file) { 'spec/fixtures/wrong_line_input.txt' }

      it 'raises an error' do
        expect {
          capture_stdout do
            described_class.call(input_file)
          end
        }.to raise_error(RuntimeError, /Invalid product line/)
      end
    end

    context 'with non-existent file' do
      let(:input_file) { 'spec/fixtures/nonexistent.txt' }

      it 'raises an error' do
        expect {
          described_class.call(input_file)
        }.to raise_error(Errno::ENOENT)
      end
    end
  end

  private

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end
