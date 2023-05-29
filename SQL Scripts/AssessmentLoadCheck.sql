------------------------------------------------------
--TITLE: Assessment Load Check
------------------------------------------------------

------------------------------------------------------------------------------------------
--PURPOSE: Use this query to see a count of assessments taken by students for each school
------------------------------------------------------------------------------------------

-------------------------------------------------------------
--Knowledge of these tables is needed:
	--SELECT * from edfi.Descriptor where Namespace like '%Assessment%Descriptor' OR Namespace like '%GradeLevelDescriptor' ORDER BY Namespace
	--SELECT * from edfi.Student
	--SELECT * from edfi.StudentSchoolAssociation
	--SELECT * from edfi.Assessment
	--SELECT * from edfi.AssessmentAcademicSubject
	--SELECT * from edfi.StudentAssessment
-------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------


WITH 
	student_school_association as (
		SELECT 
			StudentUSI,
			SchoolId,
			EducationOrganizationId
		from 
			edfi.StudentSchoolAssociation
	),
	student_count as (
		SELECT
			COUNT(StudentUSI)		AS "StudentCount",
			SchoolId
		FROM
			edfi.StudentSchoolAssociation
		GROUP BY
			SchoolId
	),
	assessment as (
		SELECT
		  a.[AssessmentIdentifier]
		  ,a.[Namespace]
		  ,[AssessmentTitle]
		  --,[AssessmentCategoryDescriptorId]
		  ,AssessmentCategory.Description				AS "AssessmentCategory"
		  ,a.[CreateDate]
		  ,a.[LastModifiedDate]
		  ,a.[ChangeVersion]
		  ,'         '									AS "BREAK"
		  --,aas.AcademicSubjectDescriptorId
		  ,AcademicSubject.Description					AS "AcademicSubject"
		FROM
			edfi.assessment a
		-- conver the Descriptor Id's to Descriptions
		LEFT JOIN edfi.Descriptor AssessmentCategory	 ON a.AssessmentCategoryDescriptorId=AssessmentCategory.DescriptorId
		--connect the Academic Subject
		LEFT JOIN edfi.AssessmentAcademicSubject aas	 ON a.AssessmentIdentifier=aas.AssessmentIdentifier
		--and convert the Decriptor Id's to Decriptions
		LEFT JOIN edfi.Descriptor AcademicSubject		 ON aas.AcademicSubjectDescriptorId=AcademicSubject.DescriptorId


	),

	student_assessment as (
		SELECT
			[AssessmentIdentifier]
		  ,sa.[Namespace]
		  ,[StudentAssessmentIdentifier]
		  ,[StudentUSI]
		  ,[AdministrationDate]
		  ,[AdministrationEndDate]
		  ,[SerialNumber]
		  --,[AdministrationLanguageDescriptorId]
		  ,AdministrationLanguage.Description			as AdministrationLanguage
		  --,[AdministrationEnvironmentDescriptorId]
		  ,AdministrationEnvironment.Description		as AdministrationEnvironment
		  --,[RetestIndicatorDescriptorId]
		  ,RetestIndicator.Description					as RetestIndicator
		  --,[ReasonNotTestedDescriptorId]
		  ,ReasonNotTested.Description					as ReasonNotTested
		  --,[WhenAssessedGradeLevelDescriptorId]
		  ,WhenAssessedGradeLevel.Description			as WhenAssessmentGradeLevel
		  --,[EventCircumstanceDescriptorId]
		  ,EventCircumstance.Description				as EventCircumstance
		  ,[EventDescription]
		  ,[SchoolYear]
		  --,[PlatformTypeDescriptorId]
		  ,PlatformType.Description						as PlatformType
		  ,[AssessedMinutes]
		  ,sa.[CreateDate]
		  ,sa.[LastModifiedDate]
		FROM
			edfi.StudentAssessment sa
		LEFT JOIN edfi.Descriptor AdministrationEnvironment	 ON sa.AdministrationEnvironmentDescriptorId=AdministrationEnvironment.DescriptorId
		LEFT JOIN edfi.Descriptor AdministrationLanguage	 ON sa.AdministrationLanguageDescriptorId=AdministrationLanguage.DescriptorId
		LEFT JOIN edfi.Descriptor EventCircumstance			 ON sa.EventCircumstanceDescriptorId=EventCircumstance.DescriptorId
		LEFT JOIN edfi.Descriptor PlatformType				 ON sa.PlatformTypeDescriptorId=PlatformType.DescriptorId
		LEFT JOIN edfi.Descriptor ReasonNotTested			 ON sa.ReasonNotTestedDescriptorId=ReasonNotTested.DescriptorId
		LEFT JOIN edfi.Descriptor RetestIndicator			 ON sa.RetestIndicatorDescriptorId=RetestIndicator.DescriptorId
		LEFT JOIN edfi.Descriptor WhenAssessedGradeLevel	 ON sa.WhenAssessedGradeLevelDescriptorId=WhenAssessedGradeLevel.DescriptorId
	),
	merge_assessment_queries as (
		SELECT
			assessment.AssessmentIdentifier,
			assessment.AssessmentTitle,
			assessment.AcademicSubject,
			assessment.AssessmentCategory,
			student_assessment.AdministrationDate,
			student_assessment.AdministrationEndDate,
			student_assessment.AdministrationEnvironment,
			student_assessment.AdministrationLanguage,
			student_assessment.AssessedMinutes,
			student_assessment.CreateDate,
			student_assessment.EventCircumstance,
			student_assessment.EventDescription,
			student_assessment.LastModifiedDate,
			student_assessment.Namespace,
			student_assessment.PlatformType,
			student_assessment.ReasonNotTested,
			student_assessment.RetestIndicator,
			student_assessment.SchoolYear,
			student_assessment.SerialNumber,
			student_assessment.StudentAssessmentIdentifier,
			student_assessment.StudentUSI,
			student_assessment.WhenAssessmentGradeLevel
		FROM
			assessment
		INNER JOIN student_assessment					 ON assessment.AssessmentIdentifier=student_assessment.AssessmentIdentifier
	)

SELECT
		student_school_association.SchoolId				AS "School Id",
		student_count.StudentCount						AS "StudentCount",
		AssessmentIdentifier							AS "Assessment Identifier",
		AssessmentTitle									AS "Assessment Title",
		AcademicSubject									AS "Academic Subject",
		Namespace										AS "Assessment Namespace",
		COUNT(AssessmentIdentifier)						AS "Count Of studentAssessments Records",
		MAX(CAST(CreateDate AS DATE))					AS "Most Recently Created Record for studentAssessment",
		MAX(LastModifiedDate)							AS "Most Recently Modified Date for studentAssessment"
	FROM
		merge_assessment_queries
		LEFT JOIN student_school_association			ON merge_assessment_queries.StudentUSI=student_school_association.StudentUSI
		INNER JOIN student_count						ON student_school_association.SchoolId=student_count.SchoolId
	GROUP BY
		student_school_association.SchoolId,
		AssessmentIdentifier,
		AssessmentTitle,
		AcademicSubject,
		Namespace,
		StudentCount
	ORDER BY
		student_school_association.SchoolId,
		AssessmentTitle,
		AcademicSubject

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Run this query to get a quick count of students per school.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- select
-- 	SchoolId,
-- 	COUNT(StudentUSI) AS "Student Count"
-- FROM
-- 	edfi.StudentSchoolAssociation
-- GROUP BY 
-- 	SchoolId
-- ORDER BY
-- 	SchoolId