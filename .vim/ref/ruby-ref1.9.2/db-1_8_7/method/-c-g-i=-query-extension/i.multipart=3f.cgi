kind=defined
names=multipart?
visibility=public

--- multipart? -> bool

�ޥ���ѡ��ȥե�����ξ��ϡ������֤��ޤ���
�����Ǥʤ����ϡ������֤��ޤ���

       �㡧
       cgi = CGI.new
       if cgi.multipart?
         field1=cgi['field1'].read
       else
         field1=cgi['field1']
       end

