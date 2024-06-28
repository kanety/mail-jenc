RSpec.describe Mail::Jenc::SmtpEnvelopePatch do
  before do
    Mail::Jenc.enable!
  end

  let(:mail) do
    Mail.new(charset: 'utf-8') do
      subject 'test'
      body 'test'
    end
  end

  context 'address instance' do
    let(:address_struct) do
      Struct.new('Address', :address, :options) do
        def to_s
          address
        end
      end
    end

    let(:from) do
      address_struct.new('from@domain', 'NOTIFY=SUCCESS,FAILURE')
    end

    let(:to) do
      address_struct.new('to@domain', 'NOTIFY=SUCCESS,FAILURE')
    end

    it 'keeps address instance' do
      mail.smtp_envelope_from [from]
      mail.smtp_envelope_to [to]
      envelope = Mail::SmtpEnvelope.new(mail)
      expect(envelope.from).to eq(mail.smtp_envelope_from)
      expect(envelope.to).to eq(mail.smtp_envelope_to)
    end
  end

  context 'keeps address string' do
    let(:from) do
      'from@domain'
    end

    let(:to) do
      'to@domain'
    end

    it 'assigns address string' do
      mail.smtp_envelope_from [from]
      mail.smtp_envelope_to [to]
      envelope = Mail::SmtpEnvelope.new(mail)
      expect(envelope.from).to eq(mail.smtp_envelope_from)
      expect(envelope.to).to eq(mail.smtp_envelope_to)
    end
  end
end
