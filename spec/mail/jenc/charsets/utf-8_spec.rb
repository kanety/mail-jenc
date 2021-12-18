RSpec.describe Mail::Jenc do
  context 'utf-8' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        from '差出人 <user1@example.com>'
        to '宛先 <user2@example.com>'
        subject 'メールの件名'
        body 'メールの本文'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
    end

    it 'encodes from address' do
      expect(mail.header[:from].value).to include('差出人')
      expect(mail.header[:from].decoded).to include('差出人')
    end

    it 'encodes to address' do
      expect(mail.header[:to].value).to include('宛先')
      expect(mail.header[:to].decoded).to include('宛先')
    end

    it 'encodes subject' do
      expect(mail.header[:subject].value).to include('メールの件名')
      expect(mail.header[:subject].decoded).to include('メールの件名')
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source).to include('メールの本文')
      expect(mail.parts[0].decoded).to include('メールの本文')
    end

    it 'encodes attachment body' do
      expect(mail.parts[1].body.raw_source).to include('添付ファイルの内容')
      expect(mail.parts[1].decoded).to include('添付ファイルの内容')
    end

    it 'encodes filename' do
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(b_encode('添付ファイル.txt', 'utf-8'))
      expect(mail.parts[1].filename).to include('添付ファイル.txt')
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end
end
