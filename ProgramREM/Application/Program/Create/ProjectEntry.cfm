

<cf_calendarscript>
<cf_textareascript>

<script>

	function setorgunit(fld,org) {	    
	   ptoken.navigate('setOrgUnit.cfm?field='+fld+'&orgunit='+org,'process')	
	}
	
	function setprogram(val,scope,org) {
	   ptoken.navigate('setProgram.cfm?programid='+val+'&orgunit='+org,'process')	
	}
		
	function applyunit(org) {    
	   ptoken.navigate('setUnit.cfm?orgunit='+org,'process')
	}
</script>

<CFset URL.ParentCode= TRIM("#URL.PARENTCODE#")>
<CFset URL.EditCode  = TRIM("#URL.EDITCODE#")>


<cfquery name="Category"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ProgramCategory
	ORDER BY Description 
</cfquery>

<cfquery name="Period" datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Period
	ORDER BY Period
</cfquery>

<cfparam Name="URL.Header"     default="1">
<cfparam Name="URL.Period"     default="">
<cfparam Name="URL.ParentCode" default="">
<cfparam Name="URL.ParentUnit" default="">
<cfparam Name="URL.EditCode"   default="">

<cfif url.editcode neq "">
	
	<cfinvoke component="Service.Access"
		Method="Program"
		ProgramCode="#URL.EditCode#"
		Period="#URL.Period#"	
		Role="'ProgramOfficer'"	
		ReturnVariable="Access">
		
		<cfif Access eq "NONE">
		
			<cf_message message="You have no access to amend the project description and settings" return="no">
			<cfabort>
		
		</cfif>

</cfif>

<cfquery name="ParentOrg"
datasource="AppsOrganization"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT *
    FROM   #CLIENT.LanPrefix#Organization O
	Where  O.OrgUnit = '#URL.ParentUnit#'
</cfquery>

<cfquery name="Parameter"					
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#ParentOrg.Mission#'
</cfquery>

<cfquery name="Program"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT   P.ProgramCode, 
	         P.ProgramName, 
			 P.ProgramScope
	FROM     ProgramPeriod Pe INNER JOIN
	         Organization.dbo.Organization O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
	         #CLIENT.LanPrefix#Program P ON Pe.ProgramCode = P.ProgramCode AND Pe.ProgramCode = P.ProgramCode
	WHERE    Pe.Period      = '#URL.Period#'
	AND      P.ProgramClass = 'Program'
	AND      O.HierarchyRootUnit = '#ParentOrg.HierarchyRootUnit#'
	AND      O.Mission      = '#ParentOrg.Mission#'
	AND      O.MandateNo    = '#ParentOrg.MandateNo#'
</cfquery>

<cfquery name="EditProgram"					
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT O.Mission, 
		   O.MandateNo, 
		   O.HierarchyRootUnit, 
		   O.OrgUnitName, 
		   O.OrgUnitClass,
		   Pe.*, 
	       P.ProgramWeight, 
	       P.ProgramScope, 
		   P.ProgramClass, 
		   P.ProgramDate,		
		   P.ProgramAllotment,
		   P.EnforceAllotmentRequest,
		   P.ProgramNameShort,
		   P.ProgramName, 
		   P.ListingOrder, 
		   P.ProgramMemo, 
		   Pe.PeriodDescription as ProgramDescription, 
		   Pe.PeriodGoal        as ProgramGoal, 
		   Pe.PeriodObjective   as ProgramObjective
	       
		  
    FROM   Program P, 
	       ProgramPeriod Pe, 
		   Organization.dbo.#CLIENT.LanPrefix#organization O
	WHERE  Pe.OrgUnit = O.OrgUnit
	AND    Pe.Period       = '#URL.Period#'
	AND    Pe.ProgramCode  = '#URL.EditCode#'
	AND    P.ProgramCode   = Pe.ProgramCode
</cfquery>

<cfquery name="isPriorPeriod"					
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ProgramPeriod
	WHERE    ProgramCode   = '#URL.EditCode#' 
	AND      Period       != '#URL.Period#' 
	AND      RecordStatus != '9'	
