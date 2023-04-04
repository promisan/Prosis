
 <!--- workflow driven --->	
				
	<cfquery name="subAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT       D.DocumentId, D.DocumentCode, D.DocumentDescription, D.DocumentOrder, D.DocumentTemplate
		FROM         Ref_EntityActionDocument AS A INNER JOIN
		             Ref_EntityDocument AS D ON A.DocumentId = D.DocumentId
		WHERE        A.ActionCode = '#url.actioncode#'
		AND          DocumentType = 'activity'
		AND          DocumentMode = 'notify'
		AND          D.Operational = 1
		ORDER BY     D.DocumentOrder		
	</cfquery>
	
	<table width="100%">
	<cfloop query="subaction">		
		<tr class="labelmedium"><td colspan="2" id="inspectionbox">									
		<cfinclude template="../../../../#DocumentTemplate#">		
		</td></tr>		
	</cfloop>
	</table>
	
	<script>Prosis.busy('no')</script>