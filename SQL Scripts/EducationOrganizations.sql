SELECT
	lea.LocalEducationAgencyId,
	EducationServiceCenterId,
	EducationOrganizationId,
	NameOfInstitution,
	Discriminator,
	sch.SchoolId,
	sch.SchoolTypeDescriptorId,
	SchoolType.Description						AS "School Type"
  FROM 
	edfi.EducationOrganization eo
	left join edfi.School sch					on eo.EducationOrganizationId=sch.SchoolId
	left join edfi.LocalEducationAgency lea		on sch.LocalEducationAgencyId=lea.LocalEducationAgencyId
	LEFT JOIN edfi.Descriptor SchoolType		on sch.SchoolTypeDescriptorId=SchoolType.DescriptorId

	