<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfoutput>

<table width="95%" align="center" class="formspacing formpadding" cellspacing="0" cellpadding="0">	
	
	<tr><td height="5"></td></tr>		
		 
		
	<tr id="unit" class="<cfif scope eq 'unit'>regular<cfelse>hide</cfif>">
	
		<TD class="labelmedium"><cf_tl id="Managed by">:</TD>
		<TD>				
			
		 <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
				  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
				  onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission2','orgunitname','orgunitclass', document.getElementById('mission2').value, '#Mandate.MandateNo#')">
			
			<input type="text" name="orgunitname"    id="orgunitname" value="#ParentOrg.OrgUnitName#" class="regularxl enterastab" size="50" maxlength="60" readonly>
			<input type="hidden" name="orgunit"      id="orgunit"      value="#ParentOrg.OrgUnit#">
			<input type="hidden" name="orgunitcode"  id="orgunitcode"  value="#ParentOrg.OrgUnitCode#">
			<input type="hidden" name="mission2"     id="mission2"      value="#ParentOrg.Mission#">
			<input type="hidden" name="orgunitclass" id="orgunitclass" value="#ParentOrg.OrgUnitClass#" class="disabled" size="20" maxlength="20" readonly>
								
		</TD> 
	</tr>
	
	<TR>

	    <TD class="labelmedium">
			<cf_UItooltip tooltip="Organization that requested the program and that would be charged for its costs"><cf_tl id="Requester">:
			</cf_UItooltip>
		</TD>
		
    	<TD>
				
		<img src="#SESSION.root#/Images/contract.gif" alt="Select " name="img5" 
			  onMouseOver="document.img5.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img5.src='#SESSION.root#/Images/contract.gif'"
			  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
			  onclick="selectorgN('#Requester.mission#','','orgunit','applyorgunit','0','0','modal')">
			
		<input type="text" name="mission0" id="mission0" value="#Requester.Mission#" class="regularxl enterastab" size="8" maxlength="20" readonly> 
		<input type="text" name="orgunitname0" id="orgunitname0" value="#Requester.orgunitName#" class="regularxl enterastab" size="50" maxlength="80" readonly>	
			
		<button type="button" class="button3" name="blank" onClick="javascript:reqblank()">
		<img src="#SESSION.root#/images/delete5.gif" alt="" border="0">
		</button> 
		
		<input type="hidden" name="orgunit0" id="orgunit0" value="#Requester.orgunit#">
		<input type="hidden" name="orgunitcode0" id="orgunitcode0" value="#Requester.orgunitcode#"> 
						
	</TD>
	</TR>	
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Implementer">:</TD>
		
    <TD>
				
		 <img src="#SESSION.root#/Images/contract.gif" alt="Select" name="img4" 
			  onMouseOver="document.img4.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img4.src='#SESSION.root#/Images/contract.gif'"
			  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
			 onclick="selectorgN('#Implementer.mission#','','orgunit','applyorgunit','0','0','modal')">
			
		<input type="text" name="mission1" id="mission1" value="#Implementer.Mission#" class="regularxl enterastab" size="8" maxlength="20" readonly> 
		<input type="text" name="orgunitname1" id="orgunitname1" value="#Implementer.orgunitName#" class="regularxl enterastab" size="50" maxlength="80" readonly>	
			
		<button type="button" class="button3" name="blank" onClick="javascript:admblank()">
		<img src="#SESSION.root#/images/delete5.gif" alt="" border="0">
		</button> 
		<input type="hidden" name="orgunit1" id="orgunit1" value="#Implementer.orgunit#">
		<input type="hidden" name="orgunitcode1" id="orgunitcode1" value="#Implementer.orgunitcode#"></TD> 
		

	</TD>
	</TR>	
	
	<TR>	
		
			<TD class="labelmedium"><cf_tl id="Budget Preparation">:</TD>
		    <TD class="labelmedium">		
			   <table>
			   <tr class="labelmedium">
			   <td><input class="radiol" type="radio" name="ProgramAllotment" value="1" <cfif EditProgram.ProgramAllotment eq "1">Checked</cfif>></td>
			   <td style="padding-left:4px">Yes</td>
			   <td style="padding-left:7px"><input class="radiol" type="radio" name="ProgramAllotment" value="0" <cfif EditProgram.ProgramAllotment neq "1">Checked</cfif>></td>
			   <td style="padding-left:4px">No</td>
			   </tr>
			   </table> 
			</td>
		
		</tr>
		
		<TR>	
			<TD class="labelmedium"><cf_tl id="Allow for Service/Activity">:</TD>
		    <TD class="labelmedium">	
			
			   <table>
			   <tr class="labelmedium">
			   <td><input class="radiol" type="radio" name="isServiceParent" value="1" <cfif EditProgram.isServiceParent eq "1">Checked</cfif>></td>
			   <td style="padding-left:4px">Yes</td>
			   <td style="padding-left:7px"><input class="radiol" type="radio" name="isServiceParent" value="0" <cfif EditProgram.isServiceParent neq "1">Checked</cfif>></td>
			   <td style="padding-left:4px">No</td>
			   </tr>
			   </table> 		
			   
			</td>		
		</tr>
		
		<TR>	
			<TD class="labelmedium"><cf_tl id="Allow for Project to be added">:</TD>
		    <TD class="labelmedium">	
			    <table>
			   <tr class="labelmedium">
			   <td><input class="radiol" type="radio" name="isProjectParent" value="1" <cfif EditProgram.isProjectParent eq "1">Checked</cfif>></td>
			   <td style="padding-left:4px">Yes</td>
			   <td style="padding-left:7px"><input class="radiol" type="radio" name="isProjectParent" value="0" <cfif EditProgram.isProjectParent neq "1">Checked</cfif>></td>
			    <td style="padding-left:4px">No</td>
			   </tr>
			   </table> 					
			</td>
		
		</tr>
			
	<TR>
	<TD class="labelmedium"><cf_tl id="Allotment Account">:</TD>
	<td> 
		<table cellspacing="0" cellpadding="0">
		
		<tr>
		    <TD class="labelmedium"><cf_tl id="Budget1">:</TD>
			<TD style="padding-left:2px" class="labelmedium"><cf_tl id="Budget2">:</TD>
			<TD style="padding-left:2px" class="labelmedium"><cf_tl id="Budget3">:</TD>
			<TD style="padding-left:2px" class="labelmedium"><cf_tl id="Budget4">:</TD>
			<TD style="padding-left:2px" class="labelmedium"><cf_tl id="Budget5">:</TD>
		    <TD style="padding-left:2px" class="labelmedium"><cf_tl id="Budget6">:</TD>
		</tr>	
		
		<tr>
		   <TD><input type="text" class="regularxl enterastab" name="ReferenceBudget1" value="#EditProgram.ReferenceBudget1#" size="6" maxlength="8" style="text-align: center;"></td>
		   <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget2" value="#EditProgram.ReferenceBudget2#" size="6" maxlength="8" style="text-align: center;"></td>
		   <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget3" value="#EditProgram.ReferenceBudget3#" size="6" maxlength="8" style="text-align: center;"></td>
		   <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget4" value="#EditProgram.ReferenceBudget4#" size="6" maxlength="8" style="text-align: center;"></td>
	       <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget5" value="#EditProgram.ReferenceBudget5#" size="6" maxlength="8" style="text-align: center;"></td>	   
	       <TD style="padding-left:2px"><input type="text" class="regularxl enterastab" name="ReferenceBudget6" value="#EditProgram.ReferenceBudget6#" size="6" maxlength="8" style="text-align: center;"></td>	   
		</tr>
		</table>
	</td>
	</tr>
	
    <!--- Field: Program Officer --->

    <TR>
    <TD class="labelmedium"><cf_tl id="Contact">:</TD>
    <TD class="regular">	
		<CFINPUT type="text" class="regularxl enterastab" name="ProgramManager" value="#EditProgram.ProgramManager#" maxLength="200" size="60">	
	</TD>
	</TR>	
	
	<tr><td class="labelmedium"><cf_tl id="Relative Order">:</td>
	<td>
	<cfinput type="Text" class="regularxl enterastab" name="ListingOrder" value="#EditProgram.ListingOrder#" validate="integer" required="No" size="2" maxlength="2" style="text-align: center;">		
	</TD>
	</TR>	
	
    <!--- Field: Program Officer --->

    <TR>
    <TD class="labelmedium">
		<cf_UItooltip tooltip="External reference is used for mapping of external KPI observations"><cf_tl id="External reference">:</cf_UItooltip>
	</TD>
    <TD>		
	<CFINPUT type="text" class="regularxl enterastab" name="Reference" value="#EditProgram.Reference#" maxLength="20" size="20">
	</TD>
	</TR>	

    <!--- Field: Program Memo --->

	<TR>
        <TD valign="top" style="padding-top:2px" class="labelmedium"><cf_tl id="Memo">:</td>		
        <TD><textarea style="width:95%" class="regular" rows="4" name="Memo">#EditProgram.ProgramMemo#</textarea></TD>		
	</TR>
		
	<tr><td colspan="2" align="center" height="30">

		<cfquery name="Check" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM  ProgramPeriod
		 WHERE PeriodParentCode = '#EditProgram.ProgramCode#'		
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
		
		
		<cf_tl id="Close" var="1">
		<input type="button" name="cancel" value="#lt_text# " class="button10g" style="height:25;width:120" onClick="window.close()">	
		
		<cfif check.recordcount eq "0" 
		   and Position.recordcount eq "0"
		   and Purchase.recordcount eq "0"
		   and Ledger.recordcount eq "0">
		<cf_tl id="Delete" var="1">
		<input class="button10g" style="height:25;width:120" type="button" onclick="validate('delete')" name="Delete"  value="#lt_text#">
		</cfif>		
		<cf_tl id="Submit" var="1">		
		<input class="button10g" style="height:25;width:120" type="button" onclick="validate('add')" name="Save" value="#lt_text#">
				   
	</td></tr>		
		
</table>

</cfoutput>