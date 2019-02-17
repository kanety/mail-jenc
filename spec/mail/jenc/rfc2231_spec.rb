RSpec.describe Mail::Jenc::RFC2231Encoder do
  it 'encodes short string into one line' do
    expect(Mail::Jenc::RFC2231Encoder.encode_to_hash('テストです', charset: 'utf-8')).to eq(
      "filename*" => "utf-8''%E3%83%86%E3%82%B9%E3%83%88%E3%81%A7%E3%81%99"
    )
  end

  it 'encodes long string into multiple lines' do
    expect(Mail::Jenc::RFC2231Encoder.encode_to_hash('長い文字列をエンコードするテストです', charset: 'utf-8')).to eq(
      "filename*0*" => "utf-8''%E9%95%B7%E3%81%84%E6%96%87%E5%AD%97%E5%88%97%E3%82%92%E3%82",
      "filename*1*" => "%A8%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%89%E3%81%99%E3%82%8B%E3%83",
      "filename*2*" => "%86%E3%82%B9%E3%83%88%E3%81%A7%E3%81%99"
    )
  end
end
