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
<cfset dateValue = "">
<cf_DateConvert Value="#Form.dateEffective#">
<cfset vDateEffective = dateValue>
<cf_tl id = "All transaction losses must be a number between 0% and 100%." class="text" var="msg">

<cfquery name="lossClasses" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT   *
		FROM     Ref_LossClass
</cfquery>

<cfset isDirty = 0>

<cfloop query="lossClasses">

	<cfset vCodeFormatted = replace(Code," ","","ALL")>	
	
	<cfif isDefined('form.lossClass_#vCodeFormatted#')>
		
		<cfif Evaluate("form.lossCalculation_#vCodeFormatted#") eq "Transaction">
			<cfif Evaluate("form.lossQuantity_#vCodeFormatted#") lt 0 or Evaluate("form.lossQuantity_#vCodeFormatted#") gt 100>
				<cfset isDirty = 1>
			</cfif>
		</cfif>
		
	</cfif>

</cfloop>

<cfif isDirty eq 0>

	<cftransaction>

		<cfquery name="clear" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				 DELETE FROM ItemWarehouseLocationLoss
				 WHERE		Warehouse = '#url.warehouse#'
				 AND       	Location = '#url.location#'		
				 AND		ItemNo = '#url.itemNo#'
				 AND		UoM = '#url.UoM#'
				 AND		DateEffective = #vDateEffective#
		</cfquery>
	
		<cfloop query="lossClasses">
	
			<cfset vCodeFormatted = replace(Code," ","","ALL")>	
		
			<cfif isDefined('form.lossClass_#vCodeFormatted#')>
			
				<cfset vLossQuantity = Evaluate("form.LossQuantity_#vCodeFormatted#")>
				<cfif Evaluate("form.LossCalculation_#vCodeFormatted#") eq "Transaction">
					<cfset vLossQuantity = vLossQuantity / 100>
				</cfif>
			
				<cfquery name="insert" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">		 		 	  
						 INSERT INTO ItemWarehouseLocationLoss
						 	(
								Warehouse,
								Location,
								ItemNo,
								UoM,
								DateEffective,
								LossClass,
								LossCalculation,
								<cfif trim(Evaluate("form.transactionClass_#vCodeFormatted#")) neq "">TransactionClass,</cfif>
								LossQuantity,
								AcceptedPointer,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						 VALUES
						 	(
								'#url.warehouse#',
								'#url.location#',
								'#url.itemNo#',
								'#url.uom#',
								#vDateEffective#,
								'#Evaluate("form.LossClass_#vCodeFormatted#")#',
								'#Evaluate("form.LossCalculation_#vCodeFormatted#")#',
								<cfif trim(Evaluate("form.transactionClass_#vCodeFormatted#")) neq "">'#Evaluate("form.transactionClass_#vCodeFormatted#")#',</cfif>
								'#vLossQuantity#',
								#Evaluate("form.AcceptedPointer_#vCodeFormatted#")#,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
				
			</cfif>
			
		</cfloop>
	
	</cftransaction>
			
	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog');
			ColdFusion.navigate('../LocationItemLosses/AcceptableLosses.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#url.uom#&effectivedate=#Form.dateEffective#&class=','contentbox2');
		</script>
	</cfoutput>

<cfelse>
	<cfoutput>
	<script>
		alert('#msg#');
	</script>
	</cfoutput>
			
</cfif>