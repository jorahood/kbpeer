CREATE TABLE `articles` (
  `id` int(11) NOT NULL auto_increment,
  `subject` varchar(255) default NULL,
  `rawtext` text,
  `message_id` varchar(255) NOT NULL,
  `parent_id` int(11) NOT NULL default '0',
  `reference` varchar(255) default NULL,
  `date` datetime default NULL,
  `editor_id` int(11) default NULL,
  `type` varchar(255) NOT NULL,
  `root_id` int(11) default NULL,
  `lft` int(11) default NULL,
  `rgt` int(11) default NULL,
  `depth` int(11) default NULL,
  `docid` varchar(255) default NULL,
  `root_editor_id` int(11) default '0',
  `reviews` int(11) default '0',
  PRIMARY KEY  (`id`),
  KEY `article_id_fkey` (`parent_id`),
  KEY `articles_message_id_index` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `editors` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `full_name` varchar(255) default NULL,
  `docs_posted` int(11) default NULL,
  `docs_reviewed` int(11) default NULL,
  `is_ex` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (21)