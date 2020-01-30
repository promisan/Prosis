
<!--- Position publications --->

query 

SELECT    R.EditionDescription, R.DateEffective, R.DateExpiration, E.Reference, E.PublishMode, R.Owner
FROM      Ref_SubmissionEditionPosition E INNER JOIN
                      Ref_SubmissionEdition R ON E.SubmissionEdition = R.SubmissionEdition
WHERE     E.PositionNo IN
                          (
						  	SELECT    PositionNo
                            FROM     Employee.dbo.Position
                            WHERE    PositionParentId = (SELECT  PositionParentId
														 FROM    Position
														 WHERE   PositionNo = '#url.PositionNo#')
						  ) 
AND        E.RecordStatus = '1'
	

