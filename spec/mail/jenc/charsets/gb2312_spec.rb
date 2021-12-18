RSpec.describe Mail::Jenc do
  context 'gb2312' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

    let(:mail) do
      Mail.new(charset: 'gb2312') do
        from '从 <user1@example.com>'
        to '目的地 <user2@example.com>'
        subject '测试电子邮件的主题'
        body '测试电子邮件的文本'
        add_file content: '附件的内容', filename: '附件.txt'
      end
    end

    it 'encodes from address' do
      expect(mail.header[:from].value).to include(b_encode('从', 'gb2312'))
      expect(mail.header[:from].decoded).to include('从')
    end

    it 'encodes to address' do
      expect(mail.header[:to].value).to include(b_encode('目的地', 'gb2312'))
      expect(mail.header[:to].decoded).to include('目的地')
    end

    it 'encodes subject' do
      expect(mail.header[:subject].value).to include(b_encode('测试电子邮件的主题', 'gb2312'))
      expect(mail.header[:subject].decoded).to include('测试电子邮件的主题')
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('gb2312')).to include(encode('测试电子邮件的文本', 'gb2312'))
      expect(mail.parts[0].decoded).to include('测试电子邮件的文本')
    end

    it 'encodes attachment body' do
      expect(mail.parts[1].body.raw_source).to include('附件的内容')
      expect(mail.parts[1].decoded).to include('附件的内容')
    end

    it 'encodes filename' do
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(b_encode('附件.txt', 'gb2312'))
      expect(mail.parts[1].filename).to include('附件.txt')
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end
end
