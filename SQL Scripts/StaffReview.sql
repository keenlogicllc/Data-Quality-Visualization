------------------------------------------------------
--TITLE: Staff Review
------------------------------------------------------

------------------------------------------------------------------------------------------
--PURPOSE: Use this query to see basic staff information alongside Assignments and Employment info
------------------------------------------------------------------------------------------

-------------------------------------------------------------
--Knowledge of these tables is needed:
	
    --SELECT * from edfi.Staff

    --The below staff tables act similary to the StudentSchoolAssociation in that they connect the staff record to the organization and 
    --allow the key/secret pair being used by the client to access the records associated to those in the edfi.Staff table. If a staff member 
    --does not have either an Assignment Association or Employment Association, then the API will return an error and not allow the client
    --to make any CRUD actions for that staff record.

	--SELECT * from edfi.StaffEducationOrganizationAssignmentAssociation        --Maintains the current assignment for the staff member
	--SELECT * from edfi.StaffEducationOrganizationEmploymentAssociation        --Maintains whether or not the staff member is employed in the LEA

-------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
    Sch.LocalEducationAgencyId,
    Sch.SchoolId,
    EO.NameOfInstitution,
    Stf.FirstName,
    Stf.MiddleName,
    Stf.LastSurname,
    Stf.StaffUSI,
    Stf.YearsOfPriorTeachingExperience,
    Stf.HighlyQualifiedTeacher,
    SEOAA.BeginDate AS AssignmentBeginDate,
    SEOAA.EndDate AS AssignmentEndDate,
    DstaffClass.CodeValue AS StateJobCode,
    DstaffClass.Description AS StateJobDescription,
    SEOAA.PositionTitle,
    Dassign.Description AS HighestLevelofEducation,
    SEOEA.EducationOrganizationId AS EmploymentSchool,
    Demploy.Description AS EmploymentStatus,
    SEOEA.HireDate AS EmploymentHireDate,
    SEOEA.EndDate AS EmploymentEndDate,
    DempSep.Description AS SeparationReason
FROM
    [edfi].[Staff] Stf
    FULL OUTER JOIN edfi.StaffEducationOrganizationAssignmentAssociation SEOAA ON Stf.StaffUSI = SEOAA.StaffUSI
    FULL OUTER JOIN edfi.StaffEducationOrganizationEmploymentAssociation SEOEA ON Stf.StaffUSI = SEOEA.StaffUSI
    LEFT JOIN edfi.School Sch ON SEOAA.EducationOrganizationId = Sch.SchoolId
    LEFT JOIN edfi.EducationOrganization EO ON SEOAA.EducationOrganizationId = EO.EducationOrganizationId
    LEFT JOIN edfi.Descriptor Dassign ON Dassign.DescriptorId = Stf.HighestCompletedLevelOfEducationDescriptorId
    LEFT JOIN edfi.Descriptor Demploy ON Demploy.DescriptorId = SEOEA.EmploymentStatusDescriptorId
    LEFT JOIN edfi.StaffClassificationDescriptor SCD ON SEOAA.StaffClassificationDescriptorId = SCD.StaffClassificationDescriptorId
    LEFT JOIN edfi.Descriptor DempSep ON DempSep.DescriptorId = SEOEA.SeparationReasonDescriptorId
    LEFT JOIN edfi.Descriptor DstaffClass ON DstaffClass.DescriptorId = SEOAA.StaffClassificationDescriptorId
--WHERE
    --SEOAA.EndDate IS NOT NULL
    -- AND SCT.Description = 'Principal'
    -- AND Dassign.Description = 'Did Not Graduate High School'
ORDER BY
    Sch.LocalEducationAgencyId,
    Sch.SchoolId
