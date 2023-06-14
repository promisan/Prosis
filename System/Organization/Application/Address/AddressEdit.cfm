
<cfparam name="url.header" default="Yes">
<cfparam name="url.html"   default="No">
<cfparam name="url.closeAction" default="">

<cfif url.header eq "Yes">
	<cf_screentop html="yes" banner="bluedark" bannerheight="60" label="Address Maintenance" layout="webdialog" jQuery="Yes">
<cfelse>
	<cf_screentop html="no"  banner="bluedark" bannerheight="60" label="Address Maintenance" layout="webdialog" jQuery="Yes">
</cfif>

<cf_divscroll overflowx="auto">

<cf_dialogPosition>
<cf_dialogStaffing>


<cfif client.googlemap eq "1">

	<cf_mapscript scope="embed">
	<cfajaximport tags="cfmap,cfform" params="#{googlemapkey='#client.googlemapid#'}#">
	
<cfelse>

	<cfajaximport tags="cfform">

</cfif>	

<cfquery name="Type"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_AddressType
</cfquery>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Nation
</cfquery>

<cfquery name="Address" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM vwOrganizationAddress
	WHERE AddressId = '#URL.ID1#'
</cfquery>

<table width="100%"><tr><td style="padding:3px">

<cfform action="AddressEditSubmit.cfm?html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#" method="POST" name="addressedit">

<cfinclude template="../UnitView/UnitViewHeader.cfm">

<cfoutput><input type="hidden" name="OrgUnit" id="OrgUnit" value="#URL.ID#"">
		  <input type="hidden" name="AddressId" id="AddressId" value="#URL.ID1#">
</cfoutput>

