RSpec.describe Mail::Jenc do
  context 'unstructured field' do
    before do
      Mail::Jenc.enable
    end

    let(:mail) do
      mail = Mail.new(charset: 'iso-2022-jp')
      mail.header['X-Sender'] = '差出人 <user1@example.com>'
      mail.header['X-Mailer'] = 'Mailer'
      mail
    end

    it 'encodes unstructured field' do
      expect(mail.header['X-Sender'].value).to include(b_encode('差出人', 'iso-2022-jp'))
    end

    it 'does not encode unstructured field with us-ascii' do
      expect(mail.header['X-Mailer'].value).to include('Mailer')
    end
  end
end
