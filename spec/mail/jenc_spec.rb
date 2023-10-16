RSpec.describe Mail::Jenc do
  it 'has a version number' do
    expect(Mail::Jenc::VERSION).not_to be nil
  end

  context 'config' do
    around(:example) do |example|
      val = Mail::Jenc.config.rfc2231
      example.run
      Mail::Jenc.config.rfc2231 = val
    end

    it 'sets global config via configure' do
      Mail::Jenc.configure do |config|
        config.rfc2231 = true
      end
      expect(Mail::Jenc.config.rfc2231).to eq(true)
    end

    it 'sets current config via block' do
      Mail::Jenc.with_config(rfc2231: true) do
        expect(Mail::Jenc.config.rfc2231).to eq(true)
      end
    end
  end
end
