with 
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