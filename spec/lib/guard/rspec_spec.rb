require "guard/compat/test/helper"
require "guard/espect"

RSpec.describe Guard::Espect do
  let(:default_options) { Guard::Espect::Options::DEFAULTS }
  let(:options) { {} }
  let(:plugin) { Guard::Espect.new(options) }
  let(:runner) { instance_double(Guard::Espect::Runner) }

  before do
    allow(Guard::Compat::UI).to receive(:info)
    allow(Guard::Espect::Deprecator).to receive(:warns_about_deprecated_options)
    allow(Guard::Espect::Runner).to receive(:new) { runner }
  end

  describe ".initialize" do
    it "instanciates with default and custom options" do
      guard_rspec = Guard::Espect.new(foo: :bar)
      expect(guard_rspec.options).to eq(default_options.merge(foo: :bar))
    end

    it "instanciates Runner with all default and custom options" do
      expect(Guard::Espect::Runner).to receive(:new).
        with(default_options.merge(foo: :bar))
      Guard::Espect.new(foo: :bar)
    end

    it "warns deprecated options" do
      expect(Guard::Espect::Deprecator).
        to receive(:warns_about_deprecated_options).
        with(default_options.merge(foo: :bar))

      Guard::Espect.new(foo: :bar)
    end
  end

  describe "#start" do
    it "doesn't call #run_all by default" do
      expect(plugin).to_not receive(:run_all)
      plugin.start
    end

    context "with all_on_start at true" do
      let(:options) { { all_on_start: true } }

      it "calls #run_all" do
        expect(plugin).to receive(:run_all)
        plugin.start
      end
    end
  end

  describe "#run_all" do
    Guard::TARGET_SPEC_FILE ||= '/some/cool/file'

    it "runs all specs via runner" do
      expect(runner).to receive(:run) { true }
      plugin.run_all
    end

    it "throws task_has_failed if runner return false" do
      allow(runner).to receive(:run) { false }
      expect(plugin).to receive(:throw).with(:task_has_failed)
      plugin.run_all
    end
  end

  describe "#reload" do
    it "reloads via runner" do
      expect(runner).to receive(:reload)
      plugin.reload
    end
  end

  describe "#run_on_modifications" do
    let(:paths) { %w(path1 path2) }
    it "runs all specs via runner" do
      expect(runner).to receive(:run).with(paths) { true }
      plugin.run_on_modifications(paths)
    end

    it "does nothing if paths empty" do
      expect(runner).to_not receive(:run)
      plugin.run_on_modifications([])
    end

    it "throws task_has_failed if runner return false" do
      allow(runner).to receive(:run) { false }
      expect(plugin).to receive(:throw).with(:task_has_failed)
      plugin.run_on_modifications(paths)
    end
  end
end
