kind=defined
names=unescapeElement
visibility=public

--- unescapeElement(string, *element) -> String

��������Ǥ�����HTML���������פ����᤹��

@param string ʸ�������ꤷ�ޤ���

@param elements HTML ������̾�����İʾ���ꤷ�ޤ���ʸ���������ǻ��ꤹ�뤳�Ȥ����ޤ���

�㡧
        require "cgi"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', "A", "IMG")
          # => "&lt;BR&gt;<A HREF="url"></A>"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', %w(A IMG))
          # => "&lt;BR&gt;<A HREF="url"></A>"

