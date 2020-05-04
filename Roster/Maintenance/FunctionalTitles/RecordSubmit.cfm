
<cfparam name="Form.Selected"            default="">
<cfparam name="Form.FunctionOperational" default="0">
<cfparam name="Form.clssel"              default="">
<cfparam name="url.action"               default="">

<cfif ParameterExists(Form.Insert) and url.action eq ""> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT *
     FROM  FunctionTitle
     WHERE FunctionDescription  = '#Form.FunctionDescription#' 
     AND   FunctionClass        = '#Form.FunctionClass#'
</cfquery>

   <cfif Verify.recordCount is 1>
   
   		<script language="JavaScript">
       		alert("A functional title with this description was registered already!")			
    	</script>  
		
		<cfabort>
  
   <cfelse>
  
			<cfquery name="AssignNo" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Parameter SET FunctionNumber = FunctionNumber+1
			</cfquery>
			
			<cfquery name="LastNo" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Parameter
			</cfquery>
			
			<!--- <cfset FunctionNo=Insert(LastNo.FunctionNumber, 0, 1)> --->
						
			<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO FunctionTitle
			         (FunctionNo,
					 FunctionClass,
					 FunctionRoster,
					 ParentFunctionNo,
					 FunctionDescription,
					 FunctionPrefix,
					 FunctionKeyword,
					 FunctionSuffix,
					 OccupationalGroup,					 
					 FunctionClassification,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				  VALUES ('#LastNo.FunctionNumber#',
			          '#Form.FunctionClass#', 
					  '#Form.FunctionRoster#', 
					  '#Form.functionno#',
					  '#Form.FunctionDescription#',
					  '#Form.FunctionPrefix#',
					  '#Form.FunctionKeyword#',
					  '#Form.FunctionSuffix#',
					  '#Form.OccGroup#',
					  <cfif Form.FunctionClassification neq "">
					  '#Form.FunctionClassification#',
					  <cfelse>
					  NULL,
					  </cfif>
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		  </cfquery>
						  		  
		  <cf_LanguageInput
			TableCode       = "FunctionTitle" 
			Mode            = "Save"
			Key1Value       = "#LastNo.FunctionNumber#"
			Name1           = "FunctionDescription">
			
			<cfquery name="DELETE" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM FunctionMissionClass
				WHERE	FunctionNo = '#LastNo.FunctionNumber#'
			</cfquery>
			
			<cfloop index="cls" list="#Form.clssel#" delimiters=", ">
			
				<cfquery name="InsertClass" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO FunctionMissionClass
				         (FunctionNo,
						 MissionClass,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  	VALUES ('#LastNo.FunctionNumber#',
				          '#cls#', 
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
				</cfquery>
				
			</cfloop>
		  
    </cfif>		
			
	<cfoutput>
	<script language="JavaScript">	  	        
		parent.parent.reloadForm('1','title','new')			
		parent.parent.ProsisUI.closeWindow('functiondialog',true);	    	   
	</script> 
	</cfoutput>   	
	           
</cfif>

<cfif (ParameterExists(Form.Update) or ParameterExists(Form.UpdateC) or url.action is "save") and url.action neq "delete">

	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE FunctionTitle
				
		SET   ParentFunctionNo       = '#Form.functionno#', 
		      FunctionDescription    = '#Form.FunctionDescription#', 
			  FunctionPrefix         = '#Form.FunctionPrefix#',
			  FunctionKeyword        = '#Form.FunctionKeyword#',
			  FunctionSuffix         = '#Form.FunctionSuffix#',
			  FunctionOperational    = '#Form.FunctionOperational#',
			  OccupationalGroup      = '#Form.OccGroup#',
			
			  <cfif Form.FunctionClassification neq "">
			  	FunctionClassification = '#Form.FunctionClassification#',
			  <cfelse>
			    FunctionClassification = NULL,
			  </cfif>
			
			  FunctionRoster         = '#Form.FunctionRoster#',
			  FunctionClass          = '#Form.FunctionClass#'
			 
		WHERE FunctionNo           = '#Form.FunctionNoOld#'
	</cfquery>	
	
	  <cf_LanguageInput
		TableCode       = "FunctionTitle" 
		Mode            = "Save"
		Key1Value       = "#Form.FunctionNoOld#"
		Name1           = "FunctionDescription">
		
		<cfquery name="DELETE" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM FunctionMissionClass
				WHERE	FunctionNo = '#Form.FunctionNoOld#'
			</cfquery>
		
		<cfloop index="cls" list="#Form.clssel#" delimiters=", ">
		
			<cftry>
			
				<cfquery name="InsertClass" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO FunctionMissionClass
					         (FunctionNo,
							 MissionClass,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					VALUES ('#Form.FunctionNoOld#',
					          '#cls#', 
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
				</cfquery>
			
				<cfcatch></cfcatch>
			
			</cftry>
		
		</cfloop>
			
		<cfoutput>
	
			<script language="JavaScript">	   			    
				parent.recordRefresh('#Form.FunctionNoOld#','desc')					  
				parent.recordRefresh('#Form.FunctionNoOld#','code')	    
				try { parent.recordRefresh('#Form.FunctionNoOld#','grde') } catch(e) {}
	    		parent.ProsisUI.closeWindow('functionedit',true);	        	
		    </script>  
		
		</cfoutput>  
		
	
</cfif>
	
<!---To Delete entry from functionTitle - need to be work on--->

<cfif url.action eq "delete"> 

	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT *
	      FROM   FunctionOrganization
	      WHERE  FunctionNo  = '#Form.FunctionNoOld#' 
    </cfquery>
	 	  
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Function in use. Operation aborted.")     
     </script>  
	 
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM FunctionTitle
		WHERE  FunctionNo = '#FORM.FunctionNoOld#' 
		</cfquery>
	
	</cfif>	
	
	<cfoutput>	
	
     	<script language="JavaScript">	   
			parent.recordRefresh('#Form.FunctionNoOld#','desc')	    
			parent.recordRefresh('#Form.FunctionNoOld#','code')	    
			try { parent.recordRefresh('#Form.FunctionNoOld#','grde') } catch(e) {}
	    	parent.ProsisUI.closeWindow('functionedit',true);	        	
	     </script>  	 
	
	</cfoutput>        
			
</cfif>	
