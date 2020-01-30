<head></head>
		
<cfquery name="Category" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ProgramCategory
	ORDER BY Description
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Period
	ORDER BY Period
</cfquery>

<cfparam Name="URL.Period" default="">
<cfparam Name="URL.ParentCode" default="">
<cfparam Name="URL.ParentUnit" default="">
<cfparam Name="URL.EditCode" default="">

<CFset URL.ParentCode  = TRIM("#URL.PARENTCODE#")>	
<CFset URL.EditCode    = TRIM("#URL.EDITCODE#")>	

<cfquery name="ParentOrg" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM #LanPrefix#Organization O
	Where O.OrgUnit = '#URL.ParentUnit#'
</cfquery>

<cfquery name="Parameter"					
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#ParentOrg.Mission#'
</cfquery>

<cfquery name="Mandate"
datasource="AppsOrganization"
maxrows=1
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT *
    FROM    Ref_MissionPeriod M
	WHERE   M.Mission = '#ParentOrg.Mission#'
	AND     M.Period = '#URL.Period#' 
</cfquery>

<cfparam Name="URL.Header"     default="1">

<cfquery name="EditProgram"	 <!--- get default values for entry fields:  if URL.EditCode eq "" values will be empty --->
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Pe.*, 
	       P.ProgramAllotment, 
		   P.ProgramClass, 
		   P.ProgramName, 		  
		   P.ProgramNameShort,
		   <!---
		   P.ProgramDescription, 
		   P.ProgramGoal, 
		   P.ProgramObjective, 
		   --->
		   P.isServiceParent,
		   P.isProjectParent,
	       P.ListingOrder, 
		   Pe.PeriodParentCode, 
		   P.ProgramMemo, 
		   O.OrgUnitName, 
		   O.OrgUnitClass, 
		   P.ProgramScope
    FROM   ProgramPeriod Pe, 
	       Program P,
		   Organization.dbo.#LanPrefix#Organization O
	WHERE  Pe.OrgUnit      = O.OrgUnit
	  AND  Pe.Period       = '#URL.Period#' 
	  AND  Pe.ProgramCode  = P.ProgramCode 
	  AND  Pe.ProgramCode  = '#URL.EditCode#' 
</cfquery>

<cfif URL.EditCode eq "">

	<cfset Update="no">
	<cfset Action="Register">
	<CFSET SubmitAction="ProgramEntrySubmit.cfm?1=1">
	
	<cfquery name="Implementer" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT *
      FROM   #LanPrefix#Organization O
   	  WHERE  O.OrgUnit = '#URL.ParentUnit#' 
    </cfquery>
	
	<cfquery name="Requester" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT *
      FROM #LanPrefix#Organization O
	  WHERE O.OrgUnit = '0'
     </cfquery>

<cfelse>

	<cfset Update="yes">
	<cfset Action="Edit">
	<CFSET SubmitAction="ProgramEntryUpdate.cfm?ProgramCode=#URL.EditCode#&header=#url.header#">
	
	 <cfquery name="Implementer" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT *
      FROM #LanPrefix#Organization O
	  WHERE O.OrgUnit = '#EditProgram.OrgUnitImplement#'
     </cfquery>
	 	 	 
	 <cfif Implementer.recordcount eq "0">
	 	 <cfquery name="Implementer" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      SELECT *
	      FROM #LanPrefix#Organization O
	   	  WHERE O.OrgUnit = '#URL.ParentUnit#'
	     </cfquery>
	 </cfif>
	 
	 <cfquery name="Requester" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT *
      FROM #LanPrefix#Organization O
	  WHERE O.OrgUnit = '#EditProgram.OrgUnitRequest#'
     </cfquery>
	 
</cfif>

<cfoutput>

<script language="JavaScript">
	
function admblank() {
	document.ProgramEntry.orgunit1.value = ""
	document.ProgramEntry.mission1.value = ""
	document.ProgramEntry.orgunitname1.value = ""
	document.ProgramEntry.orgunitclass1.value = ""
}	

function reqblank() {
	document.ProgramEntry.orgunit0.value = ""
	document.ProgramEntry.mission0.value = ""
	document.ProgramEntry.orgunitname0.value = ""
	document.ProgramEntry.orgunitclass0.value = ""
}	

function scope(tpe)	{
		
	itm1 = document.getElementById("unit");
	itm1.className = "hide";
	itm2 = document.getElementById("par");
	itm2.className = "hide";		
	if (tpe == "unit") {
	  itm1.className = "regular";
	} 	
	if (tpe == "parent") {
	  itm2.className = "regular";
	}  		
}

