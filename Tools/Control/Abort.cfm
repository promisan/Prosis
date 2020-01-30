
<!--- --compression-- --->
<cf_compression>
<!--- --------------- --->

<cfif URL.ID eq "Abort">

    <!--- user pressed so now we add a record that triggers a request record that responds to wait --->
	
    <cfquery name="AbortRequest" 
     datasource="AppsSystem">
	 INSERT INTO stReportStatus
	    (ControlId,OfficerUserId)
	 VALUES
	    ('#URL.ID1#','#SESSION.acc#')
    </cfquery>
	
	<cfoutput>
		<table cellspacing="0" cellpadding="0"><tr><td>
		<img src="#SESSION.root#/Images/busy4s.gif" id="stopping" border="0" align="absmiddle">
		</td>
		<td style="padding-left:5px" class="labelmedium">
		<font color="FF0000">Stopping</font>
		</td></tr>
		</table>
	</cfoutput>

<cfelse>

	<!--- resuming --->
	
	<cfquery name="List" 
     datasource="AppsSystem">
	 DELETE  FROM stReportStatus
	 WHERE   ControlId     = '#URL.ID1#'
	 AND     OfficerUserId = '#SESSION.acc#'
    </cfquery>

	<cfset client.abort = "0">

</cfif>
