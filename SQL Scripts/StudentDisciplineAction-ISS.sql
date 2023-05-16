
SELECT COUNT(*) from 
(SELECT 
	  s.StudentUniqueId
	  ,da.[StudentUSI]
      ,da.[DisciplineActionIdentifier]
      ,d.CodeValue AS Action
      ,d.ShortDescription AS DisciplineActionSkyward
	  ,dt.CodeValue AS DisciplineActionEdFi
      ,da.[DisciplineDate]
      ,[DisciplineActionLength]
      ,[ActualDisciplineActionLength]
      ,[ResponsibilitySchoolId]
	  ,lea.LocalEducationAgencyId
  FROM       [edfi].[DisciplineAction]           da
  INNER JOIN [edfi].[DisciplineActionDiscipline] dad ON da.DisciplineActionIdentifier = dad.DisciplineActionIdentifier AND da.StudentUSI = dad.StudentUSI
  INNER JOIN [edfi].DisciplineDescriptor          dd ON DAD.DisciplineDescriptorId = dd.DisciplineDescriptorId
  INNER JOIN [edfi].DisciplineType                dt ON dd.DisciplineTypeId = dt.DisciplineTypeId
  INNER JOIN [edfi].Descriptor                     d ON DAD.DisciplineDescriptorId = d.DescriptorId
    LEFT JOIN 
    (
	SELECT t.StudentUSI, t.EntryDate, ssa.ExitWithdrawDate, sch.LocalEducationAgencyId
	FROM
		(
		SELECT  t1.StudentUSI, t1.EntryDate, ExitWithdrawDate
		FROM
			(
			SELECT ssa1.StudentUSI, ssa1.EntryDate, nullif(max(coalesce(ssa.ExitWithdrawDate, '9999-01-01')), '9999-01-01') AS ExitWithdrawDate 
			FROM (SELECT [StudentUSI], MAX([EntryDate]) as EntryDate
				  FROM [edfi].[StudentSchoolAssociation]
				   GROUP BY  [StudentUSI]
				  ) ssa1
			LEFT JOIN [edfi].[StudentSchoolAssociation] ssa ON ssa1.StudentUSI = ssa.StudentUSI AND ssa1.EntryDate = ssa.EntryDate
			GROUP BY ssa1.StudentUSI, ssa1.EntryDate	
			) t1
	) t	
	LEFT JOIN [edfi].[StudentSchoolAssociation] ssa ON T.StudentUSI = ssa.StudentUSI AND  t.EntryDate = ssa.EntryDate 
													 AND ISNULL (t.ExitWithdrawDate,'9999-01-01') = ISNULL(ssa.ExitWithdrawDate,'9999-01-01')
	LEFT JOIN [edfi].[School] sch ON ssa.SchoolId = sch.SchoolId
	GROUP BY t.StudentUSI, t.EntryDate, ssa.ExitWithdrawDate, sch.LocalEducationAgencyId
  ) lea ON da.StudentUSI = lea.StudentUSI
  LEFT JOIN edfi.Student s ON s.StudentUSI = lea.StudentUSI
  where dt.CodeValue = 'In School Suspension' and (DisciplineActionLength = 0 OR DisciplineActionLength > 10)) O

  -----------------------------------------------------------------------

  SELECT 
	  s.StudentUniqueId
	  ,da.[StudentUSI]
      ,da.[DisciplineActionIdentifier]
      ,d.CodeValue AS Action
      ,d.ShortDescription AS DisciplineActionSkyward
	  ,dt.CodeValue AS DisciplineActionEdFi
      ,da.[DisciplineDate]
      ,[DisciplineActionLength]
      ,[ActualDisciplineActionLength]
      ,[ResponsibilitySchoolId]
	  ,lea.LocalEducationAgencyId
	  ,da.LastModifiedDate
  FROM       [edfi].[DisciplineAction]           da
  INNER JOIN [edfi].[DisciplineActionDiscipline] dad ON da.DisciplineActionIdentifier = dad.DisciplineActionIdentifier AND da.StudentUSI = dad.StudentUSI
  INNER JOIN [edfi].DisciplineDescriptor          dd ON DAD.DisciplineDescriptorId = dd.DisciplineDescriptorId
  INNER JOIN [edfi].DisciplineType                dt ON dd.DisciplineTypeId = dt.DisciplineTypeId
  INNER JOIN [edfi].Descriptor                     d ON DAD.DisciplineDescriptorId = d.DescriptorId
    LEFT JOIN 
    (
	SELECT t.StudentUSI, t.EntryDate, ssa.ExitWithdrawDate, sch.LocalEducationAgencyId
	FROM
		(
		SELECT  t1.StudentUSI, t1.EntryDate, ExitWithdrawDate
		FROM
			(
			SELECT ssa1.StudentUSI, ssa1.EntryDate, nullif(max(coalesce(ssa.ExitWithdrawDate, '9999-01-01')), '9999-01-01') AS ExitWithdrawDate 
			FROM (SELECT [StudentUSI], MAX([EntryDate]) as EntryDate
				  FROM [edfi].[StudentSchoolAssociation]
				   GROUP BY  [StudentUSI]
				  ) ssa1
			LEFT JOIN [edfi].[StudentSchoolAssociation] ssa ON ssa1.StudentUSI = ssa.StudentUSI AND ssa1.EntryDate = ssa.EntryDate
			GROUP BY ssa1.StudentUSI, ssa1.EntryDate	
			) t1
	) t	
	LEFT JOIN [edfi].[StudentSchoolAssociation] ssa ON T.StudentUSI = ssa.StudentUSI AND  t.EntryDate = ssa.EntryDate 
													 AND ISNULL (t.ExitWithdrawDate,'9999-01-01') = ISNULL(ssa.ExitWithdrawDate,'9999-01-01')
	LEFT JOIN [edfi].[School] sch ON ssa.SchoolId = sch.SchoolId
	GROUP BY t.StudentUSI, t.EntryDate, ssa.ExitWithdrawDate, sch.LocalEducationAgencyId
  ) lea ON da.StudentUSI = lea.StudentUSI
  LEFT JOIN edfi.Student s ON s.StudentUSI = lea.StudentUSI
  where dt.CodeValue = 'In School Suspension' and (DisciplineActionLength = 0 OR DisciplineActionLength > 10)
  ORDER BY LocalEducationAgencyId, LastModifiedDate DESC;