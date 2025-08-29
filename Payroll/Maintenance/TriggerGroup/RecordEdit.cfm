<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.idmenu" default="">
<cfparam name="URL.ID1" default="">

<cfquery name="get"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_TriggerGroup
		WHERE	TriggerGroup = '#url.id1#'
</cfquery>

<cfquery name="EntityAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityAction
		WHERE  EntityCode = 'Ent#URL.ID1#'
		AND    Operational = 1
		AND    ActionType IN ('Action','Decision')
		ORDER BY ListingOrder
</cfquery>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  title="Trigger Group" 			  
			  label="Trigger Group #url.id1#" 
			  line="no"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?id1=#url.id1#" method="POST" name="dialog">

	<cfoutput>
	
		<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">
		
		    <tr><td height="10"></td></tr>
				
			<TR class="labelmedium">
		    <TD width="120"><cf_tl id="Code">:</TD>
		    <TD>
				#url.id1#
		    </TD>
			</TR>
		
			<TR class="labelmedium2">
		    <TD><cf_tl id="Description">:</TD>
		    <TD>
				<cfinput 	
					type="text" 
					name="Description" 
					value="#get.Description#" 
					message="please enter a description" 
					required="yes" 
					size="30" 
			   		maxlength="50" 
					class="regularxxl">
		    </TD>
			</TR>
			
			<TR class="labelmedium2">
		    <TD><cf_tl id="Reviewer Action 1">:</TD>
		    <TD>
				<select name="ReviewerActionCodeOne" style="width:200px" class="regularxxl">
					<option value="">N/A</option>
					<cfloop query="EntityAction">
						<option value="#ActionCode#" <cfif get.ReviewerActionCodeOne eq ActionCode>selected</cfif>>#ActionDescription#</option>
					</cfloop>  
				</select>  
		    </TD>
			</TR>
			
			<TR class="labelmedium2">
		    <TD><cf_tl id="Reviewer Action 2">:</TD>
		    <TD>
				<select name="ReviewerActionCodeTwo" style="width:200px"  class="regularxxl">
					<option value="">N/A</option>
					<cfloop query="EntityAction">
						<option value="#ActionCode#" <cfif get.ReviewerActionCodeTwo eq ActionCode>selected</cfif>>#ActionDescription#</option>
					</cfloop>  
				</select>
		    </TD>
			</TR>
			
			<tr><td></td></tr>
			
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td colspan="2" align="center" height="30" id="processSubmit">
			    <input class="button10g" type="submit" name="Save" value=" Save ">
			</td></tr>
						
		</table>
	
	</cfoutput>

</CFFORM>

