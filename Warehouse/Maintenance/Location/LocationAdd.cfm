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

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes"> <!--- blockevent="rightclick" --->

<cfif client.googleMAP eq "1">
	<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">  
</cfif>
	
<cf_calendarscript>

<cfparam name="URL.ID1" default="">
<cfparam name="URL.ID3" default="{00000000-0000-0000-0000-000000000000}">

<cfif url.id3 eq "">
    <cfset url.id3 = "{00000000-0000-0000-0000-000000000000}">
</cfif>

<cfparam name="URL.ID4" default="">

<script>

function ask() {
	if (confirm("Do you want to add this org unit ?")) {	
	return true 	
	}	
	return false	
}	

</script>	

<cfquery name="Class" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_LocationClass
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Mission
	WHERE Mission = '#URL.ID1#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP 1 *
    FROM Ref_Mandate
	WHERE Mission = '#URL.ID1#'
	ORDER BY MandateDefault DESC
</cfquery>

<cfquery name="Location" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Location
	WHERE Location = '#URL.ID3#'
</cfquery>

<cfoutput> 

<cf_dialogAsset>

<!--- <cfform action="OrganizationAddSubmit.cfm" method="POST" name="OrganizationEntry" onSubmit="return ask();"> --->

<cfform action="LocationAddSubmit.cfm" method="POST" name="locentry">

<input type="hidden" name="ParentLocation" id="ParentLocation" value="#URL.ID3#">
<input type="hidden" name="MasterLocation" id="MasterLocation" value="#URL.ID4#">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
  <tr>
    <td width="100%" class="labellarge" style="height:36px;padding-left:10px" align="left" valign="middle">
	   	<cf_tl id="Add Location">
	 </td>
  </tr> 	
  
</table>

<table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center" class="formpadding">
  
<cfif URL.ID3 neq "">

<cfquery name="SearchResult" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct O.*
    FROM   Location O
	WHERE O.Mission   = '#URL.ID1#'
	AND   O.Location    = '#URL.ID3#'
