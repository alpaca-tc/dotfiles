kind=defined
names=new
visibility=public

--- new(config = {}, *options)    -> WEBrick::CGI

WEBrick::CGI ���֥������Ȥ��������Ƥ������ޤ���

@param config �������¸�����ϥå������ꤷ�ޤ���

config ��ͭ���ʥ����Ȥ����ͤϰʲ��ΤȤ���Ǥ���
�����Ϥ��٤� [[c:Symbol]] ���֥������ȤǤ���

: :ServerName     
 ������̾��ʸ����ǻ��ꤷ�ޤ����ǥե���ȤǤ� ENV["SERVER_SOFTWARE"] ���Ȥ��ޤ���
 ENV["SERVER_SOFTWARE"] �� nil �ξ��� "null" ���Ȥ��ޤ���
: :HTTPVersion
 HTTP �С������� [[c:WEBrick::HTTPVersion]] ���֥������Ȥǻ��ꤷ�ޤ���
 �ǥե���ȤǤ� ENV["SERVER_PROTOCOL"] �� HTTP �С�����󤬻Ȥ��ޤ��� 
 ENV["SERVER_PROTOCOL"] �� nil �ξ�� HTTP �С������� 1.0 �Ǥ���
: :NPH            
 NPH ������ץȤȤ��Ƽ¹Ԥ������� true ����ꤷ�ޤ��������Ǥʤ����� false ����ꤷ�ޤ���
 �ǥե���Ȥ� false �Ǥ���
: :Logger 
 �����뤿��� [[c:WEBrick::BasicLog]] ���֥������Ȥ���ꤷ�ޤ����ǥե���ȤǤ�ɸ�२�顼���Ϥ�
 �������Ϥ���ޤ���
: :RequestTimeout
 �ꥯ�����Ȥ��ɤ߹�����Υ����ॢ���Ȥ��äǻ��ꤷ�ޤ����ǥե���Ȥ� 30 �äǤ���
: :Escape8bitURI
 �����ͤ� true �ξ�硢���饤����Ȥ���Υꥯ������ URI �˴ޤޤ�� 8bit �ܤ�Ω�ä�ʸ���򥨥������פ��ޤ���
 �ǥե���Ȥ� false �Ǥ��� 

@param options �桼�������Υ��饹��Ѿ����ƺ����������饹�� @options �Ȥ������󥹥����ѿ��Ȥ��ƻ��ѤǤ��ޤ���

