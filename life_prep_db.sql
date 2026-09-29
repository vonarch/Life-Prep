-- Life Prep database
-- Import this file in phpMyAdmin (Import tab) or run it in the MySQL/MariaDB console.

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `life_prep_db`
--

CREATE DATABASE IF NOT EXISTS `life_prep_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `life_prep_db`;

-- --------------------------------------------------------

--
-- Table structure for table `preps`
--

CREATE TABLE `preps` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `source` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `preps`
--

INSERT INTO `preps` (`id`, `title`, `category`, `description`, `source`) VALUES
(1, 'Go-bag', 'Typhoon & Flood', 'One bag ready to grab if you must evacuate fast.', ''),
(2, 'Brownout kit', 'Power & Water', 'Stay safe and comfortable when the power goes out.', '');

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `prep_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `quantity` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `materials`
--

INSERT INTO `materials` (`id`, `prep_id`, `name`, `quantity`) VALUES
(1, 1, 'Waterproof bag', '1 per person'),
(2, 1, 'Drinking water', '3 L per person per day'),
(3, 1, 'Flashlight', '1'),
(4, 2, 'Rechargeable lamp', '1'),
(5, 2, 'Power bank', '1');

-- --------------------------------------------------------

--
-- Table structure for table `steps`
--

CREATE TABLE `steps` (
  `id` int(11) NOT NULL,
  `prep_id` int(11) NOT NULL,
  `step_number` int(11) NOT NULL,
  `instruction` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `steps`
--

INSERT INTO `steps` (`id`, `prep_id`, `step_number`, `instruction`) VALUES
(1, 1, 1, 'Pack documents in a sealed plastic bag.'),
(2, 1, 2, 'Pack water, food and medicines.'),
(3, 2, 1, 'Keep the lamp and power bank in one known spot.'),
(4, 2, 2, 'Charge the power bank whenever there is electricity.');

--
-- Indexes for dumped tables
--

ALTER TABLE `preps`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prep_id` (`prep_id`);

ALTER TABLE `steps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prep_id` (`prep_id`);

--
-- AUTO_INCREMENT for dumped tables
--

ALTER TABLE `preps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `steps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

ALTER TABLE `materials`
  ADD CONSTRAINT `materials_ibfk_1` FOREIGN KEY (`prep_id`) REFERENCES `preps` (`id`);

ALTER TABLE `steps`
  ADD CONSTRAINT `steps_ibfk_1` FOREIGN KEY (`prep_id`) REFERENCES `preps` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
