------------------------------------------------------
--TITLE: Student Discipline Action
------------------------------------------------------

------------------------------------------------------------------------------------------
--PURPOSE: Use this query to see the actions being taken for students.
------------------------------------------------------------------------------------------

-------------------------------------------------------------
--Knowledge of these tables is needed:
	--SELECT * from edfi.Descriptor where Namespace like '%Assessment%Descriptor' OR Namespace like '%GradeLevelDescriptor' ORDER BY Namespace
	--SELECT * from edfi.Student  --This table is not used below but good to have a basic understanding
	--SELECT * from edfi.StudentSchoolAssociation
	--SELECT * from edfi.DisciplineAction
	--SELECT * from edfi.DisciplineActionDiscipline
-------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

with 
	--Basic student info
	students as (
		SELECT
			StudentUSI,
			StudentUniqueId,
			LastSurname,
			FirstName,
			MiddleName
		FROM
			edfi.Student
	),
	--Determine what students are actively enrolled
	active_enrollments as (

    select
        StudentUSI,
		SchoolId,
		EntryDate,
		ExitWithdrawDate,
        'Yes'                as is_actively_enrolled_in_school
    from 
		edfi.StudentSchoolAssociation
    where
        ExitWithdrawDate is null
        OR (
            -- active enrollment for current year
            CAST(GETDATE() AS DATE) >= EntryDate
            and CAST(GETDATE() AS DATE) < ExitWithdrawDate
			)
	),
	--Identify the discipline actions
	discipline_actions as (
		SELECT
			da.DisciplineActionIdentifier,
			da.DisciplineDate,
			da.StudentUSI,
			DisciplineAction.Description,
			DisciplineActionLength,
			ActualDisciplineActionLength,
			DifferenceReason.Description					AS "DisciplineActionLengthDifferenceReason",
			ResponsibilitySchoolId,
			ReceivedEducationServicesDuringExpulsion,
			IEPPlacementMeetingIndicator
		FROM
			edfi.DisciplineAction da
			LEFT JOIN edfi.Descriptor DifferenceReason ON da.DisciplineActionLengthDifferenceReasonDescriptorId=DifferenceReason.DescriptorId
			LEFT JOIN edfi.DisciplineActionDiscipline dad on da.DisciplineActionIdentifier=dad.DisciplineActionIdentifier AND da.StudentUSI=dad.StudentUSI
			LEFT JOIN edfi.Descriptor DisciplineAction on dad.DisciplineDescriptorId=DisciplineAction.DescriptorId
	)

--PUll all of the above queries together to connect students with the discipline actions taken.
SELECT 
	StudentUniqueId,
	LastSurname,
	FirstName,
	MiddleName,
	CASE
		WHEN is_actively_enrolled_in_school = 'Yes' then is_actively_enrolled_in_school
		ELSE 'No'
		END AS "is_actively_enrolled_in_school",
	SchoolId,
	EntryDate,
	ExitWithdrawDate,
	discipline_actions.*
FROM 
	students 
	LEFT JOIN discipline_actions on students.StudentUSI=discipline_actions.StudentUSI
	LEFT JOIN active_enrollments on students.StudentUSI=active_enrollments.StudentUSI
WHERE 
	DisciplineActionIdentifier IS NOT NULL
ORDER BY
	DisciplineDate,
	CAST(DisciplineActionIdentifier AS INT)