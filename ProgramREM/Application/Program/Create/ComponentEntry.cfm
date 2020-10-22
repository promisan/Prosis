
<!--- Template adds new Component or edits existing one.  If URL.EditCode parameter is empty, add new, else edit program
	specified in URL.EditCode  --->
		
<CFset URL.ParentCode= TRIM("#URL.PARENTCODE#")>	
<CFset URL.EditCode  = TRIM("#URL.EDITCODE#")>	

<cfparam Name="URL.Header"     default="1">
<cfparam Name="URL.Period"     default="">
<cfparam Name="URL.ParentCode" default="">

<cfparam Name="URL.ParentUnit" default="">
<cfparam Name="URL.EditCode"   default="">

<cf_textareascript>

<cfquery name="ParentOrg" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   #LanPrefix#Organization O
	WHERE  O.OrgUnit = '#URL.ParentUnit#' 
</cfquery>

<cfquery name="Mandate"
datasource="AppsOrganization"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT *
    FROM    Ref_MissionPeriod M
	WHERE   M.Mission = '#ParentOrg.Mission#'
	AND     M.Period = '#URL.Period#' 
</cfquery>

<cfquery name="Parameter"					
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#ParentOrg.Mission#'
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_Period
	ORDER BY Period
</cfquery>

<cfquery name="qClass" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	PC.*
	FROM   	Program P
			INNER JOIN Ref_ProgramClass PC
				ON P.ProgramClass = PC.Code
	WHERE  	P.ProgramCode = '#URL.EditCode#'
</cfquery>

<cfset vPeriodFieldsMode = "Text">
<cfif qClass.EntryMode eq "Regular">
	<cfset vPeriodFieldsMode = "Text">
</cfif>
<cfif qClass.EntryMode eq "Editor">
	<cfset vPeriodFieldsMode = "HTML">
</cfif>

<cfquery name="EditProgram"					<!--- get default values for entry fields:  if URL.EditCode eq "" values will be empty --->
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT Pe.*, 
		       P.ProgramClass, 
			   P.ServiceClass,
			   P.ProgramStatus, 
			   P.ProgramScope, 
			   P.ProgramName, 
			   Pe.PeriodDescription,			  
		       P.ListingOrder, 
			   P.ProgramAllotment,
			   P.ProgramAllocation,
			   P.ProgramNameShort,
			   P.EnforceAllotmentRequest,			  
			   P.ProgramMemo, 
			   O.Mission, 
			   O.MandateNo, 
			   O.HierarchyRootUnit, 
			   O.OrgUnitName, 
			   O.OrgUnitClass
	    FROM   Program P, 
		       ProgramPeriod Pe, 
			   Organization.dbo.#CLIENT.LanPrefix#organization O
		WHERE  Pe.OrgUnit     = O.OrgUnit
		AND    Pe.Period       = '#URL.Period#' 
		AND    Pe.ProgramCode  = '#URL.EditCode#' 
		AND    P.ProgramCode   = Pe.ProgramCode 
</cfquery>

<cfif EditProgram.recordcount neq 0>

    <!--- new entry --->
	<cfset ParentCode        = "#EditProgram.PeriodParentCode#">
	<cfset OrgUnit           = "#EditProgram.OrgUnit#">
	<cfset OrgUnitName       = "#EditProgram.OrgUnitName#">
	<cfset Mission           = "#EditProgram.Mission#">
	<cfset MandateNo         = "#EditProgram.MandateNo#">
	<cfset HierarchyRootUnit = "#EditProgram.HierarchyRootUnit#">
	
<cfelse>	

    <!--- edit entry --->
	<cfset ParentCode        = "#URL.ParentCode#">
	<cfset OrgUnit           = "#ParentOrg.OrgUnit#">
	<cfset OrgUnitName       = "#ParentOrg.OrgUnitName#">
	<cfset Mission           = "#ParentOrg.Mission#">
	<cfset MandateNo         = "#ParentOrg.MandateNo#">
	<cfset HierarchyRootUnit = "#ParentOrg.HierarchyRootUnit#">
	
</cfif>

<cfquery name="OrgParent"					
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit
    FROM Organization
	WHERE Mission     = '#Mission#'
	AND   MandateNo   = '#MandateNo#'
	AND   OrgUnitCode = '#HierarchyRootUnit#'
</cfquery>

