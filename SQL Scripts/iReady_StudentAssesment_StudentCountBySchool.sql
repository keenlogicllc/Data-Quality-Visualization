USE EdFi_Prodv2_Ods_2022
GO
select count(DISTINCT StudentUSI) as StudentCount, t1.NameOfInstitution, t1.AssessmentTitle from
(select 
	s.studentuniqueId
	,sa.StudentUSI
	,ssa.EducationOrganizationId
	,eo.NameOfInstitution
	,a.AssessmentTitle
	,sa.AssessmentIdentifier
	,sa.StudentAssessmentIdentifier
	,sa.AdministrationDate
	--,sasoa.IdentificationCode
	--,sasoa.StudentAssessmentIdentifier
	--,sasoa.StudentAssessmentIdentifier
	--,sasoa.CreateDate
	--,sa.Namespace

from edfi.Student s
inner join edfi.StudentSchoolAssociation ssa on S.StudentUSI=ssa.StudentUSI
inner join edfi.StudentAssessment sa on sa.StudentUSI=s.StudentUSI
inner join edfi.Assessment a on sa.AssessmentIdentifier=a.AssessmentIdentifier
inner join edfi.EducationOrganization eo on eo.EducationOrganizationId =ssa.SchoolId
left join edfi.StudentAssessmentStudentObjectiveAssessment sasoa on s.StudentUSI=sasoa.StudentUSI and sa.StudentAssessmentIdentifier=sasoa.StudentAssessmentIdentifier
where 
	ssa.EducationOrganizationId like '38%'
	and sa.Namespace = 'http://www.curriculumassociates.com/Descriptor/Assessment.xml'
) t1
Group BY NameOfInstitution, AssessmentTitle
order by 
	NameOfInstitution,
	AssessmentTitle
	
