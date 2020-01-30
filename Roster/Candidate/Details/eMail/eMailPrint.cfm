<cfquery name="Mail" 
 datasource="AppsSelection">
 SELECT *
 FROM   ApplicantMail 		
 WHERE  MailId = '#URL.ID#' 
</cfquery>

<cfquery name="Action" 
 datasource="AppsSelection">
 SELECT *
 FROM   RosterAction
 WHERE  RosterActionNo = '#Mail.RosterActionNo#' 
</cfquery>

<cfdocument 
          format="PDF"
          pagetype="letter"
          margintop="0.5"
          marginbottom="0.5"
          marginright="0.5"
          marginleft="0.5"
          orientation="portrait"
          unit="cm"
          encryption="none"
          fontembed="Yes"
          scale="100"
          backgroundvisible="Yes">
		  
	<table width="100%">
	
	<cfoutput query="Action">
	
		<tr>
		   <td style="font-size: xx-small;"><cf_tl id="Name"></td>
		   <td style="font-size: xx-small;">#Action.OfficerUserFirstName# #Action.OfficerUserLastName#</td>
		</tr>
		<tr>
		   <td style="font-size: xx-small;"><cf_tl id="Action"></td>
		   <td style="font-size: xx-small;">#Action.ActionCode#</td>
		</tr>
		<tr>
		   <td style="font-size: xx-small;"><cf_tl id="Date"></td>
		   <td style="font-size: xx-small;">#DateFormat(Action.Created, CLIENT.DateFormatShow)#</td>
		</tr>
		<tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
		<tr><td colspan="2"></td></tr>
	
	</cfoutput>
	
	<tr><td colspan="2">
	
	<cfoutput>#Mail.mailbody#</cfoutput>
	
	</td></tr>
		
	
	</table>

</cfdocument>
