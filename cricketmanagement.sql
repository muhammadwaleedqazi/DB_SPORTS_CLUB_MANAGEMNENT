--Create database sportsclubdb2;

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'sportsclub_user')
BEGIN
    PRINT 'Creating SQL Server Login: sportsclub_user...';
    CREATE LOGIN sportsclub_user WITH PASSWORD = 'SecurePassword123';
END
GO
ALTER LOGIN sportsclub_user ENABLE;
GO
USE SPORTSCLUBDBMS;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'sportsclub_user')
BEGIN
    PRINT 'Creating Database User sportsclub_user in sportsclub_db...';
    CREATE USER sportsclub_user FOR LOGIN sportsclub_user;
    GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO sportsclub_user;
END
GO

-- 1. sc_Club (Clubs)
CREATE TABLE sc_Club (
    club_id INT IDENTITY(1,1) PRIMARY KEY,
    club_name NVARCHAR(50) NOT NULL,
    location NVARCHAR(200) NOT NULL
);
INSERT INTO sc_Club (club_name, location) VALUES
('Lahore Qalandars', 'Lahore'),
('Karachi Kings', 'Karachi'),
('Islamabad United', 'Islamabad'),
('Peshawar Zalmi', 'Peshawar'),
('Multan Sultans', 'Multan');

-- 2. sc_Team (Teams)
CREATE TABLE sc_Team (
    team_id INT IDENTITY(1,1) PRIMARY KEY,
    team_name NVARCHAR(50) NOT NULL,
    club_id INT NOT NULL,
    FOREIGN KEY (club_id) REFERENCES sc_Club(club_id)
);
INSERT INTO sc_Team (team_name, club_id) VALUES
('Qalandars Main', 1),
('Qalandars U19', 1),
('Kings Main', 2),
('United Main', 3),
('Zalmi Main', 4);

-- 3. sc_Player (Players)
CREATE TABLE sc_Player (
    player_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone_number NVARCHAR(20) NOT NULL UNIQUE,
    nationality NVARCHAR(50) NOT NULL,
    dob DATE NOT NULL
);
INSERT INTO sc_Player (first_name, last_name, email, phone_number, nationality, dob) VALUES
('Babar', 'Azam', 'babar.azam@psl.com', '+923001234567', 'Pakistani', '1994-10-15'),
('Shaheen', 'Afridi', 'shaheen.afridi@psl.com', '+923007654321', 'Pakistani', '2000-04-06'),
('Mohammad', 'Rizwan', 'rizwan@psl.com', '+923001112233', 'Pakistani', '1992-06-01'),
('Shadab', 'Khan', 'shadab@psl.com', '+923004445566', 'Pakistani', '1998-10-04'),
('Fakhar', 'Zaman', 'fakhar@psl.com', '+923007778899', 'Pakistani', '1990-04-10');

-- 4. sc_Venue (Venues)
CREATE TABLE sc_Venue (
    venue_id INT IDENTITY(1,1) PRIMARY KEY,
    venue_name NVARCHAR(200) NOT NULL,
    location NVARCHAR(200) NOT NULL,
    capacity INT NULL
);
INSERT INTO sc_Venue (venue_name, location, capacity) VALUES
('Gaddafi Stadium', 'Lahore', 27000),
('National Stadium', 'Karachi', 34228),
('Rawalpindi Cricket Stadium', 'Rawalpindi', 15000),
('Multan Cricket Stadium', 'Multan', 30000),
('Arbab Niaz Stadium', 'Peshawar', 20000);

-- 5. sc_Tournaments (Tournaments)
CREATE TABLE sc_Tournaments (
    tournament_id INT IDENTITY(1,1) PRIMARY KEY,
    tournament_name NVARCHAR(200) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);
INSERT INTO sc_Tournaments (tournament_name, start_date, end_date) VALUES
('Pakistan Super League 2024', '2024-02-17', '2024-03-18'),
('National T20 Cup 2023', '2023-11-15', '2023-12-01'),
('Quaid-e-Azam Trophy 2023', '2023-10-10', '2023-12-10'),
('Pakistan Cup 2023', '2023-01-10', '2023-01-30'),
('Patron''s Trophy 2023', '2023-02-15', '2023-03-20');

