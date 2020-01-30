
<cfquery name="Log" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     R.Code, 
	           R.Description, 
			   E.TopicValue, 
			   E.ToTopicValue,
			   E.ExpirationDate, 
			   A.OfficerUserId, 
			   A.OfficerFirstName, 
			   A.OfficerLastName,
			   A.Created,
			   A.ActionId
	FROM       ElementTopicLog E INNER JOIN
	           Ref_Topic R ON E.Topic = R.Code INNER JOIN
			   CaseAction A ON E.ActionId = A.ActionId			   
	WHERE      E.ElementId = '#url.elementid#' 
	ORDER BY   A.Created DESC
</cfquery>

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td colspan="7" height="10"></td></tr>
	
	<tr>
	   <td class="labelit"><font face="Verdana"><cf_tl id="Officer"></td>
	   <td class="labelit"><font face="Verdana"><cf_tl id="Field"></td>
	   <td class="labelit"><font face="Verdana"><cf_tl id="Name"></td>
	   <td class="labelit"><font face="Verdana"><cf_tl id="Prior Value"></td>
	   <td class="labelit"><font face="Verdana"><cf_tl id="New Value"></td>  
	   <td class="labelit"><font face="Verdana"><cf_tl id="Until"></td>	  
	</tr>
	<tr><td class="line" colspan="7"></td></tr>
	<cfif log.recordcount eq "0">
	<tr><td align="center" colspan="6" height="40" class="labelmedium"><font face="Verdana" size="2"><cf_tl id="There are no records to show in this view"></td></tr>
	</cfif>
	
	<cfoutput query="Log" group="Created">
	
	<tr>
	<td colspan="4" style="padding-top:2px;padding-bottom:2px" class="labelit"><font face="Verdana" color="808000">#officerfirstname# #officerLastname#</font> <font face="Verdana" color="black">on</font> <font face="Verdana" color="808000">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(expirationDate,"HH:MM")#</font></td>
	</tr>
	
	<tr><td colspan="7" style="border-top:1px dotted silver"></td></tr>
	
	<tr><td></td><td colspan="4">
		
	 <cf_filelibraryN
			DocumentPath="CaseAmendment"
			SubDirectory="#actionid#" 
			Filter = ""						
			Presentation="all"
			box="box_#actionid#"
			Insert="no"
			Remove="no"
			loadscript="no"		
			width="100%"									
			border="1">	
	
	</td>
	
	</tr>
		
	<cfoutput>
	
	<tr>
	    <td></td>
	    <td class="labelit"><font face="Verdana">#Code#</td>
	    <td class="labelit"><font face="Verdana">#Description#</td>	
		<td class="labelit"><font face="Verdana">#TopicValue#</td>
		<td class="labelit"><font face="Verdana">#ToTopicValue#</td>		
	</tr>	
	
	</cfoutput>	
	
	<tr><td height="7"></td></tr>
	</cfoutput>
</table>