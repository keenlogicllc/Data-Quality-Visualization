WITH CTE AS (
    SELECT
        s.studentuniqueId,
        sa.StudentUSI,
        ssa.EducationOrganizationId,
        eo.NameOfInstitution,
        a.AssessmentTitle,
        sa.AssessmentIdentifier,
        sa.StudentAssessmentIdentifier,
        sa.AdministrationDate,
        sasoa.IdentificationCode,
        sasoa.CreateDate,
        sa.Namespace
    FROM
        edfi.Student s
        INNER JOIN edfi.StudentSchoolAssociation ssa ON s.StudentUSI = ssa.StudentUSI
        INNER JOIN edfi.StudentAssessment sa ON sa.StudentUSI = s.StudentUSI
        INNER JOIN edfi.Assessment a ON sa.AssessmentIdentifier = a.AssessmentIdentifier
        INNER JOIN edfi.EducationOrganization eo ON eo.EducationOrganizationId = ssa.SchoolId
        LEFT JOIN edfi.StudentAssessmentStudentObjectiveAssessment sasoa ON s.StudentUSI = sasoa.StudentUSI
            AND sa.StudentAssessmentIdentifier = sasoa.StudentAssessmentIdentifier
)
SELECT
    COUNT(DISTINCT StudentUSI) AS StudentCount,
    t1.NameOfInstitution,
    t1.AssessmentTitle
FROM
    CTE t1
GROUP BY
    NameOfInstitution,
    AssessmentTitle
ORDER BY
    NameOfInstitution,
    AssessmentTitle;