</cfquery>

<cfquery name="isCleared"					
  datasource="AppsProgram"
  username="#SESSION.login#"
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     ProgramPeriodReview
	WHERE    ProgramCode = '#URL.EditCode#' 
	AND      ActionStatus = '3'
</cfquery>

<cfquery name="isParent" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     SELECT * 
	 FROM  ProgramPeriod
	 WHERE PeriodParentCode = '#EditProgram.ProgramCode#'			
	 AND   Period           = '#URL.Period#'
</cfquery>
		
	<cfquery name="Position" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT TOP 1 * 
	 FROM  PositionParentFunding
	 WHERE ProgramCode = '#URL.editcode#'		
    </cfquery>
	
	<cfquery name="Purchase" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT TOP 1 * 
		 FROM  RequisitionLineFunding
		 WHERE ProgramCode = '#URL.editcode#'		
    </cfquery>
	
	<cfquery name="Ledger" 
     datasource="AppsLedger" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT TOP 1 * 
		 FROM  TransactionLine
		 WHERE ProgramCode = '#URL.editcode#'		
    </cfquery>		

<cfif URL.EditCode neq "">

	<cfset ParentCode  = "#EditProgram.PeriodParentCode#">
	<cfset Org         = "#EditProgram.OrgUnit#">
	<cfset OrgUnitName = "#EditProgram.OrgUnitName#">
	<cfset Mission     = "#EditProgram.Mission#">
	<cfset MandateNo   = "#EditProgram.MandateNo#">
	<cfset HierarchyRootUnit = "#EditProgram.HierarchyRootUnit#">
	
<cfelse>

	<cfset ParentCode  = "#URL.ParentCode#">
	<cfset Org         = "#ParentOrg.OrgUnit#">
	<cfset OrgUnitName = "#ParentOrg.OrgUnitName#">
	<cfset Mission     = "#ParentOrg.Mission#">
	<cfset MandateNo   = "#ParentOrg.MandateNo#">
	<cfset HierarchyRootUnit = "#ParentOrg.HierarchyRootUnit#">
</cfif>


<!--- Template adds new Component or edits existing one.  If URL.EditCode parameter is empty, add new, else edit program
	specified in URL.EditCode  --->

<cfajaximport tags="cfdiv,cfform,cfwindow">
<cf_dialogREMProgram>
<cf_dialogOrganization>
<cfinclude template="../Category/CategoryScript.cfm">

<cfquery name="OrgParent"
datasource="AppsOrganization"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT OrgUnit
    FROM   Organization
	WHERE  Mission     = '#Mission#'
	AND    MandateNo   = '#MandateNo#'
	AND    OrgUnitCode = '#HierarchyRootUnit#'
</cfquery>

<cfquery name="Parent"					<!--- get default values for entry fields:  if URL.EditCode eq "" values will be empty --->
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT *
    FROM #CLIENT.LanPrefix#Program P
	WHERE P.ProgramCode = '#ParentCode#'
</cfquery>

<cfif EditProgram.ProgramName neq "">

	<cfset label = EditProgram.ProgramName>

<cfelseif Parent.ProgramNameShort neq "">

	<cfset label = Parent.ProgramNameShort>
	
<cfelse>

	<cf_tl id="Record Project request" var="lbl">
	<cfset label = "#lbl#">
		
</cfif>

<cfif url.header eq "1">
	<cf_screentop height="100%" banner="blue" bannerforce="Yes" label="#label#" SystemModule="Program" FunctionClass="Window" FunctionName="Project Entry" html="yes" jquery="Yes" layout="webapp" scroll="yes">
<cfelse>
	<cf_screentop height="100%" label="#label#" SystemModule="Program" FunctionClass="Window" FunctionName="Project Entry" html="no" jquery="Yes" layout="webapp" scroll="yes" banner="gray">
</cfif>

