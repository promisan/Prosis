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
<cfparam name="url.customerid"   default="">
<cfparam name="url.addressid" default="">

<cfquery name="AddressType" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_AddressType
</cfquery>
   
<cfform name="addressform" onsubmit="return false">

<table width="98%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td id="addressprocess"></td></tr>

<tr>

	<td style="border:0px dotted silver">
	    
	<cfquery name="Address" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT A.*,
			   C.Mission
	    FROM   vwCustomerAddress A
			   INNER JOIN Customer C
			   ON  A.CustomerId = C.CustomerId
	    WHERE  A.CustomerId = '#url.CustomerId#' AND A.AddressId = '#url.addressid#'
	</cfquery>
	
	<cfoutput>
	    
		<input type="hidden" name="CustomerId"  value="#URL.CustomerId#">
		<input type="hidden" name="AddressId" value="#URL.AddressId#">
		
	</cfoutput>
	
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">	
	      
	  <tr>
	    
		<td width="95%" align="center" colspan="2">
		
	    <table border="0" cellpadding="0" cellspacing="0" width="96%" align="center" class="formpadding">
		
	    <TR><TD height="6"></TD></TR>		
	    
		<cfoutput>
		
		<cfset mission = Address.Mission>
				
		<tr><td height="2" colspan="1"></td></tr>
		
		<TR>
	    <TD class="labelmedium" width="170" height="25"><cf_tl id="Address type">:</TD>
	    <TD width="80%">
		
		  
		   	<select name="AddressType" required="No" class="regularxl enterastab">
			    <cfloop query="AddressType">
					<option value="#AddressType#" <cfif AddressType eq Address.AddressType>selected</cfif>>#Description#</option>
				</cfloop>    
		   	</select>		
			
		</TD>
		</TR>
	    
		<TR>
	    <TD class="labelmedium" height="30"><cf_tl id="Effective date">:</TD>
	    <TD height="25">
		
		 <table cellspacing="0" height="100%" cellpadding="0">
		 	  
		   <tr><td class="labelmedium">
		
				<cf_intelliCalendarDate9
				FormName="addressedit"
				FieldName="DateEffective" 
				class="regularxl enterastab"
				DateFormat="#APPLICATION.DateFormat#"
				Message="Please enter an effective date for this record"
				Default="#Dateformat(Address.DateEffective, CLIENT.DateFormatShow)#"	
		    	AllowBlank="False">
			
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
			<TD class="labelmedium">
		
			  <cf_intelliCalendarDate9
				FormName="addressedit"
				class="regularxl enterastab"
				FieldName="DateExpiration" 
				DateFormat="#APPLICATION.DateFormat#"
				Default="#Dateformat(Address.DateExpiration, CLIENT.DateFormatShow)#"	
				AllowBlank="True">	
					
		      </TD>
			
			</tr>
		</table>
			
		</TD>
		
		</tr>
		
		<tr><td height="2" colspan="2" class="linedotted"></td></tr>
			
		<tr><td colspan="2" style="padding-top:2px">
		
			<cf_address mode="edit" addressid="#url.addressid#" styleclass="labelmedium" addressscope="Customer" mission="#mission#" emailRequired="No">
					
		</td></tr>
		
		<tr><td height="2" colspan="1"></td></tr>
		
		<cfquery name="ContactType" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Contact RC
				   LEFT JOIN CustomerAddressContact A
				   	ON  RC.Code = A.ContactCode AND A.CustomerId = '#url.CustomerId#' AND A.AddressId = '#url.addressid#'
			ORDER  BY ListingOrder
		</cfquery>
		
		<tr>
			<td colspan="2" class="labelmedium" align="left"><b><cf_tl id="Contact"></b></td>
		</tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<cfloop query="ContactType">
			<tr>
				<td width="100" height="30" class="labelmedium" style="padding-left:5px;">#Description#</td>
				<td align="left"><cfinput type="text" name="contact_#code#" id="contact_#code#" value="#ContactCallSign#" class="regularxl"></td>
			</tr>
		</cfloop>
		
		<TR><TD height="4"></TD></TR>			
		<tr><td class="line" height="1" colspan="3"></td></tr>		
		<TR><TD height="4"></TD></TR>			
		<tr><td height="1" colspan="3" align="center">		
			
	 	 <cf_tl id="Back" var="1">
			
		 <input type    = "button"  
		        name    = "cancel" 
		        value   = "#lt_text#" 
		        class   = "button10g" 
		        onClick = "ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/Address/CustomerAddress.cfm?customerid=#url.customerid#','addressdetail')">
	 						 
		 <cf_tl id="Delete" var="1">
		 
	     <input class="button10g"  type="button" name="Delete" value="#lt_text#" onclick="addresseditvalidate('delete')">
		 
	  	 <cf_tl id="Save" var="1">
	     <input class  = "button10g"  
		        type   = "button" 
				name   = "Submit" 
				value  = "#lt_text#" 
				onclick= "addresseditvalidate('save')">
		 
		</td>
		</tr>
		
		<tr><td height="4"></td></tr>
		
	</TABLE>
	
	</td>
	
	</tr>
	 
	</table>
	
	</cfoutput>
	
	</td>

</tr>
 
</table>

</CFFORM>

<cfset ajaxonload("doCalendar")>

<script>
	Prosis.busy('no')
</script>
