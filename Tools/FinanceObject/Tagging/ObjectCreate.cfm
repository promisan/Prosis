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
<!--- add entries is still missing --->

<!--- check if object exists --->

<cftransaction>

<cfquery name="Object" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   FinancialObject O
 WHERE  O.EntityCode   = '#Attributes.EntityCode#' 
 AND    O.Operational  = 1
        #preserveSingleQuotes(condition)# 
</cfquery>
	
<cfif Object.Recordcount eq "0">
				
		<!--- insert --->
		
		<cfif Attributes.Create eq "Yes">
		
			<cfquery name="qCheck" 
			 datasource="AppsLedger"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_Entity
			 WHERE  EntityCode = '#Attributes.EntityCode#' 
			</cfquery>		
		
			<!--- Changed it by Armin on Sept 20th 2013--->			
			<cfif qCheck.recordcount eq 1>
					<cf_AssignId>
														
					<cfquery name="InsertObject" 
					 datasource="AppsLedger"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO FinancialObject 
				           (ObjectId,Mission,
						    EntityCode,
							<cfif f eq "1">
							ObjectKeyValue1, 
							<cfelse>
							ObjectKeyValue4,
							</cfif>
							ObjectReference,
							OfficerLastName,
							OfficerFirstName,
							OfficerUserId)
					 VALUES ('#rowguid#',
					         '#Attributes.Mission#',
					         '#Attributes.EntityCode#',
							 '#Attributes.ObjectKey#', 
							 '#Attributes.ObjectReference#',
							 '#SESSION.last#',
							 '#SESSION.first#',
							 '#SESSION.acc#') 
					</cfquery>
									
					<cfquery name="InsertObjectAmount" 
					 datasource="AppsLedger"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO FinancialObjectAmount 
					           (ObjectId,
							    Currency,
								Amount,
								OfficerLastName,
								OfficerFirstName,
								OfficerUserId)
					 VALUES ('#rowguid#',
					         '#Attributes.Currency#',
							 '#Attributes.Amount#',
							 '#SESSION.last#',
							 '#SESSION.first#',
							 '#SESSION.acc#') 
					</cfquery>
			</cfif>
										
		</cfif>	
				
<cfelse>	
		
		<!--- determine if amount can be merged --->
		
		<cfquery name="Check" 
			 datasource="AppsLedger"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT TOP 1 *
			 FROM FinancialObjectAmount
			 WHERE  ObjectId = '#Object.ObjectId#'
			 AND AmountManual = 0
			</cfquery>
		
		<cfif Check.recordcount gte "1">
		
			<cfquery name="Sum" 
				 datasource="AppsLedger"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT SUM(Amount) as Amount
				 FROM FinancialObjectAmount
				 WHERE  ObjectId = '#Object.ObjectId#'
				 AND SerialNo NOT IN (SELECT SerialNo
									 FROM FinancialObjectAmount
									 WHERE  ObjectId = '#Object.ObjectId#'
									 AND AmountManual = 0)
			</cfquery>
			
			<cfif sum.Amount eq "">
			   <cfset amt = 0>
			<cfelse>
			   <cfset amt = Sum.Amount>
			</cfif>
		
			<cfquery name="Update" 
			 datasource="AppsLedger"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE FinancialObjectAmount
			 SET   Currency = '#attributes.currency#',
			       Amount = #Attributes.Amount-amt# 
			 WHERE  ObjectId = '#Object.ObjectId#'
			 AND SerialNo = '#Check.SerialNo#'
			</cfquery>
			
			<cfquery name="Update" 
			 datasource="AppsLedger"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 DELETE FROM FinancialObjectAmount
			 WHERE  ObjectId = '#Object.ObjectId#'
			 AND    SerialNo != '#Check.SerialNo#'
			 AND    AmountManual = 0
			</cfquery>
					
		<cfelse>
				
			<!--- define difference --->
		
			<cfquery name="Sum" 
				 datasource="AppsLedger"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT SUM(Amount) as Amount, Max(SerialNo) as SerialNo
				 FROM FinancialObjectAmount
				 WHERE  ObjectId = '#Object.ObjectId#'
				</cfquery>
				
				<cfif sum.SerialNo eq "">
				   <cfset ser = 1>
				   <cfset amt = 0>
				<cfelse>
				   <cfset ser = Sum.SerialNo+1>
				   <cfset amt = Sum.Amount>
				</cfif>
				
				<cfif Sum.Amount neq "#Attributes.amount#">
				
					<cfquery name="Last" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT TOP 1 * FROM FinancialObjectAmountCategory 
						 WHERE ObjectId = '#Object.ObjectId#'
						 ORDER BY SerialNo DESC
					</cfquery>
							
					<cfquery name="InsertObjectAmount" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 INSERT INTO FinancialObjectAmount 
						           (ObjectId,
								    SerialNo,
								    Currency,
									Amount,
									OfficerLastName,
									OfficerFirstName,
									OfficerUserId)
						 VALUES ('#Object.ObjectId#',
						         '#ser#',
						         '#Attributes.Currency#',
								 '#Attributes.Amount-amt#',
								 '#SESSION.last#',
								 '#SESSION.first#',
								 '#SESSION.acc#') 
					 </cfquery>
					 
					 <cfif last.serialno neq "">
					 							
						 <cfquery name="InsertObjectAmount" 
							 datasource="AppsLedger"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 INSERT INTO FinancialObjectAmountCategory 
							           (ObjectId,
									    SerialNo,
									    Category,
										OfficerLastName,
										OfficerFirstName,
										OfficerUserId)
							 SELECT ObjectId, 
							        '#ser#', 
									Category,
									OfficerLastName, 
									OfficerFirstName, 
									OfficerUserId 
							 FROM  FinancialObjectAmountCategory
							 WHERE ObjectId = '#Object.ObjectId#'
							 AND   SerialNo = #last.serialNo#
						</cfquery>
						
					</cfif>	
					
				</cfif>	
			
		 </cfif>	
				
</cfif>
	
</cftransaction>	
