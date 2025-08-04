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
<!--- create view --->
<cfparam name="Form.lookupDataSource" default="">
<cfparam name="Form.LookupTable" default="">
<cfparam name="Form.LookupViewScript" default="">

<cfparam name="url.ds"     default="#Form.LookupDataSource#">
<cfparam name="url.name"   default="#Form.LookupTable#">
<cfparam name="url.script" default="#Form.LookupViewScript#">

<!--- add spaces to the script --->

<cfset script = replaceNoCase(url.script,  "FROM", " FROM ", "ALL")> 
<cfset script = replaceNoCase(script,  "WHERE", " WHERE ", "ALL")> 
<cfset script = replaceNoCase(script,  "AND ", " AND ", "ALL")> 

<cfif trim(url.script) neq "">
	
	<cfset isValid = 1>
	
		<cfquery name="ValidateView"
			datasource="#url.ds#">
				#preservesingleQuotes(script)#   
		</cfquery>
		
	
	<cfif isValid eq 1>
	
		<cfquery name="Drop"
			datasource="#ds#">
		      if exists (select * from dbo.sysobjects 
			             where id = object_id(N'[dbo].[#url.name#]') 
		            	 and OBJECTPROPERTY(id, N'IsView') = 1)
		     drop view [dbo].[#url.name#]
		</cfquery>
						
		<cftry>	
			
			<cfquery name="CreateView"
				datasource="#url.ds#">
				CREATE VIEW #url.name#
				AS
				#preservesingleQuotes(script)#   
			</cfquery>			
			
			<cfoutput>
				<img src="#SESSION.root#/Images/check_mark2.gif" align="absmiddle" alt="" border="0"> <font color="008000">View successfully created&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
			</cfoutput>
			
			<cfcatch>	
			  <cfoutput>
			  <img src="#SESSION.root#/Images/alert_stop.gif" align="absmiddle" alt="" border="0"> <font color="red"> view was NOT created on server. Have you provided a view name and have you ensured a space at each line.&nbsp;&nbsp;&nbsp;
			  </cfoutput>
			</cfcatch>
		
		</cftry>
	
	<cfelse>
	
		<cfoutput>
			<img src="#SESSION.root#/Images/alert_stop.gif" align="absmiddle" alt="" border="0"> <font color="red"> Condition not validated, please check your datasource and query.&nbsp;&nbsp;&nbsp;
		</cfoutput>
	
	</cfif>	

</cfif>


<cfoutput>
	<script>
	ColdFusion.navigate('CriteriaEditField.cfm?id=#URL.ID#&Status=#URL.Status#&ID1=#URL.ID1#&ID2=#URL.name#&multiple=#url.multiple#&ds=#url.ds#','lookup')
	</script>

</cfoutput>