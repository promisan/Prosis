<cfparam name="first" default="0">
<cfparam name="pages" default="0">
<cfparam name="embed" default="0">
<cfparam name="header" default="1">
<cfparam name="URL.grouping" default="Journal">

<!--- provision --->
<cfif URL.ID eq "PO">
	<cfset url.id = "Journal">
</cfif>

<cfif pages gte "1">

<tr><td colspan="11" class="line"></td></tr>
<tr class="line">
   <td colspan="2" height="20">
		<cfinclude template="Navigation.cfm"> 
   </td>
</tr>

</cfif>

<TR><td colspan="2" valign="top" height="100%">

	<cfif embed eq "0">

		<cf_divscroll>		
		<cfinclude template="TransactionListingLinesContent.cfm">						
		</cf_divscroll>
		
	<cfelse>
	
		<cfinclude template="TransactionListingLinesContent.cfm">	
	
	</cfif>	
	
</td>

</tr>

 <cfif pages gte "1">	

 	 <tr><td colspan="2" class="line"></td></tr>
	 <tr class="line"><td height="14" colspan="2" class="regular">
			<cfinclude template="Navigation.cfm">
	 </td></tr>
	 
 </cfif> 
  
  