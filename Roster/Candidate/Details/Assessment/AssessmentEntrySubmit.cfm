
<!--- verify if a submission record exists --->

<cfparam name="FORM.FieldId" default="">

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
SELECT  * 
FROM    ApplicantAssessment
WHERE   PersonNo = '#Form.Personno#'
AND     Owner      = '#URL.Owner#'
</cfquery>

<cfquery name="Clear" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	DELETE FROM ApplicantAssessmentDetail
	WHERE   AssessmentId = '#Check.AssessmentId#'
	AND     Source = '#URL.Source#'
</cfquery>

<!--- add background fields level, geo, exp after identifying the assigned serialNo --->
 
<cfloop index="Item" 
        list="#Form.FieldId#" 
        delimiters="' ,">
		
<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    INSERT INTO dbo.[ApplicantAssessmentDetail] 
           (AssessmentId,
		   Owner,
		   Source,
		   SkillCode,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
   VALUES ('#Check.AssessmentId#', 
          '#URL.Owner#',
		   '#URL.Source#',
		  '#Item#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
 </cfquery>
		  
</cfloop>	

<cfset url.id2 = "read">
<cfinclude template="AssessmentDetail.cfm">
	

