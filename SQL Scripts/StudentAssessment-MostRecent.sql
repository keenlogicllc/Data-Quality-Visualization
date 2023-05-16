/****** Script for SelectTopNRows command from SSMS  ******/
SELECT S.LastSurname,S.FirstName,S.MiddleName,S.StudentUniqueId, SA.*
  FROM [EdFi_Ods].[edfi].[StudentAssessment] SA
  LEFT JOIN EdFi_Ods.edfi.Student S ON
  SA.StudentUSI = S.StudentUSI
  ORDER BY LastModifiedDate DESC