
<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Object
		WHERE    Code = '#URL.ObjectCode#'		
	</cfquery>

<cfquery name="Type" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ObjectFundType
		WHERE    Code = '#URL.ObjectCode#'		
</cfquery>
	
<cfif action eq "Display">
		
	<table cellspacing="0" cellpadding="0">
		<tr>
		<td height="15" style="padding-left:30px"></td>
		<cfoutput query="Type">
		<cfif CodeDisplay neq "">
		<td class="labelit">#FundType#:</td><td>#CodeDisplay#</td><td>&nbsp;</td>
		</cfif>
		</cfoutput>
		<td class="labelit"><cfoutput>#Object.Description#</cfoutput></td>
		</tr>
	</table>	

<cfelse>

	<cfoutput>
	 <table cellspacing="0" cellpadding="0">
		 <tr>
			 <td height="15" style="padding-left:30px"></td>
			 <td><cf_space spaces="10" class="labelit" padding="0" label="#Object.CodeDisplay#"></td>
			 <td><cf_space spaces="70" class="labelit" padding="0" label="#Object.Description#"></td>
			 </tr>					
	 </table>
	 </cfoutput>

</cfif>
