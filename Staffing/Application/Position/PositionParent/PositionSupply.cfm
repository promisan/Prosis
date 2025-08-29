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
<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM   PositionParent		 
	 WHERE  PositionParentId = '#URL.ID2#'	 
</cfquery>

<cfif PositionParent.recordcount eq "0">
    <cf_message message="Problem, Position could not be located. Please contact your administrator.">
    <cfabort>
</cfif>

<cfquery name="Current" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    Ref_Mandate
    WHERE   Mission = '#PositionParent.Mission#'
    AND     MandateNo = '#PositionParent.MandateNo#'
</cfquery>

<cfquery name="PositionChild" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	 *
	FROM 	 Position
	WHERE 	 PositionParentId = '#URL.ID2#' 
	ORDER BY DateEffective DESC
</cfquery>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	 *
	FROM 	 Ref_PostType
	WHERE 	 PostType = '#PositionChild.PostType#' 	
</cfquery>

<cf_divscroll>

<table width="97%" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

	<tr class="noprint" class="line">
   
    <td height="24" colspan="2" style="padding-right:4px">
	
		<cfoutput>	
		<table class="formpadding">
		<tr>
		    <td class="labelit" style="padding-left:5px"><cf_tl id="Post number">:</td>
			<td class="labelmedium2" style="padding-left:5px">#PositionChild.SourcePostNumber#</td>
			<td class="labelit" style="padding-left:10px"><cf_tl id="Mandate">:</td>
			<td class="labelmedium2" style="padding-left:5px">#Current.Description#</td>
			<td class="labelit" style="padding-left:10px"><cf_tl id="Period">:</td>
			<td class="labelmedium2" style="padding-left:5px">#DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)#</td>
		</tr>
		</table>	
		</cfoutput>
		
    </td>
	
	<td align="right">
	
   <cfinvoke component="Service.Access"  
		  method="position" 
		  orgunit="#PositionParent.OrgUnitOperational#" 
		  role="'HRPosition'"
		  posttype="#PositionParent.PostType#"
		  returnvariable="accessPosition">
  
   <cfinvoke component="Service.Access"  
		  method="position" 
		  orgunit="#PositionParent.OrgUnitOperational#" 
		  role="'HRLoaner'"
		  posttype="#PositionParent.PostType#"
		  returnvariable="accessLoaner">
	
	<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
	
		<!--- remove only from the the other tab can be access 
		
		        <table cellspacing="0" cellpadding="0">
				
				
				<tr>
				
					<cfoutput>
				
					<td style="padding-top:1px">
					<cf_img icon="edit" onclick="EditParentPosition('#PositionParent.Mission#','#PositionParent.MandateNo#','#PositionParent.PositionParentId#')">
					</td>
								
					<td style="padding-left:7px" class="labelmedium">			
					<cf_tl id="Parent Position" var="1">  
					<a href="javascript:EditParentPosition('#PositionParent.Mission#','#PositionParent.MandateNo#','#PositionParent.PositionParentId#')">
					<font color="6688AA">#lt_text#</font>
					</a>
					</td>
					
					</cfoutput>
				
				</tr>
				
				</table>
				
				--->

	</cfif>
			
	</td>
  </tr> 
		
  <cfoutput> 
	
	<tr><td colspan="2" style="font-size:25px;height:45px;padding-left:3px;font-weight:200" class="labellarge">Program/Fund and object</td></tr>
	
	<cf_verifyOperational 
         module    = "Program" 
		 Warning   = "No">		 
		
	<cfif operational eq "1">	
	
		<tr><td colspan="2" style="width:400px;padding-left:4px"><font size="1">usage:<b> Budget Planning</td></tr>
		<tr><td height="1" class="line" colspan="2"></td></tr>
	
		<tr><td colspan="2" style="padding-left:20px">
			<cf_securediv bind="url:../Funding/PositionFunding.cfm?ID=#url.id2#" id="fundbox">
		</td></tr>
		
		<cfif PostType.Procurement eq "1">
		
		<tr><td colspan="2" height="4"></td></tr>
		
		<tr><td colspan="2" style="padding-left:4px"><font size="1">usage:<b> Obligation driven</td></tr>
		<tr><td height="1" class="line" colspan="2"></td></tr>
		
		<tr><td colspan="2" style="padding-left:20px">
			<cf_securediv bind="url:../Funding/PositionObligation.cfm?ID=#url.id2#" id="obligbox">
		</td></tr>
		
		</cfif>
					  
	</cfif>	
	
	<tr><td height="10" colspan="2"></td></tr>
	<tr><td colspan="2" style="font-weight:200;font-size:25px;height:45px;padding-left:3px" class="labellarge"><cf_tl id="Relationships"></td></tr>
	<tr><td style="min-width:50%" style="padding-left:4px"><font size="1">usage:<b> Workforce relationships</td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	<tr class="hide"><td id="positionbox_detail" class="line" colspan="2"></td></tr>
	
	<cfloop index="itm" list="Supervisor,Administrator,Partner">	
	
	    <cfquery name="Relation" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT      PR.PositionNoRelation, 
			            PO.FunctionNo, 
						PO.FunctionDescription, 
						PO.SourcePostNumber, 
						PO.PositionParentId,
						PO.PositionNo, 
						PR.OfficerUserId, 
						PR.OfficerLastName, 
						PR.OfficerFirstName, 
						PR.Created
			FROM        PositionRelation AS PR INNER JOIN
                        Position AS PO ON PR.PositionNoRelation = PO.PositionNo
			WHERE       PR.PositionNo = '#url.id#' 
			AND         PR.RelationClass = '#itm#'			
		</cfquery>				
		
	    <tr class="labelmedium2 linedotted">
		  <td style="width:200px;padding-left:34px"><cf_tl id="#itm#"></td>
		 		 		 
		  <td style="min-width:50%;height:100%">
		      <table style="width:100%" class="navigation_table">
		      <tr class="labelmedium2 navigation_row">
			  <td style="width:30px">
			  
			    <cfset link = "#SESSION.root#/Staffing/Application/Position/PositionParent/getPosition.cfm?pos=#url.id#&class=#itm#">
							
		  		<cf_selectlookup
				    box          = "positionbox_detail"
					title        = "Position Search"
					icon         = "search.png"
					link		 = "#link#"
					des1		 = "PositionNo"
					filter1      = "Mission"
					filter1Value = "#positionchild.mission#"
					button       = "No"
					style        = "width:25px;height:25px"
					close        = "Yes"			
					datasource	 = "AppsEmployee"		
					class        = "PositionSingle">	
					
			  </td>
			  
			  <td><cf_img icon="delete" onclick="ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/getPosition.cfm?action=delete&pos=#url.id#&class=#itm#','positionbox_detail')"></td>			  
			  <td id="#itm#_1" style="width:40px"><cfif relation.SourcePostNumber eq "">#relation.PositionParentId#<cfelse>#relation.SourcePostNumber#</cfif></td>
			  <td id="#itm#_2" style="padding-left:5px;min-width:150px">#relation.FunctionDescription#</td>
			  <td id="#itm#_3" style="padding-right:5px" align="right">#relation.OfficerLastName# #dateformat(relation.created,client.dateformatshow)#</td>
			  </tr>
			  </table>
		  </td>
		  
		</tr>	
		
	</cfloop>
	
		
	<tr><td height="10" colspan="2"></td></tr>
	<tr><td colspan="2" style="font-weight:200;font-size:25px;height:45px;padding-left:3px" class="labellarge"><cf_tl id="Workforce class"></td></tr>
	<tr><td style="min-width:50%" style="padding-left:4px"><font size="1">usage:<b> Workforce Classification and Planning</td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	
	<cf_verifyOperational 
         module    = "Program" 
		 Warning   = "No">
	
	<cfif operational eq "1">
	
		<tr><td colspan="2" style="padding-left:20px">
			<cf_securediv bind="url:WorkforceEntry.cfm?ID=#url.id#" id="workbox">
		</td></tr>
		
	<cfelse>
	
		<tr><td align="center"><font color="808080">Function not operational</td></tr>	
			  
	</cfif>	
	
	
	<tr><td height="10" colspan="2"></td></tr>
	<tr><td colspan="2" style="font-weight:200;font-size:25px;height:45px;padding-left:3px" class="labellarge"><cf_tl id="Roster"> <font size="3">from which candidates for this position will be sourced</td></tr>
	<tr><td colspan="2" style="padding-left:4px"><font size="1">usage:<b> <cf_tl id="Roster Forecasting"></td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	
	<cf_verifyOperational 
         module    = "Roster" 
		 Warning   = "No">
	
	<cfif operational eq "1">
	
		<tr><td colspan="2" style="padding-left:20px">
			<cfdiv bind="url:../Edition/Edition.cfm?ID=#url.id2#" id="editionbox">
		</td></tr>
		
	<cfelse>
	
		<tr><td colspan="2" align="center"><font color="808080">Function not operational</td></tr>	
			  
	</cfif>	
	
	</cfoutput>	
	
</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>