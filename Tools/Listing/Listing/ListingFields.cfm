
<!--- select the fields to be shown --->

<cfoutput>


<form method="post" name="fieldform" id="fieldform">

	 <table width="99%"
	       height="100%"      
	       align="center">
	     	   	   
		   <tr class="hide"><td id="fieldaction"></td></tr>  
		   
		   <cfloop array="#attributes.listlayout#" index="current">
			   <tr>
			   <td style="padding:2px">
				  <input type="checkbox" 
				      onclick="ColdFusion.navigate('ListingFieldsSubmit.cfm','fieldaction','','','POST','fieldform')"
				      name="selfields" 
					  id="my#current.field#"
				 	  value="#current.field#" <cfif current.display eq "1">checked</cfif>>
			   </td>
			   <td class="labelit" style="cursor:pointer" width="99%" onclick="document.getElementById('my#current.field#').click()">#current.label#</td>
			   </tr>
		   </cfloop>	
		   
		   <tr><td height="90%"></td></tr>   
		   
	</table>

</form>  	
</cfoutput>