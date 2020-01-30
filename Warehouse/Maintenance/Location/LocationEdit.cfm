
<cf_screentop height="100%" 
    label="Maintain Geo Location" 
	layout="webapp" 
	banner="gray" 
	option="Maintain and inquiry for physical location" 
	scroll="Yes"
	close="parent.parent.ColdFusion.Window.destroy('mylocation',true)"
	jquery="Yes"
	html="Yes">

<cfif client.googleMAP eq "1">	
	<cfajaximport tags="cfdiv,cfmap" params="#{googlemapkey='#client.googlemapid#'}#">  
</cfif>

<cf_calendarscript>

<script>

function askupdate() {
	if (confirm("Do you want to update this location ?")) {
		return true 
	}	
	return false	
}	

function askdelete() {
	if (confirm("Do you want to remove this location ?")) {
	return true 
	}
	return false	
}	

</script>	

<cf_dialogOrganization>
<cf_dialogasset>

<cfquery name="Class" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_LocationClass
</cfquery>

<cfquery name="Location" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Location
	WHERE  Location = '#URL.ID#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP 1 *
    FROM Ref_Mandate
	WHERE Mission = '#Location.Mission#'
	ORDER BY MandateDefault DESC
</cfquery>

<table class="hide"><tr><td colspan="2"><iframe name="result" id="result" width="100%"></iframe></td></tr></table>

<cfoutput query = "Location">

