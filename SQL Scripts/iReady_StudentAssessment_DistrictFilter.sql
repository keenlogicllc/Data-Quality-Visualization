select 
	s.studentuniqueId
	,sa.StudentUSI
	,ssa.EducationOrganizationId
	,eo.NameOfInstitution
	,sa.AssessmentIdentifier
	,sa.StudentAssessmentIdentifier
	,sa.AdministrationDate
	,sasoa.IdentificationCode
	--,sasoa.StudentAssessmentIdentifier
	,sasoa.StudentAssessmentIdentifier
	,sasoa.CreateDate
	--,sa.Namespace

from edfi.Student s
inner join edfi.StudentSchoolAssociation ssa on S.StudentUSI=ssa.StudentUSI
inner join edfi.StudentAssessment sa on sa.StudentUSI=s.StudentUSI
inner join edfi.EducationOrganization eo on eo.EducationOrganizationId =ssa.SchoolId
left join edfi.StudentAssessmentStudentObjectiveAssessment sasoa on s.StudentUSI=sasoa.StudentUSI and sa.StudentAssessmentIdentifier=sasoa.StudentAssessmentIdentifier
where 
	ssa.EducationOrganizationId like '15%'
	and sa.Namespace = 'http://www.curriculumassociates.com/Descriptor/Assessment.xml'

order by sasoa.CreateDate desc, sa.studentusi, sa.AdministrationDate desc