-- 6. sc_Matches (Matches)
CREATE TABLE sc_Matches (
    match_id INT IDENTITY(1,1) PRIMARY KEY,
    match_date DATE NOT NULL,
    home_team_id INT NOT NULL,
    away_team_id INT NOT NULL,
    result NVARCHAR(50) NULL,
    venue_id INT NOT NULL,
    tournament_id INT NULL,
    FOREIGN KEY (venue_id) REFERENCES sc_Venue(venue_id),
    FOREIGN KEY (home_team_id) REFERENCES sc_Team(team_id),
    FOREIGN KEY (away_team_id) REFERENCES sc_Team(team_id),
    FOREIGN KEY (tournament_id) REFERENCES sc_Tournaments(tournament_id)
);
INSERT INTO sc_Matches (match_date, home_team_id, away_team_id, result, venue_id, tournament_id) VALUES
('2024-02-17', 1, 3, 'Lahore Qalandars won', 1, 1),
('2024-02-18', 3, 5, 'Karachi Kings won', 2, 1),
('2024-02-20', 5, 1, 'Islamabad United won', 3, 1),
('2024-02-22', 2, 4, 'Lahore Qalandars U19 won', 1, 1),
('2024-02-25', 4, 2, 'United Main won', 4, 1);

-- 7. sc_Contracts (Contracts)
CREATE TABLE sc_Contracts (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT NOT NULL,
    team_id INT NOT NULL,
    club_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NULL,
    FOREIGN KEY (player_id) REFERENCES sc_Player(player_id),
    FOREIGN KEY (team_id) REFERENCES sc_Team(team_id),
    FOREIGN KEY (club_id) REFERENCES sc_Club(club_id)
);
INSERT INTO sc_Contracts (player_id, team_id, club_id, start_date, end_date, total_amount) VALUES
(1, 1, 1, '2024-01-01', '2024-12-31', 5000000.00),
(2, 1, 1, '2024-01-01', '2024-12-31', 4500000.00),
(3, 3, 2, '2024-01-01', '2024-12-31', 4800000.00),
(4, 5, 3, '2024-01-01', '2024-12-31', 4200000.00),
(5, 1, 1, '2024-01-01', '2024-12-31', 3800000.00);

-- 8. sc_Awards (Awards)
CREATE TABLE sc_Awards (
    award_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT NOT NULL,
    award_name NVARCHAR(200) NOT NULL,
    award_date DATE NOT NULL,
    match_id INT NULL,
    FOREIGN KEY (player_id) REFERENCES sc_Player(player_id),
    FOREIGN KEY (match_id) REFERENCES sc_Matches(match_id)
);
INSERT INTO sc_Awards (player_id, award_name, award_date, match_id) VALUES
(1, 'Player of the Match', '2024-02-17', 1),
(2, 'Best Bowler', '2024-02-18', 2),
(3, 'Player of the Tournament', '2024-03-18', NULL),
(4, 'Emerging Player', '2024-02-20', 3),
(5, 'Fastest Century', '2024-02-25', 5);

-- 9. sc_Scorer (Scorer Stats)
CREATE TABLE sc_Scorer (
    scorer_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT NOT NULL,
    match_id INT NOT NULL,
    runs INT DEFAULT 0,
    wickets INT DEFAULT 0,
    catches INT DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES sc_Player(player_id),
    FOREIGN KEY (match_id) REFERENCES sc_Matches(match_id)
);
INSERT INTO sc_Scorer (player_id, match_id, runs, wickets, catches) VALUES
(1, 1, 85, 0, 2),
(2, 2, 15, 3, 1),
(3, 3, 67, 0, 1),
(4, 4, 42, 2, 0),
(5, 5, 104, 0, 0);

-- 10. sc_Coaches (Coaches)
CREATE TABLE sc_Coaches (
    coach_id INT IDENTITY(1,1) PRIMARY KEY,
    team_id INT NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    specialization NVARCHAR(100) NOT NULL,
    FOREIGN KEY (team_id) REFERENCES sc_Team(team_id)
);
INSERT INTO sc_Coaches (team_id, full_name, specialization) VALUES
(1, 'Aaqib Javed', 'Bowling'),
(2, 'Mohammad Hafeez', 'Batting'),
(3, 'Dean Jones', 'Fielding'),
(4, 'Mushtaq Ahmed', 'Spin Bowling'),
(5, 'Misbah-ul-Haq', 'Batting');

