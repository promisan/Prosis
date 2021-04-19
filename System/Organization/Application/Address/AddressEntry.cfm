
<cfparam name="url.html"   default="No">
<cfparam name="url.closeAction" default="">

<cf_screentop html="no" bannerheight="60" label="Address Maintenance" layout="webdialog" jQuery="Yes">

<cf_divscroll overflowx="auto">

<cf_dialogPosition>
<cf_dialogOrganization>
<cf_dialogStaffing>
<cf_systemscript>

<cf_mapscript scope="embed">

<cfajaximport tags="cfmap,cfform" params="#{googlemapkey='#client.googlemapid#'}#">

<cfquery name="AddressType" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_AddressType
	Order by ListingOrder ASC
</cfquery>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Nation
</cfquery>

<table width="100%"><tr><td style="padding:6px">

<cfform action="AddressEntrySubmit.cfm?html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#" method="POST" name="addressentry">

<cfinclude template="../UnitView/UnitViewHeader.cfm">

<cfoutput><input type="hidden" name="OrgUnit" id="OrgUnit" value="#URL.ID#" class="regular"></cfoutput>

	<table width="100%" align="center">
	  <tr>
	    <td align="left" valign="middle" style="height:45px;padding-left:20px">
				
			 	<select name="AddressType" id="AddressType" class="regularxxl" style="border:0px;background-color:f1f1f1;height:42px;font-size:28px" required="No">
			    	<cfoutput query="AddressType">
						<option value="#Code#">#Description#</option>
					</cfoutput>	    
	   			</select>	
					
		</td>
	  </tr> 	
	       
	  <tr>
	    <td width="100%" colspan="1" class="header" style="padding-left:1px">
		
	    <table border="0" width="96%" align="center" class="formpadding formspacing">
		
		<!---
	    <TR><TD class="header">&nbsp;</TD></TR>		
	
	    <TR>
	    <TD class="header">Effective date:</TD>
	    <TD class="regular">&nbsp;
		
			  <cf_intelliCalendarDate
	   	    FieldName="DateEffective" 
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#"	
	    	AllowBlank="False">
			
		</TD>
		</TR>
		
		<tr><td height="4" colspan="1" class="header"></td></tr>
		
		  <TR>
	    <TD class="header">Expiration date:</TD>
	    <TD class="regular">&nbsp;
		
		  <cf_intelliCalendarDate
			FormName="addressentry"
			FieldName="DateExpiration" 
			DateFormat="#APPLICATION.DateFormat#"
			Default=""
			AllowBlank="True">	
		
				
		</TD>
		</TR>
		--->
				
		<tr>
			<td colspan="2">
				<cf_address mode="edit" eMailRequired="No" styleclass="labelmedium" padding="1px" spaces="52" addressscope="Organization">
			</td>
		</tr>
		
		<TR>
	    	<TD style="padding-left:5px;width:20;" class="labelmedium"><cf_tl id="Marker Color">:<cf_space spaces="52"></TD>
		    <TD style="width:100%">
				<cf_input name="MarkerIcon" type="iconMap">	
			</TD>
		</TR>		
			
	    <TR>
	    <TD style="padding-left:5px" class="labelmedium"><cf_tl id="Web URL">:</TD>
	    <TD>
		   	<input type="Text" name="WebURL" id="WebURL" size="30" maxlength="30" class="regularxl enterastab"> 
		</TD>
		</TR>
		
		<tr><td height="4"></td></tr>
		<tr> <td colspan="2"><font face="Calibri" size="5"><cf_tl id="Contact"></td> </tr>
		
		<tr><td class="linedotted" colspan="2"></td></tr>	
		
		<TR>
	    	<TD style="padding-left:5px" class="labelmedium"><cf_tl id="Contact Number">:</TD>
		    <TD>	
			
			 <table cellspacing="0" cellpadding="0"><tr>
			  
			  <td >	
		
		   	  <input type="Text" name="indexno" id="indexno" value="" size="20" maxlength="20" class="regularxl enterastab">	
			  <input type="hidden" name="personno" id="personno" value="" size="20" maxlength="20" class="regular">	
			  <input type="hidden" name="lastname" id="lastname" size="10" maxlength="20" readonly>
			  <input type="hidden" name="firstname" id="firstname" size="10" maxlength="20" readonly>
			  
			  </td>
			  
			  <td style="padding-left:2px">
			 		 		
			 <cfoutput>
		  
		     <img src="#SESSION.root#/Images/contract.gif" alt="Select employee" name="img0" 
				  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
				  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
				  onClick="selectperson('webdialog','personno','indexno','lastname','firstname','contact','','')">
			
			  </cfoutput>	
			  
			  </td>
			  
			  </tr></table>	
				
			</TD>
		</TR>
		
		<TR>
		    <TD style="padding-left:5px" class="labelmedium"><cf_tl id="Contact Name">:</TD>
		    <TD><input type="Text" name="Contact" id="Contact" size="60" maxlength="80" class="regularxl enterastab"></TD>
		</TR>
			
	    <TR>
	    	<TD style="padding-left:5px" class="labelmedium"><cf_tl id="Fiscal No">:</TD>
		    <TD><input type="Text" name="FiscalNo" id="FiscalNo" size="20" maxlength="20" class="regularxl enterastab"></TD>
		</TR>
			
	    <TR>
	    	<TD style="padding-left:5px" class="labelmedium"><cf_tl id="Telephone">:</TD>
		    <TD><input type="Text" name="TelephoneNo" id="TelephoneNo" size="20" maxlength="20" class="regularxl enterastab"> 
		</TD>
		</TR>
	
	    <TR>
	    	<TD style="padding-left:5px" class="labelmedium"><cf_tl id="Mobile">:</TD>
		    <TD><input type="Text" name="MobileNo" id="MobileNo" size="20" maxlength="20" class="regularxl enterastab"> 
		</TD>
		</TR>
	
	    <TR>
	    	<TD style="padding-left:5px" class="labelmedium"><cf_tl id="Fax">:</TD>
		    <TD><input type="Text" name="FaxNo" id="FaxNo" size="20" maxlength="20" class="regularxl enterastab"> 
		</TD>
		</TR>
		
		<!---
	    <TR>
	    	<TD style="padding-left:5px" class="labelmedium"><cf_tl id="eFax">:</TD>
		    <TD><input type="Text" name="eFaxNo" id="eFaxNo" size="80" maxlength="80" class="regularxl enterastab"> 
		</TD>
		</TR>
		--->	
		
		<TR><TD height="5"></TD></TR>	
		<tr><td class="linedotted" colspan="2"></td></tr>
		<tr><td colspan="2" align="center" height="30">
	
		   <cf_tl id="Save" var="vSave">
		   <cf_tl id="Cancel" var="vCancel">
		   <cfoutput>
			   <input class="button10g" type="submit" name="Submit" id="Submit" value="#vSave#">
			   <input type="button" name="cancel" id="cancel" value="#vCancel#" class="button10g" onClick="history.back()"> 
		   </cfoutput>
	   
	   </td>
	   </tr>
	   
	   </table>
	   
	   </td>
	   </tr>
	
	</table>

</CFFORM>

</cf_divscroll>

</td></tr></table>


