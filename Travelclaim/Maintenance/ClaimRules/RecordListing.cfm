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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Validation Rules</TITLE></HEAD>

<body leftmargin="0" topmargin="0" rightmargin="0">

<cfinclude template="RuleInsertData.cfm">

<cfquery name="DutyStation"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
	FROM     Ref_DutyStation
	WHERE Mission IN (SELECT Mission FROM Ref_DutyStationValidation)
</cfquery>

<cf_ajaxRequest>	

<cfoutput>
	
	<script language="JavaScript"> 
	
	function toggle(code) {
	url = "RuleToggle.cfm?ts="+new Date().getTime()+"&code="+code;
	
		AjaxRequest.get({
		        'url':url,
		        'onSuccess':function(req){ 
						
			    document.getElementById("b"+code).innerHTML = req.responseText;},
							
		        'onError':function(req) { 
					      
			     document.getElementById("b"+code).innerHTML = req.responseText;}	
		         }
			 );	
	}
	
	</script>

</cfoutput>

<cf_divscroll>

<cfset Header = "">
<cfset add="0">
<cfinclude template="../HeaderTravelClaim.cfm"> 

<table width="97%" align="center" cellspacing="0" cellpadding="0">

<cfloop query="DutyStation">

<cfoutput>
	<tr> <td colspan="2" height="20" class="labellarge"><i>&nbsp;#Mission#</i></td></tr>
