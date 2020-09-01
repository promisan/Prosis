
<cfquery name="Content" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT     *
	    FROM       Ref_EntityDocumentQuestion P
	    WHERE      QuestionId = '#url.id#'		   
    </cfquery>	

<cfoutput>	
<table width="100%">
	<tr class="labelmedium"><td style="padding:5px;font-size:18px">#Content.QuestionMemo#</td></tr>
</table>	
</cfoutput>