<cfquery name="Parent"					
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.ProgramCode, ProgramScope, ProgramName, ProgramClass, PeriodParentCode, PeriodHierarchy
    FROM   ProgramPeriod Pe, Program P
	WHERE  Pe.ProgramCode = P.ProgramCode
	AND    Pe.ProgramCode = '#ParentCode#'
	AND    Pe.Period      = '#URL.Period#'
</cfquery>

<cf_dialogREMProgram>
<cf_dialogOrganization>

<cfif EditProgram.recordcount eq 0>

	<!--- insert --->

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
    	  FROM   #LanPrefix#Organization O
		  WHERE  O.OrgUnit = '0'
     </cfquery>
	
<cfelse>

	<cfset Update = "yes">
	<cfset Action = "Edit">
	<CFSET SubmitAction="ProgramEntryUpdate.cfm?ProgramCode=#URL.EditCode#&period=#url.period#&header=#url.header#">
	
	<cfquery name="Implementer" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	      SELECT 	*
	      FROM   	#LanPrefix#Organization O
		  WHERE  	O.OrgUnit = '#EditProgram.OrgUnitImplement#'
     </cfquery>
	 
	 <cfif Implementer.recordcount eq "0">
	 
		 <cfquery name="Implementer" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		      SELECT 	*
		      FROM   	#LanPrefix#Organization O
		   	  WHERE  	O.OrgUnit = '#URL.ParentUnit#'
	     </cfquery>
	 	 
	 </cfif>	 
	  
	 <cfquery name="Requester" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	      SELECT 	*
	      FROM   	#LanPrefix#Organization O
		  WHERE  	O.OrgUnit = '#EditProgram.OrgUnitRequest#'
     </cfquery>
	
</cfif>

<cfinvoke component="Service.Access"
		Method="Program"
		ProgramCode="#URL.EditCode#"
		Period="#URL.Period#"	
		Role="'ProgramOfficer'"	
		ReturnVariable="Access">
		
		
<cfoutput>

