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
	FROM   Ref_ServiceitemDomainClass
	WHERE  ServiceDomain = '#URL.ID1#'
	<cfif url.id2 eq "">
		AND 1=0
	<cfelse>
		AND Code = '#URL.ID2#'
	</cfif>
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT	RequestId as id
		FROM	Request
		WHERE	ServiceDomain = '#URL.ID1#'
		<cfif url.id2 eq "">
			AND 1=0
		<cfelse>
			AND		ServiceDomainClass = '#URL.ID2#'
		</cfif>
		UNION
		SELECT	WorkorderId as id
		FROM	Workorderline
		WHERE	ServiceDomain = '#URL.ID1#'		
		<cfif url.id2 eq "">
			AND 1=0
		<cfelse>
			AND		ServiceDomainClass = '#URL.ID2#'
		</cfif>
</cfquery>

<!---
<cfif url.id2 eq "">
	<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)" label="Domain Class" scroll="Yes" layout="webapp" banner="blue" user="yes">
<cfelse>
	<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)"  label="Domain Class" scroll="Yes" layout="webapp" banner="yellow" user="yes">
</cfif>
--->

<!--- edit form --->

<cfform action="DomainClass/DomainClassSubmit.cfm?id=#url.id1#&id2=#url.id2#" method="POST" name="formdomainclass" target="divDomainClassSubmit">	

<table width="92%" align="center" class="formpadding formspacing">

