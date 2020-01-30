
<!--- get the data --->

<cf_OrgTreeAssignmentData	   
	   presentation  = "summary"
	   mode          = "query"
	   tree          = "#url.tree#"
	   selectiondate = "#url.selectiondate#"
	   orgunit       = "#URL.Unit#"
	   postclass     = "#url.postclass#"
	   fund          = "#url.fund#">


<table width="100%" cellspacing="0" cellpadding="0" bgcolor="ffffef" class="formpadding">

    <tr><td colspan="7" height="1" bgcolor="d4d4d4"></td></tr>
	
	<cfif qDetails.recordcount eq "0">
	
	   <cfoutput>
		<tr><td class="labelit" colspan="6" align="center" style="cursor: pointer;" onClick="details('e#url.Unit#','#url.Unit#','show')">No assignments found.</td></tr>
	   </cfoutput>
	   
	</cfif>		
			
	<cfoutput query="qDetails">
												
		<tr>
			<td width="4">&nbsp;</td>
			
			<td width="45" style="font: xx-small; color: 002350; border: 0px solid black;" style="cursor: pointer;">
				#left(replace(PostGrade,'-',''),3)#
			</td>
			<td width="40" style="font: xx-small; color: 002350; border: 0px solid black;" style="cursor: pointer;">
			    #Fund#
			</td>				
			<td width="40" style="font: xx-small; color: 002350; border: 0px solid black;" style="cursor: pointer;" >
			    #Total#
			</td>				
		</tr>
			
		
	</cfoutput>

</table>	