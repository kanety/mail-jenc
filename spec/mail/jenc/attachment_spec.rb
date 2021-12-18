RSpec.describe Mail::Jenc do
  context 'enable rfc2231' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = true
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        body 'test'
      end
    end

    it 'uses rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      encoded = "utf-8''#{url_encode('添付ファイル')}"
      expect(mail.parts[1][:content_disposition].parameters['filename*0*']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end

    it 'does not use rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: false
      encoded = b_encode('添付ファイル.txt', 'utf-8')
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end
  end

  context 'disable rfc2231' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        body 'test'
      end
    end

    it 'uses rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: true
      encoded = "utf-8''#{url_encode('添付ファイル')}"
      expect(mail.parts[1][:content_disposition].parameters['filename*0*']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end

    it 'does not use rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: false
      encoded = b_encode('添付ファイル.txt', 'utf-8')
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(encoded)
      expect(mail.parts[1].encoded).to include(encoded)
    end
  end
end