<script language="JavaScript">
		
	function admblank() {
			document.program.orgunit1.value      = ""
			document.program.mission1.value      = ""
			document.program.orgunitname1.value  = ""
			document.program.orgunitclass1.value = ""
	}	
	
	function reqblank() {
			document.program.orgunit0.value      = ""
			document.program.mission0.value      = ""
			document.program.orgunitname0.value  = ""
			document.program.orgunitclass0.value = ""
	}	
	
	function scope(tpe) {		
			itm2 = document.getElementById("par");
			itm2.className = "hide";		
			if (tpe == "parent") {
			  itm2.className = "regular";
			}  		
	}
	
	function ask() {
		if (confirm("Do you want to remove this component ?")) { validate('delete') }
			return false	
	}	
		
	function validate(md) {
		document.componentform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {     
		    Prosis.busy('yes') 
			ptoken.navigate('#SubmitAction#&action='+md,'process','','','POST','componentform')
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

<cfif Parent.ProgramClass eq "Project">

	<cfset text = "Sub-Project">

<cfelse>

	<cfset lev = 0>
	<cfset pos = 0>
	<cfloop index="i" from="1" to="3" step="1">
	    <cfset pos = Find(".", "#Parent.PeriodHierarchy#" , "#pos#")>
		<cfif pos neq "0">
		 	<cfset lev = lev + 1>
			<cfset pos = pos + 1>
		<cfelse> <cfset pos = "99">	
		</cfif>
	</cfloop>
	
	<cfset Text = "Program component">
	
	<cfswitch expression="#lev#">
	
		<cfcase value="0">
		   <cfset text = "#Parameter.TextLevel1#">		 
		</cfcase>
		
		<cfcase value="1">
		   <cfset text = "#Parameter.TextLevel2#">		 
		</cfcase>
		
		<cfcase value="2">
		   <cfset text = "Program component">		
		</cfcase>
			
	</cfswitch>

</cfif>

<cfif url.header eq "1">
	<cfset html = "Yes">
<cfelse>
	<cfset html = "No">	
</cfif>	

<cf_screentop height="100%" label="#Action# #text#" layout="webapp" jquery="Yes" html="#html#" 
   banner="gray" scroll="yes" band="No">
   
<cfajaximport tags="cfwindow">

<cf_divscroll>   

	<cfform action="#SubmitAction#" method="POST" name="componentform" onsubmit="return false">
			
		<table width="98%" align="center">
		
		<tr class="line"><td>
		<cfif editProgram.PeriodParentCode eq "">
		    <cf_ShowProgramHierarchy parentcode="#url.ParentCode#" period="#url.period#">
		<cfelse>
			<cf_ShowProgramHierarchy parentcode="#EditProgram.PeriodParentCode#" period="#url.period#">
		</cfif>	
		</td></tr>
		
		<tr class="hide"><td id="process"></td></tr>	
		 
		<tr><td style="padding-top:3px"> 
		    
		 <table width="95%" align="center" border="0" class="formpadding" cellspacing="0" cellpadding="0">
		 		 		
			<tr class="line"><td colspan="2" class="labellarge" style="font-size:23;height:45px;font-weight:200">Name and Identification</td></tr>							 	
		  	<tr>
		
			<cfoutput>
			
			<INPUT type="hidden" name="Mission"       id="Mission"       value="#URL.Mission#">
			<INPUT type="hidden" name="Period"        id="Period"        value="#URL.Period#">
			<INPUT type="hidden" name="ProgramId"     id="ProgramId"     value="#URL.Id#">
			<INPUT type="hidden" name="ProgramLayout" id="ProgramLayout" value="Component">
			<INPUT type="hidden" name="ProgramClass"  id="ProgramClass"  value="Component">
			<INPUT type="hidden" name="Refresh"       id="Refresh"       value="#URL.Refresh#">	
			<input type="hidden" name="ProgramCode"   id="ProgramCode"   value="#EditProgram.ProgramCode#">
			
			</cfoutput>
			
			    <td align="center">
					
			    <table width="99%" align="center" class="formpadding" border="0" cellspacing="0">
													 		
					<cf_verifyOperational 
				         datasource= "appsSystem"
				         module    = "WorkOrder" 
						 Warning   = "No">
					 
					 <cfoutput>
					 
				    <cfif operational eq "1">
										
					<INPUT type="hidden" name="ServiceClass" id="ServiceClass" value="#editProgram.ServiceClass#">
						
					</cfif>	
				
				</cfoutput>
				
			    <!--- Field: Program Name --->
			    <tr>
			    <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Name">:<font color="FF0000">*</font> <cf_space spaces="46"></td>
			    <td>
				
				<cfoutput>
					
				<cf_LanguageInput
						TableCode       = "Program" 
						Mode            = "Edit"
						Name            = "ProgramName"
						Value           = "#EditProgram.ProgramName#"
						Key1Value       = "#EditProgram.ProgramCode#"
						Required        = "Yes"
						Type            = "Text"
						rows            = "2"
						style           = "font-size:13px"
						Maxlength       = "60"
						Class           = "regular enterastab">
				
				</cfoutput>	
						
				</td>
				</tr>	
				
				<TR>
	
			    <TD class="labelmedium" style="cursor:pointer">
					<cf_UItooltip tooltip="The code of the project as used by external system, such as indicator measurement source">
						<cf_tl id="Short Name">:
					</cf_UItooltip>
				</TD>
			    <td colspan="5">
				<cfoutput>
					<input type="text" class="regularxl enterastab" name="ProgramNameShort" style="border:1px solid d6d6d6" value="#EditProgram.ProgramNameShort#" size="35" maxlength="50">
				</cfoutput>			
				</td>
			    </tr>	
				
				<tr>
					<td class="labelmedium" valign="top" style="padding-top:5px;"><cf_tl id="Descriptive">:</td>
					<td>
						<cf_LanguageInput
							TableCode       = "ProgramPeriod" 
							Mode            = "Edit"
							Name            = "PeriodDescription"
							Value           = "#EditProgram.PeriodDescription#"
							Key1Value       = "#EditProgram.ProgramCode#"
							Key2Value       = "#EditProgram.Period#"
							Type            = "Text"
							Required        = "Yes"
							LanguageDefault = "1"	
							Message         = ""
							Form            = "componentform"
							Maxlength       = "2000"
							cols            = "69"
							rows            = "7"
							Class           = "regular">
					</td>
				</tr>
				
				<TR>
			    <TD class="labelmedium">
					<cf_UItooltip tooltip="Organization that requested the program and that would be charged for its costs"><cf_tl id="Requester">:</cf_UItooltip>
				</TD>
					
			    <TD class="labelmedium">
				
				<cfoutput>
				
					<table>
						<tr>
						
					<td> 	
					<input type="text" name="mission0"     id="mission0"     value="#Requester.Mission#"     class="regularxl enterastab" size="8"  maxlength="20" readonly> 
					</td>
					<td style="padding-left:3px">
					<input type="text" name="orgunitname0" id="orgunitname0" value="#Requester.orgunitName#" class="regularxl enterastab" size="50" maxlength="80" readonly>	
					</td>
					<td style="padding-left:3px">
				
					 <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img5" 
						  onMouseOver="document.img5.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img5.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 		  
						  onclick="selectorgN('#Requester.mission#','','orgunit','applyorgunit','0','0','modal')">							
					
					</td>
					<td style="padding-left:3px">	
					<button type="button" class="button3 enterastab" name="blank" onClick="javascript:reqblank()">
						<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
					</button> 
					
					<input type="hidden" name="orgunit0"       id="orgunit0"      value="#Requester.orgunit#">
					<input type="hidden" name="orgunitcode0"   id="orgunitcode0"  value="#Requester.orgunitcode#"> 
					<input type="hidden" name="orgunitclass0"  id="orgunitclass0" value="#Requester.orgunitclass#" readonly>
					
					</td>
									
					</tr>

					</table>			
				
				</cfoutput>	
				
				</TD>
				</TR>	
					
				<TR>
			    <TD class="labelmedium"><cf_tl id="Implementer">:</TD>
					
			    <TD class="labelmedium">
				
					<cfoutput>
					
						<table>
						<tr>
						
						<td> 
						<input type="text"   name="mission1" id="mission1"  value="#Implementer.Mission#" class="regularxl enterastab" size="8" maxlength="20" readonly> 
						</td>
						<td style="padding-left:3px">
						<input type="text"   name="orgunitname1" id="orgunitname1" value="#Implementer.orgunitName#" class="regularxl enterastab" size="50" maxlength="80" readonly>	
						</td>
						<td style="padding-left:3px">
											
						 <img src="#SESSION.root#/Images/contract.gif" alt="Select authorised unit" name="img1" 
									  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img1.src='#SESSION.root#/Images/contract.gif'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onclick="selectorgN('#Implementer.Mission#','','orgunit','applyorgunit','1','0','modal')">
						</td>
						<td style="padding-left:3px">
						<button type="button" class="button3 enterastab" name="blank" onClick="javascript:admblank()">
							<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
						</button> 
						<input type="hidden" name="orgunit1"      id="orgunit1"      value="#Implementer.orgunit#">
						<input type="hidden" name="orgunitcode1"  id="orgunitcode1"  value="#Implementer.orgunitcode#"></TD> 
						<input type="hidden" name="orgunitclass1" id="orgunitclass1" value="#Implementer.orgunitclass#" class="disabled" size="20" maxlength="20" readonly>
						</td>
						</tr>

					   </table>						
						
						</TD> 
						
						
						
					</cfoutput>	
					
				</TD>
				
			</TR>	
				
				
				<cfif Parameter.EnableObjective eq "1">
				
				<tr>
					<td class="labelmedium" valign="top" style="padding-top:5px;"><cf_tl id="Objective">:</td>
					<td>
						<cf_LanguageInput
							TableCode       = "ProgramPeriod" 
							Mode            = "Edit"
							Name            = "PeriodObjective"
							Value           = "#EditProgram.PeriodObjective#"
							Key1Value       = "#EditProgram.ProgramCode#"
							Key2Value       = "#EditProgram.Period#"
							Type            = "text"
							Required        = "No"
							LanguageDefault = "1"	
							Message         = ""
							Form            = "componentform"
							Maxlength       = "2000"
							cols            = "69"
							height          = "150"
							rows            = "13"
							Class           = "regular">
					</td>
				</tr>
				<tr>
					<td class="labelmedium" valign="top" style="padding-top:5px;"><cf_tl id="Goal">:</td>
					<td>
						<cf_LanguageInput
							TableCode       = "ProgramPeriod" 
							Mode            = "Edit"
							Name            = "PeriodGoal"
							Value           = "#EditProgram.PeriodGoal#"
							Key1Value       = "#EditProgram.ProgramCode#"
							Key2Value       = "#EditProgram.Period#"
							Type            = "#vPeriodFieldsMode#"
							MaxLength		= '30000'
							Required        = "Yes"
							LanguageDefault = "1"	
							Message         = ""
							Form            = "componentform"
							height          = "140"
							cols            = "69"
							rows            = "12"
							Class           = "regular">
					</td>
				</tr>
				
				</cfif>
						
				<cfquery name="Mandate"
			         datasource="AppsOrganization"
			         maxrows=1
			         username="#SESSION.login#"
			         password="#SESSION.dbpw#">
				      SELECT  *
				      FROM    Ref_Mandate M, Program.dbo.Ref_Period P
					  WHERE   M.Mission = '#ParentOrg.Mission#'
					  AND     P.Period = '#URL.Period#' 
					  AND     M.DateExpiration >= P.DateEffective
					  ORDER BY MandateNo DESC
			    </cfquery>
			
			    <!--- Field: Program Organization --->
						
				<cfif Parent.ProgramScope eq "Global" and EditProgram.recordcount eq "0">
										
					<tr>
				      <TD class="labelmedium"><cf_tl id="Program">:</TD>
					  <TD class="labelmedium"><cfoutput>#Parent.ProgramName#<b>[Global]</b></cfoutput>
					</tr>
					<tr><td height="6"></td></tr>	
					
					<cfoutput>
					<input type="hidden" name="parentcode" 	id="parentcode"  value="#Parentcode#">
					<input type="hidden" name="orgunit" 	id="orgunit"     value="#OrgUnit#">		
					<input type="hidden" name="orgunitname" id="orgunitname" value="">
					</cfoutput>
							
				<cfelse>
												   
					   <cfif EditProgram.ProgramScope eq "Unit">					   
					   
					     <cfif access eq "ALL">
						
						    <cfoutput>				
																					
							<tr>
							    <td>
								
									<table>
									<tr class="labelmedium">
									<td><cf_tl id="Budget Unit">:</td>
									<td style="padding-left:10px">
										<a style="font-weight:200" href="javascript:selectprogramme('#ParentOrg.Mission#','#URL.Period#','#OrgParent.OrgUnit#','#EditProgram.OrgUnit#','#URL.EditCode#','setprogram')"><cf_tl id="Move"></a>
									</td>
									</tr>
									</table>
								
								</td>
								
								 <TD>
								 
								 <table>
									 <tr><td>
										  <input type	  = "hidden" 			               
												name	  = "orgunit" 
												id		  = "orgunit"
												value	  = "#OrgUnit#" 
												size	  = "68" 
												maxlength = "60" 
												readonly>
									 
									      <input type	  = "text" 
								                class	  = "regularxl" 
												style     = "background-color:eaeaea"
												name	  = "orgunitname" 
												id		  = "orgunitname"
												value	  = "#OrgUnitName#" 
												size	  = "60" 
												maxlength = "60" 
												readonly>
												
										</td>
										<td style="padding-left:5px">
										<input type="checkbox" name="setimplementer" value="1" class="radiol">
										</td>
										<td class="labelmedium" style="padding-left:4px">Same as implementer</td>
										
										</tr>		
									</table>
											
								</TD>	
								
							</tr>									
												
							<tr class="labelmedium">
							    <td><cf_tl id="Program / Action">:</td>
								
								 <TD>
								 												 
								   <input type    = "hidden" 
						                name	  = "parentcode" 
										id		  = "parentcode" 
										value	  = "#Parent.ProgramCode#" 
										size	  = "68" 
										maxlength = "60" 
										readonly>
																					
								 	<input type	   = "text" 
								         class	   = "regularxl" 
										 style     = "background-color:eaeaea"
										 name	   = "parentcodename"
										 id		   = "parentcodename" 
										 value	   = "#Parent.ProgramName#" 
										 size	   = "60" 
										 maxlength = "60" readonly>	
								</td>	 
							</tr>
							
							</cfoutput>		
							
						<cfelse>
						
						<cfoutput>
						
						   <!--- -------------- --->
						   <!--- added by hanno --->
						   <!--- -------------- --->
						
						  <input type  = "hidden" 			               
							name	   = "orgunit" 
							id		   = "orgunit"
							value	   = "#OrgUnit#" 
							size	   = "68" 
							maxlength  = "60" 
							readonly>				 
								 
						  <input type  = "hidden" 
			                name	   = "parentcode" 
							id		   = "parentcode" 
							value	   = "#Parent.ProgramCode#" 
							size	   = "68" 
							maxlength  = "60" 
							readonly>
							
							</cfoutput>
												
					
						</cfif>
				   
				   <cfelse>
				   				   		
					<cfoutput>				
					<tr>
				    <td class="labelmedium"><cf_tl id="Under Program">:</TD>
						
				    <TD>
					
					<table cellspacing="0" cellpadding="0">
					<tr>
						
						<td>
			
						<input type="hidden" name="parentcode" id="parentcode" value="#Parentcode#">	
							
						<input type = "text" 
							 name	= "parentcodename" 
							 id		= "parentcodename" 
						     value	= "#Parent.ProgramName#" 
							 size	= "75" 
							 class	= "regularxl enterastab" 
							 maxlength = "75" readonly>
						 
					 	</TD>
						
						<cfif Parent.ProgramClass eq "Program">
			
						  <td width="20" style="padding-left:3px">		
						  		  
						  <img src="#SESSION.root#/Images/contract.gif" alt="Select program" name="img4" 
								  onMouseOver="document.img4.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img4.src='#SESSION.root#/Images/contract.gif'"
								  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
								  onClick="selectprogramme('#URL.Mission#','#URL.Period#','#OrgParent.OrgUnit#','#EditProgram.OrgUnit#','setprogram')">				  
					      </td>
						  
					    </cfif>
					</TR>	
					
					</table>
					</td>
					</tr>
									
					<TR>
				   
				    <TD class="labelmedium"><cf_tl id="Budget Operational Unit">:</TD>
					<td>
					
					<cfquery name="Org"
			         datasource="AppsOrganization"        
			         username="#SESSION.login#"
			         password="#SESSION.dbpw#">
					  	SELECT    Mission,
						          MandateNo,
								  HierarchyCode
					    FROM      Organization
						WHERE     OrgUnit = '#OrgUnit#'
					</cfquery>  
					
					<cfquery name="Unit"
			         datasource="AppsOrganization"        
			         username="#SESSION.login#"
			         password="#SESSION.dbpw#">
						  SELECT   * 
						  FROM     Organization
						  WHERE    Mission      = '#Org.Mission#' 
						  AND      MandateNo    = '#Org.MandateNo#'
						  AND      HierarchyCode LIKE '#Org.HierarchyCode#%'
						  ORDER BY HierarchyCode
					</cfquery>  
							
					<input type="hidden" name="orgunitname" id="orgunitname" value="">		
					<select name="OrgUnit" id="OrgUnit" class="regularxl enterastab">
						<cfloop query="Unit">
							<option value="#OrgUnit#">#OrgUnitName#</option>		
						</cfloop>
					</select>
					
					</td>
					</tr>
					
					</cfoutput>
					
				</cfif>
					
				</cfif>
								
				<cfif Parameter.EnableGlobalProgram eq "0">
				
			    	<input type="hidden" name="ProgramScope" id="ProgramScope" value="Unit">
					<cfset scope = "Unit">
					
				<cfelse>
							
						<cfif Parent.ProgramScope eq "Global" AND Parent.ProgramClass eq "Program">
							
							<cfif EditProgram.ProgramScope neq "">
							    <cfset scope = "#EditProgram.ProgramScope#">
							<cfelse>
							    <cfset scope = "Unit">
							</cfif>
						
							<TD class="labelmedium"><cf_tl id="Scope"> :</TD>
						    <TD class="labelmedium" style="height:25px">
							   <!--- not really relevant to show global again for component in my views, so disabled now
							   <input type="radio" name="ProgramScope" value="Global" 
							   <cfif Scope eq "Global">Checked</cfif> onClick="javascript:scope('global')">Global
							   --->
							   <input type="radio" class="radiol enterastab" name="ProgramScope" value="Parent" 
							   <cfif Scope eq "Parent">Checked</cfif>  onClick="javascript:scope('parent')"><cf_tl id="Parent">
							   <input type="radio" class="radiol enterastab" name="ProgramScope" value="Unit" 
							   <cfif Scope eq "Unit">Checked</cfif>  onClick="javascript:scope('parent')"><cf_tl id="Unit">
							</td>
							
							</tr>
							
						    <TR id="par" class="<cfif scope neq 'global'>regular<cfelse>hide</cfif>">
						    <TD class="labelmedium"><cf_tl id="Managed by">:</TD>
						    <TD>
									
					    	<select name="OrgUnitParent" required="Yes" class="regularxl enterastab">
							    <cfoutput query="OrgParent">
								<option value="#OrgUnit#" <cfif ParentOrg.OrgUnit eq OrgUnit> SELECTED</cfif>>#OrgUnitName#</option>
								</cfoutput>
						   	</select>
							
							</TD>
							</TR>	
							
							<!---
							<input type="hidden" name="ProgramScope" id="ProgramScope"    value="Global">
							--->
							
						<cfelse>	
						
							<input type="hidden" name="ProgramScope" id="ProgramScope"    value="Unit">
							<input type="hidden" name="orgunitparent" id="orgunitparent"  value="<cfoutput>#ParentOrg.OrgUnit#</cfoutput>">
							<cfset scope = "Unit">
							
				  		</cfif>		
				</cfif>
								
				
			
			 <!--- Field: Program Officer --->
		
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Contact">:</TD>
		    <TD class="labelmedium">
			<cfoutput>
				<CFINPUT type="text" class="regularxl enterastab" name="ProgramManager" value="#EditProgram.ProgramManager#" maxLength="200" size="55">
			</cfoutput>	
			</TD>
			</TR>			
				 
			<cfquery name="Check" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT  ProgramClass
			     FROM    Program  
		    	 WHERE   ProgramCode = '#ParentCode#'
		    </cfquery>
			
			<cfoutput>
			
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Reference">:</TD>
		    <TD>	
			    <table>
				<tr>
				<td><input type="text" class="regularxl enterastab" name="Reference" value="#EditProgram.Reference#" size="20" maxlength="20" style="text-align: center;"></td>
				<td style="padding-left:5px" class="labelmedium"><cf_tl id="Relative Order">:</td>
				<td class="labelmedium">
				<cfinput type="Text" class="regularxl enterastab" name="ListingOrder" value="#EditProgram.ListingOrder#" validate="integer" required="No" size="2" maxlength="2" style="text-align: center;">
				</td>
				</tr>
				</table>
			</td>
			</tr>	
						
			
			<TR>	
				<TD class="labelmedium"><cf_tl id="Status Mode">:</TD>
			    <TD class="labelmedium" style="height:25px">	
				
				   <table><tr class="labelmedium"><td>
				   	<input type="radio" name="Status" class="radiol enterastab" value="1" <cfif EditProgram.Status eq "1">Checked</cfif>>
					</td><td style="padding-left:4px">Locked</td>
					<td style="padding-left:8px">
					<input type="radio" name="Status" class="radiol enterastab" value="0" <cfif EditProgram.Status eq "0" or EditProgram.Status eq "">Checked</cfif>>
					</td><td style="padding-left:4px">Extend access to mode ALL</td>
					</tr>
					</table>
				</td>		
			</tr>
			
			<tr class="line"><td colspan="2" class="labellarge" style="font-weight:200;font-size:23;height:45px">Budget Settings</td></tr>		
			<tr><td height="10"></td></tr>			
					
			<TR>	
				<TD class="labelmedium"><cf_tl id="Allotment">:</TD>
			    <TD class="labelmedium" style="height:25px">	
				    <table><tr class="labelmedium"><td>	
					<input type="radio" class="radiol enterastab" name="ProgramAllotment" value="1" <cfif EditProgram.ProgramAllotment eq "1" or EditProgram.ProgramAllotment eq "">Checked</cfif>>
					</td><td style="padding-left:4px">Enabled</td>
					<td style="padding-left:8px">
					<input type="radio" class="radiol enterastab" name="ProgramAllotment" value="0" <cfif EditProgram.ProgramAllotment eq "0">Checked</cfif>>
					</td><td style="padding-left:4px">Extend access to mode ALL</td>
					<td style="padding-left:8px">	
					<input type="radio" class="radiol enterastab" name="ProgramAllotment" value="9" <cfif EditProgram.ProgramAllotment eq "9">Checked</cfif>>
					</td><td style="padding-left:4px">Disabled</td>
					</tr>
					</table>				
				</td>		
			</tr>
			
			<TR>	
				<TD class="labelmedium"><cf_tl id="Holder">:</TD>
			    <TD class="labelmedium" style="height:25px">		
				     <table><tr class="labelmedium"><td>	
					<input type="radio" class="radiol enterastab" name="ProgramAllocation" value="1" <cfif EditProgram.ProgramAllocation eq "1" or EditProgram.ProgramAllocation eq "">Checked</cfif>>
					</td><td style="padding-left:4px">Yes, disables direct allocation entry for other components <font color="0080C0">(new)</font></td>
					<td style="padding-left:8px">
					<input type="radio" class="radiol enterastab" name="ProgramAllocation" value="0" <cfif EditProgram.ProgramAllocation eq "0">Checked</cfif>>
					</td><td style="padding-left:4px">No</td>
					</tr>
					</table>													
				</td>		
			</tr>
			
			<TR>	
				<TD class="labelmedium"><cf_tl id="Requirements">:</TD>
			    <TD class="labelmedium" style="height:25px">		
				    <table><tr class="labelmedium"><td>
					<input type="radio" class="radiol enterastab" name="EnforceAllotmentRequest" value="1" <cfif EditProgram.EnforceAllotmentRequest eq "1" or EditProgram.EnforceAllotmentRequest eq "">Checked</cfif>>
					</td><td style="padding-left:4px">Enforce</td>
					<td style="padding-left:8px">
					<input type="radio" class="radiol enterastab" name="EnforceAllotmentRequest" value="0" <cfif EditProgram.EnforceAllotmentRequest eq "0">Checked</cfif>>
					</td><td style="padding-left:4px">Defined by Edition</td>
					</tr>
					</table>																	
				</td>		
			</tr>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Symbol">:</TD>
			 <TD colspan="5">	
				<CFINPUT type="text" class="regularxl enterastab" name="ReferenceBudget" value="#EditProgram.ReferenceBudget#" maxLength="20" size="20">
			</TD>   
			</tr>
			
			<TR>
			<TD style="padding-top:8px;height:40px" valign="top" class="labelmedium"><cf_tl id="Budget Code">:</TD>
			<td class="labelmedium"> 
			<table cellspacing="0" cellpadding="0" width="100%" class="formspacing" style="width:400px">
			
				<tr>
			    <TD style="padding-left:0px" class="labelit"><cf_tl id="Budget1">:</TD>
				<TD style="padding-left:2px" class="labelit"><cf_tl id="Budget2">:</TD>
				<TD style="padding-left:2px" class="labelit"><cf_tl id="Budget3">:</TD>
				<TD style="padding-left:2px" class="labelit"><cf_tl id="Budget4">:</TD>
				<TD style="padding-left:2px" class="labelit"><cf_tl id="Budget5">:</TD>
			    <TD style="padding-left:2px" class="labelit"><cf_tl id="Budget6">:</TD>
				</tr>				
			
				<tr>
				   <TD><input type="text" class="regularxl enterastab" name="ReferenceBudget1" value="#EditProgram.ReferenceBudget1#" size="4" maxlength="8" style="text-align: center;width:99%;"></td>
				   <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget2" value="#EditProgram.ReferenceBudget2#" size="4" maxlength="8" style="width:99%;text-align: center;"></td>
				   <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget3" value="#EditProgram.ReferenceBudget3#" size="4" maxlength="8" style="width:99%;text-align: center;"></td>
				   <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget4" value="#EditProgram.ReferenceBudget4#" size="4" maxlength="8" style="width:99% ;text-align: center;"></td>
			       <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget5" value="#EditProgram.ReferenceBudget5#" size="4" maxlength="8" style="width:99%;text-align: center;"></td>	   
			       <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget6" value="#EditProgram.ReferenceBudget6#" size="4" maxlength="8" style="width:100%;text-align: center;"></td>	   
				</tr>
			</table>
			</td>
			</tr>
							
			</cfoutput>	
						
		   
		    <!--- Field: Program Memo --->
		
			<TR>
		        <TD valign="top" style="padding-top:4px" class="labelmedium" height="50%"><cf_tl id="Memo">:</td>
				<cfoutput>
		        <TD><textarea style="width:95%;height:60;font-size:13px;padding:3px" class="regular" name="Memo">#EditProgram.ProgramMemo#</textarea> </TD>
				</cfoutput>
			</TR>
				         
		</table>
		
		</td></tr>	
				
		<tr><td class="line"></td></tr>
				
		<tr><td height="32" colspan="2">
			<table width="100%" class="formpadding">
			
		   		<td align="center">
				
				<cf_tl id="Close" var="1">
					   
			   	<cfquery name="IsParent" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			    	 SELECT * 
					 FROM  ProgramPeriod
					 WHERE PeriodParentCode = '#EditProgram.ProgramCode#'		
					 AND   Period = '#url.period#'
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
							
			    <cfif isParent.recordcount eq "0"  
				   and Position.recordcount eq "0"
				   and Purchase.recordcount eq "0"
				   and Ledger.recordcount eq "0">
				 
				 <cf_tl id="Delete" var="1"> 	
				 <cfoutput>		 
			     <input class="button10g" type="button" onclick="return ask()" name="Delete" style="height:25;width:130" value="#lt_text#">
				 </cfoutput>
				 
			    </cfif>
		
				<cf_tl id="Save" var="1"> 	
			    <cfoutput>
			      <input class="button10g" type="button" onclick="validate('add')" onname="Submit" style="height:25;width:130" value="#lt_text#">
			    </cfoutput>
			   
		   		</td>
				</tr>
				
		   </table>
		   
		   </td></tr>
		   
		</table>
		
		</td>
		</tr>
		
	</table>
		
	</cfform>
	
</cf_divscroll>	

<cf_screenbottom layout="webapp">
