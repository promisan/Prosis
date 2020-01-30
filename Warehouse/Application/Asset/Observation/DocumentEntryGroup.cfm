<!--- select a relevant authorization group --->

<cfparam name="url.selected" default="">

<cfquery name="Workgroup" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_EntityGroup
	WHERE    EntityCode = 'AssObservation'
	AND      (Owner is NULL or Owner = '#URL.Owner#')
</cfquery>

<cfif WorkGroup.recordcount gte "1">

    <select name="Workgroup" id="Workgroup" class="regularxl">
	    <cfoutput query="Workgroup">
			<option value="#EntityGroup#" <cfif entitygroup eq url.selected>selected</cfif>>#EntityGroupName#</option>
		</cfoutput>
    </select>
	
	<script>
	   document.getElementById("save").className = "button10g"
	</script>
	
<cfelse>

	<script>
	   document.getElementById("save").className = "hide"
	</script>
	
	<font face="Verdana" size="1" color="FF0000">Workgroups have not been configured</font>	
	
</cfif>		