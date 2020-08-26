
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.EnableAccessFly" default="0">
<cfparam name="Form.FieldName" default="">
<cfparam name="Form.ProcessMode" default="0">
<cfparam name="Form.ParentCode" default="">
<cfparam name="url.entityclass" default="">

<cfif url.search eq ",">
	<cfset url.search = "">
</cfif>

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityAction 
		  SET Operational        = '#Form.Operational#',
 		      ActionType         = '#Form.ActionType#',
			  ActionDescription  = '#Form.ActionDescription#',
			  ListingOrder       = '#Form.ListingOrder#',
			  EnableAccessFly    = '#Form.EnableAccessFly#',
			  ParentCode         = '#Form.ParentCode#',
			  ProcessMode        = '#Form.ProcessMode#'
			 WHERE ActionCode    = '#URL.ID2#'
	    </cfquery>
		
		<cf_LanguageInput
		TableCode       = "Ref_EntityAction" 
		Mode            = "Save"
		Key1Value       = "#URL.ID2#"
		Name1           = "ActionDescription">		
		
		<cfquery name="Sync" 
	     datasource="AppsOrganization" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
    	 UPDATE Ref_EntityClassAction
	     SET    ActionDescription = '#Form.ActionDescription#',
			    ActionType        = '#Form.ActionType#'
	     WHERE  ActionCode = '#URL.ID2#'
    	</cfquery>
		
<!---		document editing superceeded KRW: 20/08/08
		
		<cfquery name="ResetGroup" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM Ref_EntityActionDocument 
			WHERE ActionCode = '#URL.ID2#'
		</cfquery>

		<cfparam name="Form.Document" type="any" default="">

		<cfloop index="Item" 
        list="#Form.Document#" 
        delimiters="' ,">

		<cfquery name="InsertGroup" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_EntityActionDocument
		         (ActionCode,
				 DocumentId)
		  VALUES ('#URL.ID2#', 
		      	  '#Item#')
				  </cfquery>
		</cfloop>	
--->		

		<cfset url.id2 = "">
		<cfinclude template="ActionRecords.cfm">
		
		<!---
		
		<cfoutput>
		<script>
		  #ajaxLink('ActionRecords.cfm?entitycode=#URL.entitycode#&search=#url.search#')#
		</script>			
	    </cfoutput>		
		
		--->

<cfelse>

	<cfquery name="Entity" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_Entity 
		WHERE EntityCode = '#URL.EntityCode#' 
	</cfquery>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityAction 
		WHERE ActionCode = '#Entity.EntityAcronym##Form.ActionCode#' 
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityAction 
			         (EntityCode,
					 ActionCode,
					 ActionDescription,
					 ActionType,
					 ListingOrder,
					 EnableAccessFly,
					 ProcessMode,
					 ParentCode,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#Entity.EntityAcronym##Form.ActionCode#',
					  '#Form.ActionDescription#',
					  '#Form.ActionType#',
					  '#Form.ListingOrder#',
					  '#Form.EnableAccessFly#',
					  '#Form.ProcessMode#',
					  '#Form.ParentCode#',
			      	  '#Form.Operational#',
					  getDate())
			</cfquery>
			
			<cf_LanguageInput
			TableCode       = "Ref_EntityAction" 
			Mode            = "Save"
			Key1Value       = "#Entity.EntityAcronym##Form.ActionCode#"
			Name1           = "ActionDescription">		
			
		<!---		document editing superceeded  KRW: 20/08/08
		
					<cfparam name="Form.Document" type="any" default="">
		
					<cfloop index="Item" 
			        list="#Form.Document#" 
			        delimiters="' ,">
			
					<cfquery name="InsertGroup" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_EntityActionDocument
					         (ActionCode,
							 DocumentId)
					  VALUES ('#Entity.EntityAcronym##Form.ActionCode#', 
					      	  '#Item#')
							  </cfquery>
					</cfloop>		
		--->
					
	<cfelse>
	
	<cfoutput>
	<script language="JavaScript">
		alert("Action code #Entity.EntityAcronym##Form.ActionCode# already exists. Operation aborted")
	</script>
	</cfoutput>
			
	</cfif>	
	
	<cfquery name="Sync" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Ref_EntityClassAction
     SET    ActionDescription = '#Form.ActionDescription#',
		    ActionType = '#Form.ActionType#'
     WHERE  ActionCode = '#Form.ActionCode#'
    </cfquery>
	
	<cfset url.id2 = "new">	
	<cfinclude template="ActionRecords.cfm">
	
	<!---
	
	<cfoutput>
		<script>
		  #ajaxLink('ActionRecords.cfm?entitycode=#URL.entitycode#&search=#url.search#&id2=new')#
		</script>			
	</cfoutput>	
	
	--->
		   	
</cfif>