RSpec.describe Mail::Jenc do
  context 'attachment' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    it 'uses rfc2231 format if true' do
      mail = Mail.new(charset: 'utf-8') do
        body 'test'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: true
      end
      encoded = "utf-8''#{url_encode('添付ファイル')}"
      expect(mail.parts[1][:content_disposition].parameters['filename*0*']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end

    it 'does not use rfc2231 format if false' do
      mail = Mail.new(charset: 'utf-8') do
        body 'test'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: false
      end
      encoded = b_encode('添付ファイル')
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end

    it 'refers global option for rfc2231' do
      Mail::Jenc.rfc2231 = true
      mail = Mail.new(charset: 'utf-8') do
        body 'test'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
      encoded = "utf-8''#{url_encode('添付ファイル')}"
      expect(mail.parts[1][:content_disposition].parameters['filename*0*']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end
  end
end
