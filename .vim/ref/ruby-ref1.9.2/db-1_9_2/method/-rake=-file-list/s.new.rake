kind=defined
names=new
visibility=public

--- new(*patterns){|self| ... }

Ϳ����줿�ѥ�������Ȥˤ��Ƽ��Ȥ��������ޤ���

�֥�å���Ϳ�����Ƥ�����ϡ����Ȥ�֥�å��ѥ�᡼���Ȥ��ƥ֥�å���ɾ�����ޤ���

@param patterns �ѥ��������ꤷ�ޤ���

��:
   file_list = FileList.new('lib/**/*.rb', 'test/test*.rb')
   
   pkg_files = FileList.new('lib/**/*') do |fl|
     fl.exclude(/\bCVS\b/)
   end


