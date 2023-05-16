/****** Script for SelectTopNRows command from SSMS  ******/
USE EdFi_Ods
GO

SELECT Sch.LocalEducationAgencyId,
	   Sch.SchoolId,
	   EO.NameOfInstitution,
	   Stf.FirstName,
	   Stf.MiddleName,
	   Stf.LastSurname,
	   Stf.StaffUSI,
	   Stf.YearsOfPriorTeachingExperience,
	   Stf.HighlyQualifiedTeacher,
	   SEOAA.BeginDate AS AssignmentBeginDate,
	   SEOAA.EndDate AS AssignmentEndDate,
	   SCT.Description AS StaffType,
	   DstaffClass.CodeValue AS StateJobCode,
	   DstaffClass.Description AS StateJobDescription,
	   SEOAA.PositionTitle,
	   Dassign.Description AS HighestLevelofEducation,
	   SEOEA.EducationOrganizationId AS EmploymentSchool,
	   Demploy.Description As EmploymentStatus,
	   SEOEA.HireDate AS EmploymentHireDate,
	   SEOEA.EndDate AS EmploymentEndDate,
	   DempSep.Description AS SeparationReason

  FROM [EdFi_Ods].[edfi].[Staff] Stf
	FULL OUTER JOIN EdFi_Ods.edfi.StaffEducationOrganizationAssignmentAssociation SEOAA ON
		Stf.StaffUSI = SEOAA.StaffUSI
	Full OUTER JOIN EdFi_Ods.edfi.StaffEducationOrganizationEmploymentAssociation SEOEA ON
		Stf.StaffUSI = SEOEA.StaffUSI
	LEFT JOIN EdFi_Ods.edfi.School Sch ON
		SEOAA.EducationOrganizationId = Sch.SchoolId
	LEFT JOIN EdFi_Ods.edfi.EducationOrganization EO ON
		SEOAA.EducationOrganizationId = EO.EducationOrganizationId
  
	LEFT JOIN EdFi_Ods.edfi.Descriptor Dassign ON
		Dassign.DescriptorId = Stf.HighestCompletedLevelOfEducationDescriptorId
	LEFT JOIN EdFi_Ods.edfi.Descriptor Demploy ON
		Demploy.DescriptorId = SEOEA.EmploymentStatusDescriptorId
	LEFT JOIN EdFi_Ods.edfi.StaffClassificationDescriptor SCD ON
		 SEOAA.StaffClassificationDescriptorId = SCD.StaffClassificationDescriptorId
	LEFT JOIN EdFi_Ods.edfi.Descriptor DempSep ON
		DempSep.DescriptorId = SEOEA.SeparationReasonDescriptorId
	LEFT JOIN EdFi_Ods.edfi.Descriptor DstaffClass ON
		DstaffClass.DescriptorId = SEOAA.StaffClassificationDescriptorId
		
  
	LEFT JOIN EdFi_Ods.edfi.StaffClassificationType SCT ON
		SCD.StaffClassificationTypeId = SCT.StaffClassificationTypeId

  WHERE SEOAA.EndDate IS NOT NULL 
  --AND SCT.Description = 'Principal'
  --AND Dassign.Description = 'Did Not Graduate High School'
  --AND Sch.LocalEducationAgencyId = 2
  --AND NameOfInstitution = 'Buddy Taylor Middle School'
  --ORDER BY Sch.LocalEducationAgencyId, Sch.SchoolId, SCT.Description, SEOAA.PositionTitle, Dassign.Description, Stf.LastSurname
  --ORDER BY Dassign.Description, Stf.FirstName
  ORDER BY Sch.LocalEducationAgencyId, Sch.SchoolId, SCT.Description 