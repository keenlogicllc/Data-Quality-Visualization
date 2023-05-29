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
	student_section_attendance as (
		SELECT
			--AttendanceEventCategoryDescriptorId,
			AttendanceEventCategory.Description		AS "AttendanceEventCategory",
			EventDate,
			LocalCourseCode,
			SchoolId,
			SchoolYear,
			SectionIdentifier,
			SessionName,
			StudentUSI,
			AttendanceEventReason,
			--EducationalEnvironmentDescriptorId,
			EducationalEnvironment.Description		AS "EducationalEnvironment",
			EventDuration,
			SectionAttendanceDuration,
			ArrivalTime,
			DepartureTime		
		FROM
			edfi.StudentSectionAttendanceEvent StuSecAE
			LEFT JOIN edfi.Descriptor AttendanceEventCategory on StuSecAE.AttendanceEventCategoryDescriptorId=AttendanceEventCategory.DescriptorId
			LEFT JOIN edfi.Descriptor EducationalEnvironment on StuSecAE.EducationalEnvironmentDescriptorId=EducationalEnvironment.DescriptorId
	)

SELECT
	student_section_attendance.SchoolId,
	StudentUniqueId,
	LastSurname,
	FirstName,
	MiddleName,
	LocalCourseCode,
	AttendanceEventCategory,
	COUNT(*)										AS "Count of Absence Events"

FROM
	students
	LEFT JOIN active_enrollments					ON students.StudentUSI=active_enrollments.StudentUSI
	INNER JOIN student_section_attendance			ON students.StudentUSI=student_section_attendance.StudentUSI
GROUP BY
	student_section_attendance.SchoolId,
	StudentUniqueId,
	LastSurname,
	FirstName,
	MiddleName,
	LocalCourseCode,
	AttendanceEventCategory
ORDER BY
	student_section_attendance.SchoolId,
	LastSurname,
	LocalCourseCode,
	"Count of Absence Events" DESC