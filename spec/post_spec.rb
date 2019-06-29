

describe "post" do
  context "when new user" do
    before do
      @new_user = build(:user).to_hash

      @result = HTTParty.post(
        "http://192.168.99.100:3001/user",  
      #"http://localhost:3001/user",
        body: @new_user.to_json,
        headers: {
          "Content-Type" => "application/json",
        },
      )
    end

    it { expect(@result.response.code).to eql "200" }
  end
end
