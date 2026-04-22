-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 07, 2026 at 04:11 PM
-- Server version: 11.8.6-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u625466827_zakprint`
--

-- --------------------------------------------------------

--
-- Table structure for table `billing_profiles`
--

CREATE TABLE `billing_profiles` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `logo_path` varchar(255) DEFAULT NULL,
  `terms` text DEFAULT NULL,
  `payment_methods` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `gst_no` varchar(100) DEFAULT NULL,
  `ntn_no` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `billing_profiles`
--

INSERT INTO `billing_profiles` (`id`, `tenant_id`, `owner_user_id`, `company_name`, `address`, `phone`, `email`, `logo_path`, `terms`, `payment_methods`, `created_at`, `updated_at`, `gst_no`, `ntn_no`) VALUES
(1, 1, NULL, 'ZAK Printing', 'Office No. 59-Basement, Shan Arcade, Garden Town, Lahore 54600', '0309-6554946', 'info@zakprinting.com', NULL, 'Payment due upon receipt unless otherwise agreed. Late fees may apply after 14 days.', 'Cash ? Bank Transfer', '2025-08-31 15:42:24', '2025-08-31 15:42:24', NULL, NULL),
(2, 1, NULL, 'ZAK Printing', 'Office No. 59-Basement, Shan Arcade, Garden Town, Lahore 54600', '0309-6554946', 'info@zakprinting.com', NULL, 'Payment due upon receipt unless otherwise agreed. Late fees may apply after 14 days.', 'Cash ? Bank Transfer', '2025-08-31 15:46:53', '2025-08-31 15:46:53', NULL, NULL),
(3, 1, 1, 'ZAK Printing', 'Office No. 59-Basement, Shan Arcade, Garden Town, Lahore', '0309-6554946', 'info@zakprinting.com', '/uploads/logos/1/1/logo-1758129386.png', 'Please make a payment to\nMCB ISLAMIC Bank Ltd.\nBeneficiary Name: ZAK PRINTING\nBeneficiary Account Number: 0431005047810001\nIBAN: PK19 MCIB 0431 0050 4781 0001\nJAZZCASH |  EASYPAISA\nBeneficiary Name: Kashif Yaqoob\nAccount Number:  0309-6554946', 'Cash ? Bank Transfer', '2025-08-31 16:38:26', '2025-09-17 17:16:26', NULL, NULL),
(4, 1, 3, 'Abdullah printing', 'Office No. 59-Basement, Shan Arcade, Garden Town, Lahore 54600', '0309-6554946', 'info@Abdullah.com', '/uploads/logos/1/3/logo-1756659783.png', 'Payment due upon receipt unless otherwise agreed. Late fees may apply after 14 days.', 'Cash ? Bank Transfer', '2025-08-31 17:03:03', '2025-08-31 17:03:03', NULL, NULL),
(5, 1, 5, 'Mazoor Printing Center', 'Office # 56-B, Shan Arcade, Barkat Market, New Garden Town, Lahore', '03014573265', 'info.akgraphic@gmail.com', '/uploads/logos/1/5/logo-1758171339.png', 'Payment due upon receipt unless otherwise agreed. Late fees may apply after 14 days.', 'Please make a payment to\nJAZZCASH |  EASYPAISA\nBeneficiary Name: ASIF YAQOOB\nAccount Number:  0301-4573265', '2025-09-01 12:03:11', '2025-09-18 04:58:21', NULL, NULL),
(6, 1, 7, 'ZAK Media Private Limited', 'Office No. 59-B Shan Arcade Barket Market Garden Town Lahore', '0309-6554946 NTN: D850334-5 GST #: 3277876346981', 'zakmedialtd@gmail.com', '/uploads/logos/1/7/logo-1758128957.png', '', '', '2025-09-03 06:55:26', '2025-09-22 06:13:14', NULL, NULL),
(7, 1, 6, 'Zafar Associates & ZAK Printing', 'Office No. 59-LGF, Central Plaza Rafi Group, Garden Town, Lahore 54600', '+92 302 4082714', 'info@zakprinting.com', '/uploads/logos/1/6/logo-1761552038.png', 'Thank you for your trust. All e-stamp papers are issued under government rules. Please verify details before printing. Payments are non-refundable once processing begins.', 'Cash / Bank Transfer / JazzCash (0302-4082714)\nMeezan Bank A/C 02040104025202 ? Zafar Iqbal', '2025-09-09 07:38:41', '2025-10-27 08:00:46', NULL, NULL),
(8, 1, 4, 'Mazoor Printing Center', 'Office No. 56-Basement, Shan Arcade, Garden Town, Lahore 54600', '0325-1133444', 'info.akgraphic@gmail.com', '/uploads/logos/1/4/logo-1764310823.png', 'Please make a payment to\nJAZZCASH | EASYPAISA \nBeneficiary Name:  Syed Mujeeb Ul Hassan\nAccount Number: 0325-1133444', 'Cash ? Bank Transfer', '2025-11-28 06:06:48', '2025-11-28 06:21:04', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_blocks`
--

