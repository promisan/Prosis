<cf_screentop html="No" jquery="Yes">

<cfoutput>

	<script LANGUAGE = "JavaScript">
	
	var root = "#root#";
	
	w = 0
	h = 0
	if (screen) {
	w = #CLIENT.width# - 60
	h = #CLIENT.height# - 110
	}
	
	function showdocument(vacno,candlist,actionid) {
		ptoken.open(root + "/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno + "&IDCandlist=" + candlist + "&ActionId=" + actionid, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	</script>

</cfoutput>

<cfparam name="url.box" default="">

<cfquery name="Verify" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   P.DocumentNo, P.PostNumber
	FROM     Document D, DocumentPost P
	WHERE    P.PositionNo     = '#Form.PositionNo#'
	AND      D.DocumentNo     = P.DocumentNo
	AND      D.EntityClass    = '#Form.EntityClass#'
	AND      D.Status         = '0'
</cfquery>

<cfoutput>
<input type="hidden" name="Mission" value="#Form.Mission#">
</cfoutput>

<cfif Verify.recordCount is 1 and URL.ID eq ""> 

	<cfoutput>
	    <cf_alert message = "Position #Form.PositionNo# (#Form.SourcePostNumber#) has a registered and active track under #Verify.DocumentNo#. Operation not allowed.">	
		<script>
			try {
				parent.ProsisUI.closeWindow('mydialog')
			} catch(ex)	{
				ProsisUI.closeWindow('mydialog')
			}
		</script>		
	</cfoutput>

<CFELSE>
	
	<cfquery name="AssignNo" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Parameter 
		SET DocumentNo = DocumentNo+1
	</cfquery>
	
	<cfquery name="LastNo" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Parameter
	</cfquery>
	
	<!--- close prior document --->
	
	<cfif Form.DocumentNoTrigger neq "">
	
	   <cfquery name="Close" 
	    datasource="appsVacancy" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    	UPDATE Document
	    	SET    Status = '9'
	    	WHERE  DocumentNo = #Form.DocumentNoTrigger#
	   </cfquery>
	
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DueDate#">
	<cfset Due = dateValue>
	
	<cfif Len(Form.Remarks) gt 250>
	 <cf_alert message = "Your entered remarks that exceeded the allowed size of 250 characters.">	
	 <cfabort>
	</cfif>
	
	<cftransaction>
	
	<cfquery name="InsertDocument" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Document
		         (DocumentNo,
				 DocumentNoTrigger,
				 Status,
				 FunctionNo, 
				 FunctionalTitle, 
				 OrganizationUnit,
				 Mission,
				 Owner,
				 PostNumber,
				 PositionNo,
				 DueDate,
				 PostGrade,
				 GradeDeployment,
				 EntityClass,
				 Remarks,
				 OfficerUserId,
				 OfficerUserLastName,
				 OfficerUserFirstName)
		  VALUES ('#LastNo.DocumentNo#',
		          '#Form.DocumentNoTrigger#',
		          '0',
				  '#Form.FunctionNo#',
		          '#Form.FunctionDescription#',
				  '#Form.OrgUnit#',
				  '#Form.Mission#',
				  '#Form.Owner#',
				  '#Form.SourcePostNumber#',
				  '#Form.PositionNo#',
				  #Due#,
				  '#Form.PostGrade#',
				  <cfif #Form.GradeDeployment# eq "">
				  '#Form.PostGrade#',
				  <cfelse>
				  '#Form.GradeDeployment#',
				  </cfif>
				  '#Form.EntityClass#',
				  '#Form.Remarks#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	  </cfquery>
	  
	  <!--- update functional title --->
	  
	  <cfquery name="InsertDocument" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   UPDATE Document
		   SET    FunctionalTitle   = F.FunctionDescription,
	    	      OccupationalGroup = F.OccupationalGroup
				  
		   FROM   Document D INNER JOIN Applicant.dbo.FunctionTitle F ON D.FunctionNo = F.FunctionNo
		   AND    D.DocumentNo = #LastNo.DocumentNo#
		   AND    D.FunctionNo > ''
	  </cfquery>  
	    
	  <cfquery name="InsertDocumentPost" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO DocumentPost
				         (DocumentNo,
						 PositionNo,
						 PostNumber,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,
						 Created)
			VALUES ('#LastNo.DocumentNo#',
			        '#Form.PositionNo#',
			        '#Form.SourcePostNumber#',
			        '#SESSION.acc#',
			    	'#SESSION.last#',		  
				  	'#SESSION.first#',
					getDate())					
					
	    </cfquery>	
		
		</cftransaction>   
		
	<cfoutput>
		
	<cfquery name="Doc" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Document
		WHERE  DocumentNo = '#LastNo.DocumentNo#'
	</cfquery>
		
	<cfquery name="Position" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Position
		WHERE  PositionNo = '#Doc.PositionNo#'
	</cfquery>
	
   <cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#LastNo.DocumentNo#">
 
   <!--- ---------------------- --->	
   <!--- create workflow object --->
   <!--- ---------------------- --->  

   					
   <cf_ActionListing 
    TableWidth       = "100%"
    EntityCode       = "VacDocument"
	EntityClass      = "#Doc.EntityClass#"
	EntityGroup      = "#Doc.Owner#"
	EntityStatus     = ""		
	Mission          = "#Doc.Mission#"
	OrgUnit          = "#Position.OrgUnitOperational#"
	ObjectReference  = "#Doc.FunctionalTitle#"
	ObjectReference2 = "#Doc.Mission# - #Doc.PostGrade#"
	ObjectKey1       = "#Doc.DocumentNo#"
	Show             = "No"	
  	ObjectURL        = "#link#"
	DocumentStatus   = "#Doc.Status#">
	
	<cfif url.box neq "" and url.box neq "undefined">
			
		<script>
			try {
				parent.ProsisUI.closeWindow('mydialog')
			} catch(ex) {
				ProsisUI.closeWindow('mydialog')
			}
	    	<cfif url.box eq "isearch">
	    		parent.document.getElementById("gosearch").click();	    	
			<cfelse>
				try {
		   	   		parent.document.getElementById("refresh_#url.box#").click();
				} catch(e) {
					document.getElementById("refresh_#url.box#").click();
				}
		   	</cfif>
			ptoken.open("#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=#LastNo.DocumentNo#", "Track#LastNo.DocumentNo#");

		</script>
			
	<cfelse>
	
		<!--- regular entry screen --->
		
		<script language="JavaScript">

			try {
				parent.ProsisUI.closeWindow('mydialog')
			} catch(ex)	{
				ProsisUI.closeWindow('mydialog')
			}
			ptoken.open("#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=#LastNo.DocumentNo#", "Track#LastNo.DocumentNo#");
				
		</script>
	
	</cfif>		
		
	</cfoutput>

</cfif> 
