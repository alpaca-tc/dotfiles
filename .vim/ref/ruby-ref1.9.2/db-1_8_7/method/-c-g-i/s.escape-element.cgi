kind=defined
names=escapeElement
visibility=public

--- escapeElement(string, *elements) -> String
��������ʹߤ˻��ꤷ��������ȤΥ�����������λ��Ȥ��ִ����ޤ���

@param string ʸ�������ꤷ�ޤ���

@param elements HTML ������̾�����İʾ���ꤷ�ޤ���ʸ���������ǻ��ꤹ�뤳�Ȥ����ޤ���

�㡧
        require "cgi"

        p CGI.escapeElement('<BR><A HREF="url"></A>', "A", "IMG")
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

        p CGI.escapeElement('<BR><A HREF="url"></A>', ["A", "IMG"])
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

