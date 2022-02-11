
<!--- update module --->

<cfparam name="form.FunctionHeaderLabel" default="">
<cfparam name="form.EntityCode" default="">
<!--- Added by Jorge Mazariegos on 9/23/2010 ---->
<cfparam name="form.QueryTable" default="">

<cfif form.FunctionHeaderLabel neq "">
	
	<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    Ref_ModuleControl
		SET       FunctionName = '#Form.FunctionHeaderLabel#', 
		          Operational = 1
		WHERE     SystemFunctionId = '#url.systemfunctionid#'    
	</cfquery>  

</cfif>

<!--- update inquirydetail --->

<cfif find("UPDATE",Form.QueryScript) or find("DELETE",Form.QueryScript)>
	 <script>
	 alert("Problem, you may not save an UPDATE query")
	 </script>
	 <cfabort>
</cfif> 

<cfquery name="AuditLog" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_ModuleControlDetailLog
			(SystemFunctionId,
			 FunctionSerialNo,
			 QueryScript,
			 OfficerUserId,
			 OfficerLastName,OfficerFirstName)
		VALUES
			('#url.systemfunctionid#',
			 '#url.functionserialno#',
			 '#Form.QueryScript#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')		
</cfquery> 

<cfset argument = "#form.DrillArgumentHeight#;#form.DrillArgumentWidth#;#form.DrillArgumentModal#;#Form.DrillArgumentCenter#;#Form.ExcelExport#;#Form.Scrolling#;#Form.CacheDisable#">

<cfquery name="Module" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    Ref_ModuleControlDetail
	SET       FilterShow       = '#Form.Filtershow#', 
	          QueryDataSource  = '#Form.QueryDataSource#',
			  QueryScript      = '#Form.QueryScript#', 
			  QueryTable       = '#Form.QueryTable#',
			  InsertTemplate   = '#Form.InsertTemplate#',
			  DrillMode        = '#Form.DrillMode#',			 
			  DrillTemplate    = '#Form.DrillTemplate#',
			  DrillArgument    = '#argument#',
			  EntityCode       = '#Form.EntityCode#'			          
	WHERE     SystemFunctionId = '#url.systemfunctionid#' 
	AND       FunctionSerialNo = '#url.functionserialno#'   
</cfquery>  

<!--- create entry --->
<cfinclude template="../Functions/ModuleControl/ModuleLanguage.cfm">

<script>
	Prosis.busy('no');
    try {
		opener.document.getElementById('listing_refresh').click() } catch(e) {}	  
</script>



