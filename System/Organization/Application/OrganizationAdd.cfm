<cf_screentop jquery="Yes" html="No">


<cfparam name="URL.ID3" default="">
<cfparam name="URL.ID4" default="">
<cfparam name="URL.Source" default="">

<cf_dialoglookup>
<cfajaximport tags="cfdiv,cfwindow">
<cf_calendarscript>

<script>

function ask() {
	if (confirm("Do you want to add this org unit ?")) {
		return true 
	}
	return false	
}	

function inh(st){

	itm1 = document.getElementById("inherit1")
	itm3 = document.getElementById("inherit3")
	itm9 = document.getElementById("manual")

if (st == "0") {
	itm1.className = "hide";
	itm3.className = "hide";
	itm9.className = "regular";	
 } else {
	itm1.className = "regular";
	itm3.className = "regular";
	itm9.className = "hide";
 }
 
 }

</script>


<cfquery name="Class" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_OrgUnitClass
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mandate
	WHERE  Mission  = '#URL.ID1#' 
	 AND   MandateNo = '#URL.ID2#'
</cfquery>

<cfquery name="Organization" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   #CLIENT.LanPrefix#Organization
	WHERE  OrgUnitCode = '#URL.ID3#'
</cfquery>


<cfoutput> 

<cf_dialogOrganization>

<cf_divscroll>
<cfform action="OrganizationAddSubmit.cfm?mode=#url.mode#&source=#url.source#" method="POST" name="OrganizationEntry">

<input type="hidden" name="Mission" id="Mission" value="#URL.ID1#">
<input type="hidden" name="Mandate" id="Mandate" value="#URL.ID2#">
<input type="hidden" name="ParentOrgUnit" id="ParentOrgUnit" value="#URL.ID3#">
<input type="hidden" name="MasterOrgUnit" id="MasterOrgUnit" value="#URL.ID4#">

<table width="94%" border="0" align="center">

<tr><td height="5"></td></tr>

<tr>
    <td colspan="2" width="100%" height="29" align="left" valign="middle" class="labelmedium">
	 &nbsp;<img src="#SESSION.root#/Images/hr_org_new.gif" alt="absmiddle" border="0">  
	 <b>&nbsp;<cf_tl id="Add Node for"> <cfoutput>#URL.ID1#</cfoutput> </b>
	 </td>
</tr> 	

<tr><td colspan="2" width="100%">  
	    
	<cfif URL.ID3 neq "">
		
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT distinct O.*
		    FROM #CLIENT.LanPrefix#Organization O
			WHERE O.Mission   = '#URL.ID1#'
			AND O.MandateNo = '#URL.ID2#'
			AND O.OrgUnitCode = '#URL.ID3#'
		</cfquery>
		
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
				 
		 <TR bgcolor="f4f4f4">
		    <td height="20"></td>
		    <TD class="labelmedium"><cf_tl id="Code"></TD>
			<TD class="labelmedium"><cf_tl id="Description"></TD>
		    <TD class="labelmedium"><cf_tl id="Class"></TD>
		 </TR>
		 
		 <tr bgcolor="FCFDBD">
		   <td width="5%" style="padding-left:3px">
		     <cf_img icon="open" onclick="javascript:editOrgUnit('#SearchResult.OrgUnit#')">	
		   </td>
		   <td width="10%" class="labelmedium">#SearchResult.OrgUnitCode#</b></td>
		   <td width="60%" class="labelmedium">#SearchResult.OrgUnitName#</b></TD>
		   <td width="15%" class="labelmedium">#SearchResult.OrgUnitClass#</b></TD>
		 </TR>
		 
		</table>
	 
	 </cfif>  
 
  </td>
</tr>
     
