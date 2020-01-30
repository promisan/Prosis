	
<table width="100%" cellspacing="0" cellpadding="0" align="center" border="0">
		
		<tr>
		<td class="labelit" height="17" style="padding-left:5px">Fund</td>
		<td class="labelit" align="right">Budg</td>
		<td class="labelit" align="right">Def</td>
		<td class="labelit" align="center" style="cursor: pointer;"><cf_UIToolTip  tooltip="Define a percentage between 0 and 100 to release funds for budget execution"><font color="0080C0">Rel%</cf_UIToolTip></td>
		
		<td class="labelit" height="17" style="padding-left:5px">Fund</td>
		<td class="labelit" align="right">Budg</td>
		<td class="labelit" align="right">Def</td>
		<td class="labelit" align="center" style="cursor: pointer;"><cf_UIToolTip  tooltip="Define a percentage between 0 and 100 to release funds for budget execution"><font color="0080C0">Rel%</cf_UIToolTip></td>
					
		<td class="labelit" height="17" style="padding-left:5px">Fund</td>
		<td class="labelit" align="right">Budg</td>
		<td class="labelit" align="right">Def</td>
		<td class="labelit" align="center" style="cursor: pointer;"><cf_UIToolTip  tooltip="Define a percentage between 0 and 100 to release funds for budget execution"><font color="0080C0">Rel%</cf_UIToolTip></td>
				
		<td class="labelit" height="17" style="padding-left:5px">Fund</td>
		<td class="labelit" align="right">Budg</td>
		<td class="labelit" align="right">Def</td>
		<td class="labelit" align="center" style="cursor: pointer;"><cf_UIToolTip  tooltip="Define a percentage between 0 and 100 to release funds for budget execution"><font color="0080C0">Rel%</cf_UIToolTip></td>
	
			
		</tr>
		
		<tr><td height="1" colspan="14" class="linedotted"></td></tr>
		
		<cfset row = 0>
		
	    <cfoutput query="Fund">
		
		<cfset row = row+1>
		
		<cfif row eq "1"><tr></cfif>
					
		   <td class="labelit" style="border-left:0px solid gray;padding-left:1px">	
				 
			<cfquery name="Check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT F.*, 
				       (SELECT sum(Amount) 
					    FROM   ProgramAllotmentDetail 
						WHERE  EditionId = '#URL.ID1#' 
						AND    Fund = '#Code#'
						AND Amount > 0) as Used 
				FROM   Ref_AllotmentEditionFund F
				WHERE  F.EditionId = '#URL.ID1#'
				AND    F.Fund = '#Code#' 
			</cfquery>		
			
			<cfif Check.Used lte "1">
				<input type="checkbox" class="radiol"
				  onclick="togglefund('#code#',this.checked)" 
				  name="fund_#code#" 
				  value="#Code#" <cfif Check.RECORDCOUNT eq "1">checked</cfif>> #Code#
			<cfelse>
				<input type="checkbox" disabled value="#Code#" <cfif Check.RECORDCOUNT eq "1">checked</cfif>> <font color="808080">#Code#</font>
				<input type="hidden" name="fund_#code#" value="#Code#">
			</cfif>
							
			</td>
						
			<cfif check.recordcount eq "1">
			    <cfset cl = "">
			<cfelse>
			     <cfset cl = "disabled"> 
			</cfif>
			
			<td align="right" class="labelit">
			     <font color="gray">#numberformat(check.used,"_,__")#</font>
			</td>
									
			<td align="right" id="def_#code#">						
				<input type="radio" class="radiol" name="funddefault" #cl# value="#code#" <cfif Check.fundDefault eq "1">checked</cfif>> 			    
			</td>
			
			<td align="right" class="labelit" style="padding-right:8px">
			
			    <cfif check.PercentageRelease eq "">
				  <cfset rel = 100>
				<cfelse>
				  <cfset rel = check.PercentageRelease>  
				</cfif>
				
				<cfif check.recordcount eq "1">
				
				<cfinput type="Text"
				       name="perc_#code#"
					   class="regularh"
					   style="width:34;text-align:center"				  
				       range="0,100"
					   value="#rel#"				  
				       validate="integer"
				       required="Yes"
				       visible="Yes"
				       enabled="Yes"
					   maxlength="3">
				   
				 <cfelse>
				 
				 <cfinput type="Text"
				       name="perc_#code#"
					   style="width:34;text-align:center"
					   class="regularh"				   
				       range="0,100"
					   value="#rel#"
					   disabled				 
				       validate="integer"
				       required="Yes"
				       visible="Yes"
				       enabled="Yes"
					   maxlength="3">			 
				 
				 </cfif>
				   				   
			</td> 
			
			<cfif row eq "4">			
			</tr><cfset row = 0>
			<cfelse>
			
			</cfif>
						
		</cfoutput>
		
</table>
	