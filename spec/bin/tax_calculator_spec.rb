RSpec.describe 'Tax Calculator CLI Integration Tests' do
  let(:bin_path) { File.expand_path('../../bin/tax_calculator.rb', __dir__) }

  describe 'command line interface' do
    context 'when no file is provided' do
      it 'displays an error message' do
        output = `ruby #{bin_path} 2>&1`

        expect(output).to include('Error: No file provided.')
        expect(output).to include('Use -h for help.')
        expect($?.exitstatus).to eq(1)
      end
    end

    context 'when help flag is used' do
      it 'displays help message with -h flag' do
        output = `ruby #{bin_path} -h 2>&1`

        expect(output).to include('Usage:')
        expect(output).to include('--file FILE')
        expect(output).to include('--help')
        expect($?.exitstatus).to eq(0)
      end
    end

    context 'when file does not exist' do
      it 'displays an error message' do
        output = `ruby #{bin_path} -f /path/to/nonexistent/file.txt 2>&1`

        expect(output).to include("Error: '/path/to/nonexistent/file.txt' is not a valid .txt file.")
        expect($?.exitstatus).to eq(1)
      end
    end
  end

  describe 'processing fixture files' do
    context 'with input_1.txt fixture' do
      let(:input_file) { File.expand_path('../../spec/fixtures/input_1.txt', __dir__) }
      let(:expected_output_file) { File.expand_path('../../spec/fixtures/output_1.txt', __dir__) }
      let(:expected_output) { File.read(expected_output_file).strip }

      it 'produces the expected output' do
        output = `ruby #{bin_path} -f #{input_file} 2>&1`.strip

        expect(output).to eq(expected_output)
        expect($?.exitstatus).to eq(0)
      end
    end

    context 'with input_2.txt fixture (imported products)' do
      let(:input_file) { File.expand_path('../../spec/fixtures/input_2.txt', __dir__) }
      let(:expected_output_file) { File.expand_path('../../spec/fixtures/output_2.txt', __dir__) }
      let(:expected_output) { File.read(expected_output_file).strip }

      it 'produces the expected output' do
        output = `ruby #{bin_path} -f #{input_file} 2>&1`.strip

        expect(output).to eq(expected_output)
        expect($?.exitstatus).to eq(0)
      end
    end

    context 'with input_3.txt fixture (mixed products)' do
      let(:input_file) { File.expand_path('../../spec/fixtures/input_3.txt', __dir__) }
      let(:expected_output_file) { File.expand_path('../../spec/fixtures/output_3.txt', __dir__) }
      let(:expected_output) { File.read(expected_output_file).strip }

      it 'produces the expected output' do
        output = `ruby #{bin_path} -f #{input_file} 2>&1`.strip

        expect(output).to eq(expected_output)
        expect($?.exitstatus).to eq(0)
      end
    end
  end

  describe 'edge cases' do
    context 'with wrong_line_input.txt fixture' do
      let(:input_file) { File.expand_path('../../spec/fixtures/wrong_line_input.txt', __dir__) }

      it 'handles invalid product lines gracefully' do
        output = `ruby #{bin_path} -f #{input_file} 2>&1`

        # Should raise an error for invalid product line format
        expect($?.exitstatus).to_not eq(0)
      end
    end
  end
end