<cfif URL.EditCode eq "">

	<cfset Update="no">
	<cfset Action="Register">
	<CFSET SubmitAction="ProgramEntrySubmit.cfm?1=1">

	<cfquery name="Implementer"
     datasource="AppsOrganization"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">
	      SELECT  *
	      FROM    #CLIENT.LanPrefix#Organization O
	   	  WHERE   O.OrgUnit = '#URL.ParentUnit#'
    </cfquery>
	
	<cfquery name="Requester" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	      SELECT *
	      FROM   #LanPrefix#Organization O
		  WHERE  O.OrgUnit = '0'
     </cfquery>

<cfelse>

	<cfset Update="yes">
	<cfset Action="Edit">	
	<CFSET SubmitAction="ProgramEntryUpdate.cfm?ProgramCode=#URL.EditCode#&period=#url.period#&header=#url.header#">

	<cfquery name="Implementer"
     datasource="AppsOrganization"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">
      SELECT *
      FROM   #CLIENT.LanPrefix#Organization O
	  WHERE  O.OrgUnit = '#EditProgram.OrgUnitImplement#'
     </cfquery>

	 <cfif Implementer.recordcount eq "0">

		 <cfquery name="Implementer"
	     datasource="AppsOrganization"
	     username="#SESSION.login#"
	     password="#SESSION.dbpw#">
	    	  SELECT *
		      FROM   #CLIENT.LanPrefix#Organization O
		   	  WHERE  O.OrgUnit = '#URL.ParentUnit#'
	     </cfquery>

	 </cfif>
	 
		 <cfquery name="Requester" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      	  SELECT *
		      FROM   #LanPrefix#Organization O
			  WHERE  O.OrgUnit = '#EditProgram.OrgUnitRequest#'
	     </cfquery>

</cfif>

<cfoutput>
<script language="JavaScript">

function savebox(val) { 
	document.getElementById('savebox').className = val
}

function admblank() {
	document.getElementById('orgunit1').value = ""
	document.getElementById('mission1').value = ""
	document.getElementById('orgunitname1').value = ""
	document.getElementById('orgunitclass1').value = ""
}

function reqblank() {
	document.getElementById('orgunit0').value        = ""
	document.getElementById('orgunit0mission').value = ""
	document.getElementById('orgunit0name').value    = ""	
}	

function partnerblank(itm) {
	document.getElementById("orgunitpartner"+itm).value           = ""
	document.getElementById("orgunitpartner"+itm+"mission").value = ""
	document.getElementById("orgunitpartner"+itm+"name").value    = ""
}

function ask() {
	if (confirm("Do you want to purge this project ?")) { validate('delete') }
		return false	
	}	
				  
function expand(itm){
		 
	 se  = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 if (se.className == "regular") {
	 	 se.className = "hide";
		 icM.className = "hide";
		 icE.className = "regular";	
	 } else {
		 se.className = "regular";
		 icM.className = "regular";
		 icE.className = "hide";			
	 }
}      
  
function validate(md) {
	document.programform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {  
	    Prosis.busy('yes')    
		ptoken.navigate('#SubmitAction#&action='+md,'process','','','POST','programform')
	 }   
}		

</script>

</cfoutput>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr class="xxxxhide"><td id="process"></td></tr>	

<cf_menuscript>

<tr><td height="100%" style="padding-left:5px;padding-right:5px">

