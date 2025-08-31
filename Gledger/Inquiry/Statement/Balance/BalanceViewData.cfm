<!--
    Copyright © 2025 Promisan B.V.

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
  <cfif form.layout neq "corporate">
  
  <TR class="navigation_row linedotted fixrow fixlengthlist" onclick="#vParentOnClick#">
	  <td colspan="3" style="background-color:white;padding-left:10px;"></td>
	  
	  <cfoutput>
	  
		  <cfloop index="itm" list="#nodelist#" delimiters=",">
		  
		  <td class="labellarge" align="right" style="min-width:70px;border:1px dotted gray;padding-right:3px">
		  
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
	 
	<TR class="navigation_row linedotted fixlengthlist labelmedium2" onclick="#vParentOnClick#">
	  <td style="padding-left:10px"></td>
	  <td colspan="2" style="height:30px;width:100;padding-right:10px;font-size:18px;font-weight:bold" class="labellarge">#AccountParent# #AccountParentDescription#</td>
	  	  
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
		   			
			<td class="labellarge" align="right" style="font-size:<cfif history eq 'transactionperiod'>14px<cfelse>18px</cfif>;border:1px dotted gray;padding-left:6px;padding-right:3px;font-weight:bold">
							
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
	 
		  <td align="right" class="labelmedium" style="font-zise:18px">
		  
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
				
			<TR class="clsDetail_#field#_#vAccountParentId# navigation_row linedotted fixlengthlist labelmedium2"  onclick="#vGroupOnClick#" style="#vGroupVisible#">
		   	  <td style="padding-left:10px"></td>
		  	  <td colspan="2" style="height:23px;width:100;padding-left:6px;background-color:##e8e8e880"><cfif form.aggregation is "detail"></cfif>#AccountGroup# #AccountGroupDescription#</td>
			 			  
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
				   			
					<td align="right" style="border:1px dotted gray;padding-right:3px">
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
				  <td align="right" style="width:100;padding-right:10px; background-color:##d4d4d480;">	
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
			
				<tr class="clsDetail_#field#_#vAccountGroupId# navigation_row linedotted labelmedium2 fixlengthlist" style="#vDetailVisible#">
				    <td style="padding-left:5px"></td>
			    	
					<td colspan="2" style="width:100;padding-left:10px;padding-right:10px">#GLAccount# #Description#</td>
				    
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
																	
							<td align="right" style="padding-left:10px;border:1px solid e4e4e4;padding-right:8px"
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
						
						<td class="labellarge" style="padding-left:10px;" align="right" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='transparent'" onclick="#sc#">
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
	<!--- ---------- 
	
	<tr bgcolor="e4e4e4" class="linedotted navigation_row fixlengthlist">	
		  
		  <td></td>
		  <td class="labelmedium2" colspan="2" style="padding-left:4px;padding-right:3px"><CFIF field EQ "Debit"><cf_tl id="Total"> <b><cf_tl id="Assets"><cfelse><cf_tl id="Total"> <b><cf_tl id="Liabilities"></cfif></td>
		 
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
				
				<td class="labelmedium2" align="right" style="padding-left:10px;border:1px dotted gray;padding-right:3px"><font color="808080">
				
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
		  
			    <td class="labelmedium2" align="right" style="padding-left:10px;padding-right:3px">
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
	 
	 --->
 
    <!--- ------------------ --->
 	<!--- Profit / Loss line --->
	<!--- ------------------ --->
	
 	<cfif field eq "Debit">
	
		<cfif form.layout neq "corporate" or dbt lt crt>
	
		<!---<cfif dbt lt crt>--->
			 <tr bgcolor="#FED7CF">
			 	<td></td>
			  	<td colspan="2"  style="height:25px;padding-left:4px" class="labelmedium2"><cfoutput>#Parameter.StatementLabelLoss#</cfoutput></td>
				 
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
						   				
						<td class="labelmedium2" bgcolor="red" align="right" style="font-size:<cfif history eq 'transactionperiod'>14px<cfelse>18px</cfif>;border:1px dotted gray;padding-right:3px">
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
					<td bgcolor="red" width="100" style="font-size:23px;border:1px dotted gray;padding-right:3px; color:white;" align="right" class="labelmedium2">
						<cfoutput>#NumberFormat(crt-dbt,'#frm#')#</cfoutput>
					</td>
					<cfelse>
					<td></td>
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
			  	<cfoutput>#Parameter.StatementLabelProfit#</cfoutput></font>
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
						<td class="labellarge" bgcolor="green" align="right" style="height:25px;border:1px dotted gray;padding-right:3px">
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
