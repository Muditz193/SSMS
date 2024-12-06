USE top_2k;
GO


/*********************************************************/
/*************** DML for Industry DIM Table **************/
/*********************************************************/

INSERT INTO dim.Industry (IndustryID, Industry)
SELECT DISTINCT 
       ROW_NUMBER() OVER (ORDER BY Industry) AS IndustryID, 
       Industry
FROM (
    SELECT DISTINCT Industry
    FROM stg.Forbes_2000_top_company_CLNQ11
    EXCEPT
    SELECT Industry
    FROM dim.Industry
) uniqueIndustries;
GO

/*********************************************************/
/*************** DML for Country DIM Table ***************/
/*********************************************************/

INSERT INTO dim.Country (CountryID, Country)
SELECT DISTINCT 
       ROW_NUMBER() OVER (ORDER BY Country) AS CountryID, 
       Country
FROM (
    SELECT DISTINCT Country
    FROM stg.Forbes_2000_top_company_CLNQ11
    EXCEPT
    SELECT Country
    FROM dim.Country
) uniqueCountries;
GO

/*********************************************************/
/************** DML for Organization DIM Table ***********/
/*********************************************************/

INSERT INTO dim.Organization (OrganizationID, Organization)
SELECT DISTINCT 
       ROW_NUMBER() OVER (ORDER BY [Organization Name]) AS OrganizationID, 
       [Organization Name]
FROM (
    SELECT DISTINCT [Organization Name]
    FROM stg.Forbes_2000_top_company_CLNQ11
    EXCEPT
    SELECT Organization
    FROM dim.Organization
) uniqueOrganizations;
GO


/*********************************************************/
/*************** DML for Company FACT Table **************/
/*********************************************************/


INSERT INTO f.Company (CompanyID, OrganizationName, IndustryID, CountryID, OrganizationID, Revenue, Profits, Assets, MarketValue, TotalEmployees)
SELECT DISTINCT 
       ROW_NUMBER() OVER (ORDER BY main.[2022 Ranking]) AS CompanyID,
       main.[Organization Name],
       dimInd.IndustryID,
       dimCtry.CountryID,
       dimOrg.OrganizationID,
       main.[Revenue (Billions)],
       main.[Profits (Billions)],
       main.[Assets (Billions)],
       main.[Market Value (Billions)],
       main.[Total Employees]
FROM stg.Forbes_2000_top_company_CLNQ11 main
LEFT JOIN dim.Industry dimInd ON main.Industry = dimInd.Industry
LEFT JOIN dim.Country dimCtry ON main.Country = dimCtry.Country
LEFT JOIN dim.Organization dimOrg ON main.[Organization Name] = dimOrg.Organization;
GO

