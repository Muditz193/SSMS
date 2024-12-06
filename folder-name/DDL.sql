USE top_2k;
GO

/*********************************************************/
/******************    Schema DDL       ******************/
/*********************************************************/

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dim') 
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA dim AUTHORIZATION dbo;'
END;

GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'f') 
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA f AUTHORIZATION dbo;'
END;

GO

/*********************************************************/
/****************** Industry DIM DDL *********************/
/*********************************************************/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dim' AND TABLE_NAME = 'Industry')
BEGIN
    CREATE TABLE dim.Industry (
        IndustryID BIGINT NOT NULL,
        Industry NVARCHAR(MAX) NULL
    );

    ALTER TABLE dim.Industry
    ADD CONSTRAINT PK_Industry PRIMARY KEY (IndustryID);
END;

GO

/*********************************************************/
/****************** Country DIM DDL **********************/
/*********************************************************/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dim' AND TABLE_NAME = 'Country')
BEGIN
    CREATE TABLE dim.Country (
        CountryID BIGINT NOT NULL,
        Country NVARCHAR(MAX) NULL
    );

    ALTER TABLE dim.Country
    ADD CONSTRAINT PK_Country PRIMARY KEY (CountryID);
END;

GO

/*********************************************************/
/****************** Organization DIM DDL **********************/
/*********************************************************/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dim' AND TABLE_NAME = 'Organization')
BEGIN
    CREATE TABLE dim.Organization (
        OrganizationID BIGINT NOT NULL,
        Organization NVARCHAR(MAX) NULL
    );

    ALTER TABLE dim.Organization
    ADD CONSTRAINT PK_Organization PRIMARY KEY (OrganizationID);
END;

GO



/*********************************************************/
/************* Company Fact Table DDL ********************/
/*********************************************************/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'f' AND TABLE_NAME = 'Company')
BEGIN
    CREATE TABLE f.Company (
        CompanyID BIGINT NOT NULL,
        OrganizationName NVARCHAR(MAX) NULL,
        IndustryID BIGINT NULL,
        CountryID BIGINT NULL,
        OrganizationID BIGINT NULL,
        Revenue DECIMAL(19,4) NULL,
        Profits DECIMAL(19,4) NULL,
        Assets DECIMAL(19,4) NULL,
        MarketValue DECIMAL(19,4) NULL,
        TotalEmployees BIGINT NULL
    );

    ALTER TABLE f.Company
    ADD CONSTRAINT PK_Company PRIMARY KEY (CompanyID);

    ALTER TABLE f.Company
    ADD CONSTRAINT FK_Company_Industry FOREIGN KEY (IndustryID)
    REFERENCES dim.Industry (IndustryID);

    ALTER TABLE f.Company
    ADD CONSTRAINT FK_Company_Country FOREIGN KEY (CountryID)
    REFERENCES dim.Country (CountryID);

	ALTER TABLE f.Company
    ADD CONSTRAINT FK_Company_Organization FOREIGN KEY (OrganizationID)
    REFERENCES dim.Organization (OrganizationID);

END;

GO
