
<cfparam name = "URL.searchid"  default = "">
<cfparam name = "URL.Mode"      default = "edit">

<cfquery name = "check" 
  datasource= "AppsSystem"  
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT *
	FROM   CollectionLogCriteria
	WHERE  SearchId  = '#URL.searchid#'
</cfquery>

<cfif URL.searchid neq "">

	<table width="96%" cellspacing="0" cellpadding="0" align="center">
								
		<cfquery name="qCriteria" 
		    datasource = "AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
		    FROM      CollectionLogCriteria
		    WHERE     SearchId     = '#URL.searchId#'
			AND       SearchClass  = '#URL.class#'
		    ORDER BY  Created ASC,SearchClass
		</cfquery>
						
		<tr bgcolor="ffffff">		
			<td align="left" width="20%">
					
			<table width="100%"
			   border="0"						   
			   cellspacing="0"
			   cellpadding="0">
									
				<cfif url.mode eq "new">
				
					<cfoutput>
								
					<tr>
						  
						<td width="10%" style="padding:3px"></td>
							
						<td style="padding:3px" height="24">
						
						    <cfset vCondition = replace(URL.Where,"|","'","ALL")>
							<cfquery name ="qFields" 
							   datasource ="appsCaseFile"  
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								SELECT  T.Code, T.Description, ValueClass as 'Data_Type'
								FROM    Ref_TopicElementClass TC INNER JOIN
								        Ref_Topic T ON T.Code = TC.Code
								WHERE   1=1 #PreserveSingleQuotes(vCondition)#
								AND
								(
								 EXISTS
								(
									SELECT 'X'
									FROM ElementTopic
									WHERE Topic = T.Code
								)
								OR 
								ElementClass = 'Person'
								)
								ORDER   BY TC.ListingOrder
							</cfquery>				
							
															
							<select name="field" id="field" style="width:190;font:11px" 
								   onChange = "list_operators('#url.mode#','#url.searchid#','#url.ds#','#url.db#','#url.table#',this.options[this.selectedIndex].value, '#url.layout#','#url.Class#','0','#url.where#')">
										 							 
									 <cfif class eq "Claim">							 
										<option value="ClaimType"><cf_tl id="Case Type"></option>
										<option value="ClaimTypeClass"><cf_tl id="Case"></option>
									 	<option value="DocumentNo"><cf_tl id="Case No."></option>
										<option value="DocumentDescription"><cf_tl id="CaseFile"></option>
									 </cfif>
									 	 
									 <cfif URL.Layout eq 1>
										 
										 <cfloop query = "qFields">
										 	<cfif (Data_Type eq "varchar" or Data_Type eq "Int" or Data_Type eq "Datetime") or URL.Layout eq 1 >
												<option value="#qFields.Code#">#qFields.Description#</option>
											</cfif>	
										 </cfloop>		
												 
									 </cfif>
							</select>		 
										
						</td>		
						
						<td align="left" name="doperator_#url.class#" id="doperator_#url.class#" colspan="4" style="padding:3px" width="70%">
						
						    <cfset url.field = qFields.Code>
							<cfset url.operator = "0">
						
							<cfinclude template="AdvancedSearchOperator.cfm">					
						
						</td>		
											
					</tr>
					
					</cfoutput>
							
				</cfif>		
				
				<cfoutput>
				
				<cfif qCriteria.recordcount gte "2">
				
				<tr><td colspan="6" align="right">		
				    <a href="javascript:do_delete('#URL.searchid#','','#url.class#')"><font face="Verdana" color="FF0000"><cf_tl id="UNDO ALL"></font></a>
				</td>
				</tr>	
			    </cfif>
				
				
				</cfoutput>
				
				<cfoutput query="qCriteria" group="SearchClass">				
				
				<cfset topic = "">
						
				<cfoutput>
									
				<tr>
				<td>											  
				  		  			
				</td>					
										
				<td colspan="2" style="border-top:1px dotted silver" width="200">	
				
					<table cellspacing="0" border="0" cellpadding="0" class="formpadding">
					
					<tr>
										
					<td style="padding-left:10px;padding-right:4px">
						<img style="cursor:pointer" 
						     src="#SESSION.root#/images/delete1.gif" 
							 border="0" 
							 align="absmiddle"
							 onclick="javascript:do_delete('#searchid#','#SearchLine#','#url.class#')">					
					</td>
											
					<cfif searchfield neq topic>	
					
						<td style="padding-left:10px;padding-right:4px" width="100">	
						<font face="Verdana">		
				
						<cfif Layout eq "0">
							#SearchField#
						<cfelse>
							<!--- Element --->
							<cfquery name="qTopic" datasource= "AppsCaseFile">
								SELECT * 
								FROM Ref_Topic
								WHERE (TopicClass = 'Element' or TopicClass = 'Person')
								AND Code = '#SearchField#'
							</cfquery>		
																		
							<cfif qTopic.recordcount neq 0>
								#qTopic.Description#
							</cfif>
						</cfif>
											
						</td>
					
					<cfelse>
					
					<td style="padding-left:10px;padding-right:4px"  width="100" align="right"><font face="Verdana" color="0080C0">	<cf_tl id="OR"></td>
					
					</cfif>
										
					<td style="padding-left:10px;padding:1px" width="70">
					<font face="Verdana" color="808080">#Operator#:</font>
					</td>
					
					<td style="padding:1px">
					<font face="Verdana">
								
					<cfif Layout eq 0>
					
						<cfswitch expression = "#SearchFieldType#">
						
						<cfcase value = "varchar">
						
							<cfif Operator neq "Like">
							<cfquery name = "qList" datasource = "#ListDataSource#">
								SELECT #ListPK# as 'Code', #ListDisplay# as Description
								FROM #ListTable#
								WHERE 
								<cfif ListCondition neq "">
								#PreserveSingleQuotes(ListCondition)#
								AND 
								</cfif>
								#ListPK# =  '#ListValue#' 
							</cfquery>	
		
								<cfif qList.RecordCount neq 0>
									#qList.Description#
								<cfelse>
									#ListValue#
								</cfif>
							<cfelse>
								#Condition1#				
							</cfif>				
							
						</cfcase>					
						
						<cfdefaultcase>
							<cfif #Condition1# neq "">
								#Condition1#
							</cfif>
							<cfif #Condition2# neq "">
								- #Condition2#
							</cfif>
							<cfif ListValue neq "">
								#ListValue#
							</cfif>
						
						</cfdefaultcase>	
									
						</cfswitch>
						
					<cfelse>
					
			 			<cfswitch expression = "#SearchFieldType#">
						<cfcase value = "List">
							<cfquery name = "qList" datasource = "AppsCaseFile">
								SELECT ListValue
								FROM Ref_TopicList
								WHERE Code = '#SearchField#'
								AND ListCode = '#ListValue#' 
							</cfquery>	
		
							<cfif qList.RecordCount neq 0>
								#qList.ListValue#
							</cfif>
							
						</cfcase>
						<cfcase value = "Lookup">
							<cfquery name = "qList" datasource = "#ListDataSource#">
								SELECT #ListPK# as 'Code', #ListDisplay# as Description
								FROM #ListTable#
								WHERE 
								<cfif ListCondition neq "">
								#PreserveSingleQuotes(ListCondition)#
								AND 
								</cfif>
								Code =  '#ListValue#'
							</cfquery>	
		
							<cfif qList.RecordCount neq 0>
								#qList.Description#
							</cfif>
							
						</cfcase>	
						
						<cfcase value = "varchar">
							<cfquery name = "qList" datasource = "#ListDataSource#">
								SELECT #ListPK# as 'Code', #ListDisplay# as Description
								FROM #ListTable#
								WHERE 
								<cfif ListCondition neq "">
								#PreserveSingleQuotes(ListCondition)#
								AND 
								</cfif>
								Code =  '#Condition1#'
							</cfquery>	
		
							<cfif qList.RecordCount neq 0>
								#qList.Description#
							<cfelse>
								#Condition1#
							</cfif>
							
						</cfcase>					
						
						<cfdefaultcase>
							<cfif #Condition1# neq "">
								#Condition1#
							</cfif>
							<cfif #Condition2# neq "">
								- #Condition2#
							</cfif>
							<cfif ListValue neq "">
								#ListValue#
							</cfif>
						
						</cfdefaultcase>	
									
						</cfswitch>
						
					</cfif>	
					
					</td>					
				
					<cfset topic = searchfield>
								
				</tr>
				</table>
				</td>
				
			</tr>	
			
			</cfoutput>		
			
			</cfoutput>
			
			</table>
								
			</td>
		
		</tr>		
				
	</table>
		
</cfif>



