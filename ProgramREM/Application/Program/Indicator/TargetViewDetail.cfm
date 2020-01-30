<cfquery name="Param" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT TOP 1 *
    FROM Parameter	
</cfquery>

<cfloop query="Indicator">

        <cfset ind = Indicator.IndicatorCodeDisplay>
        <cfset uom = Indicator.IndicatorUoM>
 	    <cfset des = Indicator.IndicatorDescription>
		<cfset tpe = Indicator.IndicatorType>
        <cfset idc = Indicator.currentrow>

		<cfquery name="Target" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT *
		   FROM   ProgramIndicator 
		   WHERE  ProgramCode   = '#URL.ProgramCode#'
		   AND    Period        = '#URL.Period#'
		   AND	  RecordStatus != '9'
		   AND    IndicatorCode = '#IndicatorCode#' 
		   <cfif loc neq "">
		   AND    LocationCode  = '#loc#'
		   </cfif>
		</cfquery>
		
		<cfset tar = 0>
		
		<cfoutput>
		
		<cfset tar = tar + 1>
		
		<cfif URL.Mode eq "View">
		
			<cfif operational eq "1">
	  					
				 <tr>
				  <td height="20" class="labelit">#ind#.&nbsp;</td>
				  <td class="labelit">#des#</td>
				 				  
				  <cfquery name="TargetValue" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT T.TargetValue, T.TargetAlternate
					   FROM   ProgramIndicatorTarget T RIGHT OUTER JOIN Ref_SubPeriod S 
					   		   ON T.SubPeriod = S.SubPeriod
							   AND   T.TargetId =
							   <cfif Target.TargetId neq ""> 
							       '#Target.TargetId#' 
							   <cfelse>
							     '{00000000-0000-0000-0000-000000000000}' 
							   </cfif>
					   ORDER BY DisplayOrder
				  </cfquery>
				 
				  <cfif Target.TargetId eq "">
				  
				     <td colspan="1" height="17" align="right" class="labelit"><font color="FF0000">#msg2#&nbsp;</td>
				  
				  <cfelse>
				 
					<td align="right">
					
					<table border="0" cellspacing="0" cellpadding="0">
					<tr>					 
						  
						  <cfloop query="TargetValue">
						  
						      <td align="center" class="labelit">
							  <cf_space spaces="15">
							 
							   <cfif TargetValue eq "0">
							      <cfif tpe eq "0002">
								   #TargetValue*100#%
								  <cfelse>
								  #TargetValue#
								  </cfif>
							  <cfelseif TargetValue eq "">
							      <cfif TargetAlternate neq "">
								  <font color="blue">#TargetAlternate#</font>
								  <cfelse>
							      <font color="FF8080">N/A</font>
								  </cfif>
							  <cfelse>
								  <cfif tpe eq "0002">
								   #TargetValue*100#%
								  <cfelse>
								  #TargetValue#
								  </cfif>
							  </cfif>
							  </td>
						  </cfloop>				  
				
					</tr>
					</table>
				  </td>
									 
				  <td align="center" style="padding-top:2px">
				  <cfif ProgramAccess eq "ALL">
				  
				       <cf_img icon="delete" onClick="ask('#Target.TargetId#')">
					   
					   <!---
					   
				    
        				<img src="#SESSION.root#/Images/trash2.gif" 
						alt="Removing target" 
						border="0" 
						height="18"
						width="15"
						align="absmiddle"
						style="cursor: pointer;" 
						onClick="return ask('#Target.TargetId#')">
						
						
						--->
						
		    						  
				  </cfif>
				  				  
				  </td>			
				  
				   </cfif>  	  
					  
				</tr>			
				 
				<cfquery name="Param" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT * FROM Parameter					
				</cfquery>
								
				<cfif Target.Remarks neq "">
				<tr><td colspan="1"></td><td colspan="5" style="padding-left:4px" class="labelit"><i>#Target.Remarks#</td></tr>
				</cfif>
				
				<tr><td colspan="1"></td>
				    <td colspan="8">
					
					    <cf_filelibraryN
							DocumentPath="#Param.DocumentLibrary#"
							SubDirectory="#Target.TargetId#" 
							Filter=""
							Box="audit#currentrow#"
							Insert="no"
							Remove="no"
							width="100%"
							Highlight="no"
							Listing="yes">
							
				    </td>
				</tr>			
				
				<cfif CurrentRow neq Indicator.recordcount>					
					<tr><td colspan="4" class="linedotted"></td></tr>					
				</cfif>
				
			</cfif>
		
		<cfelse>
						
				<cfif operational eq "1">
				
					<input type="hidden" name="Location_#lor#_#idc#" id="Location_#lor#_#idc#"  value="#Loc#">
					<input type="hidden" name="Indicator_#lor#_#idc#" id="Indicator_#lor#_#idc#" value="#IndicatorCode#">
					
					<tr><td height="2"></td></tr>
					 <tr>
			  		  <td width="10%" class="labelit">#ind#.</td>
					  <td width="40%" colspan="3">
						  <table width="100%" cellspacing="0" cellpadding="0" align="center">
						  <tr>
							  <cfif Target.TargetId eq "">
							   <cfset cl = "hide"> 					  
							  <td width="90%" class="labelit"><font color="FF0000">#des#</td>
							  <td width="70" class="labelit"><cf_tl id="Enable">:</td>
							  <td><input type="checkbox" name="Status_#lor#_#idc#" value="1" onclick="toggledetail('d#currentrow#',this.checked)"> </td>
							  <cfelse>
							  <cfset cl = "regular"> 
							  <td class="labelit">#des#</td>
							  <input type="hidden" name="Status_#lor#_#idc#" id="Status_#lor#_#idc#" value="1">
							  </cfif>						 
						  </tr>
						  </table>
					  </td>
					
					 </tr>  
					 
					  <cfset sub = 0>
					  
					   <cfquery name="TargetValue" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT T.TargetValue, T.TargetAlternate, S.SubPeriod
						   FROM   ProgramIndicatorTarget T RIGHT OUTER JOIN Ref_SubPeriod S 
						     ON   T.SubPeriod = S.SubPeriod
						    AND   T.TargetId =
						   <cfif #Target.TargetId# neq ""> 
						       '#Target.TargetId#' 
						   <cfelse>
						       '{00000000-0000-0000-0000-000000000000}' 
						   </cfif>
						   ORDER BY DisplayOrder
					  </cfquery>
					  
					  <cfif tpe eq "0002">
					   <cfset mul = 100>
					  <cfelse>
					   <cfset mul = 1>
					  </cfif>  
																				
					   	  <tr id="d#currentRow#1" class="#cl#">
						  
						  <td></td>
						  <td class="labelit"><cfif tpe eq "0002">%</cfif>#uom#</td>
						  
						  <td>
						  
							  <table cellspacing="0" cellpadding="0">
							  <tr>
												  		 
								 <cfloop query="TargetValue">
								 				    				
								    <cfset sub = sub + 1> 
									
									<cfif sub eq "1">
										<cfset alt = "#TargetAlternate#">
									</cfif>
									
								    <input type="hidden" name="SubPeriod_#lor#_#idc#_#sub#" id="SubPeriod_#lor#_#idc#_#sub#" value="#SubPeriod#">
									
									<td>
									
									<cf_space spaces="15">
									
									<cfif TargetValue eq "">
									   <cfset val = "">
									<cfelse>   
									   <cfset val = "#TargetValue*mul#">
									</cfif>
									
									<cfinput type = "Text" 
									    name      = "TargetValue_#lor#_#idc#_#sub#" 
										value     = "#val#" 
										message   = "Please enter a valid target" 
										validate  = "float" 
										required  = "No" 
										size      = "3" 
										maxlength = "10" 
										class     = "regularxl enterastab" 
										style     = "text-align: center;">
									
									</td>																				
									
							     </cfloop>
							 
							 </tr>
							 </table>
							 
						</td>
					</tr>
										
					<tr id="d#currentRow#2" class="#cl#">
						<td></td>
					    <td class="labelit" colspan="1">#msg3# :</td>
					    <td colspan="2">
					     <input type="text" 
						    class="regularxl enterastab" 
							value="#alt#" 
							name="TargetAlternate_#lor#_#idc#_1" 
							style="width:100%" 							
							maxlength="100">
					   </td>
					 </tr>
					
					 <cfif Target.TargetId neq "">				 
					 <tr>
						   <td></td>
						    <td colspan="3" height="20">
						  
						    <cf_filelibraryN
								DocumentPath="#Param.DocumentLibrary#"
								SubDirectory="#Target.TargetId#" 
								Filter=""
								Box="audit#currentrow#"
								Insert="yes"
								Remove="yes"
								width="100%"
								Highlight="no"
								Listing="yes">
						  				   
						   </td>
						
					</tr>
					</cfif>
					
					<tr id="d#currentRow#3" class="#cl#">
					   <td></td>
					    <td colspan="3">						
					     <textarea style="width:100%" class="regular" rows="2" name="Remarks_#lor#_#idc#">#Target.Remarks#</textarea>
					   </td>
					 </tr>
					 
					 <cfif Target.TargetId neq "">
					 
					 <tr><td></td><td height="30" colspan="3">
					 					 
					     <cfdiv id="#lor#_#idc#_#sub#" bind="url:TargetViewDetailAccess.cfm?TargetId=#Target.TargetId#&i=#lor#_#idc#_#sub#">
						 
					 </td></tr>
					 
					 </cfif>
				 				 
					 <cfif CurrentRow neq Indicator.recordcount>
					  	 <tr><td colspan="3" class="linedotted"></td></tr>
					 </cfif>
					 
				</cfif>	 
				 
		</cfif>
					
		</cfoutput>
						
</cfloop>

