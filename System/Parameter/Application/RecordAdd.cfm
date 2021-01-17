
<cfajaximport tags="cfwindow">

<cfform action="" method="POST" name="applicationform" onsubmit="return false;">

<!--- Entry form --->
	
  <tr> <td colspan="8" height="6"></td> </tr>
	
  <tr>
  
	<td></td>
	
    <td>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20"class="regular">
    </td>

    <td>
	   	<table width="100%" align="center">
		 	<cf_LanguageInput
			TableCode       		= "Ref_Application" 
			Mode            		= "Edit"
			Name            		= "Description"
			Type            		= "Input"
			Required        		= "Yes"
			Message         		= "Please, enter a valid description."
			MaxLength       		= "50"
			Size            		= "50"
			Class           		= "regular"
			Operational     		= "1"
			Label           		= "Yes">
	    </table>
    </td>

	<td>
		<cfquery name="GetHost" 
		 datasource="AppsInit" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 	SELECT * 
			FROM   Parameter
		 
		</cfquery>

		<cfselect name="HostName">
		    <option value=""></option>
			<cfoutput query="GetHost">
				<option value="#HostName#" >#HostName#
			</cfoutput>
		</cfselect>
	</td>
	
    <td>
	
		<cfquery name="GetOwner" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
				 SELECT * 
				 FROM   Ref_AuthorizationRoleOwner
				 
		</cfquery>
	
		<select name="Owner">
		<cfoutput query="GetOwner">
			<option value="#Code#">#Description#</option>
		</cfoutput>
		</select>

    </td>

    <td>
	
		<table >
			<tr>
				<td id="acc_row"> 	<input type="hidden" name="acc" id="acc" value=""> </td>
				
				<td style="padding-left:4px;">
					<cf_selectlookup
						box          = "acc_row"
						title        = "User"
						link         = "userAccount.cfm?"  
						button       = "no"
						icon         = "search.png"
						close        = "Yes"
						class        = "user"
						des1         = "acc">	
				</td>
			</tr>
		</table>	
		
    </td>
	
    <td>
       <input type="radio" name="Operational" value="1" checked>Yes
  	   <input type="radio" name="Operational" value="0">No
    </td>
	
	<td colspan="2">
		<input type="button" class="button10g" value="Save" onclick="save('new')">
	</td>
	
</tr>

<tr> <td colspan="8" height="6"></td> </tr>
<tr> <td colspan="8" height="1" class="linedotted"></td> </tr>

</CFFORM>

