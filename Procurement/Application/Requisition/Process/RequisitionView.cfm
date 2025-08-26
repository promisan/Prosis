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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" 
     scroll="No" 
	 label="Procurement Request" 
	 layout="webapp" 
	 jquery="Yes"
	 banner="red">

<cfoutput>

<cfparam name="URL.action" default="">

<cfif url.action eq "Save">
		
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Requisition
			SET    RequisitionPurpose = '#Form.RequisitionPurpose#'
			WHERE  Reference        = '#URL.RequisitionRef#'
	</cfquery>

</cfif>

<cfquery name="Header" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Requisition
	WHERE  Reference = '#URL.RequisitionRef#'
</cfquery>

<cfquery name="Requisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   RequisitionLine
	WHERE  Reference = '#URL.RequisitionRef#'
</cfquery>

<cfquery name="RequisitionLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    L.*, 
		          S.Description as ActionDescription,
				  I.Description, 
				  Org.Mission, 
				  Org.MandateNo, 
				  Org.HierarchyCode, 
				  Org.OrgUnitName
		FROM      RequisitionLine L, 
		          ItemMaster I, 
				  Organization.dbo.Organization Org,
				  Status S
		WHERE     L.OrgUnit     = Org.OrgUnit
		AND       S.Status      = L.ActionStatus
		AND       S.StatusClass = 'Requisition'
		AND       L.ActionStatus != '9'
		<!---
		AND       L.RequisitionNo IN (SELECT RequisitionNo 
		                            FROM RequisitionLineAction 
									WHERE OfficerUserId = '#SESSION.acc#') --->
		AND       I.Code      =  L.ItemMaster   	
		AND       L.Period    = '#Requisition.Period#'	
		AND       Org.Mission = '#URL.Mission#'			
		AND       L.Reference = '#URL.RequisitionRef#'			
		ORDER BY  L.Reference,S.Status					
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>	

<cf_divscroll>

<table width="100%" border="0">

<tr><td>

<cfform action="RequisitionView.cfm?Mission=#url.mission#&period=#Requisition.period#&RequisitionRef=#URL.RequisitionRef#&action=save" method="POST">

<table width="94%" align="center" class="formpadding">

<tr><td height="6"></td></tr>

<tr class="labelmedium2">
   <td width="8%"><cf_tl id="Reference">:</td>
   <td>#Requisition.Reference#</td>
   <td width="8%"><cf_tl id="Period">:</td>
   <td>#Requisition.Period#</td>
</tr>

<tr class="labelmedium2">
   <td><cf_tl id="Issued">:</td>
   <td>#Requisition.OfficerFirstName# #Requisition.OfficerLastName#</td>
   <td><cf_tl id="Submitted">:</td>
   <td>#dateformat(Requisition.Created,CLIENT.DateFormatShow)#</td>
</tr>

<tr class="labelmedium2">
   <td valign="top" style="padding-top:5px"><cf_tl id="Justification">:</b></td>
   <td width="90%" colspan="3">
         <textarea style="width:100%;height:60px;font-size:16px;padding:4px" name="RequisitionPurpose" class="regular">#Header.RequisitionPurpose#</textarea>
   </td>
</tr>

<tr><td height="2"></td></tr>

<CFIF requisition.recordcount gt "0">

	<tr>
		<td colspan="4" align="center">	 
		<cf_tl id="Save" var="1">
		   <input type="submit" name="Submit" id="Submit" value="#lt_text#" class="button10g" style="width:190;height:28">
		</td>
	</tr>
	
</CFIF>

<tr><td height="1" colspan="4" class="line"></td></tr>
<tr><td height="2"></td></tr>

<tr><td colspan="4">

	<cfset fun = "funding">
	<cfinclude template="RequisitionViewListing.cfm">

</td></tr>

<tr><td height="4"></td></tr>

</table>

</cfform>

</td></tr>

</table>

</cf_divscroll>

</cfoutput>

<cf_screenbottom layout="webapp">
