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

<!---
<cfif url.id2 eq "">
	<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)" label="Workorder Service Add" scroll="Yes" layout="webapp" banner="blue" user="yes" jquery="yes">
<cfelse>
	<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)"  label="Workorder Service Edit" scroll="Yes" layout="webapp" banner="yellow" user="yes" jquery="yes">
</cfif>
--->

<!--- edit form --->

<cfform action="WorkOrderService/WorkOrderServiceSubmit.cfm?id1=#url.id1#&id2=#url.id2#" method="POST" 
   name="formworkorderservice" target="divWorkOrderServiceSubmit" style="height:98%;">	

<table width="92%" height="100%" align="center" class="formpadding formspacing">

<tr class="hide"><td><iframe name="divWorkOrderServiceSubmit" id="divWorkOrderServiceSubmit" frameborder="0"></iframe></td></tr>
	
	<tr><td height="6"></td></tr>
    <cfoutput>
	<TR class="labelmedium2">
    <TD>Domain:</TD>
    <TD>
		<input type="hidden" name="ServiceDomain" id="ServiceDomain" value="#URL.ID1#">
  	   <b>#GetHeader.Description#</b>
    </TD>
	</TR>
	
    <TR class="labelmedium2">
    <TD width="20%">Reference:</TD>
    <TD>
	   <cfif url.id2 eq "">	
		   	<cfinput type="Text" name="Reference" value="" message="Please enter a reference" required="Yes" size="20" maxlength="40" class="regularxxl">
	   <cfelse>
	   		#get.Reference#
			<input type="hidden" name="Reference" id="Reference" value="#get.reference#">
	   </cfif>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" 
	      required="No" size="50" maxlength="100" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
	   <cfinput 
	   		type="Text" 
			name="ListingOrder"  
			value="#get.ListingOrder#" 
			message="Please enter a numeric listing order" 
			required="Yes" 
			size="3" maxlength="5" validate="integer" class="regularxxl" style="text-align:center;">
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
		<input class="button10g" type="submit" name="Save" id="Save" value="Save">
	<cfelse>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Update" onclick="return validateOrgUnits();">
	</cfif>	
	</td>	
	
	</tr>
	
	<tr><td height="20"></td></tr>
	
	
</TABLE>

</CFFORM>	

<cf_screenbottom layout="webapp">
	