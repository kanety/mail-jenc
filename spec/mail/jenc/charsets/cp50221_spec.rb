RSpec.describe Mail::Jenc do
  context 'cp50221' do
    before do
      Mail::Jenc.enable
      Mail::Jenc.rfc2231 = false
    end

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
    end

    it 'encodes to address' do
      expect(mail.header[:to].value).to include(b_encode("ｱﾃｻｷ", 'iso-2022-jp'))
    end

    it 'encodes subject' do
      expect(mail.header[:subject].value).to include(b_encode("①ｹﾝﾒｲ―∥￣－～", 'iso-2022-jp'))
    end

    it 'encodes body' do
      expect(mail.parts[0].body.raw_source.dup.force_encoding('iso-2022-jp')).to include(encode("ﾎﾝﾌﾞﾝ", 'iso-2022-jp'))
    end

    it 'encodes attachment body' do
      expect(mail.parts[1].body.raw_source).to include('ﾃﾝﾌﾟﾌｧｲﾙﾉﾅｲﾖｳ')
    end

    it 'encodes filename' do
      field = mail.parts[1][:content_disposition]
      expect(field.parameters['filename']).to include(b_encode("①ﾃﾝﾌﾟﾌｧｲﾙ.txt", 'iso-2022-jp'))
    end

    it 'builds ascii mail' do
      expect(mail.encoded.ascii_only?).to eq(true)
    end
  end
end