</cfquery>

 <tr><td width="100%">
	
	 <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
			 
	 <cfif searchresult.recordcount gte "1">
	 
	 <TR class="line labelmedium">
	    <td height="20"></td>
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Description"></TD>
	    <TD><cf_tl id="Class"></TD>
	 </TR>
	 
	 <tr bgcolor="FCFDBD">
	     <TD width="5%">&nbsp;
		   <a href="javascript:editLocation('#SearchResult.Location#')">
		   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/edit.gif" alt="" width="11" height="11" border="0" style="cursor: pointer;" align="middle">
		   </a>
	     </td>
	     <td width="10%"><b>#SearchResult.LocationCode#</b></td>
	     <TD width="60%"><b>#SearchResult.LocationName#</b></TD>
	     <TD width="15%"><b>#SearchResult.LocationClass#</b></TD>
	 </TR>
	 
	 </cfif>
	 
	 </TABLE>
 
 </cfif>  
 
 </td></tr>
 
 <tr><td class="line"></td></tr>
        
  <tr>
    <td width="100%">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
	
	<tr><td height="4"></td></tr>
   	
	<TR>
    <TD width="20%" class="labelmedium"><cf_tl id="Hierarchy">:</TD>
    <TD class="labelmedium">
	
    	<cfif URL.ID3 eq "{00000000-0000-0000-0000-000000000000}">
		<INPUT type="radio" name="Level" id="Level" value="Root" checked> <cf_tl id="Root">
		<cfelse>
		<INPUT type="radio" name="Level" id="Level" value="Root"> <cf_tl id="Root">
		<INPUT type="radio" name="Level" id="Level" value="Same"> <cf_tl id="Same level">
		<INPUT type="radio" name="Level" id="Level" value="Child" checked> <cf_tl id="Child">
		<input type="hidden" name="ParentParentLocation" id="ParentParentLocation" value="#SearchResult.ParentLocation#">
		</cfif>
		
	</TD>
	<td rowspan="16">
	
	<cfif client.googleMAP eq "1">
		<cf_mapshow scope="embed" mode="edit" width="380" height="350" latitude="#location.Latitude#" longitude="#location.Longitude#" format="map">		
	</cfif>
		
	</td>
	</TR>
					
	<TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
	<cfinput type="Text" name="locationcode" class="regularxl enterastab" message="Please enter a valid Location code" required="Yes" size="10" maxlength="10">
	</TD>
	
	</TR>
		
	<tr id="manual">
    <TD class="labelmedium"><cf_tl id="Name">:</TD>
    <TD>
	<cfinput type="Text" name="LocationName" class="regularxl enterastab" message="Please enter a Location name" required="Yes" size="40" maxlength="80">
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Class">:</TD>
    <TD>
	
	  	<select name="locationclass" id="locationclass" size="1" class="regularxl enterastab">
		<cfloop query="Class">
		<option value="#Code#">#Description#</option>
		</cfloop>
	    </select>
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
    <TD>
	 
		   	<select name="country" id="country" required="No" class="regularxl enterastab">
			    <cfloop query="Nation">
					<option value="#Code#">#Name#</option>
				</cfloop>	    
		   	</select>		
		
	</TD>
	</TR>
	
	<TR>
	    <TD height="20" class="labelmedium"><cf_tl id="City">:</TD>
	    <TD>	
		<cfinput class="regularxl enterastab" onchange="mapaddress()" type="Text" name="addresscity" value="" message="Please enter an city" required="No" size="40" maxlength="50">	   	
		</TD>
	</TR>
	
	<TR>
	    <TD height="20" class="labelmedium"><cf_tl id="Address">:</TD>
	    <TD>	
		<cfinput class="regularxl enterastab" onchange="mapaddress()" type="Text" name="address" value="" message="Please enter an address" required="No" size="40" maxlength="80">	   	
		</TD>
	</TR>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Latitude">:</td>		
		<td>
		<cfinput type="Text" name="cLatitude" value="#location.Latitude#" validate="float" required="No" size="15" maxlength="20" class="regularxl enterastab">	
		</td>
	</tr>
	
	<tr>			
		<td class="labelmedium"><cf_tl id="Longitude">:</td>		
		<td>		
		<cfinput class="regularxl enterastab" validate="float" value="#location.Longitude#" type="Text" name="cLongitude"  require="No" size="15" maxlength="20">	
		</td>		
	</TR>		
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Order">:</TD>
    <TD>
	<cfinput type="Text" name="TreeOrder" class="regularxl enterastab" message="Please enter a numeric value" validate="integer" required="No" size="4" maxlength="4">
	</TD>
	</TR>
	      
    <TR>
    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
    <TD>
	
		  <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#Dateformat(Mission.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False"
			class="regularxl enterastab">	
	
	</TD>
	</TR>
		
	  <TR>
    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
    <TD>
	
		  <cf_intelliCalendarDate9
		FieldName="DateExpiration" 
		Default="#Dateformat(Mission.DateExpiration, CLIENT.DateFormatShow)#"
		AllowBlank="True" class="regularxl enterastab">	
			
	</TD>
	</TR>
	      
    <TR>
    <TD class="labelmedium"><cf_UIToolTip tooltip="Asset items on this location can be redistributed">Distribution Location:</cf_UIToolTip></TD>
    <TD class="labelmedium">
		<input type="radio" class="radiol enterastab" name="StockLocation" id="StockLocation" value="1"> Yes
		<input type="radio" class="radiol enterastab" name="StockLocation" id="StockLocation" value="0" checked> No
    </td>
    </tr>
			
	<cf_dialogOrganization>
    
	<tr>
	 <td class="labelmedium"><cf_tl id="Unit">:</td>
	 <td>
        <cfoutput>
        <input type="button" class="regularxl enterastab" name="search" id="search" value=" ... " onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',mission.value, mandateno.value)"> 
		<input type="text" name="orgunitname" id="orgunitname" value="" class="regularxl enterastab" size="30" maxlength="60" readonly style="text-align: left;">
		<input type="hidden" name="orgunitclass" id="orgunitclass" value="" class="disabled" size="15" maxlength="15" readonly style="text-align: left;"> 
		<input type="hidden" name="mandateno" id="mandateno" value="#Mandate.MandateNo#">
		<input type="hidden" name="orgunit" id="orgunit" value=""> 
		<input type="hidden" name="mission" id="mission" value="#URL.ID1#">
		<input type="hidden" name="orgunitcode" id="orgunitcode" value="">
		</cfoutput>
	</td>
	</tr> 
	
	<tr>
	 <td class="labelmedium"><cf_tl id="Employee">:</td>
	 <td>
 
	 <cf_dialogPosition>
 		
	<input type="button" class="regularxl enterastab" name="search0" id="search0" value=" ... " onClick="selectperson('webdialog','personno','indexno','lastname','firstname','name','','#URL.ID1#')"> 
	<input type="text" name="name" id="name" class="regularxl enterastab" size="30" maxlength="60" readonly style="text-align: left;">
	<input type="hidden" name="indexno" id="indexno" value="" class="regular" size="10" maxlength="10" readonly style="text-align: center;">
	<input type="hidden" name="personno" id="personno" value="">
    <input type="hidden" name="lastname" id="lastname" value="">
    <input type="hidden" name="firstname" id="firstname" value="">
	 
	 </td>
	</tr>
					   
	<TR>
        <td class="labelmedium"><cf_tl id="Remarks">:</td>
        <TD style="padding-right:4px"><input class="regularxl enterastab" type="text" name="Remarks" id="Remarks" size="40" maxlength="100"></TD>
	</TR>
			
	<cf_assignid>
	
	<tr><td height="4"></td></tr>
	<tr><td class="line" colspan="4"></td></tr>	
	<tr><td height="4"></td></tr>
	
	<TR>
        <td class="labelmedium"><cf_tl id="Attach">(<cf_tl id="floorplan">.. ):</td>	
	    <td colspan="2">	
		   <table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	    	  <tr><td>
		
			   	 <cf_filelibraryN
					DocumentPath="Location"
					SubDirectory="#rowguid#" 				
					Filter=""
					Insert="yes"
					Remove="yes"
					Highlight="no"
					Listing="yes">
					
		    	</td></tr>
			</table>		
		</td>
	</tr>
	
	<input class="hide" type="text" name="Location" id="Location" value="#rowguid#">
		
	<tr><td class="line" colspan="4"></td></tr>	
	
   <tr>
   <td align="center" colspan="4" height="40">
       <table class="formspacing"><tr><td>
	   <input type="button" name="cancel" id="cancel" value="Cancel" class="button10g" onClick="history.back()" style="width:130;height:23">
	   </td>
	   <td>
	   <input class="button10g" type="submit" name="Update" id="Update" value=" Save " style="width:130;height:23">   
	   </td></tr></table>
   </td>
   </tr>
   
</table>

</CFFORM>

</cfoutput>
