
<cfquery name="Interface" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Interface
	WHERE Code = '#attributes.cde#'
</cfquery>
 
<CFSET Caller.name = "#Interface.Description#"> 

  
  
  