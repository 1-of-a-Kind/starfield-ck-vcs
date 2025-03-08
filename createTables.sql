USE AssetMetaDB;

-- Table: Asset
CREATE TABLE IF NOT EXISTS Asset (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  FullPath VARCHAR(1024) NOT NULL,
  UNIQUE KEY (FullPath)
);

-- Table: Tag
CREATE TABLE IF NOT EXISTS Tag (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  UNIQUE KEY (Name)
);

-- Table: User
CREATE TABLE IF NOT EXISTS User (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  UNIQUE KEY (Name)
);

-- Table: AssetTagLink
CREATE TABLE IF NOT EXISTS AssetTagLink (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  AssetId INT NOT NULL,
  TagId INT NOT NULL,
  Operation VARCHAR(255),
  UserId INT NOT NULL,
  UpdateDate DATETIME,
  -- Potential foreign keys
  FOREIGN KEY (AssetId) REFERENCES Asset(Id),
  FOREIGN KEY (TagId) REFERENCES Tag(Id),
  FOREIGN KEY (UserId) REFERENCES User(Id)
);

-- Table: AssetGroup
CREATE TABLE IF NOT EXISTS AssetGroup (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  UserId INT NOT NULL,
  Name VARCHAR(255) NOT NULL,
  FOREIGN KEY (UserId) REFERENCES User(Id)
);

-- Table: AssetGroupLink
CREATE TABLE IF NOT EXISTS AssetGroupLink (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  GroupId INT NOT NULL,
  Operation VARCHAR(255),
  UpdateDate DATETIME,
  FOREIGN KEY (GroupId) REFERENCES AssetGroup(Id)
);

-- Table: AssetPinLink
CREATE TABLE IF NOT EXISTS AssetPinLink (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  GroupId INT NOT NULL,
  AssetId INT NOT NULL,
  Operation VARCHAR(255),
  UpdateDate DATETIME,
  FOREIGN KEY (GroupId) REFERENCES AssetGroup(Id),
  FOREIGN KEY (AssetId) REFERENCES Asset(Id)
);