</cfoutput>
         
	<cfquery name="SearchResult"
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT V.*, '#Mission#' as Mission,
		       R.Description as ValidationClassdescription,
		       R.ListingOrder,
			   R.WorkflowEnabled
		FROM   Ref_Validation V, 
               Ref_ValidationClass R
		WHERE  TriggerGroup = 'TravelClaim'
		AND    V.ValidationClass = R.Code
		ORDER BY R.WorkFlowEnabled, R.ListingOrder, R.Code
	</cfquery>
		
	<script language = "JavaScript">
		
	function recordedit(id)	{
          window.open("RecordDialog.cfm?ts="+new Date().getTime()+"&ID=" + id, "Edit", "left=80, top=80, width=660, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
			
	function template(id){
	          window.open("ValidationScript.cfm?id="+id, "script"+id, "left=40, top=40, width=700, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
			
	<tr><td colspan="2">
	
	<table width="97%" cellspacing="0" cellpadding="1" align="center">
	 
		<tr style="height:20px;">
		    <td align="right">Code</td>
			<td width="4%" align="center" ></td>
			<td>Description</td>
			<td></td>
			<td></td>
			<td align="center">Status</td>
		</tr>
		
		<tr> <td class="linedotted" colspan="6"></td> </tr>
		
	<script>
	
	function show(cde) {
	
	row = document.getElementsByName(cde)
	
	count = 0
	
	if (row[count].className == "regular") {
	while (row[count]) {
	   row[count].className = "hide"
	   count++
	}
	} else {

		while (row[count]) {
		   row[count].className = "regular"
		   count++
		}
	}
	
	}
	
	</script>	
	
	<cfoutput query="SearchResult" group="WorkflowEnabled"> 
	
	<tr><td colspan="6" class="labelmedium">&nbsp;
		<i>
		<cfif WorkflowEnabled eq "0">
			Validations prior to submission
		<cfelse>
			Validations that trigger a certain workflow
		</cfif>
		</i>
	</td></tr> 
	<tr><td height="1" colspan="6"></td></tr>
	
	<cfoutput group="ListingOrder"> 
	
		<cfoutput group="ValidationClassdescription"> 
		
		<tr><td colspan="6" class="label" style="padding-left:10px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>#ValidationClassdescription#</b></td></tr> 
		<tr><td height="1" colspan="6"></td></tr>
		
		<cfoutput>
		
		    <cfset cde = "#Code#">
			 
			<cfquery name="Actor"
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   DISTINCT A.*, V.ValidationCode
				FROM     Ref_DutyStationActor A,
				         Ref_DutyStationValidation V
				WHERE   A.Mission = V.Mission
				AND     V.ClearanceActor = A.ClearanceActor
				AND     V.ValidationCode = '#Code#'
		                AND     V.Mission = '#Mission#' 
				AND     V.Operational = 1  
				ORDER By ListingOrder
			</cfquery>
		     
		    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#">
			
			<td align="right"><a title="Edit Settings" href="javascript:recordedit('#Code#')">
			    &nbsp;#Code#
			</a>
			</td>
			
			<td width="4%">
			
			   <cfif actor.recordcount gte "1">
					<cf_img icon="expand" toggle="Yes" onclick="show('#cde#')">
			   </cfif>	
					
			</td>
			
			<td><a title="Edit Settings" href="javascript:recordedit('#Code#')">
			    #Description#</a>
			</td>
			<td>
			
			<cfif enforce eq "1">
			
			 <img src="#SESSION.root#/Images/stop1.gif"
			     alt="Must be resolved before forwarded by actor"
			     border="0"
				 align="absmiddle"
			     style="cursor: hand;">
			
			</cfif></td>
			<td align="center"><b>
			
				<cfif ValidationTemplate neq "">
					<img src="#SESSION.root#/Images/note.gif" 
					     border="0" 
						 align="absmiddle"
						 style="cursor: hand;" 
						 title="Preview script" 
						 onClick="javascript:template('#Code#')">
				</cfif>
			
			</td>
			<td id="b#code#" align="center">
			
				<cfif operational eq "0">
			 
				 <img src="#SESSION.root#/Images/light_red3.gif"
			     alt="Activate"
			     width="24"
			     height="15"
			     border="0"
			     style="cursor: hand;"
			     onClick="toggle('#code#')">
		 
				<cfelse>
			 
				  <img src="#SESSION.root#/Images/light_green2.gif"
			     alt="Disabled"
			     width="24"
			     height="15"
			     border="0"
			     style="cursor: hand;"
			     onClick="toggle('#code#')">
			
			 	</cfif>
			 
			</td>
			</tr>
				
			<!--- actor --->
			
			<cfquery name="Actor"
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  DISTINCT A.*, V.ValidationCode
				FROM    Ref_DutyStationActor A,
				        Ref_DutyStationValidation V
				WHERE   A.Mission = V.Mission
				AND     V.ClearanceActor = A.ClearanceActor
				AND     V.ValidationCode = '#Code#'
		        AND     V.Mission = '#Mission#' 
				AND     V.Operational = 1  
				ORDER By ListingOrder
			</cfquery>
			
			<cfloop query="Actor">
			<tr id="#cde#" class="hide" >
			   <td ></td>
			   <td colspan="2">
			   <a title="Edit rule" href="javascript:recordedit('#cde#')">
			   #ClearanceDescription#
			   </a>
			   </td>
			   <td></td>
			   <td></td>
			</tr>
			
			<cfquery name="Details"
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   *,
			         R.Description as ClaimCategoryDescription,
					 R1.Description as IndicatorDescription,
					 R2.Description as EventDescription
			FROM     Ref_DutyStationValidation V,
			         Ref_ClaimCategory R,
					 Ref_Indicator R1,
					 Ref_ClaimEvent R2
			WHERE   V.ValidationCode = '#ValidationCode#'
			AND     V.Mission        = '#Mission#'
			AND     V.ClearanceActor = '#ClearanceActor#'
			AND     V.Operational = 1
			AND     V.ClaimCategory *= R.Code 
			AND     V.IndicatorCode *= R1.Code 
			AND     V.EventCode *= R2.Code 
			ORDER BY ClaimCategoryDescription,IndicatorDescription
			</cfquery>
			
			<cfif #Details.ClaimCategory# neq "" 
			      or #Details.IndicatorCode# neq "" 
				  or #Details.EventCode# neq "" 
				  or #Details.ThresholdAmount# neq "">
			
			<tr id="#cde#" class="hide">
			   <td></td>
			   <td></td>
			   <td colspan="3">
			   <table width="100%" cellspacing="0" cellpadding="0">
			
			<cfloop query="Details">
			   <cfif #ClaimCategory# eq "DSA" and 
				  #Details.IndicatorCode# eq "" 
				  and #Details.EventCode# eq "" 
				  and #Details.ThresholdAmount# eq "">
			   <cfelse>
			   <tr>
				   <td width="60">#ClaimCategory#</td>
				   <td width="20%">#ClaimCategoryDescription#</td>
				   <td width="60">#IndicatorCode#</td>
				   <td width="20%">#IndicatorDescription#</td>
				   <td width="60">#EventCode#</td>
				   <td width="20%">#EventDescription#</td>
				   <td width="15%">#ThresholdAmount#</td>
				   <td width="5%"><cfif #Operational# eq "0">Disabled</cfif></td>
			   </tr>
			   </cfif>
			   
			   <cfif currentRow neq "#Details.recordcount#">
			    <tr>
					<td colspan="6" class="linedotted"></td>
				</tr>	
			   </cfif>
			   	
		   </cfloop>
			
			   </table>
			   </td>
		   </tr>
		   
		   </cfif>   
			
		   </cfloop>
			
			<cfif #currentRow# neq "#SearchResult.recordcount#">
				<tr><td height="1" colspan="6" class="linedotted"></td></tr>
			</cfif>
			
		</cfoutput>	
		</cfoutput>		
	</cfoutput>
	
	</cfoutput>
	
</table>


</cfloop>


</td>
</tr>

</table>

</cf_divscroll>

</BODY></HTML>