<tr>
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfif url.source neq "TravelClaim">	  	
	
		<TR>
	    <TD class="labelmedium"><cf_tl id="Hierarchy">:</TD>
	    <TD style="width:75%" class="labelmedium">
		
	    	<cfif URL.ID3 eq "">
				<INPUT type="radio" name="Level" ID="Level" value="Root" checked> <cf_tl id="Root">
			<cfelse>
				<INPUT type="radio" name="Level" id="Level" value="Root"> <cf_tl id="Root">
				<INPUT type="radio" name="Level" id="Level" value="Same"> <cf_tl id="Same level">
				<INPUT type="radio" name="Level" id="Level" value="Child" checked> <cf_tl id="Child">
				<input type="hidden" name="ParentParentOrgUnit" id="ParentParentOrgUnit" value="#SearchResult.ParentOrgUnit#">
			</cfif>
			
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Inherit from template">:</TD>
	    <TD class="labelmedium">
		
		    <input type="radio" name="Inherit" id="Inherit" value="0" checked onClick="javascript: inh('0')"><cf_tl id="No">
	    	<input type="radio" name="Inherit" id="Inherit" value="1" onClick="javascript: inh('1')"><cf_tl id="Yes">
				  			
		</TD>
		</TR>
		
	</cfif>
	
	<cfquery name="Template" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT   M.*
	    FROM     Ref_Mission R, Ref_Mandate M
		WHERE    R.MissionType IN ('TEMPLATE', 'PLANNING', 'OPERATIONAL')
		AND      R.Mission = M.Mission
		ORDER BY MissionName
	</cfquery>
	
	<TR id="inherit1" class="hide">
    <TD class="labelmedium"><cf_tl id="From template">:</TD>
    <TD class="labelmedium">
	
	 <CF_TwoSelectsRelated
		QUERY="Template"
		NAME1="tmission"
		NAME2="tmissionmandate"
		DISPLAY1="Mission"
		DISPLAY2="Description"
		VALUE1="Mission"
		VALUE2="MandateNo"
		SIZE1="1"
		SIZE2="1"
		AUTOSELECTFIRST="Yes"
		FORMNAME="OrganizationEntry">	
					
	</td>
	</TR>	
	
	<tr>	
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD class="labelmedium">
	<table cellspacing="0" cellpadding="0">
	<tr><td class="labelmedium">
	
	<cf_tl id="Please enter a valid OrgUnit code" var="vOrgUnitMessage" class="message">
	
	<cfinput type="Text" 
	         name="orgunitcode" 
			 message="#vOrgUnitMessage#" 
			 required="Yes" 
			 size="20" 
			 onchange="ColdFusion.navigate('OrganizationCheck.cfm?mission=#url.id1#&orgunitcode='+this.value,'check')"
			 maxlength="20" 
			 class="regularxl enterasclass">
	</td>
	<td id="check"></td>
	</tr>
	</table>		 
	</TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Node Class">:</TD>
    <TD class="labelmedium">
	
	  	<select name="orgunitclass" id="orgunitclass" size="1" class="regularxl">
		<cfloop query="Class">
		<option value="#OrgUnitClass#">
    		#OrgUnitClass#
		</option>
		</cfloop>
	    </select>
	</TD>
	</TR>
		
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
	    <TD class="labelmedium">  
	    	<select name="OrganizationCode" id="OrganizationCode" required="Yes" class="regularxl">
			<cfloop query="Area">
			<option value="#OrganizationCode#">#OrganizationDescription#</option>
			</cfloop>
			</select>
		      	 
		</TD>
		
		</TR>	
	
	</cfif>	
	
	<tr id="manual">
	
    <TD class="labelmedium" valign="top" style="padding-top:7px"><cf_tl id="Node">/<cf_tl id="Unit name"><font color="FF0000">*)</font>:</TD>
    <TD class="labelmedium">	
		
			<cf_LanguageInput
			TableCode       = "Organization" 
			Mode            = "Edit"
			Message         = "Enter shortname in" 
			Name            = "OrgUnitName"
			Value           = ""
			Key1Value       = "#OrgUnit#"
			Type            = "Input"
			Required        = "Yes"
			MaxLength       = "80"
			Size            = "65"
			Class           = "regularxl">
						
	</TD>
	</TR>
		
	<tr id="inherit3" class="hide">
		<TD  class="labelmedium"><cf_tl id="Node">:</TD>
		<TD class="labelmedium">
		<table><tr><td>
		<input type="text" name="orgunitname1" id="orgunitname1" value="" class="regularxl" size="50" maxlength="80" readonly>
		</td>
		<td>
		<input type="button" style="height:25px" class="button7" name="search1" id="search1" value=" ... " onClick="selectorgmis('OrganizationEntry','orgunit1','orgunitcode','mission1','orgunitname1','orgunitclass',tmission.value,tmissionmandate.value)"> 
		<input type="hidden" name="mission1" id="mission1" class="disabled" size="20" maxlength="20" readonly>
	   	<input type="hidden" name="orgunit1" id="orgunit1" value="">
		</td></tr></table>
		</TD>
	</tr>
		
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:7px" ><cf_tl id="Name short"><font color="FF0000">*)</font>:</TD>
    <TD class="labelmedium">
	
	<cf_LanguageInput
			TableCode       = "Organization" 
			Mode            = "Edit"
			Message         = "Enter shortname in" 
			Name            = "OrgUnitNameShort"
			Value           = ""
			Key1Value       = "#OrgUnit#"
			Type            = "Input"
			MaxLength       = "30"
			Size            = "30"
			Class           = "regularxl">
			
	</TD>
	</TR>
		
	<cfif url.source eq "base">
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Top Tree">:</TD>
    <TD class="labelmedium">
	
	    <input type="radio" name="TreeUnit" id="TreeUnit" value="0" checked><cf_tl id="No">
    	<input type="radio" name="TreeUnit" id="TreeUnit" value="1"><cf_tl id="Yes">
	  			
	</TD>
	</TR>
	
	<cfelse>
	
		<input type="hidden" name="TreeUnit" id="TreeUnit" value="0">
	
	</cfif>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Associated User account">:</TD>
    <TD class="labelmedium">	
		<table cellspacing="0" cellpadding="0">
		<tr>
			<td>								  
			<input readonly class="regularxl" type="Text" size="20" id="account" name="account" value="" maxlength="20">			
			</td>
			
		    <td width="1"></td>
		    
			<td>
			
				<table cellspacing="0" cellpadding="0">
					<tr>
					<td align="center" style="padding-left:5px;height:24;width:24;padding:1px;border:1px solid Silver;">
					
					   <cfset link = "#SESSION.root#/System/Organization/Application/setUser.cfm?mode=edit">
				   
					   <cf_selectlookup
						    class    = "User"
						    box      = "setuser"
							title    = "Select User"
							link     = "#link#"	
							close    = "Yes"
							icon     = "search.png"		
							iconheight = "19"
							iconwidth  = "19"									
							button   = "Yes"
							des1     = "Account">
							
												
					 </td></tr>
					 </table>
					</td>
					<td  id="setuser">		 
							
					</td>
					</tr>
				</table>	
			
		   </td>
		   
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Source">:</TD>
    <TD class="labelmedium">
	<INPUT type="text" class="regularxl" name="Source" id="Source" maxLength="10" size="10">
	</td>
	</tr>
	
	<tr>
	<td class="labelmedium"><cf_tl id="Source code">:</td>
	<td class="labelmedium">
	<INPUT type="text" class="regularxl" name="SourceCode" id="SourceCode" maxLength="20" size="20">
	</TD>	
	</tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Order">:</TD>
    <TD class="labelmedium">
	<cfinput type="Text" name="TreeOrder" message="Please enter a numeric value" validate="integer" required="No" size="4" maxlength="4" class="regularxl">
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Autonomous">:</TD>
    <TD class="labelmedium">	
	    <input type="radio" name="Autonomous" id="Autonomous" value="0" checked><cf_tl id="No">
    	<input type="radio" name="Autonomous" id="Autonomous" value="1"><cf_tl id="Yes">
	  			
	</TD>
	</TR>	
	      
    <TR>
    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
    <TD class="labelmedium">
	
		<cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False"
			DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
			DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
			Class="regularxl">	
		
		</td>
	</tr>
	
	<tr>	
		<td class="labelmedium"><cf_tl id="Expiration">:</td>		
		<TD class="labelmedium">
	
		<cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default="#Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#"
			DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
			DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
			AllowBlank="True" Class="regularxl">	
		
		</td>
		
	</tr>	
					   
	<TR>
        <td valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Remarks">:</td>
        <TD class="labelmedium">
		
		<cf_LanguageInput
			TableCode       = "Organization" 
			Mode            = "Edit"
			Name            = "Remarks"
			Value           = ""
			Key1Value       = "#OrgUnit#"
			Type            = "Text"
			cols            = "69"
			rows            = "3"
			Class           = "regular">		
		
		</TD>
		
	</TR>
	
   <tr><td colspan="2" class="linedotted"></td></tr>
   
   <tr>
   <td colspan="2" align="center" style="padding-top:4px">
  
  		<cf_tl id="Reset" var="vReset">
		<cf_tl id="Back" var="vBack">
		<cf_tl id="Update" var="vUpdate">
		
  	   <input class="button10g" type="reset"  name="Reset" id="Reset" value="#vReset#">
	   <input type="button" name="cancel" id="cancel" value="#vBack#" class="button10g" onClick="history.back()">
       <input class="button10g" type="submit" name="Update" id="Update" value=" #vUpdate# ">
	   
   </td>
   </tr>
   
   <tr><td height="10"></td></tr>
  
  </table>
</CFFORM>
</cf_divscroll>


</cfoutput>
 