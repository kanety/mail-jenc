RSpec.describe Mail::Jenc::ContentTypeFieldPatch do
  before do
    Mail::Jenc.enable
  end

  context 'us-ascii' do
    let(:mail) do
      Mail.new(charset: 'us-ascii') do
        body 'body'
        add_file content: 'content', filename: 'filename.txt'
      end
    end

    it 'removes charset from header' do
      expect(mail.header[:content_type].parameters.key?(:charset)).to eq(false)
    end

    it 'removes charset from attachment' do
      expect(mail.attachments[0].header[:content_type].parameters.key?(:charset)).to eq(false)
    end
  end

  context 'utf-8' do
    let(:mail) do
      Mail.new(charset: 'utf-8') do
        body '本文'
        add_file content: '添付ファイルの内容', filename: '添付ファイル.txt'
      end
    end

    it 'removes charset from header' do
      expect(mail.header[:content_type].parameters.key?(:charset)).to eq(false)
    end

    it 'removes charset from attachment' do
      expect(mail.attachments[0].header[:content_type].parameters.key?(:charset)).to eq(false)
    end
  end
end
