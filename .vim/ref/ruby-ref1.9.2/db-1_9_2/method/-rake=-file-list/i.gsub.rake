kind=defined
names=gsub
visibility=public 

--- gsub(pattern, replace) -> Rake::FileList

���Ȥ˴ޤޤ��ե�����ꥹ�ȤΤ��줾��Υ���ȥ���Ф��� [[m:String#gsub]] ��¹Ԥ���
��̤򿷤��� [[c:Rake::FileList]] �Ȥ����֤��ޤ���

 ��:
   FileList['lib/test/file', 'x/y'].gsub(/\//, "\\") # => ['lib\\test\\file', 'x\\y']

