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

<!--- make sure -fields- are always made visible by default based on the action --->

<cfparam name="formname" default="formactor">
  	   
<cfquery name="Function" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
	     SELECT    R.*, W.ListingOrder, W.ObjectFilter
		 FROM      Ref_EntityDocument R, Ref_EntityActionPublishDocument  W
		 WHERE     DocumentType = 'function'
		 AND       DocumentCode != 'fmes'
		 AND       R.Operational = 1
		 AND       R.DocumentMode    = 'Embed'
		 AND       R.DocumentId      = W.DocumentId 
		 AND       W.ActionCode      = '#Action.ActionCode#'
		 AND       W.ActionPublishNo = '#Object.ActionPublishNo#' 
		 AND       W.Operational = 1
		 ORDER BY  W.ListingOrder 
</cfquery>
 
<cfif function.recordcount gte "1">

	<tr><td colspan="2">
	
		<table width="100%">
					
			<cfoutput query="function">	  
			   		
				<!---	 					 
				 <cf_ProcessActionTopic name="#DocumentCode#"  
				   mode  = "Expanded"  
				   title = "#DocumentDescription#"
				   click = "openfunction('#DocumentCode#','#Object.ObjectId#','#DocumentCode#','#DocumentCode#','#Action.ActionCode#')">
				   --->
										   
				 <tr class="labelmedium2"><td style="font-size:18px">#DocumentDescription#</td></tr>
				 <tr>
				 <td id="#DocumentCode#">	
				 				 
				 <!--- define the targets --->
				 								 		 
				 <cfswitch expression="#DocumentCode#">
					 <cfcase value="fnts">
					 	<cfset sc = "#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box=#DocumentCode#_#Object.ObjectId#&mode=note&objectid=#Object.ObjectId#&actioncode=#Action.ActionCode#&actionid=#url.id#">
						<cfdiv bind="url:#sc#" id="#DocumentCode#_#Object.ObjectId#">		
					 </cfcase>
					 <cfcase value="fact">
			  		 	<cfset sc = "#SESSION.root#/tools/entityaction/details/actor/ActorView.cfm?formname=#formname#&box=#DocumentCode#_#Object.ObjectId#&mode=cost&objectid=#Object.ObjectId#&actioncode=#Action.ActionCode#">
						<cfdiv bind="url:#sc#" id="#DocumentCode#_#Object.ObjectId#">		
					 </cfcase>		  
					 <cfcase value="fexp">
			  		 	<cfset sc = "#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box=#DocumentCode#_#Object.ObjectId#&mode=cost&objectid=#Object.ObjectId#&actioncode=#Action.ActionCode#&actionid=#url.id#">
						<cfdiv bind="url:#sc#" id="#DocumentCode#_#Object.ObjectId#">		
					 </cfcase>		  
					 <cfcase value="ftme"> 
					 	<cfset sc = "#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box=#DocumentCode#_#Object.ObjectId#&mode=work&objectid=#Object.ObjectId#&actioncode=#Action.ActionCode#&actionid=#url.id#">
						<cfdiv bind="url:#sc#" id="#DocumentCode#_#Object.ObjectId#">		
					 </cfcase>		 
					 <cfcase value="ftpl"> 
					 	<cfset sc = "#SESSION.root#/tools/entityaction/details/template/Template.cfm?box=#DocumentCode#_#Object.ObjectId#&mode=template&objectid=#Object.ObjectId#&actioncode=#Action.ActionCode#">
						<cfdiv bind="url:#sc#" id="#DocumentCode#_#Object.ObjectId#">		
					 </cfcase>		
					 					 
					 <cfcase value="fled"> 
					 
					 	 <cfquery name="JournalList" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Journal
							WHERE    Mission = '#Object.mission#'
							AND      Operational = 1
							AND      TransactionCategory = '#ObjectFilter#'					
						</cfquery>	
																		
						<cfif JournalList.recordcount gte "1">  
						
							<table width="100%" cellspacing="0" cellpadding="0">
							<tr><td id="#DocumentCode#_#Object.ObjectId#">
					 
						 	<cf_LedgerTransaction
								 mission             = "#Object.mission#"
								 journal             = "#valueList(JournalList.Journal)#" 
							     TransactionSource   = "WorkflowSeries" 			 
								 TransactionSourceId = "#Object.ObjectId#"
								 editmode            = "edit"
								 label               = "Financial Transaction"
								 debitcredit         = "Debit"				 
								 box                 = "#DocumentCode#_#Object.ObjectId#">		
							 
							</td></tr>
							</table> 			 
							 
						 </cfif>	 
					 
					 </cfcase>	 
					 
				 </cfswitch>
								
				 </td></tr>					
				 		  	   
			</cfoutput>	   
		
		</table>
	
	</td></tr>
		   
</cfif>   
