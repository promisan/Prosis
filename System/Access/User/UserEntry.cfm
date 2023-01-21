 
<cfparam name="URL.ID" default="Individual">
<cfparam name="URL.Mode" default="">


<cfoutput>

<script language="JavaScript">
    		 
	function formvalidate() {
		document.userenter.onsubmit() 
		if( _CF_error_messages.length == 0 ) {            
			  ptoken.navigate('UserEntrySubmit.cfm?mode=#URL.Mode#','result','','','POST','userenter')	 
		 }   
	}	 

</script>

</cfoutput>

<cfquery name="Group" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AccountGroup
</cfquery>

<cfquery name="Owner" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AuthorizationRoleOwner
	WHERE 1=1
	<cfif SESSION.isAdministrator eq "No">
	AND  Code IN (SELECT ClassParameter 
	               FROM   Organization.dbo.OrganizationAuthorization
               	   WHERE  Role        IN ('AdminUser','OrgUnitManager') 
				   AND    UserAccount = '#SESSION.acc#')
	</cfif>	
	AND   Operational = 1
	ORDER BY ListingOrder,Description		   
</cfquery>

<cfif Owner.recordcount eq "0">

	<cf_message message = "Your are not authorised to define user or user group for any owner. Operation not allowed."
	  return = "">
	<cfabort>

</cfif>

<cfinvoke component   = "Service.Access"  
	   method         = "useradmin" 
	   accesslevel    = "'0','1','2'"
	   returnvariable = "accessUserAdmin">

<cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL" or getAdministrator("*") eq "1">

	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   * 
	    FROM     Ref_Mission
		WHERE    Operational   = '1'
		-- AND      MissionStatus = '1'
		ORDER BY MissionType
	</cfquery>
	
<cfelse>

	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_Mission
		WHERE  Mission IN (SELECT Mission 
		                   FROM   OrganizationAuthorization 
						   WHERE  UserAccount = '#SESSION.acc#'
						   AND    Role = 'OrgUnitManager')
		AND    Operational   = '1'
		-- AND    MissionStatus = '1'	
		ORDER BY MissionType			  
	</cfquery>

</cfif>

<cfif Mission.recordcount eq "0" AND SESSION.isAdministrator eq "No">

	<cf_message message = "Your are not authorised to define user or user group for any owner. Operation not allowed."
	  return = "">
	<cfabort>

</cfif>

<cfif url.mode eq "">
     <cfset html = "Yes">
<cfelse>
	<cfset html= "No">
</cfif>

<cfif URL.ID eq "Individual">
	<cf_ScreenTop height="100%" html="#html#" jquery="Yes" band="no" layout="webapp" 
	label="Register User Account" scroll="Yes">
<cfelse>
	<cf_ScreenTop height="100%" html="#html#" jquery="Yes" band="No" layout="webapp" banner="blue"  label="Register User Group" scroll="No">
</cfif>

<cf_dialogStaffing>
<cf_dialogPosition>

<cfajaximport tags="cfdiv">

<!--- Entry form --->

<cfform style="height:97%" name="userenter" onsubmit="return false">

<table width="96%" border="0" height="100%"      
	   class="formpadding"
       align="center">
	 
<cf_menuscript>

<cfif URL.ID eq "Individual">	

<tr><td height="30">	

		<table width="100%" 	     
		  height="100%"		  
		  align="center">	  
		  <tr>

			<cfset wd = "44">
			<cfset ht = "44">		
					
				<cf_menutab item       = "1" 
				            iconsrc    = "Logos/User/Settings.png" 
							iconwidth  = "#wd#" 
							class      = "highlight1"
							iconheight = "#ht#" 
							name       = "Account Settings">			
								
				<cf_menutab item       = "2" 
				            iconsrc    = "Logos/User/UserGroup.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							name       = "Set Group Membership">							
								
				<td width="20%"></td>
										
		</tr>
		
		</table>
	</td>					
								
</tr>

</cfif>

<tr><td height="1" colspan="1" class="line"></td></tr>		

<tr><td height="100%">

		<cf_divscroll>

		<table width="100%" 
	      height="100%"
		  align="center">	  
	 		
			<tr class="hide"><td valign="top" id="result"></td></tr>
			   
			<cf_menucontainer item="1" class="regular">
				
				<cfinclude template="UserEntryDetail.cfm">
				
			</cf_menucontainer>
							
			<cf_menucontainer item="2" class="hide">
			  <cfif URL.ID eq "Individual">
				<cfinclude template="../Membership/MemberSelect.cfm">
		 	  </cfif>
			</cf_menucontainer>
	
	</table>	
	
	</cf_divscroll>		
	
	</td>
</tr>

<tr><td height="1" colspan="1" class="line"></td></tr>	
	
<tr><td align="center" colspan="2">
        <table>
		<tr>
		<cfif url.mode neq "">
		<td><input class="button10g" type="button" value="Close" onClick="parent.ProsisUI.closeWindow('newaccount')"></td>
		<cfelse>
		<td><input class="button10g" type="button" value="Close" onClick="window.close()"></td>
		</cfif>
		<td><INPUT class="button10g" type="button" value="Save" onclick="javascript:formvalidate()"></td></tr>
		</table>
	</td></tr>
	
	<tr class="hide"><td id="result"></td></tr>

</table>

</CFFORM>
	
<cf_screenBottom layout="webapp">