-- 11. sc_Sponsors (Sponsors)
CREATE TABLE sc_Sponsors (
    sponsor_id INT IDENTITY(1,1) PRIMARY KEY,
    sponsor_name NVARCHAR(200) NOT NULL UNIQUE,
    club_id INT NOT NULL,
    contract_amount DECIMAL(12,2) NULL,
    FOREIGN KEY (club_id) REFERENCES sc_Club(club_id)
);
INSERT INTO sc_Sponsors (sponsor_name, club_id, contract_amount) VALUES
('Jazz', 1, 10000000.00),
('HBL', 2, 8500000.00),
('Pepsi', 3, 9000000.00),
('Tapal Tea', 4, 7500000.00),
('UBL', 5, 8000000.00);

-- 12. sc_Login (Login)
CREATE TABLE sc_Login (
    login_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password CHAR(64) NOT NULL,
    user_type NVARCHAR(20) NOT NULL,
    player_id INT NULL,
    coach_id INT NULL,
    FOREIGN KEY (player_id) REFERENCES sc_Player(player_id),
    FOREIGN KEY (coach_id) REFERENCES sc_Coaches(coach_id)
);
INSERT INTO sc_Login (username, password, user_type, player_id, coach_id) VALUES
('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin', NULL, NULL),
('babar', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'player', 1, NULL),
('shaheen', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'player', 2, NULL),
('aaqib', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'coach', NULL, 1),
('misbah', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'coach', NULL, 5);

-- 13. sc_Injuries (Injuries - Added for 3NF)
CREATE TABLE sc1_Injuries (
    injury_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT NOT NULL,
    description NVARCHAR(100) NOT NULL,
    recovery_status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (player_id) REFERENCES sc_Player(player_id)
);
INSERT INTO sc1_Injuries (player_id, description, recovery_status) VALUES
(2, 'Shoulder Injury', 'Recovering'),
(3, 'Knee Injury', 'Recovered'),
(4, 'Ankle Sprain', 'Under Treatment'),
(5, 'Back Strain', 'Recovered'),
(1, 'Hamstring Pull', 'Recovered');
select*from sys.tables;
-- STORED PROCEDURE 1: Register New Player
GO
CREATE PROCEDURE sp_RegisterPlayer
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @phone_number NVARCHAR(20),
    @nationality NVARCHAR(50),
    @dob DATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM sc_Player WHERE email = @email OR phone_number = @phone_number)
            THROW 50001, 'Email or phone number already exists.', 1;
        INSERT INTO sc_Player (first_name, last_name, email, phone_number, nationality, dob)
        VALUES (@first_name, @last_name, @email, @phone_number, @nationality, @dob);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
-- STORED PROCEDURE 2: Get Match Summary by Tournament
GO
CREATE PROCEDURE sp_GetTournamentMatches
    @tournament_id INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM sc_Tournaments WHERE tournament_id = @tournament_id)
            THROW 50002, 'Tournament not found.', 1;
        SELECT 
            m.match_id,
            m.match_date,
            ht.team_name AS home_team,
            at.team_name AS away_team,
            m.result,
            v.venue_name
        FROM sc_Matches m
        JOIN sc_Team ht ON m.home_team_id = ht.team_id
        JOIN sc_Team at ON m.away_team_id = at.team_id
        JOIN sc_Venue v ON m.venue_id = v.venue_id
        WHERE m.tournament_id = @tournament_id;
        IF @@ROWCOUNT = 0
            PRINT 'No matches found for this tournament.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
--Trigger 1
USE sportsclubdb2;  -- Make sure you're in the correct database
GO

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'sc_Injuries';
EXEC sp_help 'sc_Injuries';
USE sportsclubdb2;
GO

-- 1. Ensure required tables exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sc_Injuries')
BEGIN
    CREATE TABLE sc_Injuries (
        injury_id INT IDENTITY(1,1) PRIMARY KEY,
        player_id INT NOT NULL,
        description NVARCHAR(100) NOT NULL,
        recovery_status NVARCHAR(50) NOT NULL,
        FOREIGN KEY (player_id) REFERENCES sc_Player(player_id)
    );
    
    PRINT 'Created sc_Injuries table';
END
GO

-- 2. Add required columns if missing
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('sc_Player') AND name = 'is_injured'
)
BEGIN
    ALTER TABLE sc_Player ADD 
        is_injured BIT DEFAULT 0,
        last_injury_update DATETIME NULL;
    
    PRINT 'Added injury columns to sc_Player';