<tr class="hide"><td><iframe name="divDomainClassSubmit" id="divDomainClassSubmit" frameborder="0"></iframe></td></tr>
	
	<tr><td height="2"></td></tr>
    <cfoutput>
	<TR>
    <TD style="min-width:200px" class="labelmedium2">Code:</TD>
    <TD style="width:100%" class="labelmedium2">
		<input type="hidden" name="ServiceDomain" id="ServiceDomain" value="#URL.ID1#">
  	   <b>#GetHeader.Description#</b>
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium2">Domain class:</TD>
    <TD class="labelmedium2">
	   <cfif url.id2 eq "">	
		   	<cfinput type="Text" name="Code" value="" message="Please enter a class code" required="Yes" size="10" maxlength="10" class="regularxl">
	   <cfelse>
	   		<cfif CountRec.recordcount eq "0">
				<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a class code" required="Yes" size="10" maxlength="10" class="regularxxl">
			<cfelse>
				#get.Code#
				<input type="hidden" name="Code" id="Code" value="#get.Code#">
			</cfif>
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="No" 
	      size="35" maxlength="100" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium2">Doman Type:</TD>
    <TD class="labelmedium">
	    
		<table border="0">
		
		<tr class="labelmedium">
			<td><input type="radio" class="radiol" name="ServiceType" value="Service" <cfif get.ServiceType eq "Service" or url.id2 eq "">checked</cfif>></td>
			<td style="padding-left:5px"><u>Service</u></td>
		</tr>
		
		<tr>
			<td></td>
			<td> 
			
				 <table>
			        <tr>
		
					<TD class="labelit" style="padding-left:6px;padding-right:6px">Enable Service Order Request:</TD>
				    <TD class="labelmedium">
						<table>
						<tr class="labelmedium">
						<td><input type="radio" class="radiol" name="pointerRequest" id="pointerRequest" value="0" <cfif get.pointerRequest eq "0">checked</cfif>></td>
						<td style="padding-left:5px">No</td>
						<td style="padding-left:9px"><input class="radiol" type="radio" name="pointerRequest" id="pointerRequest" value="1" <cfif get.pointerRequest eq "1" or url.id2 eq "">checked</cfif>></td>			
						<td style="padding-left:5px">Yes</td>
						</tr>
						</table>			
				    </TD>
					</tr>
					
				</table>
				
				</td>
		</tr>
					
		<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="ServiceType" value="Activity" <cfif get.ServiceType eq "Activity">checked</cfif>></td>
		<td style="padding-left:5px">Activity</td>
		</tr>
		<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="ServiceType" value="Produce" <cfif get.ServiceType eq "Produce">checked</cfif>></td>
		<td style="padding-left:5px">Stock Produce</td>
		</tr>
		
		<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="ServiceType" value="Sale" <cfif get.ServiceType eq "Sale">checked</cfif>></td>
		<td style="padding-left:5px">Stock Sale</td>
		</tr>
			
		<tr>
			<td></td>
			<td> 
			
				 <table>
			        <tr>		
					<TD class="labelit" style="padding-left:6px;padding-right:6px">Shipping stock overdraw:</TD>
				    <TD class="labelmedium">
				    <table><tr class="labelmedium">
					<td><input type="radio" name="pointerOverdraw" id="pointerOverdraw" value="0" <cfif get.pointerOverdraw eq "0">checked</cfif>></td>
					<td style="padding-left:5px">No</td>
					<td style="padding-left:9px"><input type="radio" name="pointerOverdraw" id="pointerOverdraw" value="1" <cfif get.pointerOverdraw eq "1" or url.id2 eq "">checked</cfif>></td>			
					<td style="padding-left:5px">Yes</td>
					</tr>
					</table>
				    </TD>
				</tr>
				
			
				</table>
			
		    </TD>
			</tr>	
		
		
		<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="ServiceType" value="Production" <cfif get.ServiceType eq "Production">checked</cfif>></td>
		<td style="padding-left:5px">Full Production (incl Procurement)</td>				
		</tr>
		
		<tr>
			<td></td>
			<td> 
			
				 <table>
				 
			        <tr class="labelmedium2">					
					<TD style="padding-left:6px;padding-right:6px">Enabled for Sale:</TD>
				    <TD>
					    <table>
						<tr class="labelmedium2">
							<td><input type="radio" name="pointerSale" id="pointerSale" value="0" <cfif get.pointerSale eq "0">checked</cfif>></td>
							<td style="padding-left:5px">Internal use only</td>
							<td style="padding-left:9px"><input type="radio" name="pointerSale" id="pointerSale" value="1" <cfif get.pointerSale eq "1" or url.id2 eq "">checked</cfif>></td>			
							<td style="padding-left:5px">Yes</td>
						</tr>
						</table>
					</td>
					</tr>
					
					<tr class="labelmedium2">
						<TD style="padding-left:6px;padding-right:6px">Earmark stock for sale:</TD>
					    <TD>
							<table>
							<tr class="labelmedium2">
								<td><input type="radio" name="PointerStock" id="PointerStock" value="0" <cfif get.pointerStock eq "0" or url.id2 eq "">checked</cfif>></td>
								<td style="padding-left:5px">Conservative (same item and UoM)</td>
								<td style="padding-left:9px"><input type="radio" name="PointerStock" id="PointerStock" value="1" <cfif get.pointerStock eq "1">checked</cfif>></td>			
								<td style="padding-left:5px">Opportunistic (similar item</td>
							</tr>
							</table>			
					    </TD>
					</tr>
					
				</table>
			
		    </TD>
			</tr>
			
		</table>
	</TR>	
		
	<TR class="labelmedium2">
    <TD>Sort:</TD>
    <TD><cfinput type="Text" style="text-align:center" name="listingOrder" value="#get.listingOrder#" 
	      message="Please enter a numeric listing order" required="Yes" size="2" validate="integer" maxlength="3" class="regularxl"></TD>
	</TR>
	
	<tr class="labelmedium2">
		<TD>Operational:</TD>
	    <TD>
		
		 <table><tr class="labelmedium2">
			<td><input class="radiol" type="radio" name="operational" id="operational" value="0" <cfif get.Operational eq "0">checked</cfif>></td>
			<td style="padding-left:5px">No</td>
			<td style="padding-left:9px"><input class="radiol" type="radio" name="operational" id="operational" value="1" <cfif get.Operational eq "1" or url.id2 eq "">checked</cfif>></td>			
			<td style="padding-left:5px">Yes</td>
			</tr>
			</table>			
			
	    </TD>
	</tr>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>		
	<td align="center" colspan="2" height="30">
	<cfif url.id2 eq "">
		<input class="button10g" type="submit" name="Save" id="Save" value="Save">
	<cfelse>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</cfif>	
	</td>		
	</tr>
	
	
</TABLE>

</CFFORM>	

<cf_screenbottom layout="webapp">
	