--SELECT  [AssessmentIdentifier]
--      ,[Namespace]
--      ,[StudentAssessmentIdentifier]
--      ,[StudentUSI]
--      ,[AdministrationDate]
--      ,[AdministrationEndDate]
--      ,[SerialNumber]
--      ,[AdministrationLanguageDescriptorId]
--      ,[AdministrationEnvironmentTypeId]
--      ,[RetestIndicatorTypeId]
--      ,[ReasonNotTestedTypeId]
--      ,[WhenAssessedGradeLevelDescriptorId]
--      ,[EventCircumstanceTypeId]
--      ,[EventDescription]
--      ,[CreateDate]
--      ,[LastModifiedDate]
--      ,[Id]
--  FROM [EdFi_Prodv2_Ods_2021].[edfi].[StudentAssessment]
--  where CreateDate >= '7-29-2021' and StudentAssessmentIdentifier like '%FSA%'
--  order by LastModifiedDate desc 

  SELECT  AssessmentIdentifier
		,Namespace AS DistrictNamespace
		,COUNT(AssessmentIdentifier) as CountOfStudentAssessments
		,CAST(LastModifiedDate AS date) as LastModifiedDate
		--,(Select DISTINCT Namespace from Edfi_Prodv2_Ods_2021.edfi.StudentAssessment)
  FROM [EdFi_Prodv2_Ods_2022].[edfi].[StudentAssessment]
  where 
	CreateDate >= '5-1-2022' 
	and (StudentAssessmentIdentifier like '%FSA%Reading%' 
	--or AssessmentIdentifier like 'EB1%'
	--or AssessmentIdentifier like 'EAH%'
	--or AssessmentIdentifier like 'ECS%'
	)
	and Namespace like '%union%'
  GROUP BY AssessmentIdentifier
		,Namespace
		,CAST(LastModifiedDate AS date)
  ORDER BY Namespace,LastModifiedDate DESC ,AssessmentIdentifier

 -- Select 
	--DISTINCT Namespace 
 -- from Edfi_Prodv2_Ods_2022.edfi.StudentAssessment
 -- where 
	--CreateDate >= '5-1-2022' 
	--and (StudentAssessmentIdentifier like '%FSA%' 
	--or AssessmentIdentifier like 'EB1%'
	--or AssessmentIdentifier like 'EAH%'
	--or AssessmentIdentifier like 'ECS%'
	--)