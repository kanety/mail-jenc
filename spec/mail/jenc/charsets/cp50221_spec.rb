RSpec.describe Mail::Jenc do
  before do
    Mail::Jenc.enable!
    Mail::Jenc.config.rfc2231 = false
  end

  context 'cp50221' do
    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        from "ｻｼﾀﾞｼﾆﾝ <user1@example.com>"
        to "ｱﾃｻｷ <user1@example.com>"
        subject "①ｹﾝﾒｲ―∥￣－～"
        body "ﾎﾝﾌﾞﾝ"
        add_file content: "ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ", filename: "①ﾃﾝﾌﾟﾌｧｲﾙ.txt"
      end
    end

    it 'encodes from address' do
      expect(mail.header[:from].value).to include(b_encode("ｻｼﾀﾞｼﾆﾝ", 'iso-2022-jp'))
      mail.header[:from].value = mail.header[:from].value.sub('ISO-2022-JP', 'CP50221')
      expect(mail.header[:from].decoded).to include("ｻｼﾀﾞｼﾆﾝ")
    end

    it 'encodes to address' do
      expect(mail.header[:to].value).to include(b_encode("ｱﾃｻｷ", 'iso-2022-jp'))
      mail.header[:to].value = mail.header[:to].value.sub('ISO-2022-JP', 'CP50221')
      expect(mail.header[:to].decoded).to include("ｱﾃｻｷ")
    end

    it 'encodes subject' do
      expect(mail.header[:subject].value).to include(b_encode("①ｹﾝﾒｲ―∥￣－～", 'iso-2022-jp'))
      mail.header[:subject].value = mail.header[:subject].value.sub('ISO-2022-JP', 'CP50221')
      expect(mail.header[:subject].decoded).to include("①ｹﾝﾒｲ―∥￣－～")
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('iso-2022-jp')).to include(encode("ﾎﾝﾌﾞﾝ", 'iso-2022-jp'))
      mail.parts[0].charset = 'cp50221'
      expect(mail.parts[0].decoded).to include("ﾎﾝﾌﾞﾝ")
    end

    it 'encodes attachment body' do
      expect(mail.parts[1].body.raw_source).to include('ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ')
      expect(mail.parts[1].decoded).to include('ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ')
    end

    it 'encodes filename' do
      expect(mail.parts[1][:content_disposition].parameters['filename']).to include(b_encode("①ﾃﾝﾌﾟﾌｧｲﾙ.txt", 'iso-2022-jp'))
      mail.parts[1][:content_disposition].value = mail.parts[1][:content_disposition].value.sub('ISO-2022-JP', 'CP50221')
      expect(mail.parts[1].filename).to include("①ﾃﾝﾌﾟﾌｧｲﾙ.txt")
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end

  context 'cp50221 with multipart/alternative' do
    let(:mail) do
      Mail.new(charset: 'iso-2022-jp') do
        text_part do
          content_type %Q|text/plain; charset="iso-2022-jp"|
          body "ﾎﾝﾌﾞﾝ"
        end
        html_part do
          content_type %Q|text/plain; charset="iso-2022-jp"|
          body "ﾎﾝﾌﾞﾝ"
        end
        add_file content: "ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ", filename: "①ﾃﾝﾌﾟﾌｧｲﾙ.txt"
      end
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('iso-2022-jp')).to include(encode("ﾎﾝﾌﾞﾝ", 'iso-2022-jp'))
      mail.parts[0].charset = 'cp50221'
      expect(mail.parts[0].decoded).to include("ﾎﾝﾌﾞﾝ")
      expect(mail.parts[1].body.raw_source.dup.force_encoding('iso-2022-jp')).to include(encode("ﾎﾝﾌﾞﾝ", 'iso-2022-jp'))
      mail.parts[1].charset = 'cp50221'
      expect(mail.parts[1].decoded).to include("ﾎﾝﾌﾞﾝ")
    end

    it 'encodes attachment body' do
      expect(mail.parts[2].body.raw_source).to include('ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ')
      expect(mail.parts[2].decoded).to include('ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ')
    end

    it 'encodes filename' do
      expect(mail.parts[2][:content_disposition].parameters['filename']).to include(b_encode("①ﾃﾝﾌﾟﾌｧｲﾙ.txt", 'iso-2022-jp'))
      mail.parts[2][:content_disposition].value = mail.parts[2][:content_disposition].value.sub('ISO-2022-JP', 'CP50221')
      expect(mail.parts[2].filename).to include("①ﾃﾝﾌﾟﾌｧｲﾙ.txt")
    end
  end
end
