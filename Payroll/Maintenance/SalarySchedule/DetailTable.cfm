<cfparam name="URL.SN"   default="">
<cfparam name="URL.CN"   default="">
<cfparam name="URL.EP"   default="">
<cfparam name="URL.OP"   default="">
<cfparam name="URL.DV"   default="">
<cfparam name="URL.DV2"  default="">
<cfparam name="URL.PER"  default="">
<cfparam name="URL.PER2" default="">

<!--- based on the calculated base amount a different percentage --->

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="E4E4E4" class="formpadding">

<tr><td align="center" style="padding-top:5px">
	
	   <cfswitch expression="#url.detailmode#">
	   	   
	   <cfcase value="Month">	
	   
	   	<cfswitch expression="#Trim(URL.OP)#"> 
		
			   <cfcase value="save"> 
			   
			   			   							   
				<cfquery name="setparent" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE    SalaryScalePercentage
					SET       DetailMode         = '#url.detailmode#'
					WHERE     ScaleNo            = '#URL.SN#'
					and       ComponentName      = '#URL.CN#'
					and       EntitlementPointer = '#URL.EP#'
				</cfquery>
			   
			   <cfquery name="clear" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM SalaryScalePercentageDetail
					WHERE     ScaleNo            = '#URL.SN#'
					AND       ComponentName      = '#URL.CN#'
					AND       EntitlementPointer = '#URL.EP#'
				</cfquery>
				
				 <cfquery name="check" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * FROM SalaryScalePercentage
					WHERE     ScaleNo            = '#URL.SN#'
					AND       ComponentName      = '#URL.CN#'
					AND       EntitlementPointer = '#URL.EP#'
				</cfquery>
				
				<cfif check.recordcount eq "0">
				
					<script language="JavaScript">
				     alert("First save your main percentage page!")
				   </script>  
				
				<cfelse>
				
					<cfloop index="mth" from="1" to="12">
					
						<cfset val = evaluate("form.#Mth#_Percentage")>
						<cfif val eq "" or not LSIsNumeric(val)>
							<cfset val = "0">
						</cfif>											
					
						<cfquery name="Details" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO SalaryScalePercentageDetail
									(ScaleNo,ComponentName,EntitlementPointer,DetailValue,Percentage)
								VALUES('#URL.SN#','#URL.CN#','#URL.EP#','#mth#','#val#')
							</cfquery>
									
					</cfloop>		
					
				</cfif>		   
			   			   
			   </cfcase>
			   
		</cfswitch>	      
		
		<cfquery name="get" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   SalaryScale
			WHERE  ScaleNo            = '#URL.SN#'					
		</cfquery>
		
		<cfset dt = get.SalaryEffective>
		
				
		<cfquery name="Details" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    DetailValue,Percentage
			FROM      SalaryScalePercentageDetail
			WHERE     ScaleNo            = '#URL.SN#'
			and       ComponentName      = '#URL.CN#'
			and       EntitlementPointer = '#URL.EP#'
		</cfquery>
	   
	    <form method="post" name="formmonth" id="formmonth">
			   
		<table width="300" align="center" cellspacing="0" cellpadding="0" class="formpadding">
								
			<cfoutput>						
					
					<tr><td height="4"></td></tr>
					<tr class="labelmedium line" style="height:20px">
					<td><cf_tl id="Month"></td>
					<td align="right"><cf_tl id="Percentage"></td>
					<td></td>
					</tr>
					
					<cfset mth = month(dt)>
					<cfset yr  = year(dt)>
					
					<cfloop index="itm" from="1" to="12">
									
						<tr class="labelmedium line" style="height:26px">
							<td>
							
							#monthasstring(Mth)# #yr#
							
							</td>
							<td align="right" style="border-left:1px solid silver;border-right:1px solid silver;padding-right:3px">
							
							 <cfquery name="get" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * FROM SalaryScalePercentageDetail
									WHERE     ScaleNo            = '#URL.SN#'
									AND       ComponentName      = '#URL.CN#'
									AND       EntitlementPointer = '#URL.EP#'
									AND       DetailValue = '#mth#'
								</cfquery>
																
								<cfif get.recordcount eq "0">
																
								 <cfquery name="get" 
									datasource="AppsPayroll" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * FROM SalaryScalePercentage
										WHERE     ScaleNo            = '#URL.SN#'
										AND       ComponentName      = '#URL.CN#'
										AND       EntitlementPointer = '#URL.EP#'									
									</cfquery>
																	
								</cfif>
															
							<input type="text" class="regularh enterastab" 
							    name="#Mth#_Percentage" 
								style="width:97%;border:0px;font-size:12px;height:21px;text-align:right;padding-right:3px" 
								size="9" 
								value="#numberformat('#get.Percentage#','._____')#"
								maxlength="9">		
							</td>
							<td style="padding-left:3px;padding-top:3px">%</td>				
						</tr>
						
						<cfif mth eq "12">
							<cfset mth = "1">
							<cfset yr = yr+1>
						<cfelse>
							<cfset mth = mth + 1>	
						</cfif>
						
					</cfloop>
				
			<tr><td></td></tr>
						
			<tr><td colspan="3" align="center">
			    <input type="button" name="Save" style="width:130px" class="button10s" value="Save" onclick="savemonth('#URL.SN#','#URL.CN#','#URL.EP#','#url.detailmode#')">			
			</td></tr>
			
						
			</cfoutput>
		
		</table>
		
		</form>
	   
	   </cfcase>
	   
	   <cfcase value="Amount">   
	   	 
	   
		   <cfswitch expression="#Trim(URL.OP)#"> 
		
			   <cfcase value="del"> 
			
				<cfquery name="Process" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE SalaryScalePercentageDetail
					WHERE ScaleNo            = '#URL.SN#'
					and   ComponentName      = '#URL.CN#'
					and   EntitlementPointer = '#URL.EP#'
					and   DetailValue        = '#URL.DV#'
				</cfquery>
				
			   </cfcase> 
		   
			   <cfcase value="edit"> 
			   
			   <cfquery name="setparent" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE    SalaryScalePercentage
					SET       DetailMode         = '#url.detailmode#'
					WHERE     ScaleNo            = '#URL.SN#'
					and       ComponentName      = '#URL.CN#'
					and       EntitlementPointer = '#URL.EP#'
				</cfquery>
			   			
				<cfquery name="check" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * 
					FROM   SalaryScalePercentageDetail
					WHERE  ScaleNo            = '#URL.SN#'
					AND    ComponentName      = '#URL.CN#'
					AND    EntitlementPointer = '#URL.EP#'
					AND    DetailValue        = '#URL.DV2#'					
				</cfquery>
				
				<cfif check.recordcount eq "0">
				
					<cfquery name="Process" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE SalaryScalePercentageDetail
						SET    DetailValue   = '#URL.DV2#', 
						       Percentage    = '#URL.PER2#'
						WHERE  ScaleNo       = '#URL.SN#'
						and    ComponentName = '#URL.CN#'
						and    EntitlementPointer='#URL.EP#'
						and    DetailValue   = '#URL.DV#'
						and    Percentage    = '#URL.PER#'
					</cfquery>
					
				<cfelse>
				
					<script language="JavaScript">
				     alert("A record with this code has been registered already!")
				   </script>  
				   
				</cfif>
				
			   </cfcase>  
		   
			   <cfcase value="add">
			   
			   	  	<cfquery name="setparent" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE    SalaryScalePercentage
					SET       DetailMode         = '#url.detailmode#'
					WHERE     ScaleNo            = '#URL.SN#'
					and       ComponentName      = '#URL.CN#'
					and       EntitlementPointer = '#URL.EP#'
				</cfquery>	
			    
					<cfquery name="check" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   SalaryScalePercentageDetail
							WHERE  ScaleNo            = '#URL.SN#'
							and    ComponentName      = '#URL.CN#'
							and    EntitlementPointer = '#URL.EP#'
							and    DetailValue        = '#URL.DV2#'							
					</cfquery>
					
					<cfif check.recordcount eq "0">
					
						<cfquery name="Process" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO SalaryScalePercentageDetail
									(ScaleNo,ComponentName,EntitlementPointer,DetailValue,Percentage)
							VALUES('#URL.SN#','#URL.CN#','#URL.EP#','#URL.DV2#','#URL.PER2#')
						</cfquery>
						
					<cfelse>
					
						<script language="JavaScript">
					     alert("A record with this code has been registered already!")
					   </script>  			
					   
					</cfif>
				   
			   </cfcase>    
		   
		   </cfswitch>
		   
					   
			<cfquery name="Details" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    DetailValue,Percentage
				FROM      SalaryScalePercentageDetail
				WHERE     ScaleNo            = '#URL.SN#'
				and       ComponentName      = '#URL.CN#'
				and       EntitlementPointer = '#URL.EP#'
			</cfquery>
	   	   		  
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">			
				
					<cfoutput>
						<TR class="labelmedium">
					    <TD height="15" colspan="5" style="padding-left:20px" width="10%">
						#URL.CN#					
						<a href="javascript:addnew('#URL.SN#','#URL.CN#','#URL.EP#','#URL.detailmode#')">Add</a>
						</TD>
					    </TR>	
				
						<TR class="line">
					    
						<TD height="15" width="4%"></TD>
						<TD height="15" width="10%"><cf_tl id="Value Max"></TD>
						<TD height="15" width="10%"><cf_tl id="Percentage"></TD>
						<TD colspan="2" height="15" width="10%"></TD>
					    </TR>	
				
				    <cfloop query="Details">
						
						<TR class="line">
					   
						<TD height="15" width="1%"></TD>
						<TD height="15" width="10%">
			 				<input type="Text"
							       id="#currentrow#_DV"
								   value="#numberformat(DetailValue,',.____')#"
							       size="6"
								   style="width:95%;text-align:right"
								   maxlength="20"
							       class="amount2 regularh">
	
							<input type="hidden" name="#currentrow#_ODV" value="#DetailValue#">
						
						</TD>
						<TD height="15" width="10%" style="padding-left:4px">
	
			 				<input type="Text"
							       id="#currentrow#_PER"
								   value="#numberformat(Percentage,',____')#"
							       size="6"
								   style="width:95%;text-align:right"
								   maxlength="20"
							       class="amount2 regularh">
	
							<input type="hidden" id="#currentrow#_OPER" name="#currentrow#_OPER" value="#Percentage#">					
						
						</TD>
						<td width="1%">
						     <cf_img icon="delete" onClick="deletedt('#URL.SN#','#URL.CN#','#URL.EP#','#DetailValue#','#URL.detailmode#')">
						</td>						 			
						<td width="1%" style="padding-right:10px">						 
							 <cf_img icon="save" onClick="saveamount('edit','#URL.SN#','#URL.CN#','#URL.EP#','#URL.detailmode#','#currentrow#_ODV','#currentrow#_DV','#currentrow#_OPER','#currentrow#_PER')">						 
						</td>
					    </TR>	
					</cfloop>
					
				    </cfoutput>	
				
					<cfif URL.OP eq "newd">
						<cfoutput>
							<TR class="regularxl">
						   
							<TD height="15" width="4%"></TD>
							<TD height="15" width="10%">
				 				<input type="Text"
								      
									   id="new_DV"
									   value=""
								       size="6"
									   maxlength="20"
									   style="width:95%;text-align:right"
								       class="amount2 regularh">
									   
									   <input type="hidden" id="old_ODV" value="">
		
							</TD>
							<TD height="15" width="10%" style="padding-left:4px">
				 				<input type="Text"
								     
									  id="new_PER"
									   value=""
								       size="6"
									   maxlength="20"
									   style="width:95%;text-align:right"
								       class="amount2 regularh">	
									   
									    <input type="hidden" id="old_OPER" value="">				
							</TD>
							<td width="1%"></td>
		
							<td width="1%" style="padding-right:10px">						
								 <cf_img icon="add" onClick="saveamount('add','#URL.SN#','#URL.CN#','#URL.EP#','#URL.detailmode#','old_ODV','new_DV','old_OPER','new_PER')">						
							</td>
						    </TR>	
							
						</cfoutput>
					</cfif>			
			</table>
				   		   
		   
		   </cfcase>
		  		   
		   </cfswitch>
				   
			</td>
			</tr>	
</table>
