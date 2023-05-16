USE EdFi_Prodv2_Ods_2023
GO
select 
	--,t1.NameOfInstitution
	--t1.[Year]
	t1.AssessmentTitle
	,count(DISTINCT StudentUSI) as Distinct_Count_Of_Students_Who_Have_Taken_Assessment
	--,count(DISTINCT SUBSTRING(RIGHT('000000'+CAST(t1.EducationOrganizationId as varchar(6)), 6 ), 1, 2)) as Distinct_Count_Of_Districts
	--,SUBSTRING(RIGHT('000000'+CAST(t1.EducationOrganizationId as varchar(6)), 6 ), 1, 2)
	--,t1.YEAR
	--,SUBSTRING(RIGHT('000000'+CAST(EducationOrganizationId as varchar(6)), 6 ), 1, 2) as EdOrgId
	--,NameOfInstitution
from
(select 
	s.studentuniqueId
	,sa.StudentUSI
	,ssa.EducationOrganizationId
	,eo.NameOfInstitution
	,a.AssessmentTitle
	,sa.AssessmentIdentifier
	,sa.StudentAssessmentIdentifier
	,sa.AdministrationDate
	,CASE 
		WHEN sa.AdministrationDate >= '2023-07-01' and sa.AdministrationDate <= '2024-6-30' then '2023'
		WHEN sa.AdministrationDate >= '2022-07-01' and sa.AdministrationDate <= '2023-6-30' then '2023'
		WHEN sa.AdministrationDate >= '2021-07-01' and sa.AdministrationDate <= '2022-6-30' then '2022'
		WHEN sa.AdministrationDate >= '2020-07-01' and sa.AdministrationDate <= '2021-6-30' then '2021'
		WHEN sa.AdministrationDate >= '2019-07-01' and sa.AdministrationDate <= '2020-6-30' then '2020'
		WHEN sa.AdministrationDate >= '2018-07-01' and sa.AdministrationDate <= '2019-6-30' then '2019'
		WHEN sa.AdministrationDate >= '2017-07-01' and sa.AdministrationDate <= '2018-6-30' then '2018'
		WHEN sa.AdministrationDate >= '2016-07-01' and sa.AdministrationDate <= '2017-6-30' then '2017'
		WHEN sa.AdministrationDate >= '2015-07-01' and sa.AdministrationDate <= '2016-6-30' then '2016'
		WHEN sa.AdministrationDate >= '2014-07-01' and sa.AdministrationDate <= '2015-6-30' then '2015'
		WHEN sa.AdministrationDate >= '2013-07-01' and sa.AdministrationDate <= '2014-6-30' then '2014'
		WHEN sa.AdministrationDate >= '2012-07-01' and sa.AdministrationDate <= '2013-6-30' then '2013'
		WHEN sa.AdministrationDate >= '2011-07-01' and sa.AdministrationDate <= '2012-6-30' then '2012'
		WHEN sa.AdministrationDate >= '2010-07-01' and sa.AdministrationDate <= '2011-6-30' then '2011'
		WHEN sa.AdministrationDate >= '2009-07-01' and sa.AdministrationDate <= '2010-6-30' then '2010'
		WHEN sa.AdministrationDate >= '2008-07-01' and sa.AdministrationDate <= '2009-6-30' then '2009'
		WHEN sa.AdministrationDate >= '2007-07-01' and sa.AdministrationDate <= '2008-6-30' then '2009'
		WHEN sa.AdministrationDate >= '2006-07-01' and sa.AdministrationDate <= '2007-6-30' then '2009'
		WHEN sa.AdministrationDate >= '2005-07-01' and sa.AdministrationDate <= '2006-6-30' then '2009'
		WHEN sa.AdministrationDate is null or sa.AdministrationDate = '' then 'null'
		ELSE 'outside data range'
		END AS 'YEAR'
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
--where 
	--ssa.EducationOrganizationId like '63%'
	--or ssa.EducationOrganizationId like '15%'
	--or SUBSTRING(RIGHT('000000'+CAST(eo.EducationOrganizationId as varchar(6)), 6 ), 1, 2) = '02'
	--and sa.Namespace = 'http://www.curriculumassociates.com/Descriptor/Assessment.xml'
) t1
Group BY AssessmentTitle
		--,t1.[Year]
		--,SUBSTRING(RIGHT('000000'+CAST(t1.EducationOrganizationId as varchar(6)), 6 ), 1, 2)
--Group BY NameOfInstitution, AssessmentTitle
order by 
	--NameOfInstitution,
	--t1.[Year],
	--SUBSTRING(RIGHT('000000'+CAST(t1.EducationOrganizationId as varchar(6)), 6 ), 1, 2)
	AssessmentTitle
	--,t1.[YEAR]
	--,SUBSTRING(RIGHT('000000'+CAST(t1.EducationOrganizationId as varchar(6)), 6 ), 1, 2)
	
	
	--select SUBSTRING(RIGHT('000000'+CAST(EducationOrganizationId as varchar(6)), 6 ), 1, 2) from edfi.EducationOrganization 