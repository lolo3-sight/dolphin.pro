
-- Options

SET @iMaxOrder = (SELECT `menu_order` + 1 FROM `sys_options_cats` ORDER BY `menu_order` DESC LIMIT 1);
INSERT INTO `sys_options_cats` (`name`, `menu_order`) VALUES ('Chat+', @iMaxOrder);
SET @iKategId = (SELECT LAST_INSERT_ID());

INSERT INTO `sys_options` (`Name`, `kateg`, `desc`, `Type`, `VALUE`, `order_in_kateg`) VALUES
('bx_chat_plus_url', @iKategId, 'Chat URL', 'digit', '', 10),
('bx_chat_plus_helpdesk', @iKategId, 'Enable Helpdesk Chat', 'checkbox', '', 20),
('bx_chat_plus_helpdesk_guest_only', @iKategId, 'Show Helpdesk Chat For Guests Only', 'checkbox', 'on', 30);

INSERT INTO `sys_options`  (`Name`, `VALUE`, `kateg`, `desc`, `Type`, `check`, `err_text`, `order_in_kateg`, `AvailableValues`)  VALUES
('bx_chat_plus_permalinks', 'on', 26, 'Enable friendly permalinks in Chat+', 'checkbox', '', '', '0', '');

-- Menu Admin

SET @iOrder = (SELECT MAX(`order`) FROM `sys_menu_admin` WHERE `parent_id` = '2');

INSERT INTO  `sys_menu_admin`  SET `name` = 'Chat+', `title` = '_bx_chat_plus', `url` = '{siteUrl}modules/?r=chat_plus/administration/',  `description` = 'Managing the \'Chat+\' settings', `icon` = 'commenting', `parent_id` = 2, `order` = @iOrder+1;

-- Permalinks

INSERT INTO  `sys_permalinks` SET `standard` = 'modules/?r=chat_plus/', `permalink` = 'm/chat_plus/', `check` = 'bx_chat_plus_permalinks';

-- Main Menu

SET @iOrder := (SELECT MAX(`Order`) FROM `sys_menu_top` WHERE `Parent` = '0');
INSERT INTO `sys_menu_top` (`Parent`, `Name`, `Caption`, `Link`, `Order`, `Visible`, `Target`, `Onclick`, `Check`, `Editable`, `Deletable`, `Active`, `Type`, `Picture`, `BQuickLink`, `Statistics`) VALUES
(0, 'Chat+', '_bx_chat_plus_chat', 'modules/?r=chat_plus/redirect/', @iOrder+1, 'non,memb', '_blank', '', '', 1, 1, 1, 'top', 'commenting', 0, '');

-- Injections

INSERT INTO `sys_injections` (`name`, `page_index`, `key`, `type`, `data`, `replace`, `active`) VALUES
('bx_chat_plus', 0, 'injection_footer', 'php', 'return BxDolService::call(''chat_plus'', ''helpdesk_code'');', 0, 1);

