
<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET FileNo  = Attributes.FileNo>

<!--- select the defined functions --->

<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Announcement'
       </cfquery>

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_AnnSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT S.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_AnnSelect
       FROM  IMP_VacancyCandidate S
       WHERE  VacancyNo IN (SELECT SelectId
                    		FROM RosterSearchLine
                       		WHERE SearchId = '#URL.ID#'
                    		AND SearchClass = 'Announcement')
   </cfquery>
   
</cfoutput>
