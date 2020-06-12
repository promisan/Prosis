

<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Position	 
	 WHERE PositionParentId = '#positionparentid#'	
	 ORDER BY PositionNo DESC 
</cfquery>

<cfquery name="Active" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   D.DocumentNo, DP.PositionNo
	FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
	WHERE    D.Status = '0' 
	AND      DP.PositionNo IN ( SELECT PositionNo
							    FROM   Position	P 
							    WHERE  PositionParentId = '#positionparentid#' )
	ORDER BY DocumentNo DESC		
				   
</cfquery>

<cfif Active.recordcount eq "0">

	<cfoutput>
	<a href="javascript:AddVacancy('#Parent.PositionNo#','#url.ajaxid#')"><cf_tl id="Request recruitment"></a> 
	</cfoutput>

<cfelse>
	
	<cfquery name="Doc" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Document
		WHERE DocumentNo = '#Active.DocumentNo#'
	</cfquery>
	
	<cfquery name="Position" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Position
		WHERE PositionNo = '#Doc.PositionNo#'
	</cfquery>
	
	<cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#url.ajaxid#&IDCandlist=ZoomIn&ActionId=undefined">
	 					
	<cf_ActionListing 
	    ReadMode         = "read_uncommitted"     
	    TableWidth       = "100%"
	    EntityCode       = "VacDocument"
		EntityClass      = "#Doc.EntityClass#"
		EntityGroup      = "#Doc.Owner#"
		EntityStatus     = ""		
		Mission          = "#Doc.Mission#"
		OrgUnit          = "#Position.OrgUnitOperational#"
		ObjectReference  = "#Doc.FunctionalTitle#"
		ObjectReference2 = "#Doc.Mission# - #Doc.PostGrade#"
		ObjectKey1       = "#Doc.DocumentNo#"	
		AjaxId           = "#URL.ajaxId#"
	  	ObjectURL        = "#link#"
		Show             = "Mini"
		DocumentStatus   = "#Doc.Status#">

</cfif>

 	
 		
	
	
	