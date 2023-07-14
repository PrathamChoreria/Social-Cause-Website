-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Nov 28, 2022 at 03:17 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hope1`
--

-- --------------------------------------------------------

--
-- Table structure for table `c1`
--

CREATE TABLE `c1` (
  `Adhaar_Number` varchar(12) NOT NULL,
  `category` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `c1`
--

INSERT INTO `c1` (`Adhaar_Number`, `category`) VALUES
('123454321678', 'Educator'),
('666555888777', 'Child'),
('666777888555', 'Child'),
('888866664455', 'Child');

-- --------------------------------------------------------

--
-- Table structure for table `c2`
--

CREATE TABLE `c2` (
  `Adhaar_Number` varchar(12) NOT NULL,
  `category` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `c2`
--

INSERT INTO `c2` (`Adhaar_Number`, `category`) VALUES
('1234567654', 'Child'),
('345678902356', 'Educator'),
('567845673456', 'Child'),
('888866667777', 'Child');

-- --------------------------------------------------------

--
-- Table structure for table `centre`
--

CREATE TABLE `centre` (
  `centre_no` varchar(255) NOT NULL,
  `centre_category` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `centre`
--

INSERT INTO `centre` (`centre_no`, `centre_category`) VALUES
('c1', 'male'),
('c2', 'female');

-- --------------------------------------------------------

--
-- Table structure for table `charity`
--

CREATE TABLE `charity` (
  `fund_id` int(11) NOT NULL,
  `organisation_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `charity`
--

INSERT INTO `charity` (`fund_id`, `organisation_name`, `email`, `amount`) VALUES
(1, 'Being Human', 'beingin@gmail.com', 80000);

-- --------------------------------------------------------

--
-- Table structure for table `children`
--

CREATE TABLE `children` (
  `Name` varchar(50) NOT NULL,
  `Age` int(11) NOT NULL,
  `Annual_income` int(11) NOT NULL,
  `caste` varchar(10) NOT NULL,
  `city` varchar(50) NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `needs` varchar(20) NOT NULL,
  `Adhaar_number` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `children`
--

INSERT INTO `children` (`Name`, `Age`, `Annual_income`, `caste`, `city`, `Gender`, `needs`, `Adhaar_number`) VALUES
('Shakira', 12, 12000, 'obc', 'Hyderabad', 'female', 'clothes', '1234567654'),
('Zuhayr Khalid', 12, 8000, 'obc', 'pune', 'male', '', '18902211'),
('Persephone', 14, 13987, 'obc', 'Mumbai', 'female', 'clothes', '567845673456'),
('Gavi', 15, 10000, 'SC', 'Pune', 'male', 'stationary', '666555888777'),
('Kiki Camerena', 14, 7999, 'SC', 'Dholakpur', 'male', 'stationary', '666777888555'),
('Diego Silva', 17, 7865, 'obc', 'Delhi', 'male', 'food', '888866664455'),
('Pablo Escobar', 13, 8000, 'OBC', 'Delhi', 'female', '', '888866667777');

--
-- Triggers `children`
--
DELIMITER $$
CREATE TRIGGER `c1_c` AFTER INSERT ON `children` FOR EACH ROW BEGIN
IF (NEW.gender='male') THEN
INSERT into c1 values(NEW.Adhaar_Number,"Child");
ELSE
INSERT into c2 values(NEW.Adhaar_Number,"Child");
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donar`
--

CREATE TABLE `donar` (
  `Adhaar_Number` varchar(50) NOT NULL,
  `Donation_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `donating` varchar(50) NOT NULL,
  `gender` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `donar`
--

INSERT INTO `donar` (`Adhaar_Number`, `Donation_id`, `name`, `donating`, `gender`) VALUES
('456233455', 1, 'Prathmesh', 'stationary', 'male'),
('111122223333', 5, 'Ronaldo', 'clothes', 'male'),
('444455556666', 6, 'Messi', 'stationary', 'male'),
('888899990000', 7, 'Zara', 'clothes', 'female'),
('111111444444', 8, 'Pep Guardiola', 'food', 'female');

--
-- Triggers `donar`
--
DELIMITER $$
CREATE TRIGGER `archivedonar` BEFORE DELETE ON `donar` FOR EACH ROW insert into donar_archive VALUES(old.Adhaar_Number,old.name,old.donating,old.donation_id)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `need_child` BEFORE DELETE ON `donar` FOR EACH ROW UPDATE children SET needs=NULL where Adhaar_Number=NULL
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donar_archive`
--

CREATE TABLE `donar_archive` (
  `Adhaar_Number` varchar(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `donated` varchar(30) NOT NULL,
  `donation_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `donar_archive`
--

INSERT INTO `donar_archive` (`Adhaar_Number`, `name`, `donated`, `donation_id`) VALUES
('456423456734', 'Pratham', 'clothes', 2),
('890756784532', 'Poharkar', 'clothes', 3),
('890756784532', 'Poharkar', 'clothes', 4);

-- --------------------------------------------------------

--
-- Table structure for table `educator`
--

CREATE TABLE `educator` (
  `Adhaar_Number` varchar(12) NOT NULL,
  `name` varchar(50) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `centre` varchar(255) NOT NULL,
  `subject` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `educator`
--

INSERT INTO `educator` (`Adhaar_Number`, `name`, `age`, `gender`, `centre`, `subject`) VALUES
('123454321678', 'Alan Turing', 35, 'male', 'C1', 'CS'),
('345678902356', 'Marie Curie', 45, 'female', 'C2', 'Chemistry'),
('99999998888', 'hehhe', 67, 'male', 'C1', 'eng');

--
-- Triggers `educator`
--
DELIMITER $$
CREATE TRIGGER `c2_c` AFTER INSERT ON `educator` FOR EACH ROW BEGIN
IF (NEW.gender='male') THEN
INSERT into c1 values(NEW.Adhaar_Number,"Educator");
ELSE
INSERT into c2 values(NEW.Adhaar_Number,"Educator");
END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `c1`
--
ALTER TABLE `c1`
  ADD PRIMARY KEY (`Adhaar_Number`);

--
-- Indexes for table `c2`
--
ALTER TABLE `c2`
  ADD PRIMARY KEY (`Adhaar_Number`);

--
-- Indexes for table `centre`
--
ALTER TABLE `centre`
  ADD PRIMARY KEY (`centre_no`);

--
-- Indexes for table `charity`
--
ALTER TABLE `charity`
  ADD PRIMARY KEY (`fund_id`);

--
-- Indexes for table `children`
--
ALTER TABLE `children`
  ADD PRIMARY KEY (`Adhaar_number`);

--
-- Indexes for table `donar`
--
ALTER TABLE `donar`
  ADD PRIMARY KEY (`Donation_id`);

--
-- Indexes for table `donar_archive`
--
ALTER TABLE `donar_archive`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `educator`
--
ALTER TABLE `educator`
  ADD PRIMARY KEY (`Adhaar_Number`),
  ADD KEY `FOREIGN` (`centre`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `charity`
--
ALTER TABLE `charity`
  MODIFY `fund_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `donar`
--
ALTER TABLE `donar`
  MODIFY `Donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `educator`
--
ALTER TABLE `educator`
  ADD CONSTRAINT `fk` FOREIGN KEY (`centre`) REFERENCES `centre` (`centre_no`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
