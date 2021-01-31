<!--- select a relevant authorization group --->

<cfparam name="url.selected"   default="">
<cfparam name="url.scope"      default="amend">
<cfparam name="url.entitycode" default="">
<cfparam name="url.owner"      default="">

<cfquery name="Workgroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_EntityGroup
		WHERE   EntityCode = '#url.entityCode#'
		AND (Owner is NULL or Owner = '#URL.Owner#')
		AND  Operational = 1
</cfquery>

<cfif WorkGroup.recordcount gte "1">

    <cfoutput>
    <select name="#url.scope#Workgroup" id="#url.scope#Workgroup" class="regularxxl enterastab">
	 	<cfif WorkGroup.recordcount gt 1>
		 	<option value="0">[Select]</option>
		</cfif>
	    <cfloop query="Workgroup">
		<option value="#EntityGroup#" <cfif EntityGroup eq url.selected> selected </cfif>>#EntityGroupName#</option>
		</cfloop>
    </select>
	</cfoutput>
		
	<script>
		 b = document.getElementById("Save");
		 if (b)
		     b.className = "button10g"
	</script>
		
<cfelse>
	
	<script>
		 b = document.getElementById("Save");
		 if (b)
			 b.className = "hide"
	</script>
	
	<table><tr><td class="labelmedium2">
		
	<font color="FF0000">Workflow not configured</font>	
	
	</td></tr></table>
		
</cfif>		