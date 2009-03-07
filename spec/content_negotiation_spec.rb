require File.dirname(__FILE__) + '/spec_helper.rb'

describe ActionController::Base, 'parsing the HTTP_ACCEPT_LANGUAGE header' do

  before do
    @request = mock('request')
    @controller = ActionController::Base.new
    @controller.stub!(:request).and_return(@request)
  end

  describe 'with client_accepted_languages' do

    it 'should pass the header on to the parsing function' do
      @request.stub!(:env).and_return({'HTTP_ACCEPT_LANGUAGE' => 'foo'})
      @controller.should_receive(:parse_http_accept_language_header).with('foo').and_return('bar')
      @controller.send(:client_accepted_languages).should == 'bar'
    end

  end

  describe 'with parse_http_accept_language_header' do

    it "should return the empty array if no HTTP_ACCEPT_LANGUAGE is nil" do
      @controller.send(:parse_http_accept_language_header, nil).should == []
    end

    it "should return the empty array if no HTTP_ACCEPT_LANGUAGE is empty string" do
      @controller.send(:parse_http_accept_language_header, '').should == []
    end

    it "should be able to handle simple identifier" do
      @controller.send(:parse_http_accept_language_header, 'de').should == [:de]
    end

    it "should be able to handle complex identifier" do
      @controller.send(:parse_http_accept_language_header, 'de-de').should == [:de]
    end

    it "should be able to handle complex identifier with quality values" do
      @controller.send(:parse_http_accept_language_header, 'de-de,de;q=0.8,en-us;q=0.5,en;q=0.3').should == [:de, :en]
    end

  end

end
