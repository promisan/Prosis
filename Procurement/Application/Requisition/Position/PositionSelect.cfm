
<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   RequisitionLine 
	   WHERE  RequisitionNo = '#url.id#'
</cfquery>
		
<cfoutput>

	<table width="100%" align="center" border="0" style="padding:2px;border:0px dotted silver" cellspacing="0" cellpadding="0">
			
		<cfset link = "#SESSION.root#/Procurement/Application/Requisition/Position/PositionFunding.cfm?access=#url.access#&reqid=#url.id#">
		
		<!--- allow buyer to modify this information to select a different position --->
		
		<!---				
		<cfif url.access eq "Edit" or (Line.ActionStatus eq "2i" or Line.ActionStatus eq "2k") or getAdministrator(line.mission) eq "1">
		--->
		
		<cfif url.access eq "Edit" or Line.ActionStatus eq "2k" or getAdministrator(line.mission) eq "1">
			
			<tr><td height="1"></td></tr>	
			<tr>
				<td height="20" colspan="6" align="left" class="labelmedium" style="padding-left:2px">
				
				<cf_selectlookup
				    class        = "Position"
				    box          = "pos#url.id#"
					title        = "Select workforce position to be funded"
					link         = "#link#"			
					dbtable      = "Employee.dbo.PositionParentFunding"
					des1         = "PositionParentId"
					icon         = "Search.png"
					iconheight   = "22"
					iconwidth    = "22"
					close        = "Yes"
					filter1      = "requisitionno"
					filter1value = "#url.id#"
					filter2      = "orgunit"
					filter2value = "#line.orgunitimplement#">
						
				</td>
			</tr> 
			
			<tr><td height="1"></td></tr>
			<tr><td colspan="6" class="linedotted"></td></tr>
			<tr><td height="1"></td></tr>
		
		</cfif>
					
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2" align="center" id="pos#url.id#">
			<cfset url.reqid = url.id>
			<cfinclude template="PositionFunding.cfm">				
		</td>
		</tr>  
					
    </table>
      
</cfoutput>
