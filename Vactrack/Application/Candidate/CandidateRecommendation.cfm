
<!--- candidate recommendation --->

<cfquery name="get" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT   A.*				   
		   FROM    DocumentCandidate DC INNER JOIN
                   Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
                   Ref_Status S ON DC.Status = S.Status    				   	   
		  WHERE    DC.DocumentNo = '#url.documentNo#'		 
		  AND      DC.PersonNo = '#url.personno#'		 
</cfquery>

<table width="96%" height="100%" align="center">

<tr class="labelmedium line">
<td style="height:30px;font-size:18px"><cf_tl id="Candidate"></td>
<td style="width:80%;;font-size:18px"><cfoutput>#get.LastName#, #get.FirstName#</cfoutput></td>
</tr>

<tr class="labelmedium line">
<td style="height:30px;font-size:18px"><cf_tl id="Recommend candidate"></td>
<td style="width:80%">
		<input class="Radiol" style="height:21px;width:21px" type="checkbox" 
		name="ReviewStatus_#CurrentRow#" id="ReviewStatus_#CurrentRow#" 
		value="#url.wFinal#" <cfif url.Status gte wFinal>checked</cfif> style="cursor:pointer;">					
</td>
</tr>

<tr><td style="height:2px"></td></tr>

<tr class="labelmedium" style="height:80%">
<td colspan="2" valign="top">

 <cf_textarea name="Memo#url.Personno#"           		 
			 init="Yes"							
			 color="ffffff"	 
			 resize="false"		
			 border="0" 
			 toolbar="Mini"
			 height="80%"
			 width="100%"></cf_textarea>
</td>
<td>

</tr>

<tr><td colspan="2" align="center">
	<table>
	<tr>
	<td><input type="button" value="close" name="Close" class="button10g" onclick="ProsisUI.closeWindow('decisionbox')"></td>
	<td><input type="button" value="submit" name="Submit" class="button10g"></td>
	</tr>
	</table>
</td></tr>

</table>

<cfset ajaxonload("initTextArea")>