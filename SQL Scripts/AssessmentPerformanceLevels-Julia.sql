SELECT s.LastSurname,S.FirstName,S.MiddleName
	  ,sasr.StudentUSI
      ,ssa.SchoolId
      ,sch.LocalEducationAgencyId
      ,sasr.AssessmentTitle      
      ,ast.ShortDescription
      ,gld.GradeLevelTypeId
      ,glt.ShortDescription AS AssessedGradeLevel
      ,sasr.AdministrationDate
      ,armt.ShortDescription
      ,Result
      ,sapl.PerformanceLevelDescriptorId
      ,pld.PerformanceBaseConversionTypeId
      ,pbct.ShortDescription
      ,sapl.PerformanceLevelMet
FROM [EdFi_Ods].[edfi].[StudentAssessmentScoreResult] sasr
       LEFT JOIN [EdFi_Ods].[edfi].[StudentSchoolAssociation] ssa on ssa.StudentUSI = SASR.StudentUSI
       LEFT JOIN [EdFi_Ods].[edfi].[School] sch on sch.SchoolId = ssa.SchoolId
       LEFT JOIN [EdFi_Ods].[edfi].[StudentAssessmentPerformanceLevel] sapl
                     ON sapl.StudentUSI = sasr.StudentUSI
                     AND sapl.AssessmentTitle = sasr.AssessmentTitle
                     AND sapl.AcademicSubjectDescriptorId = sasr.AcademicSubjectDescriptorId
                     AND sapl.AssessedGradeLevelDescriptorId = sasr.AssessedGradeLevelDescriptorId
                     AND sapl.AdministrationDate = sasr.AdministrationDate
                     AND sapl.Version = sasr.Version
       LEFT JOIN [EdFi_Ods].[edfi].[AssessmentReportingMethodType] armt ON sasr.AssessmentReportingMethodTypeId = armt.AssessmentReportingMethodTypeId
       LEFT JOIN [EdFi_Ods].[edfi].[GradeLevelDescriptor] gld ON sasr.AssessedGradeLevelDescriptorId = gld.GradeLevelDescriptorId
       LEFT JOIN [EdFi_Ods].[edfi].[GradeLevelType] glt ON gld.GradeLevelTypeId = glt.GradeLevelTypeId
       LEFT JOIN [EdFi_Ods].[edfi].[AcademicSubjectDescriptor] asd ON asd.AcademicSubjectDescriptorId = sasr.AcademicSubjectDescriptorId
       LEFT JOIN [EdFi_Ods].[edfi].[AcademicSubjectType] ast ON ast.AcademicSubjectTypeId = asd.AcademicSubjectTypeId
       LEFT JOIN [EdFi_Ods].[edfi].[PerformanceLevelDescriptor] pld ON pld.PerformanceLevelDescriptorId = sapl.PerformanceLevelDescriptorId
       LEFT JOIN [EdFi_Ods].[edfi].[PerformanceBaseConversionType] pbct ON pbct.PerformanceBaseConversionTypeId = pld.PerformanceBaseConversionTypeId
	   LEFT JOIN [EdFi_Ods].[edfi].Student S on S.StudentUSI=SASR.StudentUSI
WHERE  sch.LocalEducationAgencyId = 2 AND ssa.SchoolId = 20012
       --AND SAPL.PerformanceLevelDescriptorId IS NULL
	   --SAPL.PerformanceLevelDescriptorId IS NULL AND SAPL.PerformanceLevelMet IS NOT NULL
	     AND SASR.AssessmentTitle = 'FSAE1'
ORDER BY sasr.StudentUSI, gld.GradeLevelTypeId
