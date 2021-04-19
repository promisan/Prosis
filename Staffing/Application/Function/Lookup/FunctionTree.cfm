
<cfoutput>

<cfparam name="URL.Owner" default="">
<cfparam name="URL.FormName" default="">
<cfparam name="URL.fldfunctionno" default="">
<cfparam name="URL.fldfunctiondescription" default="">

<script language="JavaScript1.2">
			
	function refreshTree() {
		location.reload();
	}
	
	function search(condition)
		    			
		<cfif URL.Mode eq "Lookup">		
		{			
		parent._cf_loadingtexthtml='';			
		parent.ptoken.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListingFlat.cfm?edition=#url.edition#&Mode=#URL.Mode#&Owner=#URL.Owner#&ID1=' + condition + '&FormName=#URL.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#','rightme')
		}		
		<cfelse>		
		{		
		parent._cf_loadingtexthtml='';	
		parent.ptoken.navigate('#session.root#/staffing/application/Function/Lookup/FunctionListingFlat.cfm?edition=#url.edition#&Mode=#URL.Mode#&Owner=#URL.Owner#&ID1=' + condition,'rightme')
		}
		
		</cfif>

</script>

</cfoutput>

<cfset fclass = "">
<cfset owner  = url.owner>

<cfif url.Owner neq "">
	
	<cfquery name="Mission" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM Ref_Mission 
	   WHERE Mission = '#URL.Owner#'
	</cfquery>
	
	<cfif mission.recordcount eq "1">

		<cfset fclass = "'#Mission.FunctionClass#'">
		<cfset owner  = Mission.MissionOwner>
		
	</cfif>
	
</cfif>

<cfquery name="Parameter" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM Ref_ParameterOwner 
   <cfif Owner neq "">
   WHERE Owner = '#Owner#'
   </cfif> 
</cfquery>
						
<cfloop query="Parameter">
			
  <cfif fclass eq ""> 
     <cfset fclass = "'#Parameter.FunctionClassSelect#'">
  <cfelse> 
  	 <cfset fclass = "#fclass#,'#Parameter.FunctionClassSelect#'">
  </cfif>
  
</cfloop>

<cf_screentop html="No" scroll="Yes">

<table height="100%" width="98%" border="0" class="formspacing" align="center">

  <tr class="line" style="height:40px"><td>
  
	  <table>
	  <tr>
	  <td class="labelmedium"><cf_tl id="Search">:</td>
	  <td style="padding-left:4px"><input type="text" onKeyUp="javascript:search(document.getElementById('condition').value)" id="condition" name="condition" size="22" maxlength="20" class="regularxl"></td>	  
	  </tr>
	  </table>
  
  </td></tr>
 
  <tr><td height="100%">
  
    <cfif fclass is "">
		
	['<b>No access</b>',null] 
	
	<cfelse>
	
	<table width="100%" height="100%">
	
	<tr><td style="height:40px">	
	
	<cfquery name="Class" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM Ref_FunctionClass
	   WHERE FunctionClass IN (#preservesinglequotes(fclass)#) 	  
	   ORDER BY ListingOrder 
	</cfquery>
	
	<cfoutput>
	<select name="functionclass" class="regularxl" style="width:100%" 
	   onchange="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/staffing/application/Function/Lookup/setOccupationGroup.cfm?formname=#url.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#&edition=#url.edition#&owner=#url.owner#&occ=#url.occ#&mode=#url.mode#&functionclass='+this.value,'functionclass')">
	<cfloop query="class">
	   <option value="#FunctionClass#">#FunctionClassName#</option>
	</cfloop>
	</select>
	</cfoutput>
			
	</td></tr>		
	
	<tr><td width="100%" height="100%"  valign="top">		 		
		   <cf_securediv id="functionclass" style="height:100%"
		   bind="url:#session.root#/staffing/application/Function/Lookup/setOccupationGroup.cfm?formname=#url.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#&edition=#url.edition#&owner=#url.owner#&occ=#url.occ#&mode=#url.mode#&functionclass=#class.functionclass#">						
	</td></tr>
		
	</table>
	
	</cfif>

</td></tr>

</table>
	