<cfoutput>

<cfset URL.DataSource= #Replace(URL.Datasource,"|","\")#>

<cfif URL.Datasource neq "">
	<cftry>
		<cfquery name="qDPublish" datasource="AppsOrganization">
			SELECT     TOP 1 *
			FROM    [#URL.DataSource#].Organization.dbo.Ref_EntityClassPublish
			WHERE  (EntityCode = '#URL.EntityCode#') 
			AND (EntityClass = '#URL.EntityClass#')
			ORDER BY ActionPublishNo DESC
		</cfquery>
		
		<cfoutput>
		
		<cfset URL.DataSource= #Replace(URL.Datasource,"\","|")#>
		
		<select name="sPublish" id="sPublish" onChange="ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/WorkflowDisplayComparison.cfm?DataSource=#URL.DataSource#&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo='+this.value,'divComparison');" class="regularxl">
			<option value=""></option>		
			<option value="0">Draft</option>
			<cfloop query="qDPublish">
				<option value="#qDPublish.ActionPublishNo#">#qDPublish.ActionPublishNo# - #DateFormat(qDPublish.DateEffective,CLIENT.DateFormatShow)#</option>
		    </cfloop>
		</select>	
		</cfoutput>
	<cfcatch>
		Error connecting to '#URL.Datasource#'
	</cfcatch>	
	</cftry>		
</cfif>

</cfoutput>
