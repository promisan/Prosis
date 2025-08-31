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

<cfparam name="Attributes.Event1"    	   default="">
<cfparam name="Attributes.EventDate1"      default="">
<cfparam name="Attributes.EventDetails1"   default="">

<cfparam name="Attributes.Event2"    	   default="">
<cfparam name="Attributes.EventDate2"      default="">
<cfparam name="Attributes.EventDetails2"   default="">

<cfparam name="Attributes.Event3"    	   default="">
<cfparam name="Attributes.EventDate3"      default="">
<cfparam name="Attributes.EventDetails3"   default="">

<cfparam name="Attributes.Event4"    	   default="">
<cfparam name="Attributes.EventDate4"      default="">
<cfparam name="Attributes.EventDetails4"   default="">

<cfparam name="Attributes.Event5"    	   default="">
<cfparam name="Attributes.EventDate5"      default="">
<cfparam name="Attributes.EventDetails5"   default="">

<cfloop from = "1" to = "5" index="i">

	<cfset Event        = Evaluate("Attributes.Event#i#")>
	<cfset EventDate    = Evaluate("Attributes.EventDate#i#")>
	<cfset EventDetails = Evaluate("Attributes.EventDetails#i#")>	
	
	<cfif Event neq "">
	
		<cfquery name = "qInsertMetric" 
	     datasource="#Attributes.DataSource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
			INSERT INTO AssetItemEvent
				       (AssetId, 
					    EventCode, 
						DateTimePlanning, 
						EventDetails, 
						TransactionId, 
						ActionStatus, 
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
			VALUES ('#Attributes.AssetId#',
			        '#Event#',
					'#EventDate#',
					'#EventDetails#',
					'#Attributes.TransactionId#',
					'1',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
		</cfquery>		
		
	</cfif>						
	
</cfloop>	