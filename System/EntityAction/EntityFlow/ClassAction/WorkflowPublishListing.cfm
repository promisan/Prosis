<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
