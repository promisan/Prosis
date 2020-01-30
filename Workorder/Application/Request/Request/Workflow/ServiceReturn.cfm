
<!--- ------------------------------------------------- --->
<!--- PURPOSE : worflow workorder dialog to be embedded --->
<!--- -assign the request to a user and a service id--- --->
<!--- ------------------------------------------------- --->

<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Request
	WHERE    RequestId = '#Object.ObjectKeyValue4#'	
</cfquery>		

<table width="96%" align="center">
<tr><td height="10"></td></tr>

<!--- ------------------------------------------------- --->
<!--- ------------- EXPIRATION DATE ------------------- --->
<!--- ------------------------------------------------- --->

<tr>
	<td><font color="808080"><cf_tl id="Expiration">:</td>
	<td height="#ht#">	
		
	 <cfif get.DateExpiration eq "">
			
		  <cf_intelliCalendarDate9
			FieldName="dateexpiration"
			Manual="True"	
			Class="regular"	
			ToolTip="Request Expiration Date" 				
			Default=""				
			AllowBlank="True">	
		
	 <cfelse>
	 
		  <cf_intelliCalendarDate9
			FieldName="dateexpiration"
			Manual="True"	
			Class="regular"	
			ToolTip="Request Effective Date" 				
			Default="#Dateformat(get.DateExpiration, CLIENT.DateFormatShow)#"				
			AllowBlank="True">	
	 
	 </cfif>	
		
	</td>
</tr>


<input type="hidden" name="savecustom" id="savecustom" value="WorkOrder/Application/Request/Request/Workflow/ServiceReturnSubmit.cfm">

</table>
