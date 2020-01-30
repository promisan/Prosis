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
				<tr class="labelmedium" style="height:18px">
			</cfif>					
				<td style="padding-left:0px;min-width:70px"><cfif topiclabel eq "">#Description#<cfelse>#TopicLabel#</cfif>:</td>
				<td width="150" style="padding-left:3px;padding-right:7px;"><cfif TopicValue eq "">n/a<cfelse>#TopicValue#</cfif></td>
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