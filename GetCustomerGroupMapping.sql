-- --------------------------------------------------------------
-- Use this query when you have a MySQL database
-- --------------------------------------------------------------
SELECT 
    kg.PartnerGruppeID       AS "Customer group ID",
    kg.gruppenname           AS "Customer group name",
    kg.AnlageDatum			     AS "Customer group creation date",
    kg.ZeitDerAenderung		   AS "Customer group last change date",
    kg.memo                  AS "Customer Group memo",
    GROUP_CONCAT(
        DISTINCT CONCAT(k.vorname, ' ', k.nachname)
        ORDER BY k.nachname
        SEPARATOR ', '
    )                        AS "Customers"
FROM kundengruppe kg
LEFT JOIN kundengruppenzuordnung kgz ON kg.PartnerGruppeID = kgz.PartnerGruppeID
LEFT JOIN kunde k ON kgz.MainID = k.kundeid
GROUP BY kg.PartnerGruppeID, kg.gruppenname, kg.memo;


-- --------------------------------------------------------------
-- Use this query when you have a SQL Server database
-- --------------------------------------------------------------
SELECT
    kg.PartnerGruppeID                       AS [Customer group ID],
    CAST(kg.gruppenname AS NVARCHAR(MAX))    AS [Customer group name],
    CAST(kg.memo AS NVARCHAR(MAX))           AS [Customer group memo],
	  kg.Anlagedatum                           AS [Customer group creation date],
	  kg.ZeitDerAenderung                      AS [Customer group last change date],
    STRING_AGG(T1.CustomerFullName,', ') 
      WITHIN GROUP (ORDER BY T1.SortLastName)
                                             AS [Customers]
FROM
    kundengruppe AS kg
LEFT JOIN
    (
        SELECT DISTINCT
            kgz.PartnerGruppeID,
            CONCAT(CAST(k.vorname AS NVARCHAR(MAX)), ' ', CAST(k.nachname AS NVARCHAR(MAX))) AS CustomerFullName,
            CAST(k.nachname AS NVARCHAR(MAX)) AS SortLastName
        FROM
            kundengruppenzuordnung AS kgz
        JOIN
            kunde AS k ON kgz.MainID = k.kundeid
        WHERE
            k.kundeid IS NOT NULL
    ) AS T1 ON kg.PartnerGruppeID = T1.PartnerGruppeID
GROUP BY
    kg.PartnerGruppeID,
    CAST(kg.gruppenname AS NVARCHAR(MAX)),
    CAST(kg.memo AS NVARCHAR(MAX)),
	kg.AnlageDatum,
	kg.ZeitDerAenderung
ORDER BY kg.PartnerGruppeID; 
