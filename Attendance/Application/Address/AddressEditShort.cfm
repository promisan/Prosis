
<style type="text/css">

	td.small
	{
		font-family:"Calibri";	
		font-size:12px;
	}
	
	
	.inputSmall
	{
		font-family:"Calibri";	
		font-size:12px;
	}
	
</style>


<cf_CalendarScript>

<cfparam name="url.header" default="1">
<cfparam name="url.refer" default="regular">
<cfparam name="url.drillid" default="">

<cfparam name="url.layout" default = "direct">

<cfif url.drillid neq ""> 
	
	<cfquery name="Address" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   vwPersonAddress
		WHERE  AddressId = '#URL.drillid#' 
	</cfquery>
	
	<cfset url.id  = Address.Personno>
	<cfset url.id1 = Address.AddressId>

</cfif>

<cfquery name="AddressType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_AddressType
</cfquery>

<cfquery name="Relationship" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Relationship
</cfquery>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Nation
</cfquery>
		
<cfset url.mode = "edit">

<cfform action="" id="editForm">

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr>

<td>
    
<cfquery name="Address" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM vwPersonAddress
	WHERE PersonNo = '#URL.ID#'
	AND AddressId = '#URL.ID1#' 
</cfquery>
  
<cfoutput>
<input type="hidden" name="PersonNo" id="PersonNo" value="#URL.ID#">
<input type="hidden" name="AddressId" id="AddressId" value="#URL.ID1#">
<input type="hidden" name="Layout" id="Layout" value="#URL.Layout#">
</cfoutput>

<table width="99%" border="0" cellspacing="0" align="center" class="formpadding">
  
  <tr>
    <td width="100%" colspan="4">
	
    <table border="0" cellpadding="0" cellspacing="0" width="96%" align="center" class="formpadding">
			
    <cfoutput>
   <tr><td height="2" colspan="4"></td></tr>
	
	<input type = "hidden" name = "AddressType" id="AddressType" value = "#Address.AddressType#">
	
	<TR>
    <TD height="20" class="labelit"><cf_tl id="Country">:</TD>
    <TD>
	    <cfif url.mode eq "edit">
		   	<select name="country" id="country" required="No" class="regularxl">
		    <cfloop query="Nation" >
			<option value="#Code#" <cfif Address.Country eq Code>selected</cfif>>
			#Name#
			</option>
			</cfloop>	    
		   	</select>		
		<cfelse>	
		#Address.Country#
		</cfif>
	</TD>
    <TD height="20" style="padding-left:20px" class="labelit"><cf_tl id="State"></TD>
	
    <TD>
		<cfif url.mode eq "edit">
			<cfinput type="Text" name="state" id="state" value="#Address.State#" size="10" maxlength="20" class="regularxl">	   
		<cfelse>
			#Address.State#
		</cfif>
	</TD>
	</TR>
		
	<TR>
    <TD height="20" class="labelit"><cf_tl id="City">:<font color="FF0000">*</font></TD>
    <TD>
		<cfif url.mode eq "edit">
			<cfinput type="Text" name="addresscity" id="addresscity" value="#Address.AddressCity#" message="Please enter an city" required="Yes" size="20" maxlength="40" class="regularxl">	   
		<cfelse>
			#Address.AddressCity#
		</cfif>
	</TD>

    <TD style="padding-left:20px" height="20" class="labelit"><cf_tl id="Address">:<font color="FF0000">*</font></TD>
    <TD>
		<cfif url.mode eq "edit">
			<cfinput type="Text" name="address" id="address" value="#Address.Address#" message="Please enter an address" required="Yes" size="20" maxlength="100" class="regularxl">	   
		<cfelse>
			#Address.Address#
		</cfif>
	</TD>
	</TR>
		
    <TR>
    <TD height="20" class="labelit"><cf_tl id="Address">:</TD>
    <TD>
		<cfif url.mode eq "edit">
			<cfinput type="Text" name="Address2" id="Address2" value="#Address.Address2#" message="Please enter an address" required="No" size="20" maxlength="100" class="regularxl">	   
		<cfelse>
			#Address.Address2#
		</cfif>
	</TD>
	
    <TD style="padding-left:20px" height="20" class="labelit"><cf_tl id="Room">:</TD>
    <TD>
		<cfif url.mode eq "edit">
			<cfinput type="Text" name="AddressRoom" id="AddressRoom" value="#Address.AddressRoom#" style="text-align: center;" required="No" size="20" maxlength="30" class="regularxl">	   
		<cfelse>
			#Address.AddressRoom#
		</cfif>
	</TD>
	</TR>
		
	<tr><td height="2" colspan="4"></td></tr>
				
	<TR>
				<cfset mission = "">
		<cf_verifyOnBoard PersonNo = "#URL.ID#">
						
		<cfif Mission neq "">	
		    <TD height="20" class="labelit"><cf_tl id="WardenZone">:</TD>
		    <TD>
				<cfif url.mode eq "edit">
					<cfquery name = "qAddressZone"
					  datasource = "AppsEmployee"  
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#"> 
						SELECT * 
						FROM   Ref_AddressZone
						WHERE  Mission = '#mission#'					
					</cfquery>
							
					<select name="AddressZone" id="AddressZone" required="No" class="regularxl">
						
						<option value=""></option>
							
					    <cfloop query="qAddressZone">
							<option value="#qAddressZone.Code#" <cfif qAddressZone.Code eq Address.AddressZone>selected</cfif>>
								#qAddressZone.Description#
							</option>
						</cfloop>
					</select>		
							
				</cfif>
				</TD>
				<td colspan="2">&nbsp;</td>
		<cfelse>
				<input type="hidden" name="AddressZone" id="AddressZone" value="">
		</cfif>
			
		
	</TR>
		
	<cfif mode eq "edit" and url.refer neq "workflow">
					
		<tr><td height="1" colspan="4" class="linedotted"></td></tr>		
		<TR><TD height="4" colspan="4"></TD></TR>			
		<tr><td height="1" colspan="4" align="center">
		
		 <cfif url.layout eq "direct">
		 
		     <!---
			 <cfif url.drillid eq "">			
		 	    <cf_tl id="Back" var="1">
			    <input type="button"  name="cancel" id="cancel" value="#lt_text#" class="button10g" onClick="history.back()">			 
			 </cfif>
			 --->
			 
		 </cfif>
	  	 <cf_tl id="Save" var="1">
	     <input class="button10g"  type="button" name="Submit" id="Submit" value=" #lt_text# " onClick="javascript:ColdFusion.navigate('AddressEditShortSubmit.cfm', 'dForm', '', '', 'POST', 'editForm'); ">
		 
		</td>
		</tr>
				
	</cfif>
	
</TABLE>

</td>
</tr>

</cfoutput>
 
</table>

</CFFORM>

<cfdiv id ="dForm" style="display:none"/>

<cf_screenbottom layout="webapp">
