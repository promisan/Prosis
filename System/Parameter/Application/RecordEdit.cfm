
<cfajaximport tags="cfwindow">



<!--- Entry form --->
	
  <tr> <td colspan="9" height="6"></td> </tr>
	
  <tr>
  
	<td></td>
	
    <td>
		<cfoutput> 
			#Code# 
			<input type="hidden" name="Code" value="#code#">
		</cfoutput>
    </td>

    <td>
  	  <!---
	   <cfinput type="Text" name="Description" value="#Description#" message="Please enter a description" required="Yes" size="40" maxlength="50"class="regular">
	   --->
	   <table width="100%" align="center">
	   
	   		<cf_LanguageInput
				TableCode       		= "Ref_Application" 
				Mode            		= "Edit"
				Name            		= "Description"
				Key1Value       		= "#Code#"
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
			<cfoutput query="GetHost">
				<option value="#HostName#" <cfif GetApplication.HostName eq GetHost.HostName>selected</cfif>>#HostName#
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
			<option value="#Code#" <cfif GetApplication.Owner eq Code>selected</cfif>>#Description#</option>
		</cfoutput>
		</select>

    </td>

    <td>
	
		<table >
			<tr>
				<td id="acc_row"> 	
					<cfoutput>
					  <cfif OfficerManager neq "">#FirstName# #LastName# (#OfficerManager#)</cfif> 
					  <input type="hidden" name="acc" id="acc" value="#OfficerManager#"> 
					</cfoutput>
				</td>
				
				<td style="padding-left:4px;">
					<cf_selectlookup
						box          = "acc_row"
						title        = ""
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
       <input type="radio" name="Operational" value="1" <cfif Operational eq 1>checked</cfif>>Yes
  	   <input type="radio" name="Operational" value="0" <cfif Operational eq 0>checked</cfif>>No
    </td>
	
	<td colspan="2">
	
		<input type="button" class="button10g" value="Save" onclick="save('edit')">
	
	</td>
	
</tr>

<tr> <td colspan="9" height="6"></td> </tr>
<tr> <td colspan="9" height="1" class="linedotted"></td> </tr>
