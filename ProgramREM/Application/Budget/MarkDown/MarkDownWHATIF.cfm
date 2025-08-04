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

<!--- generate action table --->

<cf_assignId>


<cfparam name="url.programselect" default="">
<cfparam name="url.objectselect" default="">

<cfif url.objectselect eq "" or url.programselect eq "">
	
 	<table cellspacing="0" cellpadding="0" align="center" class="formpadding">
	     <tr><td align="center" height="40" class="labelmedium">
        	 <font color="808080">There are no items to show in this view.</font>
     	     </td>
		 </tr>
	</table>
 
	<cfabort>


</cfif>

<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  TOP 1 P.Mission,RequirementId
	  FROM    Program AS P INNER JOIN
	          ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
	          Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
			  ProgramAllotmentRequest AS A ON A.ProgramCode = P.ProgramCode
	  <!--- selected programs --->		  
	  WHERE   Pe.ProgramId IN (#preservesinglequotes(url.programselect)#)					
	  <!--- selected objects --->
	  AND     A.ObjectCode IN (#preservesinglequotes(url.objectselect)#)		
	  AND     A.ActionStatus != '9'				 	
</cfquery>	
  
<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ParameterMission
	  WHERE   Mission = '#Check.mission#'		 	
</cfquery>	  

<cfif Check.recordcount eq "0">
 
 	<table cellspacing="0" cellpadding="0" align="center" class="formpadding">
	     <tr><td align="center" height="40" class="labelmedium">
        	 <font color="808080">There are no items to show in this view.</font>
     	     </td>
		 </tr>
	</table>
 
	<cfabort>
 
</cfif> 

<cfform method="POST" name="markdown"> 

<cfoutput>
<table width="94%" align="center"cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td colspan="2" height="10"></td></tr>
	
	<tr><td colspan="2" class="labelit" style="font-weight:200;height:40px;font-size:25px"><cf_tl id="Markdown Action">#check.mission#</td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	<tr>
			
		<td colspan="2" style="padding-top:4px">
			<input type="hidden" name="Mission" value="#Check.mission#">
		<table width="70%" align="center" class="formpadding">
		
			
		
			<tr>
			<td><input type="radio" class="radiol" checked name="selection" value="amount"></td>
			<td class="labelmedium">Adjust lines so the <b>total</b> value will be equal to:</td>
			<td class="labelmedium"><input 
			    type="text" 
				style="text-align:right" 
				class="regularxl" 
				name="amount"
				size="10" 
				maxlength="20"> #Param.BudgetCurrency#</td>
			</tr>
			<tr></tr>
			<tr>
			<td><input type="radio" class="radiol" name="selection" value="percentage"></td>
			<td class="labelmedium">OR Decrease all <b>amounts</b> with:</td>
			<td class="labelmedium"><input type="text" 
			   style="text-align:right;width:29px" 
			   class="regularxl" 
			   name="percentage" 			   		  			   
			   maxlength="4"> %
			</td>
			</tr>	
			<tr class="line">
			<td><input type="radio" class="radiol" name="selection" value="standardcost"></td>
			<td class="labelmedium">OR apply last standard costs effective prior:</td>
			<td class="labelmedium">
						
				<cf_intelliCalendarDate9
					FieldName="DateEffective" 
					Manual="True"		
					class="regularxl"										
					Default="#dateformat(now(),client.dateformatshow)#"
					AllowBlank="False">	
						
			</td>
			</tr>	
			
			<tr>
			<td style="height:30px" colspan="3">
				<input type="button" name="Prepare" onclick="applymarkdown('#rowguid#')" value="Apply" class="button10g">
			</td>
			</tr>
			
		</table>
		</td>
	
	</tr>
	<tr><td height="4"></td></tr>
		
	<tr class="line"><td colspan="2" class="labelit" style="height:40px;font-weight:200;font-size:25px"><cf_tl id="Proposed values"></td></tr>
	
	<tr>
	<td colspan="2" id="whatifresult">
	
	<cfinclude template="MarkDownSelected.cfm">
			
	</td>
	</tr>
		
</table>

</cfoutput>

</cfform> 

<cfset ajaxonload("doCalendar")>