
<cfajaximport tags="cfform">

<table width="100%" height="100%" bgcolor="FFFFFF">

<script>

 function listaction(id) {
  ptoken.location("ActionHeader.cfm?id="+id)
 } 
 
</script>

<tr><td height="20">
   <cfset ctr = 1>
   <cfinclude template="../PersonViewHeader.cfm">
   </td>
</tr>



<tr><td valign="top" height="100%">
   <table width="98%" cellspacing="0" cellpadding="0" align="center">
      
	<cfoutput>
		<tr><td height="20"><a href="javascript:listaction('#url.id#')"><font color="0080C0">Return to Personnel Action History</a></td></tr>
	</cfoutput>
   
   <tr><td height="1" colspan="2" class="line" height="1"></td></tr>
   
    <tr><td>
			
		<cfquery name="ActionList" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Ref_Action
			WHERE    (CustomForm != '' and CustomForm is not NULL)
			AND      Operational = 1
			ORDER By ListingOrder
		</cfquery>
		
		<tr>
		   <td height="24" width="20%">Personnel Action:</td>
		   <td>
		   
		   <select name="actioncode" style="font:10px">   
			   <cfoutput query="ActionList">
				   <option value="#ActionCode#">#Description#</option>
			   </cfoutput>
		   </select>
		      
		   </td>
		</tr>
		
		<tr><td colspan="2" height="1" class="line"></td></tr>
		
		<cfoutput>
		
		<tr><td colspan="2">
			
			<table width="100%">
			
			<tr>
			   <td colspan="2">
			       <cf_securediv bind="url:#SESSION.root#/staffing/application/employee/personaction/ActionForm.cfm?scope=add&mode=edit&actioncode={actioncode}"
				     id="content">
			   </td>
			</tr>
			
			<tr><td height="1" class="line" colspan="2"></td></tr>
			
			<tr><td colspan="2" align="center" height="30">
			
				<input type="button" 
						   name="Close" 
						   value="Close" 
						   class="button10g" 
						   onclick="listaction('#url.id#')" 
						   style="height:20;width:100px">	
			
			   <input type="button" 
						   name="Save" 
						   value="Save" 
						   class="button10g" 
						   onclick="ptoken.navigate(document.getElementById('formsave').value,'content','','','POST','actionform')" 
						   style="height:20;width:100px">	
			
			</td></tr>
			
			</table>
		
		</td></tr>
		</cfoutput>
	
   </table>
</td></tr>
</table>