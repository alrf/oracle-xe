
require 'serverspec'

set :backend, :exec

describe "Oracle server" do
  it "is listener on port 1521" do
    expect(port(1521)).to be_listening
  end
  describe command('pgrep -lf tnslsnr') do
   its(:stdout) { should match /tnslsnr LISTENER/ }
  end
end

describe "SQL data exist" do
  describe command('su - oracle -c "sqlplus -s system/password <<EOF
    set lin 1000
    set pages 0
    set trims on
    set tab off
    select * from oratest;
    exit
    EOF
  "') do
    its(:stdout) { should match /2 b/ }
  end
end
