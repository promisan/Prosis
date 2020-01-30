

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ClaimTypeTab
	WHERE 
	Mission = '#Form.Mission#'
	AND Code  = '#Form.Code#' 
	AND TabName = '#Form.TabName#' 
</cfquery>


	<cfif #Verify.recordCount# is 1>
		<cf_tl id="An record with this code has been registered already!" class="Message" var="1">
   <cfoutput>
   
   <script language="JavaScript">
   
     alert("#lt_text#")
     
   </script>  
   </cfoutput>
  
   <CFELSE>
  
   
	<cfquery name="Insert" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ClaimTypeTab
         (
		 Mission,
		 Code,
		 TabName, 
		 TabLabel,
		 TabOrder,
		 TabIcon,
		 TabTemplate,	
		 TabElementClass,
		 AccessLevelRead,
		 AccessLevelEdit,		
		 ModeOpen,
		 Operational,
		 Created)
  VALUES (
		 '#FORM.Mission#',
		 '#FORM.Code#',
		 '#FORM.TabName#', 
		 '#FORM.TabLabel#',
		 '#FORM.TabOrder#',
		 '#FORM.TabIcon#',
		 '#FORM.TabTemplate#',	
		 '#FORM.TabElementClass#',
		 '#FORM.AccessLevelRead#',
		 '#FORM.AccessLevelEdit#',		
		 '#FORM.ModeOpen#',
		 '#FORM.Operational#',  
  	      getDate())
	</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>
     

<cfquery name="Update" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

		UPDATE Ref_ClaimTypeTab
		SET 
		 Mission='#Form.Mission#',
		 Code='#Form.Code#',
		 TabName='#Form.TabName#', 
		 TabLabel='#Form.TabLabel#',
		 TabOrder='#Form.TabOrder#',
		 TabIcon='#Form.TabIcon#',
		 TabTemplate='#Form.TabTemplate#',	
		 TabElementClass = '#Form.TabElementClass#',
		 AccessLevelRead='#Form.AccessLevelRead#',
		 AccessLevelEdit='#Form.AccessLevelEdit#',		
		 ModeOpen='#Form.ModeOpen#',
		 Operational='#Form.Operational#'		
		WHERE 
		Mission = '#Form.MissionOld#'
		AND Code  = '#Form.Code#' 
		AND TabName = '#Form.TabNameOld#'  

</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Delete" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ClaimTypeTab
		WHERE 
		Mission = '#Form.MissionOld#'
		AND Code  = '#Form.Code#' 
		AND TabName = '#Form.TabNameOld#' 
    </cfquery>
	
</cfif>	
	
<script language="JavaScript">
     window.close()
     try {
		window.opener.document.getElementById("menu3").click()
	 } catch(err) {	}
</script>  