USE [DataCheckerPersistence]
GO


----------------------------------------------------------------------------------------------------------------------------------
--Collections Dimension
----------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW [bi].[dim_collections] as
SELECT
	Collections.Name collections_name,
	Collections.Description collections_description,
	Collections.Id collections_id
FROM
	datachecker.Containers
	left outer join datachecker.Containers as collections
		on containers.ParentContainerId = collections.Id

WHERE collections.name is not null
GROUP BY 
	Collections.Name,
	Collections.Description,
	Collections.Id

GO



----------------------------------------------------------------------------------------------------------------------------------
--Error Fact Table
-----------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW [bi].[fct_rule_execution_log_details] AS
select * from(
	SELECT 
		RuleId										as 'rule_id'
		,RuleExecutionLogId							as 'rule_execution_log_id'
		,Containers.Id								as 'containers_id'
		,Collections.Id								as 'collections_id'
		,rel.DatabaseEnvironmentId					as 'environment_id'
		,rel.StatusId								as 'status_id'
		,EducationOrganizationId					as 'education_organization_id'
		,StudentUniqueId							as 'student_unique_id'
		,StaffUniqueId								as 'staff_unique_id'
		,CourseCode									as 'course_code'
		,Discriminator								as 'discriminator'
		,ProgramName								as 'program_name'
		,[key]										as 'attribute'
		,[value]									as 'value'
		,rel.Response								as 'response'
		,rel.Result									as 'result'
		,rel.Evaluation								as 'evaluation'
		,(Select 
			DATEADD(
				mi, DATEDIFF(mi, GETUTCDATE(),
				GETDATE()),
				rel.ExecutionDate))					as 'execution_date'
		,RANK() OVER (
			PARTITION BY RuleId 
			ORDER BY rel.Id desc
			)										as rule_order
	FROM DataCheckerPersistence.destination.EdFiRuleExecutionLogDetails ereld
		CROSS APPLY  OPENJSON((SELECT ereld.OtherDetails))
		INNER JOIN [DataCheckerPersistence].[destination].[RuleExecutionLogs] rel on rel.Id=ereld.RuleExecutionLogId
		inner join DataCheckerPersistence.datachecker.Rules on rules.Id = rel.RuleId
		inner join DataCheckerPersistence.datachecker.Containers on rules.ContainerId = Containers.Id
		inner join DataCheckerPersistence.datachecker.Containers as Collections on containers.ParentContainerId = Collections.id) t1
where t1.rule_order = 1


GO


----------------------------------------------------------------------------------------------------------------------------------
--District Dimension
-----------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW [bi].[dim_District] as
with cte (EducationOrganizationId) as (

	Select DISTINCT RIGHT('000000' + CAST(EducationOrganizationId AS VARCHAR), 6) as EducationOrganizationId
from 
	DataCheckerPersistence.destination.EdFiRuleExecutionLogDetails)
Select 
	EducationOrganizationId
	,CAST(EducationOrganizationId as int) as EducationOrganizationId_int
	,LEFT(EducationOrganizationId, 2) as DistrictId
	,CAST(LEFT(EducationOrganizationId, 2)as int) as DistrictId_int
	
from cte
where EducationOrganizationId is not null
GO

----------------------------------------------------------------------------------------------------------------------------------
--District Dimension
-----------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW [bi].[dim_environments] as
SELECT
	Environments.Id evironments_id,
	Environments.Name  environments_name
FROM
	core.Catalogs as Environments
WHERE Environments.name is not null
GROUP BY 
	Environments.Id,
	Environments.Name
GO

----------------------------------------------------------------------------------------------------------------------------------
--Rules Dimension
-----------------------------------------------------------------------------------------------------------------------------------


CREATE OR ALTER VIEW [bi].[dim_rules] as
SELECT
	Rules.Id rules_id,
	Rules.Name rules_name,
	Rules.Description rules_description,
	Rules.ErrorMessage as 'error_message',
	Rules.ErrorSeverityLevel rules_error_severity_level,
	Rules.Resolution rules_resolution,
	Rules.RuleIdentification rules_identification,
	Rules.Version rules_version,
	Rules.DateUpdated date_updated

FROM
	 datachecker.Rules
		
WHERE rules.name is not null

GROUP BY 
	Rules.Id,
	Rules.Name,
	Rules.Description,
	Rules.ErrorMessage,
	Rules.ErrorSeverityLevel,
	Rules.Resolution,
	Rules.RuleIdentification,
	Rules.Version,
	Rules.DateUpdated
GO


----------------------------------------------------------------------------------------------------------------------------------
--Containers Dimension
-----------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW [bi].[dim_containers] as
SELECT
	Containers.Id	container_id,
	Containers.Name container_name,
	Containers.Description containers_description
FROM
	datachecker.Containers

WHERE containers.ParentContainerId != containers.Id and Containers.name is not null

GROUP BY 
	Containers.Name,
	Containers.Id,
	Containers.Description
GO