<cfform action="LocationEditSubmit.cfm" method="POST" target="result" name="locedit">

	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<input type="hidden" name="Location" id="Location" value="#URL.ID#">
	<input type="hidden" name="mission"  id="mission"  value="#Location.Mission#">
	
	<tr><td valign="top">
	
	<table width="98%" border="0" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
	      
	  <tr>
	    <td width="100%" style="padding-top:8px;padding-left:20px">
		
	    <table border="0" cellpadding="0" class="line formspacing formpadding" width="100%">
			
		<cfif ParentLocation neq "">
		
		<cfquery name="Parent" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *
		    FROM   Location
			WHERE  Location = '#Location.ParentLocation#'
		</cfquery>
		
		<TR>
	    <td class="labelmedium"><cf_tl id="Parent location">:</td>
	    <TD class="labelmedium">
		
			<table width="100%" cellspacing="0" cellpadding="0">
			
			<tr><td><input type="text" class="regularxl enterastab" name="locationname" style="padding-top:1px;padding-left:2px" id="locationname" value="#Parent.LocationName#" size="45" maxlength="80" readonly></td>
			<td>				
			    
				<button class="button3 enterastab" 
			       name="search" id="search" 
				   onClick="selectloc('locedit','parentlocation','parentlocationcode','locationname','','','','',document.getElementById('mission').value)"> 
						<img src="<cfoutput>#SESSION.root#</cfoutput>/images/Location2.png" alt="" width="19" height="21" border="1" align="absmiddle">
				</button>
					
				<input type="hidden" name="parentlocation"      id="parentlocation"      value="#ParentLocation#"> 
				<input type="hidden" name="parentlocationcode"  id="parentlocationcode"  value=""> 
				<input type="hidden" name="parentlocationold" id="parentlocationold" value="#ParentLocation#">		
								
				</td>
			</tr>
				
			</table>
				
		</TD>
		</TR>
			
		<cfelse>
		
		    <input type="hidden" name="parentlocation" id="parentlocation"    value="root"> 
			<input type="hidden" name="parentlocationold" id="parentlocationold" value="root">
			<input type="hidden" name="root" id="root" value="1">
			
		</cfif>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Name">:</TD>
	    <TD class="labelmedium">
		<INPUT type="text" class="regularxl enterastab" value="#LocationName#" name="LocationNameEdit" id="LocationNameEdit" maxLength="80" size="45">		
		</TD>
		<td rowspan="15">
		     <cfif client.googleMAP eq "1">
				<cf_mapshow scope="embed" mode="edit" width="420" height="370" latitude="#location.Latitude#" longitude="#location.Longitude#" format="map">		
			</cfif>
		</td>
		</TR>
		
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Code">:</TD>
	    <TD class="labelmedium">	
		
		<INPUT type="text" class="regularxl enterastab" value="#LocationCode#" name="LocationCode" id="LocationCode" maxLength="10" size="10">
			
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Class">:</TD>
	    <TD class="labelmedium">	
		  	<select name="LocationClassEdit" id="LocationClassEdit" size="1" class="regularxl enterastab">
			<cfloop query="Class">
			<option value="#Code#" <cfif #Location.LocationClass# eq #Code#>selected</cfif>>
	    		#Description#
			</option>
			</cfloop>
		    </select>
			
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Tree order">:</TD>
	    <TD class="labelmedium">
		<cfinput type="Text" name="TreeOrder" value="#TreeOrder#" style="text-align: center;" message="Please enter a numeric value" validate="integer" required="No" size="3" maxlength="6" class="regularxl enterastab">
			
		</TD>
		</TR>
				
		<cfquery name="Nation" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_Nation
		</cfquery>
		
		<TR>
	    <TD height="20" class="labelmedium"><cf_tl id="Country">:</TD>
	    <TD class="labelmedium">
		 
			   	<select name="country" id="country" class="regularxl enterastab" required="No">
			    <cfloop query="Nation" >
				<option value="#Code#" <cfif location.Country eq Code>selected</cfif>>
				#Name#
				</option>
				</cfloop>	    
			   	</select>		
			
		</TD>
		</TR>
		
		<TR>
		    <TD class="labelmedium" height="20"><cf_tl id="City">:</TD>
		    <TD class="labelmedium">	
			<cfinput class="regularxl enterastab" onchange="mapaddress()" type="Text" name="addresscity" value="#location.AddressCity#" message="Please enter an city" required="No" size="40" maxlength="50">	   	
			</TD>
		</TR>
		
		<TR>
		    <TD class="labelmedium" height="20"><cf_tl id="Address">:</TD>
		    <TD class="labelmedium">	
			<cfinput class="regularxl enterastab" onchange="mapaddress()" type="Text" name="address" value="#location.Address#" message="Please enter an address" required="No" size="40" maxlength="80">	   	
			</TD>
		</TR>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Latitude">:</td>		
	 		<td class="labelmedium">
			<cfinput type="Text" name="cLatitude" value="#location.Latitude#" validate="float" required="No" size="15" maxlength="20" class="regularxl enterastab">	
			</td>
		</tr>
		
		<tr>			
			<td class="labelmedium"><cf_tl id="Longitude">:</td>		
			<td class="labelmedium">		
			<cfinput class="regularxl enterastab" validate="float" value="#location.Longitude#" type="Text" name="cLongitude"  require="No" size="15" maxlength="20">	
			</td>		
		</TR>		
		      
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
	    <TD class="labelmedium">
		
			  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxl enterastab"
				Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
		
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
	    <TD class="labelmedium">
		
			  <cf_intelliCalendarDate9
				FieldName="DateExpiration" 
				class="regularxl enterastab"
				Default="#Dateformat(DateExpiration, CLIENT.DateFormatShow)#"
				AllowBlank="True">	
				
		</TD>
		</TR>
		      
	    <TR>
	    <TD class="labelmedium"><cf_UIToolTip tooltip="Asset items on this location can be redistributed"><cf_tl id="Stock Price Location">:</cf_UIToolTip></TD>
	    <TD class="labelmedium">	
		    <table><tr>
			<td style="padding-left:5px"><input type="radio" class="radiol enterastab" name="StockLocation" id="StockLocation" value="1" <cfif StockLocation eq "1">checked</cfif>></td>
			<td class="labelmedium">Yes</td>
			<td style="padding-left:5px">
			<input type="radio" class="rediol enterastab" name="StockLocation" id="StockLocation" value="0" <cfif StockLocation eq "0">checked</cfif>></td>
			<td class="labelmedium">No</td>
			</tr></table>
	    </td>
	    </tr>
			
		 <cf_dialogOrganization>
		 
		 <tr>
		 <td class="labelmedium" style="padding-right:10px"><cf_tl id="Belongs to unit">:</td>
		 <td class="labelmedium">
		 
		 <cfif MissionOrgUnitId neq "">
		 
				 <cfquery name="Org" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Organization
					WHERE MissionOrgUnitId = '#MissionOrgUnitId#'
					ORDER BY OrgUnit DESC
				</cfquery>
				
				<cfoutput>
				   <table cellspacing="0" cellpadding="0">
				    <tr><td>
			        <input type="button" style="height:25px;width:25px" class="button7" name="search" id="search" value=" ... " onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',document.getElementById('mission').value, mandateno.value)"> 
					</td>
					<td style="padding-left:2px">
					<input type="text" name="orgunitname" id="orgunitname" value="#Org.OrgUnitName#" class="regularxl" size="40" maxlength="60" readonly style="text-align: left;">								
					<input type="hidden" name="orgunitclass" id="orgunitclass" value="" class="disabled" size="15" maxlength="15" readonly style="text-align: left;"> 
					<input type="hidden" name="mandateno" id="mandateno" value="#Mandate.MandateNo#">
					<input type="hidden" name="orgunit" id="orgunit" value="#Org.OrgUnit#"> 
					<input type="hidden" name="mission" id="mission" value="#Location.Mission#">
					<input type="hidden" name="orgunitcode" id="orgunitcode" value="">
					</td></tr></table>
				</cfoutput>
				
				
		<cfelse>
		
					<cfoutput>
					<table cellspacing="0" cellpadding="0">
				    <tr><td>
			        <input type="button" style="height:25px;width:25px" class="button7 enterastab" name="search" id="search" value=" ... " onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',document.getElementById('mission').value, mandateno.value)"> 
					</td>
					<td style="padding-left:2px">
					<input type="text" name="orgunitname" id="orgunitname" value="" class="regularxl" size="40" maxlength="60" readonly style="text-align: left;">
					<input type="hidden" name="orgunitclass" id="orgunitclass" value="" class="disabled" size="15" maxlength="15" readonly style="text-align: left;"> 
					<input type="hidden" name="mandateno" id="mandateno" value="#Mandate.MandateNo#">
					<input type="hidden" name="orgunit" id="orgunit" value=""> 
					<input type="hidden" name="mission" id="mission" value="#Location.Mission#">
					<input type="hidden" name="orgunitcode" id="orgunitcode" value="">
					</td></tr></table>
				</cfoutput>
				
				
		</cfif>			
				
		</td>
		</tr> 
		
		 <cf_dialogPosition>
			
		<tr>
		 <td class="labelmedium" style="padding-right:10px"><cf_tl id="Employee">:</td>
		 <td class="labelmedium">
		 
		 <cfif PersonNo neq "">
		 
				 <cfquery name="Person" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Person
					WHERE PersonNo = '#PersonNo#'
				</cfquery>
		 
		        <cfoutput>
				<table cellspacing="0" cellpadding="0">
				<tr><td>
		        <input type="button" style="height:25px;width:25px" class="button7 enterastab" name="search0" id="search0" value=" ... " onClick="selectperson('webdialog','personno','indexno','lastname','firstname','name','','#Location.Mission#')"> 
				</td>
				<td style="padding-left:2px">
				<input type="text" name="name" id="name" value="#Person.FirstName# #Person.LastName#" class="regularxl enterastab" size="40" maxlength="60" readonly style="text-align: left;">
				<input type="hidden" name="indexno" id="indexno" value="" class="regular" size="10" maxlength="10" readonly style="text-align: center;">
				<input type="hidden" name="personno" id="personno" value="#PersonNo#">
			    <input type="hidden" name="lastname" id="lastname" value="">
			    <input type="hidden" name="firstname" id="firstname" value="">
				</cfoutput>
				</td>
				</tr>
				</table>	
		<cfelse>
		
				<table cellspacing="0" cellpadding="0">
			    <tr><td>
				<input type="button" style="height:25px;width:25px" class="button7" name="search0" id="search0" value=" ... " onClick="selectperson('webdialog','personno','indexno','lastname','firstname','name','','#Location.mission#')"> 
				</td>
				<td style="padding-left:2px">
				<input type="text" name="name" id="name" class="regularxl enterastab" size="40" maxlength="60" readonly style="text-align: left;">
				<input type="hidden" name="indexno" id="indexno" value="" class="regular" size="10" maxlength="10" readonly style="text-align: center;">
				<input type="hidden" name="personno" id="personno" value="">
			    <input type="hidden" name="lastname" id="lastname" value="">
			    <input type="hidden" name="firstname" id="firstname" value="">
				</td>
				</tr>
				</table>	
		</cfif>
					
		</td>
		</tr> 		
						   
		<TR>
	        <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
	        <TD>
				<textarea style="width:90%;padding:3px;font-size:12px" class="regular" rows="3" name="Remarks">#Remarks#</textarea>
			</TD>
		</TR>
		
		<tr><td colspan="4" class="labelmedium">
		
		   <table width="99%" align="center">
	    	  <tr><td>
		
			   	 <cf_filelibraryN
					DocumentPath="Location"
					SubDirectory="#url.id#" 				
					Filter=""
					Insert="yes"
					Remove="yes"
					Highlight="no"
					Listing="yes">
					
		    	</td></tr>
			</table>		
		
		
		</td></tr>
				
	   </TABLE>
	   
	   </td>
	   
	   </tr>
	  
	  
	   <tr><td class="line"></td></tr>
	  
	    <tr>
	   <td align="center" colspan="2" height="40">
		    <input class="button10s" type="reset"  name="Reset" id="Reset" value="Close" style="width:100;height:23" onclick="window.close()">
		    <input class="button10s" type="submit" name="Delete" id="Delete" value="Delete" style="width:100;height:23" onClick="return askdelete();">
			<input type="submit" name="Update" id="Update" value=" Update " class="button10s" style="width:100;height:23"> 
	   </td>
	   </tr> 
	   
	   </table>
	   
	</td></tr>
	
	</table>

</CFFORM>

</cfoutput>  


