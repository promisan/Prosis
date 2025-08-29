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
<cfparam name="url.scopetable"  default="">
<cfparam name="url.checked"     default="">

<cfif url.scopetable eq "Ref_TopicEntryClass">

	<cfset refTable     = "Ref_EntryClass">
	<cfset refField     = "EntryClass">
	<cfset missionTable = "Ref_ParameterMissionEntryClass">
	
<cfelseif url.scopetable eq "Ref_TopicOrderType">

	<cfset refTable     = "Ref_OrderType">
	<cfset refField     = "OrderType">
	<cfset missionTable = "Ref_OrderTypeMission">
	
<cfelse>

	<font color="red">Sorry, I am not able to determine the scope of this topic.</font>
	<cfabort>
	
</cfif>


<cfif url.checked neq "">

	<cfif url.checked eq "true">
	
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    	INSERT INTO #url.scopetable# 
				(Code,
				 #refField#,
				 Created)
			VALUES(
				'#url.topic#',
				'#url.class#',
				getdate()
			)
			
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE FROM #url.scopetable#
			WHERE  Code       = '#url.topic#'
			AND    #refField# = '#url.class#'
		</cfquery>
		
	</cfif>
	
</cfif>

<cfquery name="Select" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT C.Code, C.Description, EC.Code as Selected
	FROM   #refTable# C
	LEFT   JOIN #url.scopetable# EC
		   ON C.Code = EC.#refField# AND EC.Code = '#url.topic#'
	ORDER  BY C.ListingOrder

</cfquery>


<cfset columns = 4>
<cfset cont    = 0>

<cfoutput>

<table width="100%">
			
	<cfloop query="Select">
	
		<cfif cont eq 0> <tr style="height:20px;" class="line labelmedium2"> </cfif>
		<cfset cont = cont + 1>
		
		<td style="width:20px" bgcolor="<cfif selected neq "">ffffbf</cfif>">
		 	<input type="checkbox" class="radiol" value="#code#" <cfif Selected neq "">checked="yes"</cfif> onClick="javascript:ColdFusion.navigate('#SESSION.root#/Tools/Topic/Purchase/Class.cfm?scopetable=#url.scopetable#&Topic=#URL.Topic#&class=#code#&checked='+this.checked,'#url.topic#_class')">
		</td>
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>"  style="padding-left:5px;padding:1px;">#Description#</td>		
		<td bgcolor="<cfif selected neq "">ffffbf</cfif>"  style="padding:1px; font-size:8pt;">
		
			<cfif selected neq "">
			
				<cfquery name="Mission" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					SELECT DISTINCT Mission
					FROM   #missionTable#
					WHERE	
						<cfif  refField eq "EntryClass"> 
							EntryClass  = '#code#' 
						<cfelseif refField eq "OrderType"> 
							Code = '#code#' 
						</cfif>	
				</cfquery>
				
				<cfset missionList = "">
				<cfloop query="Mission">
					<cfif missionList eq "">
						<cfset missionList = "<ul> <li>" & #Mission# & "</li>">
					<cfelse>
						<cfset missionList = #missionList# & " <li>"& #Mission# &"</li>">
					</cfif>
				</cfloop>
			
				<cfset missionList = missionList & "</ul>">
			
				<cf_UIToolTip tooltip="Enabled for entities: <br> #missionList#">
					<img src="#SESSION.root#/images/info.gif" 
					 style="cursor:pointer">
				</cf_UIToolTip>
			</cfif>
			
		</td>
				 
		 <cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
		 
	 </cfloop>
	 
	 <tr class="hide">
	 	<td colspan="#columns#" height="25" align="center">  <cfif url.checked neq "">  <font color="0080C0"> Saved! <font/> </cfif>  </td>
	 </tr>
	 
</table>

</cfoutput>
