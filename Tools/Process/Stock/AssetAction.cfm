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
<cfparam name="Attributes.TransactionId"   default="">
<cfparam name="Attributes.AssetId"    	   default="">
<cfparam name="Attributes.DataSource"      default="appsMaterials">
<cfparam name="Attributes.TransactionDate" default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.TransactionTime" default="#timeformat(now(),'HH:MM')#">
<cfparam name="Attributes.ActionType"  	   default="">
<cfparam name="Attributes.Metric1"    	   default="">
<cfparam name="Attributes.MetricValue1"    default="0">
<cfparam name="Attributes.Metric2"    	   default="">
<cfparam name="Attributes.MetricValue2"    default="0">
<cfparam name="Attributes.Metric3"    	   default="">
<cfparam name="Attributes.MetricValue3"    default="0">
<cfparam name="Attributes.Metric4"    	   default="">
<cfparam name="Attributes.MetricValue4"    default="0">
<cfparam name="Attributes.Metric5"    	   default="">
<cfparam name="Attributes.MetricValue5"    default="0">

<cfset dateValue = "">
<CF_DateConvert Value="#Attributes.TransactionDate#">
<cfset dte = dateValue>

<cfset Header = FALSE>

<cfloop from="1" to="5" index="i">

	<cfset CategoryMetric = Evaluate("Attributes.Metric#i#")>
	<cfset j = 0>
	
	<cfset Category = "">
	<cfset Metric = "">
	
	<cfloop list="#CategoryMetric#" delimiters="." index="element">
		<cfif j eq 0>
			<cfset Category = element>	
		<cfelse>
			<cfset Metric   = element>	
		</cfif>
		<cfset j = j + 1>
	</cfloop>
	
	<cfset Value  = Evaluate("Attributes.MetricValue#i#")>
	
			
	<cfif Category neq "" and Metric neq "" and (Value neq "" and Value neq "0")>
		
		<cfif NOT Header>
				
			<cf_AssignId>
			<cfset Id = rowguid>			
			<cfset Header = TRUE>			

			<!--- Taking the default value for the category --->
			
			<cfquery name = "qCategory" 
		     datasource="#Attributes.DataSource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT   TOP 1 ListCode
				FROM     Ref_AssetActionList
				WHERE    Code = '#Category#'
				AND      Operational = '1'
				AND      ListDefault = '1'
				ORDER BY ListOrder 		
			</cfquery>			

			<cfquery name = "qMode" 
		     datasource="#Attributes.DataSource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT   AC.DetailMode
				FROM 	 AssetItem	AI INNER JOIN Item I ON AI.ItemNo = I.ItemNo
					     INNER JOIN Ref_AssetActionCategory AC ON I.Category = AC.Category			
				WHERE  	 AC.ActionCategory = '#Category#'
				AND  	 AI.AssetId = '#Attributes.AssetId#'
			</cfquery>						
			
			<cfset c_dte  = dte>
			
						
			<cfswitch expression="#qMode.DetailMode#">

			<cfcase value="None">
				<cfset c_dte  = dte>
				<cfset vHour = 0>					
			</cfcase>	
			
			<cfcase value="Hour">
				<cfset Pos = Find(":",Attributes.TransactionTime)>
				<cfif Pos neq 0>
					<cfset vHour = Mid(Attributes.TransactionTime,1,pos-1)>
				<cfelse>
					<cfset vHour = 0>	
				</cfif>
				<cfset c_dte = DateAdd("h", vHour, dte)>
				
			</cfcase>	
				
			<cfcase value="Standard">
			<!---- This is the transactional mode per hour and minute---->
			
				<cfset Pos = Find(":",Attributes.TransactionTime)>
				<cfif Pos neq 0>
					<cfset vHour = Mid(Attributes.TransactionTime,1,pos-1)>
					<cfset vMinute = Mid(Attributes.TransactionTime,pos+1,Len(Attributes.TransactionTime))>		
				<cfelse>
					<cfset vHour = 0>	
					<cfset vMinute = 0>						
				</cfif>

				<cfset c_dte = DateAdd("h", vHour, dte)>
				<cfset c_dte = DateAdd("n", vMinute, c_dte)>		
						
			</cfcase>							
			
			</cfswitch>
			
			<cfif attributes.actiontype eq "">
			
				<cfif vHour eq 0>
					<cfset attributes.actiontype = "Standard">
				<cfelse>
				    <cfset attributes.actiontype = "Detail">									
				</cfif>	
						
			</cfif>
			
			<cfquery name = "qInsertAction" 
		     datasource="#Attributes.DataSource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			INSERT INTO AssetItemAction 
			    (AssetActionId,
				 TransactionId,
				 AssetId,
				 ActionDate,
				 ActionType, 
				 ActionCategory,
				 ActionCategoryList,
				 ActionMemo,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)			
			VALUES ('#Id#',
				'#Attributes.TransactionId#',
				'#Attributes.AssetId#',
				#c_dte#,
				'#Attributes.ActionType#',								
				'#Category#',
				'#qCategory.ListCode#',
				'',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
			</cfquery>
			
		</cfif>		
	
		<cfquery name = "qInsertMetric" 
	     datasource="#Attributes.DataSource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			INSERT INTO AssetItemActionMetric 
				  (AssetActionId,
				   Metric,
				   MetricValue,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
			VALUES
				 ('#Id#','#Metric#','#Value#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>	
								
	</cfif> 
	
</cfloop>	