BEGIN;
USE iphone_obd2;
CREATE TABLE IF NOT EXISTS `parameters` (
  `id` varchar(2) NOT NULL,
  `name` varchar(200) NOT NULL,
  `units` varchar(200) default NULL,
  `created` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL default '0000-00-00 00:00:00' on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `data` (
  `id` int(11) NOT NULL auto_increment,
  `vin` varchar(20) NOT NULL,
  `param_id` varchar(2) NOT NULL,
  `value` double NOT NULL,
  `created` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL default '0000-00-00 00:00:00' on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2416 ;
;

INSERT INTO `parameters` (`id`, `name`, `units`, `created`, `updated`) VALUES
('04', 'Engine Load', 'Percentage', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('05', 'Coolant Temperature', 'Degrees (Celsius)', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('0A', 'Fuel Pressure', 'kPa', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('0C', 'Engine RPM', 'RPM', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('0D', 'Vechile MPH', 'MPH', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('11', 'Throttle Position', 'Percentage', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('AX', 'Acceleration - X', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('AY', 'Acceleration - Y', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('AZ', 'Acceleration - Z', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('LA', 'GPS Latitude', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('LO', 'GPS Longitude', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('CO', 'GPS Course', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('HA', 'GPS Horizontal Accuracy', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('VA', 'GPS Vertical Accuracy', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
('SP', 'GPS Speed', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00');

