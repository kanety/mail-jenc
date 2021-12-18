RSpec.describe Mail::Jenc::RFC2231Encoder do
  it 'encodes to one block' do
    encoded = Mail::Jenc::RFC2231Encoder.encode_to_hash('テストです', 'iso-2022-jp')
    expect(encoded).to eq(
      "filename*"=>"iso-2022-jp''%1B%24%42%25%46%25%39%25%48%24%47%24%39%1B%28%42"
    )
    expect(Mail::ParameterHash.new(encoded)[:filename]).to eq('テストです')
  end

  it 'encodes to multiple blocks' do
    encoded = Mail::Jenc::RFC2231Encoder.encode_to_hash('長い文字列をエンコードするテストです', 'iso-2022-jp')
    expect(encoded).to eq(
      "filename*0*" => "iso-2022-jp''%1B%24%42%44%39%24%24%4A%38%3B%7A%4E%73%24%72%25%28%25",
      "filename*1*" => "%73%25%33%21%3C%25%49%24%39%24%6B%25%46%25%39%25%48%24%47%24%39",
      "filename*2*" => "%1B%28%42"
    )
    expect(Mail::ParameterHash.new(encoded)[:filename]).to eq('長い文字列をエンコードするテストです')
  end
end
