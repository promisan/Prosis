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

<cfparam name="url.webapp"  default="">
<!--- Query returning search results --->

<cfquery name="Search" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*,
	         B.Name, 
		     R.Description as AddressTypeDescription
	FROM     vwPersonAddress A, 	        
	         System.dbo.Ref_Nation B, 
		     Ref_AddressType R
	WHERE    PersonNo      = '#URL.ID#'
	AND      A.Country     = B.Code
	AND      A.AddressType = R.AddressType
	ORDER BY A.AddressType DESC
</cfquery>

<table width="98%" align="center">
 
  <tr>
    <td style="padding-top:4px;height:65px;padding-left:10px;font-size:23px" class="labellarge">
        <img src="<cfoutput>#session.root#/Images/Contact.png</cfoutput>" style="height:65px;float:left;">
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;">Address Information</h1>
        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Maintain your contact information.</p>
        <div class="emptyspace" style="height: 30px;"></div>        
	</td>
        
    <cfoutput>
    <td align="right" class="labelmedium2" style="padding-right:5px;padding-bottom:3px" valign="bottom">
			
        <cfif mode eq "edit">
		   
			<cf_tl id="Add new Contact" var="1">			
			<a href="javascript:personaddressentry('#URL.ID#')"><font size="2" color="0080C0">[#lt_text#]</font></a>	
				
		</cfif>
			
	</cfoutput>
    </td>
  </tr>
     
  <td width="100%" colspan="2">

	<table border="0" width="100%" class="formpadding navigation_table">
		
	<tr><td class="line" colspan="9"></td></tr>	
	
	<TR  class="labelmedium2 line fixlengthlist">
	    <td height="20"></td>
	    <td><cf_tl id="Type"></td>
		<TD><cf_tl id="Address"></TD>
		<TD><cf_tl id="City"></TD>		
		<TD><cf_tl id="Zone"></TD>	
		<TD><cf_tl id="Contact"></TD>
		<TD><cf_tl id="Source"></TD>
		<TD align="right"><cf_tl id="Effective"></TD>
	</TR>
	
	<cfset last = '1'>
	
	<cfif search.recordcount eq "0">
	
		<tr>
		<td colspan="9" height="200" align="center" class="labelit"><font face="Calibri" size="2" color="gray">There are no address records to show in this view.</font>
		 <cfoutput>				
			<a href="javascript:personaddressentry('#URL.ID#')"><font size="2" color="0080C0"><u><cf_tl id="Add new Contact"></font></a>	
		 </cfoutput>
		 </td>
		</tr>
		
	</cfif>
	
	<cfoutput query="Search">
	
		<TR class="labelmedium2 navigation_row line fixlengthlist" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
		
		<td align="center" style="padding-top:4px"> 		   
		    <cf_img icon="open" navigation="yes" onclick="personaddressedit('#URL.ID#','#AddressId#','#url.webapp#')">		  			
		</td>	
		
		<td><a href="javascript:personaddressedit('#URL.ID#','#AddressId#','#url.webapp#')">#AddressTypeDescription#</a></td>
		
		<td style="padding-left:4px" title="#Address# #Address2# #AddressRoom#">
		    <a href="javascript:personaddressedit('#URL.ID#','#AddressId#','#url.webapp#')">#Address# #Address2# #AddressRoom#</a>
		</td>
		
		<td>#AddressCity#, #Name#</td>
		
		<td>
		<cfif AddressZone neq "">
		
			<cfquery name = "qAddressZone" 
			Datasource = "AppsEmployee">
				SELECT * 
				FROM   Ref_AddressZone	
				WHERE  Code = '#AddressZone#'
			</cfquery>
			#qAddressZone.Description#	
			
		</cfif>	
		</td>
		<TD>#Contact# #ContactRelationship#</TD>
		<td>#source#</td>
		<td align="right">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
		</TR>
		
		<cfquery name="ContactNo" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT P.*, (
				      SELECT ContactCallSign 
					  FROM   PersonAddressContact 
					  WHERE  PersonNo = '#personno#' 
					  AND Addressid = '#AddressId#'
					  AND ContactCode = P.Code ) as CallSign
			    FROM Ref_Contact P
		</cfquery>
		
		<cfif contactNo.recordcount gte "1">
	
		<TR class="labelmedium2 line navigation_row_child" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
	
		    <td colspan="1"></td>
			<td colspan="8" align="left">
			
				<table>
				<tr class="labelmedium2 fixlengthlist" style="height:0px">
				<cfset row = 0>
				
					<cfloop query="contactNo">	
					  	
					  <cfset row = row+1>
					  	
					  <cfif row eq "4">
					  
					    <tr>
						<cfset row = 0>
						
					  </cfif> 
					  
					  <td><cf_tl id="#Description#">:</td>
					  <td>						  
					      <font color="gray">
					      <cfif callsign eq "">n/a<cfelse><b>#CallSign#</cfif></b>	
					      </font>
					  </td>
					  <td>&nbsp;&nbsp;</td>
					  
					</cfloop>	
					
				</tr>
				</table>	
			
			</td>
	
		</TR>
		
		</cfif>
		
	</cfoutput>
	
	</TABLE>
	
</td></tr>

</table>

<cfset ajaxonload("doHighlight")>