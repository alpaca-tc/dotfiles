kind=defined
names=a
visibility=public

--- a(href = "") -> String
--- a(href = ""){ ... } -> String

a ���Ǥ��������ޤ���

�֥�å���Ϳ����ȡ��֥�å���ɾ��������̤����Ƥˤʤ�ޤ���

@param href ʸ�������ꤷ�ޤ���°����ϥå���ǻ��ꤹ�뤳�Ȥ�Ǥ��ޤ���
       
��:
  a("http://www.example.com") { "Example" }
    # => "<A HREF=\"http://www.example.com\">Example</A>"

  a("HREF" => "http://www.example.com", "TARGET" => "_top") { "Example" }
    # => "<A HREF=\"http://www.example.com\" TARGET=\"_top\">Example</A>"

