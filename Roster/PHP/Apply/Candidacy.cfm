<cfquery name="Candidacy" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  AF.*, R.Meaning AS StatusDescription
			FROM    ApplicantFunction AF INNER JOIN
		            FunctionOrganization FO ON AF.FunctionId = FO.FunctionId INNER JOIN
		            Ref_StatusCode R ON AF.Status = R.Status INNER JOIN
		            Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition AND R.Owner = S.Owner
			WHERE   R.Id = 'FUN'
			AND     AF.ApplicantNo = '#client.applicantNo#' 
			AND     AF.FunctionId  = '#url.FunctionId#' 
		</cfquery>	
	   
<cfoutput query="Candidacy">   

	   <table width="100%" cellspacing="0" cellpadding="0" bgcolor="D5F1FF">
	   <tr class="navigation_row_child">
	   		<td bgcolor="white" align="left" width="25"><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
	   		<td bgcolor="white" width="140" class="labelit">Application received on:</td>
	   		<td width="100" class="labelmedium" style="padding-left:4px">#DateFormat(Candidacy.FunctionDate)#</b></td>
	   		<td class="labelmedium">#Candidacy.StatusDescription#</td>
	   		<td class="labelmedium">
	   	   		<cfif Candidacy.Status eq "0">
		   			<a title="Withdraw candidacy" href="javascript:withdraw('#FunctionId#','#FunctionId#')"><font color="0080C0"><u>Withdraw My Candidacy</font></a>
		   		</cfif>
	   		</td>
	   </tr>
	   </table>
	   	   
</cfoutput>		

<cfset ajaxonLoad("doHighlight")>   