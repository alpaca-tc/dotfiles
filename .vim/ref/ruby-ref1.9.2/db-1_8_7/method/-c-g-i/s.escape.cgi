kind=defined
names=escape
visibility=public

--- escape(string) -> String

Ϳ����줿ʸ����� URL ���󥳡��ɤ���ʸ����򿷤����������֤��ޤ���

@param string URL ���󥳡��ɤ�����ʸ�������ꤷ�ޤ���

��:
        require "cgi"

        p CGI.escape('@##')   #=> "%40%23%23"

        url = "http://www.example.com/register?url=" + 
          CGI.escape('http://www.example.com/index.rss')
        p url
        #=> "http://www.example.com/register?url=http%3A%2F%2Fwww.example.com%2Findex.rss"