CREATE TABLE `cms_blocks` (
  `id` int(10) UNSIGNED NOT NULL,
  `page_id` int(10) UNSIGNED NOT NULL,
  `block_key` varchar(100) NOT NULL,
  `title` varchar(190) DEFAULT NULL,
  `content_html` longtext DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cms_blocks`
--

INSERT INTO `cms_blocks` (`id`, `page_id`, `block_key`, `title`, `content_html`, `image_path`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 1, 'hero', 'Hero section', NULL, NULL, 4, '2026-03-04 16:17:35', '2026-03-04 16:17:35'),
(2, 1, 'intro', 'Intro / About snippet', NULL, NULL, 4, '2026-03-04 16:17:35', '2026-03-04 16:17:35'),
(3, 1, 'services', 'Services / Highlights', NULL, NULL, 4, '2026-03-04 16:17:35', '2026-03-04 16:17:35'),
(4, 1, 'cta', 'Bottom Call-to-Action', NULL, NULL, 4, '2026-03-04 16:17:35', '2026-03-04 16:17:35');

-- --------------------------------------------------------

--
-- Table structure for table `cms_pages`
--

CREATE TABLE `cms_pages` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(100) NOT NULL,
  `title` varchar(190) NOT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cms_pages`
--

INSERT INTO `cms_pages` (`id`, `slug`, `title`, `meta_description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'home', 'Home', NULL, 1, '2026-03-04 16:14:52', '2026-03-04 16:14:52'),
(2, 'about', 'About', NULL, 1, '2026-03-04 16:14:52', '2026-03-04 16:14:52'),
(3, 'contact', 'Contact', NULL, 1, '2026-03-04 16:14:52', '2026-03-04 16:14:52'),
(4, 'blog_insights', 'Blog / Insights', NULL, 1, '2026-03-04 16:14:52', '2026-03-04 16:14:52'),
(5, 'shop', 'Shop', NULL, 1, '2026-03-10 10:00:25', '2026-03-10 10:00:25'),
(6, 'book_appointment', 'Book Appointment', NULL, 1, '2026-03-10 10:00:25', '2026-03-10 10:00:25'),
(7, 'checkout', 'Checkout', NULL, 1, '2026-03-10 10:00:25', '2026-03-10 10:00:25'),
(8, 'portfolio', 'Corporate Portfolio', NULL, 1, '2026-03-10 10:00:25', '2026-03-10 10:00:25'),
(9, 'our_work', 'Our Work', NULL, 1, '2026-03-10 10:00:25', '2026-03-10 10:00:25');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `name`, `email`, `phone`, `subject`, `message`, `created_at`) VALUES
(1, 'Abe Huot', 'huot.abe@msn.com', '745488802', 'Achieve Your Morning Growth in Just 5 Days ? No heavy setups, No campaigns!', 'Hello,\r\n\r\nWe present some insight for your website zakprinting.com : https://goldsolutions.pro/TitanEdge?zakprinting.com\r\n\r\nHad enough of complex funnels, marketing campaigns, and daily grind?  \r\nIn just a handful of days, you?ll adopt a practical, structured workflow ? just 30?60 minutes each morning ? that turns your coffee time into visible results.  \r\nZero stock, no chasing audiences, no campaign pressure.  \r\nJust clear steps, extra flexibility, and the motivation of watching progress appear.  \r\nCurious about the details?\r\n\r\nSee it in action: https://goldsolutions.pro/TitanEdge?zakprinting.com\r\n\r\nYou are receiving this message because we considered our content may be helpful to you.  \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com  \r\nAddress: 209 West Street Comstock Park, MI 49321  \r\n\r\nAll the best,  \r\nEthan Parker', '2025-09-11 10:17:17'),
(2, 'Alfie Nellis', 'nellis.alfie@hotmail.com', '665082369', 'Create Colorful Children?s Story Clips Fast ? No Skills Needed , Single Payment Only', 'Hi,\r\n\r\nI?d like to share a tailored solution that matches your domain zakprinting.com : https://goldsolutions.pro/KidsTaleAI?zakprinting.com\r\n\r\nWhy could this matter? this solution instantly changes any idea into animated kids? story videos in just minutes ? no prior experience needed, no big investments, no monthly payments. Your stories arrive complete with spoken lines, playful rhyme, soundtracks, subtitles ? simply type, click, and publish.\r\n\r\nSee how rapidly you can grow in the kids? content area: post on YouTube, TikTok, Instagram and let the views grow. Or sell them on Fiverr, Etsy, or Gumroad at $50 up to $500 per video. You get a full license, fast availability, and ongoing help ? for a one-time fair price. This is your chance to start something new.\r\n\r\nCheck the demo: https://goldsolutions.pro/KidsTaleAI?zakprinting.com\r\n\r\nYou are seeing this message because we believe it could fit your needs to you.  \r\nIf you wish to stop further info from us, please follow here to UNSUBSCRIBE:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\n\r\nLooking forward,  \r\nEthan Parker', '2025-09-12 14:17:01'),
(3, 'Carina Cottrell', 'carina.cottrell@gmail.com', '189000882', 'Instant Setup, Bring Attention & Momentum ? No Programming, No Upfront Payment', 'Hi,\r\n\r\nI?d like to share a special solution tailored for your website zakprinting.com: https://goldsolutions.pro/VibeCode?zakprinting.com\r\n\r\nWhy is this useful?  \r\nWith Vibe Code Blueprint, you?re activating a instant engine designed to bring traffic and growth straight away ? no developers, no upfront payment, no waiting weeks.  \r\nBuild conversion-ready digital assets instantly ? items that used to cost a lot ? and move forward today.\r\n\r\nIn a saturated digital world, this framework makes a difference: from setup to monetization, it?s simple, intuitive, and usable by anyone.  \r\nThe possibility is here now ? early members benefit the most.  \r\nThinking to test it? Click through and I?ll walk you inside.\r\n\r\nExplore it now: https://goldsolutions.pro/VibeCode?zakprinting.com\r\n\r\nYou are receiving this message because this might connect with your needs.  \r\nIf you prefer not to get further information from us, follow this link to stop messages:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com  \r\nAddress: 209 West Street Comstock Park, MI 49321  \r\n\r\nWarmly,  \r\nEthan Parker', '2025-09-13 02:38:25'),
(4, 'Merri Watson', 'watson.merri@gmail.com', '267149382', 'Discover Your', 'Hey there,\r\n\r\nTake a look at a useful tool for your website zakprinting.com : https://goldsolutions.pro/BlackBoxProfits?zakprinting.com\r\n\r\nWhy it?s worth checking:  \r\nIf you?re active online, Black Box Profits is your shortcut to consistent results ? no technical setup, no content overload.  \r\nJust input an idea, and the system delivers a ready-to-sell mini-app that acts as an online tool and sells without extra effort.\r\n\r\nFocus on results, not harder: forget ebooks, hours of editing, or self-branding.  \r\nBuild micro-programs, not PDFs, that bring sales ? and all it takes is a concept and a short setup.  \r\nWant to learn more today?\r\n\r\nSee it in action: https://goldsolutions.pro/BlackBoxProfits?zakprinting.com\r\n\r\nYou are receiving this message because it could be valuable for your online activity.  \r\nIf you prefer not to get updates from us, please click here to leave the list:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\n\r\nAll the best,  \r\nEthan Parker', '2025-09-13 10:13:57'),
(5, 'Reynaldo Roxon', 'reynaldo.roxon@gmail.com', '6648225446', 'Whenever your words can carry the message', 'Hi,\r\n\r\nWe have a limited access for your website zakprinting.com: https://goldsolutions.pro/VoiceBeastAI?zakprinting.com\r\n\r\nVisualize this: a content maker turning any text into a natural, captivating voiceover in seconds?no mic, no studio, no hassle. VoiceBeast AI VIP gives you the power to create a voice that doesn?t just read?it delivers, engaging your audience right in your browser. It?s not hard to use?it?s a performance booster: more attention, better results, fewer hurdles. Ready to make your words sound authentic?\r\n\r\nTry it live: https://goldsolutions.pro/VoiceBeastAI?zakprinting.com\r\n\r\nYou are receiving this update because we believe our service may be useful to you.  \r\nIf you do not wish to receive further updates, please click here to remove:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\nLooking out for you,  \r\nEthan Parker', '2025-09-13 20:01:35'),
(6, 'Winifred Bobadilla', 'bobadilla.winifred@gmail.com', '698689341', 'Generate Video Scripts with ease: Done-for-you texts that get attention', 'Hi,\r\n\r\nYou?ll find a tailored solution connected with zakprinting.com zakprinting.com https://goldsolutions.pro/VideoScriptProGPT?zakprinting.com \r\n\r\nIf you monetize sites looking for efficient tools?  \r\nConsider: no struggle over writing engaging content ? Video Script Pro GPT does the heavy lifting, done instantly.  \r\nNo endless typing, just focused, attention-grabbing scripts that capture interest ? and increase your results with almost no time.\r\n\r\nInterested how it helps you improve your click rate, reduce workload, and let you concentrate on new tasks?\r\n\r\nPreview now: https://goldsolutions.pro/VideoScriptProGPT?zakprinting.com\r\n\r\nYou are receiving this update because it?s likely our solution may help for your site.  \r\nIf you do not wish to be updated with future letters from us, please click here to UNSUBSCRIBE:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com\r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\nSincerely,  \r\nEthan Parker', '2025-09-13 21:46:43'),
(7, 'Faheem', 'regis@stoshi.one', '03096554946', 'Delll', 'Test 0123', '2025-09-14 10:45:08'),
(8, 'Lelia Buchholz', 'buchholz.lelia@gmail.com', '740099949', 'Gain Google reach in no time ? no website required', 'Greetings,\r\n\r\nHere?s a unique opportunity designed for your domain : https://smartexperts.pro/GhostPage?zakprinting.com\r\n\r\nHere?s why this matters: it lets you generate consistent visitors and growth starting right away ? avoiding costly ad platforms or technical stress. Ghost Pages positions you as a silent authority that Google supports: you launch hidden assets via a hidden Google asset, and they drive people interested in your content ? while others remain unaware.\r\n\r\nIt?s quick, it?s efficient: no need for domains, hosting, or social media, and you don?t need any skills ? as long as you can copy-paste, you can use it. Plus, it?s proven and expandable: launch one Ghost Page and boom ? traffic flows to any link you choose ? the destination is yours to pick. Get going instantly? Explore how it works and experience growth.\r\n\r\nWatch it in action: https://smartexperts.pro/GhostPage?zakprinting.com\r\n\r\nYou are receiving this message because it might align with your current needs.  \r\nIf you do not wish to hear from us again, please click here to UNSUBSCRIBE:  \r\nhttps://smartexperts.pro/unsub?domain=zakprinting.com  \r\nAddress: 1464 Lewis Street Roselle, IL 60177  \r\n\r\nLooking forward,  \r\nMichael Turner.', '2025-09-14 21:19:13'),
(9, 'TimothyPox', 'nomin.momin+373j6@mail.ru', '88625285791', 'Odkwsdjferheejdfehueyidjaswdhuheufhe fjhwegfweuihdwhfi ifhewidjawsjdgewuifhqw', 'Mfwdjwdhefiejfh fhiwuewuoioruiwes jkcsjhcksdlalsdjfhgh ejdowkkDIEWHRUEOFIW JIEWFOKDWDJEWIHFIEWFJEWFJIkhfjejfie efjfwjdfe zakprinting.com', '2025-09-15 03:22:44'),
(10, 'Terra Stukes', 'terra.stukes76@hotmail.com', '7878958279', 'Boost your setup with Results With Kevin AI ? fewer steps, stronger impact', 'Hey there,\r\n\r\nBringing over a custom opportunity for your website zakprinting.com https://novaai.expert/KevinAI?zakprinting.com\r\n\r\nImagine initiating a plan and watching results rise very quickly ? without unnecessary adjustments, without brainstorming until midnight.  \r\n\r\nResults With Kevin AI provides a collection of AI tools + verified strategies that handle the time-consuming parts: shaping content ideas and more. With one start ? the system produces, tries out, sells.  \r\n\r\nWant to break out of the ?I?m busy all day? pattern and transition toward ?I launch, I watch, I gain? mode?  \r\n\r\nTake a closer look: https://novaai.expert/KevinAI?zakprinting.com\r\n\r\nYou are receiving this update because we believe our information may be useful to you.  \r\nIf you do not wish to receive further messages, please click here to opt-out:  \r\nhttps://www.novaai.expert/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\nBest regards,  \r\nEthan Parker', '2025-09-15 19:05:49'),
(11, 'Micheline Gale', 'micheline.gale91@hotmail.com', '40855008', 'Generate Online Resources,', 'Hi,\r\n\r\nWe have a limited suggestion for your website zakprinting.com : https://goldsolutions.pro/VibeCodeBlueprint?zakprinting.com\r\n\r\nWhy should this be important to you? Because Vibe Code Blueprint is your new framework ? create scalable digital assets in seconds, with zero developers and zero budget, while audience and returns start coming in. Imagine being the creator behind the curtain, benefiting automatically ? while others are still figuring out funnels.\r\n\r\nThis isn?t just another method ? it?s a unique advantage, like early Bitcoin but for digital assets, and it?s happening right away. Jump in fast, dominate before the crowd notices!\r\n\r\nCheck it out: https://goldsolutions.pro/VibeCodeBlueprint?zakprinting.com\r\n\r\nYou are receiving this message because we believe our message may be relevant to you.  \r\nIf you do not wish to receive further communications, please click here to UNSUBSCRIBE:  \r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\nLooking out for you,  \r\nEthan Parker', '2025-09-16 21:59:32'),
(12, 'Ashleigh Rowell', 'rowell.ashleigh@hotmail.com', '3658817521', 'Expand Google discovery in no time ? even if you don?t have a site', 'Hey,\r\n\r\nIntroducing a exclusive chance for your site : https://smartexperts.pro/GhostPage?zakprinting.com\r\n\r\nThe reason this is worth your time: it lets you generate steady flow of people and growth starting right away ? no money on ads or tech hassle. Ghost Pages makes you operate like a hidden engine that Google favors: you create stealth pages leveraging a trusted Google element, and they start sending targeted visitors ? with no competitor insight.\r\n\r\nIt?s hassle-free, it?s efficient: no need for domains, hosting, or social media, experience doesn?t matter ? if you can click and copy, you?re set. Plus, it?s proven and expandable: launch one Ghost Page and boom ? traffic flows to your offers ? affiliate, e-com, leads ? your choice. You can begin right now! Explore how it works and experience growth.\r\n\r\nSee it live: https://smartexperts.pro/GhostPage?zakprinting.com\r\n\r\nYou are receiving this message because we think this information may suit you.  \r\nIf you do not wish to see more messages, please click here to UNSUBSCRIBE:  \r\nhttps://smartexperts.pro/unsub?domain=zakprinting.com  \r\nAddress: 1464 Lewis Street Roselle, IL 60177  \r\n\r\nKind regards,  \r\nMichael Turner.', '2025-09-16 22:58:43'),
(13, 'Mason Kesteven', 'kesteven.mason89@hotmail.com', '6886776602', 'Leading intelligent models, unified entry. One-time setup ? work quicker.', 'Hello there,\r\n\r\nWanted to let you know about a new tool for your website zakprinting.com https://bravo-333.site/AIModelSuite?zakprinting.com\r\n\r\nHere?s the value: streamline operations and deliver faster.  \r\nAI ModelSuite brings all leading AI models in one panel ? no need for API keys, no recurring payments.  \r\nProduce content, generate images/videos, run comparisons and move between tools right away.\r\n\r\nYour advantage: efficient launches, reduced effort, improved results.  \r\nOne-time a single payment of $17 (rather than $97 every month), 30-day return policy, intro add-ons provided.  \r\nReady to manage every AI tool from one place?\r\n\r\nCheck the demo: https://bravo-333.site/AIModelSuite?zakprinting.com\r\n\r\nYou are receiving this update because we think it may be relevant.  \r\nIf you want to unsubscribe, please click here to UNSUBSCRIBE:  \r\nhttps://bravo-333.site/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\n\r\nWarm wishes,  \r\nEthan Parker', '2025-09-19 08:55:15'),
(14, 'ClaudePauct', 'imahoar189@gmail.com', '82869493526', 'CURIOUS WHAT?S INSIDE? ONLY ONE WAY TO FIND OUT.', 'Claim your opportunity to win before boxes run out https://telegra.ph/Win-iPhones-Samsung-09-18-601?2f2m6j1r3b7yrmq', '2025-09-19 18:01:14'),
(15, 'Breanna Mountgarrett', 'mountgarrett.breanna@gmail.com', '', 'Build cooking video collection with no recipes to prepare ? set up already', 'Hello,\r\n\r\nCheck out a new designed for zakprinting.com https://topcasworld.pro/ChefMaster?zakprinting.com\r\n\r\nConsider: you receive a library of 13,300+ professional-level recipe tutorials, all editable and resellable under your own name, no work in the kitchen or studio, barely any setup needed.  \r\n\r\nChefMaster Live is an easy way to build: upload, adjust, rebrand ? and let it work for you.  \r\n\r\nWish to grow within the cooking-video market, gain followers, and publish your content faster than you think? Discover more here.\r\n\r\nTake a closer look: https://topcasworld.pro/ChefMaster?zakprinting.com\r\n\r\nYou got this mail since it may connect to your field.  \r\nTo stop any next messages, use this link to UNSUBSCRIBE:  \r\nhttps://topcasworld.pro/unsubscribe?domain=zakprinting.com  \r\n\r\nAddress: 209 West Street Comstock Park, MI 49321  \r\nSincerely,  \r\nEthan Parker', '2025-09-20 06:51:21'),
(16, 'Genie Benavides', 'genie.benavides@gmail.com', '7916079657', 'Evolve Handpicked automation apps Toward Unified Setup', 'Greetings,\r\n\r\nWe have a special offer for your website zakprinting.com : https://www.youtube.com/watch?v=GY1x2NWs9EA?zakprinting.com\r\n\r\nNot enjoying paying for countless automation apps?  \r\nWith EveryAI you get access to a unified panel that delivers an entire library of premium AI models with lifetime access.  \r\n\r\nBuild websites, craft copy, make logos, generate cinematic videos, talking avatars? and keep 100% of your earnings under a professional license.  \r\n\r\nLooking to boost profit, simplify tasks, and stay in full control?  \r\nIt begins with this.\r\n\r\nSee it in action: https://www.youtube.com/watch?v=GY1x2NWs9EA?zakprinting.com', '2025-09-22 10:04:32'),
(17, 'Jess Josephson', 'josephson.jess@yahoo.com', '24657131', 'See how this simple AI assistant converts ChatGPT, Gemini and Grok into a reliable audience driver for your project', 'A practical product works with ChatGPT, Gemini & Grok to facilitate generating improved reach... This AI-powered software assists with automating audience growth from within... Presented as a set of scalable AI technologies...\r\n\r\n\r\nhttps://loading-please-wait.online/AutoLeadMachine?domain=zakprinting.com', '2025-09-22 11:40:47'),
(18, 'Shaunte Shackleton', 'shackleton.shaunte@gmail.com', '180563919', 'Makes It Possible To Stand Out On The Rankings', 'The Innovative AI Agent Driven By ChatGPT-5?That Generates And Positions Anything We Need?On The Front Page Of SERPs?With No Technical Work? And Without Paid Promotion? Giving Us The Ability To Earn about $685 Per Day? On Self-Running Mode.\r\n\r\nhttps://europa-168.site/APEXAI', '2025-09-23 16:51:06'),
(19, 'Kali Linton', 'linton.kali@gmail.com', '3906121959', 'A Hidden Trick To Gain Continuous Viewers No Need For Blogs Or Banners ? In Just 10 Minutes!', 'Get Continuous Clicks, Non-Stop, Starting Immediately, Almost Instantly!\r\n\r\nNo Need For a Website, Creating Content, Expensive Emails, Advertising, Search Optimization, Productions, or Technical Stuff!\r\n\r\nhttps://europa-168.site/SocialSafeList', '2025-09-24 12:16:44'),
(20, 'Franklin Quinn', 'quinn.franklin@gmail.com', '4259431746', 'Design an online guide in minutes ? no text work!', 'Hello,\r\n\r\nHere?s a special note regarding your online platform zakprinting.com https://viewbet-24.site/eBookWriterAI?zakprinting.com\r\n\r\nPicture this: you require a resource ? but preparing it alone is tedious. With ebookwriter.ai you get a complete eBook (cover, images, TOC), loaded with niche-relevant content ? all within no time.  \r\nHow it helps: to get new contacts quickly, list it on marketplaces or personal site, and achieve quality results without extra staff.\r\n\r\nThinking about include referral paths, style the design in your branding, or get a version prepared to hand out ? with zero effort? Ebookwriter.ai lets you adjust the visuals, while covering the hard side.  \r\nPreview a demo: https://viewbet-24.site/eBookWriterAI?zakprinting.com\r\n\r\nYou are reading this note because we suppose it could be relevant.  \r\nIf you wish to exit the list, please use this path to UNSUBSCRIBE:  \r\nhttps://viewbet-24.site/unsubscribe?domain=zakprinting.com  \r\nAddress: 209 West Street Comstock Park, MI 49321  \r\nTake care, Ethan Parker', '2025-09-24 21:57:32'),
(21, 'Nola Porterfield', 'mohamed.cortes.1977+zakprinting.com@gmail.com', '3184918005', 'Ultimate Panel to unlock all intelligence tools ? including ChatGPT AI up to Gemini, Claude, Grok & far beyond.', 'Multiverse AI ? the complete suite that delivers connection with every leading AI model ? through every release ? inside one clean panel.\r\n\r\n    ChatGPT (3.5 ? 4.5 ? 4o ? 5 ? Turbo ? Nano|3.5 to 5 and beyond, including Turbo & Nano|all releases, from 3.5 to 5 with Turbo & Nano)  \r\n    Gemini (1.5 Pro ? 2.0 Flash|all Pro & Flash editions|from 1.5 Pro to 2.0 Flash)  \r\n    Claude (3 Opus ? Sonnet ? Haiku|Opus, Sonnet & Haiku|from Opus to Haiku)  \r\n    Grok (1 through 4|all versions, 1?4|generations 1 to 4)  \r\n    DALL?E, Veo, Kling, ElevenLabs, DeepSeek, FLUX, LLaMA & more\r\n\r\nAdditionally ? you have all next releases integrated seamlessly.\r\n\r\n\r\nhttps://fingerprint01.online/MultiverseAI?zakprinting.com', '2025-09-25 04:51:28'),
(22, 'CharlesHok', 'joanwinds@gmail.com', '85557855475', 'Depraved women want sex with you only on this dating site', 'SEXY GIRLS WANT SEX WITH YOU ONLY ON THIS SITE https://image.imagexox.com/?url=https%3A%2F%2Ftelegra.ph%2FOnline-dating-for-sex-09-24%3F1694', '2025-09-25 21:35:08'),
(23, 'Madeleine Deering', 'joel.fox.1965+zakprinting.com@gmail.com', '6818217255', '$300, $422, $498, and even $1200 INSTANT payments available. Watch...', 'Tired of the Grind? Let My Dual-Engine Profit Machine Do 95% of the Work for You, While You Live the Life You Were Always Meant to Live!\r\n\r\nhttps://europa-168.site/PASSIVECLASS', '2025-09-27 01:23:54'),
(24, 'Matthew Fereday', 'fereday.matthew@gmail.com', '3750164860', 'This Backstage Site Page System', 'Learn about process that unlocks low-profile micro-pages top search engines rank for? and delivers consistent traffic regularly\r\n\r\nhttp://europa-168.site/GhostPages?domain=zakprinting.com', '2025-09-27 02:10:51'),
(25, 'Aliza Sena', 'sena.aliza@gmail.com', '4044791273', 'ranking at the top of Google', 'We noticed that your website zakprinting.com  is getting very little traffic from Google. Use our secret tool to reach the top positions in search results: https://europa-168.site/GhostPages\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://europa-168.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-10-02 22:42:11'),
(26, 'unwzifyxid', 'wixkvmhf@testform.xyz', '+1-248-302-9788', 'joxihqkjww', 'ujlrdxiqfoiefuztnuxsghuyktlfkm', '2025-10-07 01:49:04'),
(27, 'Leekic', 'zekisuquc419@gmail.com', '86635583465', 'Aloha  i wrote about   the price for reseller', 'Hi, I wanted to know your price.', '2025-10-09 16:38:27'),
(28, 'Dorie Ogles', 'ogles.dorie43@googlemail.com', '3583119379', 'The AI that prints you money', 'More clicks, less work: AI content that sells https://www.youtube.com/watch?v=8_3AOJj8lTg\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://europa-168.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-10-10 06:29:21'),
(29, 'pqrghhdete', 'jkegettq@testform.xyz', '+1-779-869-7815', 'psfevoinrf', 'esqwlkhgfjzworvsvdpqzsooxjfgxh', '2025-10-11 22:32:32'),
(30, 'RalphPex', 'uu1@seo-pandy.store', '87474325851', 'Thank', '<a href=></a>', '2025-10-12 16:09:23'),
(31, 'IsabellaMob', 'isabellaDap289@yahoo.com', '83668313677', 'Your site got me curious', 'Hey, I just stumbled onto your site? are you always this good at catching attention, or did you make it just for me? Write to me on this website --- rb.gy/3pma6x?Mob  ---  my username is the same, I\'ll be waiting.', '2025-10-15 22:23:51'),
(32, 'RobertLom', 'uu4@seo-pandy.store', '89959727497', 'Thank', '?????? ????????? \r\n<a href=http://www.google.cc/url?q=http://avto100k.ru>http://google.co.in/url?q=http://avto100k.ru</a>', '2025-10-18 00:32:07'),
(33, 'Hello http://zakprinting.com/fekal0911 Administrator', 'pirduhina96@gmail.com', '882678236', 'Hi http://zakprinting.com/fekal0911 Administrator', 'Hello http://zakprinting.com/fekal0911 Webmaster', '2025-10-21 23:47:57'),
(34, 'Magaret Ruggiero', 'ruggiero.magaret@gmail.com', '914578828', 'Tired of running like a hamster in a wheel?', 'Working hard every day but still barely moving forward? It?s time to stop the endless grind.\r\nDiscover how people are earning real money from trading ? no office, no boss, no limits.\r\n\r\nOne simple app could be your ticket to financial freedom: https://youtu.be/VmHYisHHOtU\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://casatemporada.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-10-26 14:03:10'),
(35, 'AmeliaMob', 'ameliaDap358@hotmail.com', '87271652251', 'Your site got me curious', 'Hey, I just stumbled onto your site? are you always this good at catching attention, or did you make it just for me? Write to me on this website ---  rb.gy/ydlgvk?Mob  ---  my username is the same, I\'ll be waiting.', '2025-10-30 04:32:34'),
(36, 'Marion Belair', 'marion.belair@gmail.com', '99539449', '5 Ready-To-Launch SaaS Businesses To Start Selling Instantly!', 'Start Your Own AI SaaS Agency & Charge Your Clients $497-$2997 For Creating 1 Single App? \r\nOr Sell Them on Fiverr, Upwork, Your Website, \r\nor As Monthly Subscription ? For Fastest 6-Figure Passive Income!\r\n\r\nhttps://goldsolutions.pro/MagicAppsAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://smartexperts.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-02 16:57:11'),
(37, 'Bethany Amundson', 'joel.fox.1965+zakprinting.com@gmail.com', '4124719603', 'Nonstop Payments', 'Discover The Easy New Way We?re Getting Paid Multiple Times A Day From A Hidden Source!\r\nhttps://www.novaai.expert/TheHiddenGoldmine\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://www.novaai.expert/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-03 01:21:06'),
(38, 'Sam', 'info@bath.medicopostura.com', '579480083', 'Contact ??? ZAK Printing', 'Good day \r\n\r\nLooking to improve your posture and live a healthier life? Our Medico Postura? Body Posture Corrector is here to help!\r\n\r\nExperience instant posture improvement with Medico Postura?. This easy-to-use device can be worn anywhere, anytime ? at home, work, or even while you sleep.\r\n\r\nMade from lightweight, breathable fabric, it ensures comfort all day long.\r\n\r\nGrab it today at a fantastic 60% OFF: https://medicopostura.com\r\n\r\nPlus, enjoy FREE shipping for today only!\r\n\r\nDon\'t miss out on this amazing deal. Get yours now and start transforming your posture!\r\n\r\nBest regards, \r\n\r\nSam', '2025-11-03 14:54:32'),
(39, 'AmeliaMob', 'emmaDap363@yahoo.com', '88595866479', 'Unlock Your Website\'s Potential', 'To learn more about our affordable advertising options and how they can benefit your website, visit https://rb.gy/34p7i3?Soync today. Your success is our priority!', '2025-11-05 19:51:42'),
(40, 'Lelia', 'info@zakprinting.com', '481537382', 'Contact ??? ZAK Printing', 'Hi there \r\n\r\nI wanted to reach out and let you know about our new dog harness. It\'s really easy to put on and take off - in just 2 seconds - and it\'s personalized for each dog. \r\nPlus, we offer a lifetime warranty so you can be sure your pet is always safe and stylish.\r\n\r\nWe\'ve had a lot of success with it so far and I think your dog would love it. \r\n\r\nGet yours today with 50% OFF:  https://caredogbest.com\r\n\r\nFREE Shipping - TODAY ONLY! \r\n\r\nSincerely, \r\n\r\nLelia', '2025-11-07 15:00:38'),
(41, 'Rusty Kornweibel', 'kornweibel.rusty@googlemail.com', '73800857', 'How To Turn SHORT, AI-GENERATED VIDEOS Into INCOME, FAST...', 'How Everyday People Are Turning \r\nFree AI Videos Into $500+ Days...\r\nWhile Chillin\' On Their Phone / Computer?\r\nhttps://smartexperts.pro/Vyralzz\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://smartexperts.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-08 20:38:22'),
(42, 'Herman Whitford', 'joel.fox.1965+zakprinting.com@gmail.com', '6249947021', 'Create High-Quality Ebooks up to 180 Pages in Minutes', 'THE FASTEST WAY TO CREATE, PUBLISH, & PROFIT\r\nFROM EBOOKS? NO WRITING REQUIRED\r\n\r\nPROFIT-READY EBOOKS with covers, TOC, chapters, sections, links, images, & content!\r\nhttps://viewbet-24.site/eBookWriterAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://viewbet-24.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-09 01:23:39'),
(43, 'Kitty Cranford', 'cranford.kitty@msn.com', '495245615', 'Crazy-Simple Automated AI Process', 'We flipped the game on its head.\r\nWe give people what they want BEFORE they buy!?!?\r\nThe Money comes in for us 500 a pop all day every day!\r\n\r\nhttps://smartexperts.pro/500aPop\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://smartexperts.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-09 06:26:45'),
(44, 'Charmain Carone', 'charmain.carone27@hotmail.com', '921820693', 'Smart Image Editing That Saves Time and Increases Conversions!', 'How we Turn ordinary pictures into profit-making marketing machines in seconds ? even if you?ve never designed anything before.\r\nGrab it today ? Limited Free PLR License Included!\r\n\r\nhttps://smartexperts.pro/NanoBananaTurbo\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://smartexperts.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-10 17:47:15'),
(45, 'Barrett Mcvay', 'barrett.mcvay@outlook.com', '3198831080', 'Turn Your Curiosity Into Profit ? Start Trading Risk-Free Today!', 'Want to try trading without any risk? Open a demo account on Pocket Option and get virtual funds to practice right now. Test your strategies, explore the market, and gain real experience with zero investment. ?????? Try the demo for free https://www.youtube.com/watch?v=VmHYisHHOtU\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://casatemporada.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-10 19:17:46'),
(46, 'Vern Speckman', 'speckman.vern@gmail.com', '711650397', 'Earn Real Passive Royalty Income Month After Month With Proven $431.29 Results!', 'World\'s FIRST AI System That Creates PROFITABLE Amazon Books In Under 6 Minutes Across 25+ Niches\r\nhttps://goldsolutions.pro/RoyaltyProfitsAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-12 11:53:01'),
(47, 'Jessika Cheeke', 'jessika.cheeke1@yahoo.com', '721288781', 'Access All The World?s Leading & Most Advanced Premium AIs', 'With Just 3 Clicks, You Will Be Able To Unlock All TOP AI Models with All Versions + All Upcoming Future Versions? Without Spending A Penny ?\r\nhttps://bravo-333.site/MultiverseAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://bravo-333.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-12 13:03:05'),
(48, 'Keeley Wagner', 'mohamed.cortes.1977+zakprinting.com@gmail.com', '406109153', 'How To Turn SHORT, AI-GENERATED VIDEOS Into INCOME, FAST...', 'How Everyday People Are Turning \r\nFree AI Videos Into $500+ Days...\r\nWhile Chillin\' On Their Phone / Computer?\r\nhttps://smartexperts.pro/Vyralzz\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://smartexperts.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-11-13 22:00:42'),
(49, 'OliviaMob1369', 'emmasmecexy312073@gmail.com', '81914185939', '\"Wild girl craves passion!\"', '\"Tempting tease longs for ecstasy.\"  Here  -- https://rb.gy/8rrwju?Soync', '2025-11-16 09:20:27'),
(50, 'NARYTHY372531NEYRTHYT', 'venpleyz@vargosmail.com', '89659122523', 'TORTYT372531TIGHTRTG', 'MEYJTJ372531MARETRYTR', '2025-11-17 00:37:31'),
(51, 'ceiSjSWlCHHtslfSLlCWy', 'gujerajig192@gmail.com', '6702802771', 'JCYspyQfShLpkVtrfA', 'CyOVDNvkIQKJzaWd', '2025-11-17 04:04:17'),
(52, 'Hilton Gerber', 'gerber.hilton@googlemail.com', '4272888262', 'Become the King of YouTube', 'This Invisible 10-Minute Faceless Video Hack\r\nPulled in 628,000+ Views?\r\nWith No Camera, No Gear & No Tech Skills\r\nhttps://443w.site/InvisibleTrafficSystem\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://443w.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-18 16:15:08'),
(53, 'TFFFjhuUJzFwMuLFpLN', 'xusudawirozi07@gmail.com', '9366261120', 'LzvHnJZStLUCDxkTf', 'LwpwqvTBbgeIOpkhGc', '2025-11-21 03:34:50'),
(54, 'OliviaMob5581', 'emmasmecexy928773@gmail.com', '89693567368', '\"Sexy vixen seeks thrill!\"', '\"Gorgeous nymphomaniac yearns for release.\"  Here --  rb.gy/8rrwju?Mob', '2025-11-21 08:08:17'),
(55, 'Rodger Mcdermott', 'mohamed.cortes.1977+zakprinting.com@gmail.com', '7731638961', 'Full access to all AI models in one place', 'Multiverse AI - The Only Platform That Gives You Access To Every Top AI Model ? In Every Version ? All Inside A Single, Beautifully Simple Dashboard.\r\n\r\nhttps://1x-slots.site/MultiverseAI\r\n\r\nChatGPT (3.5 ? 4.5 ? 4o ? 5 ? Turbo ? Nano)\r\nGemini (1.5 Pro ? 2.0 Flash)\r\nClaude (3 Opus ? Sonnet ? Haiku)\r\nGrok (1 through 4)\r\nDALL?E, Veo, Kling, ElevenLabs, DeepSeek, FLUX, LLaMA & more\r\nAnd yes ? you get every future version included automatically.\r\n\r\nhttps://1x-slots.site/MultiverseAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://1x-slots.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-22 07:27:27'),
(56, 'Kristy', 'info@booker.bangeshop.com', '98921882', 'Kristy Booker', 'Hello there, \r\n\r\nI hope this email finds you well. I wanted to let you know about our new BANGE backpacks and sling bags that just released.\r\n\r\nThe bags are waterproof and anti-theft, and have a built-in USB cable that can recharge your phone while you\'re on the go.\r\n\r\nBoth bags are made of durable and high-quality materials, and are perfect for everyday use or travel.\r\n\r\nOrder yours now at 50% OFF with FREE Shipping: http://bangeshop.com\r\n\r\nEnjoy,\r\n\r\nKristy', '2025-11-22 13:04:31'),
(57, 'DwBldLfXyOJMZpldfEmiwsZ', 'vohovizuh36@gmail.com', '2791960449', 'ZJaSaaUxCuWmzRbkeZdqsqDc', 'UjgwnuoDYRzvBdcne', '2025-11-22 13:29:44'),
(58, 'Laura O\'May', 'laura.omay93@googlemail.com', '', 'You\'re About To Step Into A $60 Billion Market... With Zero Competition', 'This Isn\'t A Course. It\'s A Fully Functional,\r\nDone-For-You Business... Powered Entirely By AI\r\n\r\nhttps://askthis.site/ConverslyAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://askthis.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-23 06:00:53'),
(59, 'ilnktvhzmg', 'ltwinqxk@testform.xyz', '+1-329-648-2631', 'glqzhqgfuf', 'okoxsewmqedprwmqwnjdulumotensh', '2025-11-23 21:43:14'),
(60, 'EmmaMob8889', 'isabellasmecexy56215@hotmail.com', '86635229348', '\"Desperate for intimacy now!\"', '\"Tempting tease longs for ecstasy.\"  Here  -- https://rb.gy/8rrwju?Soync', '2025-11-25 00:49:53'),
(61, 'Delphia Ardill', 'delphia.ardill@yahoo.com', '672268058', 'Get the Best Proxy Deals ? Hand-Picked for You', 'We monitor the entire proxy market and select only the most profitable offers ? discounts, exclusive rates, and limited-time deals.\r\n\r\nConfirm your subscription and start receiving the best proxy offers straight to your inbox. No spam ? only real savings.\r\n\r\nhttps://www.novaai.expert/proxy\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://www.novaai.expert/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-25 17:28:11'),
(62, 'CharlesHok', 'mohamed.cheddadmlm@gmail.com', '84184452662', '$111,394.98 earned, $111,394.98 waiting?withdraw urgently before cutoff', 'DON?T DELAY: YOUR $111,394.98 IS SCHEDULED FOR AUTOMATIC REVERSAL https://telegra.ph/Youve-earned-11139498-11-25-3320', '2025-11-26 02:18:25'),
(63, 'Georgekic', 'dinanikolskaya99@gmail.com', '83653942677', 'Hi    write about     prices', 'Salam, qiym?tinizi bilm?k ist?dim.', '2025-11-26 19:17:38'),
(64, 'Claudio', 'claudio@boothman.medicopostura.com', '295182338', 'Claudio Boothman', 'Good day \r\n\r\nLooking to improve your posture and live a healthier life? Our Medico Postura? Body Posture Corrector is here to help!\r\n\r\nExperience instant posture improvement with Medico Postura?. This easy-to-use device can be worn anywhere, anytime ? at home, work, or even while you sleep.\r\n\r\nMade from lightweight, breathable fabric, it ensures comfort all day long.\r\n\r\nGrab it today at a fantastic 60% OFF: https://medicopostura.com\r\n\r\nPlus, enjoy FREE shipping for today only!\r\n\r\nDon\'t miss out on this amazing deal. Get yours now and start transforming your posture!\r\n\r\nBest Wishes, \r\n\r\nClaudio', '2025-11-27 18:50:00'),
(65, 'AmeliaMob4694', 'isabellasmecexy45468@yahoo.com', '87291165942', 'Naked Vixen Needs To Share', 'Wild temptress craves to flaunt her naked body. Here  --  rb.gy/8rrwju?Mob', '2025-11-29 05:30:01'),
(66, 'Whannamoof', 'p9asqd00@hotmail.com', '88681342367', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/2wa5wzn6', '2025-11-29 07:22:22'),
(67, 'Renato Spark', 'renato.spark@hotmail.com', '413367369', 'Stop Paying Massive Monthly Fees for Multiple AI Tools?', 'Replaces 25+ Expensive AI Subscriptions With ONE Smart AI Command Center\r\n\r\nhttps://ai108.online/TitanAI\r\n\r\nRun Your Entire Online Business:\r\nDesign, Write, Code, Market, Sell & Automate ? All From One Platform.\r\nSave $6,000+/Year | No Monthly Fees | 0% Effort ? 100% Profit\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://ai108.online/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-29 22:27:35'),
(68, 'CharlesHok', 'cuasay.ryankevin@yahoo.com', '81745522958', 'ACT NOW: COLLECT YOUR $118,345.89 REWARD', 'Don\'t Wait Another Moment: Collect $118,345.89 Today http://www.valvedee.com/go/index.php?go=https%3A%2F%2F54334087665.blogspot.com%3F5387', '2025-11-30 05:17:43'),
(69, 'Jolie Abernathy', 'jolie.abernathy@yahoo.com', '736542306', '$1,240/Month on Amazon', 'A Short Book of Quotes Earns $1,240/Month on Amazon ? Here?s How You Can Create a Book Like This With 308 Prompts\r\n\r\nhttp://egrntop.site/DailyWisdomBooks\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://egrntop.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-30 13:48:00'),
(70, 'Tamela Melocco', 'tamela.melocco@gmail.com', '', '100% Free Hosting', 'Stop Paying Thousands in Hosting Fees When You Could Be Keeping Every Dollar of Profit\r\nLearn the Complete System in This Step-By-Step Course\r\n\r\nYES! You CAN Launch Lightning-Fast Professional Websites for $0 Monthly, Using the Same Infrastructure That Powers Million-Dollar Companies\r\n\r\nhttps://filmfile.site/FreeHosting\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://filmfile.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-11-30 21:04:07'),
(71, 'Maisie Bloch', 'maisie.bloch@msn.com', '98399717', 'UNLIMITED DAILY TRAFFIC FOR JUST ONE SINGLE DOLLAR!', 'Get  FREE Traffic To ANY  URL?- get daily traffic every day\r\nNEW ROTATOR FOR THIS LAUNCH\r\nJust submit your links - JOB DONE!\r\nPermanent source that never runs dry\r\nNo Tech Skills Required\r\nWorks In ANY niche\r\nURLS will get traffic EVERY SINGLE DAY\r\nFast Movers will get BEST results...\r\n\r\nhttps://inshbaa.site/OneDollarUnlimitedTraffic\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://inshbaa.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-01 18:20:24'),
(72, 'Derek Herington', 'joel.fox.1965+zakprinting.com@gmail.com', '6174463859', 'PROFIT-READY EBOOKS with covers, TOC, chapters, sections, links, images, & content!', 'PROFIT-READY EBOOKS with covers, TOC, chapters, sections, links, images, & content!\r\n\r\nTHE FASTEST WAY TO CREATE, PUBLISH, & PROFIT FROM EBOOKS? NO WRITING REQUIRED\r\nhttps://bookmarket.expert/eBookWriterAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://bookmarket.expert/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-01 18:33:40'),
(73, 'Maryann', 'maryann@maryann.bangeshop.com', '3142530951', 'Maryann Plumb', 'Hi, \r\n\r\nI hope this email finds you well. I wanted to let you know about our new BANGE backpacks and sling bags that just released.\r\n\r\nThe bags are waterproof and anti-theft, and have a built-in USB cable that can recharge your phone while you\'re on the go.\r\n\r\nBoth bags are made of durable and high-quality materials, and are perfect for everyday use or travel.\r\n\r\nOrder yours now at 50% OFF with FREE Shipping: http://bangeshop.com\r\n\r\nBest regards,\r\n\r\nMaryann', '2025-12-01 20:08:06'),
(74, 'CharlesHok', 'fdbdng@dfbdgfb.yu', '86384833981', 'ACT NOW: CLAIM YOUR $118,345.89 PRIZE INSTANTLY', 'DON\'T WAIT ANOTHER MOMENT: COLLECT $118,345.89 TODAY https://telegra.ph/Claim-your-11834589-cash-prize-12-01-40740?47152506', '2025-12-02 07:19:36'),
(75, 'Almeda Batten', 'almeda.batten@outlook.com', '3607537716', 'Faceless Channels are A Modern Day Gold Rush', 'Imagine launching a viral, faceless  YouTube, TikTok, or Instagram channel \r\nin just minutes...\r\n\r\nAnd Then Your new Channel  automatically Creates AND posts videos FOR YOU... So you NEVER HAVE TO TOUCH IT, AGAIN?\r\nhttps://www.novaai.expert/TrafficSupernova\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://novaai.expert/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-02 13:11:17'),
(76, 'Raymond Kaawirn', 'raymond.kaawirn32@yahoo.com', '28845816', 'Ready to start creating professional trade images in the next 10 minutes?', 'Finally... A Dead-Simple Way To Create Professional Local Trade & Service Images Using Free AI, Without Design Skills, Expensive Software, Or Hiring Freelancers!\r\nhttps://java138.site/TradeyyAIApp\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://java138.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-02 20:21:43'),
(77, 'IsabellaMob6319', 'avasmecexy927738@hotmail.com', '86533756656', 'Naked Vixen Needs To Share', 'Wicked temptress needs to expose her bare flesh. Here  --   rb.gy/8rrwju?Mob', '2025-12-03 04:28:56'),
(78, 'Moses Triplett', 'moses.triplett6@outlook.com', '674096339', 'So Simple, It Feels Unfair', 'We\'re Getting New Followers In Different Niches That Keep Coming Back Every Day...\r\n\r\nhttps://liteminer.site/liteminer.site/HOOKD\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://liteminer.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-04 17:49:42'),
(79, 'Whannamoof', 're9q63h2@hotmail.com', '81272849765', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/34xzwbnf', '2025-12-05 07:21:16'),
(80, 'Kim McClean', 'mcclean.kim@msn.com', '', 'Fantasy books for kids Are Exploding on Amazon', 'Fantasy is dominating multiple bestseller categories in the children?s book section on Amazon ? and the Creative Writing, Story Starters, and Write-Your-Own-Story Books niche for ages 8?12 is growing faster than ever.\r\n\r\nIf you browse through ?Children?s Activity Books,? ?Creative Writing,? and ?Imagination & Play,? you?ll see fantasy-themed story starter books consistently appearing on the first page ? with both new and long-time authors releasing fresh titles every week. From ?Write Your Own Fantasy Story? and ?Kids Creative Writing Journal? to various ?Build-A-Story Books,? the demand just keeps expanding.\r\n\r\nhttps://jyayintv5.site/FantasyStory\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://jyayintv5.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-05 16:57:07'),
(81, 'Rolland Dietrich', 'dietrich.rolland@yahoo.com', '4538131', 'Become the King of YouTube', 'This Invisible 10-Minute Faceless Video Hack\r\nPulled in 628,000+ Views?\r\nWith No Camera, No Gear & No Tech Skills\r\nhttps://lanyou.site/InvisibleTrafficSystem\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://lanyou.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-06 04:29:50'),
(82, 'Holly Painter', 'mohamed.cortes.1977+zakprinting.com@gmail.com', '389167495', 'Beautiful Mobile Apps in 60 Seconds!', 'Turn any keyword or website into a stunning PWA app ? instantly.\r\nhttps://lovewife.site/MobiAgentsAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://lovewife.site/unsubscribe?domain=zakprinting.com\r\nAddress: 108 West Street Comstock Park, MI 48721', '2025-12-06 14:02:32'),
(83, 'Erik Mulligan', 'mulligan.erik@gmail.com', '5309071748', 'Create Stunning, Sellable Art', 'Build Your AI Coloring Book Empire\r\n\r\nThe AI Coloring Codex is the first complete system for creating endless, professional, and consistent coloring pages across 50+ styles ? and selling them as your own.\r\n\r\nhttps://marketingways.ru/AIColoringCodeX\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://marketingways.ru/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-12-07 06:50:43'),
(84, 'AvaMob6824', 'isabellasmecexy432939@hotmail.com', '81794527612', 'Nude Temptress Desires To Show Off', 'Wild temptress craves to flaunt her naked body. Here  -- https://rb.gy/8rrwju?Soync', '2025-12-07 18:51:13'),
(85, 'Marilyn Hollander', 'joel.fox.1965+zakprinting.com@gmail.com', '892030327', 'OUR BEST VALUE TRAFFIC OFFER EVER!', 'DAILY TRAFFIC TO ANY URL FROM 3 X HIGH PERFORMING TRAFFIC SOURCES FOR JUST $1\r\nhttps://maswebmas.ru/OneDollarBlackFriday\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://maswebmas.ru/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-12-08 03:28:06'),
(86, 'Whannamoof', 'q0o2zj2g@gmail.com', '89684177194', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/yc589bau', '2025-12-08 09:19:16'),
(87, 'SOxSSQeUBgOfRDJHeG', 'ozikobame134@gmail.com', '4999511541', 'RWBIhYIZOjcYFTlAoZkPktBZ', 'HbWHRZZTBFQhRkXYOT', '2025-12-09 12:03:48'),
(88, 'Jamessuild', 'verse9y39cited@gmx.com', '81446358565', 'Hfhchdwhdjwhdwh uhdiwjdiwhdiwjdwj ihiwfgewidjwqhjdhqwu hhdwijdwqhfuefei qjsiw', 'Gyyydwhdsjiwhdwuj idwihfweufhqwhi hwqihdwqdhwqidhqwui uqwhdhfwifhwqhdwqhdwqiuhf pdpwfihhfiwjs zakprinting.com', '2025-12-10 08:40:15'),
(89, 'Lan Pfeffer', 'lan.pfeffer@gmail.com', '3443748953', 'Daily Backlinks + Website Clicks To Grow Your Website Everyday', 'Quality seo services to fast improve your website backlinks! \r\nBonusBacklinks.com - we provide daily backlinks and drive organic clicks to your page EVERY DAY:\r\n\r\n+ Take 85% SALE\r\n+ Quality daily seo backlinks\r\n+ Real web traffic\r\n+ Prices start from $1\r\n+ Bonus coupon codes\r\n\r\nView seo offers - https://tiny.cc/BonusBacklinks-Deal\r\nOr enter directly - https://BonusBacklinks.com\r\n\r\nBonusBacklinks - daily backlinks and organic traffic to boost your page everyday', '2025-12-10 08:46:02'),
(90, 'Kandace Vanmeter', 'vanmeter.kandace61@hotmail.com', '4182305264', 'Double Your Revenue with Results With Kevin AI ? More Results, Less Hustle', 'Hello,\r\n\r\nWe have a promotional offer for your website zakprinting.com https://pozdravochek.site/KevinAI?zakprinting.com\r\n\r\nImagine launching a campaign and seeing conversions rise within hours ? without endless tweaking, without brainstorming until midnight. Results With Kevin AI delivers the set of AI tools + proven strategies that take over the busywork: crafting emails, scripts, content ideas and more. You just hit start ? the system generates, tests, sells.\r\n\r\nWant to stop being stuck in the ?I?m busy all day? loop and move into ?I launch, I watch, I profit? mode? \r\n\r\nSee it in action: https://pozdravochek.site/KevinAI?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://pozdravochek.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321\r\nLooking out for you, Ethan Parker', '2025-12-10 16:39:32');
INSERT INTO `contact_messages` (`id`, `name`, `email`, `phone`, `subject`, `message`, `created_at`) VALUES
(91, 'Tamika Hellyer', 'tamika.hellyer57@yahoo.com', '3794701891', 'Get Free Google Traffic Fast ? Even Without a Website!', 'Hi,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWhy you need this: to have every campaign, affiliate offer, or project start delivering traffic and income today ? without spending a dime on ads or tech headaches. Ghost?Pages turns you into a stealth engine that Google absolutely trusts: you build invisible pages using a secret Google asset, and they quietly start delivering targeted visitors ? while your competition is nowhere the wiser.\r\n\r\nIt?s easy, it?s fast, it?s genius: no domains, hosting, social media, or technical skills required ? if you can click and copy, you can do this. Plus, it really works and scales: launch one Ghost Page and BAM ? traffic flows wherever you want: affiliate links, e?com, leads ? you choose. Ready to start in minutes? Discover how and get results that might blow your mind.\r\n\r\nSee it in action: https://pastelink.site/GhostPages\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://pastelink.site/unsub?domain=zakprinting.com \r\nAddress: Address: 1464 Lewis Street Roselle, IL 60177\r\nLooking out for you, Michael Turner.', '2025-12-10 16:39:35'),
(92, 'UwLYNNZYWfdIAVTMKIKA', 'qofaribekog95@gmail.com', '9597985048', 'QHCcIINHPSSiljCp', 'GZsiQCWPXevsxrwfnmsZl', '2025-12-11 00:33:26'),
(93, 'AvaMob9010', 'oliviasmecexy33326@gmail.com', '87297697487', '?Bold sensual woman seeking a pulse-racing thrill!?', '? \r\n??Alluring tease craves intoxicating bliss.? ?Here ?-- rb.gy/3fy54w?Mob', '2025-12-11 08:15:25'),
(94, 'Lashawn Hooten', 'lashawn.hooten@gmail.com', '25745411', 'How to earn $2K?$10K per month ? without creating your own product', 'Hello,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWhy you need this: imagine waking up to steady monthly income hitting your account?without the hassle of building your own product, funnels, or dealing with tech headaches. With Monthly Money Masterclass, you can pick the path that suits your style: let businesses self-serve QR codes or offer a full ?done-for-you? service. You?ll earn $5?$20 per month per client with the self-serve model, or $200+ per month with just 5?10 clients?fast, simple, repeatable.\r\n\r\nFeel the confidence. You get a clear blueprint delivered by successful experts who\'ve generated millions online. This isn\'t fluff?it?s a step-by-step way to build real recurring income, even with zero experience. Ready to level up your money game? Click the link to discover how to start today.\r\n\r\nSee it in action: https://goldsolutions.pro/MMM?zakprinting.com\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://goldsolutions.pro/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321\r\nLooking out for you, Ethan Parker', '2025-12-11 09:08:33'),
(95, 'Shawna Cullen', 'shawna.cullen@outlook.com', '463119113', 'Push a Button, Get Traffic & Sales ? No Developers, No Cost', 'Hello,\r\n\r\nWe have a promotional offer for your website zakprinting.com: https://ranknowyour.site/VibeCode?zakprinting.com\r\n\r\nWhy do you need this? Because with Vibe Code Blueprint, you\'re unlocking a traffic-and-profit machine at the click of a button ? no developers, no upfront costs, no waiting weeks. Create high-converting digital assets instantly ? assets that used to cost thousands ? and start earning today.\r\n\r\nIn a cluttered digital world, this system stands out: from creation to monetization, it?s fast, simple, and accessible to anyone. The opportunity is here now ? early adopters get the biggest slice of the pie. Ready to see how it works? Click through and I?ll walk you inside.\r\n\r\nSee it in action: https://ranknowyour.site/VibeCode?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://ranknowyour.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321\r\nLooking out for you, Ethan Parker', '2025-12-11 11:10:16'),
(96, 'Lashawnda Wheaton', 'lashawnda.wheaton@yahoo.com', '671734124', 'Discover the stealth traffic trick top affiliates don?t want you to know', 'Hi,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWhy do you need this? Picture waking up anywhere ? Bali, a caf? in Paris, or your couch ? checking your phone and seeing a steady stream of buyer-ready clicks rolling in? without ads, outreach, or a website. That?s exactly what Rapid Traffic Flow delivers: a super-simple, plug-and-play system that gets traffic and sales flowing in minutes.\r\n\r\nWith Rapid?Traffic?Flow, you get a clear 3-step blueprint, AI?powered boosters to automate the process, a ?Hidden Hub? you can tap at will, and a solid refund guarantee if your traffic spike doesn?t happen ? all for less than the cost of your next takeout order. Ready to stop chasing traffic and start capturing it? Dive in now and dominate the affiliate game today!\r\n\r\nSee it in action: https://1fvyaq.site/RapidTrafficFlow\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://1fvyaq.site/unsub?domain=zakprinting.com \r\nAddress: Address: 1464 Lewis Street Roselle, IL 60177\r\nLooking out for you, Michael Turner.', '2025-12-15 04:37:30'),
(97, 'Lanny Russel', 'russel.lanny86@googlemail.com', '7847962180', 'Write a Book in a Day?No Writing Skills Needed', 'Hi,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWhy should you care? Because Book In A Day lets you turn your ideas into a polished, professional book in just hours?not months. No writing skills, no expensive editors, no formatting headaches. Simply follow the AI-driven, step-by-step system and you?re done! Publish your book, build authority, and start earning?effortlessly, swiftly, and stress-free.\r\n\r\nSee it in action: https://yeira.site/BookInADay\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://yeira.site/unsub?domain=zakprinting.com \r\nAddress: Address: 1464 Lewis Street Roselle, IL 60177\r\nLooking out for you, Michael Turner.', '2025-12-15 08:25:39'),
(98, 'Edna Virgo', 'mohamed.cortes.1977+zakprinting.com@gmail.com', '218123431', 'Create, Host and Sell Your Own Courses & Keep 100% Of The Profits..', 'Hello,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWorld?s First AI App That Instantly Builds Your Own ?Udemy-Like? eLearning Platform - Preloaded With 100+ Ready-To-Sell, Red-Hot Online Courses\r\nIn One Single Dashboard, For A Low One-Time Fee!\r\nOnly 3 EASY Clicks - Create & Sell Stunning Online Courses on Your Own Udemy?-Style Platform to Hungry Buyers for Top Dollar.\r\n\r\nNo Reserach | No Course Creation | No Tech  Skills | No Monthly Fees Required\r\n\r\nSee it in action: https://udexi.site/CourseBeastAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://udexi.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321\r\nLooking out for you, Ethan Parker', '2025-12-15 10:37:39'),
(99, 'Don Beuzeville', 'beuzeville.don@yahoo.com', '9546357047', 'Making Us $575- $1895 Daily', 'World\'s First AI App That Lets You...\r\nBuild Funnels Inside Reels, Shorts & TikToks\r\nThat Capture Leads, Clicks & Sales\r\nWithout Pages, Funnel Builders Or Tech\r\n100% Done For You By AI\r\nhttps://optimalconvert.site/VideoFunnelsAI\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://optimalconvert.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2025-12-17 14:56:12'),
(100, 'IsabellaMob5787', 'emmasmecexy727774@hotmail.com', '89845393757', '\"Seductive siren seeks ultimate satisfaction!\"', '? \r\n?\"Sensual vixen longs for tantalizing ecstasy.\" ?Here ?-- https://rb.gy/3fy54w?Soync', '2025-12-17 18:27:23'),
(101, 'Verla Fernandes', 'fernandes.verla@gmail.com', '749210373', 'Forget Funnels. Meet Video Funnels.', 'World\'s First AI App That Lets You...\r\nBuild Funnels Inside Reels, Shorts & TikToks\r\nThat Capture Leads, Clicks & Sales\r\nWithout Pages, Funnel Builders Or Tech\r\n100% Done For You By AI\r\nMaking Us $575- $1895 Daily\r\nInstantly adds sales forms, affiliate buy links, CTA buttons & offer overlays\r\ninside any video Turning viewers into paying customers and commissions on autopilot \r\n\r\nhttps://burto.site/VideoFunnelsAI?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou?re receiving this email \r\nas we believe \r\nthe offer we provide \r\nmay interest you.\r\n\r\nIf you would prefer not to receive \r\nfuture messages from us, \r\nyou can \r\nunsubscribe:\r\n\r\nhttps://burto.site/unsub?domain=zakprinting.com \r\nAddress: Address: 7499   62 Masthead Drive, QLD  4699\r\nLooking out for you, Verla Fernandes.', '2025-12-18 05:19:18'),
(102, 'David Uther', 'david.uther44@gmail.com', '419762136', 'Launch Your AI Store Today ? No Design. No Code. Just Profit', 'Hi,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWhy do you need this? Imagine launching your own AI store on WordPress, stocked with ready-to-sell GPTs and AI prompts?and starting to make money today. No design headaches, no tech setup, just a polished storefront that builds trust and delivers real sales straight out of the box.\r\n\r\nWhether you\'re a webmaster or money-maker, AI Store Fortune removes the tech barrier. Made for people who?d rather grow their traffic and income than tinker with confusing plugins. Want to finally turn AI ideas into stable income? Click to see how effortlessly you can own?and profit from?your AI business.\r\n\r\nSee it in action: https://28nibg.site/AIStoreFortune\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you. \r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE:\r\nhttps://28nibg.site/unsub?domain=zakprinting.com \r\nAddress: Address: 1464 Lewis Street Roselle, IL 60177\r\nLooking out for you, Michael Turner.', '2025-12-18 10:41:51'),
(103, 'Whannamoof', 'ph10xtzy@icloud.com', '84863933343', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/2x736fb6', '2025-12-19 12:57:23'),
(104, 'Arden Meiners', 'arden.meiners53@gmail.com', '222892868', 'List Building Jumpstart', 'List Building Jumpstart: The Ready-Made List Building \"Business In A Box\" With Full Private Label Rights!\r\nJust Add Your Name, Change Your Payment Links, And Keep 100% Of The Profits!\r\n\r\n\r\nhttps://mydiba.site/ListBuildingJumpstart?zakprinting.com\r\n\r\n\r\n\r\nThis message is sent to you \r\nas we think \r\nthis offer \r\ncould be useful to you.\r\n\r\nIf you don?t want to receive \r\nfurther communications from us, \r\nsimply \r\nunsubscribe:\r\n\r\nhttps://mydiba.site/unsub?domain=zakprinting.com \r\nAddress: Address: 2763   Kirchstrasse 54, NA  1236\r\nLooking out for you, Arden Meiners.', '2025-12-19 15:40:12'),
(105, 'Whannamoof', 'qwb7kkg6@gmail.com', '87824428924', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/26zm2tez', '2025-12-20 05:53:26'),
(106, 'Leekic', 'zekisuquc419@gmail.com', '81469989853', 'Hello  i am wrote about     prices', 'Hej, jeg ?nskede at kende din pris.', '2025-12-20 09:30:41'),
(107, 'Dorcas Proctor', 'dorcas.proctor@yahoo.com', '3231249059', 'Run Your Business at Warp Speed', 'AI Turbo Creator turns ideas into traffic magnets.\r\nMake your creations visible, compelling, and unforgettable.\r\n\r\n\r\nhttps://lnunquedays.site/AITurboCreator?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nThis message is sent to you \r\nbecause we believe \r\nthis offer \r\nmay be relevant to you.\r\n\r\nIf you would prefer not to receive \r\nany more messages from us, \r\nyou can \r\nstop receiving emails:\r\n\r\nhttps://lnunquedays.site/unsub?domain=zakprinting.com \r\nAddress: Address: 3381   Lungodora Napoli 62, VI  36056\r\nLooking out for you, Dorcas Proctor.', '2025-12-20 23:54:22'),
(108, 'Merrill Deweese', 'deweese.merrill4@yahoo.com', '696002111', 'Your AI Hero Understands You & Acts Fast', 'GET INSTANT AI POWERED COURSE CREATION, MARKETING STRATEGIES, AND COMPELLING CONTENT THAT ADAPTS TO YOUR EXACT NEEDS - ALL AT SUPERHERO SPEED!\r\n\r\n\r\nhttps://lordvpn.site/HeroCommandersAI?zakprinting.com\r\n\r\n\r\nYour Course Creation Superhero That Delivers Exactly What You Want, Instantly - Even If You\'re A Complete Newbie!\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are getting this email \r\nas we believe \r\nour offer \r\nmay be relevant to you.\r\n\r\nIf you do not wish to receive \r\nfurther communications from us, \r\nsimply \r\nunsubscribe:\r\n\r\nhttps://lordvpn.site/unsub?domain=zakprinting.com \r\nAddress: Address: 5789   Cascadeborg 156, GR  9617 El\r\nLooking out for you, Merrill Deweese.', '2025-12-21 07:38:42'),
(109, 'IsabellaMob3665', 'oliviasmecexy214227@gmail.com', '85559822178', '\"Naughty temptress craves intimate connection!\"', '? \r\n?\"Exotic siren craves the thrill of forbidden temptation.\" ?Here -- ?rb.gy/3fy54w?Mob', '2025-12-22 01:29:47'),
(110, 'Mattie Pender', 'pender.mattie@hotmail.com', '', 'This website is able to work more effectively ? without extra team members or additional overhead', 'Why does this matter to you? Because your website is able to enable more user activity with no need for adding staff, complex configurations, and constant manual management.\r\n\r\nhttps://moveinready.site/AIModelSuite?zakprinting.com\r\n\r\nYou have a complete system which manages on-site interaction for you, allowing it to move site visitors into meaningful actions such as requests and other outcomes.\r\n\r\nThis is designed for site owners looking to present a more professional online presence without extra configuration work.\r\n\r\nJust connect it, the site begins working in a clearer organized way. Curious how it works in practice?\r\n\r\nhttps://moveinready.site/AIModelSuite?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nThis message is sent to you \r\nsince we believe \r\nwhat we?re offering \r\ncould be relevant to you.\r\n\r\nIf you would prefer not to receive \r\nfurther communications from us, \r\nplease click here to \r\nunsubscribe:\r\n\r\nhttps://moveinready.site/unsub?domain=zakprinting.com \r\nAddress: Address: 1733   Ernstbrunner Strasse 80, BURGENLAND  3844\r\nLooking out for you, Mattie Pender.', '2025-12-24 07:49:44'),
(111, 'NZByODxXbCBmZoejGk', 'munedeme946@gmail.com', '2836924261', 'sHDPLIZHtWMkxOcnEFOGNWl', 'STuhMYQqCdJDfYOmfygNXLzs', '2025-12-25 03:03:08'),
(112, 'IsabellaMob3007', 'isabellasmecexy626856@gmail.com', '84886459575', '\"Naughty temptress craves intimate connection!\"', '? \r\n?\"Sensual vixen longs for tantalizing ecstasy.\" ?Here ?-- rb.gy/3fy54w?Mob', '2025-12-25 09:07:56'),
(113, 'Alyce', 'sales@zakprinting.com', '673364646', 'Alyce Rosser', 'Good day \r\n\r\nLooking to improve your posture and live a healthier life? Our Medico Postura? Body Posture Corrector is here to help!\r\n\r\nExperience instant posture improvement with Medico Postura?. This easy-to-use device can be worn anywhere, anytime ? at home, work, or even while you sleep.\r\n\r\nMade from lightweight, breathable fabric, it ensures comfort all day long.\r\n\r\nGrab it today at a fantastic 60% OFF: https://medicopostura.com\r\n\r\nPlus, enjoy FREE shipping for today only!\r\n\r\nDon\'t miss out on this amazing deal. Get yours now and start transforming your posture!\r\n\r\nThank You, \r\n\r\nAlyce', '2025-12-26 02:25:47'),
(114, 'Carmella Abraham', 'abraham.carmella@yahoo.com', '8038313596', 'Turn digital instructions to build real projects ? relaxing illustration books made fast', 'Burned out by competitive markets and inefficient content creation? This pack of 342 prompts for soft-style coloring books provides a {complete|ready|fully prepared|wel\r\n\r\nhttps://5sq4ek.site/CozyColoringBooks?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n{You are receiving this message|You?re receiving this email|This message is sent to you|You received this notification|You are getting this email} \r\n{because we believe|because we think|as we believe|as we think|since we believe|since we think} \r\n{our offer|this offer|the offer we provide|what we?re offering} \r\n{may be relevant to you|could be relevant to you|might be of interest to you|may interest you|could be useful to you}.\r\n\r\n{If you do not wish to receive|If you don?t want to receive|If you would prefer not to receive|If you no longer wish to get} \r\n{further communications from us|future messages from us|additional emails from us|any more messages from us}, \r\n{please click here to|you can|simply} \r\n{unsubscribe|opt out|unsubscribe from these emails|stop receiving emails}:\r\n\r\nhttps://5sq4ek.site/unsub?domain=zakprinting.com \r\nAddress: Address: 2622   2752 Emily Drive, SC  29710\r\nLooking out for you, Carmella Abraham.', '2025-12-27 03:34:05'),
(115, 'Elyse Beeler', 'beeler.elyse@gmail.com', '7079842591', 'The Old Way of Making Money Online is DEAD', 'Achieve More With Less Effort: Discover 10 Step-by-Step Strategies to Transform Free AI Tools Like ChatGPT Into Practical Business Skills, Even If You\'re a Complete Beginner!\r\n\r\nhttps://absoliut.site/AIProfitBlueprint?zakprinting.com\r\n\r\nPure actionable content. These proven AI strategies are designed to be implemented fast - if you can follow simple instructions, you can start applying professional AI techniques this week. Perfect for entrepreneurs, freelancers, content creators, and anyone ready to transform how they use AI.\r\n\r\nhttps://absoliut.site/AIProfitBlueprint?zakprinting.com\r\n\r\n\r\nYou are getting this email \r\nbecause we believe \r\nthis offer \r\ncould be relevant to you.\r\n\r\nIf you do not wish to receive \r\nfuture messages from us, \r\nyou can \r\nunsubscribe from these emails:\r\n\r\nhttps://absoliut.site/unsub?domain=zakprinting.com \r\nAddress: Address: 4948   66 Winchester Rd, NA  Gu1 2nb\r\nLooking out for you, Elyse Beeler.', '2025-12-27 16:01:23'),
(116, 'Leekic', 'zekisuquc419@gmail.com', '85327197885', 'Hallo,   writing about   the price', 'Szia, meg akartam tudni az ?r?t.', '2025-12-28 06:57:20'),
(117, 'Kendrick', 'sales@zakprinting.com', '', 'Kendrick Hoffnung', 'Morning, \r\n\r\nI hope this email finds you well. I wanted to let you know about our new BANGE backpacks and sling bags that just released.\r\n\r\nThe bags are waterproof and anti-theft, and have a built-in USB cable that can recharge your phone while you\'re on the go.\r\n\r\nBoth bags are made of durable and high-quality materials, and are perfect for everyday use or travel.\r\n\r\nOrder yours now at 50% OFF with FREE Shipping: http://bangeshop.com\r\n\r\nEnjoy,\r\n\r\nKendrick', '2025-12-29 12:31:40'),
(118, 'Leekic', 'zekisuquc419@gmail.com', '83444443696', 'Hello, i writing about your the price', 'Hallo, ek wou jou prys ken.', '2025-12-29 14:36:48'),
(119, 'Herbertdwems', 'johnstegall4@gmail.com', '84536983588', 'URGENT MESSAGE! Claim Your Fortune: Withdraw Your $117,901.55 Today!', 'URGENT MESSAGE! UNBELIEVABLE! YOU\'VE WON $117,901.64 ? WITHDRAW NOW BEFORE IT\'S GONE! https://www.google.com/url?q=https://telegra.ph/Youve-earned-11790176-New-transfer--927534-12-29?85864068 \r\n \r\n \r\n \r\n \r\n \r\nHash: h1nu0x1k1a9z6v2te4sz3u9e2v9e8u0cp7hf7d2y7u1l9j1tv7om2e3e8o9z0w5uj2qq9y6g6s0o7d1qc0nu8x9f5s4i4b2al4xc2v4t7f2a3b4x', '2025-12-30 03:48:57'),
(120, 'Loreen Burden', 'loreen.burden@gmail.com', '9166699512', 'A practical way to apply a pack of mystery story starters to publish young readers? mystery books that fit activity packs', 'Visualize accessing an extensive collection of prebuilt detective story frameworks that easily become content pieces families and educators look for ? books, activity packs ? while avoiding initial drafting. This is not only a loose idea collection. It?s a well-organized prompt collection including clear frameworks that allows you to build engaging children?s stories in a short time, not weeks.\r\n\r\nhttps://6pr5pg.site/StoryPromptsDetective?zakprinting.com\r\n\r\nIf you work as a webmaster, content creator, or KDP publisher, that means entering an evergreen children?s niche with steady interest, building multiple formats from one foundation and opening sustainable income paths. Looking for a simple approach to prepare and share children?s mystery materials without needing long creation timelines? Open the page to see the details.\r\n\r\nhttps://6pr5pg.site/StoryPromptsDetective?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nThis message is sent to you \r\nbecause we believe \r\nthe offer we provide \r\nmight be of interest to you.\r\n\r\nIf you don?t want to receive \r\nany more messages from us, \r\nsimply \r\nunsubscribe from these emails:\r\n\r\nhttps://6pr5pg.site/unsub?domain=zakprinting.com \r\nAddress: Address: 8551   652 Highland View Drive, CA  95661\r\nLooking out for you, Loreen Burden.', '2025-12-30 10:47:22'),
(121, 'AmeliaMob2341', 'avasmecexy216480@yahoo.com', '85997769254', '\"Desperate for intimacy now!\"', '? \r\n?\"Carnal temptress demands irresistible passion.\" ?Here ?-- Kj3fz2f.short.gy/ueeSek?Mob', '2026-01-01 00:34:27'),
(122, 'Oma MacDevitt', 'oma.macdevitt@gmail.com', '106314523', 'Never Pay For Traffic Ever Again?', 'World\'s First AI Agent Powered By ChatGPT-5?\r\nThat Writes And Ranks Anything We Want? On The First Page Of Google? With ZERO SEO. And Zero Ads? \r\n\r\nhttps://www.youtube.com/@AISolutionsTop', '2026-01-04 05:38:37'),
(123, 'Fernando Lazenby', 'fernando.lazenby@msn.com', '9708419683', 'The \"Secret Source Code\" Behind the World?s Top Bestsellers', 'Why do some books sell millions of copies while others fail?\r\n\r\nThe answer isn\'t luck. It?s Psychology. \r\n\r\nThe book that currently dominates the charts?selling over 272 copies daily?was built on a very specific scientific foundation. It took deep behavioral principles and simplified them into \"Tiny\" steps.\r\n\r\nhttps://center303-center303.site/TinyActionBooks?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are getting this email \r\nbecause we think \r\nour offer \r\ncould be relevant to you.\r\n\r\nIf you don?t want to receive \r\nany more messages from us, \r\nplease click here to \r\nstop receiving emails:\r\n\r\nhttps://center303-center303.site/unsub?domain=zakprinting.com \r\nAddress: Address: 3054   Paul-Nevermann-Platz 20, BY  97699\r\nLooking out for you, Fernando Lazenby.', '2026-01-04 07:01:05'),
(124, 'Josephine O\'Donnell', 'josephine.odonnell73@gmail.com', '6804035499', 'A Modern Day Gold Rush, making tens of thousands a month', 'Imagine launching a viral, faceless \r\nYouTube, TikTok, or Instagram channel \r\nin just minutes...\r\n(And Then Your new Channel \r\nautomatically Creates AND posts videos FOR YOU...\r\nSo you NEVER HAVE TO TOUCH IT, AGAIN?)\r\n\r\nThis is 100% AUTOMATED, so once you set it up, you never have to lift a finger!\r\n\r\nhttps://cola52.site/TrafficSupernova?zakprinting.com\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message \r\nas we think \r\nour offer \r\ncould be useful to you.\r\n\r\nIf you no longer wish to get \r\nfuture messages from us, \r\nsimply \r\nopt out:\r\n\r\nhttps://cola52.site/unsub?domain=zakprinting.com \r\nAddress: Address: 4264   Buanvagen 85, NA  840 98\r\nLooking out for you, Josephine O\'Donnell.', '2026-01-04 18:05:08'),
(125, 'Margaret Julia', 'yiyayova@gmail.com', '3712736548', 'ChatGPT, Gemini, Stable Diffusion & More? Without Monthly Fees', 'Hello,\r\n\r\nWe have a promotional offer for your website zakprinting.com.\r\n\r\nWhat if you could use the best AI models in the world without limits or extra costs? Now you can. With our brand-new AI-powered app, you\'ll have ChatGPT, Gemini Pro, Stable Diffusion, Cohere AI, Leonardo AI Pro, and more ? all under one roof. No monthly subscriptions, no API key expenses, no experience required, just one dashboard, one payment, and endless possibilities.\r\n\r\nSee it in action:?https://aistore.vinhgrowth.com\r\n\r\nYou are receiving this message because we believe our offer may be relevant to you.?\r\nIf you do not wish to receive further communications from us, please click here to UNSUBSCRIBE: https://vinhgrowth.com/unsubscribe?domain=zakprinting.com\r\nAddress: 60 Crown Street, London\r\nLooking out for you, Margaret Julia', '2026-01-05 17:39:27'),
(126, 'OliviaMob332', 'ameliasmecexy417116@gmail.com', '81767263427', '\"I\'ll show you the real me, and it\'s scandalous.\"', '? \r\n?\"I\'m looking for an intimate connection that goes beyond the ordinary.\" ? ?- https://girlsfun.short.gy/Ju0Xdq?Soync', '2026-01-08 21:03:58'),
(127, 'Whannamoof', 'p6avpwtg@yahoo.com', '85793158283', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/36bavcwu', '2026-01-11 01:45:53'),
(128, 'Whannamoof', '29npx8l3@hotmail.com', '83897516358', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/338cfh39', '2026-01-12 22:16:37'),
(129, '* * * $3,222 payment available! Confirm your operation here: http://nationwidepackaging.com/?w6ubs1 * * * hs=678bb198da84b4c855fe743f0ca1e8c2* ???*', 'ydx~nwa9pwyxz@mailbox.in.ua', '351530006254', '7l54fe', 'd9ev6e', '2026-01-13 01:12:46'),
(130, '* * * <a href=\"http://nationwidepackaging.com/?w6ubs1\">$3,222 deposit available</a> * * * hs=678bb198da84b4c855fe743f0ca1e8c2* ???*', 'ydx~nwa9pwyxz@mailbox.in.ua', '351530006254', '7l54fe', 'd9ev6e', '2026-01-13 01:12:47'),
(131, 'AvaMob655', 'avasmecexy261422@hotmail.com', '89465513768', '\"Forbidden Fantasies Realized\"', 'Desire pulses through every vein and nerve.   - https://Kj3fz2f.short.gy/ueeSek?Soync', '2026-01-14 09:42:51'),
(132, 'Whannamoof', '2tegg4k3@gmail.com', '88453933528', 'I promised.', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/3tmy559u', '2026-01-14 12:36:08'),
(133, 'IsabellaMob3238', 'ameliasmecexy594023@gmail.com', '87348332327', '\"Lust\'s Wild Ride Begins\"', 'Surrender to this primal pull between us.   -   https://https://nMm5id.short.gy/jEMfCL?Soync', '2026-01-17 23:08:48'),
(134, 'Erlinda Sparling', 'sparling.erlinda@gmail.com', '3506022313', 'Still Missing Out on FREE Buyer Traffic from TikTok, YouTube, Instagram & Facebook ?', 'World\'s First AI App That Creates\r\nCinematic Clips, Shorts & Reels Completely Hands-Free\r\nIn 100s Of Language - In Just 60 Seconds\r\n\r\nhttps://fitgirlpack.site/MagicClipsAI\r\n\r\n\r\n\r\n\r\n\r\nto UNSUBSCRIBE:\r\nhttps://fitgirlpack.site/unsubscribe?domain=zakprinting.com\r\nAddress: 209 West Street Comstock Park, MI 49321', '2026-01-25 16:46:36'),
(135, 'Jetta Ballinger', 'ballinger.jetta@gmail.com', '887072927', 'Amazon is handing out $520,000,000?why are you still broke?', 'While you?re rotting away building complex funnels and burning cash on ads that don?t convert, Amazon is paying out over half a billion dollars in royalties to people who aren?t even \"writers\". You?re working too hard for pennies. Stop being a \"content slave\" and start building a digital asset portfolio that actually pays while you sleep. Book Ninja is an AI-powered beast that uses nine different tools to research, write, and design high-demand books in under 4 minutes.\r\nNo writing, no design skills, and zero marketing are required because Amazon already has the buyers waiting for you. Simply pick a niche, click a button, and upload your assets to Amazon, Etsy, or Shopify to start stacking royalties 24/7. Every day you hesitate is another day you are literally handing your share of that $520M to someone else who was faster than you. Stop wondering \"what if\" and start collecting?it\'s 100% risk-free for 30 days.\r\n\r\nhttps://jrvtns4nrv9jekfx.site/BookNinja?domain=zakprinting.com \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are getting this email \r\nsince we think \r\nthe offer we provide \r\nmay interest you.\r\n\r\nIf you don?t want to receive \r\nfuture messages from us, \r\nplease click here to \r\nunsubscribe from these emails:\r\n\r\nhttps://jrvtns4nrv9jekfx.site/unsub?domain=zakprinting.com \r\nAddress: Address: 8376   77 Henry Moss Court, SA  5495\r\nLooking out for you, Jetta Ballinger.', '2026-01-28 02:01:06'),
(136, 'OliviaMob9629', 'emmasmecexy642687@gmail.com', '88727696431', 'My bed is empty', 'Check out the photos that were too hot for social media.   -  Kul2f3c.short.gy/KI3JLy?Mob', '2026-01-30 06:56:42'),
(137, 'Luigi Hercus', 'hercus.luigi@gmail.com', '618219631', 'Stop \"Inventing\" Demand (And Start Selling)', 'Stop acting like a starving artist and wasting hours \"inventing demand\" for products nobody wants. While you?re stuck in \"prompt roulette\" and watching your generic listings stay flat for months, there is a $12.96 billion market laughing at your effort. You?re fighting for scraps because you?re starting from zero, while the pros are busy \"stealing\" an audience that is already obsessed and ready to buy.\r\nThe secret is the 80/20 Rule: 20% of public domain figures drive 80% of the sales. Easy AI Popular Figure Public Domain hands you the keys to this vault with 250 proven prompts and a Custom GPT that does 99% of the work for you. You can either keep screaming into the void with products that don\'t sell, or you can use our 2-step multiplier to hijack existing traffic and finally start winning.\r\nStop Guessing. Start Scaling: https://playfix.site/EasyAI?domain=zakprinting.com \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are receiving this message \r\nbecause we believe \r\nthe offer we provide \r\ncould be useful to you.\r\n\r\nIf you would prefer not to receive \r\nadditional emails from us, \r\nplease click here to \r\nopt out:\r\n\r\nhttps://playfix.site/unsub?domain=zakprinting.com \r\nAddress: Address: 1992   Somervaart 122, OV  7421 Hx\r\nLooking out for you, Luigi Hercus.', '2026-01-31 07:46:24'),
(138, 'Vonnie Peek', 'peek.vonnie@gmail.com', '491959318', 'Your Business is a Dead End (Unless You Change This)', 'Stop lying to yourself. If you?re stuck selling one-off products, you aren?t a business owner?you?re a slave to the next sale. Every single month, your bank account resets to zero, and you?re forced back onto the \"entrepreneurial hamster wheel\". It?s exhausting, it\'s demoralizing, and it?s stealing your financial freedom.\r\nThe R.A.P.I.D. TimeShift? System is your only way out. It is a \"set-it-and-forget-it\" blueprint designed to build predictable monthly income that deposits money into your account like clockwork.\r\n\r\nGet Out of the Trap Here: https://indianxvideos.site/RapidRecurringRevenue?domain=zakprinting.com \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nYou are getting this email \r\nsince we believe \r\nwhat we?re offering \r\nmay interest you.\r\n\r\nIf you do not wish to receive \r\nfuture messages from us, \r\nsimply \r\nstop receiving emails:\r\n\r\nhttps://indianxvideos.site/unsub?domain=zakprinting.com \r\nAddress: Address: 4225   Rue De Baras 83, WHT  7333\r\nLooking out for you, Vonnie Peek.', '2026-02-05 02:06:53'),
(139, 'IsabellaMob6084', 'oliviasmecexy287531@gmail.com', '86133516115', 'I???m yours to take', 'Let???s get a little crazy together, join me on my personal page.   -  telegra.ph/Enter-01-31?Mob', '2026-02-07 00:44:48'),
(140, 'Forestepins', 'noelbillings9@gmail.com', '84577524969', 'IMPORTANT! Your $93,689.17 is Mature', 'IMPORTANT MESSAGE! YOU\'VE EXECUTED $93,689.17 NOW GET EARNINGS https://url28x.com/jVFMe \r\n \r\n \r\n \r\n \r\n \r\nTAG: o1if9u1t1s0m8x1wi6nq0q2c3q4b8d9za7wn7z6i3l8g4y3fs8bg4z5y8j4l1d9ex2md8q2w2b7u7q9ms8oq0l6e6u1s3y1jz4bj1n5d6k5d9m9u', '2026-02-10 12:13:33'),
(141, 'Forestepins', 'mageed.moula88@gmail.com', '83367928629', 'URGENT MESSAGE! Your 1.749542 BTC is guaranteed withdraw right away', 'IMPORTANT MESSAGE! WITHDRAW YOUR 1.749542 BTC AND INVEST IT https://plu.sh/t8cqp \r\n \r\n \r\n \r\n \r\n \r\nConfirmation ID: u9ve8h9s0s6m2q1dx7ph5v8x7m9v4z8cc5bf6q9l1w8j9v8dj4dd0d6k5b3y4q5iw8mm1f0m3l1j5x8of6ec3g1b0i7d0k4vy9bl7s0c0j6f7o2e', '2026-02-14 02:46:05'),
(142, 'Vickey Marler', 'marler.vickey@gmail.com', '388679697', 'Launch Your Own Chrome Extension in 15 Minutes', 'Launch your own branded Chrome extension in just 15 minutes with zero coding required to instantly elevate your professional authority. Use our proven templates to streamline your operations or deliver white-labeled solutions to clients for effortless recurring revenue.\r\nhttps://www.youtube.com/watch?v=ATYTVlN5MSM', '2026-02-15 14:56:48'),
(143, 'Alberto Dellinger', 'alberto.dellinger@hotmail.com', '249363667', 'That creates winning affiliate promotions FOR YOU?', 'Tap into decades of super-affiliate expertise with an intelligent software that automates everything from strategy to high-converting copy in just a few clicks. Launch profitable affiliate campaigns across any niche and secure lifetime access with a single payment?no subscriptions or hidden fees required\r\nhttps://www.youtube.com/watch?v=GIWPFQOltPk', '2026-02-16 03:54:38'),
(144, 'Belle Gellert', 'joel.fox.1965+zakprinting.com@gmail.com', '5905421630', 'Creating new income streams is SO EASY with Book Ninja...', 'Create new automated passive income streams with Book Ninja, which uses AI to find profitable niches and fully assembles ready-to-publish books for Amazon in under 30 minutes. This is your chance to scale your business portfolio with digital assets that generate royalties for years without spending on ads, design, or writing.\r\nhttps://www.youtube.com/watch?v=PQCSucpPt-0', '2026-02-16 09:57:07'),
(145, 'Adriene Coble', 'coble.adriene@msn.com', '2019729692', 'NO Client Fulfillment ? NO API Key ? JUST A Smart and Sustainable Business', 'Launch a Local Toolkit Website that Business Owners Use Daily, Builds Trust Fast, and Turns Free Value into Paid Upgrades on Autopilot. All Done-for-You, Automated and Ready to Go.\r\nhttps://www.youtube.com/watch?v=aOTUmzKLTwY', '2026-02-16 17:00:45'),
(146, 'Jaimie Fernie', 'jaimie.fernie@gmail.com', '6502601472', 'How to Turn Online Effort Into Income', 'Stop wasting months on content creation and start selling a professional, ready-to-use video course that positions you as an instant authority in the digital business space. This complete white-label package allows you to grow your email list and generate recurring income without spending a single minute on planning, scripting, or recording https://www.youtube.com/watch?v=ss4tux6Q4pI', '2026-02-17 15:19:25'),
(147, 'Veda Levering', 'levering.veda@yahoo.com', '4985812649', 'Siphon Traffic From People Leaving Other Websites Into Monthly Visitors Without Buying Ads, Sending Emails, Or Lifting A Finger', 'Stop losing money on visitors who leave websites and start automatically redirecting that \"wasted\" traffic toward your own offers for as little as five cents per person. Exit Traffic Network provides a completely hands-free, set-it-and-forget-it system that captures real desktop traffic from established platforms while you sleep\r\nhttps://www.youtube.com/watch?v=3013L2Yxg1k', '2026-02-19 23:53:02'),
(148, 'Lashawn Fellows', 'lashawn.fellows@outlook.com', '7821925374', 'Write LinkedIn comments in your tone in 5 seconds (without bots or automation)', 'Scale your authority and warm up high-value leads on LinkedIn by generating tone-perfect, professional comments in just five seconds,. Stay consistently visible to your target audience and grow your business safely without bots for only $5 a month,.\r\n\r\nhttps://www.youtube.com/watch?v=fnBU0pu0F_s', '2026-02-21 21:24:10'),
(149, 'Heidi Lemmon', 'heidi.lemmon@msn.com', '654643105', 'The Reality of Relationship Content Creation Today https://dig-ai.pro/RelationshipeBookEmpire', 'Stop wasting months on content creation and start scaling instantly with a ready-made library of 77 professional relationship eBooks you can rebrand and sell as your own. Gain full ownership of high-demand, evergreen assets with unrestricted PLR to power your memberships and coaching programs while keeping 100% of the profits.\r\n\r\nhttps://www.youtube.com/watch?v=TUQ7Rumq1ZA', '2026-02-22 11:58:15'),
(150, 'Forestepins', 'Sotosoto1283@gmail.com', '89949154895', 'IMPORTANT MESSAGE! YOU’VE EARNED 1.749542 BTC WITHDRAW BEFORE RESET', 'URGENT! WHY WAIT YOUR 1.749542 BTC IS READY https://urlshort.xyz/JWcew \r\n \r\n \r\n \r\n \r\n \r\nPRODUCT ID: g2qq9j6r0m8t0h3wb1fv8o3g1d3k2m3qh7wa8y5b8s6m3x7xq5qd2v5x0w4m2c7yk8in3t1p9a3m3j3ua0qe1y3n0e9h4f4mi8gn8i5y4o8y8l2d', '2026-02-24 05:34:15'),
(151, 'Jarrod Key', 'key.jarrod@gmail.com', '3167050684', 'Let AI Find $50-$500 Flips For You', 'Scale your arbitrage operations instantly with FlipNinja’s AI, which automates the hunt for 50%–500% profit flips across Amazon, Walmart, and AliExpress. Secure an unfair data advantage for a one-time $17 investment and stop guessing where your next high-margin deal is coming from.\r\n\r\nhttps://www.youtube.com/watch?v=FgXeh1S8NXg', '2026-02-25 22:34:58'),
(152, 'Pearlene Deeter', 'pearlene.deeter@msn.com', '671321338', '', 'Stop wasting your budget on expensive ads and complex tech by implementing a 30-day AI-driven roadmap that automates 80% of your content creation and lead generation. Scale your business effortlessly using viral 5-second videos and proven conversion scripts to turn free traffic into consistent revenue for just $17,,,.\r\n\r\nhttps://www.youtube.com/watch?v=NTlA-HHd478', '2026-02-27 04:37:55'),
(153, 'YPDtRGEeUCsgzeSlpIBPmqY', 'el.iy.a.ma21.9@gmail.com', '9561036841', 'WYzNDtjLytseQzIIdlZEfZdz', 'OPREyUsKNQiaosIg', '2026-02-28 00:06:18'),
(154, 'HowardFib', 'Ladybird6470@gmail.com', '85832242372', 'IMPORTANT MESSAGE! You’ve unlocked special 1.749542 BTC withdraw now', 'IMPORTANT! Withdraw your 1.749542 BTC before system reset https://biolink.com.do/xlZEs \r\n \r\n \r\n \r\n \r\n \r\nReference ID: y3iu4w7u2z9h1l3yb2iy8j1f2x0v7l2co0uo3a4r6l6g7v1gm3ss3g1k1q5r0r3kw1al7i6g0y9i3j2pv4op1r6q1q0u6h4hs1sp4e2s7t1u1x8s', '2026-02-28 18:57:03'),
(155, 'Kashif Yaqoob', 'ar.kashifyaqoob@gmail.com', '+923096554946', '', '123', '2026-03-11 10:46:34'),
(156, 'Kevin', 'kevin.holloman@gmail.com', '412685518', '', 'Hi,\r\n\r\nI am a senior web developer, highly skilled and with 10+ years of collective web design and development experience, I work in one of the best web development company.\r\n\r\nMy hourly rate is $8\r\n\r\nMy expertise includes:\r\n\r\nWebsite design - custom mockups and template designs\r\nWebsite design and development - theme development, backend customisation\r\nResponsive website - on all screen sizes and devices\r\nPlugins and Extensions Development\r\nWebsite speed optimisation and SEO on-page optimisation\r\nWebsite security\r\nWebsite migration, support and maintenance\r\nIf you have a question or requirement to discuss, I would love to help and further discuss it. Please email me at e.solus@gmail.com\r\n\r\nRegards,\r\nSachin\r\ne.solus@gmail.com', '2026-03-18 16:25:24'),
(157, 'Whannamoof', 'i6i15ddm@hotmail.com', '87284955529', '', 'Struggling to feel good again? That heavy feeling sucks the joy out of everything. We\'ve got proven support that helps lift the fog вЂ” private ordering, rapid delivery, 100% discreet. Take the first step here. \r\nhttps://tinyurl.com/55k9px6f', '2026-03-18 20:01:22'),
(158, 'Whannamoof', 'mtewox8c@icloud.com', '86785131615', '', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/37t26pmp', '2026-03-24 15:47:44'),
(159, 'Whannamoof', '7zfrn7h2@hotmail.com', '86548296593', '', 'Photos for my escort application are uploaded.   \r\nLet me know if the quality is good.   \r\nPreview: https://tinyurl.com/33njz8s4', '2026-03-28 16:33:37'),
(160, 'NAERTERHTE314545NEHTYHYHTR', 'pcnsmufx@vargosmail.com', '87829285815', '', 'MEYJTJ314545MARTHHDF', '2026-03-31 17:10:57');

-- --------------------------------------------------------

--
-- Table structure for table `finance_cash_entries`
--

CREATE TABLE `finance_cash_entries` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(11) NOT NULL DEFAULT 1,
  `owner_user_id` int(11) DEFAULT NULL,
  `direction` enum('in','out') NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `source_type` enum('manual','invoice') NOT NULL DEFAULT 'manual',
  `invoice_id` int(11) DEFAULT NULL,
  `invoice_item_id` int(11) DEFAULT NULL,
  `finance_product_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `finance_products`
--

CREATE TABLE `finance_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(11) NOT NULL DEFAULT 1,
  `owner_user_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `purchase_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `retail_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `misc_expense` decimal(10,2) NOT NULL DEFAULT 0.00,
  `misc_profit` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('active','archived') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `invoice_no` varchar(40) NOT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(10,2) DEFAULT 0.00,
  `status` enum('unpaid','partial','paid','completed','cancelled') NOT NULL DEFAULT 'unpaid',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `due_date` date DEFAULT NULL,
  `client_name` varchar(200) DEFAULT NULL,
  `client_phone` varchar(50) DEFAULT NULL,
  `client_email` varchar(200) DEFAULT NULL,
  `client_company` varchar(200) DEFAULT NULL,
  `include_tax` tinyint(1) DEFAULT 0,
  `tax_percent` decimal(5,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT 0.00,
  `design_file` varchar(255) DEFAULT NULL,
  `external_design_link` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `tenant_id`, `created_by`, `invoice_no`, `customer_name`, `total`, `amount_paid`, `status`, `created_at`, `due_date`, `client_name`, `client_phone`, `client_email`, `client_company`, `include_tax`, `tax_percent`, `subtotal`, `design_file`, `external_design_link`, `notes`) VALUES
(11, 1, 1, 'INV-20250901-115658', NULL, 15000.00, 0.00, 'partial', '2025-09-01 11:58:19', NULL, 'Rukhsar Ahmad', '+92 320 8444414', '', 'Midjac Pvt Ltd.', 0, 0.00, 15000.00, NULL, NULL, ''),
(14, 1, 1, 'INV-20250903-064021', NULL, 7500.00, 0.00, 'paid', '2025-09-03 06:42:46', NULL, 'Rizwan Sab', '+92 301 1105165', '', 'Ocean Paints Private Limited', 0, 0.00, 7500.00, NULL, NULL, NULL),
(16, 1, 1, 'INV-20250903-100039', NULL, 3992.00, 0.00, 'paid', '2025-09-03 10:02:23', NULL, 'Azmat Rana', '+92 333 4733694', '', '', 0, 0.00, 3992.00, NULL, NULL, NULL),
(19, 1, 1, 'INV-20250904-102043', NULL, 2000.00, 0.00, 'paid', '2025-09-04 10:21:33', NULL, 'Malik Naeem', '+92 300 1116985', '', '', 0, 0.00, 2000.00, NULL, NULL, NULL),
(20, 1, 1, 'INV-20250904-102842', NULL, 181575.00, 0.00, 'partial', '2025-09-04 10:30:25', '2025-09-04', 'Wajid Sab', '', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 181575.00, NULL, NULL, ''),
(23, 1, 1, 'INV-20250904-153659', NULL, 9000.00, 0.00, 'paid', '2025-09-04 15:38:35', NULL, 'Sky Events', '+92-3329999045', 'info@skyevents.pk', 'skyevents.pk', 0, 0.00, 9000.00, NULL, NULL, NULL),
(50, 1, 1, 'ZAK-20250911-122051', NULL, 6000.00, 0.00, 'paid', '2025-09-11 12:22:33', NULL, 'Arslan Haider Sab', '+92 334 0403020', '', 'Sky Events', 1, 0.00, 6000.00, NULL, NULL, NULL),
(51, 1, 1, 'ZAK-20250912-105956', NULL, 3460.00, 0.00, 'paid', '2025-09-12 11:02:11', NULL, 'Mansoor Sab', '+92 309 5012013', '', 'Door of Awareness', 0, 0.00, 3460.00, NULL, NULL, NULL),
(52, 1, 1, 'ZAK-20250912-124008', NULL, 2470.00, 0.00, 'paid', '2025-09-12 12:42:19', NULL, 'Ikram Sab', '+92 322 4379517', '', 'Jamal Din & Sons', 0, 0.00, 2470.00, NULL, NULL, ''),
(53, 1, 1, 'ZAK-20250915-124559', NULL, 98000.00, 0.00, 'unpaid', '2025-09-15 12:52:03', NULL, 'Jabran Akbar', '+92 300 7493192', '', 'iTee University', 0, 0.00, 98000.00, NULL, NULL, NULL),
(54, 1, 6, 'ZAK-20250916-085723', NULL, 10000.00, 0.00, 'paid', '2025-09-16 08:58:37', NULL, 'Mr. Faisal', '', '', 'DFTR FACILITY SMC PRIVATE LIMITED', 0, 0.00, 10000.00, NULL, NULL, NULL),
(57, 1, 7, 'ZAK-20250917-081456', NULL, 26443.80, 0.00, 'paid', '2025-09-17 08:15:58', NULL, 'Muhammad Akbar Sab (Best Seller)', '+92 314 4004756', '', 'Stylers International', 1, 18.00, 22410.00, NULL, NULL, NULL),
(58, 1, 7, 'ZAK-20250917-081923', NULL, 43211.60, 0.00, 'paid', '2025-09-17 08:25:14', NULL, 'Muhammad Akbar (Styler Unit 1)', '+92 336 3080105', '', 'Stylers International', 1, 18.00, 36620.00, NULL, NULL, NULL),
(59, 1, 7, 'ZAK-20250917-082702', NULL, 11646.60, 0.00, 'paid', '2025-09-17 08:29:29', NULL, 'Hafiz Hamza', '+92 321 7399690', '', 'Stylers International Limited', 1, 18.00, 9870.00, NULL, NULL, ''),
(60, 1, 7, 'ZAK-20250917-083253', NULL, 98750.00, 0.00, 'unpaid', '2025-09-17 08:35:09', '2025-09-17', 'Naeem Akhtar Sab', '+92 334 4002878', '', 'Pakistan Expo Center, Lahore', 1, 18.00, 98750.00, NULL, NULL, ''),
(61, 1, 1, 'ZAK-20250917-142307', NULL, 1220.00, 0.00, 'paid', '2025-09-17 14:23:55', NULL, 'Rana Muhammad Saleem', '+92 322 4379517', '', 'JDS', 0, 0.00, 1220.00, NULL, NULL, NULL),
(76, 1, 5, 'ZAK-20250919-124546', NULL, 8520.00, 0.00, 'paid', '2025-09-19 12:51:45', NULL, 'Mr. Amir', '03312680268', '', '', 0, 0.00, 8520.00, NULL, NULL, NULL),
(78, 1, 1, 'ZAK-20250922-071739', NULL, 35120.00, 0.00, 'unpaid', '2025-09-22 07:21:33', NULL, 'Rana Zia ul Islam Manj', '0300 786 00 34', '', 'PROPERTY CARE and Develpors', 0, 0.00, 35120.00, NULL, NULL, NULL),
(80, 1, 1, 'INV-20250924-092036', NULL, 235300.00, 0.00, 'partial', '2025-09-24 09:20:36', NULL, 'Talha Ali', '+92 301 2008792', '', 'Habib Engineering', 0, 0.00, 235300.00, NULL, NULL, ''),
(83, 1, 1, 'INV-20250925-142500', NULL, 8000.00, 0.00, 'paid', '2025-09-25 14:25:00', NULL, 'Kashif Saleem', '', '', 'Door of Awareness', 0, 0.00, 8000.00, NULL, NULL, NULL),
(84, 1, 1, 'INV-20250925153726-2440', NULL, 116670.00, 0.00, 'paid', '2025-09-25 15:37:26', NULL, 'Atif Sab', '+92 321 9522071', '', 'Youth Development Foundation (YDF)', 0, 0.00, 116670.00, NULL, NULL, NULL),
(88, 1, 7, 'PO No 1231807', NULL, 340028.80, 0.00, 'paid', '2025-09-26 16:43:49', NULL, 'Naeem Akhtar Sab', '+92 334 4002878', '', 'Pakistan Expo Center, Lahore', 1, 18.00, 288160.00, NULL, NULL, ''),
(89, 1, 7, 'INV 2516700', NULL, 200600.00, 0.00, 'paid', '2025-09-26 16:53:15', '2026-02-01', 'Naeem Akhtar Sab', '+92 334 4002878', '', 'Pakistan Expo Center, Lahore', 1, 18.00, 170000.00, NULL, NULL, ''),
(90, 1, 1, 'INV-20250927-112543', NULL, 7450.00, 0.00, 'unpaid', '2025-09-27 11:25:43', NULL, 'Kashif Saleem', '+92 321 4236669', '', 'Door of Awareness', 0, 0.00, 7450.00, NULL, NULL, ''),
(91, 1, 1, 'ZAK-20250929-142925', NULL, 19200.00, 0.00, 'paid', '2025-09-29 14:31:59', NULL, 'Dr. Faryal', '', '', 'National Hospital & Medical Centre Lahore', 0, 0.00, 19200.00, NULL, NULL, ''),
(94, 1, 7, '2516701', NULL, 14773.60, 0.00, 'paid', '2025-10-06 09:22:34', '2026-02-01', 'Muhammad Akbar Sab', '+92 314 4004756', '', 'Stylers International', 1, 18.00, 12520.00, NULL, NULL, ''),
(95, 1, 1, 'INV-20251006-094959', NULL, 3600.00, 0.00, 'paid', '2025-10-06 09:49:59', NULL, 'Rana Muhammad Saleem', '+92 322 4379517', '', 'JDS', 0, 0.00, 3600.00, NULL, NULL, ''),
(98, 1, 1, 'ZAK-20251008-073637', NULL, 3000.00, 0.00, 'paid', '2025-10-08 07:37:42', NULL, 'Life Plus Fertility Clinic', '+92 318 4130586', '', 'Life Plus Fertility Clinic', 0, 0.00, 3000.00, NULL, NULL, NULL),
(101, 1, 1, 'INV-20251013-120315', NULL, 17500.00, 0.00, 'paid', '2025-10-13 12:03:15', NULL, 'Atif Sab', '+92 321 9522071', '', 'Youth Development Foundation (YDF)', 0, 0.00, 17500.00, NULL, NULL, ''),
(102, 1, 1, 'ZAK-20251014-095842', NULL, 10640.00, 0.00, 'paid', '2025-10-14 10:02:29', NULL, 'Hamza Waris', '+92 306 0481372', '', 'Monarch Developements', 0, 0.00, 10640.00, NULL, NULL, ''),
(103, 1, 1, 'INV-20251015-101335', NULL, 5000.00, 0.00, 'paid', '2025-10-15 10:13:35', NULL, 'Fahad Sab', '+92 301 4542694', '', 'MTI Medical Pvt Ltd', 0, 0.00, 5000.00, NULL, NULL, ''),
(104, 1, 1, 'ZAK-20251015-110702', NULL, 40200.00, 0.00, 'paid', '2025-10-15 11:12:01', NULL, 'Hussain Sab', '+92 304 0304304', '', 'Visa Advisor Private Limited', 0, 0.00, 40200.00, NULL, NULL, ''),
(118, 1, 1, 'ZAK-20251021-162406', NULL, 11175.00, 0.00, 'paid', '2025-10-21 16:31:59', NULL, 'Zaheer Abbas Khan', '+92 301 4094964', '', 'Bada', 0, 0.00, 11175.00, NULL, NULL, ''),
(119, 1, 1, 'ZAK-20251021-180228', NULL, 1096.00, 0.00, 'paid', '2025-10-21 18:03:29', NULL, '', '+92 321 8551555', '', '', 0, 0.00, 1096.00, NULL, NULL, ''),
(121, 1, 1, 'INV-20251022-140426', NULL, 13420.00, 0.00, 'paid', '2025-10-22 14:04:26', NULL, 'Zaheer Abbas Khan', '+92 301 4094964', '', 'Bada', 0, 0.00, 13420.00, NULL, NULL, ''),
(123, 1, 1, 'ZAK-20251027-075352', NULL, 4500.00, 0.00, 'paid', '2025-10-27 07:55:00', NULL, 'Yasir hanif', '+92 306 8211606', '', 'GLISTEN INTERNATIONAL', 0, 0.00, 4500.00, NULL, NULL, ''),
(125, 1, 1, 'ZAK-20251027-080119', NULL, 11400.00, 0.00, 'paid', '2025-10-27 08:02:37', NULL, 'Naveed Sultan', '+92 324 0145510', '', '', 0, 0.00, 11400.00, NULL, NULL, ''),
(126, 1, 1, 'INV-20251027-083104', NULL, 34300.00, 0.00, 'partial', '2025-10-27 08:31:04', NULL, 'Jabran Akbar', '+92 300 7493192', '', 'iTee University', 0, 0.00, 34300.00, NULL, NULL, ''),
(127, 1, 1, 'INV-20251028-070955', NULL, 22000.00, 0.00, 'paid', '2025-10-28 07:09:55', NULL, 'Hasnain Saheb', '+92 300 1919198', '', 'Habib Engineering', 0, 0.00, 22000.00, NULL, NULL, ''),
(128, 1, 1, 'ZAK-20251029-135907', NULL, 14000.00, 0.00, 'paid', '2025-10-29 14:00:55', NULL, 'Bilal Sab', '+92 315 7014534', '', 'Elite Police Traning School', 0, 0.00, 14000.00, NULL, NULL, ''),
(129, 1, 6, 'ZAK-20251030-105142', NULL, 2200.00, 0.00, 'paid', '2025-10-30 10:52:54', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 2200.00, NULL, NULL, ''),
(131, 1, 6, 'ZAK-20251031-071507', NULL, 49350.00, 0.00, 'paid', '2025-10-31 07:15:48', NULL, 'Mr. Nouman', '', '', 'M/S Tkxel NTN : 22181784', 0, 0.00, 49350.00, NULL, NULL, 'Invoice have been generated from Serial No. 765 to 839, for the period from October 13, 2025, to October 31, 2025.'),
(132, 1, 1, 'ZAK-20251031-132918', NULL, 2500.00, 0.00, 'paid', '2025-10-31 13:30:36', NULL, 'Ali Husnain Cheema ??', '+92 306 9737713', '', 'Al Manzoor Engineers', 0, 0.00, 2500.00, NULL, NULL, ''),
(133, 1, 7, 'INV-20251031-144225', NULL, 19411.00, 0.00, 'paid', '2025-10-31 14:42:25', NULL, 'Imran Sab', '+92 310 4403222', '', 'Stylers International Limited', 1, 18.00, 16450.00, NULL, NULL, ''),
(134, 1, 1, 'INV-20251103-062048', NULL, 9600.00, 0.00, 'partial', '2025-11-03 06:20:48', NULL, 'Wajid Sab', '+92 321 4632844', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 9600.00, NULL, NULL, ''),
(138, 1, 1, 'INV-20251106073336-1204', NULL, 53450.00, 0.00, 'paid', '2025-11-06 07:33:36', NULL, 'Rao Rashid Mubeen', '+92 300 1501503', '', 'Star Chem Tech', 0, 0.00, 53450.00, NULL, NULL, ''),
(139, 1, 1, 'ZAK-20251106-093840', NULL, 6500.00, 0.00, 'paid', '2025-11-06 09:41:09', NULL, 'Arooj Asad', '+92 307 6464369', '', '', 0, 0.00, 6500.00, NULL, NULL, ''),
(141, 1, 1, 'ZAK-20251110-140535', NULL, 28980.80, 0.00, 'unpaid', '2025-11-10 14:16:28', NULL, 'Ejaz Hussain Virk', '+92 300 8036229', '', 'Stylers International Limited', 1, 18.00, 24560.00, NULL, NULL, ''),
(143, 1, 1, 'ZAK-20251111-095201', NULL, 2000.00, 0.00, 'paid', '2025-11-11 09:53:03', NULL, '~Wajid Ali', '+92 321 4632844', '', 'NS Enterpries', 0, 0.00, 2000.00, NULL, NULL, ''),
(144, 1, 1, 'INV-20251112-120230', NULL, 980.00, 0.00, 'paid', '2025-11-12 12:02:30', NULL, 'Rana Muhammad Saleem', '+92 322 4379517', '', 'JDS', 0, 0.00, 980.00, NULL, NULL, ''),
(145, 1, 1, 'INV-20251112-155026', NULL, 1500.00, 0.00, 'paid', '2025-11-12 15:50:26', NULL, 'Bilal Sab', '+92 315 7014534', '', 'Elite Police Traning School', 0, 0.00, 1500.00, NULL, NULL, ''),
(147, 1, 6, 'ZAK-20251114-084422', NULL, 11000.00, 0.00, 'paid', '2025-11-14 08:45:06', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 11000.00, NULL, NULL, ''),
(148, 1, 1, 'ZAK-20251114-112210', NULL, 2750.00, 0.00, 'paid', '2025-11-14 11:23:47', NULL, 'Atif Sab', '', '', '+92 348 9482197', 0, 0.00, 2750.00, NULL, NULL, ''),
(149, 1, 1, 'ZAK-20251114-113953', NULL, 25000.00, 0.00, 'paid', '2025-11-14 11:42:15', NULL, '', 'Career Advisors Educational Consultant', '', '+92 315 7446786', 0, 0.00, 25000.00, NULL, NULL, ''),
(150, 1, 1, 'ZAK-20251115-111020', NULL, 5000.00, 0.00, 'paid', '2025-11-15 11:11:14', NULL, 'Dr Farooq Sab', '+92 321 9476786', '', 'Denticare', 0, 0.00, 5000.00, NULL, NULL, ''),
(151, 1, 1, 'INV-20251120-061338', NULL, 4500.00, 0.00, 'paid', '2025-11-20 06:13:38', NULL, 'Dr Farooq Sab', '+92 321 9476786', '', 'Denticare', 0, 0.00, 4500.00, NULL, NULL, ''),
(153, 1, 6, 'ZAK-20251121-060853', NULL, 36000.00, 0.00, 'paid', '2025-11-21 06:28:32', NULL, 'Mr. Mian Haroon', '+92 335 8734622', '', '', 0, 0.00, 36000.00, NULL, NULL, ''),
(154, 1, 6, 'ZAK-20251121-070843', NULL, 8300.00, 0.00, 'paid', '2025-11-21 07:11:37', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 8300.00, NULL, NULL, ''),
(155, 1, 1, 'ZAK-20251121-160823', NULL, 5180.00, 0.00, 'paid', '2025-11-21 16:10:49', NULL, 'Hafiz Muhammad Naseer', '+92 309 8883449', '', 'Frontier Works Organization (FWO)', 0, 0.00, 5180.00, NULL, NULL, ''),
(157, 1, 1, 'INV-20251124-140809', NULL, 1200.00, 0.00, 'paid', '2025-11-24 14:08:09', NULL, 'Miss Munazza', '+92 311 4008102', '', 'Youth Development Foundation (YDF)', 0, 0.00, 1200.00, NULL, NULL, ''),
(159, 1, 1, 'INV-20251125-124816', NULL, 17500.00, 0.00, 'paid', '2025-11-25 12:48:16', NULL, '', 'Career Advisors Educational Consultant', '', '+92 315 7446786', 0, 0.00, 17500.00, NULL, NULL, ''),
(160, 1, 1, 'ZAK-20251126-105522', NULL, 7200.00, 0.00, 'paid', '2025-11-26 10:56:59', NULL, 'Shirazi Trading', '+92 336 0042976', '', 'Shirazi Trading', 0, 0.00, 7200.00, NULL, NULL, ''),
(161, 1, 6, 'ZAK-20251127-115609', NULL, 11900.00, 0.00, 'paid', '2025-11-27 11:57:55', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 11900.00, NULL, NULL, ''),
(162, 1, 1, 'ZAK-20251127-124830', NULL, 2250.00, 0.00, 'paid', '2025-11-27 12:50:09', NULL, '', '', '', '+92 323 0381713', 0, 0.00, 2250.00, NULL, NULL, ''),
(164, 1, 4, 'MPC-20251128-062627', NULL, 3150.00, 0.00, 'paid', '2025-11-28 06:27:57', NULL, 'Hafiz Khubaib', '0318-2539998', '', '', 1, 5.00, 3000.00, NULL, NULL, 'Please make a payment to\r\nJAZZCASH | EASYPAISA \r\nBeneficiary Name:  Syed Mujeeb Ul Hassan\r\nAccount Number: 0325-1133444'),
(165, 1, 1, 'INV-20251128-120753', NULL, 1760.00, 0.00, 'paid', '2025-11-28 12:07:53', NULL, 'Rana Muhammad Saleem', '+92 322 4379517', '', 'JDS', 0, 0.00, 1760.00, NULL, NULL, ''),
(166, 1, 6, 'ZAK-20251129-064309', NULL, 54200.00, 0.00, 'paid', '2025-11-29 07:04:15', NULL, 'Mr. Nouman', '', '', 'M/S Tkxel NTN : 22181784', 0, 0.00, 54200.00, NULL, NULL, 'Invoice have been generated from Serial No. 840 to 920, for the period from October 31, 2025, to November 28, 2025.'),
(167, 1, 1, 'ZAK-20251129-083047', NULL, 10000.00, 0.00, 'paid', '2025-11-29 08:36:48', NULL, 'Fahad Sab', '', '', 'MTI Medical Pvt Ltd', 0, 0.00, 10000.00, NULL, NULL, ''),
(168, 1, 1, 'INV-20251201-091804', NULL, 6000.00, 0.00, 'paid', '2025-12-01 09:18:04', NULL, 'Life Plus Fertility Clinic', '+92 318 4130586', '', 'Life Plus Fertility Clinic', 0, 0.00, 6000.00, NULL, NULL, ''),
(169, 1, 1, 'ZAK-20251201-095212', NULL, 20000.00, 0.00, 'paid', '2025-12-01 09:54:34', NULL, 'Shamail Shahid', '+92 300 9430988', '', 'Muhammad Asif & Co.', 0, 0.00, 20000.00, NULL, NULL, ''),
(170, 1, 1, 'ZAK-20251202-132623', NULL, 3240.00, 0.00, 'unpaid', '2025-12-02 13:32:24', NULL, 'Farzana Riaz', 'KK C', '', '+92 300 4789727', 0, 0.00, 3240.00, NULL, NULL, ''),
(171, 1, 1, 'ZAK-20251203-110359', NULL, 65400.00, 0.00, 'paid', '2025-12-03 11:12:54', NULL, 'Arslan Sab', '', '', 'SKY EVENTS PK', 0, 0.00, 65400.00, NULL, NULL, ''),
(173, 1, 1, 'INV-20251204-092646', NULL, 98000.00, 0.00, 'paid', '2025-12-04 09:26:46', NULL, 'Awais Sab', '+92 322 8085406', '', 'ecargo World', 1, 0.00, 98000.00, NULL, NULL, ''),
(174, 1, 7, 'ZAK-20251205-110133', NULL, 28980.80, 0.00, 'paid', '2025-12-05 11:05:21', NULL, 'Ejaz Hussain Virk', '+92 300 8036229', '', 'Stylers International Limited', 1, 18.00, 24560.00, NULL, NULL, ''),
(175, 1, 1, 'ZAK-20251206-095913', NULL, 26500.00, 0.00, 'paid', '2025-12-06 10:10:58', NULL, 'Rahat Saeed Sab', '+92 322 9499809', '', 'Ocean Paints', 0, 0.00, 26500.00, NULL, NULL, ''),
(176, 1, 1, 'INV-20251206-102624', NULL, 88000.00, 0.00, 'paid', '2025-12-06 10:26:24', NULL, 'Fahad Sab', '+92 301 4542694', '', 'MTI Medical Pvt Ltd', 0, 0.00, 88000.00, NULL, NULL, ''),
(177, 1, 1, 'INV-20251208-082101', NULL, 12000.00, 0.00, 'paid', '2025-12-08 08:21:01', NULL, 'Jabran Akbar', '+92 300 7493192', '', 'iTee University', 0, 0.00, 12000.00, NULL, NULL, ''),
(178, 1, 6, 'ZAK-20251211-054923', NULL, 12400.00, 0.00, 'paid', '2025-12-11 05:52:13', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 12400.00, NULL, NULL, ''),
(179, 1, 1, 'INV-20251211-110938', NULL, 8260.00, 0.00, 'unpaid', '2025-12-11 11:09:38', NULL, 'Muhammad Akbar', '+92 314 4004756', '', 'Stylers International', 1, 18.00, 7000.00, NULL, NULL, ''),
(180, 1, 6, 'ZAK-20251213-111401', NULL, 11350.00, 0.00, 'partial', '2025-12-13 11:15:19', NULL, 'Mr. Muhammad Naeem', '', '', '', 0, 0.00, 11350.00, NULL, NULL, ''),
(181, 1, 6, 'ZAK-20251215-123453', NULL, 16100.00, 0.00, 'paid', '2025-12-15 12:38:45', NULL, 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 16100.00, NULL, NULL, ''),
(182, 1, 6, 'ZAK-20251219-074452', NULL, 4500.00, 0.00, 'paid', '2025-12-19 07:45:42', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 4500.00, NULL, NULL, ''),
(183, 1, 1, 'ZAK-20251224-112631', NULL, 19753.20, 0.00, 'paid', '2025-12-24 11:35:13', NULL, 'Hafiz Muhammad Hamza', '03217399690', 'm.hamza@stylersintl.com', 'Stylers International Limited', 1, 18.00, 16740.00, NULL, NULL, ''),
(185, 1, 6, 'ZAK-20251226-111734', NULL, 53750.00, 0.00, 'paid', '2025-12-26 11:20:40', NULL, 'Mr. Nouman', '', '', 'M/S TKXEL', 0, 0.00, 53750.00, NULL, NULL, 'Invoice have been generated from Serial No. 920 to 1003, for the period from 1 December 2025 to 26 December 2025'),
(186, 1, 1, 'INV-20251227-113825', NULL, 22000.00, 0.00, 'paid', '2025-12-27 11:38:25', NULL, 'Hasnain Saheb', '+92 300 1919198', '', 'MTECH', 0, 0.00, 22000.00, NULL, NULL, ''),
(187, 1, 1, 'ZAK-20260106-154520', NULL, 17500.00, 0.00, 'paid', '2026-01-06 15:46:18', NULL, 'Dr. Kashif Sab', '+92 336 3013535', '', 'sheikh zayed hospital lahore', 0, 0.00, 17500.00, NULL, NULL, ''),
(188, 1, 1, 'INV-20260107-093804', NULL, 9280.00, 0.00, 'paid', '2026-01-07 09:38:04', NULL, 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 9280.00, NULL, NULL, ''),
(189, 1, 1, 'ZAK-20260108-113347', NULL, 6970.00, 0.00, 'paid', '2026-01-08 11:40:08', NULL, 'Mudsir Sab', '+92 302 5760520', '', 'MPC', 0, 0.00, 6970.00, NULL, NULL, ''),
(190, 1, 6, 'ZAK-20260109-094530', NULL, 7300.00, 0.00, 'paid', '2026-01-09 09:47:19', NULL, 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 7300.00, NULL, NULL, ''),
(191, 1, 1, 'ZAK-20260109-170756', NULL, 3388.00, 0.00, 'unpaid', '2026-01-09 17:12:04', NULL, 'Usama Javed', '', '', '+92 307 9418400', 0, 0.00, 3388.00, NULL, NULL, ''),
(192, 1, 1, 'INV-20260110-081121', NULL, 45465.00, 0.00, 'paid', '2026-01-10 08:11:21', NULL, 'Malik Javed Sab', '+92 319 6998413', '', 'Pathfinder International', 0, 0.00, 45465.00, NULL, NULL, ''),
(193, 1, 1, 'INV-20260110-081925', NULL, 31000.00, 0.00, 'paid', '2026-01-10 08:19:25', NULL, 'Malik Javed Sab', '+92 319 6998413', '', 'Pathfinder International', 0, 0.00, 31000.00, NULL, NULL, ''),
(194, 1, 1, 'INV-20260110-082612', NULL, 45000.00, 0.00, 'paid', '2026-01-10 08:26:12', NULL, 'Malik Javed Sab', '+92 319 6998413', '', 'Pathfinder International', 0, 0.00, 45000.00, NULL, NULL, ''),
(195, 1, 1, 'INV-20260110-082725', NULL, 37500.00, 0.00, 'paid', '2026-01-10 08:27:25', NULL, 'Malik Javed Sab', '+92 319 6998413', '', 'Pathfinder International', 0, 0.00, 37500.00, NULL, NULL, ''),
(196, 1, 1, 'INV-20260110-083516', NULL, 20940.00, 0.00, 'paid', '2026-01-10 08:35:16', NULL, 'Malik Javed Sab', '+92 319 6998413', '', 'Pathfinder International', 0, 0.00, 20940.00, NULL, NULL, ''),
(198, 1, 1, 'INV-20260113-084213', NULL, 250000.00, 0.00, 'partial', '2026-01-13 08:42:13', NULL, 'Hasnain Saheb', '+92 300 1919198', '', 'Habib Engineering', 0, 0.00, 250000.00, NULL, NULL, ''),
(199, 1, 6, 'ZAK-20260114-061728', NULL, 45150.00, 0.00, 'paid', '2026-01-14 06:18:14', NULL, 'Mr. Nouman', '', '', 'M/S TKXEL', 0, 0.00, 45150.00, NULL, NULL, 'Invoice have been generated from Serial No.  1004 to 1072, for the period from 30 December 2025 to 14 January 2026.'),
(200, 1, 1, 'INV-20260114-112218', NULL, 37500.00, 0.00, 'paid', '2026-01-14 11:22:18', NULL, 'Malik Javed Sab', '+92 319 6998413', '', 'Pathfinder International', 0, 0.00, 37500.00, NULL, NULL, ''),
(201, 1, 1, 'ZAK-20260114-125747', NULL, 7800.00, 0.00, 'paid', '2026-01-14 13:00:23', NULL, 'Engr Manzar Sab', '+92 344 2759596', '', 'Aesthetics Emporium', 0, 0.00, 7800.00, NULL, NULL, ''),
(202, 1, 1, 'INV-20260114-133050', NULL, 43200.00, 0.00, 'paid', '2026-01-14 13:30:50', NULL, 'Fahad Sab', '', '', 'MTI Medical Pvt Ltd', 0, 0.00, 43200.00, NULL, NULL, ''),
(203, 1, 1, 'ZAK-20260116-170002', NULL, 38150.00, 0.00, 'paid', '2026-01-16 17:07:39', NULL, 'Urshyan', '+92 300 5953504', '', 'Trade unleashed', 0, 0.00, 38150.00, NULL, NULL, ''),
(204, 1, 6, 'ZAK-20260120-080511', NULL, 2500.00, 0.00, 'paid', '2026-01-20 08:06:23', NULL, 'Mr. Abbas', '', '', 'M/s Goldfinh', 0, 0.00, 2500.00, NULL, NULL, ''),
(205, 1, 1, 'INV-20260123-103606', NULL, 16000.00, 0.00, 'paid', '2026-01-23 10:36:06', NULL, 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 16000.00, NULL, NULL, ''),
(208, 1, 6, 'ZAK-20260124-064434', NULL, 8800.00, 0.00, 'paid', '2026-01-24 06:46:36', NULL, 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 8800.00, NULL, NULL, ''),
(212, 1, 1, 'ZAK-20260126-104750', NULL, 10500.00, 0.00, 'paid', '2026-01-26 10:48:58', NULL, 'Dr Saqib Bajwa Sab', '+92 322 3977773', '', '', 0, 0.00, 10500.00, NULL, NULL, ''),
(216, 1, 1, 'INV-20260128-070222', NULL, 20000.00, 0.00, 'paid', '2026-01-28 07:02:22', NULL, 'Awais Sab', '+92 322 8085406', '', 'ecargo World', 1, 0.00, 20000.00, NULL, NULL, ''),
(217, 1, 1, 'INV-20260128-073338', NULL, 5255.00, 0.00, 'paid', '2026-01-28 07:33:38', NULL, 'Tahir Satta', '+92 334 0017406', '', 'Youth Development Foundation (YDF)', 0, 0.00, 5255.00, NULL, NULL, ''),
(218, 1, 7, 'INV-20260128-094952', NULL, 115109.00, 0.00, 'unpaid', '2026-01-28 09:49:52', NULL, 'Naeem Akhtar Sab', '+92 334 4002878', '', 'Pakistan Expo Center, Lahore', 1, 18.00, 97550.00, NULL, NULL, NULL),
(219, 1, 1, 'ZAK-20260128-124524', NULL, 8000.00, 0.00, 'paid', '2026-01-28 12:46:41', NULL, 'Sagar Javeed', '+92 312 4172800', '', '', 0, 0.00, 8000.00, NULL, NULL, ''),
(220, 1, 1, 'INV-20260129-105029', NULL, 7000.00, 0.00, 'paid', '2026-01-29 10:50:29', NULL, 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 7000.00, NULL, NULL, ''),
(221, 1, 1, 'INV-20260129-124239', NULL, 43200.00, 0.00, 'paid', '2026-01-29 12:42:39', NULL, 'Fahad Sab', '', '', 'MTI Medical Pvt Ltd', 0, 0.00, 43200.00, NULL, NULL, ''),
(222, 1, 1, 'ZAK-20260130-110731', NULL, 2310.00, 0.00, 'paid', '2026-01-30 11:09:38', NULL, 'Adeel Rao', '+92 321 3285862', '', '', 0, 0.00, 2310.00, NULL, NULL, ''),
(223, 1, 1, 'INV-20260130-121322', NULL, 15300.00, 0.00, 'paid', '2026-01-30 12:13:22', NULL, 'Bilal Sab', '+92 315 7014534', '', 'Elite Police Traning School', 0, 0.00, 15300.00, NULL, NULL, ''),
(224, 1, 6, 'ZAK-20260131-064525', NULL, 43850.00, 0.00, 'paid', '2026-01-31 06:48:00', NULL, 'Mr. Nouman', '', '', 'M/S TKXEL', 0, 0.00, 43850.00, NULL, NULL, 'Invoice have been generated from Serial No.1072 to 1143, for the period from 13 January 2026 to 31 January 2026.'),
(226, 1, 1, 'INV-20260202-085125', NULL, 4500.00, 0.00, 'paid', '2026-02-02 08:51:25', NULL, 'Yasir Hanif', '+92 300 5953504', '', 'GLISTEN INTERNATIONAL', 0, 0.00, 4500.00, NULL, NULL, ''),
(227, 1, 1, 'INV-20260202-090836', NULL, 8200.00, 0.00, 'paid', '2026-02-02 09:08:36', NULL, 'Amir Habib Sab', '+92 300 4412321', '', 'Habib Engineering', 0, 0.00, 8200.00, NULL, NULL, ''),
(228, 1, 1, 'ZAK-20260202-093342', NULL, 11900.00, 0.00, 'paid', '2026-02-02 09:36:16', NULL, 'Mehran Sab', '+92 300 9434719', '', 'Nw Technology', 0, 0.00, 11900.00, NULL, NULL, ''),
(229, 1, 1, 'ZAK-20260202-095633', NULL, 6900.00, 0.00, 'paid', '2026-02-02 09:57:38', NULL, 'Umair Butt Sab', '+92 309 8960110', '', '', 0, 0.00, 6900.00, NULL, NULL, ''),
(230, 1, 6, 'ZAK-20260202-112353', NULL, 3930.00, 0.00, 'paid', '2026-02-02 11:26:00', NULL, 'Mr. Waleed', '', '', 'Innovative Software LLC', 0, 0.00, 3930.00, NULL, NULL, ''),
(231, 1, 1, 'INV-20260203-072031', NULL, 560.00, 0.00, 'paid', '2026-02-03 07:20:31', NULL, 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 560.00, NULL, NULL, ''),
(232, 1, 1, 'ZAK-20260204-072126', NULL, 6600.00, 0.00, 'paid', '2026-02-04 07:29:44', NULL, 'Abdul Ahad Sab', '03396180080', '', 'ZA. Legal', 0, 0.00, 6600.00, NULL, NULL, ''),
(233, 1, 1, 'ZAK-20260204-094046', NULL, 4000.00, 0.00, 'partial', '2026-02-04 09:42:10', NULL, 'Syed Taqi Shah', '03008645314', '', 'Change Agent', 0, 0.00, 4000.00, NULL, NULL, ''),
(234, 1, 1, 'ZAK-20260209-071350', NULL, 21780.00, 0.00, 'paid', '2026-02-09 07:22:33', NULL, 'Zakriya Sab', '+92 312 4415574', '', 'Zpeak', 0, 0.00, 21780.00, NULL, NULL, ''),
(235, 1, 1, 'INV-20260210-083317', NULL, 560.00, 0.00, 'paid', '2026-02-10 08:33:17', NULL, 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 560.00, NULL, NULL, ''),
(236, 1, 1, 'INV-20260210-083336', NULL, 76500.00, 0.00, 'partial', '2026-02-10 08:33:36', '2026-02-10', 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 76500.00, NULL, NULL, ''),
(238, 1, 1, 'ZAK-20260211-075451', NULL, 3500.00, 0.00, 'paid', '2026-02-11 07:56:13', NULL, 'Shan Anwar Sab', '+92 320 9047111', '', 'SA CONTRACTING Shan', 0, 0.00, 3500.00, NULL, NULL, ''),
(239, 1, 1, 'INV-20260211-081340', NULL, 21000.00, 0.00, 'unpaid', '2026-02-11 08:13:40', NULL, 'Rahat Saeed Sab', '+92 322 9499809', '', 'Ocean Paints Private Limited', 0, 0.00, 21000.00, NULL, NULL, ''),
(243, 1, 1, 'ZAK-20260212-050532', NULL, 3300.00, 0.00, 'paid', '2026-02-12 05:07:20', NULL, 'Mudassar Nawaz', '03270041919', '', '', 0, 0.00, 3300.00, NULL, NULL, ''),
(245, 1, 7, '2516702', NULL, 8260.00, 0.00, 'paid', '2026-02-12 09:57:59', '2026-02-12', 'Muhammad Akbar Sab', '+92 314 4004756', '', 'Stylers International', 1, 18.00, 7000.00, NULL, NULL, ''),
(246, 1, 6, 'ZAK-20260212-115516', NULL, 3400.00, 0.00, 'paid', '2026-02-12 11:57:06', NULL, 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 3400.00, NULL, NULL, ''),
(247, 1, 6, 'ZAK-20260213-105724', NULL, 1000.00, 0.00, 'paid', '2026-02-13 10:57:50', NULL, 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 1000.00, NULL, NULL, ''),
(248, 1, 1, 'INV-20260216-113321', NULL, 15000.00, 0.00, 'paid', '2026-02-16 11:33:21', NULL, 'Rukhsar Ahmad', '+92 320 8444414', '', 'Midjac Pvt Ltd.', 0, 0.00, 15000.00, NULL, NULL, ''),
(250, 1, 6, 'ZAK-20260217-092154', NULL, 3100.00, 0.00, 'paid', '2026-02-17 09:23:51', NULL, 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 3100.00, NULL, NULL, ''),
(251, 1, 1, 'ZAK-20260217-141703', NULL, 2950.00, 0.00, 'partial', '2026-02-17 14:19:16', NULL, '', '03096554946', 'ar.kashifyaqoob@gmail.com', 'zak media', 0, 0.00, 2500.00, NULL, NULL, ''),
(254, 1, 1, 'ZAK-190226', NULL, 8930.00, 0.00, 'paid', '2026-02-19 10:56:15', NULL, 'Afaq Sab', '+92 301 4111691', '', '', 0, 0.00, 8930.00, NULL, NULL, ''),
(256, 1, 1, 'INV-20260221-082208', NULL, 1300.00, 0.00, 'paid', '2026-02-21 08:22:08', NULL, 'Afaq Sab', '+92 301 4111691', '', '', 0, 0.00, 1300.00, NULL, NULL, ''),
(257, 1, 6, 'ZAK-20260225-073859', NULL, 2800.00, 0.00, 'paid', '2026-02-25 07:41:04', NULL, 'Mr. Yahya Khan', '+92 302 5878684', '', '', 0, 0.00, 2800.00, NULL, NULL, ''),
(258, 1, 1, 'INV-20260227-065018', NULL, 29500.00, 0.00, 'paid', '2026-02-27 06:50:18', NULL, 'Dr Farooq Sab', '+92 321 9476786', '', 'Denticare', 0, 0.00, 29500.00, NULL, NULL, ''),
(259, 1, 1, 'ZAK-20260227-065758', NULL, 4500.00, 0.00, 'paid', '2026-02-27 06:59:10', NULL, 'Abdu Qayam', '03120504003', 'abdul.ayyum860466@gmail.com', '', 0, 0.00, 4500.00, NULL, NULL, ''),
(261, 1, 1, 'ZAK-20260227-092814', NULL, 400.00, 0.00, 'paid', '2026-02-27 09:31:44', NULL, 'Moin sab', '+92 3034807110', 'dr.hmoin@yahoo.com', '', 0, 0.00, 400.00, NULL, NULL, ''),
(262, 1, 6, 'ZAK-20260228-073503', NULL, 48350.00, 0.00, 'paid', '2026-02-28 07:37:41', NULL, 'Mr. Nouman Anas', '', 'nauman.anas@corp.tkxel.com', 'M/S Tkxel NTN : 22181784', 0, 0.00, 48350.00, NULL, NULL, 'Invoice have been generated from Serial No. 1144 to 1215. dated 02 February 2026 to 27 February 2026.'),
(263, 1, 1, 'INV-20260302-074407', NULL, 7250.00, 0.00, 'paid', '2026-03-02 07:44:07', NULL, 'Abdu Qayyam Sab', '03120504003', 'abdul.ayyum860466@gmail.com', '', 0, 0.00, 7250.00, NULL, NULL, ''),
(264, 1, 1, 'INV-20260302-091109', NULL, 76500.00, 0.00, 'partial', '2026-03-02 09:11:09', NULL, 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 76500.00, NULL, NULL, ''),
(265, 1, 1, 'ZAK-20260302-103555', NULL, 7800.00, 0.00, 'paid', '2026-03-02 10:36:47', NULL, 'Sagar Javeed', '+92 312 4172800', '', '', 0, 0.00, 7800.00, NULL, NULL, ''),
(266, 1, 1, 'INV-20260303-080534', NULL, 12100.00, 0.00, 'unpaid', '2026-03-03 08:05:34', '2026-03-03', 'Fahad Sab', '', '', 'MTI Medical Pvt Ltd', 0, 0.00, 12100.00, NULL, NULL, ''),
(267, 1, 1, 'ZAK-20260303-080740', NULL, 7000.00, 0.00, 'paid', '2026-03-03 08:10:07', '2026-03-03', 'mudasir Sab', '+92 321 5033524', '', '', 0, 0.00, 7000.00, NULL, NULL, ''),
(268, 1, 6, 'ZAK-20260303-095609', NULL, 33000.00, 0.00, 'partial', '2026-03-03 09:58:04', NULL, 'Ms. Syeda Fatima', '+92 336 4543634', '', '', 0, 0.00, 33000.00, NULL, NULL, ''),
(270, 1, 1, 'ZAK-20260303-101917', NULL, 50000.00, 0.00, 'unpaid', '2026-03-03 10:19:51', NULL, 'Mr. Muhammad Naeem', '309654946', 'info.zakprinting@gmail.com', 'ZAK Printing', 0, 0.00, 50000.00, NULL, NULL, ''),
(272, 1, 1, 'INV-20260303-144001', NULL, 11900.00, 0.00, 'paid', '2026-03-03 14:40:01', NULL, 'Mehran Sab', '+92 300 9434719', '', 'Nw Technology', 0, 0.00, 11900.00, NULL, NULL, ''),
(273, 1, 1, 'ZAK-20260306-071047', NULL, 2000.00, 0.00, 'paid', '2026-03-06 07:11:26', '2026-03-06', 'Mr. Yahya Khan', '', '', 'M/s Goldfinh', 0, 0.00, 2000.00, NULL, NULL, ''),
(274, 1, 1, 'INV-20260306-100955', NULL, 21160.00, 0.00, 'partial', '2026-03-06 10:09:55', '2026-03-06', 'Rizwan Sab', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 21160.00, NULL, NULL, ''),
(277, 1, 1, 'INV-20260311-081951', NULL, 7250.00, 0.00, 'paid', '2026-03-11 08:19:51', NULL, 'Abdu Qayyam Sab', '03120504003', 'abdul.ayyum860466@gmail.com', '', 0, 0.00, 7250.00, NULL, NULL, ''),
(278, 1, 1, 'INV-20260311-082002', NULL, 5500.00, 0.00, 'paid', '2026-03-11 08:20:02', '2026-03-11', 'Abdu Qayyam Sab', '03120504003', 'abdul.ayyum860466@gmail.com', '', 0, 0.00, 5500.00, NULL, NULL, ''),
(279, 1, 1, 'INV-20260313-070327', NULL, 46100.00, 0.00, 'paid', '2026-03-13 07:03:27', '2026-03-06', 'Miss Saira', '+92 303 4003460', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 46100.00, NULL, NULL, ''),
(280, 1, 7, '251705', NULL, 29795.00, 0.00, 'unpaid', '2026-03-14 07:57:10', '2026-03-14', 'Muhammad Akbar Sab', '+92 314 4004756', '', 'Stylers International', 1, 18.00, 25250.00, NULL, NULL, ''),
(281, 1, 1, 'ZAK-20260317-110445', NULL, 1320.00, 0.00, 'unpaid', '2026-03-17 11:05:38', '2026-03-17', '', '', '', '', 0, 0.00, 1320.00, NULL, NULL, ''),
(282, 1, 1, 'ZAK-20260317-170447', NULL, 780.00, 0.00, 'paid', '2026-03-17 17:05:57', '2026-03-17', 'Softshifters', '+92 306 4206801', '', 'Softshifters', 0, 0.00, 780.00, NULL, NULL, ''),
(283, 1, 1, 'ZAK-20260325-074325', NULL, 5700.00, 0.00, 'paid', '2026-03-25 07:48:12', '2026-03-25', 'Mr. Yahya Khan', '03025878684', '', 'M/s Goldfinh', 0, 0.00, 5700.00, NULL, NULL, ''),
(284, 1, 1, 'INV-20260326-055447', NULL, 17500.00, 0.00, 'unpaid', '2026-03-26 05:54:47', NULL, 'Atif Sab', '+92 321 9522071', '', 'Youth Development Foundation (YDF)', 0, 0.00, 17500.00, NULL, NULL, ''),
(285, 1, 1, 'INV-20260326-055550', NULL, 4500.00, 0.00, 'unpaid', '2026-03-26 05:55:50', '2026-03-26', 'Atif Sab', '+92 321 9522071', '', 'Youth Development Foundation (YDF)', 0, 0.00, 4500.00, NULL, NULL, ''),
(286, 1, 1, 'INV-20260326-084415', NULL, 135796.00, 0.00, 'partial', '2026-03-26 08:44:15', '2026-03-26', 'Shan Anwar Sab', '+92 320 9047111', '', 'SA CONTRACTING Shan', 0, 0.00, 135796.00, NULL, NULL, ''),
(287, 1, 7, 'ZAK-20260327-092402', NULL, 109210.00, 0.00, 'unpaid', '2026-03-27 09:31:34', '2026-03-27', 'Naeem Akhtar Sab', '03096554946', 'ar.kashifyaqoob@gmail.com', 'zak media', 0, 0.00, 109210.00, NULL, NULL, ''),
(288, 1, 6, 'ZAK-20260327-092958', NULL, 5750.00, 0.00, 'paid', '2026-03-27 09:31:35', '2026-03-27', 'Mr. Yahya Khan', '+92 302 5878684', '', 'M/s Goldfinh', 0, 0.00, 5750.00, NULL, NULL, ''),
(289, 1, 7, 'INV-20260327-093149', NULL, 179289.20, 0.00, 'unpaid', '2026-03-27 09:31:49', '2026-03-27', 'Naeem Akhtar Sab', '03096554946', 'ar.kashifyaqoob@gmail.com', 'zak media', 0, 0.00, 151940.00, NULL, NULL, ''),
(290, 1, 6, 'ZAK-20260327-132913', NULL, 2000.00, 0.00, 'paid', '2026-03-27 13:30:00', '2026-03-27', 'Mr. Yahya Khan', '+92 302 5878684', '', 'M/s Goldfinh', 0, 0.00, 2000.00, NULL, NULL, ''),
(291, 1, 6, 'ZAK-20260330-134202', NULL, 9950.00, 0.00, 'paid', '2026-03-30 13:44:42', '2026-03-30', 'Mr. Yahya Khan', '+92 302 5878684', '', 'M/s Goldfinh', 0, 0.00, 9950.00, NULL, NULL, ''),
(292, 1, 6, 'ZAK-20260331-062509', NULL, 2200.00, 0.00, 'paid', '2026-03-31 06:25:35', '2026-03-31', 'Mr. Yahya Khan', '+92 302 5878684', '', 'M/s Goldfinh', 0, 0.00, 2200.00, NULL, NULL, ''),
(293, 1, 6, 'ZAK-20260401-063330', NULL, 43400.00, 0.00, 'paid', '2026-04-01 06:38:52', '2026-04-01', 'Mr. Nouman Anas', '', 'nauman.anas@corp.tkxel.com', 'M/S TKXEL', 0, 0.00, 43400.00, NULL, NULL, 'Invoice have been generated from Serial No. 1216 to 1277, dated 02 March 2026 to 31 March 2026'),
(294, 1, 1, 'ZAK-20260401-132816', NULL, 11600.00, 0.00, 'unpaid', '2026-04-01 13:32:40', '2026-04-01', 'visa advisor', '+92 304 0304304', '', '', 0, 0.00, 11600.00, NULL, NULL, ''),
(295, 1, 1, 'INV-20260402-072024', NULL, 2000.00, 0.00, 'unpaid', '2026-04-02 07:20:24', '2026-04-02', 'Rana Muhammad Saleem', '+92 322 4379517', '', 'JDS', 0, 0.00, 2000.00, NULL, NULL, ''),
(296, 1, 1, 'ZAK-20260402-082415', NULL, 6400.00, 0.00, 'unpaid', '2026-04-02 08:25:57', '2026-04-02', 'Razzaq Sab', '+92 300 4999241', '', 'ARS Traders', 0, 0.00, 6400.00, NULL, NULL, ''),
(297, 1, 1, 'ZAK-20260402-140506', NULL, 2500.00, 0.00, 'paid', '2026-04-02 14:08:36', '2026-04-02', 'Talha Ansari', '+92 313 6548390', '', '', 0, 0.00, 2500.00, NULL, NULL, ''),
(298, 1, 1, 'ZAK-20260403-114927', NULL, 104940.00, 0.00, 'unpaid', '2026-04-03 11:57:53', '2026-04-03', 'Hamza Irfan', '+92 324 4425949', '', '', 0, 0.00, 104940.00, NULL, NULL, ''),
(299, 1, 1, 'INV-20260406-115738', NULL, 4800.00, 0.00, 'unpaid', '2026-04-06 11:57:38', '2026-04-06', 'Wajid Sab', '+92 321 4632844', '', 'ISP Environmental Solutions Pvt. Ltd.', 0, 0.00, 4800.00, NULL, NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `finance_product_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `line_total` decimal(10,2) NOT NULL,
  `tax_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `product_id`, `finance_product_id`, `description`, `quantity`, `price`, `line_total`, `tax_percent`, `tax_amount`) VALUES
(46, 14, NULL, NULL, '4x4 Inch Round Stacker with Plotter Cutting and Shine Lamination', 500, 15.00, 7500.00, 0.00, 0.00),
(47, 16, NULL, NULL, 'A4 SIZE BLACK PRINT Front and Back Side', 998, 4.00, 3992.00, 0.00, 0.00),
(58, 19, NULL, NULL, 'A4 COLOR PRINT with Binding', 100, 20.00, 2000.00, 0.00, 0.00),
(136, 23, NULL, NULL, 'A4 Size 100 Gsm INVOICE Print Front and Back Side', 100, 60.00, 6000.00, 0.00, 0.00),
(137, 23, NULL, NULL, 'A4 Size 100 Gsm Letter Head Print', 100, 30.00, 3000.00, 0.00, 0.00),
(258, 50, NULL, NULL, 'Digtal 100 Gsm Envlap Printing w', 100, 60.00, 6000.00, 0.00, 0.00),
(263, 51, NULL, NULL, 'Flex Print 4x2 Feet for Table', 1, 560.00, 560.00, 0.00, 0.00),
(264, 51, NULL, NULL, 'Standee WIth 4 Side Rings', 1, 800.00, 800.00, 0.00, 0.00),
(265, 51, NULL, NULL, 'Shehzore 3x5 Feet flex', 2, 1050.00, 2100.00, 0.00, 0.00),
(266, 53, NULL, NULL, 'All Pending Bills', 1, 98000.00, 98000.00, 0.00, 0.00),
(270, 54, NULL, NULL, 'E Stamp (Rs.1200) Formatting, Printing,Extra Prints', 4, 2500.00, 10000.00, 0.00, 0.00),
(341, 61, NULL, NULL, 'A4 Size Sticker Pritning', 17, 60.00, 1020.00, 0.00, 0.00),
(342, 61, NULL, NULL, 'Design', 1, 200.00, 200.00, 0.00, 0.00),
(464, 83, NULL, NULL, 'Flex Print 5x3 Feet', 10, 800.00, 8000.00, 0.00, 0.00),
(588, 78, NULL, NULL, '350 Gsm UV Front and Back Card Round Cutting', 3000, 3.00, 9000.00, 0.00, 0.00),
(589, 78, NULL, NULL, '100 Gsm Letter Head with 4 Color Printing', 1000, 10.00, 10000.00, 0.00, 0.00),
(590, 78, NULL, NULL, 'Star Flex Print 20x4 Feet', 1, 4800.00, 4800.00, 0.00, 0.00),
(591, 78, NULL, NULL, 'Star Flex Print 43x4 Feet', 1, 10320.00, 10320.00, 0.00, 0.00),
(592, 78, NULL, NULL, 'Logo Design', 1, 0.00, 0.00, 0.00, 0.00),
(593, 78, NULL, NULL, 'Flex Design', 1, 0.00, 0.00, 0.00, 0.00),
(594, 78, NULL, NULL, 'Letter Head Desgin', 1, 0.00, 0.00, 0.00, 0.00),
(595, 78, NULL, NULL, 'Auto Stamps', 1, 1000.00, 1000.00, 0.00, 0.00),
(596, 76, NULL, NULL, 'A3 Color Print 4 Set', 112, 35.00, 3920.00, 0.00, 0.00),
(597, 76, NULL, NULL, 'A4 Color Print A4', 120, 30.00, 3600.00, 0.00, 0.00),
(598, 76, NULL, NULL, 'Tap Binding A4 & A3', 5, 200.00, 1000.00, 0.00, 0.00),
(777, 98, 12, NULL, 'Auto Stamp With Blue Ink', 2, 1500.00, 3000.00, 0.00, 0.00),
(805, 84, NULL, NULL, 'T-Shirt Printing with Logo DTF', 24, 1500.00, 36000.00, 0.00, 0.00),
(806, 84, NULL, NULL, 'Flood Aid-YDF Sticker A4 Size', 300, 70.00, 21000.00, 0.00, 0.00),
(807, 84, NULL, NULL, 'Cap with Logo Print White', 24, 800.00, 19200.00, 0.00, 0.00),
(808, 84, NULL, NULL, 'Standee with 4 Side Rings', 5, 1000.00, 5000.00, 0.00, 0.00),
(809, 84, NULL, NULL, 'Flex 2x3 Feet', 3, 500.00, 1500.00, 0.00, 0.00),
(810, 84, NULL, NULL, 'Flex 6x4 Feet With Rings', 3, 2000.00, 6000.00, 0.00, 0.00),
(811, 84, NULL, NULL, 'Sticker 4x4 inch Printing', 500, 40.00, 20000.00, 0.00, 0.00),
(812, 84, NULL, NULL, '8x12 Feet Flex China', 1, 6720.00, 6720.00, 0.00, 0.00),
(813, 84, NULL, NULL, 'Digital Business card design and pirnt with Lamination', 50, 25.00, 1250.00, 0.00, 0.00),
(833, 57, NULL, NULL, '10x4 Feet Star flex', 1, 2800.00, 2800.00, 0.00, 0.00),
(834, 57, NULL, NULL, 'Book Printing', 1, 5450.00, 5450.00, 0.00, 0.00),
(835, 57, NULL, NULL, 'Book Printing', 1, 5390.00, 5390.00, 0.00, 0.00),
(836, 57, NULL, NULL, 'Book Printing', 1, 4150.00, 4150.00, 0.00, 0.00),
(837, 57, NULL, NULL, '12x4 Feet Principle', 1, 3360.00, 3360.00, 0.00, 0.00),
(838, 57, NULL, NULL, '2x3 Feet FINAL INSPECTION STEPS', 1, 420.00, 420.00, 0.00, 0.00),
(839, 57, NULL, NULL, '2x3 Feet Packing Aera', 2, 420.00, 840.00, 0.00, 0.00),
(840, 58, NULL, NULL, '8x12 steel less steel plate with engraving.', 4, 1400.00, 5600.00, 0.00, 0.00),
(841, 58, NULL, NULL, 'Standee with 4 Side Rings', 2, 1000.00, 2000.00, 0.00, 0.00),
(842, 58, NULL, NULL, 'Tree Plantation Drive 12x8 feet (Back Drop)', 1, 6720.00, 6720.00, 0.00, 0.00),
(843, 58, NULL, NULL, 'Tree Plantation Drive 8x10 feet', 1, 5600.00, 5600.00, 0.00, 0.00),
(844, 58, NULL, NULL, 'Diamond Shape shield with transparent sticker printing', 1, 3800.00, 3800.00, 0.00, 0.00),
(845, 58, NULL, NULL, 'Gate no. 2, 3 and Vinyl sticker with matt lamination', 2, 4050.00, 8100.00, 0.00, 0.00),
(846, 58, NULL, NULL, '10x4 Feet Star flex', 1, 2800.00, 2800.00, 0.00, 0.00),
(847, 58, NULL, NULL, 'Standee with 4 Side Rings', 2, 1000.00, 2000.00, 0.00, 0.00),
(934, 101, NULL, NULL, 'Standee with 4 Side Rings', 1, 1000.00, 1000.00, 0.00, 0.00),
(935, 101, NULL, NULL, 'Certificate Printing on Art Card', 30, 70.00, 2100.00, 0.00, 0.00),
(936, 101, NULL, NULL, 'Passport Size Photo', 1, 200.00, 200.00, 0.00, 0.00),
(937, 101, NULL, NULL, '150 Gsm Paper Print', 4, 50.00, 200.00, 0.00, 0.00),
(938, 101, NULL, NULL, 'A4 Size Sticker Printing', 200, 70.00, 14000.00, 0.00, 0.00),
(952, 102, NULL, NULL, 'Single Side 350 Gsm UV Visiting Cards', 2, 2500.00, 5000.00, 0.00, 0.00),
(953, 102, NULL, NULL, '14x3 Feet Flex China', 1, 2520.00, 2520.00, 0.00, 0.00),
(954, 102, NULL, NULL, '6x3 Feet Flex China', 1, 1080.00, 1080.00, 0.00, 0.00),
(955, 102, NULL, NULL, '3x3 Feet Flex China', 1, 540.00, 540.00, 0.00, 0.00),
(956, 102, NULL, NULL, 'All Flex and Card Design', 1, 1000.00, 1000.00, 0.00, 0.00),
(957, 102, NULL, NULL, 'Letter Head Print A4 Size', 10, 20.00, 200.00, 0.00, 0.00),
(958, 102, NULL, NULL, 'Auto Stamp With Blue Ink', 1, 300.00, 300.00, 0.00, 0.00),
(962, 104, NULL, NULL, '100 Gsm Yellow Page Notepads with 4 Color Printing Each Pad 100 Pages', 12, 600.00, 7200.00, 0.00, 0.00),
(963, 104, NULL, NULL, '100 Gsm Fornt and Back Side Invoice with 4 Color Printing 10 Books Each Book 100 Pages', 10, 800.00, 8000.00, 0.00, 0.00),
(964, 104, NULL, NULL, 'Matt Paper 150 Gsm Brochure Fornt and Back Side 4 Color Printing', 2000, 12.50, 25000.00, 0.00, 0.00),
(974, 119, NULL, NULL, 'A4 Black Print 80 Gsm', 27, 8.00, 216.00, 0.00, 0.00),
(975, 119, NULL, NULL, 'A4 Size Color Print 80 Gsm', 44, 20.00, 880.00, 0.00, 0.00),
(990, 118, NULL, NULL, 'Digtal Card with Lemanation and Round Cutting', 109, 20.00, 2180.00, 0.00, 0.00),
(991, 118, NULL, NULL, 'A4 Size Certificate Print', 27, 35.00, 945.00, 0.00, 0.00),
(992, 118, NULL, NULL, 'PVC card with Dori and Card Hoder', 21, 250.00, 5250.00, 0.00, 0.00),
(993, 118, NULL, NULL, '4x6 Inch Card', 50, 20.00, 1000.00, 0.00, 0.00),
(994, 118, NULL, NULL, 'A4 Size Certificate Print', 26, 50.00, 1300.00, 0.00, 0.00),
(995, 118, NULL, NULL, 'Sample\'s', 1, 500.00, 500.00, 0.00, 0.00),
(1002, 121, NULL, NULL, 'Digtal Card with Lemanation and Round Cutting', 110, 25.00, 2750.00, 0.00, 0.00),
(1003, 121, NULL, NULL, 'A4 Size Certificate Print', 27, 60.00, 1620.00, 0.00, 0.00),
(1004, 121, NULL, NULL, 'PVC card with Dori and Card Hoder', 21, 250.00, 5250.00, 0.00, 0.00),
(1005, 121, NULL, NULL, '4x6 Inch Card', 50, 40.00, 2000.00, 0.00, 0.00),
(1006, 121, NULL, NULL, 'A4 Size Lemanation', 26, 50.00, 1300.00, 0.00, 0.00),
(1007, 121, NULL, NULL, 'Sample\'s', 1, 500.00, 500.00, 0.00, 0.00),
(1008, 95, NULL, NULL, 'A4 Size Sticker Pritning', 60, 60.00, 3600.00, 0.00, 0.00),
(1036, 126, NULL, NULL, 'Book Printing With Title and Cutting and Ring Binding', 1, 2300.00, 2300.00, 0.00, 0.00),
(1037, 126, NULL, NULL, 'Report Card 2 Side Printing on Art Card With Careez', 150, 80.00, 12000.00, 0.00, 0.00),
(1038, 126, NULL, NULL, 'school batch with embroidery', 200, 100.00, 20000.00, 0.00, 0.00),
(1056, 128, NULL, NULL, 'Certifiacte Print', 300, 45.00, 13500.00, 0.00, 0.00),
(1057, 128, NULL, NULL, 'Art Paper Printing with Cutting', 25, 20.00, 500.00, 0.00, 0.00),
(1058, 90, NULL, NULL, 'Asfand Yar Visting', 1, 2000.00, 2000.00, 0.00, 0.00),
(1059, 90, NULL, NULL, 'Kashif Saleem Hr UV 2 Side', 1, 0.00, 0.00, 0.00, 0.00),
(1060, 90, NULL, NULL, 'Hiba Arooj Digtal Card', 250, 20.00, 5000.00, 0.00, 0.00),
(1061, 90, NULL, NULL, 'Color?Print A4 Size', 15, 30.00, 450.00, 0.00, 0.00),
(1065, 129, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 1, 2200.00, 2200.00, 0.00, 0.00),
(1079, 127, NULL, NULL, '9\'\'x6\'\',4.5\"x7\",4\"x2\",3\"x3\"and 6.5\"x 4\" Sticker with lamination L/S Rate', 1000, 22.00, 22000.00, 0.00, 0.00),
(1081, 125, NULL, NULL, 'Visting Card 350 Gsm UV Fornt and Back Side With Round Cutting', 3000, 3.80, 11400.00, 0.00, 0.00),
(1082, 123, NULL, NULL, 'Visting Card 350 Gsm UV Fornt and Back Side With Round Cutting', 1000, 4.50, 4500.00, 0.00, 0.00),
(1087, 59, NULL, NULL, '1.5x2 Feet Flex with Wooden Frame', 21, 470.00, 9870.00, 0.00, 0.00),
(1113, 132, NULL, NULL, 'Designing and Printing Standee with 4 Side Rings and Stand with 2x2 Flex', 1, 2500.00, 2500.00, 0.00, 0.00),
(1114, 91, NULL, NULL, 'Design and Setting Update 20-09-2025', 1, 1000.00, 1000.00, 0.00, 0.00),
(1115, 91, NULL, NULL, 'Prnting', 2, 600.00, 1200.00, 0.00, 0.00),
(1116, 91, NULL, NULL, 'Design and Setting Update 29-09-2025', 1, 1000.00, 1000.00, 0.00, 0.00),
(1117, 91, NULL, NULL, '10x15 Inch Art Paper Printing 4 Pages with Binding', 50, 300.00, 15000.00, 0.00, 0.00),
(1118, 91, NULL, NULL, 'Design and Setting Update 16-10-2025', 1, 1000.00, 1000.00, 0.00, 0.00),
(1188, 52, NULL, NULL, 'Sticker Printing and Designing', 38, 65.00, 2470.00, 0.00, 0.00),
(1203, 134, NULL, NULL, 'Tariq Garen Slip Printing with Auto Numbering', 12, 400.00, 4800.00, 0.00, 0.00),
(1204, 134, NULL, NULL, 'G Magnolia Park Slip Printing with Auto Numbering', 12, 400.00, 4800.00, 0.00, 0.00),
(1205, 143, NULL, NULL, 'Letter Head Design and Flex Prinitng 2x5 Feet', 1, 2000.00, 2000.00, 0.00, 0.00),
(1227, 145, NULL, NULL, 'A4 Size Print', 50, 30.00, 1500.00, 0.00, 0.00),
(1235, 147, NULL, NULL, 'E Stamps with print', 5, 2000.00, 10000.00, 0.00, 0.00),
(1236, 147, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 5, 200.00, 1000.00, 0.00, 0.00),
(1240, 148, NULL, NULL, 'Digtal A3 Color Print', 2, 100.00, 200.00, 0.00, 0.00),
(1241, 148, NULL, NULL, 'Digtal A3 Black and Whte Print', 78, 25.00, 1950.00, 0.00, 0.00),
(1242, 148, NULL, NULL, 'Binding A3 Side', 6, 100.00, 600.00, 0.00, 0.00),
(1249, 150, NULL, NULL, 'PTCL Pad Printig with Binding', 10, 500.00, 5000.00, 0.00, 0.00),
(1266, 144, NULL, NULL, 'A4 Size Sticker Pritning', 13, 60.00, 780.00, 0.00, 0.00),
(1267, 144, NULL, NULL, 'Setting', 1, 200.00, 200.00, 0.00, 0.00),
(1278, 154, NULL, NULL, 'E Stamp (Rs.1200) with Drafting', 3, 2000.00, 6000.00, 0.00, 0.00),
(1279, 154, NULL, NULL, 'E Stamp for Receipt with Drafting', 1, 1500.00, 1500.00, 0.00, 0.00),
(1280, 154, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 4, 200.00, 800.00, 0.00, 0.00),
(1303, 155, NULL, NULL, 'Black Print A4 Size', 80, 10.00, 800.00, 0.00, 0.00),
(1304, 155, NULL, NULL, 'Color Print A4 Size', 6, 30.00, 180.00, 0.00, 0.00),
(1305, 155, NULL, NULL, 'Sprater Page', 30, 40.00, 1200.00, 0.00, 0.00),
(1306, 155, NULL, NULL, 'Book Binding', 2, 1500.00, 3000.00, 0.00, 0.00),
(1363, 138, NULL, NULL, 'Ball Pen | Note Pad Wirh One Color Pririnting and Bag with Notepad and Pen Packing', 100, 300.00, 30000.00, 0.00, 0.00),
(1364, 138, NULL, NULL, 'Brochure Printing A3 Size Art paper 150 Gsm Front and Back Side', 470, 35.00, 16450.00, 0.00, 0.00),
(1365, 138, NULL, NULL, 'Card 350 Gsm UV Front and Back Side', 2000, 3.50, 7000.00, 0.00, 0.00),
(1369, 159, NULL, NULL, 'Mug China With Sublimation and Box', 10, 900.00, 9000.00, 0.00, 0.00),
(1370, 159, NULL, NULL, 'Employee Card with Dori and Card Holder', 10, 400.00, 4000.00, 0.00, 0.00),
(1371, 159, NULL, NULL, 'Reception Plate Silver', 1, 1500.00, 1500.00, 0.00, 0.00),
(1372, 159, NULL, NULL, 'Ceo Plate Golden', 1, 1500.00, 1500.00, 0.00, 0.00),
(1373, 159, NULL, NULL, 'Manager Plate Golden', 1, 1500.00, 1500.00, 0.00, 0.00),
(1378, 149, NULL, NULL, 'Letter Head 100 Gsm (IK Paper) With 4 Color Printing and Gum Binding', 1000, 11.00, 11000.00, 0.00, 0.00),
(1379, 149, NULL, NULL, 'Admission Form 100 Gsm (IK Paper) With 4 Color Printing and Gum Binding', 1000, 11.00, 11000.00, 0.00, 0.00),
(1380, 149, NULL, NULL, '350 Gsm UV Front and Back Card Round Cutting', 1000, 3.00, 3000.00, 0.00, 0.00),
(1381, 157, NULL, NULL, 'Union Council Profile Print', 10, 120.00, 1200.00, 0.00, 0.00),
(1382, 139, NULL, NULL, 'customized 12x18 frame with Printing and Fitting', 4, 1500.00, 6000.00, 0.00, 0.00),
(1383, 139, NULL, NULL, 'customized 6x6 frame with Printing and Fitting', 1, 500.00, 500.00, 0.00, 0.00),
(1384, 151, NULL, NULL, 'Denticare Card Printing fornt and Back Side', 100, 45.00, 4500.00, 0.00, 0.00),
(1400, 160, NULL, NULL, 'Standee with 4 Side Rings', 4, 800.00, 3200.00, 0.00, 0.00),
(1401, 160, NULL, NULL, 'Standee Design', 4, 1000.00, 4000.00, 0.00, 0.00),
(1438, 161, NULL, NULL, 'E Stamp (Rs.1200) Drafting Printing', 5, 2000.00, 10000.00, 0.00, 0.00),
(1439, 161, NULL, NULL, 'E Stamp Payment Receipt', 1, 1500.00, 1500.00, 0.00, 0.00),
(1440, 161, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 2, 200.00, 400.00, 0.00, 0.00),
(1447, 162, NULL, NULL, 'A4 Size Art Paper with Setting and Cutting', 26, 45.00, 1170.00, 0.00, 0.00),
(1448, 162, NULL, NULL, 'A5 Size Art Paper with Setting and Cutting', 36, 30.00, 1080.00, 0.00, 0.00),
(1458, 103, NULL, NULL, 'A5 Size Sticker Printing', 60, 50.00, 3000.00, 0.00, 0.00),
(1459, 103, NULL, NULL, 'A3 Print Color', 20, 100.00, 2000.00, 0.00, 0.00),
(1465, 164, NULL, NULL, 'A4 Printing Color', 50, 30.00, 1500.00, 0.00, 0.00),
(1466, 164, NULL, NULL, 'A3 Printing Color', 20, 60.00, 1200.00, 0.00, 0.00),
(1467, 164, NULL, NULL, 'Stamp', 1, 300.00, 300.00, 0.00, 0.00),
(1468, 131, NULL, NULL, 'E Stamp (Rs.100)', 7, 250.00, 1750.00, 0.00, 0.00),
(1469, 131, NULL, NULL, 'E Stamp (Rs.200)', 136, 350.00, 47600.00, 0.00, 0.00),
(1472, 165, NULL, NULL, 'A4 Size Sticker Pritning', 26, 60.00, 1560.00, 0.00, 0.00),
(1473, 165, NULL, NULL, 'Cutting', 1, 200.00, 200.00, 0.00, 0.00),
(1495, 153, NULL, NULL, 'E Sale Deed Translation', 3, 1500.00, 4500.00, 0.00, 0.00),
(1496, 153, NULL, NULL, 'Gift Deed Translation', 2, 1500.00, 3000.00, 0.00, 0.00),
(1497, 153, NULL, NULL, 'Rental Agreements Translation', 4, 1500.00, 6000.00, 0.00, 0.00),
(1498, 153, NULL, NULL, 'Marriage Certificate (Nikah Nama) Translation', 1, 1500.00, 1500.00, 0.00, 0.00),
(1499, 153, NULL, NULL, '5 Sets of each Translation Prints & Notarized', 160, 100.00, 16000.00, 0.00, 0.00),
(1500, 153, NULL, NULL, 'Sale Deed Translation', 1, 1500.00, 1500.00, 0.00, 0.00),
(1501, 153, NULL, NULL, 'notarized 11 Translations (35 pages)', 100, 35.00, 3500.00, 0.00, 0.00),
(1502, 166, NULL, NULL, 'E Stamp (Rs.100)', 4, 250.00, 1000.00, 0.00, 0.00),
(1503, 166, NULL, NULL, 'E Stamp (Rs.200)', 152, 350.00, 53200.00, 0.00, 0.00),
(1510, 169, NULL, NULL, 'Letter Head A4 Size 100 gsm Paper', 1000, 13.00, 13000.00, 0.00, 0.00),
(1511, 169, NULL, NULL, '700 Gsm UV Matt Card with Round Cutting And All Text and Logo UV Ground Matt', 1000, 7.00, 7000.00, 0.00, 0.00),
(1538, 170, NULL, NULL, 'Print As per', 32, 20.00, 640.00, 0.00, 0.00),
(1539, 170, NULL, NULL, 'Print', 20, 20.00, 400.00, 0.00, 0.00),
(1540, 170, NULL, NULL, 'Print', 110, 20.00, 2200.00, 0.00, 0.00),
(1550, 168, 12, NULL, 'Auto Stamp With Blue Ink', 4, 1500.00, 6000.00, 0.00, 0.00),
(1551, 167, NULL, NULL, 'Vinyl Sticker Width 990mm x2030mm Height with Printing', 1, 6000.00, 6000.00, 0.00, 0.00),
(1552, 167, NULL, NULL, 'Pasting on side Sunder Industrial estate', 1, 4000.00, 4000.00, 0.00, 0.00),
(1589, 141, NULL, NULL, 'Simple Flex W 3 ft x H 2.5 ft', 1, 840.00, 840.00, 0.00, 0.00),
(1590, 141, NULL, NULL, 'Sticker Flex W 1.5 ft x H 1 ft', 2, 240.00, 480.00, 0.00, 0.00),
(1591, 141, NULL, NULL, 'Simple Flex W 2.5 ft x H 3 ft', 21, 840.00, 17640.00, 0.00, 0.00),
(1592, 141, NULL, NULL, 'Simple Flex W 2.5 ft x H 2.5 ft', 2, 840.00, 1680.00, 0.00, 0.00),
(1593, 141, NULL, NULL, 'Sticker Flex W 1 ft x H 2 ft', 5, 240.00, 1200.00, 0.00, 0.00),
(1594, 141, NULL, NULL, 'Sticker Flex W 2 ft x H 1.5 ft', 1, 320.00, 320.00, 0.00, 0.00),
(1595, 141, NULL, NULL, 'Sticker Flex W 2.5 feet x H 3 feet', 3, 800.00, 2400.00, 0.00, 0.00),
(1676, 175, NULL, NULL, 'Power Emulsion Wall Pati Sticker with lamination Printing', 500, 29.00, 14500.00, 0.00, 0.00),
(1677, 175, NULL, NULL, 'Carbanless Books triplicate book 5.5x8.5 Inch With Black Printing And auto Numbering', 20, 600.00, 12000.00, 0.00, 0.00),
(1709, 176, NULL, NULL, 'Instructions of Air Shower A3 Size Digital Print with Hard Lamination', 4, 200.00, 800.00, 0.00, 0.00),
(1710, 176, NULL, NULL, 'A3 Size Digital Print', 48, 100.00, 4800.00, 0.00, 0.00),
(1711, 176, NULL, NULL, '14x18 L/S Transparent Acrylic Sheet 5mm with UV Printing and 4 Side Hole with Spacer', 17, 3800.00, 64600.00, 0.00, 0.00),
(1712, 176, NULL, NULL, 'Report Printing and Binding with Annex Color Page Use', 1, 6000.00, 6000.00, 0.00, 0.00),
(1713, 176, NULL, NULL, 'Pakistan Oxygen Print on Card Front and Back', 70, 20.00, 1400.00, 0.00, 0.00),
(1714, 176, NULL, NULL, 'Length 910mm width 610 mm Vinyl Printing and Pasting', 2, 3000.00, 6000.00, 0.00, 0.00),
(1715, 176, NULL, NULL, 'Length 1220 mm 605 mm Vinyl Printing and Pasting', 1, 4000.00, 4000.00, 0.00, 0.00),
(1716, 176, NULL, NULL, 'General Lyophilized A3 Size Digital Print with Hard Lamination', 2, 200.00, 400.00, 0.00, 0.00),
(1741, 177, NULL, NULL, 'Report Card 2 Side Printing on Art Card With Careez', 150, 80.00, 12000.00, 0.00, 0.00),
(1742, 173, NULL, NULL, 'Pen', 100, 110.00, 11000.00, 0.00, 0.00),
(1743, 173, NULL, NULL, 'Calender 2026 Printing 4 Page and front Steel Pati and Rig Binding print on art Card', 100, 470.00, 47000.00, 0.00, 0.00),
(1744, 173, NULL, NULL, 'Profile with Center Pin Binding 8 Pages and Cutting', 100, 400.00, 40000.00, 0.00, 0.00),
(1769, 178, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 4, 200.00, 800.00, 0.00, 0.00),
(1770, 178, NULL, NULL, 'E Stamp (Rs.1200) Drafting Printing', 5, 2000.00, 10000.00, 0.00, 0.00),
(1771, 178, NULL, NULL, 'E Stamp (Rs.300) Drafting Printing & Receipt', 2, 800.00, 1600.00, 0.00, 0.00),
(1814, 179, NULL, NULL, '2x5 Feet Standee with 4 Side Rings Aquaree', 2, 800.00, 1600.00, 0.00, 0.00),
(1815, 179, NULL, NULL, 'Steel Less Steel Metal Plates with Engraving', 3, 1800.00, 5400.00, 0.00, 0.00),
(1820, 180, NULL, NULL, 'Salee Deed, Rent Agreement Translation', 7, 1500.00, 10500.00, 0.00, 0.00),
(1821, 180, NULL, NULL, 'Notarized', 17, 50.00, 850.00, 0.00, 0.00),
(1859, 181, NULL, NULL, 'E Stamp (Rs.1200) with Delivery Mr. Majid', 1, 2300.00, 2300.00, 0.00, 0.00),
(1860, 181, NULL, NULL, 'E Stamp Abdul Moiz', 2, 700.00, 1400.00, 0.00, 0.00),
(1861, 181, NULL, NULL, 'E Stamp (Rs.300) Mr. Zeeshan', 1, 400.00, 400.00, 0.00, 0.00),
(1862, 181, NULL, NULL, 'E Stamp Saqib, Qadeer, Ilyas, Danish', 4, 2000.00, 8000.00, 0.00, 0.00),
(1863, 181, NULL, NULL, '2 Sets E Stamp Danish', 2, 2000.00, 4000.00, 0.00, 0.00),
(1870, 182, NULL, NULL, 'Balance Amount', 1, 2100.00, 2100.00, 0.00, 0.00),
(1871, 182, NULL, NULL, 'E stamp Zeeshan', 1, 2000.00, 2000.00, 0.00, 0.00),
(1872, 182, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 2, 200.00, 400.00, 0.00, 0.00),
(1873, 80, NULL, NULL, 'Covid and Polio Vaccine and Cards (Amir Sab) Old Balance', 1, 13000.00, 13000.00, 0.00, 0.00),
(1874, 80, NULL, NULL, 'Habib Engineering Stamps (Simple)', 2, 300.00, 600.00, 0.00, 0.00),
(1875, 80, NULL, NULL, 'Habib Engineering (Auto Stamps)', 3, 1500.00, 4500.00, 0.00, 0.00),
(1876, 80, NULL, NULL, '300/1 Stamp Paper with Print and Stamp', 1, 1000.00, 1000.00, 0.00, 0.00),
(1877, 80, NULL, NULL, 'Polo T-Shirt Navy Blue Color with Embroidery logo Fornt and Back Side', 100, 2050.00, 205000.00, 0.00, 0.00),
(1878, 80, NULL, NULL, 'Chaque photo copy on 100 Gsm paper and Scaning', 3, 100.00, 300.00, 0.00, 0.00),
(1879, 80, NULL, NULL, 'Old Stamp Paper with Print', 2, 500.00, 1000.00, 0.00, 0.00),
(1880, 80, NULL, NULL, 'Stamp EFU General', 1, 300.00, 300.00, 0.00, 0.00),
(1881, 80, NULL, NULL, 'PVC Employee Card with Design', 24, 400.00, 9600.00, 0.00, 0.00),
(1897, 183, NULL, NULL, 'Sticker Flex W 2.5ft x H 3ft with Pasting', 3, 1620.00, 4860.00, 0.00, 0.00),
(1898, 183, NULL, NULL, 'Sticker Flex W 3ft x H 1.5ft (File Name (1) with Pasting', 2, 1080.00, 2160.00, 0.00, 0.00),
(1899, 183, NULL, NULL, 'Sticker Flex W 3ft x H 1.5ft (File Name (2) with Pasting', 2, 1080.00, 2160.00, 0.00, 0.00),
(1900, 183, NULL, NULL, 'Sticker Flex W 3ft x H 1.5ft (File Name (3) with Pasting', 5, 1080.00, 5400.00, 0.00, 0.00),
(1901, 183, NULL, NULL, 'Sticker Flex W 3ft x H 1.5ft (File Name (4) with Pasting', 2, 1080.00, 2160.00, 0.00, 0.00),
(1925, 185, NULL, NULL, 'E Stamp (Rs.100)', 13, 250.00, 3250.00, 0.00, 0.00),
(1926, 185, NULL, NULL, 'E Stamp (Rs.200)', 143, 350.00, 50050.00, 0.00, 0.00),
(1927, 185, NULL, NULL, 'E Stamp (Rs.300)', 1, 450.00, 450.00, 0.00, 0.00),
(1932, 186, NULL, NULL, '9\'\'x6\'\',4.5\"x7\",4\"x2\",3\"x3\"and 6.5\"x 4\" Sticker with lamination L/S Rate', 1000, 22.00, 22000.00, 0.00, 0.00),
(1933, 88, NULL, NULL, 'Parking Slips with Auto Numbering', 4000, 72.04, 288160.00, 0.00, 0.00),
(2009, 187, NULL, NULL, 'Glass shields With Printing and Box', 5, 3500.00, 17500.00, 0.00, 0.00),
(2011, 188, NULL, NULL, '3\'x 5\' Flex Printing with 4 Side Rings', 4, 1200.00, 4800.00, 0.00, 0.00),
(2012, 188, NULL, NULL, '4\'x 7\' Flex Printing with 4 Side Rings', 2, 2240.00, 4480.00, 0.00, 0.00),
(2055, 189, NULL, NULL, 'Submission of Design Drwgs - EFMR - TDS', 1, 30.00, 30.00, 0.00, 0.00),
(2056, 189, NULL, NULL, 'EFMR Final 8-01-2026', 47, 30.00, 1410.00, 0.00, 0.00),
(2057, 189, NULL, NULL, 'Binding A4 Size', 1, 100.00, 100.00, 0.00, 0.00),
(2058, 189, NULL, NULL, 'A3 Size Drawing Color', 8, 50.00, 400.00, 0.00, 0.00),
(2059, 189, NULL, NULL, 'A3 Size Drawing B/W', 140, 30.00, 4200.00, 0.00, 0.00),
(2060, 189, NULL, NULL, '3 TDS Color Print', 9, 30.00, 270.00, 0.00, 0.00),
(2061, 189, NULL, NULL, '3 TDS Color B/W and Submission Page', 28, 20.00, 560.00, 0.00, 0.00),
(2065, 190, NULL, NULL, 'Car Sale Agreement Rashid Sb', 1, 700.00, 700.00, 0.00, 0.00),
(2066, 190, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 3, 200.00, 600.00, 0.00, 0.00),
(2067, 190, NULL, NULL, 'E Stamps (Rs.1200) Asghar Ali, Mustansar and Ejaz Ali', 3, 2000.00, 6000.00, 0.00, 0.00),
(2068, 191, NULL, NULL, 'Binding', 12, 50.00, 600.00, 0.00, 0.00),
(2069, 191, NULL, NULL, 'Print B/W', 1160, 2.00, 2320.00, 0.00, 0.00),
(2070, 191, NULL, NULL, 'Sheet', 180, 2.00, 360.00, 0.00, 0.00),
(2071, 191, NULL, NULL, 'Color Print', 12, 9.00, 108.00, 0.00, 0.00),
(2262, 198, NULL, NULL, 'Premium Table Calendar with Laminated Box Size: 7\" x 9.5\" Material: 300 GSM Premium Card Binding: Twin-loop Wiro Binding Packaging: Custom Printed & Laminated Outer Box with Design', 500, 500.00, 250000.00, 0.00, 0.00),
(2265, 199, NULL, NULL, 'E Stamp (Rs.100)', 7, 250.00, 1750.00, 0.00, 0.00),
(2266, 199, NULL, NULL, 'E Stamp (Rs.300)', 124, 350.00, 43400.00, 0.00, 0.00),
(2287, 193, NULL, NULL, 'Temporary Employment offer as a Communicty Health Inspector 16-12-2025', 1000, 25.00, 25000.00, 0.00, 0.00),
(2288, 193, NULL, NULL, 'Standee Design and Printing with 4 Side Holes with Stand 16-12-2025', 3, 2000.00, 6000.00, 0.00, 0.00),
(2289, 194, NULL, NULL, 'Employe Card Jecket and Dori 3 Jan 2025', 300, 115.00, 34500.00, 0.00, 0.00),
(2290, 194, NULL, NULL, 'PVC Employe Card Jecket and Dori 3 Jan 2025', 50, 210.00, 10500.00, 0.00, 0.00),
(2293, 196, NULL, NULL, 'Training Material 1st Batch and Presentations Printing 06 Dec 2025', 2792, 7.50, 20940.00, 0.00, 0.00),
(2295, 200, NULL, NULL, 'Contract Printing Each Set 10 Pages (500 set) with Striple Pin 29 Dec 2025', 500, 75.00, 37500.00, 0.00, 0.00),
(2296, 195, NULL, NULL, 'Contract Printing Each Set 10 Pages 500+500 Sets  with Striple Pin 8 Jan 2025', 500, 75.00, 37500.00, 0.00, 0.00),
(2297, 201, NULL, NULL, 'Certificate Design', 2, 500.00, 1000.00, 0.00, 0.00),
(2298, 201, NULL, NULL, 'Certificate Ptrint', 40, 70.00, 2800.00, 0.00, 0.00),
(2299, 201, NULL, NULL, 'Acrylic Sheet with Printing', 1, 4000.00, 4000.00, 0.00, 0.00),
(2335, 204, NULL, NULL, 'agreement draft Haris Sb', 1, 500.00, 500.00, 0.00, 0.00),
(2336, 204, NULL, NULL, 'E Stamp (Rs.1200) with Drafting Mr. Shafiq Cheema', 1, 2000.00, 2000.00, 0.00, 0.00),
(2337, 174, NULL, NULL, 'Simple Flex W 3 ft x H 2.5 ft', 1, 840.00, 840.00, 0.00, 0.00),
(2338, 174, NULL, NULL, 'Sticker Flex W 1.5 ft x H 1 ft', 2, 240.00, 480.00, 0.00, 0.00),
(2339, 174, NULL, NULL, 'Simple Flex W 2.5 ft x H 3 ft', 21, 840.00, 17640.00, 0.00, 0.00),
(2340, 174, NULL, NULL, 'Simple Flex W 2.5 ft x H 2.5 ft', 2, 840.00, 1680.00, 0.00, 0.00),
(2341, 174, NULL, NULL, 'Sticker Flex W 1 ft x H 2 ft', 5, 240.00, 1200.00, 0.00, 0.00),
(2342, 174, NULL, NULL, 'Sticker Flex W 2 ft x H 1.5 ft', 1, 320.00, 320.00, 0.00, 0.00),
(2343, 174, NULL, NULL, 'Sticker Flex W 2.5 feet x H 3 feet', 3, 800.00, 2400.00, 0.00, 0.00),
(2344, 133, NULL, NULL, '1.5x2 Feet Flex with Wooden Frame', 35, 470.00, 16450.00, 0.00, 0.00),
(2382, 208, NULL, NULL, 'E Stamps (Rs.1200) Mr. Zakir, Mr. Khalid, Mrs. Shaughfta', 3, 2000.00, 6000.00, 0.00, 0.00),
(2383, 208, NULL, NULL, 'E Stamps with draft of Receipt for Mr. Abdul Moiz, Bilal Asghar', 2, 1400.00, 2800.00, 0.00, 0.00),
(2529, 216, NULL, NULL, '100 Gsm Letter Head with Gum Binding and 4 Color Prinitng', 1000, 20.00, 20000.00, 0.00, 0.00),
(2546, 217, NULL, NULL, 'Art Paper Front and Back Side Printing with Center Carze and Cutting', 50, 50.00, 2500.00, 0.00, 0.00),
(2547, 217, NULL, NULL, 'YDF Profile Printing', 1, 280.00, 280.00, 0.00, 0.00),
(2548, 217, NULL, NULL, 'A4 Size Color Dital Printing', 19, 25.00, 475.00, 0.00, 0.00),
(2549, 217, NULL, NULL, 'Digital Card Printing 91x57 mm', 50, 30.00, 1500.00, 0.00, 0.00),
(2550, 217, NULL, NULL, 'Design 2 side Card', 1, 500.00, 500.00, 0.00, 0.00),
(2556, 218, NULL, NULL, 'Employe Card', 29, 450.00, 13050.00, 0.00, 0.00),
(2557, 218, NULL, NULL, 'Visting Cards', 1000, 4.50, 4500.00, 0.00, 0.00),
(2558, 218, NULL, NULL, 'Caps', 100, 680.00, 68000.00, 0.00, 0.00),
(2559, 218, NULL, NULL, 'Stamp 841', 3, 1000.00, 3000.00, 0.00, 0.00),
(2560, 218, NULL, NULL, '12x8 Steel les Steel Paltes', 5, 1800.00, 9000.00, 0.00, 0.00),
(2575, 205, NULL, NULL, '3\'x 5\' Flex Printing', 4, 1200.00, 4800.00, 0.00, 0.00),
(2576, 205, NULL, NULL, 'Office Plate with Printing and Pasting Size 6x12 Inch', 8, 1400.00, 11200.00, 0.00, 0.00),
(2590, 221, NULL, NULL, 'Stamp Paper', 100, 160.00, 16000.00, 0.00, 0.00),
(2591, 221, NULL, NULL, 'A3 Size Print Color', 24, 200.00, 4800.00, 0.00, 0.00),
(2592, 221, NULL, NULL, '14x18 L/S Transparent Acrylic Sheet 5mm with UV Printing and 4 Side Hole with Spacer', 4, 3800.00, 15200.00, 0.00, 0.00),
(2593, 221, NULL, NULL, 'A3 Size Print Color', 32, 200.00, 6400.00, 0.00, 0.00),
(2594, 221, NULL, NULL, 'a3 size paper lamination sheets', 4, 200.00, 800.00, 0.00, 0.00),
(2595, 222, NULL, NULL, 'Certifiacte Print Art Card 300 Gsm', 33, 70.00, 2310.00, 0.00, 0.00),
(2604, 224, NULL, NULL, 'E Stamp (Rs.100)', 15, 250.00, 3750.00, 0.00, 0.00),
(2605, 224, NULL, NULL, 'E Stamp (Rs.200)', 110, 350.00, 38500.00, 0.00, 0.00),
(2606, 224, NULL, NULL, 'E Stamp (Rs.1200)', 1, 1600.00, 1600.00, 0.00, 0.00),
(2624, 220, NULL, NULL, '4x4\' Flex Printing', 1, 1280.00, 1280.00, 0.00, 0.00),
(2625, 220, NULL, NULL, 'Brochure Size A5 Art Paper 128 Gsm Single Side Printing', 150, 35.00, 5250.00, 0.00, 0.00),
(2626, 220, NULL, NULL, '1 Standee with Panda Stand', 1, 470.00, 470.00, 0.00, 0.00),
(2627, 203, NULL, NULL, 'Customized Diary Printing with UV Small', 20, 500.00, 10000.00, 0.00, 0.00),
(2628, 203, NULL, NULL, 'Customized Pen Printing with UV', 50, 175.00, 8750.00, 0.00, 0.00),
(2629, 203, NULL, NULL, 'Customized Bags Printing with Screen Printing', 100, 50.00, 5000.00, 0.00, 0.00),
(2630, 203, NULL, NULL, 'Digital Card Printing fornt and back side', 400, 16.00, 6400.00, 0.00, 0.00),
(2631, 203, NULL, NULL, 'Customized Diary Printing with UV 8x5 Inch', 10, 800.00, 8000.00, 0.00, 0.00),
(2649, 227, NULL, NULL, 'Old Stamp Paper 100/3 and 200/3 L/S Rate (Amir Sab)', 6, 500.00, 3000.00, 0.00, 0.00),
(2650, 227, NULL, NULL, 'PVC Employee Cards', 12, 350.00, 4200.00, 0.00, 0.00),
(2651, 227, NULL, NULL, 'Stamp', 1, 1000.00, 1000.00, 0.00, 0.00),
(2662, 230, NULL, NULL, 'EMPLOYMENT AGREEMENT', 2, 900.00, 1800.00, 0.00, 0.00),
(2663, 230, NULL, NULL, 'EQUIPMENT HANDOVER AGREEMENT', 1, 800.00, 800.00, 0.00, 0.00),
(2664, 230, NULL, NULL, 'Extra Sheets', 19, 70.00, 1330.00, 0.00, 0.00),
(2670, 233, NULL, NULL, 'Visting Card 350 Gsm UV SIngle Side With Round Cutting', 1, 4000.00, 4000.00, 0.00, 0.00),
(2671, 228, NULL, NULL, 'Visting Card 700 Gsm UV Fornt and Back Side With Round Cutting', 1000, 7.50, 7500.00, 0.00, 0.00),
(2672, 228, NULL, NULL, 'Plate Steel Less Steel with Red and Black Color 8x12 Inch', 1, 2000.00, 2000.00, 0.00, 0.00),
(2673, 228, NULL, NULL, 'Letter Head Design A4 Size', 1, 500.00, 500.00, 0.00, 0.00),
(2674, 228, NULL, NULL, 'Letter Head Printing A4 Size', 50, 30.00, 1500.00, 0.00, 0.00),
(2675, 228, NULL, NULL, 'Letter Head Printing A4 Size Careem Color Paper', 10, 40.00, 400.00, 0.00, 0.00),
(2699, 235, NULL, NULL, 'Certifiacte Print Art Card', 7, 80.00, 560.00, 0.00, 0.00),
(2708, 231, NULL, NULL, 'Certifiacte Print Art Card', 7, 80.00, 560.00, 0.00, 0.00),
(2709, 229, NULL, NULL, 'Sticker Printing 2x2 Inch With Cutting', 600, 10.00, 6000.00, 0.00, 0.00),
(2710, 229, NULL, NULL, 'Sticker Printing 2x2 Inch With Cutting', 40, 10.00, 400.00, 0.00, 0.00),
(2711, 229, NULL, NULL, 'Designing', 1, 500.00, 500.00, 0.00, 0.00),
(2712, 226, NULL, NULL, 'Visting Card 350 Gsm UV Fornt and Back Side With Round Cutting', 1000, 4.50, 4500.00, 0.00, 0.00),
(2713, 223, NULL, NULL, 'Star flex standee with Panda Stand and Designing', 1, 2500.00, 2500.00, 0.00, 0.00),
(2714, 223, NULL, NULL, '4x8 Feet High-Density Flex printing. Includes fabrication of a custom Iron Frame (4ft x 8ft) with heavy-duty square piping, professional stretching, and secure fitting/mounting of the flex onto the frame.', 1, 12800.00, 12800.00, 0.00, 0.00),
(2715, 219, NULL, NULL, 'Letter Head Design A4 Size', 1, 300.00, 300.00, 0.00, 0.00),
(2716, 219, NULL, NULL, 'Letter Head Printing A4 Size 80 Gsm Paper', 20, 25.00, 500.00, 0.00, 0.00),
(2717, 219, NULL, NULL, 'Auto Stamp with Blue ink Pad', 1, 1200.00, 1200.00, 0.00, 0.00),
(2718, 219, NULL, NULL, 'Carbanless Books 1+1 8.5x5.5 Inch With Black Printing And auto Numbering', 10, 600.00, 6000.00, 0.00, 0.00),
(2719, 212, NULL, NULL, 'The Journal of Allama Iqbal Medical College Matt Paper 128 Gsm Front and Back Side Printing', 1, 10500.00, 10500.00, 0.00, 0.00),
(2720, 202, NULL, NULL, 'Stamp Paper', 100, 160.00, 16000.00, 0.00, 0.00),
(2721, 202, NULL, NULL, 'A3 Size Print Color', 24, 200.00, 4800.00, 0.00, 0.00),
(2722, 202, NULL, NULL, '14x18 L/S Transparent Acrylic Sheet 5mm with UV Printing and 4 Side Hole with Spacer', 4, 3800.00, 15200.00, 0.00, 0.00),
(2723, 202, NULL, NULL, 'A3 Size Print Color', 32, 200.00, 6400.00, 0.00, 0.00),
(2724, 202, NULL, NULL, 'a3 size paper lamination sheets', 4, 200.00, 800.00, 0.00, 0.00),
(2725, 234, NULL, NULL, 'Color Printing', 660, 8.00, 5280.00, 0.00, 0.00),
(2726, 234, NULL, NULL, 'Book Printing Color Print (31 Each and 50 Set)', 50, 330.00, 16500.00, 0.00, 0.00),
(2728, 232, NULL, NULL, 'custom shields with Box', 3, 2200.00, 6600.00, 0.00, 0.00),
(2729, 171, NULL, NULL, 'Costomed Box 6x8x4 with Pritnting and Dyi and Box Making', 60, 650.00, 39000.00, 0.00, 0.00),
(2730, 171, NULL, NULL, 'Costomed popcorn boxes 6x4x4', 60, 400.00, 24000.00, 0.00, 0.00),
(2731, 171, NULL, NULL, 'Sticker 2x2 Inch Round', 200, 12.00, 2400.00, 0.00, 0.00),
(2736, 238, NULL, NULL, 'Digtal Color Printig', 160, 20.00, 3200.00, 0.00, 0.00),
(2737, 238, NULL, NULL, 'Binding Sprial Binding', 1, 300.00, 300.00, 0.00, 0.00),
(2770, 239, NULL, NULL, 'Carbanless Books 1+1+1 8x3.75 Inch With Black Printing And auto Numbering', 50, 420.00, 21000.00, 0.00, 0.00),
(2773, 243, NULL, NULL, 'Certifiacte Print Texture Card 300 Gsm', 60, 55.00, 3300.00, 0.00, 0.00),
(2777, 192, NULL, NULL, 'Interview Form A4 SIze B/W Printing (3 Pages 200 Set) 20-12-2025', 600, 7.50, 4500.00, 0.00, 0.00),
(2778, 192, NULL, NULL, 'Self-Declaration A4 SIze B/W Printing 20-12-2025', 200, 7.50, 1500.00, 0.00, 0.00),
(2779, 192, NULL, NULL, 'EMPLOYEE BIOGRAPHICAL DATA SHEET A4 SIze B/W Printing 20-12-2025', 200, 7.50, 1500.00, 0.00, 0.00),
(2780, 192, NULL, NULL, 'CV Print 20-12-2025', 562, 7.50, 4215.00, 0.00, 0.00),
(2781, 192, NULL, NULL, 'Interview Form A4 SIze B/W Printing Complate Print 20-12-2025', 500, 7.50, 3750.00, 0.00, 0.00),
(2782, 192, NULL, NULL, 'Interview Form (Double Side) 16-12-2025', 1000, 7.50, 7500.00, 0.00, 0.00),
(2783, 192, NULL, NULL, 'Offer Letter 16-12-2025', 500, 7.50, 3750.00, 0.00, 0.00),
(2784, 192, NULL, NULL, '7- Self Declaration Form 16-12-2025', 500, 7.50, 3750.00, 0.00, 0.00),
(2785, 192, NULL, NULL, 'Goods Received Note 16-12-2025', 1000, 7.50, 7500.00, 0.00, 0.00),
(2786, 192, NULL, NULL, 'Employee Biographical Data Sheet (Double Side) 16-12-2025', 1000, 7.50, 7500.00, 0.00, 0.00),
(2790, 246, NULL, NULL, 'E Stamp Muhammad Ashraf ETC', 1, 2000.00, 2000.00, 0.00, 0.00),
(2791, 246, NULL, NULL, 'E Stamp Receipt Majid Khan', 1, 1000.00, 1000.00, 0.00, 0.00),
(2792, 246, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 2, 200.00, 400.00, 0.00, 0.00),
(2794, 247, NULL, NULL, 'Car Sale Agreement', 1, 1000.00, 1000.00, 0.00, 0.00),
(2799, 11, NULL, NULL, 'Carbanless Books 1+1 7x4 Inch With Black Printing And auto Numbering', 10, 600.00, 6000.00, 0.00, 0.00),
(2800, 11, NULL, NULL, 'Carbanless Books 1+1+1 10x7 Inch With Black Printing And auto Numbering', 10, 900.00, 9000.00, 0.00, 0.00),
(2809, 248, NULL, NULL, 'Carbanless Books 1+1 7x4 Inch With Black Printing And auto Numbering', 10, 600.00, 6000.00, 0.00, 0.00),
(2810, 248, NULL, NULL, 'Carbanless Books 1+1+1 10x7 Inch With Black Printing And auto Numbering', 10, 900.00, 9000.00, 0.00, 0.00),
(2816, 250, NULL, NULL, 'Agreement Maria', 1, 1400.00, 1400.00, 0.00, 0.00),
(2817, 250, NULL, NULL, 'Agreement Asghar Ali', 1, 1400.00, 1400.00, 0.00, 0.00),
(2818, 250, NULL, NULL, 'E Stamp Ahmed Sb & Copies', 1, 300.00, 300.00, 0.00, 0.00),
(2819, 251, NULL, NULL, 'Letterhead Printing', 100, 10.00, 1000.00, 18.00, 180.00),
(2820, 251, 13, NULL, 'Flyer Printing in Pakistan | Promotional Leaflets & Handouts', 150, 10.00, 1500.00, 18.00, 270.00),
(2835, 254, NULL, NULL, 'A1 Size Color Printing', 18, 300.00, 5400.00, 0.00, 0.00),
(2836, 254, NULL, NULL, 'A2 Size Color Printing', 7, 200.00, 1400.00, 0.00, 0.00),
(2837, 254, NULL, NULL, 'A3 Size Color Printing', 17, 60.00, 1020.00, 0.00, 0.00),
(2838, 254, NULL, NULL, 'A4 Size Digital Color Print', 48, 20.00, 960.00, 0.00, 0.00),
(2839, 254, NULL, NULL, 'Spiral Binding A4 Size', 1, 150.00, 150.00, 0.00, 0.00),
(2870, 256, NULL, NULL, 'A1 Size Color Printing', 1, 300.00, 300.00, 0.00, 0.00),
(2871, 256, NULL, NULL, 'A4 Size Digital Color Print', 20, 20.00, 400.00, 0.00, 0.00),
(2872, 256, NULL, NULL, 'Spiral Binding A4 Size', 4, 150.00, 600.00, 0.00, 0.00),
(2880, 258, NULL, NULL, 'PTCL Pad Printig with Binding with Gum Binding', 1000, 5.50, 5500.00, 0.00, 0.00),
(2881, 258, NULL, NULL, 'Letter Head with Fornt and Back Side Printing and Gum Binding', 1000, 17.00, 17000.00, 0.00, 0.00),
(2882, 258, NULL, NULL, 'Careem Color Card Printing Front and Back side', 100, 70.00, 7000.00, 0.00, 0.00),
(2895, 257, NULL, NULL, 'E Stamp Agreement Ghulam Shabbir', 1, 2000.00, 2000.00, 0.00, 0.00),
(2896, 257, NULL, NULL, 'E Stamp Ahmad Sb', 1, 200.00, 200.00, 0.00, 0.00),
(2897, 257, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 3, 200.00, 600.00, 0.00, 0.00),
(2898, 259, NULL, NULL, 'Auto Stamp with Blue Ink', 3, 1500.00, 4500.00, 0.00, 0.00),
(2904, 261, 26, NULL, 'Sticker Printing', 1, 400.00, 400.00, 0.00, 0.00),
(2905, 262, NULL, NULL, 'E Stamp (Rs.100)', 6, 250.00, 1500.00, 0.00, 0.00),
(2906, 262, NULL, NULL, 'E Stamp (Rs.200)', 130, 350.00, 45500.00, 0.00, 0.00),
(2907, 262, NULL, NULL, 'E Stamp (Rs.300)', 3, 450.00, 1350.00, 0.00, 0.00),
(2918, 263, NULL, NULL, '2x5 Feet Standee with 4 Side Rings with Panda Stand', 3, 2000.00, 6000.00, 0.00, 0.00),
(2919, 263, NULL, NULL, 'Letter Head 150 Gsm Papar', 15, 50.00, 750.00, 0.00, 0.00),
(2920, 263, NULL, NULL, 'Design and Setting Letter Head and Standee', 1, 500.00, 500.00, 0.00, 0.00),
(2921, 264, NULL, NULL, 'RVM Machine Printing and Passting and Designing Pasting on sundar industrial estate Site', 1, 30000.00, 30000.00, 0.00, 0.00),
(2922, 264, NULL, NULL, '9 Side and one fornt size Booth design Vinyl Printing and Pasting on sundar industrial estate Site', 1, 42000.00, 42000.00, 0.00, 0.00),
(2923, 264, NULL, NULL, 'Board Delivery Rent', 1, 4500.00, 4500.00, 0.00, 0.00),
(2926, 265, NULL, NULL, 'Carbanless Books 1+1 7x4 Inch With Black Printing And auto Numbering', 10, 600.00, 6000.00, 0.00, 0.00),
(2927, 265, NULL, NULL, 'PVC Employee Card Printing', 9, 200.00, 1800.00, 0.00, 0.00),
(2936, 268, NULL, NULL, 'E Stamp value Rs.30,000 & Service Charges', 1, 33000.00, 33000.00, 0.00, 0.00),
(2938, 270, 12, NULL, 'Brochure Printing', 500, 100.00, 50000.00, 0.00, 0.00),
(2940, 272, NULL, NULL, 'Visting Card 700 Gsm UV Fornt and Back Side With Round Cutting', 1000, 7.50, 7500.00, 0.00, 0.00),
(2941, 272, NULL, NULL, 'Plate Steel Less Steel with Red and Black Color 8x12 Inch', 1, 2000.00, 2000.00, 0.00, 0.00),
(2942, 272, NULL, NULL, 'Letter Head Design A4 Size', 1, 500.00, 500.00, 0.00, 0.00),
(2943, 272, NULL, NULL, 'Letter Head Printing A4 Size', 50, 30.00, 1500.00, 0.00, 0.00),
(2944, 272, NULL, NULL, 'Letter Head Printing A4 Size Careem Color Paper', 10, 40.00, 400.00, 0.00, 0.00),
(2948, 273, NULL, NULL, 'E Stamp Agreement Mubeen Ahmad', 1, 2000.00, 2000.00, 0.00, 0.00),
(2966, 60, NULL, NULL, 'Employe Card', 29, 450.00, 13050.00, 0.00, 0.00),
(2967, 60, NULL, NULL, 'Visting Cards', 1000, 4.50, 4500.00, 0.00, 0.00),
(2968, 60, NULL, NULL, 'Caps', 100, 680.00, 68000.00, 0.00, 0.00),
(2969, 60, NULL, NULL, 'Stamp 841', 3, 1000.00, 3000.00, 0.00, 0.00),
(2970, 60, NULL, NULL, '12x8 Steel les Steel Paltes', 5, 1800.00, 9000.00, 0.00, 0.00),
(2971, 60, NULL, NULL, 'Stamp 741', 1, 1200.00, 1200.00, 0.00, 0.00),
(2973, 89, NULL, NULL, 'Design & Printing of Annual Report (70?75 Pages) ? Report title art card 300 gram with shine lamination ? 4 color printing ? Inner pages: 4 color printing on art paper 128 gram ? Gum binding', 100, 1700.00, 170000.00, 18.00, 30600.00),
(2988, 94, NULL, NULL, 'Stylers-Pink-October-Standee-2x5', 1, 800.00, 800.00, 18.00, 144.00),
(2989, 94, NULL, NULL, 'Finance for Non Finance Managers 2x5 Feet Standee with 4 Side Rings', 1, 800.00, 800.00, 18.00, 144.00),
(2990, 94, NULL, NULL, 'Rider', 1, 700.00, 700.00, 18.00, 126.00),
(2991, 94, NULL, NULL, '2x5 Feet Standee with 4 Side Industrial & Commercial Employment', 1, 800.00, 800.00, 18.00, 144.00),
(2992, 94, NULL, NULL, 'EPA Baord 3x3 Feet', 1, 1020.00, 1020.00, 18.00, 183.60),
(2993, 94, NULL, NULL, 'Book Printing With Title on Art Card and Spiral Binding 100 Gsm', 1, 870.00, 870.00, 18.00, 156.60),
(2994, 94, NULL, NULL, 'Book Printing With Title on Art Card and Spiral Binding 128 Gsm', 6, 1255.00, 7530.00, 18.00, 1355.40),
(2999, 245, NULL, NULL, '2x5 Feet Standee with 4 Side Rings Aquaree', 2, 800.00, 1600.00, 18.00, 288.00),
(3000, 245, NULL, NULL, 'Steel Less Steel Metal Plates with Engraving', 3, 1800.00, 5400.00, 18.00, 972.00),
(3015, 277, NULL, NULL, '2x5 Feet Standee with 4 Side Rings with Panda Stand', 3, 2000.00, 6000.00, 0.00, 0.00),
(3016, 277, NULL, NULL, 'Letter Head 150 Gsm Papar', 15, 50.00, 750.00, 0.00, 0.00),
(3017, 277, NULL, NULL, 'Design and Setting Letter Head and Standee', 1, 500.00, 500.00, 0.00, 0.00),
(3039, 278, NULL, NULL, '2x5 Feet Standee with 4 Side Rings', 2, 1000.00, 2000.00, 0.00, 0.00),
(3040, 278, NULL, NULL, 'Letter Head 150 Gsm Papar', 10, 50.00, 500.00, 0.00, 0.00),
(3041, 278, NULL, NULL, 'Auto Stamp', 2, 1500.00, 3000.00, 0.00, 0.00),
(3042, 266, NULL, NULL, 'e-Stamp Papers', 65, 180.00, 11700.00, 0.00, 0.00),
(3043, 266, NULL, NULL, 'A3 Printing', 2, 200.00, 400.00, 0.00, 0.00),
(3100, 267, NULL, NULL, 'Art Card 300 Gsm with Fornt Side Black Printing', 2000, 3.50, 7000.00, 0.00, 0.00),
(3136, 280, NULL, NULL, 'Stylers-Pink-October-Standee-2x5', 2, 800.00, 1600.00, 18.00, 288.00),
(3137, 280, NULL, NULL, 'Driving Sustainable Mobility Backdrop 10x10 feet', 1, 8000.00, 8000.00, 18.00, 1440.00),
(3138, 280, NULL, NULL, '24x58 Inch key with acrylic sheets  with vinyl printing and pasting', 1, 15000.00, 15000.00, 18.00, 2700.00),
(3139, 280, NULL, NULL, 'Ride', 1, 650.00, 650.00, 18.00, 117.00),
(3182, 20, NULL, NULL, 'Tariq Garen Slip Priitng with Auto Numbering', 12, 400.00, 4800.00, 0.00, 0.00),
(3183, 20, NULL, NULL, 'Main Flex For wall 8x5 Feet', 1, 2400.00, 2400.00, 0.00, 0.00),
(3184, 20, NULL, NULL, 'Main Flex For Table 8x2.5 Feet', 1, 1440.00, 1440.00, 0.00, 0.00),
(3185, 20, NULL, NULL, '2 standard size standees 2x5 Feet with Panda Stand', 2, 2000.00, 4000.00, 0.00, 0.00),
(3186, 20, NULL, NULL, 'A5 Size Digital Colour?Prints Art Paper Poster', 400, 20.00, 8000.00, 0.00, 0.00),
(3187, 20, NULL, NULL, 'Star Standee With Panda Stand', 2, 2000.00, 4000.00, 0.00, 0.00),
(3188, 20, NULL, NULL, 'standees 2x5 Feet with Panda Stand Flood Relief Camp', 4, 2000.00, 8000.00, 0.00, 0.00),
(3189, 20, NULL, NULL, '10x8 Feet for Back Drop Flood Relief Camp', 1, 4800.00, 4800.00, 0.00, 0.00),
(3190, 20, NULL, NULL, '36x18 inch cheque printing with pasting with Hard Sheet', 1, 5000.00, 5000.00, 0.00, 0.00),
(3191, 20, NULL, NULL, 'Certificates print', 12, 80.00, 960.00, 0.00, 0.00),
(3192, 20, NULL, NULL, 'Auto Stamp With Blue Ink', 1, 1500.00, 1500.00, 0.00, 0.00),
(3193, 20, NULL, NULL, 'Logo Sticker Printing', 3, 700.00, 2100.00, 0.00, 0.00),
(3194, 20, NULL, NULL, 'Remove the vinyl, clean the surface thoroughly, and then neatly glue it back into place, ensuring all four sides are pasted down securely using the Roland printing and pasting method', 4, 22000.00, 88000.00, 0.00, 0.00),
(3195, 20, NULL, NULL, 'Acrylic Sheet with Plotter Cutting and Panel Frame and Round Holes WIth Cap and Bottle', 4, 1900.00, 7600.00, 0.00, 0.00),
(3196, 20, NULL, NULL, 'vinyl White Sticker 4.5x1 Feet', 1, 675.00, 675.00, 0.00, 0.00),
(3197, 20, NULL, NULL, 'INVOICE #: INV-20251120-065659 Flex 5x5 Feet', 1, 4000.00, 4000.00, 0.00, 0.00),
(3198, 20, NULL, NULL, 'INV-20251111-093856 UNPAID Star flex standee with Panda Stand', 1, 8000.00, 8000.00, 0.00, 0.00),
(3199, 20, NULL, NULL, 'INV-20251106-161724 A4 Size Digital Certificate Printing', 1, 3500.00, 3500.00, 0.00, 0.00),
(3200, 20, NULL, NULL, 'INV-20251103-062048', 1, 9600.00, 9600.00, 0.00, 0.00),
(3201, 20, NULL, NULL, 'Tariq Garen Slip Priitng with Auto Numbering', 21, 400.00, 8400.00, 0.00, 0.00),
(3202, 20, NULL, NULL, 'G Magnolia Park Slips', 12, 400.00, 4800.00, 0.00, 0.00),
(3203, 279, NULL, NULL, 'Flex 8x8 Feet and Wooden Frame', 1, 12000.00, 12000.00, 0.00, 0.00),
(3204, 279, NULL, NULL, '5x5 Wood Just Frame', 2, 600.00, 1200.00, 0.00, 0.00),
(3205, 279, NULL, NULL, '5x3 Feet Wood Just Frame', 4, 600.00, 2400.00, 0.00, 0.00),
(3206, 279, NULL, NULL, '2x4.10 Flex', 4, 1000.00, 4000.00, 0.00, 0.00),
(3207, 279, NULL, NULL, 'Flex 6x4 Feet with Frame', 2, 3000.00, 6000.00, 0.00, 0.00),
(3208, 279, 19, NULL, 'Digital Business Cards', 1, 2500.00, 2500.00, 0.00, 0.00),
(3209, 279, NULL, NULL, 'Iron Farm with Viniyl Printing and Pasting and acrylic sheet', 3, 4500.00, 13500.00, 0.00, 0.00),
(3210, 279, NULL, NULL, 'Rent L/S Loader Rickshaw', 1, 4500.00, 4500.00, 0.00, 0.00),
(3211, 279, NULL, NULL, '', 1, 0.00, 0.00, 0.00, 0.00),
(3212, 236, NULL, NULL, 'RVM Machine Printing and Passting and Designing Pasting on sundar industrial estate Site', 1, 30000.00, 30000.00, 0.00, 0.00),
(3213, 236, NULL, NULL, '9 Side and one fornt size Booth design Vinyl Printing and Pasting on sundar industrial estate Site', 1, 42000.00, 42000.00, 0.00, 0.00),
(3214, 236, NULL, NULL, 'Board Delivery Rent', 1, 4500.00, 4500.00, 0.00, 0.00),
(3219, 274, NULL, NULL, 'Certificate Printing on art card', 167, 60.00, 10020.00, 0.00, 0.00),
(3220, 274, NULL, NULL, 'Slips Printing', 12, 400.00, 4800.00, 0.00, 0.00),
(3221, 274, NULL, NULL, 'A4 Print', 10, 10.00, 100.00, 0.00, 0.00),
(3222, 274, NULL, NULL, 'Flex Printing 13x6 Feet', 1, 6240.00, 6240.00, 0.00, 0.00),
(3223, 281, NULL, NULL, 'Black Print A4 Size', 105, 10.00, 1050.00, 0.00, 0.00),
(3224, 281, NULL, NULL, 'Black Print A4 Size', 3, 10.00, 30.00, 0.00, 0.00),
(3225, 281, NULL, NULL, 'Black Print A4 Size', 24, 10.00, 240.00, 0.00, 0.00),
(3228, 282, 11, NULL, 'Envelope Printing Letter Size', 13, 60.00, 780.00, 0.00, 0.00),
(3232, 283, NULL, NULL, 'Receipt Ghulam Shabbir', 1, 1500.00, 1500.00, 0.00, 0.00),
(3233, 283, NULL, NULL, 'Muhammad Ashraf Agreement Double Stamp', 1, 3200.00, 3200.00, 0.00, 0.00),
(3234, 283, NULL, NULL, 'Affidivat Muhammad Ali Ashiq', 1, 1000.00, 1000.00, 0.00, 0.00),
(3235, 284, NULL, NULL, 'Standee with 4 Side Rings', 1, 1000.00, 1000.00, 0.00, 0.00),
(3236, 284, NULL, NULL, 'Certificate Printing on Art Card', 30, 70.00, 2100.00, 0.00, 0.00),
(3237, 284, NULL, NULL, 'Passport Size Photo', 1, 200.00, 200.00, 0.00, 0.00),
(3238, 284, NULL, NULL, '150 Gsm Paper Print', 4, 50.00, 200.00, 0.00, 0.00),
(3239, 284, NULL, NULL, 'A4 Size Sticker Printing', 200, 70.00, 14000.00, 0.00, 0.00),
(3245, 285, NULL, NULL, 'Letter Head print A4 size 100gsm and careem color', 150, 30.00, 4500.00, 0.00, 0.00),
(3264, 287, NULL, NULL, 'Broom large Salon Quality', 30, 390.00, 11700.00, 0.00, 0.00),
(3265, 287, NULL, NULL, 'Dust bin bags without handle (Size: 21\" * 45\")', 300, 270.00, 81000.00, 0.00, 0.00),
(3266, 287, NULL, NULL, 'Towels for cleaning', 30, 390.00, 11700.00, 0.00, 0.00),
(3267, 287, NULL, NULL, 'Duster', 10, 300.00, 3000.00, 0.00, 0.00),
(3268, 287, NULL, NULL, 'Cotton Rags', 5, 150.00, 750.00, 0.00, 0.00),
(3269, 287, NULL, NULL, 'Broom Ring', 12, 30.00, 360.00, 0.00, 0.00),
(3270, 287, NULL, NULL, 'Broom Dasta', 1, 700.00, 700.00, 0.00, 0.00),
(3282, 288, NULL, NULL, 'Receipt Ghulam Shabbir', 1, 1500.00, 1500.00, 0.00, 0.00),
(3283, 288, NULL, NULL, 'Muhammad Ashraf Stamp paper', 1, 1250.00, 1250.00, 0.00, 0.00),
(3284, 288, NULL, NULL, 'Affidavit Muhammad Ali Ashiq', 1, 1000.00, 1000.00, 0.00, 0.00),
(3285, 288, NULL, NULL, 'Agreement Muhammad Ali Ashiq', 1, 2000.00, 2000.00, 0.00, 0.00),
(3286, 289, NULL, NULL, 'Broom large Salon Quality', 30, 570.00, 17100.00, 18.00, 3078.00),
(3287, 289, NULL, NULL, 'Dust bin bags without handle (Size: 21\" * 45\")', 300, 380.00, 114000.00, 18.00, 20520.00),
(3288, 289, NULL, NULL, 'Towels for cleaning', 30, 480.00, 14400.00, 18.00, 2592.00),
(3289, 289, NULL, NULL, 'Duster', 10, 390.00, 3900.00, 18.00, 702.00),
(3290, 289, NULL, NULL, 'Cotton Rags', 5, 100.00, 500.00, 18.00, 90.00),
(3291, 289, NULL, NULL, 'Broom Ring', 12, 70.00, 840.00, 18.00, 151.20),
(3292, 289, NULL, NULL, 'Broom Dasta', 12, 100.00, 1200.00, 18.00, 216.00),
(3294, 290, NULL, NULL, 'Agreement Muhammad Ali Ashiq', 1, 2000.00, 2000.00, 0.00, 0.00),
(3295, 290, NULL, NULL, '', 1, 0.00, 0.00, 0.00, 0.00),
(3336, 286, NULL, NULL, 'Door one way vision sticker pritning and Pasting 43x90 Inch', 1, 6500.00, 6500.00, 0.00, 0.00),
(3337, 286, NULL, NULL, 'Wall Flex pritning and Pasting 154x105 Inch', 1, 16000.00, 16000.00, 0.00, 0.00),
(3338, 286, NULL, NULL, 'one way vision sticker pritning and Pasting 19.5x92 Inch', 1, 33345.00, 33345.00, 0.00, 0.00),
(3339, 286, NULL, NULL, 'one way vision sticker pritning and Pasting 18.10x92 Inch', 1, 30951.00, 30951.00, 0.00, 0.00),
(3340, 286, NULL, NULL, 'Folding with Rent', 1, 7000.00, 7000.00, 0.00, 0.00),
(3341, 286, NULL, NULL, 'LED board with lights and fiting 19x3 feet', 1, 35000.00, 35000.00, 0.00, 0.00),
(3342, 286, NULL, NULL, 'Folding Rent one day Extra', 1, 4000.00, 4000.00, 0.00, 0.00),
(3343, 286, NULL, NULL, 'Fitting charges again working', 1, 3000.00, 3000.00, 0.00, 0.00),
(3350, 291, NULL, NULL, 'Receipt Ghulam Shabbir', 1, 1500.00, 1500.00, 0.00, 0.00),
(3351, 291, NULL, NULL, 'Muhammad Ashraf Stamp paper', 1, 1250.00, 1250.00, 0.00, 0.00),
(3352, 291, NULL, NULL, 'Affidavit Muhammad Ali Ashiq', 1, 1000.00, 1000.00, 0.00, 0.00),
(3353, 291, NULL, NULL, 'Agreement Muhammad Ali Ashiq', 1, 2000.00, 2000.00, 0.00, 0.00),
(3354, 291, NULL, NULL, 'Agreement Muhammad Ali Ashiq', 1, 2000.00, 2000.00, 0.00, 0.00),
(3355, 291, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 11, 200.00, 2200.00, 0.00, 0.00),
(3357, 292, NULL, NULL, 'Passport Size Pictures and CNIC Copies', 11, 200.00, 2200.00, 0.00, 0.00),
(3359, 293, NULL, NULL, 'E Stamp (Rs.200)', 124, 350.00, 43400.00, 0.00, 0.00),
(3364, 294, NULL, NULL, 'Epson Service and Cable Upate', 1, 1500.00, 1500.00, 0.00, 0.00),
(3365, 294, NULL, NULL, 'Auto Stamp', 1, 1200.00, 1200.00, 0.00, 0.00),
(3366, 294, NULL, NULL, 'Letter Head Printing', 30, 30.00, 900.00, 0.00, 0.00),
(3367, 294, NULL, NULL, 'brochure Printing', 500, 15.00, 7500.00, 0.00, 0.00),
(3368, 294, NULL, NULL, 'Letter Head and Brichure Design', 1, 500.00, 500.00, 0.00, 0.00),
(3371, 295, NULL, NULL, 'A4 Size Sticker Pritning', 25, 60.00, 1500.00, 0.00, 0.00),
(3372, 295, NULL, NULL, 'Setting and Re-Design', 1, 500.00, 500.00, 0.00, 0.00),
(3375, 296, NULL, NULL, 'Sticker 2x2 feet', 4, 700.00, 2800.00, 0.00, 0.00),
(3376, 296, NULL, NULL, 'Visting Card 310 Gsm Single Side', 2000, 1.80, 3600.00, 0.00, 0.00),
(3385, 297, NULL, NULL, 'A4 Size Color Print', 4, 30.00, 120.00, 0.00, 0.00),
(3386, 297, NULL, NULL, 'A4 Size Careem Color Print', 24, 40.00, 960.00, 0.00, 0.00),
(3387, 297, NULL, NULL, 'Lamination A4 Size', 2, 60.00, 120.00, 0.00, 0.00),
(3388, 297, NULL, NULL, 'Logo and stamp', 1, 1300.00, 1300.00, 0.00, 0.00),
(3392, 298, NULL, NULL, 'Letter Head A4 Size 128 Gsm Matt Paper  with 4 Color Printing and Binding', 3000, 9.00, 27000.00, 0.00, 0.00),
(3393, 298, NULL, NULL, 'A4 Size Envelope with 4 Color Printing frond and Back Side (9.25x12 Inch)', 3000, 14.98, 44940.00, 0.00, 0.00),
(3394, 298, NULL, NULL, 'Letter Size Envelope with 4 Color Printing front and Back Side (4.25x9.25 Inch)', 3000, 11.00, 33000.00, 0.00, 0.00),
(3397, 299, NULL, NULL, 'Tariq Garen Slip Printing with Auto Numbering', 12, 400.00, 4800.00, 0.00, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `invoice_payments`
--

CREATE TABLE `invoice_payments` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paid_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_payments`
--

INSERT INTO `invoice_payments` (`id`, `invoice_id`, `amount`, `paid_at`) VALUES
(9, 11, 5000.00, '2025-09-03 06:47:26'),
(11, 14, 7500.00, '2025-09-03 11:05:33'),
(12, 14, 7500.00, '2025-09-03 11:05:50'),
(13, 16, 3992.00, '2025-09-03 13:07:27'),
(14, 11, 7000.00, '2025-09-04 10:11:20'),
(15, 19, 2500.00, '2025-09-04 10:22:01'),
(18, 23, 9000.00, '2025-09-04 17:05:15'),
(24, 51, 3460.00, '2025-09-12 14:42:10'),
(25, 54, 10000.00, '2025-09-16 09:00:58'),
(28, 61, 1220.00, '2025-09-17 15:22:39'),
(34, 83, 8000.00, '2025-09-25 14:25:59'),
(38, 20, 15000.00, '2025-10-08 07:21:51'),
(39, 98, 3000.00, '2025-10-08 07:38:01'),
(41, 84, 116670.00, '2025-10-13 12:03:00'),
(42, 58, 42267.58, '2025-10-14 07:45:13'),
(43, 57, 26443.80, '2025-10-14 07:45:46'),
(44, 58, 944.02, '2025-10-14 07:46:38'),
(45, 20, 19800.00, '2025-10-16 11:07:23'),
(47, 104, 40200.00, '2025-10-18 15:03:24'),
(48, 104, 40200.00, '2025-10-18 15:03:34'),
(49, 102, 10640.00, '2025-10-18 15:03:55'),
(50, 104, -40200.00, '2025-10-18 15:04:27'),
(51, 104, -40200.00, '2025-10-18 15:04:28'),
(52, 104, 40200.00, '2025-10-18 15:04:45'),
(53, 119, 1109.50, '2025-10-21 18:04:26'),
(54, 121, 13420.00, '2025-10-24 11:50:44'),
(55, 95, 3600.00, '2025-10-27 06:33:03'),
(57, 125, 7000.00, '2025-10-27 08:02:47'),
(58, 128, 14000.00, '2025-10-29 14:02:35'),
(59, 129, 2200.00, '2025-10-30 10:53:10'),
(60, 59, 11646.60, '2025-10-30 18:39:35'),
(62, 127, 22000.00, '2025-10-31 13:28:59'),
(63, 125, 4400.00, '2025-10-31 13:31:51'),
(64, 123, 4500.00, '2025-10-31 13:32:25'),
(65, 132, 2500.00, '2025-11-03 06:29:24'),
(66, 80, 50000.00, '2025-11-03 06:40:40'),
(67, 118, 11175.00, '2025-11-03 07:02:17'),
(68, 101, 17500.00, '2025-11-03 07:02:44'),
(69, 91, 19200.00, '2025-11-03 07:03:03'),
(70, 138, 20000.00, '2025-11-10 07:06:55'),
(71, 52, 2470.00, '2025-11-10 07:07:57'),
(72, 134, 2000.00, '2025-11-11 15:26:08'),
(73, 134, 4890.00, '2025-11-11 15:26:57'),
(74, 143, 2000.00, '2025-11-11 15:28:28'),
(75, 145, 1500.00, '2025-11-12 15:56:14'),
(76, 147, 11000.00, '2025-11-14 08:45:24'),
(77, 148, 2750.00, '2025-11-14 11:23:55'),
(78, 138, 10000.00, '2025-11-18 11:50:42'),
(79, 144, 1000.00, '2025-11-20 11:05:35'),
(80, 154, 8300.00, '2025-11-21 07:11:55'),
(81, 153, 15000.00, '2025-11-21 09:59:35'),
(82, 155, 5180.00, '2025-11-21 16:12:31'),
(84, 138, 23500.00, '2025-11-25 11:59:41'),
(86, 160, 7200.00, '2025-11-26 10:57:07'),
(87, 149, 15000.00, '2025-11-26 11:33:03'),
(88, 157, 1200.00, '2025-11-27 05:57:00'),
(89, 151, 4500.00, '2025-11-27 05:57:41'),
(90, 139, 6500.00, '2025-11-27 05:58:36'),
(91, 80, 50000.00, '2025-11-27 06:04:39'),
(92, 161, 11900.00, '2025-11-27 11:58:12'),
(93, 162, 2250.00, '2025-11-27 12:50:46'),
(94, 162, 130.00, '2025-11-27 12:51:14'),
(95, 162, -130.00, '2025-11-27 12:51:46'),
(96, 164, 3150.00, '2025-11-28 06:34:45'),
(97, 164, 3150.00, '2025-11-28 09:15:15'),
(98, 131, 49350.00, '2025-11-28 12:06:57'),
(99, 131, 49350.00, '2025-11-28 12:08:16'),
(100, 165, 1760.00, '2025-11-28 12:26:51'),
(101, 153, 16000.00, '2025-11-28 12:55:28'),
(102, 153, 5000.00, '2025-11-28 12:57:15'),
(103, 171, 65000.00, '2025-12-04 05:51:24'),
(104, 168, 6000.00, '2025-12-04 05:52:23'),
(105, 167, 10000.00, '2025-12-04 05:52:39'),
(106, 174, 18.00, '2025-12-05 11:06:02'),
(107, 174, -18.00, '2025-12-05 11:06:16'),
(108, 20, 6890.00, '2025-12-05 13:26:15'),
(109, 20, 20000.00, '2025-12-05 13:26:51'),
(110, 126, 12000.00, '2025-12-08 08:20:37'),
(111, 177, 12000.00, '2025-12-08 08:21:13'),
(112, 166, 54200.00, '2025-12-11 05:49:09'),
(113, 178, 12400.00, '2025-12-11 06:26:54'),
(114, 180, 7000.00, '2025-12-13 11:15:32'),
(115, 180, 2000.00, '2025-12-13 11:17:50'),
(116, 181, 14000.00, '2025-12-16 10:49:42'),
(117, 181, 2100.00, '2025-12-16 10:54:47'),
(118, 182, 4500.00, '2025-12-19 07:46:06'),
(119, 80, 50000.00, '2025-12-20 13:58:53'),
(120, 185, 53750.00, '2025-12-26 11:21:55'),
(121, 186, -20000.00, '2025-12-27 11:39:08'),
(122, 186, 20000.00, '2025-12-27 11:40:37'),
(123, 88, 340028.80, '2026-01-06 09:07:12'),
(124, 88, 340028.80, '2026-01-06 09:17:28'),
(125, 173, 98000.00, '2026-01-06 09:25:53'),
(126, 186, 22000.00, '2026-01-06 09:26:11'),
(127, 175, 26500.00, '2026-01-06 09:27:38'),
(128, 176, 88000.00, '2026-01-06 09:28:41'),
(129, 187, 17500.00, '2026-01-06 15:46:59'),
(130, 169, 20000.00, '2026-01-07 09:48:34'),
(131, 103, 5000.00, '2026-01-07 09:49:49'),
(132, 159, 17500.00, '2026-01-07 09:50:50'),
(133, 150, 5000.00, '2026-01-07 09:51:04'),
(134, 190, 7300.00, '2026-01-09 09:47:31'),
(135, 133, 18440.00, '2026-01-10 08:51:41'),
(136, 174, 27531.00, '2026-01-10 08:52:56'),
(137, 80, 50000.00, '2026-01-13 08:35:36'),
(138, 199, 45150.00, '2026-01-14 06:18:27'),
(139, 189, 6970.00, '2026-01-14 13:29:40'),
(140, 203, 20000.00, '2026-01-17 15:46:13'),
(141, 203, 20000.00, '2026-01-17 15:46:21'),
(142, 203, -20000.00, '2026-01-17 15:48:24'),
(143, 198, 100000.00, '2026-01-19 07:57:40'),
(144, 204, 2500.00, '2026-01-20 08:06:32'),
(145, 133, -18440.00, '2026-01-20 10:37:46'),
(146, 133, 19411.00, '2026-01-20 10:37:52'),
(147, 174, -27531.00, '2026-01-20 10:38:13'),
(148, 174, 28980.80, '2026-01-20 10:38:20'),
(149, 201, 7800.00, '2026-01-22 12:25:03'),
(150, 188, 9280.00, '2026-01-22 12:25:25'),
(151, 208, 8800.00, '2026-01-24 06:46:48'),
(153, 205, 16000.00, '2026-01-29 10:50:15'),
(154, 222, 2310.00, '2026-01-30 11:09:44'),
(155, 224, 43850.00, '2026-02-02 07:15:47'),
(156, 221, 43200.00, '2026-02-02 08:41:04'),
(157, 220, 7000.00, '2026-02-02 08:41:29'),
(158, 50, 6000.00, '2026-02-02 08:50:00'),
(159, 216, 20000.00, '2026-02-02 08:53:39'),
(160, 149, 10000.00, '2026-02-02 09:03:08'),
(161, 203, 18150.00, '2026-02-02 09:04:28'),
(162, 230, 3930.00, '2026-02-02 11:26:12'),
(163, 233, 1000.00, '2026-02-04 09:42:19'),
(164, 234, 4800.00, '2026-02-09 07:22:58'),
(165, 235, 560.00, '2026-02-10 08:33:24'),
(166, 232, 6600.00, '2026-02-11 06:23:51'),
(167, 231, 560.00, '2026-02-11 06:24:05'),
(168, 229, 6900.00, '2026-02-11 06:24:34'),
(169, 227, 8200.00, '2026-02-11 06:25:16'),
(170, 226, 4500.00, '2026-02-11 06:25:29'),
(171, 223, 15800.00, '2026-02-11 06:25:58'),
(172, 219, 8000.00, '2026-02-11 06:26:09'),
(173, 212, 10500.00, '2026-02-11 06:26:25'),
(174, 202, 43200.00, '2026-02-11 06:26:46'),
(175, 234, 16980.00, '2026-02-11 06:37:48'),
(176, 171, 400.00, '2026-02-11 06:38:59'),
(177, 238, 3500.00, '2026-02-11 07:57:23'),
(184, 243, 3300.00, '2026-02-12 05:08:25'),
(185, 192, 45465.00, '2026-02-12 11:03:16'),
(186, 193, 31000.00, '2026-02-12 11:03:24'),
(187, 194, 45000.00, '2026-02-12 11:11:32'),
(188, 195, 37500.00, '2026-02-12 11:11:38'),
(189, 196, 20940.00, '2026-02-12 11:11:45'),
(190, 200, 37500.00, '2026-02-12 11:11:51'),
(191, 246, 3400.00, '2026-02-12 11:57:15'),
(192, 247, 1000.00, '2026-02-13 10:58:00'),
(193, 248, 12000.00, '2026-02-16 11:33:44'),
(194, 248, 3000.00, '2026-02-16 11:35:02'),
(195, 250, 3100.00, '2026-02-17 09:23:58'),
(196, 251, 1000.00, '2026-02-17 14:19:16'),
(198, 254, -0.04, '2026-02-19 10:56:15'),
(199, 254, 0.04, '2026-02-19 11:02:50'),
(200, 254, 8930.00, '2026-02-19 11:52:25'),
(201, 256, 1300.00, '2026-02-21 08:24:42'),
(202, 257, 2400.00, '2026-02-25 07:41:23'),
(203, 257, 400.00, '2026-02-27 06:57:23'),
(204, 259, 4500.00, '2026-02-27 06:59:10'),
(205, 261, 400.00, '2026-02-27 09:31:44'),
(206, 262, 48350.00, '2026-02-28 07:37:41'),
(207, 263, 5000.00, '2026-03-02 08:16:18'),
(208, 263, 2250.00, '2026-03-03 06:44:15'),
(209, 273, 2000.00, '2026-03-06 07:11:57'),
(211, 274, 9600.00, '2026-03-10 09:54:53'),
(212, 89, 200600.00, '2026-03-10 10:24:24'),
(213, 94, 14773.60, '2026-03-10 10:27:26'),
(214, 245, 8260.00, '2026-03-10 10:34:38'),
(215, 278, 5500.00, '2026-03-12 07:36:22'),
(216, 277, 7250.00, '2026-03-12 07:36:32'),
(217, 272, 11900.00, '2026-03-12 07:36:45'),
(218, 268, 30000.00, '2026-03-12 07:38:28'),
(219, 258, 29500.00, '2026-03-12 07:38:56'),
(220, 76, 8520.00, '2026-03-12 07:39:42'),
(221, 217, 5255.00, '2026-03-12 07:40:59'),
(222, 228, 11900.00, '2026-03-12 07:41:26'),
(223, 265, 7800.00, '2026-03-12 07:43:29'),
(224, 183, 19753.20, '2026-03-12 07:43:52'),
(225, 267, 7000.00, '2026-03-13 10:53:45'),
(226, 279, 35000.00, '2026-03-14 07:43:30'),
(227, 20, 60000.00, '2026-03-17 08:07:46'),
(228, 20, -60000.00, '2026-03-17 08:08:15'),
(229, 264, 60000.00, '2026-03-17 08:11:54'),
(230, 279, 11560.00, '2026-03-17 08:41:38'),
(231, 236, 16500.00, '2026-03-17 08:42:25'),
(232, 274, 9200.00, '2026-03-17 08:43:48'),
(233, 282, 780.00, '2026-03-17 17:05:57'),
(234, 283, 5700.00, '2026-03-25 07:48:51'),
(235, 288, 5750.00, '2026-03-27 09:31:49'),
(236, 290, 2000.00, '2026-03-27 13:30:08'),
(237, 286, 50000.00, '2026-03-29 07:47:45'),
(238, 291, 9950.00, '2026-03-30 13:44:52'),
(239, 292, 2200.00, '2026-03-31 06:25:42'),
(240, 293, 43400.00, '2026-04-01 06:39:05'),
(241, 297, 2500.00, '2026-04-02 14:10:54');

-- --------------------------------------------------------

--
-- Table structure for table `invoice_settings`
--

CREATE TABLE `invoice_settings` (
  `id` int(11) NOT NULL,
  `terms` text DEFAULT NULL,
  `payment_methods` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_settings`
--

INSERT INTO `invoice_settings` (`id`, `terms`, `payment_methods`) VALUES
(0, 'Payment due upon receipt', 'Cash ? Bank Transfer');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `code` varchar(40) NOT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','processing','completed','cancelled') DEFAULT 'pending',
  `design_file` varchar(255) DEFAULT NULL,
  `external_design_link` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `tenant_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `customer_phone` varchar(50) DEFAULT NULL,
  `customer_email` varchar(200) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `items_json` text DEFAULT NULL,
  `cancel_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL DEFAULT 1,
  `key` enum('home','about','services','contact') NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` mediumtext DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`id`, `tenant_id`, `key`, `title`, `content`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'about', 'About Us:', 'ZAK PRINTING is a brand development company providing vast services to make your brand memorable, trusted and a name on which people can rely We have strategic, creative and technical expertise to offer an end-to-end Designing, Branding, Digital & Offset Printing and Indoor & Outdoor Sign solutions. Moreover we are offering a wide range of professional Laser Cutting, Laser Engraving. Vinyl Cutting, Acrylic and SS Letters, Promotional Products/Gifts based on your project requirements and budget limits.\r\nWe provide creative solutions to marketing needs and understand your business needs providing solutions with our wide range of design & advertising services. We\'ll do all the hard work to make your brand successful as we believe, that your success is our success.\r\n\r\nOVERVIEW\r\nZAK PRINTING is a young and vibrant company with a lot of experience in Design and Signage services and product offerings. We will provide guidance through our experience in Signage and Designing Industry Our aim is to focus on your needs and we offer each client a dedicated client service to help you throughout the development and building of your brand. We create the brand identity you require and build your brand awareness through the countless services we offer Put your brand in our hands and we will show you the way forward We\'re a friendly bunch, down-to-earth and honest. We pride ourselves on long lasting client relationships. We are a small studio but we certainly don\'t think small. ZAK Printing offers you services helping you to establish your market presence\r\n\r\nZAK PRINTING offers you services helping you to establish your market presence. We understand the importance of making a good impression and the value creativity can add in transforming your company\'s corporate image into a powerful punch. Whether you are creating a new brand or promoting an existing and trusted, a brand that people return to time after time has to have an impact.', 1, '2025-10-29 06:46:12', '2025-10-29 06:47:07'),
(2, 1, 'services', 'Services', 'ZAK PRINTING is a brand development company providing vast services to make your brand memorable, trusted and a name on which people can rely We have strategic, creative and technical expertise to offer an end-to-end Designing, Branding, Digital & Offset Printing and Indoor & Outdoor Sign solutions. Moreover, we are offering a wide range of professional Laser Cutting, Laser Engraving. Vinyl Cutting, Acrylic and SS Letters, Promotional Products/Gifts based on your project requirements and budget limits.\r\nWe provide creative solutions to marketing needs and understand your business needs providing solutions with our wide range of design & advertising services. We\'ll do all the hard work to make your brand successful as we believe, that your success is our success.\r\n\r\nOVERVIEW\r\nZAK PRINTING is a young and vibrant company with a lot of experience in Design and Signage services and product offerings. We will provide guidance through our experience in Signage and Designing Industry Our aim is to focus on your needs and we offer each client a dedicated client service to help you throughout the development and building of your brand. We create the brand identity you require and build your brand awareness through the countless services we offer Put your brand in our hands and we will show you the way forward We\'re a friendly bunch, down-to-earth and honest. We pride ourselves on long lasting client relationships. We are a small studio but we certainly don\'t think small. ZAK Printing offers you services helping you to establish your market presence\r\n\r\nZAK PRINTING offers you services helping you to establish your market presence. We understand the importance of making a good impression and the value creativity can add in transforming your company\'s corporate image into a powerful punch. Whether you are creating a new brand or promoting an existing and trusted, a brand that people return to time after time has to have an impact.', 1, '2025-10-29 06:48:57', '2025-10-29 06:48:57');

-- --------------------------------------------------------

--
-- Table structure for table `page_assets`
--

CREATE TABLE `page_assets` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `page_key` varchar(100) NOT NULL,
  `asset_key` varchar(150) NOT NULL,
  `label` varchar(255) DEFAULT '',
  `type` enum('image','video') DEFAULT 'image',
  `file_path` varchar(255) DEFAULT '',
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `page_assets`
--

INSERT INTO `page_assets` (`id`, `tenant_id`, `page_key`, `asset_key`, `label`, `type`, `file_path`, `width`, `height`, `alt_text`, `created_at`, `updated_at`, `updated_by`) VALUES
(1, 1, 'global', 'logo_primary', 'Primary Logo', 'image', 'storage/assets/asset_6915aee3aa49d0.08892223.png', 404, 71, 'ZAK Printing logo', '2025-11-13 10:11:47', '2025-11-13 10:11:47', 1),
(2, 1, 'global', 'logo_footer', 'Footer Logo', 'image', 'storage/assets/asset_6915aeee15a470.97614465.png', 404, 71, 'ZAK Printing footer logo', '2025-11-13 10:11:53', '2025-11-13 10:11:58', 1),
(4, 1, 'home', 'hero_slide_2_bg', 'Hero Slide 2 Background', 'image', '/assets/printnow/assets/img/hero/hero-bg-2.jpg', NULL, NULL, '', '2025-11-13 10:13:03', '2025-11-13 10:13:03', 1),
(5, 1, 'home', 'hero_slide_1_bg', 'Hero Slide 1 Background', 'image', 'storage/assets/asset_6915af58a721d3.64774844.jpg', 1920, 1280, '', '2025-11-13 10:13:27', '2025-11-13 10:13:44', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pricing_plans`
--

CREATE TABLE `pricing_plans` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL DEFAULT 1,
  `key` enum('basic','premium','enterprise') NOT NULL,
  `title` varchar(190) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `period` varchar(20) DEFAULT 'Year',
  `features` mediumtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pricing_plans`
--

INSERT INTO `pricing_plans` (`id`, `tenant_id`, `key`, `title`, `price`, `period`, `features`, `is_active`, `sort_order`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'basic', 'Basic', 7999.00, 'Month', 'LOGO Design\nStationary Design\nExecutive Business Cards\nLetterheads A4 100 Gsm\nInvoice Pad A5 (100 Pages)\nFile Cover Letterhead size\nRound Stamp Manual 1\"\nWhite Mug', 1, NULL, 1, '2025-10-21 17:41:33', '2025-10-23 13:09:58'),
(2, 1, 'premium', 'Premium', 29999.00, 'Month', 'LOGO Design\nStationary Design\nExecutive Business Cards\nLetterheads A4  100 gsm\nInvoice Pad A5 (100 Pages)\nFile Cover Letterhead size\nRound Stamp Manual 1.5\"\nWhite Mug', 1, NULL, 1, '2025-10-21 17:41:33', '2025-10-23 13:19:44'),
(3, 1, 'enterprise', 'Enterprise', 54999.00, 'Month', 'LOGO Design\nStationary Design\nPremium Business Cards\nLetterhead A4 100 gsm\nInvoice Pad A5 (100 Pages)\nFile Cover Letterhead size\nRound Stamp Auto 1.5\" Round\nWhite mug\nStickers 1\" Round\nBusiness Card Stand\nPen', 1, NULL, 1, '2025-10-21 17:41:33', '2025-10-23 13:19:44');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('active','draft') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `featured_order` int(11) DEFAULT NULL,
  `image2` varchar(255) DEFAULT NULL,
  `image3` varchar(255) DEFAULT NULL,
  `image4` varchar(255) DEFAULT NULL,
  `weight` varchar(100) DEFAULT NULL,
  `dimensions` varchar(150) DEFAULT NULL,
  `colors` varchar(150) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `title`, `price`, `status`, `created_at`, `description`, `image`, `is_featured`, `featured_order`, `image2`, `image3`, `image4`, `weight`, `dimensions`, `colors`, `tenant_id`) VALUES
(11, 'Envelope Printing', 10.00, 'active', '2025-09-29 15:58:54', 'Custom Envelope Printing | Branded Mailing Solutions \r\nOffset-printed envelopes in multiple sizes with logo and branding. Essential for professional mailouts and corporate identity.', 'storage/products/prod_690cb4d8182391.86704345.jpg', 1, NULL, 'storage/products/prod_690cb4d81843a5.97174973.webp', 'storage/products/prod_690cb4d81854b4.91482878.jpg', 'storage/products/prod_690cb4d8186797.68678029.jpg', '', '', '', 1),
(12, 'Brochure Printing', 5.00, 'active', '2025-09-29 15:59:53', 'Full Color Catalogs & Profiles Vibrant, multi-page brochures for product showcases, company profiles, and marketing campaigns. High-impact offset quality. Brochure Printing Services', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(13, 'Flyer Printing in Pakistan | Promotional Leaflets & Handouts', 10.00, 'active', '2025-09-29 16:01:31', 'Promotional Leaflets & Handouts Cost-effective bulk flyer printing for events, sales, and promotions. Sharp text and vivid images with offset technology.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(14, 'Poster Printing', 10.00, 'active', '2025-09-29 16:02:05', 'High-resolution offset posters for shops, events, and exhibitions. Durable and eye-catching for indoor/outdoor use.\r\nPoster Printing Services | Large Format Advertising', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(15, 'Catalog Printing', 30.00, 'active', '2025-09-29 16:03:08', 'Product Catalog Printing | Full Color Business Catalogs Professional catalogs for retail, wholesale, or B2B. Perfect binding, laminated covers, and vivid imagery. Rate Depent on Pages', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(16, 'Magazine Printing', 10.00, 'active', '2025-09-29 16:03:40', 'Magazine Printing Services | Custom Periodicals & Zines Offset-printed magazines with custom layouts, perfect for publishers, schools, or corporate newsletters.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(17, 'Calendar Printing', 10.00, 'active', '2025-09-29 16:04:08', 'Calendar Printing Pakistan | Wall & Desk Calendars Branded wall and desk calendars with company logo or custom themes. Great for gifting and year-round brand visibility.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(18, 'Booklet Printing', 30.00, 'active', '2025-09-29 16:04:33', 'Booklet Printing Services | Event Guides & Manuals Compact, professionally bound booklets for training, events, or product guides. High-quality offset print with custom covers.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(19, 'Digital Business Cards', 2500.00, 'active', '2025-09-29 16:05:10', '100 Digital Business Card Printing | Quick Turnaround Fast, short-run business cards with variable data or personalized names. Ideal for startups and small teams.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(20, 'Personalized Invitations', 50.00, 'active', '2025-09-29 16:05:39', 'Invitation Card Printing | Wedding & Event Cards Elegant digital-printed invitations for weddings, birthdays, and corporate events. Custom designs and fast delivery.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(21, 'Custom Greeting Cards', 50.00, 'active', '2025-09-29 16:06:50', 'Greeting Card Printing | Birthday & Thank You Notes Heartfelt greeting cards with custom messages or photos. Perfect for personal or corporate gifting.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(22, 'Menu Card Printing', 50.00, 'active', '2025-09-29 16:08:01', 'Restaurant Menu Printing | Caf? & Hotel Menus Professionally designed menu cards for restaurants and cafes. Laminated, spiral-bound, or stand-up options available.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(23, 'Event Tickets Printing', 10.00, 'active', '2025-09-29 16:09:36', 'Event Ticket Printing | Concerts & Functions Secure, numbered, or barcoded tickets for events, theaters, and conferences. Custom design and fast printing.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(24, 'Digital Certificates Print', 40.00, 'active', '2025-09-29 16:12:18', 'Certificate Printing | Academic & Achievement Awards Elegant certificates for schools, universities, or corporate awards. Add seals, signatures, and custom borders.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(25, 'Customized Notepads Print', 1000.00, 'active', '2025-09-29 16:13:18', '5 Notepad Printing | Branded Office Memo Pads Spiral-bound or glued notepads with company logo on every sheet. Great for offices, hotels, and giveaways.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(26, 'Digital Stickers Prinitng', 300.00, 'active', '2025-09-29 16:14:39', 'Sticker Printing | Custom Labels & Decals Waterproof, matte, or glossy stickers for packaging, branding, or personal use. Any shape or size.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(27, 'Training Manuals', 50.00, 'active', '2025-09-29 16:15:42', 'Professionally printed manuals for workshops, employee training, or academic courses. Saddle-stitched or perfect bound.\r\nTraining Manual Printing | Short-Run Educational Books Rate as per Your Books', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(28, 'UV Mug Printing', 999.00, 'active', '2025-09-29 16:17:00', 'Custom Mug Printing | Photo & Logo Mugs High-gloss UV printing on ceramic mugs. Dishwasher-safe and vibrant. Perfect for gifts, cafes, and corporate branding.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(29, 'UV Acrylic Printing', 500.00, 'active', '2025-09-29 16:18:03', 'Crystal-clear acrylic plaques or signs with UV-printed logos. Great for office branding, awards, or retail displays. Acrylic Sheet Printing | Clear & Glossy Displays', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(30, 'UV Keychains Print', 199.00, 'active', '2025-09-29 16:18:50', 'Durable acrylic or metal keychains with full-color UV printing. Perfect for giveaways, events, or retail branding.\r\nKeychain Printing | High-Gloss Custom Designs', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(31, 'UV Sign Boards', 5000.00, 'active', '2025-09-29 16:19:47', 'UV-printed rigid signs for shops, offices, or exhibitions. Weatherproof and long-lasting.\r\nSign Board Printing | Indoor & Outdoor Branding', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(32, 'UV Name Plates', 699.00, 'active', '2025-09-29 16:20:18', 'Elegant desk or door nameplates with UV-printed names and titles. Available in acrylic, wood, or metal.\r\nName Plate Printing | Custom Office Door Signs', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(33, 'UV DTF Stickers', 50.00, 'active', '2025-09-29 16:21:02', 'Direct-to-film UV stickers that adhere to curved or uneven surfaces. Ideal for bottles, jars, or promotional items.\r\nDTF Sticker Printing | Waterproof & Flexible Labels Rate Per Sq. Inch', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(34, 'UV DTF Bottle Stickers', 99.00, 'active', '2025-09-29 16:21:54', 'Wrap-around or front labels for beverage bottles. Stretchable and conformable to bottle curves. Bottle Sticker Printing | Water & Juice Labels', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(35, 'Transparent Stickers', 50.00, 'active', '2025-09-29 16:24:53', 'Transparent background stickers for glass jars, windows, or premium packaging. Design appears to float on the surface.\r\nClear Sticker Printing | See-Through Labels', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(36, 'Custom T-Shirt Printing', 699.00, 'active', '2025-09-29 16:26:45', 'Full-color, soft-hand prints on cotton t-shirts. No minimum order ? perfect for events, teams, or personal use. T-Shirt Printing Pakistan | Direct to Garment', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(37, 'Polo Shirt Printing', 999.00, 'active', '2025-09-29 16:29:27', 'Polo Shirt Printing | Branded Work Uniforms | Corporate Uniforms Professional DTG-printed polos for corporate teams, schools, or events. Breathable fabric and vibrant prints.', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(38, 'Hoodie Printing', 1499.00, 'active', '2025-09-29 16:30:31', 'Warm, comfortable hoodies with custom designs. Ideal for winter promotions, universities, or streetwear brands.\r\nHoodie Printing Services | Custom Sweatshirts', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(39, 'Jacket Printing', 1499.00, 'active', '2025-09-29 16:31:29', 'DTG printing on lightweight or insulated jackets. Great for outdoor teams, delivery staff, or events.\r\nCustom Jacket Printing | Team & Corporate Jackets', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(40, 'Cap Printing', 699.00, 'active', '2025-09-29 16:32:00', 'Adjustable or fitted caps with printed front panels. Perfect for sports teams, promotions, or retail branding.\r\nCap Printing Services | Custom Branded Caps', 'storage/products/prod_690cb2a3364be4.55069031.jpg', 0, NULL, 'storage/products/prod_690cb2a3369806.39565937.jpg', 'storage/products/prod_690cb2a336c933.40771564.jpg', 'storage/products/prod_690cb2a336e2d2.47406943.webp', '', '', '', 1),
(42, 'Kids T-Shirt Printing', 2999.00, 'active', '2025-09-29 16:34:12', 'Soft, safe prints on children?s tees. Popular for birthdays, schools, or family events.\r\nKids T-Shirt Printing | Cartoon & Fun Designs', 'storage/products/prod_690cb16b61f7b1.99464555.jpg', 0, NULL, 'storage/products/prod_690cb16b620f26.61406791.jpg', NULL, NULL, '', '', '', 1),
(44, 'Mask Printing', 50.00, 'active', '2025-09-29 16:35:18', 'Custom Face Mask Printing | Branded & Fashion\r\nReusable fabric masks with custom prints. Great for corporate gifting or fashion statements.', 'storage/products/prod_690caf34174420.57415154.webp', 1, NULL, 'storage/products/prod_690caf34175c86.81872279.png', 'storage/products/prod_690caf34177463.47246198.png', 'storage/products/prod_690caf3417c937.30807410.jpg', '', '', '', 1),
(45, 'Personalized Diaries', 999.00, 'active', '2025-09-29 16:36:13', 'Leather or PU-bound diaries with embossed or printed names/logos. Ideal for corporate gifts or students.\r\nDiary Printing Pakistan | Custom Planners & Journals', 'storage/products/prod_690cae76a25ba0.87162006.webp', 1, NULL, 'storage/products/prod_690cae76a27aa4.48776787.jpg', 'storage/products/prod_690cae76a29674.81876305.webp', 'storage/products/prod_690cae76a2aba6.13954883.jpg', '', '', '', 1),
(46, 'Customized Pens', 99.00, 'active', '2025-09-29 16:36:46', 'Ballpoint or rollerball pens with laser engraving or pad printing. Low-cost, high-impact promotional item.\r\nPen Printing Services | Branded Corporate Pens', 'storage/products/prod_690cae15d7e6d3.21557654.jpg', 1, NULL, 'storage/products/prod_690cae15d816e5.16115267.webp', 'storage/products/prod_690cae15d82991.10104124.jpg', 'storage/products/prod_690cae15d841f9.92117112.png', '', '', '', 1),
(47, 'Personalized Water Bottles', 1499.00, 'active', '2025-09-29 16:37:10', 'Stainless steel or plastic bottles with permanent logo printing. Great for gyms, offices, or outdoor events.', 'storage/products/prod_690cad4ad9f3f5.18452143.jpg', 1, NULL, 'storage/products/prod_690cad4ada2375.26638976.webp', 'storage/products/prod_690cad4ada3297.27719612.jpg', NULL, '', '', '', 1),
(49, 'Printed Cushions', 1499.00, 'active', '2025-09-29 16:37:57', 'Cushion Printing | Custom Photo & Logo Pillows\r\nSoft, washable cushions with printed photos or designs. Perfect for homes, cafes, or gifting.', 'storage/products/prod_690cacb19dca97.45258212.jpg', 1, NULL, 'storage/products/prod_690cacb19de5f1.11446277.jpeg', 'storage/products/prod_690cacb19df8a0.56896501.webp', NULL, '', '', '', 1),
(50, 'Personalized Photo Frames | Custom Picture Gifts', 999.00, 'active', '2025-09-29 16:38:22', 'Personalized Photo Frames: Frame Your Story\r\nEvery photo holds a precious memory?it deserves a frame that is just as unique.\r\n\r\nWelcome to our Personalized Photo Frames studio, where we turn your cherished pictures into custom-crafted heirlooms. Whether you\'re celebrating a wedding, a new baby, a graduation, or just a beautiful moment, we provide the perfect personalized setting for your memories.\r\n\r\nDesign a truly unique gift or piece of home decor:\r\n\r\nEngrave a Message: Add names, dates, meaningful quotes, or a special anniversary message directly onto the frame.\r\n\r\nPrint Your Photo: Simply upload your favorite picture, and we will print it in stunning clarity, perfectly fitted into your chosen frame style.\r\n\r\nChoose Your Material: Select from classic wood, sleek acrylic, modern metal, or charming engraved plaques.\r\n\r\nStop scrolling through generic frames. Start creating a meaningful masterpiece that will be admired for generations.', 'storage/products/prod_68fb73d536c278.86948192.jpg', 1, NULL, 'storage/products/prod_68fb73d5370114.17258663.webp', 'storage/products/prod_68fb73d5373963.49498990.jpg', 'storage/products/prod_68fb73d5374fe4.01718044.jpg', '', '', '', 1),
(51, 'Customized Clocks Printing: Timeless Branding for Your Business', 1500.00, 'active', '2025-09-29 16:38:42', 'Looking for a unique, practical, and highly visible way to promote your brand? Our Customized Clocks Printing service is the perfect solution.\r\nA clock is a universal necessity, ensuring your message is seen day in and day out, all year long. We specialize in transforming high-quality wall clocks into powerful branding tools.\r\nCorporate Gifts: Impress clients and partners with a premium, useful item featuring your logo.\r\nPromotional Giveaways: Create high-value swag for trade shows and events.\r\nEmployee Recognition: Brand your office space and celebrate your team.\r\n\r\nFrom vibrant colors and bold logos to subtle, sophisticated designs, we handle the printing with precision and care, delivering a product that truly reflects your company\'s quality.\r\n\r\nMake every minute count for your brand. Get started on your custom clock order today!', 'storage/products/prod_68fb7269979118.35696138.webp', 1, NULL, 'storage/products/prod_68fb726997bc52.59636041.jpg', 'storage/products/prod_68fb726997d668.25691371.jpg', 'storage/products/prod_68fb726997ebc1.36231445.jpg', '', '', '', 1),
(52, 'Customize Temperature Bottle', 499.00, 'active', '2025-09-29 16:39:04', 'Ever thought of improving your daily jogging routine with a digital temperature bottle? This customizable smart thermos brings all that and more with breathtaking looks and functionality to match.\r\n\r\nUnparalleled Looks and Custom Design\r\nOn the surface, the metallic finish and build of this bottle alone are a testament to quality construction. The compact style makes it perfect for a picnic, school hours, recreational outing, or the gym. But despite the apparently small dimensions, it can still hold up to half a liter of liquids at a time.\r\nBuyers can customize bottles with permanent engravings of their choice, including the premium option of double-sided prints. Plus, the bottles come in four color variants fitting for any tastes: black, white, red, and black.\r\n\r\nSuperior Physical and Digital Performance\r\nBy having a digital monitor for temperature, bottles like this are an essential tool for health-conscious hydration. Its vacuum seal keeps your drink at the perfect temperature for a long time.\r\nPlus, the stainless-steel construction allows it to be suitable for any hot and cold beverages. The steel filter is another technological godsend for separating the pulp from juices or making tea without the bad.\r\nBut the flagship technology of this product are the digital, touch powered temperature sensors. Knowing how hot or cold your water or beverages are is a vital quality that facilitates responsible consumption. For peak performance, this sensitive smart bottle is battery powered, durable, and easy to clean.\r\nColor	\r\nBlack, White, Red', 'storage/products/prod_68fb6fc3964659.66043622.webp', 1, NULL, 'storage/products/prod_68fb6fc3966b09.75009264.webp', 'storage/products/prod_68fb6fc3967f30.79184460.webp', 'storage/products/prod_68fb6fc3969224.04907406.webp', '', '', '', 1),
(53, 'Customized USB Flash Drives with Logo', 2200.00, 'active', '2025-09-29 16:41:19', 'Personalized Metallic USB: Seamlessly Blend Functionality and Branding\r\n\r\nImagine a USB drive that not only serves as a convenient data storage solution but also carries your name or logo, adding a touch of professionalism and personalization to your digital world. Welcome to the world of Personalized Metallic USB drives?where utility meets branding.\r\n\r\n1. Your Signature Statement: These metallic USB drives are not just data storage devices; they\'re a statement of identity. Your name or logo etched onto the sleek metallic surface turns each drive into a unique piece, reflecting your individuality or brand identity.\r\n\r\n2. Multi-Purpose Versatility: Beyond data storage, these USB drives come with an ingenious twist. They are designed with an attached keyring loop, offering you the option to use them as keychains. This duality means you can conveniently carry your keys and important digital files together, streamlining your essentials.\r\n\r\n3. Durability and Style: Crafted from high-quality metallic materials, these USB drives are built to withstand everyday wear and tear. The robust construction not only ensures their longevity but also adds a touch of elegance to your digital accessories.\r\n\r\n4. Marketing and Branding: For businesses and organizations, these personalized USB drives are an effective marketing tool. They serve as memorable giveaways at events, promotional items, or corporate gifts, helping to enhance brand recognition and loyalty.\r\n\r\n5. Practical Gifting: On a personal level, they make for thoughtful and practical gifts for friends, family, or colleagues. Customize them with the recipient\'s name or a meaningful message for a gift that leaves a lasting impression.\r\n\r\nSize	\r\n16GB, 32GB, 64GB', 'storage/products/prod_69b2a35a47a757.84581431.jpg', 1, NULL, 'storage/products/prod_68fb6ea0c831c4.15456351.webp', 'storage/products/prod_68fb6ea0c84ab5.86812938.webp', 'storage/products/prod_68fb6ea0c86027.72235505.webp', '', '', '', 1),
(61, 'Custom File Cover Printing', 150.00, 'active', '2025-11-06 07:12:24', 'Custom File Cover Printing for all your professional and organizational needs. High-quality printing, available in A4 size and various materials. No Minimum Quantity Required! Print exactly what you need, even just one piece. Perfect for businesses, schools, and personal use.', 'storage/products/prod_69b2a2e292e337.82866121.jpg', 1, NULL, NULL, NULL, NULL, '', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `quotations`
--

CREATE TABLE `quotations` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL DEFAULT 1,
  `quote_no` varchar(40) NOT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('draft','sent','accepted','paid') DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quotations`
--

INSERT INTO `quotations` (`id`, `tenant_id`, `quote_no`, `customer_name`, `total`, `status`, `created_at`) VALUES
(14, 1, 'QUO-20260310103658-112', NULL, 31420.00, '', '2026-03-10 10:36:58'),
(16, 1, 'QUO-20260325105137-996', NULL, 6034.00, '', '2026-03-25 10:51:37'),
(17, 1, 'QUO-20260325105225-144', NULL, 15000.00, '', '2026-03-25 10:52:25'),
(18, 1, 'QUO-20260329140916-993', NULL, 147500.00, '', '2026-03-29 14:09:16');

-- --------------------------------------------------------

--
-- Table structure for table `quotations_items`
--

CREATE TABLE `quotations_items` (
  `id` int(11) NOT NULL,
  `quotation_id` int(11) NOT NULL,
  `tenant_id` int(11) DEFAULT 1,
  `product_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `line_total` decimal(10,2) NOT NULL,
  `tax_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quotations_items`
--

INSERT INTO `quotations_items` (`id`, `quotation_id`, `tenant_id`, `product_id`, `description`, `quantity`, `price`, `line_total`, `tax_percent`, `tax_amount`) VALUES
(77, 14, 1, 51, 'Customized Clocks Printing: Timeless Branding for Your Business', 20, 1560.00, 31200.00, 0.00, 0.00),
(78, 14, 1, 16, 'Magazine Printing', 1, 210.00, 210.00, 0.00, 0.00),
(79, 14, 1, 17, 'Calendar Printing', 1, 10.00, 10.00, 0.00, 0.00),
(82, 16, 1, NULL, 'A4 COLOR PRINT', 431, 14.00, 6034.00, 0.00, 0.00),
(84, 17, 1, NULL, 'A4 Doctor File / File Cover (250 grm)', 300, 50.00, 15000.00, 0.00, 0.00),
(94, 18, 1, NULL, '9 X 4 Envolepe 80gm', 1000, 9.00, 9000.00, 0.00, 0.00),
(95, 18, 1, NULL, 'A4 Size Pocket File wtih 4 Color Printing Lamination', 500, 75.00, 37500.00, 0.00, 0.00),
(96, 18, 1, NULL, 'Flyer A3 Front and Back Side 128gm', 1000, 17.00, 17000.00, 0.00, 0.00),
(97, 18, 1, NULL, 'Catalog 5.5 X 8.5 22 pages paper 128 gsm', 500, 150.00, 75000.00, 0.00, 0.00),
(98, 18, 1, NULL, 'Letter Head 4K  paper 100 gsm with gum binding', 1000, 9.00, 9000.00, 0.00, 0.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `quotes`
-- (See below for the actual view)
--
CREATE TABLE `quotes` (
`id` int(11)
,`quote_no` varchar(40)
,`customer_name` varchar(200)
,`total` decimal(10,2)
,`status` enum('draft','sent','accepted','paid')
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `quote_items`
-- (See below for the actual view)
--
CREATE TABLE `quote_items` (
`id` int(11)
,`quote_id` int(11)
,`product_id` int(11)
,`description` text
,`quantity` int(11)
,`price` decimal(10,2)
,`line_total` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`id`, `name`, `slug`, `status`, `created_at`) VALUES
(1, 'Default Tenant', 'default', 'active', '2025-11-12 17:23:03');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(160) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin','developer','super_admin') NOT NULL DEFAULT 'user',
  `reset_token` varchar(64) DEFAULT NULL,
  `reset_expires` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `tenant_id` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `phone`, `password_hash`, `role`, `reset_token`, `reset_expires`, `created_at`, `tenant_id`) VALUES
(1, 'Super Admin', 'super@zakprinting.com', NULL, '$2y$10$Jq6xCTm.mct5QndiLSzctOLHU7oQ1VJoNpi8ktS1csloql42STwh.', 'super_admin', NULL, NULL, '2025-08-31 15:34:29', 1),
(2, 'Developer', 'dev@zakprinting.com', NULL, '$2b$12$6yLe6k6niefkBDOcP/MwR..UPbuezVSdAfFE1k7zdWv8rTbk5b4n.', 'developer', NULL, NULL, '2025-08-31 15:34:29', 1),
(3, 'Abdullah', 'AbdullahAzeem59@outlook.com', NULL, '$2y$10$JBaCOfwlu6xjoooAmBoR7OiEdYra9eumfrRWgArJ2IKjvDqncHDyW', 'admin', NULL, NULL, '2025-08-31 16:58:33', 1),
(4, 'Mujeeb', 'Mujeeb@zakprinting.com', NULL, '$2y$10$MLI3fDqXCheAZPHB09oPo.44T/EFADNnUNE.FX6brv/lru4rEhA/.', 'admin', NULL, NULL, '2025-09-01 09:28:51', 1),
(5, 'Asif', 'asif@zakprinting.com', NULL, '$2y$10$3ZxDsx6MiK1p01KksdHEzeHhk7Zj4kFy5IEVsKUIsD/EOxLik3yT.', 'admin', NULL, NULL, '2025-09-01 09:29:23', 1),
(6, 'Zafar Iqbal', 'zafar@zakprinting.com', NULL, '$2y$10$iTDnjXU0aoqUHYUMixS4RekILswRlFOojxGT2eFzwfOLeDpIrkNG.', 'admin', NULL, NULL, '2025-09-01 09:29:46', 1),
(7, 'zak Media Pvt. Ltd', 'ar.kashifyaqoob@gmail.com', NULL, '$2y$10$viu5dKsoGsHC2uV.N8.oUetxD15.kswnR/s09f4kaPOQqkL5M.Es6', 'admin', NULL, NULL, '2025-09-03 06:48:18', 1),
(25, 'Imran sab', 'imran@zakprinting.com', NULL, '$2y$10$ndr4ZRSm6QHX3MZfvlZXOOL0WsPhWGHwYQDhaZ2z5XYAviIiIqCPu', 'admin', NULL, NULL, '2026-02-23 08:31:27', 1),
(26, 'Kashif Yaqoob', 'dell@zakprinting.com', '309654946', '$2y$10$//07qCUkCPTaUXkNa1mC4uShUiiCz02O.UrRyDRdOZXBecqFtk2iG', 'user', NULL, NULL, '2026-03-03 10:12:14', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `billing_profiles`
--
ALTER TABLE `billing_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bp_tenant` (`tenant_id`),
  ADD KEY `idx_bp_owner` (`owner_user_id`);

--
-- Indexes for table `cms_blocks`
--
ALTER TABLE `cms_blocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_page_block` (`page_id`,`block_key`);

--
-- Indexes for table `cms_pages`
--
ALTER TABLE `cms_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `finance_cash_entries`
--
ALTER TABLE `finance_cash_entries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `finance_products`
--
ALTER TABLE `finance_products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_no` (`invoice_no`),
  ADD KEY `idx_invoices_tenant` (`tenant_id`),
  ADD KEY `idx_invoices_created_by` (`created_by`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `invoice_payments`
--
ALTER TABLE `invoice_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Indexes for table `invoice_settings`
--
ALTER TABLE `invoice_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_orders_tenant` (`tenant_id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_pages_tenant_key` (`tenant_id`,`key`),
  ADD KEY `idx_pages_updated_by` (`updated_by`),
  ADD KEY `idx_pages_tenant` (`tenant_id`);

--
-- Indexes for table `page_assets`
--
ALTER TABLE `page_assets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_page_asset` (`tenant_id`,`page_key`,`asset_key`),
  ADD KEY `idx_page_assets_tenant` (`tenant_id`),
  ADD KEY `idx_page_assets_updated_by` (`updated_by`);

--
-- Indexes for table `pricing_plans`
--
ALTER TABLE `pricing_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_tenant_key` (`tenant_id`,`key`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_products_featured` (`is_featured`,`featured_order`,`created_at`),
  ADD KEY `idx_products_tenant` (`tenant_id`);

--
-- Indexes for table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quote_no` (`quote_no`),
  ADD KEY `idx_quotations_tenant` (`tenant_id`);

--
-- Indexes for table `quotations_items`
--
ALTER TABLE `quotations_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_qi_quotation` (`quotation_id`),
  ADD KEY `idx_qi_product` (`product_id`),
  ADD KEY `idx_qi_tenant` (`tenant_id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_phone` (`phone`),
  ADD KEY `idx_users_tenant` (`tenant_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `billing_profiles`
--
ALTER TABLE `billing_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `cms_blocks`
--
ALTER TABLE `cms_blocks`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cms_pages`
--
ALTER TABLE `cms_pages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=161;

--
-- AUTO_INCREMENT for table `finance_cash_entries`
--
ALTER TABLE `finance_cash_entries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `finance_products`
--
ALTER TABLE `finance_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=300;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3398;

--
-- AUTO_INCREMENT for table `invoice_payments`
--
ALTER TABLE `invoice_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=242;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `page_assets`
--
ALTER TABLE `page_assets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pricing_plans`
--
ALTER TABLE `pricing_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `quotations_items`
--
ALTER TABLE `quotations_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

-- --------------------------------------------------------

--
-- Structure for view `quotes`
--
DROP TABLE IF EXISTS `quotes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`u625466827_zakprint`@`127.0.0.1` SQL SECURITY INVOKER VIEW `quotes`  AS SELECT `q`.`id` AS `id`, `q`.`quote_no` AS `quote_no`, `q`.`customer_name` AS `customer_name`, `q`.`total` AS `total`, `q`.`status` AS `status`, `q`.`created_at` AS `created_at` FROM `quotations` AS `q` ;

-- --------------------------------------------------------

--
-- Structure for view `quote_items`
--
DROP TABLE IF EXISTS `quote_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`u625466827_zakprint`@`127.0.0.1` SQL SECURITY INVOKER VIEW `quote_items`  AS SELECT `qi`.`id` AS `id`, `qi`.`quotation_id` AS `quote_id`, `qi`.`product_id` AS `product_id`, `qi`.`description` AS `description`, `qi`.`quantity` AS `quantity`, `qi`.`price` AS `price`, `qi`.`line_total` AS `line_total` FROM `quotations_items` AS `qi` ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing_profiles`
--
ALTER TABLE `billing_profiles`
  ADD CONSTRAINT `fk_bp_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_bp_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cms_blocks`
--
ALTER TABLE `cms_blocks`
  ADD CONSTRAINT `fk_cms_blocks_page` FOREIGN KEY (`page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoices_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_invoices_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `invoice_payments`
--
ALTER TABLE `invoice_payments`
  ADD CONSTRAINT `invoice_payments_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `pages`
--
ALTER TABLE `pages`
  ADD CONSTRAINT `fk_pages_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pages_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pages_updated_by_users` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `page_assets`
--
ALTER TABLE `page_assets`
  ADD CONSTRAINT `fk_page_assets_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_page_assets_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `page_assets_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `page_assets_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `quotations`
--
ALTER TABLE `quotations`
  ADD CONSTRAINT `fk_quotations_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quotations_items`
--
ALTER TABLE `quotations_items`
  ADD CONSTRAINT `fk_qi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_qi_quotation` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
