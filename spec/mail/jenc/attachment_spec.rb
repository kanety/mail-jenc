RSpec.describe Mail::Jenc do
  context 'enable rfc2231' do
    before do
      Mail::Jenc.enable!
      Mail::Jenc.config.rfc2231 = true
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        body 'test'
      end
    end

    it 'uses rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      expect(mail.parts[1][:content_disposition].parameters['filename*0*']).to include(url_encode('添付ファイル'))
      expect(mail.parts[1].filename).to include('添付ファイル.txt')
    end

    it 'does not use rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: false
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(b_encode('添付ファイル.txt', 'utf-8'))
      expect(mail.parts[1].filename).to include('添付ファイル.txt')
    end
  end

  context 'disable rfc2231' do
    before do
      Mail::Jenc.enable!
      Mail::Jenc.config.rfc2231 = false
    end

    let(:mail) do
      Mail.new(charset: 'utf-8') do
        body 'test'
      end
    end

    it 'uses rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: true
      expect(mail.parts[1][:content_disposition].parameters['filename*0*']).to include(url_encode('添付ファイル'))
      expect(mail.parts[1].filename).to include('添付ファイル.txt')
    end

    it 'does not use rfc2231 format' do
      mail.add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: false
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(b_encode('添付ファイル.txt', 'utf-8'))
      expect(mail.parts[1].filename).to include('添付ファイル.txt')
    end
  end
end
