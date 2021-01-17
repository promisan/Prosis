<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" 
     scroll="No" 
	 label="Procurement Request" 
	 layout="webapp" 
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

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="6"></td></tr>

<tr class="labelmedium2">
   <td width="8%"><cf_tl id="Reference">:</b></td>
   <td>#Requisition.Reference#</td>
</tr>

<tr class="labelmedium2">
   <td width="8%"><cf_tl id="Period">:</b></td>
   <td>#Requisition.Period#</td>
</tr>

<tr class="labelmedium2">
   <td><cf_tl id="Issued">:</b></td>
   <td>#Requisition.OfficerFirstName# #Requisition.OfficerLastName#</td>
</tr>

<tr class="labelmedium2">
   <td><cf_tl id="Submitted">:</b></td>
   <td>#dateformat(Requisition.Created,CLIENT.DateFormatShow)#</td>
</tr>

<cfform action="RequisitionView.cfm?action=save&Mission=#url.mission#&RequisitionRef=#URL.RequisitionRef#" method="POST">
<tr class="labelmedium2">
   <td valign="top" style="padding-top:4px"><cf_tl id="Justification">:</b></td>
   <td width="90%">
         <textarea style="width:100%;height:90;font-size:13px;padding:4px" name="RequisitionPurpose" class="regular">#Header.RequisitionPurpose#</textarea>
   </td>
</tr>

<tr><td height="2"></td></tr>
<tr><td height="1" colspan="2" class="line"></td></tr>

<CFIF requisition.recordcount gt "0">

	<tr>
		<td colspan="2" align="center">	 
		   <input type="submit" name="Submit" id="Submit" value="Save Justification" class="button10g" style="width:150;height:25">
		</td>
	</tr>
	
</CFIF>

<tr><td height="1" colspan="2" class="line"></td></tr>
<tr><td height="2"></td></tr>

<tr><td colspan="2">

	<cfset fun = "funding">
	<cfinclude template="RequisitionViewListing.cfm">

</td></tr>


<tr><td height="4"></td></tr>

</cfform>

</table>

</td></tr>

</table>

</cf_divscroll>

</cfoutput>

<cf_screenbottom layout="webapp">
