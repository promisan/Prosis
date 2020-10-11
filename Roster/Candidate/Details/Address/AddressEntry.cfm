<cf_param name="url.mode" default="edit" type="String">
<cf_param name="url.id"   default="" type="String">
<cf_param name="url.submissionedition"   default="" type="String">

<cfquery name="Prior" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP 1 *
    FROM  ApplicantAddress
	WHERE PersonNo = '#URL.ID#'
	ORDER BY Created DESC
</cfquery>

<cfif Prior.recordcount eq "0">

	<cfquery name="Prior" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
	    FROM     ApplicantAddress 
		ORDER BY Created DESC
	</cfquery>

</cfif>

<cfquery name="AddressType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM #CLIENT.LanPrefix#Ref_AddressType
	WHERE Operational = 1
	ORDER BY ListingOrder
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
	   SELECT *
	   FROM   #CLIENT.LanPrefix#Ref_Nation
	   ORDER BY Name
</cfquery>

<cfform name="formaddress" id="formaddress" onsubmit="return false">

<cfoutput><input type="hidden" name="PersonNo" id="PersonNo" value="#URL.ID#" class="regular"></cfoutput>

<cfif client.googlemap eq "1">
	<cfset maplink = "mapaddress()">				
<cfelse>		
	<cfset maplink = "">			
