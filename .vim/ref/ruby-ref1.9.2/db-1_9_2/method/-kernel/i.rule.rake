kind=added
names=rule
visibility=private 

--- rule(*args){|t| ... } -> Rake::Task

��ưŪ�˺������륿�����Τ���Υ롼���������ޤ���

@param args �롼���Ϳ����ѥ�᡼������ꤷ�ޤ���

��:
  rule '.o' => '.c' do |t|
    sh %{cc -o #{t.name} #{t.source}}
  end

