
<cf_tl id="Tree Node" var="vTree">
<cf_tl id="Edit" 	  var="vEdit">
<cf_tl id="and"  	  var="vAnd">
<cf_tl id="Inquiry"   var="vInquiry">

<cf_screentop height="100%" 
	  label="#vTree# - #vEdit#" 
	  line="no" 
	  banner="blue"  
	  bannerforce="Yes"
	  option="#vTree# #vEdit# #vAnd# #vInquiry#" 
	  html="yes" 
	  systemmodule="System"
	  functionclass="Window"
	  functionName="Organization Edit"
	  scroll="no" 
	  jquery="Yes" 
	  layout="webapp">

<cf_tl id="Do you want to update this unit" var="vAskUpdate" class="message">
<cf_tl id="Do you want to remove this unit" var="vAskDelete" class="message">

<cfoutput>
 
	<script>
	
	function editname(org) {	
	  document.getElementById('namechange').className = "regular"
	}  
	
	function askupdate() {
		if (confirm("#vAskUpdate# ?")) {
			return true 
		}
		return false	
	}	
	
	function askdelete() {
		if (confirm("#vAskDelete# ?")) {
		return true 
		}
		return false	
	}	
	
	function applyunit(org) {	
	    ptoken.navigate('setUnit.cfm?orgunit='+org,'process')		
		try { processorg(orgunit) } catch(e) {}
	}
	
	</script>	

</cfoutput>

<cf_dialoglookup>
<cf_dialogOrganization>
<cf_calendarscript>

<cfparam name="URL.node" default="">
<cfset client.Parent = "#URL.node#">

<cfquery name="Class" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_OrgUnitClass
</cfquery>

<cfquery name="Organization" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Organization
	WHERE  OrgUnit = '#URL.ID#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mandate
	WHERE  Mission     = '#Organization.Mission#'
	AND    MandateNo   = '#Organization.MandateNo#'
</cfquery>

<cfquery name="Parent" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   #CLIENT.LanPrefix#Organization
	WHERE  OrgUnitCode = '#Organization.ParentOrgUnit#'
	AND    Mission     = '#Organization.Mission#'
	AND    MandateNo   = '#Organization.MandateNo#'
</cfquery>

<cf_divscroll>

<cfoutput query = "Organization">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr class="hide"><td id="process"></td></tr>

<tr class="hide"><td colspan="3"><iframe style="width:100%" name="result" id="result"></iframe></td></tr>

<tr><td valign="top">

<cfform action="OrganizationEditSubmit.cfm?source=#URL.source#" target="result" method="POST" name="OrganizationEdit">

<input type="hidden" name="OrgUnitOld" id="OrgUnitOld" value="#OrgUnit#">

