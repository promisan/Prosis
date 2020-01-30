    
  <cfif form.layout neq "corporate">
  
  <TR class="navigation_row linedotted" onclick="#vParentOnClick#">
	  <td colspan="3" style="padding-left:10px;width:100%"></td>
	  
	  <cfoutput>
	  
		  <cfloop index="itm" list="#nodelist#" delimiters=",">
		  
		  <td class="labelit" align="right" style="border:1px dotted gray;padding-right:3px"><cf_space spaces="22">
		  
			  <cfif form.layout eq "owner">
			  
				   <cfquery name="Org"
			       datasource="AppsQuery" 
			       username="#SESSION.login#" 
			       password="#SESSION.dbpw#">
				       SELECT *
				       FROM   Organization.dbo.Organization
				       WHERE  OrgUnit = '#itm#'
			       </cfquery>
			 
			   	   #org.OrgUnitName#
				
			   <cfelse>
			   
				   #itm#		
			  
			   </cfif>
		   
		  </td>
		  </cfloop>
	  
	  </cfoutput>
	  
  </tr>	   
  
  </cfif>  
   
  <cfoutput query="#source#" group="AccountParent"> 
  
	 <cfquery name="Parent"
       datasource="AppsQuery" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT SUM(#field#) as Total
       FROM   #SESSION.acc#Balance#fileNo#
       WHERE  AccountParent = '#AccountParent#'
	   AND    Panel         = '#field#'
     </cfquery>

	<!--- Provision to toggle group and account details --->
	<cfset vAccountParentId = trim(replace(AccountParent, " ", "", "ALL"))>
	<cfset vParentOnClick = "">
	<cfset vGroupVisible = "">
	<cfif form.aggregation eq "total">
		<cfset vParentOnClick = "$('.clsDetail_#field#_#vAccountParentId#').toggle();">
		<cfset vGroupVisible = "display:none;">
	</cfif>
	 
	<TR class="navigation_row linedotted" onclick="#vParentOnClick#">
	  <td style="padding-left:10px"></td>
	  <td style="width:100;padding-right:10px" class="labellarge">#AccountParent#</td>
	  <td class="labellarge" style="width:100%">#AccountParentDescription#</td>
	  
	   <cfif form.layout neq "corporate">
	 
		   <cfloop index="itm" list="#nodelist#" delimiters=",">
		   
		   	  <!--- source data--->
			  <cfquery name="Data"
			   datasource="AppsQuery" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				  SELECT  SUM(#field#) as Total
				  FROM    #SESSION.acc#Balance#fileNo#
				  WHERE   AccountParent = '#AccountParent#'
				  AND     Panel = '#field#'
				  <cfif form.layout eq "owner">
				      AND     OrgUnitOwner = '#itm#'
				  <cfelse>
					  <cfif history eq "TransactionPeriod">
					     AND     TransactionPeriod <= '#itm#'	
					  <cfelse>
					     AND     AccountPeriod     <= '#itm#'	
					  </cfif>
				  </cfif>	  
			  </cfquery>		  			
		   			
			<td class="labelit" align="right" style="border:1px dotted gray;padding-right:3px">
							
					<cfif data.total eq "">
						-
					<cfelse>
						<cfif Data.Total lt 0>
							<font color="FF0000">#NumberFormat(evaluate("Data.Total"),'(_,____)')#</font>
						<cfelse>
							<font color="808080">#NumberFormat(evaluate("Data.Total"),'_,____')# </font>
						</cfif>
					</cfif>

			</td>
			
		   </cfloop>
	
	  <cfelse> <!--- total only if periods are not shown, because this is running balance --->
	 
		  <td align="right" class="labelmedium">
		  
			  <cfif evaluate(Parent.total) lte "0">
			  <font color="FF0000">(#NumberFormat(-Parent.total,'#frm#')#)</font>
			  <cfelse>
			  #NumberFormat(Parent.total,'#frm#')#&nbsp;
			  </cfif>
		  </td>
	 
	  </cfif> 

	</tr>
	
	<cfoutput group="AccountGroup">
		  	  
		   <!--- <cfif form.aggregation is "group" or form.aggregation is "detail">	 --->
		   
		   <cfquery name="Group"
		        datasource="AppsQuery" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT SUM(#field#) as Subtotal
		        FROM   #SESSION.acc#Balance#fileNo#
		        WHERE  AccountParent = '#AccountParent#'
			    AND    AccountGroup  = '#AccountGroup#'
				AND    Panel = '#field#'
		    </cfquery>
				
			<!--- Provision to toggle accounts detail --->
			<cfset vAccountGroupId = trim(replace(AccountGroup, " ", "", "ALL"))>
			<cfset vGroupOnClick = "">
			<cfset vDetailVisible = "">
			
			<cfif form.aggregation eq "group">
			
				<cfset vGroupOnClick = "$('.clsDetail_#field#_#vAccountGroupId#').toggle();">
				<cfset vDetailVisible = "display:none;">
				
			<cfelseif form.aggregation eq "total">
			
				<cfset vGroupOnClick = "$('.clsDetail_#field#_#vAccountGroupId#').toggle();">
				<cfset vDetailVisible = "display:none;">
				<cfset vGroupVisible  = "display:none;">
				
			</cfif>
				
			<TR class="clsDetail_#field#_#vAccountParentId# navigation_row linedotted" bgcolor="##e8e8e8" onclick="#vGroupOnClick#" style="#vGroupVisible#">
		   	  <td style="padding-left:10px"></td>
		  	  <td style="height:23px;width:100;padding-left:6px" class="labelit"><cfif form.aggregation is "detail"></cfif>#AccountGroup#</b></td>
			  <td class="labelit" ><cfif form.aggregation is "detail"></cfif>#AccountGroupDescription#</td>
			  
			   <cfif form.layout neq "corporate">
	 
				   <cfloop index="itm" list="#nodelist#" delimiters=",">
				   
				   	  <!--- source data--->
					  <cfquery name="Data"
					   datasource="AppsQuery" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT  SUM(#field#) as Total
						FROM    #SESSION.acc#Balance#fileNo#
						WHERE   AccountGroup  = '#AccountGroup#'
						AND     Panel = '#field#'
						<cfif form.layout eq "owner">
						   AND     OrgUnitOwner = '#itm#'
						<cfelse>
						  <cfif history eq "TransactionPeriod">
						     AND     TransactionPeriod <= '#itm#'	
						  <cfelse>
						     AND     AccountPeriod     <= '#itm#'	
						  </cfif>
						</cfif>	
					  </cfquery>
				   			
					<td class="labelit" align="right" style="border:1px dotted gray;padding-right:3px">
							<font color="808080">			
							<cfif data.total eq "">
								-
							<cfelse>
								<cfif Data.Total lt 0>
									<font color="FF0000">#NumberFormat(evaluate("Data.Total"),'(_,____)')#</font>
								<cfelse>
									#NumberFormat(evaluate("Data.Total"),'_,____')#
								</cfif>
							</cfif>
							</font>
					</td>
					
				   </cfloop>
				   
			  <cfelse>
			  
			      <!--- Show total only if periods are not shown, because this is running balance --->
				  <td align="right" style="width:100;padding-right:10px; background-color:##d4d4d4;" class="labelit">	
				  	<cfif Group.subtotal lt 0>
						<font color="FF0000">#NumberFormat(evaluate("Group.subtotal"),'(_,____)')#</font>
					<cfelse>
						#NumberFormat(Group.subtotal,'#frm#')#
					</cfif>	
				  </td>		
				  	  	  
			  </cfif>

			</tr>
			<!--- </cfif> --->
		  		
			<cfoutput group="GLAccount">
					
		   <!--- <cfif form.aggregation is "detail"> --->
			
				<tr class="clsDetail_#field#_#vAccountGroupId# navigation_row linedotted labelit" style="#vDetailVisible#">
				    <td style="padding-left:5px"></td>
			    	
					<td style="width:100;padding-left:10px;padding-right:10px" class="labelit">#GLAccount#</td>
				    
					<td style="padding-left:5px" class="labelit">#Description#</td>
					
					<cfif form.layout neq "corporate">
					
						<cfset sum = "0">
						
						<cfloop index="itm" list="#nodelist#" delimiters=",">
								 							 
							<!--- source data--->
							<cfquery name="Data"
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT SUM(#field#) as Total
								FROM   #SESSION.acc#Balance#fileNo#
								WHERE  GLAccount  = '#GLAccount#'	
								AND    Panel = '#field#'
								<cfif form.layout eq "owner">
								   AND     OrgUnitOwner = '#itm#'
								<cfelse>
								 <cfif history eq "TransactionPeriod">
								     AND     TransactionPeriod <= '#itm#'	
								  <cfelse>
								     AND     AccountPeriod     <= '#itm#'	
								  </cfif>
								</cfif>	
							</cfquery>													
													
							<cfif history eq "TransactionPeriod">
						    	<cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#GLAccount#','#itm#','','tab')"> 								
							<cfelse>
								<cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#GLAccount#','#itm#','','tab')">						    
							</cfif>	
																	
							<td class="labelit" align="right" style="padding-left:10px;border:1px solid e4e4e4;padding-right:8px"
							 onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='transparent'" onclick="#sc#">
								
								<cfif data.total eq "">
									-
								<cfelse>
								
									<cfif data.total lt 0>								
										<font color="FF0000">#NumberFormat(evaluate("Data.Total"),'(_,____)')#</font>
									<cfelse>
										<font color="b0b0b0"> #NumberFormat(evaluate("Data.Total"),'_,____')#</font>
									</cfif>
								</cfif>
								
							</td>
												
						</cfloop>
					
					<cfelse> <!--- Show total only if periods are not shown, because this is running balance --->
					
						<cfquery name="Data"
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  SUM(#FIELD#) as Total
						    FROM    #SESSION.acc#Balance#fileNo#
							WHERE   GLAccount  = '#GLAccount#'		
							AND     Panel = '#field#'
						</cfquery>
						
						<cfif history eq "TransactionPeriod">
							<cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#GLAccount#',#Form.TransactionPeriod#,'','tab')">
						<cfelse>
						    <cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#GLAccount#',#Form.TransactionPeriod#,'','tab')"> 
						</cfif>		
						
						<td class="labelit" style="padding-left:10px;" align="right" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='transparent'" onclick="#sc#">
							<cfif Data.Total lt 0>
								<font color="FF0000">#NumberFormat(evaluate("Data.Total"),'(_,____)')#</font>
							<cfelse>
								#NumberFormat('#evaluate(Data.Total)#','#frm#')# 
							</cfif>
						</td>
						
				    </cfif>
					
				</tr>
				
			 <!--- </cfif> --->
			
			</cfoutput>		
					  
	    </cfoutput>						
		
	</cfoutput>
 
 
 	<!--- ---------- --->
	<!--- total line --->
	<!--- ---------- --->
	
	<tr bgcolor="e4e4e4" class="linedotted navigation_row">	
		  
		  <td></td>
		  <td class="labelmedium" colspan="2" style="padding-left:4px;padding-right:3px"><CFIF field EQ "Debit"><cf_tl id="Total"> <b><cf_tl id="Assets"><cfelse>Total <b><cf_tl id="Liabilities"></cfif></td>
		 
		  <cfif form.layout neq "corporate">
		 
			   <cfloop index="itm" list="#nodelist#" delimiters=",">
			   
			   	 <!--- source data--->
					<cfquery name="Data"
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  SUM(#field#) as Total
						FROM    #SESSION.acc#Balance#fileNo#
						
						<cfif form.layout eq "owner">
				        WHERE   OrgUnitOwner = '#itm#'
						<cfelse>				  						
							<cfif history eq "TransactionPeriod">
							WHERE   TransactionPeriod <= '#itm#'	
							<cfelse>
							WHERE   AccountPeriod     <= '#itm#'	
							</cfif>
						</cfif>
						AND    Panel = '#field#'
					</cfquery>
				
				<td class="labelmedium" align="right" style="padding-left:10px;border:1px dotted gray;padding-right:3px"><font color="808080">
				
					<cfoutput>
						<cfif Data.total lt 0>
							<font color="FF0000">#NumberFormat(Data.Total,'(_,____)')#</font>
						<cfelse>
							#NumberFormat(Data.Total,'_,____')#
						</cfif>
					</cfoutput>
				</td>
				
			   </cfloop>
		  
		  <cfelse>  <!--- Show total only if periods are not shown, because this is running balance --->
		  
			    <td class="labelmedium" align="right" style="padding-left:10px;padding-right:3px">
			  	<cfoutput>
					<cfif field eq "Debit">
					
						<cfif dbt lt 0>
							<font color="FF0000">#NumberFormat(dbt,'(_,____)')#</font>
						<cfelse>
							#NumberFormat(dbt,'_,____')#
						</cfif>
						
					<cfelse>
					
						<cfif crt lt 0>
							<font color="FF0000">#NumberFormat(crt,'(_,____)')#</font>
						<cfelse>
							#NumberFormat(crt,'_,____')#
						</cfif>
					
					</cfif>
				</cfoutput>
			   </td>
		  
		  </cfif>					
			
	 </tr>	
 
    <!--- ------------------ --->
 	<!--- Profit / Loss line --->
	<!--- ------------------ --->
	
 	<cfif field eq "Debit">
	
		<cfif form.layout neq "corporate" or dbt lt crt>
	
		<!---<cfif dbt lt crt>--->
			 <tr bgcolor="#FED7CF">
			 	<td></td>
			  	<td height="15" colspan="2"  style="height:35px;padding-left:4px" class="labelmedium"><cfoutput>#Parameter.StatementLabelLoss#</cfoutput></td>
				 
			   <cfif form.layout neq "corporate">
			   
				   <cfloop index="itm" list="#nodelist#" delimiters=",">
				   
				   	    <!--- source data--->
						<cfquery name="Data"
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT sum(Credit-Debit) as Total
							FROM   #SESSION.acc#Balance#fileNo# 
							<cfif form.layout eq "owner">
					        WHERE   OrgUnitOwner = '#itm#'
							<cfelse>									
								<cfif history eq "TransactionPeriod">
								WHERE   TransactionPeriod <= '#itm#'	
								<cfelse>
								WHERE   AccountPeriod     <= '#itm#'	
								</cfif>		
							</cfif>				
						</cfquery>	
									
						
						<cfif data.total gte "0">	
						   				
						<td class="labellarge" bgcolor="red" align="right" style="border:1px dotted gray;padding-right:3px">
							<cfoutput>
							<font color="white">#NumberFormat(Data.Total,'_,____')#</font>
							</cfoutput>
						</td>
						
						<cfelse>
						
							<td></td>
							
						</cfif>
					
				   </cfloop>
			   
			   <cfelse>  <!--- Show total only if periods are not shown, because this is running balance --->
			   
					<cfif dbt lt crt>
					<td bgcolor="red" width="100" style="border:1px dotted gray;padding-right:3px; color:white;" align="right" class="labellarge">
						<cfoutput>#NumberFormat(crt-dbt,'#frm#')#</cfoutput>
					</td>
					<cfelse>
					<td>
					</td>
					</cfif>
			   
			   </cfif>
				
		    </tr>
		</cfif> 
		
	<cfelse>
	
	  <cfif form.layout neq "corporate" or crt lt dbt>		  
	
	  <!--- <cfif crt lt dbt> --->
		  <tr class="linedotted" bgcolor="#E1FFC4">
		  	<td></td>
			
			<td colspan="2" class="labelmedium" style="padding-left:4px">
			  	<cfoutput>#Parameter.StatementLabelProfit#</cfoutput></b></font>
			</td>
			
			 <cfif form.layout neq "corporate">
			 
				   <cfloop index="itm" list="#nodelist#" delimiters=",">
				   
				   		 <!--- source data--->
						<cfquery name="Data"
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  sum(Debit-Credit) as Total
							FROM    #SESSION.acc#Balance#fileNo#
							
							<cfif form.layout eq "owner">
					        WHERE   OrgUnitOwner = '#itm#'
							<cfelse>	
														
								<cfif history eq "TransactionPeriod">
								WHERE   TransactionPeriod <= '#itm#'	
								<cfelse>
								WHERE   AccountPeriod     <= '#itm#'	
								</cfif>		
								
							</cfif>
										
						</cfquery>
						
										   		
						<cfif data.total gte "0">	   				 
						<td class="labellarge" bgcolor="green" align="right" style="height:35px;border:1px dotted gray;padding-right:3px">
							<font color="white">											
							<cfoutput>#NumberFormat(Data.Total,'_,____')#</cfoutput>
							</font>
						</td>
						<cfelse>
						<td></td>
						</cfif>
					
				   </cfloop>
				   
			  <cfelse> <!--- Show total only if periods are not shown, because this is running balance --->
			  
				<cfif  crt lt dbt>		
					<td align="right" width="100" class="labellarge" style="height:35px;background-color:green;color:white;">
				  		<cfoutput>#NumberFormat(dbt-crt,'#frm#')#</cfoutput>&nbsp;
					</td>
				<cfelse>
					<td></td>
				</cfif>
				  
			  
			  </cfif>		
			
		  </tr>
		  
	</cfif> 
	  
 </cfif>
