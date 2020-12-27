<cfparam name="URL.mode" default="descriptive">
<cfoutput>

<cfif License eq 1>
	
	<cfset c = "#year(now())##quarter(now())#">	
	
	<cfoutput>
	
	<table style="width:100px" class="formpadding">
	
	<tr>
		<td class="labelmedium2" style="width:10px">
		<cfif c GT "#vyear##vquarter#">			
		    <!--- <img src="#SESSION.root#/Images/delete5.gif" height="13" width="13" alt="Expiration" border="0" align="absmiddle"> --->
			<font color="FF0000">
				<cfif vyear eq ""><cf_tl id="Expired"></cfif>		
			</font>
		<cfelse>	
		    <img src="#SESSION.root#/Images/check_icon.gif" style="height:20px" alt="License is in order" border="0" align="absmiddle">	
			<font color="008080">				
		</cfif>	
		</td>
	
		<cfif url.mode eq "descriptive">
			<td class="labelmedium2" style="padding-left:4px">
			<cfswitch expression="#vquarter#">
			  <cfcase value="1">
			   Mar #vyear#
			  </cfcase>
			  <cfcase value="2">
			   Jun #vyear#
			  </cfcase>
			  <cfcase value="3">
			   Sep #vyear#
			  </cfcase>
			  <cfcase value="4">
			   Dec #vyear#
			  </cfcase>
			</cfswitch>
			</td>
		</cfif>												
	
	</table>
	
	</cfoutput>	
	
<cfelse>	

     <cfoutput>
	 <table cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
     <!--- <img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0" align="absmiddle">	--->
	 </td><td class="labelmedium2">
	 <font color="FF0000">Invalid Key</font>	
	 </td></tr>
	 </table>
	 </cfoutput>		
	 
</cfif>
</cfoutput>