function validate(act) {
	document.ProgramEntry.onsubmit() 
	if( _CF_error_messages.length == 0 ) {  
	    _cf_loadingtexthtml='';	    
		Prosis.busy('yes')
		ptoken.navigate('#SubmitAction#&action='+act,'target','','','POST','ProgramEntry')
	 }   
}	

function setorgunit(fld,org) {	    
	    ptoken.navigate('setOrgUnit.cfm?field='+fld+'&orgunit='+org,'process')	
	}
	

function setprogram(val,scope,org) {
	   ptoken.navigate('setProgram.cfm?programid='+val+'&orgunit='+org,'process')	
	}

</script>

</cfoutput>

<cf_dialogREMProgram>
<cf_dialogOrganization>

<cfif url.header eq "1">
	<cfset html = "Yes">
<cfelse>
	<cfset html = "No">	
</cfif>	

<cf_screentop layout="webapp" banner="gray" bannerheight="55" jquery="Yes"
   height="100%" label="#Action# #Parameter.TextLevel0#" html="#html#" band="no" scroll="yes">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

  <tr class="hide"><td id="target"></td></tr>	
  
  <tr class="hide"><td id="process"></td></tr>	
    
  <tr><td>
         
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <tr><td height="3"></td></tr>
     
  <tr> <td width="100%" colspan="2" align="center">
  
  <cfform action="#SubmitAction#" method="POST" name="ProgramEntry" onsubmit="return false">
 
	<cfoutput>
	
	<cfparam name="URL.Refresh" default="">
	<INPUT type="hidden" name="Mission"       id="Mission"       value="#URL.Mission#">
	<INPUT type="hidden" name="ParentCode"    id="ParentCode"    value="#URL.ParentCode#">
	<INPUT type="hidden" name="ProgramId"     id="ProgramId"     value="#URL.Id#">
	<INPUT type="hidden" name="Period"        id="Period"        value="#URL.Period#">
	<INPUT type="hidden" name="ProgramLayout" id="ProgramLayout" value="Program">
	<INPUT type="hidden" name="ProgramClass"  id="ProgramClass"  value="Program">
	<INPUT type="hidden" name="Refresh"       id="Refresh"       value="#URL.Refresh#">	
	</cfoutput>
	
	<cf_menuscript>
	
	<cf_tl id="Descriptive" var="1">		
		
    <table width="99%" align="center" border="0" class="formpadding">
	
	<tr><td>
	
	   <!--- top menu --->
				
		<table width="100%" border="0" align="center" class="formspacing" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "48">
			<cfset wd = "48">
								
			<tr>		
			
			<cfset itm = 1>		
			<cf_tl id="Name and Descriptive" var="vName">
			<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Program/Benefit.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 									
					class      = "highlight1"
					name       = "#vName#">
					
			<cfif Parameter.EnableObjective eq "1">
			
				<cfset itm = itm+1>
				<cf_tl id="Goal and Objective" var="vGoal">
				<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Program/Goal.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 														
					name       = "#vGoal#">	
					
			</cfif>						
					
			<cfset itm = itm+1>
			<cf_tl id="Settings" var="vSettings">										
										
			<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Program/Indicator.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 				
					name       = "#vSettings#">			
			
			<td width="10%"></td>																 		
																 		
			</tr>
		</table>
		
		</td>
		
	</tr>
	
	<tr><td class="linedotted"></td></tr>	
	
	<cfoutput>
	<input type="Hidden" name="ProgramCode" id="ProgramCode" value="#EditProgram.ProgramCode#">
    </cfoutput>
	
	<!--- --------------------- --->
	<!--- descriptive container --->
	<!--- --------------------- --->
	
	<cf_menucontainer item="1" class="regular">
		
		<table width="96%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
		
	    <!--- Field: Program Name --->
		<TR><TD height="10"></TD></TR>
		
	    <TR>
	    <TD valign="top" class="labelmedium" style="padding-top:4px"><cf_tl id="Name">:</TD>
	    <TD>
		
		<cf_LanguageInput
				TableCode       = "Program" 
				Mode            = "Edit"
				Name            = "ProgramName"
				Value           = "#EditProgram.ProgramName#"
				Key1Value       = "#EditProgram.ProgramCode#"
				Type            = "Input"
				Required        = "No"
				Message         = "Please enter a Name"
				size            = "78"
				maxlength       = "400"
				Class           = "regularxl">
		
		</TD>
		</TR>	
				
		<TR><TD height="10"></TD></TR>
		
	    <!--- Field: Program Goal --->
	
		<TR>
	        <TD valign="top" class="labelmedium" style="padding-top:4px"><cf_tl id="Description">:</td>
			<td>
			
			<cf_LanguageInput
				TableCode       = "ProgramPeriod" 
				Mode            = "Edit"
				Name            = "PeriodDescription"
				Value           = "#EditProgram.PeriodDescription#"
				Key1Value       = "#EditProgram.ProgramCode#"
				Key2Value       = "#EditProgram.Period#"
				Type            = "Text"
				Required        = "No"
				Message         = ""
				Maxlength       = "2000"				
				cols            = "62"
				rows            = "6"
				Class           = "regular">
				
			</td>	
			
		</TR>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" align="center" height="30">
	
			<cfquery name="Check" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM  ProgramPeriod
			 WHERE PeriodParentCode = '#EditProgram.ProgramCode#'		
		    </cfquery>
			
			<cfoutput>			
					
					<cfif check.recordcount eq "0">
					<cf_tl id="Delete" var="vDelete">
					<input class="button10g" type="button" onclick="validate('delete')" style="height:26;width:120" name="Delete"  value="#vDelete#">
					</cfif>		
					<cf_tl id="Save" var="vSave">						
					<input class="button10g" type="button" onclick="validate('add')" style="height:26;width:120" name="Save" value="#vSave#">
				</cfoutput>				   
			
			</td></tr>			   
		
		</table>
		
	</cf_menucontainer>
	
	<!--- --------------------- --->
	<!--- -----goal container-- --->
	<!--- --------------------- --->
	
	<cfif Parameter.EnableObjective eq "1">
	
	<cf_menucontainer item="2" class="hide">	
	 	
	    <!--- Field: Program Goal --->
		
		<table width="96%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
			
			<TR>
		        <TD width="10%" class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Goal">:</td>
				
		        <TD>
							
				<cf_LanguageInput
					TableCode       = "ProgramPeriod" 
					Mode            = "Edit"
					Name            = "PeriodGoal"
					Value           = "#EditProgram.PeriodGoal#"
					Key1Value       = "#EditProgram.ProgramCode#"
					Key2Value       = "#EditProgram.Period#"
					Type            = "Text"
					Required        = "No"
					Message         = ""
					cols            = "59"
					rows            = "4"
					Maxlength       = "50000"
					Class           = "regular">
				
				</td>
				
			</TR>
			
			<TR><TD height="10"></TD></TR>
			
		    <!--- Field: Program Objective --->
		
			<TR>
		        <TD valign="top" class="labelmedium" style="padding-top:4px"><cf_tl id="Objective">:</td>
				
				<td>
				
				<cf_LanguageInput
					TableCode       = "ProgramPeriod" 
					Mode            = "Edit"
					Name            = "PeriodObjective"
					Value           = "#EditProgram.PeriodObjective#"
					Key1Value       = "#EditProgram.ProgramCode#"
					Key2Value       = "#EditProgram.Period#"
					Type            = "Text"
					Required        = "No"
					Message         = ""
					cols            = "69"
					rows            = "4"
					Maxlength       = "2000"
					Class           = "regular">
				
				</td>
				
			</TR>
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr><td colspan="2" align="center" height="30">
	
				<cfquery name="Check" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT * 
				 FROM  ProgramPeriod
				 WHERE PeriodParentCode = '#EditProgram.ProgramCode#'		
			    </cfquery>
				
				<cfoutput>			
					
					<cfif check.recordcount eq "0">
					<cf_tl id="Delete" var="vDelete">
					<input class="button10g" type="button" onclick="validate('delete')" style="height:26;width:120" name="Delete"  value="#vDelete#">
					</cfif>		
					<cf_tl id="Save" var="vSave">						
					<input class="button10g" type="button" onclick="validate('add')" style="height:26;width:120" name="Save" value="#vSave#">
				</cfoutput>				   
			
			</td></tr>			   
			
		</table>	
		
		</cf_menucontainer>
		
	<cfelse>
		
			<!--- Field: Program Objective --->
			<input type="hidden" name="ProgramGoal" id="ProgramGoal" value="">
			<input type="hidden" name="ProgramObjective" id="ProgramObjective" value="">
			
	</cfif>
			
	<!--- --------------------- --->
	<!--- settings container--- --->
	<!--- --------------------- --->
	
	<cf_menucontainer item="3" class="hide">		
		<cfinclude template="ProgramEntrySetting.cfm">	
	</cf_menucontainer>
	
</td></tr>
		   		      
</CFFORM>

</table>
  
</td></tr>	

</table>

<cf_screenbottom  layout="webapp">
