RSpec.describe Mail::Jenc do
  before do
    Mail::Jenc.enable!
    Mail::Jenc.config.rfc2231 = false
  end

  context 'unstructured field' do
    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        from '差出人 <user1@example.com>'
        to '宛先 <user2@example.com>'
        subject '件名'
        header['X-Test'] = 'ヘッダ'
        header['X-Mailer'] = 'Mailer'
      end
    end

    it 'encodes unstructured field' do
      expect(mail.header[:from].value).to include(b_encode('差出人', 'iso-2022-jp'))
      expect(mail.header[:from].decoded).to include('差出人')
      expect(mail.header[:to].value).to include(b_encode('宛先', 'iso-2022-jp'))
      expect(mail.header[:to].decoded).to include('宛先')
      expect(mail.header[:subject].value).to include(b_encode('件名', 'iso-2022-jp'))
      expect(mail.header[:subject].decoded).to include('件名')
      expect(mail.header['X-Test'].value).to include(b_encode('ヘッダ', 'iso-2022-jp'))
      expect(mail.header['X-Test'].decoded).to include('ヘッダ')
      expect(mail.header['X-Mailer'].value).to include('Mailer')
      expect(mail.header['X-Mailer'].decoded).to include('Mailer')
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end

    it 'copies headers' do
      copy = Mail.new(charset: 'iso-2022-jp')
      mail.header.fields.each do |field|
        copy.header[field.name] = field.value
      end
      expect(copy.header[:from].value).to include(b_encode('差出人', 'iso-2022-jp'))
      expect(copy.header[:from].decoded).to include('差出人')
      expect(copy.header[:to].value).to include(b_encode('宛先', 'iso-2022-jp'))
      expect(copy.header[:to].decoded).to include('宛先')
      expect(copy.header[:subject].value).to include(b_encode('件名', 'iso-2022-jp'))
      expect(copy.header[:subject].decoded).to include('件名')
      expect(copy.header['X-Test'].value).to include(b_encode('ヘッダ', 'iso-2022-jp'))
      expect(copy.header['X-Test'].decoded).to include('ヘッダ')
      expect(copy.header['X-Mailer'].value).to include('Mailer')
      expect(copy.header['X-Mailer'].decoded).to include('Mailer')
      expect(copy.encoded.ascii_only?).to eq(true)
    end
  end
end