<table height="100%" width="100%" cellspacing="0" cellpadding="0">
  
  <cfif url.editcode neq "" and Access neq "READ">	
   
  <tr>	

    <td align="center" height="30" style="padding-left:20px">
	
	 <!--- top menu --->
				
		<table border="0" align="center" class="formpadding">		  		
						
			<cfset ht = "48">
			<cfset wd = "48">
								
			<tr>		
					
			<cfset itm = 1>		
			<cf_tl id="Title and Summary" var="vName">		
			<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Program/Project.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 		
					script     = "savebox('regular')"							
					class      = "highlight1"
					name       = "#vName#">		
			
			<!--- ------------------------------------------- --->		
			<!--- hide if this is not recorded as program yet --->	
			
			<cfset itm = itm+1>										
			<cf_tl id="Other settings" var="1">	
			<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Program/Setting.png" 
					iconwidth  = "#wd#" 					
					iconheight = "#ht#" 	
					script     = "savebox('regular')"		
					name       = "#lt_text#">	
					
			<cfif url.header eq "1">		
												
				<cfset itm = itm+1>										
				<cf_tl id="Expected Results" var="1">	
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Program/Result.png" 					
							iconwidth  = "#wd#" 					
							iconheight = "#ht#" 						
							targetitem = "3"	
							script     = "savebox('regular')"				
							name       = "#lt_text#">	
													
				<cfif url.editcode neq "">		
							
				<cfset itm = itm+1>										
					<cf_tl id="Metrics" var="1">		
					<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/Cash.png" 
							iconwidth  = "#wd#" 					
							iconheight = "#ht#" 	
							targetitem = "4"				
							name       = "#lt_text#"
							script     = "savebox('regular')">										
											
					<cfset itm = itm+1>										
					<cf_tl id="Review Cycles" var="1">	
					<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Program/Rationale.png" 					
							iconwidth  = "#wd#" 					
							iconheight = "#ht#" 	
							targetitem = "5"							
							script     = "savebox('hide')"	
							source     = "ProjectEntryReviewCycle.cfm?Mission=#url.mission#&ProgramCode=#url.editcode#&Period=#url.period#"	
							name       = "#lt_text#">										
										
				</cfif>		
				
			</cfif>	
			
			<td style="width:10%"></td>
																			 		
			</tr>
		</table>
		
	</td>
	
</tr>

</cfif>

<!--- global --->
		   
<cfquery name="ParentList"
    datasource="AppsProgram"
    username="#SESSION.login#"
  	password="#SESSION.dbpw#">
	   SELECT   P.ProgramCode, Pe.Reference, Pe.PeriodHierarchy
	   FROM     Program P, ProgramPeriod Pe
	   WHERE    P.ProgramClass = 'Program'
	   AND      P.Mission      = '#ParentOrg.Mission#' 
	   AND      P.ProgramCode  = Pe.ProgramCode
	   AND      Pe.Period      = '#url.period#' 
	   AND      P.ProgramScope IN ('Global','Parent')
	   AND      Pe.Reference is not NULL AND Pe.Reference > ''
	   ORDER BY ListingOrder,PeriodHierarchy
</cfquery>	

<cfset mode = "view">

<cfif ParentList.recordcount eq "0">
	
	<tr><td height="5"></td></tr>
		
	<tr><td height="10">
	
		<cfif editProgram.PeriodParentCode eq "">
		      <cf_ShowProgramHierarchy parentcode="#url.ParentCode#" period="#url.period#">
		<cfelse>
			  <cf_ShowProgramHierarchy parentcode="#EditProgram.PeriodParentCode#" period="#url.period#">
		</cfif>	
		
		</td>
	</tr>	

