kind=defined
names=exclude
visibility=public 

--- exclude(*patterns){|entry| ... } -> self

���Ȥ���������٤��ե�����̾�Υѥ�����򼫿Ȥν����ꥹ�Ȥ���Ͽ���ޤ���

�ѥ�����Ȥ�������ɽ��������֥ѥ�����ʸ���󤬻��Ѳ�ǽ�Ǥ���
����˥֥�å���Ϳ����줿���ϡ��֥�å���ɾ�����ƿ��ˤʤä�����ȥ�������ޤ���

����֥ѥ�����ϥե����륷���ƥ���Ф���Ÿ������ޤ���
�⤷���ե����륷���ƥ��¸�ߤ��ʤ��ե����������Ū�˥ꥹ�Ȥ��ɲä�����硢
����֥ѥ�����ǤϤ��Υե������ꥹ�Ȥ��������ޤ���

��:
  FileList['a.c', 'b.c'].exclude("a.c") # => ['b.c']
  FileList['a.c', 'b.c'].exclude(/^a/)  # => ['b.c']
  
  # If "a.c" is a file, then ...
  FileList['a.c', 'b.c'].exclude("a.*") # => ['b.c']
  
  # If "a.c" is not a file, then ...
  FileList['a.c', 'b.c'].exclude("a.*") # => ['a.c', 'b.c']

