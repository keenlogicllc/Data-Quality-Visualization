------------------------------------------------------
--TITLE: Student Assessment Simple County By Year
------------------------------------------------------

------------------------------------------------------------------------------------------
--PURPOSE: Use this query to see a count of student assessments for each school by Year. This would be used if multiple years of Assessments 
--		   are being kept in the ODS
------------------------------------------------------------------------------------------

-------------------------------------------------------------
--Knowledge of these tables is needed:
	--SELECT * from edfi.Descriptor where Namespace like '%Assessment%Descriptor' OR Namespace like '%GradeLevelDescriptor' ORDER BY Namespace
	--SELECT * from edfi.Student  --This table is not used below but good to have a basic understanding
	--SELECT * from edfi.StudentSchoolAssociation
	--SELECT * from edfi.Assessment
	--SELECT * from edfi.AssessmentAcademicSubject
	--SELECT * from edfi.StudentAssessment
-------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

with CTE as (
	select 
	s.studentuniqueId
	,sa.StudentUSI
	,ssa.EducationOrganizationId
	,eo.NameOfInstitution
	,a.AssessmentTitle
	,sa.AssessmentIdentifier
	,sa.StudentAssessmentIdentifier
	,sa.AdministrationDate
	,CASE 
		WHEN sa.AdministrationDate is null or sa.AdministrationDate = '' then 'null'
		WHEN MONTH(sa.AdministrationDate) < 7 then CONVERT(VARCHAR,YEAR(sa.AdministrationDate))
		ELSE CONVERT(VARCHAR,YEAR(sa.AdministrationDate) + 1)
		END AS 'YEAR'
from 
	edfi.Student s
	inner join edfi.StudentSchoolAssociation ssa on S.StudentUSI=ssa.StudentUSI
	inner join edfi.StudentAssessment sa on sa.StudentUSI=s.StudentUSI
	inner join edfi.Assessment a on sa.AssessmentIdentifier=a.AssessmentIdentifier
	inner join edfi.EducationOrganization eo on eo.EducationOrganizationId =ssa.SchoolId
	left join edfi.StudentAssessmentStudentObjectiveAssessment sasoa on s.StudentUSI=sasoa.StudentUSI 
		and sa.StudentAssessmentIdentifier=sasoa.StudentAssessmentIdentifier
)

select 
	[YEAR]
	,AssessmentTitle
	,count(DISTINCT StudentUSI) as Distinct_Count_Of_Students_Who_Have_Taken_Assessment
from
	CTE
Group BY
	[YEAR]
	,AssessmentTitle
order by 
	AssessmentTitle
	,[YEAR]
