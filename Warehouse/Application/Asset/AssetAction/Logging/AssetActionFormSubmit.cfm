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
<cfoutput>

<cfset cnt = 1>
<cfset rlist = "">

<cfloop list="#form['IDS']#" index="element">
	
	<cf_AssignId>
	<cfset Id = rowguid>

	<cfset Category = trim(listGetAt(FORM['actions'], cnt))>
	<cfset Memo     = trim(listGetAt(FORM['memos'], cnt))>
	<cfset HR       = trim(listGetAt(FORM['HRS'], cnt))>
	
	<cfif Memo eq "null">
		<cfset Memo = "">
	</cfif>

	<CF_DateConvert Value="#Form['RecordingDate']#">
	<cfset tDate = dateValue>	

	<cfif NOT ListContains(rlist, element)>

		<cfset vDateStart = DateAdd("h", 0, tDate)>
		<cfset vDateEnd   = DateAdd("h", 24, tDate)>

		<cfquery name = "qDeleteAction" 
		    datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE AssetItemAction 
			WHERE  AssetId = #PreserveSingleQuotes(element)#
			AND    ActionDate >= #vDateStart#
			AND    ActionDate <= #vDateEnd#
			AND    ActionCategory = '#FORM['sAction']#'
		</cfquery>	
	
		<cfset rlist = rlist & "," & element>
		
	</cfif>
			
	<cfset PROCESS = TRUE>	
	<cfset pos_minute = Find("-",HR)>

	<cfif pos_minute neq 0>

		<cfset vHour = Mid(HR,1,pos_minute-1)>
		<cfset vMinute = Mid(HR,pos_minute+1,Len(HR))>		
		
		<cfif vHour eq "|1">
			<cfset PROCESS = FALSE> <!---- We ignore the lines that the user left blank--->
		<cfelse>
		    <cfset vDate = DateAdd("h", vHour, tDate)>		
		    <cfset vDate = DateAdd("n", vMinute, vDate)>
		</cfif>		

	<cfelse>	
	
	    <cfset vDate = DateAdd("h", HR, tDate)>
		
	</cfif>	

	<cfif PROCESS>	
		
			<cfset INSERT_FIRST = TRUE>
		
			<cfset pos = ListContains(FORM['values'], replace(element & "_" & HR,"'","","ALL"))>

			<cfif pos neq 0>
		
				<cfloop condition="pos neq 0">
		
					<cfset combination = listGetAt(FORM['values'], pos)>
				
					<cfset i = 0>
					
					<cfloop list="#combination#" index="key" delimiters="_">
					
						<cfswitch expression="#i#">
						
							<cfcase value="0">
								<cfset vAssetId = key>
							</cfcase>
							<cfcase value="1">
								<!---- nothing it is the time--->
							</cfcase>
							<cfcase value="2">
								<cfset vMetric = key>
							</cfcase>
							<cfcase value="3">
								<cfset vValue = key>
							</cfcase>
			
						</cfswitch>	
					
						<cfset i = i + 1>
						
					</cfloop>
					
					<cfif vValue neq "null">

						<cfif INSERT_FIRST>					
						
							<cfset INSERT_FIRST = FALSE>
							
							<!---- Check if there is a transaction Id --->
							<cfset vTransactionId = "">
							<cfset trans = replace(element & "_" & HR & "_","'","","ALL")>
							<cfset pos_transaction = ListContains(FORM['transactions'], trans)>
							
							<cfif  pos_transaction neq 0>
							
								   <!--- the HR involved an ID --->
								   <cfset vTransactionId = Replace(listGetAt(FORM['transactions'], pos_transaction),trans,"","ALL")>
								   
							</cfif>
							
							<cfquery name  = "qInserAction" 
							    datasource = "AppsMaterials" 
								username   = "#SESSION.login#" 
								password   = "#SESSION.dbpw#">
								INSERT INTO AssetItemAction 
									   (AssetActionId,
									    AssetId,
										ActionDate,
										ActionType,
										ActionCategory,
										ActionCategoryList,
										ActionMemo,
										OperationMode,
										<cfif vTransactionId neq "">
											TransactionId,
										</cfif>
										OfficerUserId,
										OfficerLastName,
										OfficerFirstName)
								VALUES ('#Id#',
										#PreserveSingleQuotes(element)#,
										#vDate#,
										<cfif HR eq 0>
											'Standard',
										<cfelse>
											'Detail',				
										</cfif>
										'#FORM['sAction']#',
										'#Category#',
										'#Memo#',
										'#Category#',
										<cfif vTransactionId neq "">
											'#vTransactionId#',
										</cfif>
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#')
							</cfquery>				
							
						</cfif>								

						<cfquery name = "qInsertMetric" 
						         datasource="AppsMaterials" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								INSERT INTO AssetItemActionMetric 
									   (AssetActionId,Metric,MetricValue,OfficerUserId,OfficerLastName,OfficerFirstName)
								VALUES ('#Id#',
								        '#vMetric#',
										'#vValue#',
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#')
						</cfquery>						

		
					</cfif>			
				
					<cfset FORM['values'] = ListDeleteAt(FORM['values'], pos)>			
					<cfset pos = ListContains(FORM['values'], replace(element & "_" & HR,"'","","ALL"))>
					
				</cfloop>
				
			</cfif>
	</CFIF>
	
	<cfset cnt = cnt + 1>

</cfloop>

</cfoutput>

<cf_compression>
