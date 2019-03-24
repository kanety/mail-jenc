RSpec.describe Mail::Jenc do
  context 'iso-2022-jp' do
    before do
      Mail::Jenc.enable
    end

    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        from '差出人 <user1@example.com>'
        to '宛先 <user2@example.com>'
        subject 'テストメールの件名'
        body 'テストメールの本文'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
    end

    it 'encodes from address' do
      expect(mail[:from].value).to include(b_encode('差出人', 'iso-2022-jp'))
    end

    it 'encodes to address' do
      expect(mail[:to].value).to include(b_encode('宛先', 'iso-2022-jp'))
    end

    it 'encodes subject' do
      expect(mail[:subject].value).to include(b_encode('テストメールの件名', 'iso-2022-jp'))
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('iso-2022-jp')).to include(encode('テストメールの本文', 'iso-2022-jp'))
    end

    it 'encodes filename' do
      field = mail.parts[1][:content_disposition]
      expect(field.parameters['filename*0*']).to include("iso-2022-jp''#{url_encode('添付ファイル', 'iso-2022-jp').slice(0, 20)}")
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end

  context 'cp50221' do
    before do
      Mail::Jenc.enable
    end

    let(:text) do
      '①②③ｱｲｳｴｵ―∥￣－～'
    end

    let(:mail) do
      _text = text
      Mail.new(charset: 'iso-2022-jp') do
        from "#{_text} <user1@example.com>"
        to "#{_text} <user1@example.com>"
        subject _text
        body _text
        add_file content: _text, filename: "#{_text}.txt"
      end
    end

    it 'encodes from address' do
      expect(mail[:from].value).to include(b_encode(text, 'cp50221'))
    end

    it 'encodes to address' do
      expect(mail[:to].value).to include(b_encode(text, 'cp50221'))
    end

    it 'encodes subject' do
      expect(mail[:subject].value).to include(b_encode(text, 'cp50221'))
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('cp50221')).to include(encode(text, 'cp50221'))
    end

    it 'encodes filename' do
      field = mail.parts[1][:content_disposition]
      expect(field.parameters['filename*0*']).to include("iso-2022-jp''#{url_encode(text, 'cp50221').slice(0, 20)}")
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end

  context 'utf-8' do
    before do
      Mail::Jenc.enable
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        from '差出人 <user1@example.com>'
        to '宛先 <user2@example.com>'
        subject 'テストメールの件名'
        body 'テストメールの本文'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
    end

    it 'encodes from address' do
      expect(mail[:from].value).to include('差出人')
    end

    it 'encodes to address' do
      expect(mail[:to].value).to include('宛先')
    end

    it 'encodes subject' do
      expect(mail[:subject].value).to include('テストメールの件名')
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source).to include('テストメールの本文')
    end

    it 'encodes attachment' do
      expect(mail.parts[1].body.raw_source).to include('添付ファイルの内容')
    end

    it 'encodes filename' do
      field = mail.parts[1][:content_disposition]
      expect(field.parameters['filename*0*']).to include(url_encode('添付ファイル'))
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end

  context 'disable' do
    before do
      Mail::Jenc.disable
    end

    let(:mail) do
      Mail.new(charset: 'iso2022-jp') do
        subject 'テストメールの件名'
        body 'テストメールの本文'
      end
    end

    it 'does not encode subject' do
      expect(mail[:subject].value).to include('テストメールの件名')
    end
  end

  context 'disable rfc2231' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
    end

    it 'encodes filename' do
      field = mail.parts[0][:content_disposition]
      expect(field.parameters['filename']).to include(b_encode('添付ファイル'))
    end
  end
end
