kind=defined
names=service
visibility=public

--- service(req, res)     -> ()

���ꤵ�줿 [[c:WEBrick::HTTPRequest]] ���֥������� req �� [[m:WEBrick::HTTPRequest#request_method]] �˱����ơ�
���Ȥ� do_GET, do_HEAD, do_POST, do_OPTIONS... �����줫�Υ᥽�åɤ� req �� res ������Ȥ��ƸƤӤޤ���

�ä���ͳ��̵���¤� [[c:WEBrick::CGI]] �Υ��֥��饹�����Υ᥽�åɤ��������ɬ�פϤ���ޤ���

@param req ���饤����Ȥ���Υꥯ�����Ȥ�ɽ�� [[c:WEBrick::HTTPRequest]] ���֥������ȤǤ���

@param res ���饤����ȤؤΥ쥹�ݥ󥹤�ɽ�� [[c:WEBrick::HTTPResponse]] ���֥������ȤǤ���

@raise WEBrick::HTTPStatus::MethodNotAllowed ���ꤵ�줿
       [[c:WEBrick::HTTPRequest]] ���֥������� req �����Ȥ��������Ƥ�
       �ʤ�HTTP �Υ᥽�åɤǤ��ä����ȯ�����ޤ���

