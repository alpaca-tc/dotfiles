kind=added
names=namespace
visibility=private 

--- namespace(name = nil){ ... } -> Rake::NameSpace

������̾�����֤�������ޤ���

Ϳ����줿�֥�å���ɾ������֤ϡ�����̾�����֤���Ѥ��ޤ���

��:
   ns = namespace "nested" do
     task :run
   end
   task_run = ns[:run] # find :run in the given namespace.

@see [[m:Rake::TaskManager#in_namespace]]

