

<table width="98%">

		<!--- check access = program manager --->
		
		<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
			Method         = "budget"
			Mission        = "#ParentOrg.Mission#"
			Period         = "#url.Period#"				
			Role           = "'ProgramManager'"
			ReturnVariable = "ProgramAccess">
		
		<tr><td height="4"></td></tr>
		
		<tr class="line"><td colspan="6" style="height:37px;font-size:24px;padding-left:4px" class="labellarge"><cf_tl id="Actors and Partners"></td></tr>	
				
		<cfoutput>	
			<INPUT type="hidden" name="orgunit" id="orgunit" value="#Org#">
		</cfoutput>	
						
		<cfif update eq "yes">
			
				<tr class="line" style="background-color:f3f3f3"><td colspan="3" height="35" style="padding-left:10px">
					<table cellspacing="0" cellpadding="0">
						<tr class="labelmedium">
						<td><input type="radio" class="radiol" name="toggle" id="toggle1" value="unit" checked onclick="togglebox('unit')"></td>
						<td style="padding-left:4px;cursor:pointer" onclick="document.getElementById('toggle1').click()"><cf_tl id="Move responsibility"></td>
					    <cfif Access eq "ALL" or ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">						
						<td style="padding-left:10px"><input type="radio" name="toggle" class="radiol" id="toggle2" value="action" onclick="togglebox('action')"></td>
						<td style="padding-left:4px;cursor:pointer" onclick="document.getElementById('toggle2').click()"><cf_tl id="Move under different Program">/<cf_tl id="Project"></td>		
						</cfif>
						</tr>
					</table>	
				</td></tr>
								
				<tr><td height="4"></td></tr>
												
				<TR name="unitmove">
				
			   	    <TD style="padding-left:10px;width:20%" class="labelmedium"><cf_tl id="Unit">:</TD>
					<td height="23" style="width:80%">
				
					<cfquery name="OrgSel"
			         datasource="AppsOrganization"        
			         username="#SESSION.login#"
			         password="#SESSION.dbpw#">
					  	SELECT   Mission,MandateNo,HierarchyCode
						FROM     Organization
						WHERE    OrgUnit = '#Org#'
					</cfquery>  
					
					<cfquery name="Unit"
			         datasource="AppsOrganization"        
			         username="#SESSION.login#"
			         password="#SESSION.dbpw#">
						  SELECT   * 
						  FROM     Organization
						  WHERE    Mission     = '#Orgsel.Mission#' 
						  AND      MandateNo   = '#Orgsel.MandateNo#'
						  <cfif getAdministrator("*") eq "0">
						  AND      HierarchyCode LIKE '#left(OrgSel.HierarchyCode,2)#%'
						  </cfif>
						  ORDER BY HierarchyCode
					</cfquery>  
					
					<select name="OrgUnitNew" class="regularxl" onchange="document.getElementById('OrgUnit').value=this.value">
						<cfoutput query="Unit">
							<option value="#OrgUnit#" <cfif Org eq OrgUnit>selected</cfif>>#hierarchycode# #OrgUnitName#</option>		
						</cfoutput>
					</select>
				
					</td>
					
				</tr>
							
				<cfoutput>	
				
				<TR name="unitmove">
			    	<TD height="25" style="padding-left:10px;width:20%" class="labelmedium"><cf_tl id="Program">:</TD>
				    <TD style="width:80%"class="labelmedium">#Parent.ProgramName#</td>		
				</tr>
				
				</cfoutput>			
						
			</cfif>	
			
			<cfif EditProgram.ProgramScope eq "Unit">
			
			    <cfoutput>				
				
								
				<tr id="actionmove" class="hide">
				    <td  style="padding-left:10px" width="16%" class="labelmedium"><cf_tl id="Unit">:</td>
					
					 <TD><input type="text" 
				                class="regularxl"
								id="orgunitname"  
								name="orgunitname" 
								value="#OrgUnitName#" 
								size="58" 
								maxlength="60" 
								readonly>
					</TD>	
					
				</tr>
		
				<tr name="actionmove" class="hide">
				    <td style="padding-left:10px" class="labelmedium"><cf_tl id="Parent">:</td>
					
					 <TD>
					 
					 <table>
					 <tr><td>
					 
					 <input type="text" 
					         class="regularxl" 
							 name="parentcodename"
							 id="parentcodename"  
							 value="#Parent.ProgramName#" 
							 size="68" 
							 maxlength="60" readonly>	
					</td>	
					
					 <TD style="height:30px;padding-left:3px">
		    	
				    	<button class="button10g" 
							   name="search1" 
							   type="button"
							   style="width:30px;height:25px" 
							   onClick="selectprogramme('#ParentOrg.Mission#','#URL.Period#','#OrgParent.OrgUnit#','#EditProgram.OrgUnit#','#URL.EditCode#','setprogram')">			
							   <cf_tl id="...">
						</button>	   
						    
					
					</td></tr>
					</table>
					
					</td>
					
					 
				</tr>
				
				</cfoutput>			
		
			</cfif>
	
	    <cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">
				
			<TR>
		    <TD class="labelmedium" style="padding-left:10px">
				<cf_UItooltip tooltip="Organization that requested the program and that would be charged for its costs"><cf_tl id="Requester">:</cf_UItooltip>
			</TD>
				
		    <TD class="labelmedium">
			
			<table cellspacing="0" cellpadding="0" class="formspacing">
			<tr><td>
			<cfoutput>
			
			 <img src="#SESSION.root#/Images/search.png" alt="Select Unit" name="img5" 
				  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
				 onClick="selectorgN('#Implementer.Mission#','','orgunit0','setorgunit')">
				 
			</td>
			<td>		
			<input type="text" name="orgunit0mission" id="orgunit0mission" value="#Requester.Mission#" class="regularxl enterastab" size="8" maxlength="20" readonly> 
			</td>
			<td>
			<input type="text" name="orgunit0name" id="orgunit0name" value="#Requester.orgunitName#" class="regularxl enterastab" size="49" maxlength="80" readonly>	
			</td>
			<td>	
			<button type="button" class="button3" name="blank" onClick="javascript:reqblank()">
			<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
			</button> 
			</td>
			<input type="hidden" name="orgunit0"      id="orgunit0"      value="#Requester.orgunit#">
			</TD> 
			
			</cfoutput>	
			
			</td></tr></table>
			</TD>
			</TR>	
		
		<cfelse>	
		
		<cfoutput>
			<input type="hidden" name="orgunit0" id="orgunit0" value="#Requester.orgunit#">
		</cfoutput>
		
		</cfif>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="Implementer">:<cf_space spaces="35"></TD>		
		    <TD class="labelmedium">
			
			<table cellspacing="0" cellpadding="0" class="formspacing">
			
			<tr><td>
			<cfoutput>
			
			 <img src="#SESSION.root#/Images/search.png" alt="Select" name="img4" 
				  onMouseOver="document.img4.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img4.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" 
				  width="25" height="25" border="0" 
				  align="absmiddle" 
				  onClick="selectorgmisn('#Implementer.mission#','#Implementer.mandateno#','')">
				 
				  
			</td>
			
			<td><input type="text" name="mission1" id="mission1"             value="#Implementer.Mission#"     class="regularxl enterastab" size="8" maxlength="20" readonly></td>
			<td><input type="text" name="orgunitname1" id="orgunitname1"     value="#Implementer.orgunitName#" class="regularxl enterastab" size="49" maxlength="80" readonly></td>		
			<td><button type="button" class="button3" name="blank"           onClick="javascript:admblank()">
			     <img src="#SESSION.root#/Images/delete5.gif" alt="" border="0"></button>
			</td>		
			<input type="hidden" name="orgunit1" id="orgunit1"           value="#Implementer.orgunit#">
			<input type="hidden" name="orgunitcode1" id="orgunitcode1"   value="#Implementer.orgunitcode#">
			<input type="hidden" name="orgunitclass1" id="orgunitclass1" value="#Implementer.orgunitclass#"     class="disabled" size="20" maxlength="20" readonly>
			</td></tr>
			
			</table>
			</cfoutput>	
			
			</TD>
		</TR>	
				
		<cfloop index="itm" from="1" to="4">
				
			<cfquery name="Orgunit"
			datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			    SELECT Pe.*,O.Mission, O.OrgUnitName, O.OrgUnitCode, O.OrgUnitClass
			    FROM  ProgramPeriodOrgUnit Pe, Organization.dbo.Organization O
				WHERE Pe.OrgUnit = O.OrgUnit
				AND   Pe.Period         = '#URL.Period#'
				AND   Pe.ProgramCode    = '#URL.EditCode#'
				AND   Pe.ListingOrder   = '#itm#'
			</cfquery>
		
			<TR>
		    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="Partner"> <cfoutput>#itm#</cfoutput>:</TD>		
			    <TD class="labelmedium">
				
				<cfif Parameter.TreePartner neq "">
						<cfset mis = Parameter.TreePartner>	
				<cfelse>
						<cfset mis = implementer.mission>
				</cfif>						
				
					<cfoutput>
					
						<table cellspacing="0" cellpadding="0" class="formspacing">
						<tr>
						<td>			
						
						 <img src="#SESSION.root#/Images/search.png" alt="Select" name="img4#itm#" 
							  onMouseOver="document.img4#itm#.src='#SESSION.root#/Images/contract.gif'" 
							  onMouseOut="document.img4#itm#.src='#SESSION.root#/Images/search.png'"
							  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
							  onClick="selectorgN('#mis#','','orgunitpartner#itm#','setorgunit')">
							 
						</td>	
														
						<td><input type="text" id="orgunitpartner#itm#mission" value="#OrgUnit.Mission#" class="regularxl enterastab" size="8" maxlength="20" readonly></td>
						<td><input type="text" id="orgunitpartner#itm#name"    value="#OrgUnit.orgunitName#" class="regularxl enterastab" size="49" maxlength="80" readonly></td>		
						<td><button type="button" class="button3" name="blank" onClick="partnerblank('#itm#')"><img src="#SESSION.root#/Images/delete5.gif" alt="" border="0"></button></td>		
						
						<input type="hidden" id="orgunitpartner#itm#"   name="orgunitpartner#itm#"    value="#OrgUnit.orgunit#">
						
						</tr>
						</table>
					
					</cfoutput>	
				
				</TD>
			</TR>	
		
		</cfloop>		
				
		<!--- check access = budget manager --->
		
		<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
			Method         = "budget"
			Mission        = "#ParentOrg.Mission#"
			Period         = "#url.Period#"				
			Role           = "'BudgetManager'"
			ReturnVariable = "BudgetAccess">
			
		<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">		
			
			<cfquery name="Check"
		     datasource="AppsProgram"
		     username="#SESSION.login#"
		     password="#SESSION.dbpw#">
		     	SELECT  ProgramClass
			    FROM    Program
			    WHERE   ProgramCode = '#ParentCode#'
		    </cfquery>
			
			<tr><td colspan="6" height="5"></td></tr>	
			<tr class="line"><td colspan="6" style="height:47px;font-size:24px;padding-left:4px" class="labelmedium"><cf_tl id="Budget Settings"><span style="font-size:15px">[Budget Manager only]</span></td></tr>	
							
			<cfoutput>
			
			<TR><TD class="labelmedium" style="height:25px;padding-left:10px"><cf_tl id="Allotment">:</TD>
			    <TD class="labelmedium" style="padding-left:4px">
				    <table><tr>
					<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="ProgramAllotment" value="1" <cfif EditProgram.ProgramAllotment neq "0" >Checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">Yes</td>
					<td style="padding-left:7px"><input type="radio" class="radiol enterastab" name="ProgramAllotment" value="9" <cfif EditProgram.ProgramAllotment eq "9">Checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">No, disabled</td>
					</tr>
					</table>			
				</td>		
			</tr>
			
			<input type="hidden" name="ProgramAllocation" value="0">
			
			<TR>	
				<TD class="labelmedium" style="height:25px;padding-left:10px"><cf_tl id="Requirements">:</TD>
			    <TD class="labelmedium" style="padding-left:4px">
					<table><tr>
					<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="EnforceAllotmentRequest" value="1" <cfif EditProgram.EnforceAllotmentRequest eq "1" or EditProgram.EnforceAllotmentRequest eq "">Checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">Enforce</td>
					<td style="padding-left:7px"><input type="radio" name="EnforceAllotmentRequest" class="radiol enterastab" value="0" <cfif EditProgram.EnforceAllotmentRequest eq "0">Checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">Rule by Edition settings</td>
					</tr>
					</table>						
				</td>		
			</tr>
			
			<TR>
			<TD class="labelmedium" style="padding-top:16px;padding-left:10px"><cf_tl id="Budget Account">:</TD>
			<td> 
				<table width="400" cellspacing="0" cellpadding="0">
				<tr bgcolor="E6E6E6">
			    <TD style="text-align:center;border:1px solid silver" class="labelit"><cf_tl id="Budget1"></TD>
				<TD style="text-align:center;border:1px solid silver" class="labelit"><cf_tl id="Budget2"></TD>
				<TD style="text-align:center;border:1px solid silver" class="labelit"><cf_tl id="Budget3"></TD>
				<TD style="text-align:center;border:1px solid silver" class="labelit"><cf_tl id="Budget4"></TD>
				<TD style="text-align:center;border:1px solid silver" class="labelit"><cf_tl id="Budget5"></TD>
			    <TD style="text-align:center;border:1px solid silver" class="labelit"><cf_tl id="Budget6"></TD>
				</tr>	
				<tr>
				   <TD style="border:1px solid silver"><input type="text" class="regularh enterastab" name="ReferenceBudget1" value="#EditProgram.ReferenceBudget1#" size="4" maxlength="6" style="border:0px;"></td>
				   <TD style="border:1px solid silver"><input type="text" class="regularh enterastab" name="ReferenceBudget2" value="#EditProgram.ReferenceBudget2#" size="4" maxlength="6" style="border:0px;"></td>
				   <TD style="border:1px solid silver"><input type="text" class="regularh enterastab" name="ReferenceBudget3" value="#EditProgram.ReferenceBudget3#" size="4" maxlength="6" style="border:0px;"></td>
				   <TD style="border:1px solid silver"><input type="text" class="regularh enterastab" name="ReferenceBudget4" value="#EditProgram.ReferenceBudget4#" size="4" maxlength="6" style="border:0px;"></td>
			       <TD style="border:1px solid silver"><input type="text" class="regularh enterastab" name="ReferenceBudget5" value="#EditProgram.ReferenceBudget5#" size="4" maxlength="6" style="border:0px;"></td>	   
			       <TD style="border:1px solid silver"><input type="text" class="regularh enterastab" name="ReferenceBudget6" value="#EditProgram.ReferenceBudget6#" size="4" maxlength="6" style="border:0px;"></td>	   
				</tr>
				</table>
			</td>
			</tr>	
						
			</cfoutput>
		
		</cfif>
										
		
		<tr class="line"><td colspan="6" style="height:47px;font-size:24px;padding-left:4px" class="labelmedium"><cf_tl id="Miscellaneous"></td></tr>	
		<tr><td height="3"></td></tr>		
		<TR>
	
		    <TD class="labelmedium" style="padding-left:10px"style="cursor:pointer">
				<cf_UItooltip tooltip="The code of the project as used by external system, such as indicator measurement source">
					<cf_tl id="Short Name">:
				</cf_UItooltip>
			</TD>
		    <td colspan="5">
			<cfoutput>
				<input type="text" class="regularxl enterastab" name="ProgramNameShort" value="#EditProgram.ProgramNameShort#" size="35" maxlength="50">
			</cfoutput>			
			</td>
		</tr>
				
		<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">
		
		<TR><TD class="labelmedium" style="height:30px;padding-left:10px"><cf_tl id="Presentation">:</TD>
			    <TD class="labelmedium">
				    <table><tr>
					<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="Presentation" value="1" <cfif EditProgram.Presentation neq "0" >Checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">Yes</td>
					<td style="padding-left:7px"><input type="radio" class="radiol enterastab" name="Presentation" value="0" <cfif EditProgram.Presentation eq "0">Checked</cfif>></td>
					<td class="labelmedium" style="padding-left:4px">No</td>
					</tr>
					</table>			
				</td>		
			</tr>
		
		<TR>	
			<TD class="labelmedium" style="height:30px;padding-left:10px"><cf_tl id="Status Handling">:</TD>
		    <TD class="labelmedium">	
				<table><tr>
				<td style="padding-left:0px"><input type="radio" name="Status" class="radiol enterastab" value="1" <cfif EditProgram.Status eq "1">Checked</cfif>></td>
				<td class="labelmedium" style="padding-left:4px"><cf_tl id="Locked"></td>
				<td style="padding-left:7px"><input type="radio" name="Status" class="radiol enterastab" value="0" <cfif EditProgram.Status eq "0" or EditProgram.Status eq "">Checked</cfif>></td>
				<td class="labelmedium" style="padding-left:4px"> <cf_tl id="Extend access to mode ALL"></td>	
				</tr>
				</table>
			</td>		
		</tr>	
				
		<tr>
		<td class="labelmedium" style="padding-left:10px">	
		<cf_tl id="Weight">:
		</td>
		<td colspan="5">
		
			<cfif EditProgram.ProgramWeight eq "">
				<cfset wgt = "1">
			<cfelse> 
				<cfset wgt = "#EditProgram.ProgramWeight#">
			</cfif>
			
			<cfinput type="Text" class="regularxl enterastab" name="ProgramWeight" value="#wgt#" validate="integer" required="No" size="2" maxlength="2" style="text-align: center;">
		
		</TD>
		</TR>	
		
		<cfelse>
		
		<cfif EditProgram.ProgramWeight eq "">
				<cfset wgt = "1">
			<cfelse> 
				<cfset wgt = "#EditProgram.ProgramWeight#">
			</cfif>
		
		<cfoutput>
		<input type="hidden" name="Status" value="#EditProgram.Status#">
		<input type="hidden" name="ProgramWeight" value="#wgt#">
		
		</cfoutput>
		
		</cfif>
		
		<cfif EditProgram.ListingOrder eq "">
				<cfset srt = "1">
			<cfelse> 
				<cfset srt = "#EditProgram.ListingOrder#">
			</cfif>
			
		<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL">	
		
		<tr><td height="4"></td></tr>
		<tr>
			<td class="labelmedium" style="padding-left:10px"><cf_tl id="Relative Sort">:</td>
			<td colspan="5">
			   <cfinput type="Text" class="regularxl enterastab" name="ListingOrder" value="#srt#" validate="integer" required="No" size="2" maxlength="2" style="text-align: center;">
			</TD>
		</tr>
		
		<cfelse>
		
		<cfoutput>
		
		<input type="hidden" name="ListingOrder" value="#srt#">
		
		</cfoutput>
		
		</cfif>
		<tr><td height="4"></td></tr>
		<TR>
	        <TD class="labelmedium" valign="top" style="padding-top:3px;padding-left:10px" colspan="1"><cf_tl id="Memo">:</td>
			<cfoutput>
	        <TD colspan="5">
			    <textarea class="regular" style="width:95%;height:30;font-size:13px;padding:3px;" 
			    name="Memo">#EditProgram.ProgramMemo#</textarea> 
			</TD>
			</cfoutput>
		</TR>	
		<tr><td height="4"></td></tr>
		
</table>