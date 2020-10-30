
<script language="JavaScript">
	 document.getElementById('savebox').className = "regular"
</script>

<cfparam name="access" default="edit">

<cfif access eq "READ">
	<cfset mode = "view">
<cfelse>
	<cfset mode = "edit">	
</cfif>

<!--- --------------------- kherrera (2017-02-15): labels by group ---------------------------- --->
<cfset vEditProgramCode = url.EditCode>
<cfif trim(url.EditCode) eq "">
	<cfset vEditProgramCode = url.ParentCode>
</cfif>

<cfquery name="qGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	G.*,
			O.Mission
	FROM   	ProgramGroup G
			INNER JOIN Ref_ProgramGroup RG ON G.ProgramGroup = RG.Code
			INNER JOIN ProgramPeriod PP    ON PP.ProgramCode = G.ProgramCode AND PP.Period = '#url.period#'
			INNER JOIN Organization.dbo.Organization O ON PP.OrgUnit = O.OrgUnit
	WHERE  	G.ProgramCode = '#vEditProgramCode#'
</cfquery>

<cfquery name="qClass" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	PC.*
	FROM   	Program P
			INNER JOIN Ref_ProgramClass PC ON P.ProgramClass = PC.Code
	WHERE  	P.ProgramCode = '#vEditProgramCode#'
</cfquery>

<cfset vPeriodFieldsMode = "Text">
<cfif qClass.EntryMode eq "Regular">
	<cfset vPeriodFieldsMode = "Text">
</cfif>
<cfif qClass.EntryMode eq "Editor">
	<cfset vPeriodFieldsMode = "HTML">
</cfif>

<!--- prepare subtitles to be customazble --->
	
<cfif qGroup.Mission eq "DPA" OR qGroup.Mission eq "DPPA-DPO">
					
	<!--- DPA projects --->						
	<cfset vDisplayProblemAnalysis = "display:none;">
	
	<!--- Rapid Response --->
	<cfif qGroup.ProgramGroup eq "D02">		
		<cf_tl class="Message" id="Rapid DPPA-DPO Objective"       var="vSummarySubtitle">
		<cf_tl class="Message" id="Rapid DPPA-DPO Requirement"     var="vRequirementsSubtitle">
		<cf_tl class="Message" id="Rapid DPPA-DPO Justification"   var="vJustificationSubtitle">	
	<cfelse>
		<cf_tl class="Message" id="Project DPPA-DPO Objective"     var="vSummarySubtitle">
		<cf_tl class="Message" id="Project DPPA-DPO Requirement"   var="vRequirementsSubtitle">
		<cf_tl class="Message" id="Project DPPA-DPO Justification" var="vJustificationSubtitle">								
	</cfif>
		
<cfelse>
	
	<cf_tl class="Message" id="Project Objective Subtitle"         var="vSummarySubtitle">
	<cf_tl class="Message" id="Project Requirement Subtitle"       var="vRequirementsSubtitle">
	<cf_tl class="Message" id="Project Justification Subtitle"     var="vJustificationSubtitle">
		
</cfif>

<!--- General text box titles and subtitles --->
<cfoutput>
<cfsavecontent variable="vSummaryLabel">
	<cf_tl id="Overall Objectives">:<font color="FF0000">*</font>
	<cfif vSummarySubtitle neq "">
	<br><font size="2" color="808080">#vSummarySubtitle#</font>
	</cfif>	
</cfsavecontent>

<cfsavecontent variable="vRequirementsLabel">
   <cf_tl id="Budget Requirements">:
   <cfif vRequirementsSubtitle neq "">
	<br><font size="2" color="808080">#vRequirementsSubtitle#</font>
	</cfif>   
</cfsavecontent>

<cfset vDisplayDescription = "">
<cfsavecontent variable="vDescriptionLabel">
   <cf_tl id="Justification">:<font color="FF0000">*</font>
   <cfif vJustificationSubtitle neq "">
	<br><font size="2" color="808080">#vJustificationSubtitle#</font>
	</cfif>      
</cfsavecontent>

