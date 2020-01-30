
<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_ScaleDetail
	WHERE    Code = '#URL.Code#'	
	ORDER BY AgeYear
</cfquery>

<cfquery name="Last" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  Max(AgeYear)+1 as Last
    FROM    Ref_ScaleDetail
	WHERE   Code = '#URL.Code#'	
</cfquery>

<cfif Last.Last eq "">
	<cfset yr = 1>	
<cfelse>
	<cfset yr = last.last>	
</cfif>

<cfparam name="URL.ID2" default="new">
	
<table width="250" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
				
		<cfif list.recordcount eq "0">
		
		    <cfset url.id2 = "new">
			
		</cfif>  
			
		    <TR class="labelit line">
			 
			   <td width="20%">Age</td>
			   <td width="30%">Cum Depr</td>			  
			   <td colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.ID2 neq "new">
				     <A href="javascript:ColdFusion.navigate('List.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&ID2=new','#url.code#_list')">
					 <font color="0080FF">[add]</font></a>
				 </cfif>
				 </cfoutput>
			   </td>		  
		    </TR>
				
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = AgeYear>
			<cfset de = CumDepreciation*100>
																								
			<cfif URL.ID2 eq nm>
			
				<tr>
					<td colspan="4">
					
						<cfform action="ListSubmit.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&id2=#url.id2#" 
			    			method="POST" 
							name="element">
						
							<table width="100%" align="center">
								<input type="hidden" name="ListCode" id="ListCode" value="<cfoutput>#nm#</cfoutput>">
													
								<TR>
								
								   <td width="20%">#nm#</td>
								   <td width="30%">
								   	   <cfinput type="Text" 
									   	value="#de#" 
										name="CumDepreciation" 
										message="You must enter a percentage" 
										validate="integer"
										required="Yes" 
										size="2" 
										style="width:30px;text-align:center"
										maxlength="3" 
										class="regularh">&nbsp;%				  
						           </td>
												  
								   <td colspan="2" align="right">
								   <input type="submit" 
								        value="Save" 
										class="button10g" 
										style="width:50">
								   </td>
								   
							    </TR>	
						
							</table>
						
						</cfform>
						
					</td>
				</tr>			
															
			<cfelse>								
						
				<TR bgcolor="fcfcfc" class="labelit line navigation_row">
				   <td style="padding-left:3px">#nm#</td>
				   <td width="70%">#de#%</td>				  
				   <td align="right">
						<cf_img icon="edit" navigation="Yes" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('List.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
				   </td>			   
				   <td align="center">
				     <cfif currentrow eq recordcount>
				   		<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('ListPurge.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
					 </cfif>						  
				   </td>					
				 </TR>					 
										
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.ID2 eq "new">
		
			<tr>
				<td colspan="4">
					<cfform action="ListSubmit.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&id2=new" 
					    method="POST" 
						name="element">
						<table width="100%" align="center">
							<TR>
								<td height="28" width="20%" class="labelit">
								
								<cfoutput>
									#yr#								
									 <input type="Hidden" 
									   	value="#yr#" 
										name="AgeYear" id="AgeYear">
								</cfoutput>								
																
						        </td>
										   
								<td width="30%">
								
							     <cfinput type="Text" 
								   	value="" 
									name="CumDepreciation" 
									message="You must enter a percentage" 
									validate="integer"
									required="Yes" 
									size="2" 
									style="width:30px;text-align:center"
									maxlength="3" 
									class="regularxl">&nbsp;%		
									
								</td>								 
																									   
								<td colspan="2" align="right" style="padding-right:4px">
									<cfoutput>
									<input type="submit" 
										value="Add" 
										class="button10g" 
										style="width:50">								
									</cfoutput>
								</td>			    
								</TR>	
						</table>
					</cfform>
				</td>
			</tr>			
											
		</cfif>								
</table>		
				
<cfset ajaxonload("doHighlight")>				
						

