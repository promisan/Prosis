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
<!--- ripple list 
	
	select mission (Ref_ParameterMission)
	select itemmaster / OE combination as enabled for the selected mission	: Ref_ItemMasterMission, 
	   and enabled for OE 
	ripple mode (1,2,3) as per below
	operational
	ripple amount
	
	Select another 
	    ItemMaster (enabled, 
	    OE, Mission, amount to ripple an single entry for this itemmaster to.
	
	The total is either 
	
	an amount (1)
	an amount per Resource quantity (2)
	an amount per Request Quantity (3)
		
	
	Inherit to ProgramAllotmentRequirement
	
	 only if the OE is part of the OE schedule defined through the edition (ObjectUsage) for which it is recorded.

--->

<cfparam name="url.mode" default="view">

<cfquery name="RippleList" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   R.* 
	  FROM     ItemMasterRipple R LEFT OUTER JOIN
	  		   ItemMasterList I ON I.ItemMaster = R.Code AND I.TopicValueCode = R.TopicValueCode				
	  WHERE    R.Code = '#url.code#'
	  ORDER BY R.Mission,I.ListOrder
</cfquery>

<div id="result"></div>

<table width="100%" class="navigation_table">

<tr class="labelmedium2 line">
	<td style="padding-left:2px"><cf_tl id="Entity"></td>
	<td style="padding-left:2px"><cf_tl id="List"></td>
	<td style="padding-left:2px"><cf_tl id="Effective"></td>
	<td><cf_tl id="Ripple to Item Master"></td>
	<td><cf_tl id="Object"></td>
	<td><cf_tl id="Ripple Mode"></td>
	<td align="right"><cf_tl id="Amount"></td>
	<td width="5%" align="right" >O</td>
	<td></td>
	<td></td>
</tr>

<cfif url.mode eq "add">

  	<cfset rippleitemmaster = "">
	<cfset mission          = "">
	<cfset mis              = "">	
	<cfset top              = "">	
	<cfset rippleobjectcode = "">	
	<cfset dateeffective    = "#dateformat(now(),client.datesql)#">	
	<cfset budgetmode       = "">	
	<cfset operational      = 1>	
	<cfinclude template     = "RippleRow.cfm">
	<cfset url.mode         = "view">
	
</cfif>

<cfset vMode = url.mode>

<cfoutput query="rippleList" group="mission">

	<cfset pr = "">

	<cfoutput group="topicvaluecode">
		
		<cfoutput>		
		
			<cfset mis = mission>
			<cfset top = topicvaluecode> 
			
			 <cfif vMode eq "edit">
			 
				<cfif TopicValueCode eq URL.id1 
					AND Mission eq URL.id2
					AND RippleItemMaster eq URL.id3
					AND RippleObjectCode eq URL.id4>
					<cfset url.mode = "edit">			
				 <cfelse>
					 <cfset url.mode = "view">	
				 </cfif>	
					
			 <cfelse>
			 	<cfset url.mode = "view">	
			 </cfif>
			 
			 <cfif pr neq top>
				 <tr><td colspan="9" class="line"></td></tr> 	
				 <cfset pr = top>
			 </cfif>
			 
			 <cfinclude template="RippleRow.cfm">
		
		</cfoutput>
	
	</cfoutput>

</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	