
<cfparam name="CLIENT.payables" default="">
<cfparam name="url.value" default="">

<cfquery name="Person"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT THA.PersonNo, P.LastName, P.FirstName, P.Gender
	FROM   TransactionHeaderActor AS THA INNER JOIN
           Employee.dbo.Person AS P ON THA.PersonNo = P.PersonNo
		   
	WHERE  EXISTS (SELECT 'X' 
	               FROM userquery.dbo.Inquiry_#url.mode#_#session.acc# P
				   <cfif client.payables eq "">
				   WHERE 1=1
				   <cfelse>
				   #PreserveSingleQuotes(Client.Payables)# 
				   </cfif>
		
				   AND Journal         = THA.Journal
				   AND JournalSerialNo = THA.JournalSerialNo	
				   
					<cfif url.value eq "Upcoming">
						AND		Days <= 0
					</cfif>		
					<cfif url.value eq "1-30d">
						AND		Days > 7.0 AND Days <= 30
					</cfif>
					<cfif url.value eq "31-60d">
						AND		Days > 31.0 AND Days <= 60
					</cfif>
					<cfif url.value eq "61-90d">
						AND		Days > 61.0 AND Days <= 90
					</cfif>
					<cfif url.value eq "91-180d">
						AND		Days > 91.0 AND Days <= 180
					</cfif>
					<cfif url.value eq "Over 180d">
						AND		Days > 180.0
					</cfif>		
					)	
					
		GROUP BY THA.PersonNo, P.LastName, P.FirstName, P.Gender
		ORDER BY P.LastName			   
						 
</cfquery>

<table width="100%">

<tr class="line labelmedium"><td style="height:30px;padding-top:4px"><cf_tl id="Document Owner"></td></tr>

<tr><td style="padding:10px">
	<table  width="100%" class="navigation_table" navigationselected="silver">
	<tr class="line navigation_row labelmedium navigation_action" onclick="reload('person','undefined')">
			<td style="padding-left:3px"><cf_tl id="Any"></td>
		</tr>
	<cfoutput query="Person">
		<tr class="line navigation_row labelmedium navigation_action" onclick="reload('person','#personno#')">
			<td style="padding-left:3px">#LastName#</td>
		</tr>
	</cfoutput>						 
	</table>
</td></tr></table>

<cfset ajaxonload("doHighlight")>