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
	student_school_attendance as (
		SELECT
			--AttendanceEventCategoryDescriptorId,
			AttendanceEventCategory.Description		AS "AttendanceEventCategory",
			EventDate,
			SchoolId,
			SchoolYear,
			SessionName,
			StudentUSI,
			AttendanceEventReason,
			--EducationalEnvironmentDescriptorId,
			EducationalEnvironment.Description		AS "EducationalEnvironment",
			EventDuration,
			ArrivalTime,
			DepartureTime		
		FROM
			edfi.StudentSchoolAttendanceEvent StuSchAE
			LEFT JOIN edfi.Descriptor AttendanceEventCategory on StuSchAE.AttendanceEventCategoryDescriptorId=AttendanceEventCategory.DescriptorId
			LEFT JOIN edfi.Descriptor EducationalEnvironment on StuSchAE.EducationalEnvironmentDescriptorId=EducationalEnvironment.DescriptorId
	)

SELECT
	student_school_attendance.SchoolId,
	StudentUniqueId,
	LastSurname,
	FirstName,
	MiddleName,
	COUNT(*)										AS "Count of Unexcused Absence Events"

FROM
	students
	LEFT JOIN active_enrollments					ON students.StudentUSI=active_enrollments.StudentUSI
	INNER JOIN student_school_attendance			ON students.StudentUSI=student_school_attendance.StudentUSI
WHERE
	AttendanceEventCategory = 'Unexcused Absence'
GROUP BY
	student_school_attendance.SchoolId,
	StudentUniqueId,
	LastSurname,
	FirstName,
	MiddleName
ORDER BY
	"Count of Unexcused Absence Events" DESC,
	LastSurname
