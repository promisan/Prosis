
<cfparam name="elementCode" default="P002">
<cfset url.inputclass = "regularxl">
<cf_textareascript>

<cfquery name="GetElement" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT    T.*
		FROM      Ref_CompositionElement T
		WHERE     ElementCode = '#elementcode#' 		
</cfquery>

<cfquery name="GetTopics" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT    T.*
		FROM      Ref_CompositionElementTopic ET INNER JOIN Ref_Topic T ON ET.Topic = T.Code
		WHERE     ElementCode = '#elementcode#' 
		AND       ET.Operational = 1
		ORDER BY  ListingOrder
</cfquery>

<cfset ajaxonload("initTextArea")>	

<!--- custom fields and saving --->		

<table width="100%">

	<cfoutput>

	<tr class="labelmedium"><td style="font-size:20px">#getElement.ElementName#</td></tr>
		
	<tr><td style="padding-left:20px; padding-right:20px">	
		
		<cfset url.topicclass    = "composition">
		<cfset url.workorderid   = "8fccc2eb-fa3a-4bbd-8393-0000949f76ab">
		<cfset url.workorderline = "1">		
	
		<cfform method="POST" name="topicform">		
		
			<table width="100%">	
					
				<tr><td>
				<table width="100%" border="0" class="formpadding">
				
					<cfloop query="GetTopics">
					
						<tr>
						<td>
					    <cfinclude template="../WorkOrder/Create/CustomFieldsContent.cfm">
						</td>
						</tr>
									
					</cfloop>
				
				</table>	
				</td></tr>
				
				<!---
				
				<cfif editmode eq "EDIT">
							
				<tr><td align="center" style="padding-top:10px;height:33px" id="custom">
				
				   <input type="button" 
					      style="font-size:15px;width:320;height:30px" 
						  name="close" 
						  value="Save" 
						  class="button10g" 
						  onclick="updateTextArea();Prosis.busy('yes');ptoken.navigate('setWorkOrderTopic.cfm?topicclass=request&workorderid=#url.workorderid#&workorderline=#url.workorderline#&domainclass=#domainclass#','custom','','','POST','customform')">
						  
				   </td>
			    </tr>  
				</cfif>
				
				--->
				
			</table>
		
		</cfform>	
		
	</cfoutput>
	
	</td></tr>  
	
</table>		

	