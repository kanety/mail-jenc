RSpec.describe Mail::Jenc do
  context 'attachment' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    it 'uses rfc2231 format if true' do
      mail = Mail.new(charset: 'utf-8') do
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: true
      end
      field = mail.parts[0][:content_disposition]
      expect(field.parameters['filename*0*']).to include("utf-8''#{url_encode('添付ファイル')}")
    end

    it 'does not use rfc2231 format if false' do
      mail = Mail.new(charset: 'utf-8') do
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt', rfc2231: false
      end
      field = mail.parts[0][:content_disposition]
      expect(field.parameters['filename']).to include(b_encode('添付ファイル'))
    end

    it 'refers global option for rfc2231' do
      Mail::Jenc.rfc2231 = true
      mail = Mail.new(charset: 'utf-8') do
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
      field = mail.parts[0][:content_disposition]
      expect(field.parameters['filename*0*']).to include("utf-8''#{url_encode('添付ファイル')}")
    end
  end
end
