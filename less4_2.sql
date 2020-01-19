/zd2/ select firstname from vk2.users GROUP by firstname order by firstname;
/* zd 3.1*/ alter table profiles add is_active enum ('1', '0') not null default '0';
/zd 3.2/ update vk2.profiles set is_active = '1' where birthday < date('2002.01.10');
/zd 4/ INSERT INTO vk2.messages
(from_user_id, to_user_id, body, created_at)
values(5, 2, 'Hi! Who are you?', '2025.01.03 11:12:30'),
(2, 5, 'I am your old friend. My name is Max', '2025.01.05 10:30:15'),
(3, 9, 'How about go for a walk?', '2022.08.15 12.26.33'),
(9, 3, 'No thanks! I do not want.', '2022.08.15 13.01.14');
delete from vk2.messages where created_at > date(now());
select * from vk2.messages where created_at > date(now())