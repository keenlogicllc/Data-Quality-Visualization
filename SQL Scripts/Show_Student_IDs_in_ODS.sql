select DISTINCT d.CodeValue as StudentIdentificationSystemDescriptor_CodeValue
from edfi.Student s
left join edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic on s.StudentUSI=seoasic.StudentUSI
inner join edfi.Descriptor d on seoasic.StudentIdentificationSystemDescriptorId=d.DescriptorId

select DISTINCT AssigningOrganizationIdentificationCode
from edfi.Student s
left join edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic on s.StudentUSI=seoasic.StudentUSI
inner join edfi.Descriptor d on seoasic.StudentIdentificationSystemDescriptorId=d.DescriptorId

select
	s.StudentUSI
	,s.StudentUniqueId
	,seoasic.AssigningOrganizationIdentificationCode
	,seoasic.EducationOrganizationId
	,seoasic.IdentificationCode
	,d.CodeValue as StudentIdentificationSystemDescriptor_CodeValue
	,d.Description as StudentIdentificationSystemDescriptor_Description
from edfi.Student s
left join edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic on s.StudentUSI=seoasic.StudentUSI
inner join edfi.Descriptor d on seoasic.StudentIdentificationSystemDescriptorId=d.DescriptorId
where IdentificationCode like 'FL%'