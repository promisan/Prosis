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
<cfparam name="URL.payerid"  default="">
	
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset DEFF = dateValue>		

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateExpiration#">
<cfset DEXP = dateValue>

<cfif DEXP gte DEFF>

	<cfif FORM.Mission1 neq "">
		
		<cfif URL.payerId eq "">
		
			<cftransaction>
		
				<cfquery name="PayerTree" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  TOP 1 Mission,TreeCustomerPayer
					FROM    Ref_ParameterMission
					WHERE   TreeCustomerPayer IS NOT NULL  		
				</cfquery>	
				
				<cfquery name="qCheck"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Customer
					WHERE  PersonNo = '#URL.ID#'
					AND    Mission  = '#url.mission#'
				</cfquery>		
								
				<cfif qCheck.recordcount eq 0>
				
					<!---- We need to create the customer ---->
					
					<cf_assignid>
					<cfset cId = rowguid>
					
					<cfquery name="qApplicant"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   Applicant.dbo.Applicant
						WHERE  PersonNo = '#URL.ID#'
					</cfquery>				
					
					<cfif qApplicant.recordcount neq 0>
						
						<cfset vName="">
						<cfif qApplicant.FirstName neq "">
							<cfset vName = "#vName# #qApplicant.FirstName#">
						</cfif>	
		
						<cfif qApplicant.MiddleName neq "">
							<cfset vName = "#vName# #qApplicant.MiddleName#">
						</cfif>	
		
						<cfif qApplicant.LastName neq "">
							<cfset vName = "#vName# #qApplicant.LastName#">
						</cfif>
		
						<cfif qApplicant.LastName2 neq "">
							<cfset vName = "#vName# #qApplicant.LastName2#">
						</cfif>
											
						<cfquery name="qInsert"
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO Customer(CustomerId,Mission,PersonNo,CustomerName,OfficerUserId,OfficerLastName,OfficerFirstName)
								VALUES ('#cId#',
								        '#PayerTree.Mission#',
										'#URL.ID#',
										'#vName#',
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#')
						</cfquery>						
		
					</cfif>
						
				<cfelse>
				
					<cfset cId = qCheck.CustomerId>		
						
				</cfif>	

				<cfquery name="qReferenceCheck"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   CustomerPayer
					WHERE  AccountNo = '#FORM.AccountNo#'
					AND    CustomerId  = '#cId#'
					AND    OrgUnit     = '#FORM.ReferenceOrgUnit1#'					
				</cfquery>
			
				<cfif qReferenceCheck.recordCount eq 0>
				
					<cfset error = false>	
					
					<cfquery name="qInsert"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO CustomerPayer
						
						  (CustomerId,
						   DateEffective,
						   DateExpiration,
						   OrgUnit,
						   AccountNo,
						   Reference,
						   Status,
						   Memo,
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName)
						  
						VALUES 
						
						 ('#cId#',
						  #DEFF#,
						  #DEXP#,
						  '#Form.ReferenceOrgUnit1#',
						  '#Form.AccountNo#',
						  '#Form.Reference#',
						  0,
						  '#Form.Remarks#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
						  
					</cfquery>
					
				<cfelse>
				
					<cfquery name="qReferenceCheck"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   CustomerPayer
						WHERE  AccountNo = '#FORM.AccountNo#'
						AND    CustomerId  = '#cId#'
						AND    OrgUnit     = '#FORM.ReferenceOrgUnit1#'		
						AND    Status      != '9'			
					</cfquery>

					<cfif qReferenceCheck.recordCount eq 1>

						<cfquery name="qUpdate"
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							UPDATE CustomerPayer 
							SET    DateEffective  = #DEFF#,
								   DateExpiration = #DEXP#,
							       OrgUnit        = '#FORM.ReferenceOrgUnit1#',
							       AccountNo      = '#FORM.AccountNo#',
							       Reference      = '#Form.Reference#'							       
								   Status         = '0',
								   Memo			  = '#Form.Remarks#'
							WHERE  AccountNo = '#FORM.AccountNo#'
							AND    CustomerId  = '#cId#'
							AND    OrgUnit     = '#FORM.ReferenceOrgUnit1#'		
							
						</cfquery>
																			
					<cfelse>
				
						<cfset error = true>
						
					</cfif>	
					
				</cfif>		
				
			</cftransaction>	
			
			
		<cfelse>
		
			<cftransaction>
				
				<cfquery name="qReferenceCheck"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  * 
					FROM    CustomerPayer
					WHERE   PayerId != '#URL.PayerId#'
					AND     OrgUnit    = '#FORM.ReferenceOrgUnit1#'
					AND     AccountNo  = '#FORM.AccountNo#'
				</cfquery>
			
				<cfquery name="qCustomerPayer"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT CustomerId
				  	FROM  CustomerPayer
				  	WHERE PayerId = '#URL.PayerId#'
				</cfquery>  		
				
				<cfquery name="qCustomer"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT PersonNo
				  	FROM  Customer
				  	WHERE CustomerId = '#qCustomerPayer.CustomerId#'
				</cfquery>  		


				<cfset URL.ID = qCustomer.PersonNo>		
			
			
				<cfif qReferenceCheck.recordCount eq 0>
				
					<cfset error = false>
					
					<cfquery name="qUpdate"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						UPDATE CustomerPayer 
						SET    DateEffective  = #DEFF#,
							   DateExpiration = #DEXP#,
						       OrgUnit        = '#FORM.ReferenceOrgUnit1#',
						       AccountNo      = '#FORM.AccountNo#',
						       Reference      = '#Form.Reference#',
						       Memo			  = '#Form.Remarks#'
						WHERE  PayerId        = '#URL.PayerId#'
						
					</cfquery>
					
				<cfelse>
					<cfset error = true>
				</cfif>		
				
			</cftransaction>
			
		</cfif>	
		
		<cfif error>
		
			<cf_tl id = "Reference already exists" var="mReference">
			<cfoutput>
			<script>
			     Prosis.busy('no')
				Ext.Msg.alert('Status', '#mReference#', function(){
					$('##accountNo').focus();
				});
			</script>
			</cfoutput>				
			
		<cfelse>
		
			<cfoutput>
				<script>				    
				    _cf_loadingtexthtml='';
					ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerListingDetail.cfm?mission=#url.mission#&owner=#URL.owner#&id=#URL.id#','dPayerListing')
				</script>		
			</cfoutput>
			
		</cfif>			
		
	</cfif>	

<cfelse>

    
	<cf_tl id = "Date Expiration is less than Date Effective. This is not allowed" var="mDateExpirationLess">
	<cfoutput>
	<script>
	    Prosis.busy('no')
		Ext.Msg.alert('Status', '#mDateExpirationLess#', function(){
			$('##DateExpiration').focus();
		});
	</script>
	</cfoutput>	

</cfif>