kind=added
names=multitask
visibility=private 

--- multitask(args){ ... } -> Rake::MultiTask

����������������¹Ԥ��륿������������ޤ���

Ϳ����줿������������¹Ԥ�����������Ǥ���

��:
  multitask :deploy => [:deploy_gem, :deploy_rdoc]

