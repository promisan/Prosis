<cf_param name="url.mode" default="edit">

<cf_param name="url.entryScope"  	default="Backoffice" type="string">
<cf_param name="url.section" 		default=""  type="string">
<cf_param name="url.mission" 		default=""  type="string">
<cf_param name="url.applicantno" 	default="0" type="string">
<cf_param name="url.Id"	 			default="" 	type="string">
<cf_param name="url.Id1" 			default=""  type="String">  <!--- type="GUID" --->
<cf_param name="url.owner" 			default=""  type="String">

<cfquery name="AddressType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM #CLIENT.LanPrefix#Ref_AddressType
</cfquery>

<cfquery name="Relationship" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Relationship
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     #CLIENT.LanPrefix#Ref_Nation
    ORDER BY Name
</cfquery>

<cfform name="formaddress" id="formaddress" onsubmit="return false">

<table width="99%" align="center" class="formpadding">
<tr>

<td>
    
<cfquery name="Address" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ApplicantAddress
	WHERE  PersonNo = '#URL.ID#'
	AND    AddressId = '#URL.ID1#' 
</cfquery>
  
<cfoutput>
<input type="hidden" name="PersonNo"  value="#URL.ID#">
<input type="hidden" name="AddressId" value="#URL.ID1#">
</cfoutput>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

  <cfif url.entryscope neq "backoffice">
  
  <cfoutput>
  <tr>
    <td height="30" align="left" style="padding-top:25px;padding-left:15px" valign="middle" class="labellarge">
	 <table>
	 <tr><td style="padding-left:4px">    
	    <img src="#SESSION.root#/images/logos/staffing/blue/address.png" alt="Click to view details"  height="65" border="0" align="absmiddle">    	
		</td>
		<td class="labellarge" valign="bottom" style="font-size:30px;padding-left:15px;padding-bottom:6px">
    	<cf_tl id="Amend"><cf_tl id="Contact"></b></font>
		</td>		
	    </tr></table>
    </td>    
  </tr>   
  </cfoutput>	     
  
  </cfif>
  
  <tr>
  <td style="padding-left:30px;pading-right:10px">
  <table width="100%" align="center" class="formpadding">
    <tr> 
    <td width="100%" colspan="2" style="padding:3px">
 
    <table border="0" cellpadding="0" cellspacing="0" align="center" class="formpadding">
	   
    <cfoutput>    	
	
	<cfset row = 0>
	<cfset lat  = "">
	<cfset lng  = "">
	
	<cfloop index="itm" list="#Address.Coordinates#" delimiters=",">
		<cfset row = row+1>
		<cfif row eq "1">
		  <cfset  lat = itm>
		<cfelse>
		   <cfset lng = itm>  		
		</cfif>
	</cfloop>			
		
	<TR>
	
	    <TD class="labelmedium" style="min-width:130px"><cf_tl id="Address type">:</TD>
	  
	    <TD>
		   	<cfselect name="AddressType" class="regularxxl enterastab">
		    	<cfloop query="AddressType">
					<option value="#AddressType#" <cfif Address.AddressType eq AddressType>selected</cfif>>
					#Description#
					</option>
				</cfloop>
		   	</cfselect>		
		</TD>
		
		<td rowspan="12" valign="top" align="right" style="padding-left:10px">
		
			<cfif client.googlemap eq "1">
			
				<cfset maplink = "mapaddress()">	
				
				<cf_mapshow scope="embed" mode="edit" addressid="#url.id1#" width="400" script="No" height="390" latitude="#lat#" longitude="#lng#">		
				
			<cfelse>
			
				<cfset maplink = "">
				
			</cfif>		
		
		</td>	
	
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Country">:</TD>
    <TD>
	   	<cfselect name="country" id="country" class="regularxxl enterastab" onchange="#maplink#">
		    <cfloop query="Nation" >
				<option value="#Code#" <cfif Address.Country eq Code>selected</cfif>>#Name#</option>
			</cfloop>    
	   	</cfselect>		
	</TD>
	</TR>
		
    <TR>
	    <TD class="labelmedium"><cf_tl id="State"></TD>
    	<TD><cfinput class="regularxxl enterastab" type="Text" name="State" value="#Address.State#" size="10" maxlength="20"></TD>
	</TR>
			
	<TR>
	    <TD class="labelmedium"><cf_tl id="City">: <font color="FF0000">*</font></TD>
    	<TD><cfinput class="regularxxl enterastab" type="Text" 
    		onchange="#maplink#" 
    		id="addresscity" 
    		name="addresscity" 
    		value="#Address.City#" 
    		message="Please enter an city" 
    		required="Yes" 
    		size="40" 
    		onError="show_error"
    		maxlength="40">
    	</TD>
	</TR>
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Postal code">:</TD>    <TD>
	
			<cfif url.entryscope eq "Backoffice">			
				<cf_textInput
				  form      = "addressentry"
				  type      = "ZIP"
				  mode      = "regular"
				  class     = "regularxxl"
				  name      = "addresspostalcode"
			      value     = "#Address.AddressPostalCode#"
		          required  = "1"
				  size      = "8"
				  maxlength = "8"
				  label     = "&nbsp;"
				  onError   = "show_error"
				  style     = "text-align: center;">
			<cfelse>
			   	<cfinput 
			   		class="regularxxl enterastab" 
			   		type="Text" 
			   		name="addresspostalcode" 
			   		id="addresspostalcode" 
			   		message="Please enter an address postal code" 
					value     = "#Address.AddressPostalCode#"
			   		required="No" 
			   		size="6"
			   		maxlength="6">
			</cfif>
					
 		</TD>
	</TR>
		
	<TR>
	    <TD class="labelmedium"><cf_tl id="Address">: <font color="FF0000">*</font></TD>
    	<TD><cfinput class="regularxxl enterastab" 
    			onchange="#maplink#" 
    			type="Text" 
    			id="address" 
    			name="address" 
    			value="#Address.Address1#" 
    			message="Please enter an address" 
    			required="Yes"
    			onError="show_error" 
    			size="40" 
    			maxlength="100"></TD>
	</TR>
		
    <TR>
	    <TD class="labelmedium"><cf_tl id="Address">2:</TD>
    	<TD><cfinput class="regularxxl enterastab" type="Text" name="Address2" value="#Address.Address2#" message="Please enter an address" required="No" size="40" maxlength="100"></TD>
	</TR>
	
	<!---	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Address Zone">:</TD>
    	<TD><cfinput class="regularxl enterastab" type="Text" name="AddressZone" value="#Address.AddressZone#" style="text-align: center;" required="No" size="10" maxlength="10"></TD>
	</TR>
	--->
			
	
	<TR class="hide">
    <TD class="labelmedium"><cf_tl id="Coordinates">:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td class="labelmedium">Lat:</td>
			<td>&nbsp;</td>
			<td><cfinput class="regularxxl enterastab" validate="float" value="#lat#" type="Text" id="cLatitude" name="cLatitude" size="15" maxlength="20"></td>
			<td>&nbsp;</td>
			<td class="labelmedium">Lng:</td>
			<td>&nbsp;</td>
			<td>
			<cfinput class="regularxxl enterastab" validate="float" value="#lng#" type="Text" id="cLongitude" name="cLongitude" size="15" maxlength="20">	
			</td>
			</tr>
		</table>
	</TD>
	</TR>		
	
	<TR><TD class="labelmedium"><cf_tl id="Telephone">:</TD>
    	<TD><input type="Text" name="TelephoneNo" value="#Address.TelephoneNo#" size="20" maxlength="20" class="regularxxl enterastab"></TD>
	</TR>
	
	<TR class="hide">
    	<TD class="labelmedium"><cf_tl id="Fax">:</TD>
	    <TD><input type="Text" name="FaxNo" value="#Address.Faxno#" size="20" maxlength="20" class="regularxxl enterastab"></TD>
	</TR>	
		
	<TR><TD class="labelmedium"><cf_tl id="Cellular">:</TD>
    	<TD><input type="Text" name="Cellular" value="#Address.Cellular#" size="20" maxlength="20" class="regularxxl enterastab"></TD>
	</TR>
	
			
	<TR>
    <TD class="labelmedium"><cf_tl id="eMail"></TD>
    <TD><cfinput type="Text" validate="email" name="emailaddress" value="#Address.emailaddress#" message="Please enter a valid eMail address" required="No" size="30" maxlength="40" class="regularxxl enterastab"></TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Contact Person">:</TD>
    <TD>
	   <table cellspacing="0" cellpadding="0">
	   <tr>
		   <td>
		   <cfselect name="ContactRelationShip" class="regularxxl enterastab">
			<option value="" selected></option>
			<cfloop query="Relationship">
				<option value="#Relationship#" <cfif Address.ContactRelationship eq Relationship>selected</cfif>><cf_tl id="#Description#"></option>
			</cfloop>
	 		</cfselect>
	   	   </td>
		   <td style="padding-left:4px">
		   	<input type="Text" name="Contact" value="#Address.Contact#" size="30" maxlength="40" class="regularxxl enterastab">		
		   </td>
	   </tr>
	   </table>	
	</TD>
	</TR>
			   
	<TR>
        <td valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Remarks">:</td>
        <td><textarea class="regular" style="width:100%;font-size:14px;padding:4px" cols="70" rows="3" name="Remarks">#Address.Remarks#</textarea> </td>
	</TR>
	
	</table>
	
	</td>
	</tr>
	
	<tr><td height="1" colspan="3" class="line"></td></tr>
	
	<tr><td colspan="3" style="height:40" align="center"> 	
  	 
	 <cfinvoke component="Service.Access"  
			 method="roster" 
			 returnvariable="Access"
			 role="'AdminRoster','CandidateProfile'">
			 
	 <cfif access eq "EDIT" or url.entryscope eq "portal">		 
	 
		  <cf_tl id="Delete" var="1">
		  <input class="button10g"  
		      type="button" 
			  name="Submit" 
			  value=" #lt_text#" 
			  onclick="ColdFusion.navigate('#SESSION.root#/Roster/Candidate/Details/Address/AddressDelete.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&id1=#url.id1#&entryScope=#url.entryScope#&mission=#url.mission#','addressprocess')">
	 
	 </cfif>
	 
	 <cf_tl id="Save" var="1">
	 <input class="button10g"  type="button" name="Submit" value=" #lt_text#" onclick="validate('#url.id1#')">		 
	 
	</td></tr>
	
	</table>

</td>
</tr>

</cfoutput>
 
</table>

</CFFORM>

<script>
	Prosis.busy('no')
</script>

