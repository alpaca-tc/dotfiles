kind=defined
names=parse
visibility=public

--- parse(raw_cookie) -> Hash

���å���ʸ�����ѡ������ޤ���

@param raw_cookie ���Υ��å�����ɽ��ʸ�������ꤷ�ޤ���

        �㡧
        cookies = CGI::Cookie.parse("raw_cookie_string")
          # { "name1" => cookie1, "name2" => cookie2, ... }

