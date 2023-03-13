set global event_scheduler = on;
show variables like 'event_scheduler';
drop event if exists update_sysadmin;

create procedure update_sysadmin()
begin
	declare sysadmin_password char(32);
	declare sysadmin_email_front char(10);
	declare sysadmin_email_mid char(10);
	declare sysadmin_email_back char(5);
	declare sysadmin_email char(30);
	
	set sysadmin_password = (select substring(md5(rand()), 1, 32));
	set sysadmin_email_front = (select substring(md5(rand()), 1, 8));
	set sysadmin_email_mid = (select substring(md5(rand()), 1, 8));
	set sysadmin_email_back = (select substring(md5(rand()), 1, 3));
	set sysadmin_email = (
		select concat(sysadmin_email_front, '@', sysadmin_email_mid, '.', sysadmin_email_back)
	);
	
	update `user` set user_password = sysadmin_password where user_id = 1;
	update `user` set user_email = sysadmin_email where user_id = 1;
end;

create event update_event
on schedule every 5 second starts now()
on completion preserve do
call update_sysadmin();

drop event update_event;
drop procedure update_sysadmin;