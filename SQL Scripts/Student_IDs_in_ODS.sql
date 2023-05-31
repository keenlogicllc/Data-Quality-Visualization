SELECT DISTINCT
    d.CodeValue AS StudentIdentificationSystemDescriptor_CodeValue
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
INNER JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId


SELECT DISTINCT
    AssigningOrganizationIdentificationCode
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
INNER JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId


SELECT
    s.StudentUSI,
    s.StudentUniqueId,
    seoasic.AssigningOrganizationIdentificationCode,
    seoasic.EducationOrganizationId,
    seoasic.IdentificationCode,
    d.CodeValue AS StudentIdentificationSystemDescriptor_CodeValue,
    d.Description AS StudentIdentificationSystemDescriptor_Description
FROM
    edfi.Student s
LEFT JOIN
    edfi.StudentEducationOrganizationAssociationStudentIdentificationCode seoasic ON s.StudentUSI = seoasic.StudentUSI
LEFT JOIN
    edfi.Descriptor d ON seoasic.StudentIdentificationSystemDescriptorId = d.DescriptorId
