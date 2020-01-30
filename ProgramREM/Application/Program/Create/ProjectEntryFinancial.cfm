
<!-- <cfform> -->

<cfparam name="url.mode" default="edit">

<table width="94%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
	<TR class="labelit">		    
	    <td height="20" colspan="2"><cf_tl id="Metric"></td>  
		<TD><cf_tl id="Reference"></TD>
		<td width="130"><cf_tl id="Officer"></td>
		<td width="4"></td>
	</TR>
					
	<tr><td colspan="6" height="1" class="linedotted"></td></tr>
	
	<cfquery name="Metrics" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT   *		       
		FROM     Ref_ProgramFinancial F
		WHERE    Code IN (SELECT Code 
		                  FROM   Ref_ProgramFinancialCategory
						  WHERE  ProgramCategory IN (SELECT S.Code
						                             FROM   ProgramCategory P, 
													        Ref_ProgramCategory R,
															Ref_ProgramCategory S
													 WHERE  P.ProgramCategory = R.Code
													 AND    R.Area = S.Area
													 AND    P.ProgramCode = '#url.programcode#'													 )
					     )		                      
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
	
		<TR>
					  				
			<TD  class="labelmedium" height="31" width="160">&nbsp;#Description#:
				<input type="hidden" name="Metric_#currentRow#" id="Metric_#currentRow#" value="#Code#" size="4" maxlength="4"></td>
			</TD>
			
			<cfif url.mode eq "edit">
			
				<TD>	
				
				 <table cellspacing="0" cellpadding="0"><tr><td style="padding:4px">
				 
					<cfinput type="Text"
				       name="MetricsPlanned_#currentRow#"
				       validateat="onBlur"
				       validate="float"
				       required="No"
					   class="regularxl"				  
					   value="#numberformat(last.AmountPlanned,'__,__')#"
					   message="Please enter a correct amount"
					   style="width:60;text-align:right"
				       visible="Yes"
				       enabled="Yes">
				   
				   </td><td>&nbsp;</td><td>#APPLICATION.BaseCurrency#</td></tr>
				 </table>
			   			  
				</TD>
				<td>
				<input type="text" class="regularxl" name="MetricsReference_#currentRow#" value="#last.Reference#" size="20" maxlength="20">
				</td>
									
			<cfelse>
											
				<cfif last.amountplanned gt "0">
				
					<td height="20">
					<table>
						<tr><td width="56" class="labelmedium">
						#APPLICATION.BaseCurrency#
						</td>
						<td class="labelmedium">
						#numberformat(Last.AmountPlanned,"__,__")#
						</td>
						</tr>
					</table>
					</td>	
				
				<cfelse>
				
					<td>--</td>				
					
				</cfif>
			
			<td class="lalbelit">#last.reference#</td>
			
			</cfif>	
							
			<td class="labelit">#last.officerfirstName# #last.officerLastName# <font size="1">(#dateformat(last.created,CLIENT.DateFormatShow)# #timeformat(last.created,"HH:MM")#)</font></td>	
			<td></td>				
			
	</TR>		
	
		
	</CFOUTPUT>	
	
</table>	

<!-- </cfform> -->
			