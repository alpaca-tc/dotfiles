kind=defined
names=params
visibility=public

--- params -> Hash

�ѥ�᡼�����Ǽ�����ϥå�����֤��ޤ���

�ե����फ�����Ϥ��줿�ͤ䡢URL�������ޤ줿 QUERY_STRING �Υѡ�����̤μ����ʤɤ˻��Ѥ��ޤ���

      cgi = CGI.new
      cgi.params['developer']     # => ["Matz"] (Array)
      cgi.params['developer'][0]  # => "Matz"
      cgi.params['']              # => nil

