-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 13 Eki 2023, 16:12:54
-- Sunucu sürümü: 8.0.17
-- PHP Sürümü: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `university_management_system`
--
CREATE DATABASE IF NOT EXISTS `university_management_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `university_management_system`;

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `CalculateAverages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateAverages` ()  BEGIN
    -- Öğrencilerin dönem sonu ortalamalarını hesaplamak için bir örnek (gerçekte daha kompleks olabilir)
    DECLARE done INT DEFAULT 0;
    DECLARE current_student INT;
    DECLARE average_grade DECIMAL(4,2);

    DECLARE cur CURSOR FOR SELECT student_id FROM students;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO current_student;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT AVG(score) INTO average_grade FROM grades WHERE enrollment_id IN (SELECT enrollment_id FROM enrollments WHERE student_id = current_student);
        -- Ortalamayı bir yere kaydedebilir veya başka işlemler yapabilirsiniz
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `classrooms`
--

DROP TABLE IF EXISTS `classrooms`;
CREATE TABLE IF NOT EXISTS `classrooms` (
  `classroom_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`classroom_id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `clubs`
--

DROP TABLE IF EXISTS `clubs`;
CREATE TABLE IF NOT EXISTS `clubs` (
  `club_id` int(11) NOT NULL AUTO_INCREMENT,
  `club_name` varchar(255) NOT NULL,
  `president_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`club_id`),
  KEY `president_id` (`president_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `clubs`
--

INSERT INTO `clubs` (`club_id`, `club_name`, `president_id`) VALUES
(1, 'Bilgisayar Kulübü', 1),
(2, 'Robotik Kulübü', 2),
(3, 'Makine Kulübü', 3);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `club_memberships`
--

DROP TABLE IF EXISTS `club_memberships`;
CREATE TABLE IF NOT EXISTS `club_memberships` (
  `membership_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `club_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`membership_id`),
  KEY `student_id` (`student_id`),
  KEY `club_id` (`club_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `courses`
--

DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_name` varchar(255) NOT NULL,
  `instructor_id` int(11) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `instructor_id` (`instructor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `courses`
--

INSERT INTO `courses` (`course_id`, `course_name`, `instructor_id`, `credit`) VALUES
(1, 'Programlama 101', 1, 4),
(2, 'Devre Teorisi', 2, 3),
(3, 'Termodinamik', 3, 3);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `departmentaverages`
-- (Asıl görünüm için aşağıya bakın)
--
DROP VIEW IF EXISTS `departmentaverages`;
CREATE TABLE IF NOT EXISTS `departmentaverages` (
`Department` varchar(255)
,`AverageGrade` decimal(9,6)
);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `departments`
--

DROP TABLE IF EXISTS `departments`;
CREATE TABLE IF NOT EXISTS `departments` (
  `department_id` int(11) NOT NULL AUTO_INCREMENT,
  `department_name` varchar(255) NOT NULL,
  `head_of_department` int(11) DEFAULT NULL,
  PRIMARY KEY (`department_id`),
  KEY `head_of_department` (`head_of_department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
CREATE TABLE IF NOT EXISTS `enrollments` (
  `enrollment_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `semester` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  KEY `student_id` (`student_id`),
  KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_name` varchar(255) NOT NULL,
  `event_date` date DEFAULT NULL,
  `event_location` varchar(255) DEFAULT NULL,
  `event_description` text,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `events`
--

INSERT INTO `events` (`event_id`, `event_name`, `event_date`, `event_location`, `event_description`) VALUES
(1, 'Teknoloji Zirvesi', '2023-05-20', 'Mühendislik Fakültesi Konferans Salonu', 'Ünlü mühendislerin katılımıyla gerçekleşecek olan etkinlikte, teknolojinin geleceği tartışılacak.');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `grades`
--

DROP TABLE IF EXISTS `grades`;
CREATE TABLE IF NOT EXISTS `grades` (
  `grade_id` int(11) NOT NULL AUTO_INCREMENT,
  `enrollment_id` int(11) DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `grade` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`grade_id`),
  KEY `enrollment_id` (`enrollment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `instructors`
--

DROP TABLE IF EXISTS `instructors`;
CREATE TABLE IF NOT EXISTS `instructors` (
  `instructor_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `department` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`instructor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `instructors`
--

INSERT INTO `instructors` (`instructor_id`, `first_name`, `last_name`, `department`) VALUES
(1, 'Ahmet', 'Ersoy', 'Bilgisayar Mühendisliği'),
(2, 'Elif', 'Boran', 'Elektrik Mühendisliği'),
(3, 'Hasan', 'Kutlu', 'Makine Mühendisliği');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `schedules`
--

DROP TABLE IF EXISTS `schedules`;
CREATE TABLE IF NOT EXISTS `schedules` (
  `schedule_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL,
  `classroom_id` int(11) DEFAULT NULL,
  `day_of_week` varchar(50) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `course_id` (`course_id`),
  KEY `classroom_id` (`classroom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `students`
--

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `major` varchar(255) DEFAULT NULL,
  `advisor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `advisor_id` (`advisor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `students`
--

INSERT INTO `students` (`student_id`, `first_name`, `last_name`, `date_of_birth`, `enrollment_date`, `major`, `advisor_id`) VALUES
(1, 'Ali', 'Kaya', '2000-01-05', '2019-09-10', 'Bilgisayar Mühendisliği', NULL),
(2, 'Ayşe', 'Duru', '2001-04-12', '2020-09-10', 'Elektrik Mühendisliği', NULL),
(3, 'Mehmet', 'Öz', '1999-08-22', '2018-09-10', 'Makine Mühendisliği', NULL);

--
-- Tetikleyiciler `students`
--
DROP TRIGGER IF EXISTS `after_student_delete`;
DELIMITER $$
CREATE TRIGGER `after_student_delete` AFTER DELETE ON `students` FOR EACH ROW BEGIN
    DELETE FROM enrollments WHERE student_id = OLD.student_id;
    DELETE FROM grades WHERE enrollment_id IN (SELECT enrollment_id FROM enrollments WHERE student_id = OLD.student_id);
    DELETE FROM club_memberships WHERE student_id = OLD.student_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `departmentaverages`
--
DROP TABLE IF EXISTS `departmentaverages`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `departmentaverages`  AS  select `s`.`major` AS `Department`,avg(`g`.`score`) AS `AverageGrade` from ((`students` `s` join `enrollments` `e` on((`s`.`student_id` = `e`.`student_id`))) join `grades` `g` on((`e`.`enrollment_id` = `g`.`enrollment_id`))) group by `s`.`major` ;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `classrooms`
--
ALTER TABLE `classrooms`
  ADD CONSTRAINT `classrooms_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);

--
-- Tablo kısıtlamaları `clubs`
--
ALTER TABLE `clubs`
  ADD CONSTRAINT `clubs_ibfk_1` FOREIGN KEY (`president_id`) REFERENCES `students` (`student_id`);

--
-- Tablo kısıtlamaları `club_memberships`
--
ALTER TABLE `club_memberships`
  ADD CONSTRAINT `club_memberships_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  ADD CONSTRAINT `club_memberships_ibfk_2` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`club_id`);

--
-- Tablo kısıtlamaları `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`instructor_id`);

--
-- Tablo kısıtlamaları `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`head_of_department`) REFERENCES `instructors` (`instructor_id`);

--
-- Tablo kısıtlamaları `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);

--
-- Tablo kısıtlamaları `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`enrollment_id`);

--
-- Tablo kısıtlamaları `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
  ADD CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`classroom_id`);

--
-- Tablo kısıtlamaları `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`advisor_id`) REFERENCES `instructors` (`instructor_id`);

DELIMITER $$
--
-- Olaylar
--
DROP EVENT `CleanOldStudents`$$
CREATE DEFINER=`root`@`localhost` EVENT `CleanOldStudents` ON SCHEDULE EVERY 1 YEAR STARTS '2023-10-13 18:56:57' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM students WHERE enrollment_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
