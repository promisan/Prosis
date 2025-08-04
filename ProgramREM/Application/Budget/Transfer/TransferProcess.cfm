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

<cfquery name="Lines"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Sum(Amount) as Amount, 
		       count(*) as Lines
		FROM #SESSION.acc#BudgetTransfer_#client.sessionNo# 
	</cfquery>
	
	<cfif Lines.Amount eq "0" and Lines.Lines gte "2">
	   		
			<input type="button" name="Close" value="Close" class="button10s" style="width:120;height:22" onclick="window.close()">	
			<input type="button" name="Submit" style="width:120;height:22"
				value="Transfer" 
				class="button10g" 
				onclick="ColdFusion.navigate('TransferSubmit.cfm','result','','','POST','transferform')">	
			
	</cfif>