</cfif>
			
	<script>
		
		 function togglebox(val) {
		 
			 uno = document.getElementsByName("unitmove")
			 aco = document.getElementsByName("actionmove") 
			 
			 if (val == "unit") {
			   unv = "regular"
			   acv = "hide"
			 } else {
			   unv = "hide"
			   acv = "regular"		 
			 }
			 
			 cnt = 0
			 while (uno[cnt]) {
			    uno[cnt].className = unv
				cnt++
			 }
			 cnt = 0
			 while (aco[cnt]) {
			    aco[cnt].className = acv
				cnt++
			 }
		 }
		 
	</script>
	
	<tr><td style="padding-top:7px;padding-left:30px;padding-right:30px">	
	
	    <cf_divscroll>
		
		<cfform method="POST" name="programform" onsubmit="return false">
		
			<table width="100%" height="100%">	
										
			<cfoutput>
			    <INPUT type="hidden" name="Mission"       id="Mission"       value="#URL.Mission#">
				<INPUT type="hidden" name="Period"        id="Period"        value="#URL.Period#">
				<INPUT type="hidden" name="ProgramId"     id="ProgramId"     value="#URL.Id#">
				<INPUT type="hidden" name="ProgramLayout" id="ProgramLayout" value="Component">
				<INPUT type="hidden" name="ProgramClass"  id="ProgramClass"  value="Project">
				<INPUT type="hidden" name="Refresh"       id="Refresh"       value="1">		
				<INPUT type="hidden" name="ProgramScope"  id="ProgramScope"  value="Unit">	
				<!---	
				<input type="Hidden" name="parentcode"    id="parentcode"    value="#ParentCode#">	
				--->
			</cfoutput>
			
			<cfif url.editcode neq "">	
					
				<cf_menucontainer item="1" class="regular">
								
					<cf_divscroll style="height:99%">				
						<cfinclude template="ProjectEntryTitle.cfm">										    			
					</cf_divscroll>
					
				</cf_menucontainer>
				
				<cfquery name="Mandate"
				         datasource="AppsOrganization"
				         maxrows=1
				         username="#SESSION.login#"
				         password="#SESSION.dbpw#">
					      SELECT *
					      FROM Ref_Mandate M, Program.dbo.Ref_Period P
						  WHERE   M.Mission = '#ParentOrg.Mission#'
						  AND     P.Period = '#URL.Period#'
						  AND     M.DateExpiration >= P.DateEffective
						  ORDER BY MandateNo DESC
			    </cfquery>		
					
				<!--- -------- --->
				<!--- settings --->
				<!--- -------- --->
							
				<cf_menucontainer item="2" class="hide">						
					<cfinclude template="ProjectEntrySetting.cfm">			
				</cf_menucontainer>
				
				<cf_menucontainer item="3" class="hide">	
				
				    <cf_divscroll style="height:100%">	
				    <cfset programclass = "project">
					<cfset url.programcode = url.editcode>
					<cfset mode         = "submit">				
					<cfinclude template="../Category/CategoryEntryDetail.cfm">			
					</cf_divscroll>
					
				</cf_menucontainer>			
				
				<cf_menucontainer item="4" class="hide">	
				    <cfset url.mode = "edit">
					<cfinclude template="ProjectEntryFinancial.cfm">		
				</cf_menucontainer>	
				
				<cf_menucontainer item="5" class="hide"/>	
				
			   <cfelse>
			   
			   <tr><td>
				   <cfinclude template="ProjectEntryTitle.cfm">	
			   </td></tr>
			  
			   <tr><td style="padding-right:20px">
				    <cfset programclass = "project">				
					<cfset url.programcode = url.editcode>
					<cfset mode         = "submit">		
										
					<cfinclude template="../Category/CategoryEntryDetail.cfm">				   
			   </td></tr>
			   
			   <tr><td>
			   	   <cfinclude template="ProjectEntrySetting.cfm">		
			   </td></tr>		   
			   
			   </cfif>	
			
			</table>
			
		</td></tr>
		
		<cfif access neq "READ">
		
		<tr><td colspan="6" height="1" class="linedotted"></td></tr>
		
		<tr><td id="savebox" colspan="6" align="center" style="height:67px">
							
			<cfoutput>	   
												
		     <cfif isParent.recordcount  eq "0" 
			   and Position.recordcount  eq "0"
			   and isCleared.recordcount eq "0"
			   and Purchase.recordcount  eq "0"
			   and Ledger.recordcount    eq "0">
			   			
			   <cf_tl id="Delete" var="vDelete">
		       <input class="button10g" style="height:28;width:180" type="submit" name="Delete" onclick="return ask()" value="#vDelete#">
				 
		    </cfif>
		
			<cf_tl id="Save" var="1">
		    <input class="button10g" style="height:28;width:180" type="button" name="Submit" value="#lt_text#" onclick="updateTextArea();validate('add')">
			
			</cfoutput>
						
			</td>
		</tr>
		
		</cfif>
	
	</table>
	
	</CFFORM>
	
	</cf_divscroll>	
	
</td>
</tr>

</table>

<cf_screenbottom layout="webapp">