</cfif>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

  <cfif url.entryscope neq "backoffice">
   
  <cfoutput>
   
  <tr>
    <td height="30" align="left" valign="middle" class="labellarge" style="padding-top:28px">
	 <table>
	 <tr ><td style="padding-left:25px">    
	    <img src="#SESSION.root#/images/logos/staffing/blue/address.png" height="65" alt="Click to view details"  border="0" align="absmiddle">    	
		</td>
		<td class="labellarge" valign="bottom" style="font-size:30px;padding-left:16px;padding-bottom:3px">
    	<cf_tl id="Add Address">
		</td>		
    </tr>
	
	</table>
    </td> 
   
  </tr> 
  
  </cfoutput>	     
  
  </cfif>
  
  <tr><td height="10"></td></tr>
       
  <tr>
    <td width="100%" valign="top" colspan="2" style="padding-left:20px;pading-right:10px">
	
    <table border="0" cellpadding="0" cellspacing="0" width="96%" align="center" class="formpadding">
						
	<TR>
    <TD class="labelmedium" style="min-width:120px"><cf_tl id="Address type">: <font color="FF0000">*</font></TD>
    <TD>	
	   	<cfselect name="AddressType" id="AddressType" class="regularxl enterastab">
		    <cfoutput query="AddressType">
				<option value="#AddressType#">#Description#</option>
			</cfoutput>	    
	   	</cfselect>		
	</TD>
	
		
	</TR>	
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Country">: <font color="FF0000">*</font></TD>
    <TD>		
		
		<cfset nat = Prior.Country>		
				
		<cfif nat eq "">
		
			<cfquery name="PHPParameter" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
		    	SELECT   TOP 1 *
			    FROM     Parameter
			</cfquery>
		
			<cfset nat= PHPParameter.PHPNationality>
		</cfif>
			
	   	<cfselect name="country" id="country" class="regularxl enterastab" onchange="#maplink#">
		    <cfoutput query="Nation">
				<option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#</option>
			</cfoutput>
	   	</cfselect>		
		
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="State"></TD>
    <TD>
	   	<cfinput class="regularxl enterastab" value="#prior.state#" type="Text" name="State" id="State" size="10" maxlength="20">	   
	</TD>
	</TR>
				
	<TR>
    <TD class="labelmedium"><cf_tl id="City">: <font color="FF0000">*</font></TD>
    <TD>
	   	<cfinput 
	   		class="regularxl enterastab" 
	   		type="Text" 
	   		onchange="#maplink#" 
			value="#prior.city#"
	   		name="addresscity" 
	   		id="addresscity" 
	   		message="Please enter a city name" 
	   		required="Yes" 
	   		size="40"
	   		onError="show_error" 
	   		maxlength="40">
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Postal code">:</TD>
    <TD>
	
		<cfif url.entryscope eq "Backoffice">
		
			<cf_textInput
				  form      = "addressentry"
				  type      = "ZIP"
				  mode      = "regularxl"
				  class     = "regularxl"
				  name      = "addresspostalcode"
				  id		= "addresspostalcode"
			      value     = "#prior.addresspostalcode#"
		          required  = "0"
				  size      = "8"
				  maxlength = "8"
				  label     = "&nbsp;"
				  onError   = "show_error"
				  style     = "text-align: center;">
				  
		<cfelse>
		
		   	<cfinput 
		   		class     = "regularxl enterastab" 
		   		type      = "Text" 
		   		name      = "addresspostalcode" 
		   		id        = "addresspostalcode" 
		   		message   = "Please enter an address postal code" 
		   		required  = "No" 
				value     = "#prior.addresspostalcode#"
		   		size      = "8"
		   		maxlength = "8">
				
		</cfif>		  
		
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Address">: <font color="FF0000">*</font></TD>
    <TD class="regular">
	   	<cfinput 
	   		class="regularxl enterastab" 
	   		type="Text" 
	   		onchange="#maplink#" 
	   		name="address" 
	   		id="address" 
	   		message="Please enter an address" 
	   		required="Yes" 
	   		size="50"
	   		onError="show_error" 
	   		maxlength="100">
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Address">2:</TD>
    <TD class="regular">
	   	<cfinput class="regularxl enterastab" type="Text" name="address2" id="address2" message="Please enter an address" required="No" size="50" maxlength="100">
	</TD>
	</TR>
		
	<TR class="hide">
    <TD class="labelmedium"><cf_tl id="Coordinates">:</TD>
    <TD>
	<table cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium">Lat:</td>
		<td>&nbsp;</td>
		<td>
		<cfinput class="regularxl enterastab" validate="float" type="Text" name="cLatitude" id="cLatitude" size="15" maxlength="20">	
		</td>
		<td>&nbsp;</td>
		<td class="labelmedium">Lng:</td>
		<td>&nbsp;</td>
		<td>
		<cfinput class="regularxl enterastab" validate="float" type="Text" name="cLongitude" id="cLongitude"  size="15" maxlength="20">	
		</td>
		</tr>
	</table>
	</TD>
	</TR>	
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Telephone">:</TD>
    <TD>
	   	<input type="Text" name="TelephoneNo" id="TelephoneNo" size="20" maxlength="20" class="regularxl enterastab">
 	</TD>
	</TR>
		
	<TR class="hide">
    <TD class="labelmedium"><cf_tl id="Fax">:</TD>
    <TD>
	   	<input type="Text" name="FaxNo" id="FaxNo" size="20" maxlength="20" class="regularxl enterastab">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="eMail">:</TD>
    <TD>
	   	<cfinput type="Text" name="emailaddress"  id="emailaddress" required="no" message="Please enter a valid eMail address" validate="email" size="30" maxlength="40" class="regularxl enterastab">
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Cellular:"></TD>
    <TD>
	   	<input type="Text" name="Cellular" id="Cellular" size="20" maxlength="20" class="regularxl enterastab">
 
	</TD>
	</TR>
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Contact Person">:</TD>
    <TD>
	<table cellspacing="0" cellpadding="0">
	  <tr>
	  <td>
	  
	  <cfselect name="ContactRelationShip" id="ContactRelationShip" class="regularxl enterastab">
		   <option value="" selected></option>
		    <cfoutput query="Relationship">
			<option value="#Relationship#">
				<cf_tl id="#Description#">
			</option>
			</cfoutput>
 	  </cfselect>
	  
	  </td>
	  <td style="padding-left:4px"><input type="Text" name="Contact" id="Contact" size="30" maxlength="40" class="regularxl enterastab"></td>
	  </tr>
	 </table>  	
	</TD>
	</TR>	
			   
	<TR>
        <td valign="top" style="padding-top:4px">
			<table cellspacing="0" cellpadding="0">
				<tr><td class="labelmedium" style="padding-top:2px"><cf_space spaces="30"><cf_tl id="Remarks">:</td></tr>
				<tr><td id="memocount"></td></tr>
			</table>
		</td>
        <TD colspan="1">
		<textarea class="regular" style="width:100%;font-size:13px;padding:4px" rows="7" name="Remarks" id="Remarks" ></textarea> 
		</TD>
	</TR>
	
	</table>
	
	</td>
	
	<td valign="top" align="right" style="padding-left:10px">
		<cf_mapshow scope="embed" mode="edit" script="no" width="400" height="390">							
	</td>	
	
	</tr>	
	
	<tr><td height="1" colspan="3" class="line"></td></tr>
	
	<tr><td colspan="3" align="center" height="30">	 
	    <cfoutput>
		<cf_tl id="Reset" var="1">
	   <input class="button10g" type="reset"  name="Reset" id="Submit" value="#lt_text#"> 
	    <cf_tl id="Save" var="1">
	   <input class="button10g" type="button" name="Submit" id="Submit" value="#lt_text#" onclick="validate('')">	  
	   </cfoutput>
   </td>
   
   </tr>
   
</table>

</CFFORM>

<script>
	Prosis.busy('no')
</script>
