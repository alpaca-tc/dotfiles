kind=added
names=sh
visibility=public 

--- sh(*cmd){|result, status| ... }

Ϳ����줿���ޥ�ɤ�¹Ԥ��ޤ���

Ϳ����줿������ʣ���ξ�硢��������ͳ���ʤ��ǥ��ޥ�ɤ�¹Ԥ��ޤ���

@param cmd �����β��˴ؤ��Ƥ� [[m:Kernel.#exec]] �򻲾Ȥ��Ƥ���������


��:
   sh %{ls -ltr}
   
   sh 'ls', 'file with spaces'
   
   # check exit status after command runs
   sh %{grep pattern file} do |ok, res|
     if ! ok
       puts "pattern not found (status = #{res.exitstatus})"
     end
   end

@see [[m:Kernel.#exec]], [[m:Kernel.#system]]


