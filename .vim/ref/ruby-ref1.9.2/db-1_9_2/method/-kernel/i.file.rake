kind=added
names=file
visibility=private 

--- file(*args){ ... } -> Rake::FileTask

�ե����륿������������ޤ���

@param args �ե�����̾�Ȱ�¸�ե�����̾����ꤷ�ޤ���

��:
   file "config.cfg" => ["config.template"] do
     open("config.cfg", "w") do |outfile|
       open("config.template") do |infile|
         while line = infile.gets
           outfile.puts line
         end
       end
     end
   end

@see [[m:Rake::Task.define_task]]

