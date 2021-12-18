RSpec.describe Mail::Jenc do
  context 'iso-2022-jp' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        from '差出人 <user1@example.com>'
        to '宛先 <user2@example.com>'
        subject 'メールの件名'
        body 'メールの本文'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
    end

    it 'encodes from address' do
      expect(mail.header[:from].value).to include(b_encode('差出人', 'iso-2022-jp'))
    end

    it 'encodes to address' do
      expect(mail.header[:to].value).to include(b_encode('宛先', 'iso-2022-jp'))
    end

    it 'encodes subject' do
      expect(mail.header[:subject].value).to include(b_encode('メールの件名', 'iso-2022-jp'))
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('iso-2022-jp')).to include(encode('メールの本文', 'iso-2022-jp'))
    end

    it 'encodes attachment body' do
      expect(mail.parts[1].body.raw_source).to include('添付ファイルの内容')
    end

    it 'encodes filename' do
      field = mail.parts[1][:content_disposition]
      expect(field.parameters['filename']).to include(b_encode('添付ファイル', 'iso-2022-jp'))
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end
end
