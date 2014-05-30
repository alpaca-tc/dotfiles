require '<%= variables['gemname'] %>/version'

describe '<%= variables['gem_camelname'] %>::Version' do
  subject { <%= variables['gem_camelname'] %>::Version }
  it { is_expected.to match /\d+\.\d+\.\d+/ }
end
