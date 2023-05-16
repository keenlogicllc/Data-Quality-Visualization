select 
	ssa.StudentUSI
	,ssa.SchoolId
	,ssa.EntryDate
	,ssa.ExitWithdrawDate
	,ssa.LastModifiedDate as LastModifiedDate_SSA
	,seoa.StudentUSI as StudentUSI_SEOA
	,seoa.LastModifiedDate as LastModifiedDate_SEOA
from edfi.StudentSchoolAssociation ssa
left join edfi.StudentEducationOrganizationAssociation seoa
	on ssa.StudentUSI=seoa.StudentUSI
	--and ssa.SchoolId = seoa.EducationOrganizationId
where ssa.ExitWithdrawDate < GETDATE() and seoa.StudentUSI is null
order by ssa.LastModifiedDate desc