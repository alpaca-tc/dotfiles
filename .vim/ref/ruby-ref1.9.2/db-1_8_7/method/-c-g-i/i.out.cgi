kind=defined
names=out
visibility=public

--- out(options = "text/html") { .... }

HTTP �إå��ȡ��֥�å���Ϳ����줿ʸ�����ɸ����Ϥ˽��Ϥ��ޤ���

HEAD�ꥯ������ (REQUEST_METHOD == "HEAD") �ξ��� HTTP �إå��Τߤ���Ϥ��ޤ���

charset �� "iso-2022-jp"��"euc-jp"��"shift_jis" �Τ����줫��
�������ʸ���󥨥󥳡��ǥ��󥰤�ư�Ѵ�����language �� "ja"�ˤ��ޤ���

@param options [[c:Hash]] ��ʸ����� HTTP �إå����������뤿��ξ������ꤷ�ޤ���

�㡧
        cgi = CGI.new
        cgi.out{ "string" }
          # Content-Type: text/html
          # Content-Length: 6
          #
          # string

        cgi.out("text/plain"){ "string" }
          # Content-Type: text/plain
          # Content-Length: 6
          #
          # string

        cgi.out({"nph"        => true,
                 "status"     => "OK",  # == "200 OK"
                 "server"     => ENV['SERVER_SOFTWARE'],
                 "connection" => "close",
                 "type"       => "text/html",
                 "charset"    => "iso-2022-jp",
                   # Content-Type: text/html; charset=iso-2022-jp
                 "language"   => "ja",
                 "expires"    => Time.now + (3600 * 24 * 30),
                 "cookie"     => [cookie1, cookie2],
                 "my_header1" => "my_value",
                 "my_header2" => "my_value"}){ "string" }

@see [[m:CGI#header]]

