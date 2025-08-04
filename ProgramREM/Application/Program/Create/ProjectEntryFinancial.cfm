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

<!-- <cfform> -->

<cfparam name="url.mode" default="edit">

<table width="94%" align="center" class="formpadding">
				
	<TR class="labelmedium line">		    
	    <td height="20" colspan="2"><cf_tl id="Metric"></td>  
		<TD><cf_tl id="Reference"></TD>
		<td width="130"><cf_tl id="Officer"></td>
		<td width="4"></td>
	</TR>
	
	<cfinvoke component="Service.Process.Program.Category"  
	   method         = "ReferenceTableControl" 
	   ControlObject  = "Ref_ProgramFinancial"	
	   Mission        = "#ParentOrg.Mission#"   
	   ProgramCode    = "#url.ProgramCode#" 
	   Period         = "#url.period#"	   
	   returnvariable = "control">		
			
	<cfquery name="Metrics" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT   *		       
		FROM     Ref_ProgramFinancial F
		<!--- exists for the entity --->
		WHERE    Code IN (SELECT Code FROM Ref_ProgramFinancialControl WHERE Mission = '#ParentOrg.Mission#')		
		<!--- not disabled for this program --->
		<cfif control.deny neq "">
		AND       Code NOT IN (#preservesingleQuotes(control.deny)#)
		</cfif>		 
		
		<!--- we obtain any code that belongs to the category : 22/10 we moved this out to Ref_ProgramFinancialControl
		which does not mean the below table can't have a function as well --->
		<!---
		WHERE    Code IN (SELECT Code 
		                  FROM   Ref_ProgramFinancialCategory
						  WHERE  ProgramCategory IN (SELECT S.Code
						                             FROM   ProgramCategory P 
													        INNER JOIN Ref_ProgramCategory R ON P.ProgramCategory = R.Code
															INNER JOIN Ref_ProgramCategory S ON R.AreaCode = S.AreaCode
													 WHERE  P.ProgramCode = '#url.programcode#'		
											 )
					     )		                      
		--->		
		
		
	    ORDER BY ListingOrder
		
	</cfquery>	
					
	<cfoutput query="Metrics">
	
		<cfquery name="Last" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     ProgramFinancial S 
			WHERE    Code        = '#code#'
			AND      ProgramCode = '#URL.ProgramCode#'
		    ORDER BY DateEffective DESC
		</cfquery>
	
		<TR class="labelmedium">
					  				
			<TD  height="31" style="padding-left:4px" width="160">#Description#:
				<input type="hidden" name="Metric_#Code#" id="Metric_#Code#" value="#Code#" size="4" maxlength="4"></td>
			</TD>
			
			<cfif url.mode eq "edit">
			
				<TD>	
				
				 <table cellspacing="0" cellpadding="0"><tr><td style="padding:4px">
				 
					<cfinput type="Text"
				       name="MetricsPlanned_#Code#"
				       validateat="onBlur"
				       validate="float"
				       required="No"
					   class="regularxxl"				  
					   value="#numberformat(last.AmountPlanned,',__')#"
					   message="Please enter a correct amount"
					   style="width:80;text-align:right"
				       visible="Yes"
				       enabled="Yes">
				   
				   </td><td>&nbsp;</td><td>#APPLICATION.BaseCurrency#</td></tr>
				 </table>
			   			  
				</TD>
				<td>
				<input type="text" class="regularxxl" name="MetricsReference_#Code#" value="#last.Reference#" size="20" maxlength="20">
				</td>
									
			<cfelse>
											
				<cfif last.amountplanned gt "0">
				
					<td height="20">
					<table>
						<tr class="labelmedium">
						<td width="56">
						#APPLICATION.BaseCurrency#
						</td>
						<td>
						#numberformat(Last.AmountPlanned,",__")#
						</td>
						</tr>
					</table>
					</td>	
				
				<cfelse>
				
					<td>--</td>				
					
				</cfif>
			
			<td>#last.reference#</td>
			
			</cfif>	
							
			<td>#last.officerfirstName# #last.officerLastName# <font size="1">(#dateformat(last.created,CLIENT.DateFormatShow)# #timeformat(last.created,"HH:MM")#)</font></td>	
			<td></td>				
			
	</TR>			
		
	</CFOUTPUT>	
	
</table>	

<!-- </cfform> -->
			