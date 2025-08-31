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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<!-- ensure defaults are set --->

<cfif Parameter.EnablePurchaseClass eq "1">

		<cfquery name="def" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_PurchaseClass 
			WHERE   SetAsDefault = 1
		</cfquery>
		
		<cfif def.recordcount eq "0">
		
		<cf_tl id="Problem, default class has not been defined. Please contact your administrator" var="1" class="Message">
		<cf_message message="#lt_text#">
		<cfabort>
		
		<cfelse>

			<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  RequisitionNo, OrderAmount as Amount
				FROM    PurchaseLine 
				WHERE   PurchaseNo = '#URL.ID1#'
			</cfquery>
			
			<cfloop query="Lines">
						
				<cfquery name="Class" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  sum(AmountPurchase) as Total
					FROM    PurchaseLineClass 
					WHERE   RequisitionNo = '#RequisitionNo#'
					AND     PurchaseClass != '#def.Code#'
				</cfquery>
								
				<cfif Class.total eq "">
					<cfset cla = 0>
				<cfelse>
					<cfset cla = Class.total>
				</cfif>
				
				<cfif abs(Amount - cla) gte 0.01 and def.recordcount eq "1">
				
					<cftry>
					
						<cfquery name="PurchaseClass" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO PurchaseLineClass 
								(RequisitionNo, 
								 PurchaseClass, 
								 AmountPurchase, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
								VALUES
								('#requisitionno#',
								 '#def.Code#',
								 '#Amount - cla#',
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')
						</cfquery>
								
						<cfcatch>
							
								<cfquery name="PurchaseClass" 
								datasource="AppsPurchase" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE PurchaseLineClass 
									SET    AmountPurchase  = '#Amount - cla#'
									WHERE  RequisitionNo = '#requisitionno#'
									AND    PurchaseClass = '#def.Code#'
								</cfquery>
							
						</cfcatch>
					
					</cftry>	
						
				</cfif>
				
			</cfloop>	
			
		</cfif>	
		
</cfif>
