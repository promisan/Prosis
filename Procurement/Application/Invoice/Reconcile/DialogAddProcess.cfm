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

<cfparam name="url.programcode" default="">
<cfparam name="url.period" default="">
<cfparam name="url.glaccount" default="">

<cfoutput>

   <cfquery name="Mission" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM stLedgerIMIS 
		WHERE  TransactionSerialNo = '#URL.TransactionNo#'
	</cfquery>	
	
	<!--- hardcoded check for CMP to allow --->
	
	<cfif Mission.mission neq "CMP" and url.programcode eq "" or url.glaccount eq "">
	
		<script>
			alert("You must identify a project/program and/or account") 
		</script>
		
		<cfquery name="I" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE stReconciliationIMIS 
				WHERE  reconciliationNo  = '0' 
				AND    TransactionSerialNo = '#URL.TransactionNo#'
		</cfquery>	
		
		<button class="button3" 
	       onClick="setstatus('#URL.TransactionNo#','1')"> 			
			<img align="absmiddle" src="#SESSION.root#/Images/config.gif" align="absmiddle" alt="Report this transaction as Direct Cost" border="0">
		</button>
			
		<cfabort>
			
	</cfif>			

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  * 
		FROM    stReconciliationIMIS
		WHERE   ReconciliationNo    = '0' 
		AND     TransactionSerialNo = '#URL.TransactionNo#'		
	</cfquery>	
	
	<cfif URL.act eq "save">
	
			<cfif Check.recordcount eq "0">
				
				<cfquery name="I" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO stReconciliationIMIS (
				        Mission,
					    ReconciliationNo,
						TransactionSerialNo,
						ProgramCode,
						Period,
						GLAccount,
						ObjectCode
						)
				VALUES ('#mission.mission#',
				        '0',
						'#URL.TransactionNo#',
						'#url.programcode#',
						'#url.period#',
						'#url.glaccount#',
						'#url.ObjectCode#')
				</cfquery>	
			</cfif>

		    <button class="button3" onClick="javascript:setstatus('#URL.TransactionNo#','0')"> 			
				<img align="absmiddle" 
				     src="#SESSION.root#/Images/alert_good.gif" 
					 align="absmiddle" 
					 alt="Undo Direct Cost" 
					 border="0">							
			</button>
			
	<cfelse>
	
			<cfif Check.recordcount neq "0">
			
				<cfquery name="I" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE stReconciliationIMIS 
					WHERE  ReconciliationNo    = '0' 
					AND    TransactionSerialNo = '#URL.TransactionNo#'
					AND    Mission = '#check.mission#'
				</cfquery>	
				
			</cfif>

		    <button class="button3" 
	        onClick="javascript:setstatus('#URL.TransactionNo#','1')"> 			
			<img align="absmiddle" src="#SESSION.root#/Images/config.gif" align="absmiddle" alt="Report this transaction as Direct Cost" border="0">
			</button>
	</cfif>	

</cfoutput>
