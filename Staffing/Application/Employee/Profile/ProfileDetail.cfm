<cfparam name="Form.ProfileText" default="">

<cfif Form.ProfileText neq "">
	
	<cfquery name="Profile" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM PersonProfile
	 WHERE PersonNo = '#url.Id#'
	 AND LanguageCode = '#URL.LanguageCode#'
	</cfquery> 
	
	<cfif Profile.recordcount eq "0">

		<cfquery name="Insert" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO PersonProfile
		 (PersonNo, LanguageCode,OfficerUserid,OfficerLastName,OfficerFirstname)
		 VALUES
		 ('#url.Id#','#URL.LanguageCode#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery> 	

	</cfif>			

	<cfquery name="Update" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE PersonProfile
		 SET ProfileText = '#form.ProfileText#'
		 WHERE PersonNo = '#url.Id#'
		 AND LanguageCode = '#URL.LanguageCode#'
	</cfquery> 
	
	
</cfif>

<cfquery name="Profile" 
 datasource="AppsEmployee"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM PersonProfile
 WHERE PersonNo = '#url.Id#'
 AND LanguageCode = '#URL.LanguageCode#'
</cfquery> 

<cfoutput>
		<table width="100%" align="center" height="70%" cellspacing="0" cellpadding="0">
		<tr>
		  <td style="border: 0px solid Silver;padding:4px" height="100%">
		  		  		  
		  <input type="hidden" id="lanselect" name="lanselect"  value="#url.languagecode#">
		  
		   <cf_textarea name="ProfileText" id="ProfileText"                                            
			   height         = "50%"
			   toolbar        = "mini"
			   resize         = "0"
			   color          = "ffffff">#Profile.ProfileText#</cf_textarea>		  
					
			</td>
		</tr>
	
		</table>
</cfoutput>

<cfset ajaxonload("initTextArea")>
