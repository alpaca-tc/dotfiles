kind=defined
names=sub
visibility=public 

--- sub(pattern, replace) -> Rake::FileList

���Ȥ˴ޤޤ��ե�����ꥹ�ȤΤ��줾��Υ���ȥ���Ф��� [[m:String#sub]] ��¹Ԥ���
��̤򿷤��� [[c:Rake::FileList]] �Ȥ����֤��ޤ���

��:
   FileList['a.c', 'b.c'].sub(/\.c$/, '.o')  => ['a.o', 'b.o']


