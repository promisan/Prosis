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
<cfparam name="Attributes.RequisitionNo" default="">
<cfparam name="Attributes.TopicsPerRow" default="5">
<cfparam name="Attributes.Show" default="Yes">

<cfoutput>

	<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT I.EntryClass
	    FROM   RequisitionLine L,ItemMaster I
	    WHERE  RequisitionNo =  '#attributes.RequisitionNo#'
		AND    L.ItemMaster = I.Code
	</cfquery>	

	<cfquery name="getCustomFields" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    R.Description,R.TopicLabel, V.TopicValue
		FROM      #client.lanPrefix#Ref_Topic R INNER JOIN
                  Ref_TopicEntryClass E ON R.Code = E.Code AND E.EntryClass = '#get.EntryClass#' 				  
				  LEFT OUTER JOIN  RequisitionLineTopic V ON R.Code = V.Topic 
				                                           AND V.RequisitionNo = '#attributes.RequisitionNo#'
		 WHERE    R.TopicClass = 'Requisition'		
		 AND      R.Operational = 1
		 ORDER  BY ListOrder  
				
	</cfquery>	
	
	
	<cfif attributes.show eq "yes">
	
		<cfif getCustomFields.recordcount gte "1">
										
		<table>
		
		<cfset vTotal = Attributes.TopicsPerRow>
		<cfset i = 0>
		
		<cfloop query="getCustomFields">
			<cfif i eq 0>
				<tr class="labelmedium2" style="height:18px">
			</cfif>					
				<td style="padding-left:0px;font-size:12px;min-width:70px"><cfif topiclabel eq "">#Description#<cfelse>#TopicLabel#</cfif>:</td>
				<td style="mon-width:200px;padding-left:3px;padding-right:7px;"><cfif TopicValue eq "">n/a<cfelse>#TopicValue#</cfif></td>
				<cfset i = i + 1>
	
			<cfif i eq vTotal>
				<cfset i = 0>
				</tr>
			</cfif>			
			
		</cfloop>
		</table>
		
		</cfif>
		
	<cfelse>
	
		<cfset caller.requisition = "#getCustomFields.recordcount#">	
		
	</cfif>
		
</cfoutput>