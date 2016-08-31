-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.1.13-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win32
-- HeidiSQL Versão:              9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Copiando estrutura do banco de dados para bancoenem
CREATE DATABASE IF NOT EXISTS `bancoenem` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `bancoenem`;


-- Copiando estrutura para tabela gplac.capital
CREATE TABLE IF NOT EXISTS `capital` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(13) DEFAULT '0',
  `dataprevista` date DEFAULT '0000-00-00',
  `status` enum('PENDENTE','TRIADO','CONFERIDO') DEFAULT 'PENDENTE',
  `codigoretorno` varchar(13) DEFAULT NULL,
  `rota` int(11) DEFAULT NULL,
  `ordem` int(4) DEFAULT NULL,
  `destinatario` varchar(200) DEFAULT NULL,
  `logradouro` varchar(200) DEFAULT NULL,
  `bairro` varchar(200) DEFAULT NULL,
  `cep` varchar(200) DEFAULT NULL,
  `cidade` varchar(200) DEFAULT NULL,
  `sabatina` enum('S','N') DEFAULT 'N',
  `provaespecial` enum('S','N') DEFAULT 'N',
  `peso` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- Copiando estrutura para view gplac.domingo
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `domingo` (
	`rota` INT(11) NULL,
	`total` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Copiando estrutura para view gplac.domingocapital
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `domingocapital` (
	`rota` INT(11) NULL,
	`total` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Copiando estrutura para tabela gplac.interior
CREATE TABLE IF NOT EXISTS `interior` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(13) DEFAULT '0',
  `status` enum('PENDENTE','TRIADO','CONFERIDO') DEFAULT 'PENDENTE',
  `codigoretorno` varchar(13) DEFAULT NULL,
  `dataprevista` date DEFAULT '0000-00-00',
  `rota` int(11) DEFAULT NULL,
  `nomerota` varchar(10) DEFAULT NULL,
  `destinatario` varchar(200) DEFAULT NULL,
  `logradouro` varchar(200) DEFAULT NULL,
  `bairro` varchar(200) DEFAULT NULL,
  `cep` varchar(9) DEFAULT NULL,
  `cidade` varchar(200) DEFAULT NULL,
  `sabatina` enum('S','N') DEFAULT 'N',
  `provaespecial` enum('S','N') DEFAULT 'N',
  `peso` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- Copiando estrutura para view gplac.listarrotas
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `listarrotas` (
	`rota` INT(11) NULL,
	`total` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Copiando estrutura para view gplac.sabado
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `sabado` (
	`rota` INT(11) NULL,
	`total` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Copiando estrutura para view gplac.sabadocapital
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `sabadocapital` (
	`rota` INT(11) NULL,
	`total` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Copiando estrutura para procedure gplac.sp_contarRotas
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contarRotas`(IN `var_data` DATE)
BEGIN
	SELECT rota, Count(*) AS total FROM interior 
	WHERE dataprevista = var_data
	GROUP BY rota
	HAVING Count(*) > 1 ;
	
END//
DELIMITER ;


-- Copiando estrutura para view gplac.domingo
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `domingo`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `domingo` AS SELECT rota, Count(*) AS total FROM interior 
where dataprevista = '2016-11-06'
GROUP BY rota
HAVING Count(*) > 1 ;


-- Copiando estrutura para view gplac.domingocapital
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `domingocapital`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `domingocapital` AS SELECT rota, Count(*) AS total FROM capital 
where dataprevista = '2016-11-06'
GROUP BY rota
HAVING Count(*) > 1 ;


-- Copiando estrutura para view gplac.listarrotas
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `listarrotas`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `listarrotas` AS SELECT rota, Count(*) AS total FROM capital 
where dataprevista = '2016-11-06'
GROUP BY rota
HAVING Count(*) > 1 ;


-- Copiando estrutura para view gplac.sabado
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `sabado`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `sabado` AS SELECT rota, Count(*) AS total FROM interior 
where dataprevista = '2016-11-05'
GROUP BY rota
HAVING Count(*) > 1 ;


-- Copiando estrutura para view gplac.sabadocapital
-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `sabadocapital`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `sabadocapital` AS SELECT rota, Count(*) AS total FROM capital 
where dataprevista = '2016-11-05'
GROUP BY rota
HAVING Count(*) > 1 ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
