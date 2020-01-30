<cfparam name="url.accountdelegate" default="">

<cfoutput>
	
	<cfif URL.accountDelegate neq "">
					  
		<cfquery name="Delegate" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.accountdelegate#'
		</cfquery>
		
		<input type="text" class="regularxl" name="lookup" size="40" maxlength="40" value="#Delegate.FirstName# #Delegate.LastName#">
		
	<cfelse>
	  
	  	<input type="text" class="regularxl" name="lookup" value=""  size="40" maxlength="40" readonly >											  
	  
	</cfif>
	
	
	<input type="hidden" name="lastname">
	<input type="hidden" name="firstname">
	<input type="hidden" name="accountdelegate" value="#url.accountdelegate#" >

	<img src="#SESSION.root#/Images/delete5.gif" alt="Select item master" name="img1" 
			  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img1.src='#SESSION.root#/Images/delete4.gif'"
			  style="cursor: pointer;" alt="" border="0" align="absmiddle" 
			  onClick="accountdelegate.value='';lookup.value=''">

</cfoutput>