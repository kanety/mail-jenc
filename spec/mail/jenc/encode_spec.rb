RSpec.describe Mail::Jenc do
  context 'enabled' do
    before do
      Mail::Jenc.enable!
    end

    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        subject '件名'
        body '本文'
      end
    end

    it 'encodes subject' do
      expect(mail.header[:subject].value).not_to include('件名')
    end
  end

  context 'disable' do
    before do
      Mail::Jenc.disable!
    end

    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        subject '件名'
        body '本文'
      end
    end

    it 'does not encode subject' do
      expect(mail.header[:subject].value).to include('件名')
    end
  end
end
