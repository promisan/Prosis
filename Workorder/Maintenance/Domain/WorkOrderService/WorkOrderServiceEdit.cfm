<cfquery name="GetHeader" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ServiceitemDomain
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="Get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrderService
		WHERE  ServiceDomain = '#URL.ID1#'
		<cfif url.id2 eq "">
			AND 1=0
		<cfelse>
			AND Reference = '#URL.ID2#'
		</cfif>
</cfquery>

<cfif url.id2 eq "">
	<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)" label="Workorder Service Add" scroll="Yes" layout="webapp" banner="blue" user="yes" jquery="yes">
<cfelse>
	<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)"  label="Workorder Service Edit" scroll="Yes" layout="webapp" banner="yellow" user="yes" jquery="yes">
</cfif>

<!--- edit form --->

<cfform action="WorkOrderService/WorkOrderServiceSubmit.cfm?id1=#url.id1#&id2=#url.id2#" method="POST" name="formworkorderservice" target="divWorkOrderServiceSubmit" style="height:100%;">	

<table width="92%" height="100%" cellspacing="4" cellpadding="1" align="center" class="formpadding formspacing">

<tr class="hide"><td><iframe name="divWorkOrderServiceSubmit" id="divWorkOrderServiceSubmit" frameborder="0"></iframe></td></tr>
	
	<tr><td height="2"></td></tr>
    <cfoutput>
	<TR>
    <TD class="labelmedium">Domain:</TD>
    <TD class="labelmedium">
		<input type="hidden" name="ServiceDomain" id="ServiceDomain" value="#URL.ID1#">
  	   <b>#GetHeader.Description#</b>
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium" width="30%">Reference:</TD>
    <TD class="labelmedium">
	   <cfif url.id2 eq "">	
		   	<cfinput type="Text" name="Reference" id="Reference" value="" message="Please enter a reference" required="Yes" size="20" maxlength="40" class="regularxl">
	   <cfelse>
	   		#get.Reference#
			<input type="hidden" name="Reference" id="Reference" value="#get.reference#">
	   </cfif>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="No" size="50" maxlength="100" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
	   <cfinput 
	   		type="Text" 
			name="ListingOrder" 
			id="ListingOrder" 
			value="#get.ListingOrder#" 
			message="Please enter a numeric listing order" 
			required="Yes" 
			size="3" 
			maxlength="5" 
			validate="integer" 
			class="regularxl" 
			style="text-align:center;">
    </TD>
	</TR>
			
	</cfoutput>
	
	<cfif url.id2 neq "">
	
		<tr>
			<td colspan="2" height="100%">
				<table width="100%" height="100%" align="center">
					<tr>
						<td style="border-right:1px dotted #C0C0C0; padding-left:5px; padding-right:10px;" width="50%" height="100%" valign="top">
							<table width="100%">
								<tr>
									<td class="labellarge"><cf_tl id="Entities"></td></td>
								</tr>
								<tr><td class="line"></td></tr>
								<tr><td height="10"></td></tr>
								<tr>
									<td>
										<cfinclude template="WorkOrderServiceMission.cfm">
									</td>
								</tr>
							</table>
						</td>
						<td valign="top" style="padding-left:15px;">
							<table width="100%">
								<tr>
									<td class="labellarge">
										<cfoutput>
											<cf_tl id="Items"> <a href="javascript:selectwarehouseitemnoclose('','','','addItem','#URL.ID1#|#URL.ID2#');" style="color:##2497F4; font-size:85%;">[ Add ]</a>
										</cfoutput>
									</td>
								</tr>
								<tr><td class="line"></td></tr>
								<tr><td height="10"></td></tr>
								<tr>
									<td id="itemContainer">
										<cfinclude template="WorkOrderServiceItem.cfm">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
	</cfif>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<cfif url.id2 eq "">
		<input class="button10g" type="submit" style="height:25;font-size:13px" name="Save" id="Save" value="Save">
	<cfelse>
    	<input class="button10g" type="submit" style="height:25;font-size:13px" name="Update" id="Update" value="Update" onclick="return validateOrgUnits();">
	</cfif>	
	</td>	
	
	</tr>
	
	<tr><td height="20"></td></tr>
	
	
</TABLE>

</CFFORM>	

<cf_screenbottom layout="webapp">
	