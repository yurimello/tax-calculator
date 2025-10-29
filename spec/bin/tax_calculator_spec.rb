# spec/read_txt_opt_spec.rb
require 'open3'

RSpec.describe "tax_calculator.rb" do
  let(:script) { File.expand_path("../../bin/tax_calculator.rb", __dir__) }

  def run_script(*args)
    Open3.capture3("ruby", script, *args)
  end

  context "when no arguments are given" do
    it "shows an error about missing file" do
      stdout, stderr, status = run_script
      expect(stdout).to include("Error: No file provided.")
      expect(status.exitstatus).to eq(1)
    end
  end

  context "when --help is used" do
    it "shows help output" do
      stdout, stderr, status = run_script("--help")
      expect(stdout).to include("Usage:")
      expect(stdout).to include("--file")
      expect(status.exitstatus).to eq(0)
    end
  end

  context "when given a non-existent file" do
    it "shows an error" do
      stdout, stderr, status = run_script("-f", "missing.txt")
      expect(stdout).to include("is not a valid .txt file")
      expect(status.exitstatus).to eq(1)
    end
  end
end
