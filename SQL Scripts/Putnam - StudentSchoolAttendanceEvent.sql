/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	s.StudentUSI
	,s.StudentUniqueId
	--,d2.Description
	--,sic.IdentificationCode
		,ssae.SchoolId
		,d.CodeValue
		,d.ShortDescription
		,d.Description
		,ssae.EventDate
		,aect.Description as AttenType
	,ssae.AttendanceEventReason


  FROM [EdFi_Prodv2_Ods_2021].[edfi].student s
  full outer join edfi.StudentSchoolAttendanceEvent ssae on s.StudentUSI=ssae.StudentUSI
  full outer join edfi.Descriptor d on d.DescriptorId=ssae.AttendanceEventCategoryDescriptorId
 -- full outer join edfi.StudentIdentificationCode sic on sic.StudentUSI=s.StudentUSI
  --full outer join edfi.Descriptor d2 on d2.DescriptorId=sic.StudentIdentificationSystemDescriptorId
  full outer join edfi.AttendanceEventCategoryDescriptor aecd on aecd.AttendanceEventCategoryDescriptorId=ssae.AttendanceEventCategoryDescriptorId
  full outer join edfi.AttendanceEventCategoryType aect on aect.AttendanceEventCategoryTypeId=aecd.AttendanceEventCategoryTypeId
  inner join edfi.StudentSchoolAssociation ssa on ssa.StudentUSI=s.StudentUSI

  where 
  d.Namespace like '%putnam%' 
   and d.Namespace like '%attendance%' 
  --and d.Description like '%unexcused%'
  and aect.Description like '%Absence%'
 -- and d2.Description = 'Other ID'
  --and d.CodeValue like '0101%'
  --and ssae.SchoolId = 540101
  --and sic.IdentificationCode = '5419000991'
  --and ssae.AttendanceEventReason is not null
  and ssae.EventDate >= '2020-08-24' and ssae.EventDate <= '2020-10-26'
  and ssa.ExitWithdrawDate is null
  --and ssa.EducationOrganizationId = '540101'

  order by StudentUSI, EventDate