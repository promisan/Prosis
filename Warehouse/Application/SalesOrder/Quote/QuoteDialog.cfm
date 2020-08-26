
<cfquery name="Request"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  Requestno = '#URL.Requestno#'
	</cfquery>
	
<cfoutput>

<table style="height:100%;width:100%">
<tr><td valign="top" style="border-right:1px solid silver">

	<form name="quote" style="height:100%">
		
	<table style="height:100%;width:300px">
	
		<tr class="labelmedium">
		      <td><cf_tl id="Source">:</td>
		      <td style="font-size:17px">#Request.RequestNo#</td>
		</tr>
	
		<tr class="labelmedium">
		      <td><cf_tl id="Source">:</td>
		      <td style="font-size:17px">#Request.Source#</td>
		</tr>
		<tr class="labelmedium">
		      <td><cf_tl id="Recorded">:</td>
		      <td style="font-size:17px">#Request.OfficerLastName#</td>
		</tr>
		<tr class="labelmedium">
		      <td><cf_tl id="Time">:</td>
		      <td style="font-size:17px">#dateformat(Request.Created,client.dateformatshow)# #timeformat(Request.Created,"HH:MM")#</td>
		</tr>
		
		<tr class="labelmedium line">
		      <td colspan="2"><cf_tl id="Customer request">:</td>
		</tr>
				
		<tr class="labelmedium" style="height:100%" class="line">
		      <td colspan="2" valign="top">
			  <textarea name="remarks" 
			  onchange="ptoken.navigate('#session.root#/warehouse/application/salesOrder/Quote/setQuote.cfm?requestNo=#request.RequestNo#','process','','','POST','quote')"
			  style="border:0px;padding:5px;min-width:290px;max-width:290px;font-size:14px;height:100%;background-color:DAF9FC">#Request.Remarks#</textarea>
			  </td>
		</tr>
	
				
	</table>
	
	</form>

</td>

<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   OrganizationObject
			WHERE  EntityCode = 'WhsQuote'
			AND    ObjectKeyValue1 = '#Request.RequestNo#'
			AND    Operational = 1
		</cfquery>
				
<cfif Object.recordcount gte "1">	
	
	<td style="width:100%;height:100%" valign="top">
		
			<cf_divscroll style="height:100%">			
					<cf_commentlisting objectid="#Object.ObjectId#" ajax="Yes">		
			</cf_divscroll>
	
	</td>

</cfif>

</tr></table>

</cfoutput>

<cfset ajaxonload("initTextArea")>