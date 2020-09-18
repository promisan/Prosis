
<!--- listing of the action --->

<cfquery name="SearchResult" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT      DCRA.ActionId,
	            R.DocumentCode, 
	            R.DocumentDescription, 
				DCRA.ActionDateStart, 
				DCRA.ActionMemo, 
				DCRA.ActionStatus,
				(SELECT count(*) FROM Organization.dbo.OrganizationObjectActionMail WHERE DCRA.ActionId = ActionId) as MailCount,				
				DCRA.OfficerLastName,
				DCRA.Created
				
	FROM        DocumentCandidateReviewAction AS DCRA 
	            INNER JOIN      Organization.dbo.Ref_EntityDocument AS R ON DCRA.DocumentId = R.DocumentId 
	WHERE       DCRA.DocumentNo = '#url.documentNo#'
	AND         DCRA.PersonNo   = '#url.personno#'	
	
	ORDER BY    DCRA.Created DESC 			

</cfquery>


<table width="100%" class="navigation_table">

<cfoutput>
<tr class="labelmedium line" style="height:20px">
   <td style="min-width:200px"></td>
   <td style="min-width:120px"><cf_tl id="Due"></td>   
   <td style="width:100%"><cf_tl id="Message"></td>
   <td style="min-width:160px"><cf_tl id="Officer"></td>
   <td style="min-width:120px"><cf_tl id="Recorded"></td>
   <td></td>
</tr>
</cfoutput>

<cfoutput query="SearchResult">
	
	<tr class="labelmedium <cfif actionmemo eq "" and currentrow neq recordcount>line</cfif> navigation_row" style="height:15px">
	   <td style="padding-left:4px">#DocumentDescription#</td>
	   <td>#dateformat(ActionDateStart,client.dateformatshow)# #timeformat(ActionDateStart,"HH:MM")#</td>	
	   	 
	   <td style="background-color:##e1e1e180;padding-left:3px;padding-right:3px">
	   
	   <cfif mailcount gte "1">
	   
		    <cfquery name="Mail" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT      *				
				FROM       Organization.dbo.OrganizationObjectActionMail AS OM 
				WHERE      ActionId = '#actionid#'			
				ORDER BY   Created DESC 			
		   </cfquery>	
	   		  
		   <table>
		   <cfloop query="Mail">
		     <tr class="<cfif currentrow neq Mail.recordcount>line</cfif> labelmedium" style="height:10px">
			         <td style="padding-left:2px;min-width:30px">#serialno#.</td>
			         <td style="min-width:120px;padding-right:5px">#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>
					 <td>#MailTo# : #MailSubject#</td>
			 </tr>
		   </cfloop>
		   </table>
	   
	   </cfif>
	   
	   </td>
	   <td style="padding-left:2px">#OfficerLastName#</td>
	   <td>#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>
	   <td style="padding-top:2px">
	   <!---
	   <cfif actionstatus eq "0">
	   	  <cf_img onclick="deleteactivity('#ActionId#','#url.documentNo#','#url.personno#','#url.actioncode#')" icon="delete">
	   </cfif>
	   --->
	   </td>
	</tr>
	<cfif actionmemo neq "">
	<tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>" style="border-top:1px dotted silver;height:15px">   
	   <td colspan="6" style="padding-left:4px">#ActionMemo#</td>  
	</tr>
	</cfif>

</cfoutput>

</table>
	
<cfset ajaxonload("doHighlight")>	