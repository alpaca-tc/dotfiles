kind=defined
names=unescapeHTML
visibility=public

--- unescapeHTML(string) -> String
Ϳ����줿ʸ������μ��λ��ȤΤ�����&amp; &gt; &lt; &quot;
�ȿ��ͻ��꤬����Ƥ����� (&#0ffff �ʤ�) �򸵤�ʸ������ִ����ޤ���

@param string ʸ�������ꤷ�ޤ���

        require "cgi"

        p CGI.unescapeHTML("3 &gt; 1")   #=> "3 > 1"

