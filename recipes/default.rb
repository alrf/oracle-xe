#
# Cookbook Name:: oracle-xe-my
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'oracle-xe'

package ['gcc']


#
# This variables should be set!
#
ENV['ORACLE_HOME'] = "/u01/app/oracle/product/11.2.0/xe"
ENV['LD_LIBRARY_PATH'] = "/u01/app/oracle/product/11.2.0/xe/lib"


gem_package 'ruby-oci8'

ruby_block "initialize" do
  block do
    require 'oci8'
    conn = OCI8.new('system', "#{node['oracle-xe']['oracle-password']}", '//127.0.0.1:1521/XE')
    conn.exec("CREATE TABLE #{node['oracle-xe']['oracle-table']} (a number, b varchar2(10))")
    conn.exec("INSERT INTO #{node['oracle-xe']['oracle-table']}(a,b) values (1,'a')")
    conn.exec("INSERT INTO #{node['oracle-xe']['oracle-table']}(a,b) values (2,'b')")
    conn.exec("CREATE USER #{node['oracle-xe']['test-user']} IDENTIFIED BY #{node['oracle-xe']['test-password']}")
    conn.exec("GRANT CONNECT TO #{node['oracle-xe']['test-user']}")
    conn.exec("GRANT SELECT on system.#{node['oracle-xe']['oracle-table']} TO #{node['oracle-xe']['test-user']}")
    conn.commit
    conn.logoff
  end
end