<table width="94%" border="0" class="formspacing" align="center">
 
  <tr>
    <td width="100%" align="center">
	
	    <table border="0" class="formpadding formspacing" cellpadding="0" cellspacing="0" width="100%">
		
		<tr><td style="height:8px"></td></tr>		
		
		<cfif url.source eq "base">
			
			<TR><td class="labelmedium"><cf_tl id="Parent node">:</td>
			<TD>
			
			<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
			<td width="80%">
				<input type="text"   name="orgunitnameparent" id="orgunitnameparent" value="#Parent.OrgUnitName#" class="regularxl" size="50" maxlength="80" readonly>		
				<input type="hidden" name="orgunit"           id="orgunit" value="">
				<input type="hidden" name="parentorgunit"     id="parentorgunit"    value="#ParentOrgUnit#"> 
				<input type="hidden" name="parentorgunitold"  id="parentorgunitold" value="#ParentOrgUnit#">
				<input type="hidden" name="orgunitclass"      id="orgunitclass"     value="">				
			</td>
			
			<td width="20" style="padding-left:4px">
			
			<img height="25" 
				onClick="selectorgmis('webdialog','orgunit','parentorgunit','mission','orgunitnameparent','orgunitclass','#Organization.Mission#','#MandateNo#')"
				width="25" src="<cfoutput>#SESSION.root#</cfoutput>/Images/search.png"
				alt="Select unit" 
				border="0" 
				style="cursor:pointer"
				align="absmiddle">
			
			</td>
			
			<td style="padding-left:4px">
			
			<script>
			 function clearparent() {
			    document.getElementById('orgunitnameparent').value = ""
				document.getElementById('orgunit').value = ""
				document.getElementById('parentorgunit').value = ""
			 }
			</script>
			
			<cfoutput>
			
			<cf_tl id="Set a parent root unit" var="vSetParent">
			
			<img height="18" 
				onClick="clearparent()"
				width="17" src="#SESSION.root#/Images/delete5.gif"
				alt="#vSetParent#" 
				border="0" 
				style="cursor:pointer"
				align="absmiddle">
			
			</cfoutput>
			
			</td>
			
			</tr>
			</table>
					
			</TD>
			</TR>
			
		<cfelse>	
		
			<input type="hidden" name="parentorgunit" id="parentorgunit"    value="#ParentOrgUnit#"> 
			<input type="hidden" name="parentorgunitold" id="parentorgunitold" value="#ParentOrgUnit#">
		
		</cfif>
		
		<TR>
	    <TD valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Name"><font color="FF0000">*)</font>:</TD>
	    <TD>
		
			<cf_LanguageInput
				TableCode       = "Organization" 
				Mode            = "Edit"
				Name            = "OrgUnitName"
				Value           = "#OrgUnitName#"
				Key1Value       = "#URL.ID#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a unit name"
				MaxLength       = "80"
				Size            = "80"
				Onchange        = "editname('#OrgUnit#')"
				Class           = "regularxl">
							
		</TD>
		
		</TR>
		
		<TR>
	    <TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Name short">: <font color="FF0000">*)</font></TD>
	    <TD>
		
		<cf_LanguageInput
				TableCode       = "Organization" 
				Mode            = "Edit"
				Name            = "OrgUnitNameShort"
				Value           = "#OrgUnitNameShort#"
				Key1Value       = "#OrgUnit#"
				Type            = "Input"
				MaxLength       = "30"
				Size            = "30"
				Onchange        = "editname('#OrgUnit#')"
				Class           = "regularxl">
			
		</TD>
		</TR>
		
		 <cfquery name="language" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   System.dbo.Ref_SystemLanguage
			 WHERE  SystemDefault = '1'
		 </cfquery>
		
		<cfquery name="History" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT *
		    FROM   OrganizationName
			WHERE  OrgUnit      = '#OrgUnit#'	
			AND    LanguageCode = '#language.code#'
		</cfquery>		
		
		<cfif history.recordcount gte "1">
		
		<tr>
			<td></td>
			<td>
				<table width="90%" class="formpadding">				
				<tr class="line">
				<td><cf_tl id="Until"></td>
				<td><cf_tl id="Name"></td>
				<td><cf_tl id="Short Name"></td>
				</tr>
				<cfloop query="History">
				<tr class="line labelmedium">
				    <td>#dateformat(DateExpiration,client.dateformatshow)#</td>
					<td>#OrgUnitName#</td>
					<td>#OrgUnitNameShort#</td>
				</tr>
				</cfloop>
				</table>
			</td>		
		</tr>
		
		</cfif>
		
		<TR class="hide" id="namechange">
	    <TD style="padding-right:5px" align="right" class="labelmedium"><cf_tl id="Name effective">:</TD>
	    <TD>
		
		  <cf_intelliCalendarDate9
				FieldName="NameEffective" 
				class="regularxl"
				DateValidStart="#Dateformat(DateEffective, 'YYYYMMDD')#"
				DateValidEnd="#Dateformat(DateExpiration, 'YYYYMMDD')#"
				Default=""
				AllowBlank="True">	
		
		</td>
		</tr>
					
		<TR>
	    <TD class="labelmedium"><cf_tl id="Class">:</TD>
	    <TD>	
		
		  	<select name="OrgUnitClassEdit" id="OrgUnitClassEdit" size="1" class="regularxl enterastab">
			<cfloop query="Class">
				<option value="#OrgUnitClass#" <cfif Organization.OrgUnitClass eq Class.OrgUnitClass>selected</cfif>>
		    		#OrgUnitClass#
				</option>
			</cfloop>
		    </select>
			
		</TD>
		</TR>	
		
		<!--- the scope of this orgunit --->
		
		<cfquery name="Vendor"
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ParameterMission
				WHERE     TreeVendor = '#Organization.Mission#'
		</cfquery>
		
		<cfif Vendor.recordcount gte "1">
		
		 	<tr>
				   
			   <TD class="labelmedium" style="width:24%"><cf_tl id="Vendor terms">: <font color="FF0000">*</font></TD>
	    
		       <td colspan="1">				   						  
															
					<cfquery name="VendorTerms" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM Ref_Terms 
							WHERE Operational = 1
					</cfquery>
 	     	   
					<select name="terms" id="terms" class="regularxl enterastab">
								
					      <option value=""><cf_tl id="None"></option>  
						  <cfloop query="VendorTerms">
						   	  <option value="#Code#" <cfif code eq organization.Terms>selected</cfif>>#Description#</option>
					   	  </cfloop>  
					            
					</select>	
												     		   
		       </td>	
			   
			</tr>   
		
		
		<cfelse>
				
			<cf_verifyOperational 
		         module    = "Roster" 
				 Warning   = "No">
				 
			<cfif operational eq "1"> 
				
				<cfquery name="Area"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      Ref_Organization
				</cfquery>
						
				<tr>	
			    <td class="labelmedium"><cf_tl id="Roster Area">:</td>
			    <TD>  
			    	<select name="OrganizationCode" id="OrganizationCode" required="Yes" class="regularxl enterastab">
						<cfloop query="Area">
						<option value="#OrganizationCode#" <cfif Organization.OrganizationCode eq OrganizationCode>selected</cfif>>#OrganizationDescription#</option>
						</cfloop>
					</select>
				      	 
				</TD>
				
				</TR>
				
			</cfif>	
					
		</cfif>
				
		
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Code">:</TD>
	    <TD>	
		
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *
		    FROM   Organization
			WHERE  OrgUnitCode = '#Organization.OrgUnitCode#'
			AND    Mission     = '#Organization.Mission#'
		</cfquery>
	
		<cfif Check.recordcount gt "1">
			<input type="text" name="OrgUnitCode" id="OrgUnitCode" value="#OrgUnitCode#" size="15" maxlength="20" readonly class="regularxl">
		<cfelse>		
			<INPUT type="text" class="regularxl" value="#OrgUnitCode#" name="OrgUnitCode" id="OrgUnitCode" maxLength="20" size="15">
		</cfif>
		<input type="hidden" name="OrgUnitCodeOld" id="OrgUnitCodeOld" value="#OrgUnitCode#">
		<input type="hidden" name="mission" id="mission" value="#Mission#">
		<input type="hidden" name="MandateNo" id="MandateNo" value="#MandateNo#">
			
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" style="height:25px"><cf_tl id="Top Tree">:</TD>
	    <TD class="labelmedium">	
		    <input type="radio" class="radiol"  name="TreeUnit" id="TreeUnit" value="0" <cfif Organization.TreeUnit eq "0">checked</cfif>><cf_tl id="No">
	    	<input type="radio" class="radiol" name="TreeUnit" id="TreeUnit" value="1" <cfif Organization.TreeUnit eq "1">checked</cfif>><cf_tl id="Yes">	  			
		</TD>
		</TR>			
				
		<TR>
	    <TD class="labelmedium" style="height:25px"><cf_tl id="Autonomous">:</TD>
	    <TD class="labelmedium">	
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td><input type="radio" class="radiol" name="Autonomous" id="Autonomous" value="0" <cfif Organization.Autonomous eq "0">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium"><cf_tl id="No, default"></td>
				<td style="padding-left:6px"><input type="radio" class="radiol" name="Autonomous" id="Autonomous" value="1" <cfif Organization.Autonomous eq "1">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium"><cf_tl id="Yes, acts like a parent"></td>
			</tr>	
			</table>	  			
		</TD>
		</TR>	
			
		<tr>				
			<td class="labelmedium" style="height:25px"><a href="##" title="Present this unit as a line or support unit"><cf_tl id="Node role">:</a></td>		 			  		     
			<td>
				<table cellspacing="0" cellpadding="0">
				<tr>
				<td><input type="radio" name="ParentSupport" class="radiol" id="ParentSupport" value="0" <cfif Organization.ParentSupport eq "0">checked</cfif>></td><td style="padding-left:5px" class="labelmedium"><cf_tl id="Line unit"></td>	
				<td style="padding-left:10px"><input type="radio" class="radiol" name="ParentSupport" id="ParentSupport" value="1" <cfif Organization.ParentSupport eq "1">checked</cfif>></td><td style="padding-left:5px" class="labelmedium"><cf_tl id="Support unit"></td>			
				</tr>
				</table>				
	 		</td>			
				
		</TR>	
		
		<TR>
	    <TD class="labelmedium" style="height:25px"><cf_tl id="Work scheduling and submission">:</TD>	 
		<TD class="labelmedium">	
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
			    <input type="radio" class="radiol"  name="Workschema" id="Workschema" value="0" <cfif Organization.Workschema eq "0">checked</cfif>>
				</td>
				<td style="padding-left:4px" class="labelmedium"><cf_tl id="No, default"></td>
				<td style="padding-left:6px">			
			   	<input type="radio" class="radiol" name="Workschema" id="Workschema" value="1" <cfif Organization.Workschema eq "1">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium"><cf_tl id="Yes"></td>
				<td style="padding-left:4px">
				
				<cfquery name="class" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Ref_EntityClass
					WHERE EntityCode = 'OrgAction'
				</cfquery>
		
		    	<select name="WorkschemaEntityClass" class="regularxl">
					<option value="">N/A</option>
					<cfloop query="class">
						<option value="#EntityClass#" <cfif Organization.WorkschemaEntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
					</cfloop>
				</select>
				
				
				</td>
			</tr>
			</table>					
		</TD>
		</TR>	
		
		
		<TR>
	    <TD class="labelmedium" style="height:26"><cf_tl id="Application Server">:</TD>
	    <TD>	
			
				<cfquery name="appServer" 
				datasource="AppsControl" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM ParameterSite
					WHERE Operational = 1
				</cfquery>
		
		    	<select name="ApplicationServer" id="ApplicationServer" class="regularxl">
					<option value="">N/A</option>
					<cfloop query="appServer">
						<option value="#ApplicationServer#" <cfif Organization.ApplicationServer eq ApplicationServer>selected</cfif>>#ApplicationServer#</option>
					</cfloop>
				</select>
				  			
		</TD>
		</TR>	
			
		
		<TR>
	    <TD class="labelmedium" style="height:26"><cf_tl id="Source">:</TD>
	    <TD>
			<table cellspacing="0" cellpadding="0"><tr><td>
			<input type="text" name="Source" id="Source" value="#Source#" size="10" maxlength="10" class="regularxl" style="text-align: center;">
			</td>
			<TD class="labelmedium" style="padding-left:7px"><cf_tl id="Code">:</TD>
		    <TD style="padding-left:3px">
			<input type="text" name="SourceCode" id="SourceCode" value="#SourceCode#" size="20" maxlength="20" class="regularxl" style="text-align: center;">
			</TD>
			</tr></table>
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium" style="height:26"><cf_tl id="Tree order">:</TD>
	    <TD>
			<cfinput type="Text" name="TreeOrder" value="#TreeOrder#" style="text-align: center;" message="Please enter a numeric value" validate="integer" required="No" size="3" maxlength="6" class="regularxl">		
		</TD>
		</TR>
		   
	    <TR>
	    <TD class="labelmedium" width="180"><cf_tl id="Effective">:</TD>
	    <td>
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
		
			  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxl"
				DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
				DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
				Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			
			</td>
			<td style="padding-left:10px;padding-right:10px">-</td>
			<td>
			
			  <cf_intelliCalendarDate9
				FieldName="DateExpiration"
				class="regularxl"
				DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
				DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#" 
				Default="#Dateformat(DateExpiration, CLIENT.DateFormatShow)#"
				AllowBlank="True">	
				
			</TD>
			</TR>
			</table>
		</td>	
					   
		<TR>
	        <td valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Remarks">:</td>
	        <TD class="labelmedium">
			
			<cf_LanguageInput
				TableCode       = "Organization" 
				Mode            = "Edit"
				Name            = "Remarks"
				Value           = "#Remarks#"
				Key1Value       = "#OrgUnit#"
				Type            = "Text"
				MaxLength       = "300"
				cols            = "69"
				rows            = "3"
				style           = "font-size:13px;height:40px"
				Class           = "regular">
				
			 </TD>
		</TR>
				
		<TR>
		    <TD class="labelmedium" style="cursor:pointer;padding-top:1px" valign="top">
			<cf_UIToolTip tooltip="Define a user account that will be granted access to Portal information (invoices etc.) associated to this node"><cf_tl id="Associated Users">:</cf_UIToolTip></TD>
		    <TD height="70" valign="top" style="border:0px solid silver">			
			<cfinclude template="OrganizationUser.cfm">			
			</TD>
		</TR>	
			  
	   <tr><td colspan="2" class="line"></td></tr>
	  	   
	   <tr>
		   <td align="center" colspan="2" height="24">
		  
		    <cf_tl id="Delete" var="vDelete">
			<cf_tl id="Close"  var="vClose">
			<cf_tl id="Update" var="vUpdate">
			   
			<input type="button"     name="Close" id="Close" value=" #vClose# " class="button10g" onclick="window.close()">
			<input class="button10g" type="submit" name="Delete" id="Delete" value=" #vDelete# " onClick="return askdelete();">
			<input type="submit"     name="Update" id="Update" value=" #vUpdate# " class="button10g">			
		 
		   </td>
	   </tr> 
	   
	   </table>
   
   </td>   
   </tr>
  
</table>

</CFFORM>

 </td>   
   </tr>
  
</table>
    

</cfoutput>

</cf_divscroll>

<cf_screenbottom layout="innerbox">
