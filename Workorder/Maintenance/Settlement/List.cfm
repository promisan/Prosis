
<cfparam name="url.code"    default="">
<cfparam name="url.mission" default="">
<cfparam name="url.action"  default="">

<cfquery name="List" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *, 
	       (SELECT Description 
		    FROM   Accounting.dbo.Ref_Account 
			WHERE  GLAccount = D.GLAccount) as Description
	FROM   Ref_SettlementMission D
	WHERE  Code = '#url.Code#'
</cfquery>

<cfquery name="getMission" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission NOT IN
		( 
		  SELECT Mission
		  FROM   Ref_SettlementMission
	      WHERE  Code = '#url.Code#'
		)
</cfquery>

<cfform  method="POST" name="settlement_#code#" id="settlement_#code#" onsubmit="return false">
	
<table width="80%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">					
		
		<tr><td colspan="6" height="10"></td></tr>
		
		<cfoutput>
		
		 <TR height="18" class="line labelmedium">
			   <td><cf_tl id="Mission"></td>
			   <td width="40%"><cf_tl id="GLAccount"></td>
			   <td><cf_tl id="Order"></td>		
   			   <td><cf_tl id="Officer"></td>		
   			   <td><cf_tl id="Created"></td>		
			   <td align="right" style="padding-right:4px">
			   		<cfoutput>
						<cfif url.action neq 'new'>
							<a title="Link new mission" href="javascript:addMission('#url.code#')">[Add]</a>
						</cfif>
					</cfoutput>
			   </td>  
		  </TR>
				
		
		<cfif url.action eq "new">
												
			<input type="hidden" name="action" value="new">
			<input type="hidden" name="code"   value="#Code#">
			
				<TR>
				   <td height="35px">
				   	   <select name="Mission" class="regularxl">
					   	   <cfloop query="getMission">
						   		<option value="#Mission#">#Mission#</option>
						   </cfloop>
					   </select>
		           </td>
				   <td>
				   
				   		<cfinput type="Text" 
							name="GLAccount" 
							message="Please enter GLAccount" 
							required="No" 							 
							maxlength="20" 
							class="regularxl" 
							style="width:60px;">
							
				   </td>				  
				   <td>
					    <cf_tl id="You must enter a listing order" var ="1" class="Message">
						<cfinput type="Text" 
						   	value="" 
							name="ListingOrder" 
							message="#lt_text#" 
							required="Yes" 							 
							maxlength="2" 
							class="regularxl" style="text-align:center;width:25px;">
				   </td>		
				   <td colspan="3" align="right">
   					    <cf_tl id="Save" var ="1">
					   <input type="button" 
					        value="#lt_text#" 
							class="button10s" 
							onclick="saveMission('#Code#')"
							style="width:50;height:25px">
				   </td>
			    </TR>					
				
		</cfif>
		
		<cfloop query="List">					
																								
			<cfif url.code eq List.Code and url.mission eq List.Mission>		
								
				<input type="hidden" name="action" value="update">
				<input type="hidden" name="code"   value="#Code#">			
				<input type="hidden" name="missionOld" value="#Mission#">
						
				<TR>
				   <td height="35px">
				   	  <select name="Mission" class="regularxl">
					  	   <option value="#List.Mission#" selected>#List.Mission#</option>
					   	   <cfloop query="getMission">
						   		<option value="#Mission#">#Mission#</option>
						   </cfloop>
					   </select>
		           </td>
				   <td>
				   		<cfinput type="Text" 
							name="GLAccount" 
							value="#GLAccount#"
							message="Please enter GLAccount" 
							required="No" 							 
							maxlength="20" 
							class="regularxl" 
							style="width:60px;">
				   </td>				  
				   <td>
					    <cf_tl id="You must enter a listing order" var ="1" class="Message">						
						<cfinput type="Text" 
						   	value="#ListingOrder#" 
							name="ListingOrder" 
							message="#lt_text#" 
							required="Yes" 							 
							maxlength="2" 
							class="regularxl" style="width:25px;">
				   </td>
				   <td colspan="3" align="right">
   					   <cf_tl id="Save" var ="1">
					   <input type="button" 
					        value="#lt_text#" 
							class="button10s" 
							onclick="saveMission('#Code#');"
							style="width:50;height:25px">
				   </td>
			    </TR>							
				
				<tr><td colspan="6" class="line"></td></tr>
													
			<cfelse>								
						
				<TR class="navigation_row line labelmedium" bgcolor="ffffff">
				   <td>&nbsp;#Mission#</td>
				   <td height="20"><cfif GLAccount eq ""><font color="808080">[Accounts Receivable]</font><cfelse>#GLAccount# #Description#</cfif></td>
   				   <td height="20">#ListingOrder#</td>
				   <td>#OfficerFirstName# #OfficerLastName#</td>
				   <td>#dateFormat(Created,"dd/mm/yyyy")#</td>
				   <td align="right" style="padding-right:4px">
					  <cf_img icon="open" navigation="Yes" onclick="ptoken.navigate('List.cfm?code=#URL.code#&mission=#mission#','#url.code#_list')">
				   </td>					
				 </TR>					 
										
			</cfif>
						
		</cfloop>
		</cfoutput>
		
		<tr><td colspan="6" height="10"></td></tr>
																
</table>	

</cfform>

<cfset ajaxonload("doHighlight")>

