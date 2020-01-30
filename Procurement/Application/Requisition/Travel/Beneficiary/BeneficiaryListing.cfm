<cfquery name="Traveller" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *,
				(SELECT Name FROM System.dbo.Ref_Nation WHERE Code = B.Nationality) as NationalityName
	    FROM  RequisitionLineBeneficiary B
		WHERE RequisitionNo = '#URL.RequisitionNo#'
		ORDER BY LastName, FirstName, birthDate
</cfquery>

 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
				
    <tr class="line labelmedium">
	   <td><cf_tl id="LastName"></td>	
	   <td><cf_tl id="FirstName"></td>	
	   <td width="20%"><cf_tl id="Nationality"></td>
	   <td><cf_tl id="DOB"></td>		   
	   <td><cf_tl id="Passport"></td>					  
	   
	   <td align="right">
	   
	    <cfoutput>
		 <cfif url.access eq "Edit">
		 <!---				 	
		     <A href="javascript:lookupperson('#url.mission#','parent.opener.selectBeneficiary')">[<cf_tl id="add">]</a>
			 --->
			 <A href="javascript:editBeneficiary('')">[<cf_tl id="add">]</a>
		 </cfif>
		 </cfoutput>
	   
	   </td>		   
	 </tr>
	 
	 <cfoutput query="traveller">
	 	<tr class="navigation_row" class="labelmedium line">
			<td style="padding-left:4px">#lastName#</td>
			<td>#firstName#</td>
			<td>#NationalityName#</td>
			<td>#dateformat(birthdate, client.dateformatshow)#</td>
			<td>#reference#</td>
			<td align="right">
				<cfif url.access eq "Edit">
					<table>
						<tr>
							<td><cf_img icon="edit" onclick="editBeneficiary('#beneficiaryId#')"></td>
							<td><cf_img icon="delete" onclick="removeBeneficiary('#beneficiaryId#')"></td>
						</tr>
					</table>				
				 </cfif>
			</td>
		</tr>
	 </cfoutput>
	 
</table>

<cfset AjaxOnLoad("doHighlight")>