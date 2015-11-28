require "spec_helper"

describe Lita::Handlers::ZhihuDaily, lita_handler: true do
  it {is_expected.to route_command("zhihu").to(:fetch_zhihu)}

  it 'should get content form zhihu' do
    send_command('zhihu')
    #puts replies.last
    expect(replies.last).to include('question')
    expect(replies.last).to include('answer')
  end
end