END
GO

-- 3. Create the trigger
CREATE OR ALTER TRIGGER trg_UpdatePlayerAvailability
ON sc1_Injuries
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update player availability status
        UPDATE p
        SET is_injured = CASE 
                            WHEN i.recovery_status = 'Recovered' THEN 0 
                            ELSE 1 
                         END,
            last_injury_update = GETDATE()
        FROM sc_Player p
        JOIN inserted i ON p.player_id = i.player_id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        PRINT 'Error in trg_UpdatePlayerAvailability: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

PRINT 'Trigger trg_UpdatePlayerAvailability created successfully';

--trigger2
USE sportsclubdb2;
GO

-- 1. Ensure required tables exist (sc_Contracts already exists, confirming structure)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sc_Contracts')
BEGIN
    CREATE TABLE sc_Contracts (
        contract_id INT IDENTITY(1,1) PRIMARY KEY,
        player_id INT NOT NULL,
        team_id INT NOT NULL,
        club_id INT NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        total_amount DECIMAL(12,2) NULL,
        FOREIGN KEY (player_id) REFERENCES sc_Player(player_id),
        FOREIGN KEY (team_id) REFERENCES sc_Team(team_id),
        FOREIGN KEY (club_id) REFERENCES sc_Club(club_id)
    );
    PRINT 'Created sc_Contracts table';
END
GO

-- 2. Add required column if missing (contract_status)
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('sc_Contracts') AND name = 'contract_status'
)
BEGIN
    ALTER TABLE sc_Contracts ADD 
        contract_status NVARCHAR(20) DEFAULT 'Active';
    
    PRINT 'Added contract_status column to sc_Contracts';
END
GO

-- 3. Create the trigger
CREATE OR ALTER TRIGGER trg_UpdateContractStatus
ON sc_Contracts
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update contract status based on end_date
        UPDATE c
        SET contract_status = CASE 
                                WHEN c.end_date < GETDATE() THEN 'Expired'
                                WHEN c.end_date >= GETDATE() THEN 'Active'
                                ELSE 'Pending'
                             END
        FROM sc_Contracts c
        JOIN inserted i ON c.contract_id = i.contract_id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        PRINT 'Error in trg_UpdateContractStatus: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

PRINT 'Trigger trg_UpdateContractStatus created successfully';

-- CRUD Operations Documentation
-- ======================================
-- 1. sc_Player Table
-- Create: Insert a new player with transaction safety
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO sc_Player (first_name, last_name, email, phone_number, nationality, dob)
    VALUES ('Imran', 'Khan', 'imran.khan@psl.com', '+923008887766', 'Pakistani', '1985-11-25');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
-- Explanation: Ensures data integrity with transaction; checks for unique constraints via procedure.

-- Read: Retrieve all active players
SELECT * FROM sc_Player WHERE dob <= GETDATE();
-- Explanation: Filters players by current date for active status.

-- Update: Modify player phone number
UPDATE sc_Player
SET phone_number = '+923001111222'
WHERE email = 'imran.khan@psl.com' AND EXISTS (SELECT 1 FROM sc_Player WHERE email = 'imran.khan@psl.com');
-- Explanation: Updates only if email exists, maintaining data consistency.

-- Delete: Remove a player
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM sc_Player WHERE email = 'imran.khan@psl.com';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
-- Explanation: Safely deletes with transaction, avoiding partial updates.

-- 2. sc_Club Table
-- Create: Add a new club
INSERT INTO sc_Club (club_name, location) VALUES ('Quetta Gladiators', 'Quetta');
-- Explanation: Simple insertion with unique constraint.

-- Read: List all clubs
SELECT * FROM sc_Club ORDER BY club_name;
-- Explanation: Ordered for clarity.

-- Update: Update club location
UPDATE sc_Club
SET location = 'Quetta City'
WHERE club_name = 'Quetta Gladiators' AND EXISTS (SELECT 1 FROM sc_Club WHERE club_name = 'Quetta Gladiators');
-- Explanation: Ensures club exists.

-- Delete: Remove a club
DELETE FROM sc_Club
WHERE club_name = 'Quetta Gladiators' AND NOT EXISTS (SELECT 1 FROM sc_Team WHERE club_id = club_id);
-- Explanation: Prevents deletion if teams exist.
SELECT*FROM sys.tables;
select*from sc_player;
select*from sc_club;

select * from sys.triggers;