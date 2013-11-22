SET FOREIGN_KEY_CHECKS=0;

--
-- Table structure for table `bars`
--

DROP TABLE IF EXISTS `bars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bars` (
  `name` varchar(50) NOT NULL DEFAULT '',
  `license` varchar(7) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `addr` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `beers`
--

DROP TABLE IF EXISTS `beers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `beers` (
  `name` varchar(100) NOT NULL DEFAULT '',
  `manf` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drinkers`
--

DROP TABLE IF EXISTS `drinkers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drinkers` (
  `name` varchar(50) NOT NULL DEFAULT '',
  `city` varchar(50) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `addr` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `frequents`
--

DROP TABLE IF EXISTS `frequents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `frequents` (
  `drinker` varchar(50) NOT NULL DEFAULT '',
  `bar` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`drinker`,`bar`),
  KEY `fk_frequents_bar` (`bar`),
  CONSTRAINT `fk_frequents_bar` FOREIGN KEY (`bar`) REFERENCES `bars` (`name`),
  CONSTRAINT `fk_frequents_drinker` FOREIGN KEY (`drinker`) REFERENCES `drinkers` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `drinker` varchar(50) NOT NULL DEFAULT '',
  `beer` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`drinker`,`beer`),
  KEY `fk_likes_beer` (`beer`),
  CONSTRAINT `fk_likes_beer` FOREIGN KEY (`beer`) REFERENCES `beers` (`name`),
  CONSTRAINT `fk_likes_drinker` FOREIGN KEY (`drinker`) REFERENCES `drinkers` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sells`
--

DROP TABLE IF EXISTS `sells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sells` (
  `bar` varchar(100) NOT NULL DEFAULT '',
  `beer` varchar(100) NOT NULL DEFAULT '',
  `price` decimal(9,2) DEFAULT NULL,
  PRIMARY KEY (`bar`,`beer`),
  KEY `fk_sells_beer` (`beer`),
  CONSTRAINT `fk_sells_bar` FOREIGN KEY (`bar`) REFERENCES `bars` (`name`),
  CONSTRAINT `fk_sells_beer` FOREIGN KEY (`beer`) REFERENCES `beers` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `date` varchar(50) NOT NULL DEFAULT '',
  `bar` varchar(100) NOT NULL DEFAULT '',
  `beer` varchar(100) NOT NULL DEFAULT '',
  `price` decimal(9,2) DEFAULT NULL,
  `drinker` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`bar`,`beer`, `drinker`),
  KEY `fk_sells_beer` (`beer`),
  CONSTRAINT `fk_transactions_bar` FOREIGN KEY (`bar`) REFERENCES `bars` (`name`),
  CONSTRAINT `fk_transactions_beer` FOREIGN KEY (`beer`) REFERENCES `beers` (`name`),
  CONSTRAINT `fk_transactions_drinker` FOREIGN KEY (`drinker`) REFERENCES `drinkers` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friendships`
--

DROP TABLE IF EXISTS `friendships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friendships` (
  `drinker1` varchar(50) NOT NULL DEFAULT '',
  `drinker2` varchar(50) NOT NULL DEFAULT '',
  CONSTRAINT `fk_friendships_drinker1` FOREIGN KEY (`drinker1`) REFERENCES `drinkers` (`name`),
  CONSTRAINT `fk_friendships_drinker2` FOREIGN KEY (`drinker2`) REFERENCES `drinkers` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

SET FOREIGN_KEY_CHECKS=1;
