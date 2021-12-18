RSpec.describe Mail::Jenc::BEncoder do
  it 'encodes to one block' do
    encoded = Mail::Jenc::BEncoder.encode('テストです', 'iso-2022-jp')
    expect(encoded).to eq("=?ISO-2022-JP?B?GyRCJUYlOSVIJEckORsoQg==?=")
    expect(Mail::Encodings.b_value_decode(encoded)).to eq('テストです')
  end

  it 'encodes to multiple blocks' do
    encoded = Mail::Jenc::BEncoder.encode('長い文字列をエンコードするテストです', 'iso-2022-jp')
    expect(encoded).to eq("=?ISO-2022-JP?B?GyRCRDkkJEo4O3pOcyRyJSglcyUzITwlSSQ5JGsbKEI=?= =?ISO-2022-JP?B?GyRCJUYlOSVIJEckORsoQg==?=")
    expect(Mail::Encodings.value_decode(encoded)).to eq('長い文字列をエンコードするテストです')
  end
end
