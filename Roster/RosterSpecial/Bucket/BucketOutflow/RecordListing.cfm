
<cf_screentop height="100%" scroll="yes" html="No">

<cfinvoke component="Service.Presentation.Presentation" 
       		   method="highlight" 
			   class="highlight1"
			   returnvariable="stylescroll"/>

		
<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

 <tr><td height="3"></td></tr> 		
 <tr>
	   <td colspan="3" class="labelmedium"><b>Set the roster outflow rules for this bucket</font></td>
 </tr>
	
 <tr><td height="6"></td></tr> 		
		
	<tr class="hide"><td id="process"></td></tr> 
	<tr>
	
		<td width="40" class="label">Ope.</td>
		<td width="80%" class="label">Rule</td>
		<td class="label">Allow<br>reapply</td>
		<td class="label">Send Mail</td>
		
	</tr>
	<tr><td colspan="4" height="1" class="linedotted"></td></tr>
	 	 
	<cfquery name="Rules" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_Rule
		 WHERE  TriggerGroup = 'Bucket'	
	</cfquery>	
	
	<cfset link = "ColdFusion.navigate('../Bucket/BucketOutflow/RecordListingSubmit.cfm','process','','','POST','outflow')">
	
	<form action="outflow" name="outflow" id="outflow">
	
	<cfoutput>
	<input type="hidden" id="idfunction" name="idfunction" value="#url.idfunction#">
	</cfoutput>
	
	<cfoutput query="rules">
	
	<cfquery name="Check" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     SELECT *
		 FROM   FunctionOrganizationOutflow
		 WHERE  RuleCode = '#Code#'	
		 AND   FunctionId = '#url.idFunction#'			
	</cfquery>
	
	 <tr>
	 	 <td height="28"><input type="checkbox" name="#Code#_operational" value="1" onclick="#link#" <cfif check.operational eq "1">checked</cfif>></td>
		 <td class="labelit">#Description#  <input type="Text" name="#Code#_days" class="regular" onchange="#link#" size="2" style="text-align:center" value="#check.days#" maxlength="3"> days</td>
		 <td><input type="checkbox" name="#Code#_AllowReactivation" value="1" onclick="#link#" <cfif check.AllowReactivation eq "1">checked</cfif>></td>
		 <td><input type="checkbox" name="#Code#_MailNotification" value="1" onclick="#link#" <cfif check.MailNotification eq "1">checked</cfif>></td>
	 </tr>
	 <tr><td colspan="4" height="1" class="linedotted"></td></tr>
	
	</cfoutput>
	
	</form>		

</table>	
				