<table width="100%" align="center">

  <tr>
    <td align="left" valign="middle" style="padding-top:5px;padding-left:20px">
		   
   	   <table>
		<tr class="labelmedium2">
		<td>
		   
   	 	<select name="AddressType" id="AddressType" class="regularxxl enterastab" style="border:0px;background-color:e1e1e1">
	    <cfoutput query="Type">
			<option value="#Code#" <cfif Address.AddressType eq Code>selected</cfif>>
			#Description#
			</option>
		</cfoutput>  
   	    </select>	
		
		</td>
		
		<td style="padding-left:10px"><cf_tl id="Active"></td>
		<td style="padding-left:10px">
		
		<input type="checkbox" name="Operational" id="Operational" value="1" <cfif address.operational eq "1">checked</cfif> class="radiol">
		
		</td>
		</tr>
		</table>
		
	</td>
  </tr> 	
       
  <tr>
    <td width="100%" colspan="2">
	
    <table width="97%" align="center" class="formspacing formpadding">
	
	<cfoutput>
	
	<!---
    <TR><TD class="header">&nbsp;</TD></TR>		

    <TR>
    <TD class="header">Effective date:</TD>
    <TD class="regular">&nbsp;
	
		  <cf_intelliCalendarDate
		FieldName="DateEffective" 
		Default="#Dateformat(Address.DateEffective, CLIENT.DateFormatShow)#"	
    	AllowBlank="False">
		
	</TD>
	</TR>
	
	<tr><td height="2" colspan="1" class="header"></td></tr>
	
	  <TR>
    <TD class="header">Expiration date:</TD>
    <TD class="regular">&nbsp;
	
	  <cf_intelliCalendarDate
		FieldName="DateExpiration" 
		Default="#Dateformat(Address.DateExpiration, CLIENT.DateFormatShow)#"	
		AllowBlank="True">	
	
			
	</TD>
	</TR>
	--->	
	
   	<tr>
		<td colspan="2">
			<cf_address mode="edit" eMailRequired="No" styleclass="labelmedium" spaces="52" addressid="#url.id1#" addressscope="Organization">
		</td>
	</tr>
	
	<TR>
	    <TD class="labelmedium" style="height:34;width:20;padding-left:5px">
		
		<!---
		<cfoutput>
		<input type="color" value="###Address.markerColor#">
		</cfoutput>
		--->
		
		<cfif client.googlemap eq "1">
		<cf_space spaces="50">
		<cfelse>
		<cf_space spaces="50">
		</cfif>
		<cf_tl id="Marker">:</TD>
	    <TD style="width:100%;padding-left:0px">
			<cf_input name="MarkerIcon" type="iconMap" color="#Address.markerColor#" value="#Address.markerIcon#" >
		</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Web URL">:</TD>
    <TD style="width:100%;padding-left:0px"><input type="Text" name="Weburl" id="Weburl" value="#Address.Weburl#" size="40" maxlength="20" class="regularxl enterastab"> 
	</TD>
	</TR>
	
	<tr><td height="4"></td></tr>
	
	<tr> <td colspan="2" style="height:35" class="labellarge"><b><cf_tl id="Contact"></b></font> </td> </tr>
	
	<tr><td class="linedotted" colspan="2"></td></tr>	
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Person
		WHERE Personno = '#Address.PersonNo#'
	</cfquery>
		
	<TR>
    <TD style="padding-left:5px" class="labelmedium"><cf_tl id="Contact Indexno">:</TD>
    <TD>
	
	  <table cellspacing="0" cellpadding="0"><tr><td>
	  
	           <img src="#SESSION.root#/Images/contract.gif" alt="Select employee" name="img0" 
					  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="24" height="25" border="0" align="absmiddle" 
					  onClick="selectperson('webdialog','personno','indexno','lastname','firstname','contact','','')">
				
	     </td>
		 <td style="padding-left:2px">
		 
	   	<input type="Text"    name="indexno"   id="indexno"   value="#Person.IndexNo#" size="20" maxlength="20" class="regularxl enterastab">	
		<input type="hidden"  name="personno"  id="personno"  value="#Person.PersonNo#" size="20" maxlength="20" class="regularxl">	
		<input type="hidden"  name="lastname"  id="lastname"  size="10" maxlength="20" readonly>
		<input type="hidden"  name="firstname" id="firstname" size="10" maxlength="20" readonly>
		
		</td></tr>
		</table>
			
	</TD>
	</TR>
			
    <TR class="labelmedium">
    <TD style="padding-left:5px"><cf_tl id="Contact Name">:</TD>
    <TD>
	   	<input type="Text" name="contact" id="contact" value="#Address.Contact#" size="40" maxlength="40" class="regularxl enterastab">		
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD style="padding-left:5px"><cf_tl id="Fiscal No">:</TD>
    <TD>
	   	<input type="Text" name="FiscalNo" id="FiscalNo" size="20" value="#Address.FiscalNo#" maxlength="20" class="regularxl enterastab"> 
	</TD>
	</TR>
	
    <TR class="labelmedium">
    <TD style="padding-left:5px"><cf_tl id="Telephone">:</TD>
    <TD>
	   	<input type="Text" name="TelephoneNo" id="TelephoneNo" value="#Address.TelephoneNo#" size="20" maxlength="20" class="regularxl enterastab"> 
	</TD>
	</TR>


    <TR class="labelmedium">
    <TD style="padding-left:5px"><cf_tl id="Mobile">:</TD>
    <TD>
	   	<input type="Text" name="MobileNo" id="MobileNo" value="#Address.MobileNo#" size="20" maxlength="20" class="regularxl enterastab"> 
	</TD>
	</TR>
		
	<TR class="labelmedium">
    <TD style="padding-left:5px"><cf_tl id="Fax">:</TD>
    <TD>
	   	<input type="Text" name="FaxNo" id="FaxNo" value="#Address.Faxno#" size="20" maxlength="20" class="regularxl enterastab"> 
	</TD>
	</TR>
	   
	<TR class="labelmedium">
    <TD style="padding-left:5px"><cf_tl id="eFax">:</TD>
    <TD>
	   	<input type="Text" name="eFaxNo" id="eFaxNo" value="#Address.eFaxno#" size="80" maxlength="80" class="regularxl enterastab"> 
	</TD>
	</TR>	   
	
	<TR><TD colspan="2" height="1" class="line"></TD></TR>	
	<tr>
	<td colspan="2" align="center" height="30">
   
     <cf_tl id="Back" var="vBack">
     <cf_tl id="Delete" var="vDelete">
     <cf_tl id="Update" var="vUpdate">
   
     <input type="button" name="cancel" id="cancel" value="#vBack#" class="button10g" onClick="history.back()">   
     <input class="button10g" type="submit" name="Delete" id="Delete" value=" #vDelete# ">
     <input class="button10g" type="submit" name="Update" id="Update" value=" #vUpdate# ">
   	
   </td>
   </table>
      
</cfoutput>

</table>

</CFFORM>

</td></tr>
</table>

</cf_divscroll>

<cf_screenbottom layout="webapp">

