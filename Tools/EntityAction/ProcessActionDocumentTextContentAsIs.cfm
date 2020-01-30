
  <cfquery name="Doc" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SET     TextSize 1000000 
			SELECT  O.*, R.DocumentMode, R.DocumentCode,R.DocumentLayout
			FROM    OrganizationObjectActionReport O INNER JOIN
                    Ref_EntityDocument R ON O.DocumentId = R.DocumentId
			WHERE   O.ActionId   = '#url.MemoActionID#'
			AND     O.DocumentId = '#url.documentid#' 
	  </cfquery>		  	  

<cfdiv id="MarginHold" class="hide">   <!--- dummy div to use for ColdFusion.navigate update of top margin --->
<cfset text = replace(doc.DocumentContent,"<script","<disable","all")>
<cfset text = replace(text,"<iframe","<disable","all")>				
<cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput>

	