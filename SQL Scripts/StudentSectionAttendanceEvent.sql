/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	s.StudentUSI
	,s.StudentUniqueId
	,s.LastSurname
	,d2.Description
	,sic.IdentificationCode
		,ssae.SchoolId
		,ssae.EventDate
		,ssae.ClassPeriodName
		,d.CodeValue
		,d.ShortDescription
		,d.Description
		,aect.Description as AttenType
	,ssae.AttendanceEventReason


  FROM [EdFi_Prodv2_Ods_2021].[edfi].student s
  inner join edfi.StudentSectionAttendanceEvent ssae on s.StudentUSI=ssae.StudentUSI
  inner join edfi.Descriptor d on d.DescriptorId=ssae.AttendanceEventCategoryDescriptorId
  inner join edfi.StudentIdentificationCode sic on sic.StudentUSI=s.StudentUSI
  inner join edfi.Descriptor d2 on d2.DescriptorId=sic.StudentIdentificationSystemDescriptorId
  inner join edfi.AttendanceEventCategoryDescriptor aecd on aecd.AttendanceEventCategoryDescriptorId=ssae.AttendanceEventCategoryDescriptorId and ssae.AttendanceEventCategoryDescriptorId=aecd.AttendanceEventCategoryDescriptorId
  inner join edfi.AttendanceEventCategoryType aect on aect.AttendanceEventCategoryTypeId=aecd.AttendanceEventCategoryTypeId

  where 
  d.Namespace like '%putnam%' 
   and d.Namespace like '%attendance%' 
  --and d.Description like '%unexcused%'
  and d2.Description = 'Other ID'
  and d.CodeValue like '0101%'
  and sic.IdentificationCode = '5419000991'
  --and ssae.AttendanceEventReason is not null
  and ssae.EventDate <= '2020-12-06' and ssae.EventDate <= '2020-12-12'

  order by StudentUSI, EventDate