<cfset vDisplayProblemAnalysis = "">
<cfsavecontent variable="vProblemAnalysisLabel">
    <cf_tl id="Problem Analysis">:<font color="FF0000">*</font>	
</cfsavecontent>
</cfoutput>

<!--- ----------------------------------------------------------------------------------------- --->

<table width="98%" border="0" class="formpadding" cellpadding="0" cellspacing="0">					
					
		 <!--- check access = budget manager --->
		
		   <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
					Method         = "budget"
					Mission        = "#ParentOrg.Mission#"
					Period         = "#url.Period#"				
					Role           = "'BudgetManager'"
					ReturnVariable = "BudgetAccess">					
				
		  <cfoutput>	
		  
		   <!--- Hanno 16/5/2015 : hiding it 		 
		   		   
		   <cfif Parent.ProgramClass eq "Program" and ParentList.recordcount gte "1">
		   		   
		   <cfif EditProgram.Reference eq "" and (BudgetAccess eq "NONE" or BudgetAccess eq "READ")>
		     <cfset cl = "hide">
		   <cfelse>
		     <cfset cl = "regular">
		   </cfif>	 
		   
		   <tr class="hide"> 
		      <TD class="labelmedium"><cf_tl id="Output">: <font color="FF0000">*</font></TD>
			  <td class="labelit">
			  
			  <select name="parentcode" id="parentcode" class="regularxl">
				  <cfloop query="ParentList">
				  <option value="#ProgramCode#" <cfif ParentCode eq ProgramCode>selected</cfif>><cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif></option>
				  </cfloop>
			  </select>
			  
			  </td>		  
		   </tr>
		   		   		   
		   <cfelse>	   
			   
		   		   
		   </cfif>		
		   
		   --->	  
		   
		   <input type="hidden" name="parentcode"    id="parentcode"    value="#ParentCode#">	
		   
		  <tr class="line"><td colspan="6" style="height:47px;font-size:24px" class="labelmedium"><cf_tl id="Project Definition"></td></tr>	
		
		   
		   <tr>
			  <td class="labelmedium"><cf_tl id="Entry Date">: <font color="FF0000">*</font></td>
			  <td  class="labelmedium">
			  
			    <cfif mode eq "edit">
			  
					  	<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL" or 
						       (isCleared.recordcount eq "0" and isPriorPeriod.recordcount eq "0")>	
					  
						    <cfif EditProgram.ProgramDate neq "">
							
								<cf_intelliCalendarDate9
											FieldName="ProgramDate" 
											Default="#DateFormat(EditProgram.ProgramDate, '#CLIENT.DateFormatShow#')#"
											AllowBlank="false"
											Message="Enter a project date"
											Class="regularxl enterastab">
							
							<cfelse>
							 
							  	<cf_intelliCalendarDate9
											FieldName="PrograamDate" 
											Default="#DateFormat(now(), '#CLIENT.DateFormatShow#')#"
											AllowBlank="false"
											Message="Enter a project date"
											Class="regularxl enterastab">
										
							</cfif>		
							
						<cfelse>
						
							#DateFormat(EditProgram.ProgramDate, '#CLIENT.DateFormatShow#')#					
							<input type="hidden" name="ProgramDate" value="#DateFormat(EditProgram.ProgramDate, '#CLIENT.DateFormatShow#')#">
						
						</cfif>		
						
				<cfelse>
				
					#DateFormat(EditProgram.ProgramDate, '#CLIENT.DateFormatShow#')#	
				
				</cfif>		
			  
			  </td>
			  </tr>
			  
			  <!--- events to be shown --->
			
			  <cfquery name="Events" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  F.Code, 
					        F.Description, 
						    F.Listingorder, 
						    S.EntityClass,				
						    S.OfficerFirstName, 
						    S.OfficerLastName, 
						    S.ActionStatus,		
						    S.ProgramEvent,		  
						    S.Created, 
						    S.DateEvent, 
						    S.Remarks, 
						    S.ProgramCode as Selected
					FROM    ProgramEvent S RIGHT OUTER JOIN
				            Ref_ProgramEvent F ON S.ProgramEvent = F.Code AND S.ProgramCode = '#URL.EditCode#'
					WHERE   F.Code IN (SELECT ProgramEvent
					                   FROM   Ref_ProgramEventMission	   
								 	   WHERE  Mission = '#Mission#') 
					AND     ModeEntry = '1'				  
						 
				    ORDER By ListingOrder, Description
				
			  </cfquery>	
			  
			  <cfloop query="Events">
									
				<tr>
				<td class="labelmedium">#Description# :&nbsp;<font color="FF0000">*</font></td>
				<td colspan="5" class="labelit">
				
						<cfif mode eq "edit">
														
						<cf_intelliCalendarDate9
							FieldName="DateEvent_#Code#" 
							Default="#DateFormat(DateEvent, '#CLIENT.DateFormatShow#')#"
							AllowBlank="false"
							Message="Please enter #Description#"
							Class="regularxl enterastab">
							
						<cfelse>
						
						#DateFormat(DateEvent, '#CLIENT.DateFormatShow#')#
						
						</cfif>	
								
				</td>
				</tr>
			
			  </cfloop>			
			  
			  <cfif url.editcode eq "">									
		
			    <!--- Field: Program Officer --->
				
			    <TR>
			    <TD class="labelmedium"><cf_tl id="Manager">: <font color="FF0000">*</font></TD>
			    <TD colspan="5" class="labelit">	
				
				    <table cellspacing="0" cellpadding="0">
					 <tr><td id="member">
					 
					 <input type="text" name="ProgramManager" value="" size="40" maxlength="40" class="regularxl" readonly style="height:27px;padding-left:3px">				
					 <input type="hidden" name="personno" id="personno" value="" size="10" maxlength="10" readonly style="text-align: center;">
						
						</td>
						
						<td>
						
						 <cfset link = "#SESSION.root#/ProgramREM/Application/Program/Create/setManager.cfm?1=1">	
								
						 <cf_selectlookup
						    class      = "Employee"
						    box        = "member"
							button     = "yes"
							icon       = "search.png"
							iconwidth  = "28"
							iconheight = "28"
							title      = "#lt_text#"
							link       = "#link#"						
							close      = "Yes"
							des1       = "PersonNo">
						
						</td></tr>
					</table>
						
				</TD>
				</TR>	
			
			<cfelse>
			
				<TR>
			    <TD class="labelmedium"><cf_tl id="Manager">: <font color="FF0000">*</font></TD>
			    <TD colspan="5" class="labelit">		
				
					<cfif mode eq "edit">			
				 				 
						<cfinput type="text" 
						    class="regularxl enterastab" 
							name="ProgramManager" 
							value="#EditProgram.ProgramManager#" 
							maxLength="200" 
							size="45" 
							message="Please enter a Project Manager" required="Yes">
							
					<cfelse>
					
					#EditProgram.ProgramManager#
					
					</cfif>		
						
											
				</TD>
				</TR>				
			
			</cfif>
			
			  <tr>
			  <td class="labelmedium"><cf_tl id="Internal Code">:</td>
			  <td>
			  			  
			  	<cfif mode eq "edit">		
			     
				    <cfinput type="text" class="regularxl enterastab" name="ReferenceBudget" value="#EditProgram.ReferenceBudget#" maxLength="20" size="15">
					
				<cfelse>
				
					#EditProgram.ReferenceBudget#
					
				</cfif>	
			  </td>
			  </tr>	
			  
			 <cfif mode eq "View">
			 					 			  			  
			 <cfelseif (EditProgram.Reference eq "" and (BudgetAccess eq "NONE" or BudgetAccess eq "READ"))>
			  
				  	<!--- not to be shown --->					
					<input type="hidden" class="regularxl enterastab" name="Reference" value="#EditProgram.Reference#" size="10" maxlength="20" style="text-align: left;">
					
			  <cfelse>
			  
			      <tr>
			  
					  <td class="labelmedium"><cf_UIToolTip tooltip="The code of the project as used by external system, such as indicator measurement source">
		    			<cf_tl id="External Reference">:</cf_UIToolTip>
					  </td>			 
							
					  <cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">							  		  
					  <td class="labelit"><input type="text" class="regularxl enterastab" name="Reference" value="#EditProgram.Reference#" size="15" maxlength="20" style="text-align: left;"></td>					  
					  <cfelse>					  
					  <td class="labelmedium">#EditProgram.Reference#<input type="hidden" class="regularxl enterastab" name="Reference" value="#EditProgram.Reference#" size="15" maxlength="20" style="text-align: left;"></td>								  
					  </cfif>	
				  
				  <tr>
				  
				   <td class="labelit" style="padding-left:10px"><cf_UIToolTip tooltip="The code of the project as used by execution system"><cf_tl id="Extended reference">:</cf_UIToolTip></td>
				   <td>
				   <table class="formpadding">
				   
				   <cfquery name="Source" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM   ProgramPeriodSource
						WHERE  ProgramCode = '#EditCode#'
						AND    Period = '#url.period#'
				   </cfquery>
					
				   <cfloop query="Source">
			   			<cfset mysource[currentrow] = sourceno>
				   </cfloop>					
									   
				   <cfloop index="itm" from="1" to="14">
				   
				   		<cfif itm eq "1" or itm eq "8">
						<tr>
						</cfif>
				   
					   <cfparam name="mysource[#itm#]" default="">
					   
					   <td style="padding-right:4px">
						   <cfset val = mysource[itm]>
						   <input type="text" 
						        class="regularh enterastab" 
								name="Source#itm#" 
								value="#val#" 
								size="13" maxlength="20" style="text-align: left;">
					   </td>	
					   
					   <cfif itm eq "7" or itm eq "14">
						<tr>
						</cfif>	
					   		   
				   </cfloop>
				   </table>
				   </td>
				  			  
				  </tr>
			  
			  </cfif>		 	  	     
		   
		    <!--- Field: Program Name --->
			
		    <TD class="labelmedium" valign="top" style="padding-top:5px"><cf_space spaces="40"><cf_tl id="Title">: <font color="FF0000">*</font></TD>
			
		    <TD colspan="5" class="labelmedium">
			
					<cfif mode eq "edit">
						
						<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL" or
						
						  (isCleared.recordcount eq "0" and isPriorPeriod.recordcount eq "0")>	
				
							<cf_LanguageInput
								TableCode       = "Program" 
								Mode            = "Edit"
								Name            = "ProgramName"
								Value           = "#EditProgram.ProgramName#"
								Key1Value       = "#EditProgram.ProgramCode#"
								Type            = "Input"
								Required        = "Yes"
								LanguageDefault   = "0"							
								Message         = "Please enter a Name"
								style           = "width:100%"
								maxlength       = "200"
								Class           = "regularxl enterastab">
							
						<cfelse>
						
							<cf_LanguageInput
								TableCode       = "Program" 
								Mode            = "View"
								Name            = "ProgramName"
								Value           = "#EditProgram.ProgramName#"
								Key1Value       = "#EditProgram.ProgramCode#"
								Type            = "Input"
								Required        = "Yes"
								LanguageDefault = "0"	
								Class           = "LabelMedium"
								Message         = "Please enter a Name"
								style           = "width:100%"
								maxlength       = "200">				
						
						</cfif>			
						
					<cfelse>
					
					#EditProgram.ProgramName#
					
					</cfif>		
						
				</TD>
			</TR>
			
			<TR style="#vDisplayDescription#">
		        <TD valign="top" style="padding-top:5px" class="labelmedium" colspan="6">
					#vDescriptionLabel# 
				</td>
		   </tr>		
			
		   <tr style="#vDisplayDescription#">	
				<TD colspan="6">
				
				<cfif mode eq "edit">
								
		       	<cf_LanguageInput
					TableCode       = "ProgramPeriod" 
					Mode            = "Edit"
					Name            = "PeriodDescription"
					Value           = "#EditProgram.ProgramDescription#"
					Key1Value       = "#EditProgram.ProgramCode#"
					Key2Value       = "#EditProgram.Period#"
					Type            = "Text"
					Required        = "Yes"
					LanguageDefault = "1"	
					Message         = ""
					Form            = "programform"
					Maxlength       = "30000"
					cols            = "69"
					rows            = "12"
					Class           = "regular">
					
				<cfelse>
				
				<cf_LanguageInput
					TableCode       = "ProgramPeriod" 
					Mode            = "View"
					Name            = "PeriodDescription"
					Value           = "#EditProgram.ProgramDescription#"
					Key1Value       = "#EditProgram.ProgramCode#"
					Key2Value       = "#EditProgram.Period#"
					Type            = "Text"
					Required        = "Yes"
					LanguageDefault = "1"	
					Message         = ""
					Form            = "programform"
					Maxlength       = "30000"
					cols            = "69"
					rows            = "12"
					Class           = "regular">
				
				
				</cfif>	
				
			    </TD>
				
		     </TR>		
			
		 <cfif Parameter.EnableObjective eq "1">
		 	
			<TR>
		        <TD valign="top" style="padding-top:5px" class="labelmedium" colspan="6">
					#vSummaryLabel#
				</td>
			</tr>
			
			<tr>	
			
				<TD colspan="6">
				
				<cfif mode eq "edit">
				
			       	<cf_LanguageInput
						TableCode       = "ProgramPeriod" 
						Mode            = "Edit"
						Name            = "PeriodGoal"
						Value           = "#EditProgram.ProgramGoal#"
						Key1Value       = "#EditProgram.ProgramCode#"
						Key2Value       = "#EditProgram.Period#"
						Type            = "#vPeriodFieldsMode#"
						Required        = "Yes"
						LanguageDefault = "1"	
						Message         = ""
						Form            = "programform"
						Maxlength       = "30000"
						height          = "140"
						cols            = "69"
						rows            = "12"
						Class           = "regular">
					
				<cfelse>
				
						<cf_LanguageInput
						TableCode       = "ProgramPeriod" 
						Mode            = "View"
						Name            = "PeriodGoal"
						Value           = "#EditProgram.ProgramGoal#"
						Key1Value       = "#EditProgram.ProgramCode#"
						Key2Value       = "#EditProgram.Period#"
						Type            = "#vPeriodFieldsMode#"
						Required        = "Yes"
						LanguageDefault = "1"	
						Message         = ""
						Form            = "programform"
						Maxlength       = "30000"
						height          = "140"
						cols            = "69"
						rows            = "12"
						Class           = "regular">
				
				
				</cfif>	
				
			    </TD>
				
			</TR>
						
		 <cfelse>
		 		    
			 <input type="hidden" name="PeriodGoal" id="PeriodGoal" value="">
				
		 </cfif>	 

			 <!--- hardcoded setting to hide this field in the UN for SZA --->
			 <cfquery name="check" 
    		 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
	    	  SELECT *
		      FROM ProgramGroup
			  WHERE ProgramCode = '#url.parentCode#'
			  AND   ProgramGroup = 'D03'
		     </cfquery>
			 		 
			 <cfif Parameter.EnableObjective eq "1" and check.recordcount eq "0">
			  			  
				<TR style="#vDisplayProblemAnalysis#">
			        <TD valign="top" style="padding-top:5px" class="labelmedium" colspan="6">
						#vProblemAnalysisLabel#
					</td>
				</tr>
				
				<tr style="#vDisplayProblemAnalysis#">	
				
					<TD colspan="6" style="padding-left:4px">
					
					<cfif mode eq "edit">
					
			       	<cf_LanguageInput
						TableCode       = "ProgramPeriod" 
						Mode            = "Edit"
						Name            = "PeriodProblem"
						Value           = "#EditProgram.PeriodProblem#"
						Key1Value       = "#EditProgram.ProgramCode#"
						Key2Value       = "#EditProgram.Period#"
						Type            = "#vPeriodFieldsMode#"
						Required        = "Yes"
						LanguageDefault = "1"	
						Message         = ""
						Form            = "programform"
						Maxlength       = "10000"
						height          = "140"
						cols            = "69"
						rows            = "6"
						Class           = "regular">
						
					<cfelse>
					
					<cf_LanguageInput
						TableCode       = "ProgramPeriod" 
						Mode            = "View"
						Name            = "PeriodProblem"
						Value           = "#EditProgram.PeriodProblem#"
						Key1Value       = "#EditProgram.ProgramCode#"
						Key2Value       = "#EditProgram.Period#"
						Type            = "#vPeriodFieldsMode#"
						Required        = "Yes"
						LanguageDefault = "1"	
						Message         = ""
						Form            = "programform"
						Maxlength       = "10000"
						height          = "140"
						cols            = "69"
						rows            = "6"
						Class           = "regular">
					
					</cfif>	
					
				    </TD>
					
				</TR>	 
			
			<cfelse>
								 
		     <input type="hidden" name="PeriodProblem" id="PeriodProblem" value=""> 
						
			</cfif> 
					
		<TR>
		       <TD valign="top" style="padding-top:5px;padding-right:20px" class="labelmedium" colspan="6">
			   	#vRequirementsLabel#
			   </td>		
		</tr>
		
		<tr>   
								
		        <TD colspan="6">
								
				
				<cfif mode eq "edit">
								
				<cf_LanguageInput
					TableCode       = "ProgramPeriod" 
					Mode            = "Edit"
					Name            = "PeriodObjective"
					Value           = "#EditProgram.ProgramObjective#"
					Key1Value       = "#EditProgram.ProgramCode#"
					Key2Value       = "#EditProgram.Period#"
					Type            = "text"
					Required        = "No"
					LanguageDefault = "1"	
					Message         = ""
					Form            = "programform"
					Maxlength       = "30000"					
					cols            = "69"
					height          = "150"
					rows            = "13"
					Class           = "regular">	
					
				<cfelse>
				
				<cf_LanguageInput
					TableCode       = "ProgramPeriod" 
					Mode            = "View"
					Name            = "PeriodObjective"
					Value           = "#EditProgram.ProgramObjective#"
					Key1Value       = "#EditProgram.ProgramCode#"
					Key2Value       = "#EditProgram.Period#"
					Type            = "text"
					Required        = "No"
					LanguageDefault = "1"	
					Message         = ""
					Form            = "programform"
					Maxlength       = "30000"
					cols            = "69"
					height          = "150"
					rows            = "13"
					Class           = "regular">	
				
				
				</cfif>		
							
				</td>
			</tr>		
		
		<cfif mode eq "edit">					
				
			<cfquery name="StatusList" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  F.Code, 
				        F.Description, 					   
						F.StatusClass,					    							   							    	
					    S.Created,
						S.OfficerFirstName, 
					    S.OfficerLastName, 
					    S.ProgramStatus as Selected
				FROM    ProgramStatus S RIGHT OUTER JOIN
			            Ref_ProgramStatus F ON S.ProgramStatus = F.Code AND S.ProgramCode = '#URL.EditCode#'
				WHERE   F.Code IN (SELECT ProgramStatus
				                   FROM   Ref_ProgramStatusMission	   
							 	   WHERE  Mission = '#Mission#') 
				 AND    F.Operational = 1 
					 
			    ORDER By Description
			
			</cfquery>	
			
			<cfquery name="statusclasslist" dbtype="query">
				SELECT DISTINCT StatusClass
				FROM StatusList
			</cfquery>			
											    		
			<cfloop query="statusclasslist">
			
				<tr>
			    <td width="20%" class="labelmedium"><cf_tl id="#StatusClass#">:</td>
				    <td colspan="5" class="labelit">
					
					<cfquery name="StatusSelect" dbtype="query">
				       SELECT *
				       FROM   StatusList
					   WHERE  StatusClass = '#StatusClass#'					
				    </cfquery>
					
					<cfset fld = replaceNoCase(StatusClass," ","","ALL")>
																		 							 																								
					<select name="Status#fld#" class="regularxl enterastab">				
					 					
						 <cfloop query="StatusSelect">
						  <option value="#Code#" <cfif Selected eq Code> selected</cfif>>#Description#</option>
						 </cfloop>
					
					</select>
					
					</td>
				</tr>
			
			</cfloop>	
			
		</cfif>				
						
		</cfoutput>		
					
	</table>