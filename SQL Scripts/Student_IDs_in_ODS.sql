<<<<<<< HEAD:SQL Scripts/Show_Student_IDs_in_ODS.sql
------------------------------------------------------
--TITLE: Show Student IDs in ODS
------------------------------------------------------

------------------------------------------------------------------------------------------
--PURPOSE: Use these queries to reveal the ID's that each student have in the ODS. 
------------------------------------------------------------------------------------------

-------------------------------------------------------------
--Knowledge of these tables is needed:
	--SELECT * from edfi.Descriptor where Namespace like '%studentIdentificationSystem%'
    --SELECT * from edfi.StudentEducationOrganizationAssociation
	--SELECT * from edfi.StudentEducationOrganizationAssociationStudentIdentificationCode  --This table contains the ID's for each student
-------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------


--Shows the ID code values available in the ODS
SELECT DISTINCT
    d.CodeValue AS StudentIdentificationSystemDescriptor_CodeValue
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
INNER JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId

--Identifies the Organizations who assign each code
SELECT DISTINCT
    AssigningOrganizationIdentificationCode
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
INNER JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId

--Shows each student and the ID's they have associated with to them in the ODS
SELECT
    s.StudentUSI,
    s.StudentUniqueId,
    seoasic.AssigningOrganizationIdentificationCode,
    seoasic.EducationOrganizationId,
    seoasic.IdentificationCode,
    d.CodeValue AS StudentIdentificationSystemDescriptor_CodeValue,
    d.Description AS StudentIdentificationSystemDescriptor_Description
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
LEFT JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId
=======
SELECT DISTINCT
    d.CodeValue AS StudentIdentificationSystemDescriptor_CodeValue
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
INNER JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId


SELECT DISTINCT
    AssigningOrganizationIdentificationCode
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
INNER JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId


SELECT
    s.StudentUSI,
    s.StudentUniqueId,
    seoasic.AssigningOrganizationIdentificationCode,
    seoasic.EducationOrganizationId,
    seoasic.IdentificationCode,
    d.CodeValue AS StudentIdentificationSystemDescriptor_CodeValue,
    d.Description AS StudentIdentificationSystemDescriptor_Description
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
LEFT JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId
>>>>>>> fde31e9aa4bd6d27e8e2943024952ef982262c8f:SQL Scripts/Student_IDs_in_ODS.sql
