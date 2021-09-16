
<cfajaximport>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational"         default="0">

<cfif IsDefined("Form.FieldRequired")>
	<cfset Form.FieldRequired = 1>
<cfelse>
	<cfset Form.FieldRequired = 0>
</cfif>

<cfif IsDefined("Form.Today")>
	<cfset vToday = 1>
<cfelse>
	<cfset vToday = 0>
</cfif>

<cfparam name="Form.FieldType"           default="">
<cfparam name="Form.FieldName"           default="">
<cfparam name="Form.FieldMask"           default="">
<cfparam name="Form.FieldLayout"         default="">
<cfparam name="Form.FieldValidation"     default="">
<cfparam name="Form.FieldLength"         default="">
<cfparam name="Form.FieldMultipleSelect" default="0">
<cfparam name="Form.LookupSelect"        default="0">
<cfparam name="Form.DocumentFramework"   default="0">
<cfparam name="Form.DocumentEditor"      default="FCK">
<cfparam name="Form.DocumentOrientation" default="Vertical">
<cfparam name="Form.MarginTop"           default="0">
<cfparam name="Form.MarginBottom"        default="0">
<cfparam name="Form.Scale"               default="100">
<cfparam name="Form.PortalShow"          default="0">
<cfparam name="Form.LookupFieldKey"      default="">
<cfparam name="Form.LookupFieldName"     default="">
<cfparam name="Form.DocumentTemplate"    default="">
<cfparam name="Form.LogActionContent"    default="0">
<cfparam name="Form.DocumentStringList"  default="">
<cfparam name="Form.DocumentPassword"    default="">
<cfparam name="Form.MailToDocumentId"    default="">


<cfif url.Type eq "Dialog">

	<cfif not FileExists("#SESSION.rootPath#\#Form.DocumentTemplate#")>
	
		<script>
		<cfoutput>
		alert("Sorry, but #SESSION.rootPath#\#Form.DocumentTemplate# is not a valid path/file name")
		</cfoutput>
		</script>
					
	</cfif>
		
</cfif>	

<cfif URL.ID2 neq "new">

	 <cfquery name="Check" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   Ref_EntityDocument
		  WHERE  DocumentCode = '#URL.ID2#'
		   AND   EntityCode   = '#URL.EntityCode#' 
	 </cfquery>

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_EntityDocument
		  SET    Operational         = '#Form.Operational#',
		         DocumentFramework   = '#Form.DocumentFramework#',
 		         DocumentDescription = '#Form.DocumentDescription#',
				 DocumentTemplate    = '#Form.DocumentTemplate#',
				 DocumentMode        = '#Form.DocumentMode#',
				 DocumentLayout      = '#Form.FieldLayout#',
				 DocumentOrientation = '#Form.DocumentOrientation#',				 
				 DocumentEditor      = '#Form.DocumentEditor#',
				 DocumentStringList  = '#Form.DocumentStringList#',
				 FieldRequired       = '#Form.FieldRequired#', 
				 DocumentPassword    = '#Form.DocumentPassword#',
				 DocumentOrder       = '#Form.DocumentOrder#',
				 FieldType           = '#Form.FieldType#', 
				 PortalShow          = '#Form.PortalShow#', 
				 MarginTop           = '#Form.MarginTop#',
				 MarginBottom        = '#Form.MarginBottom#',
				 Scale               = '#Form.Scale#',
				 <!---
				 <cfif url.type eq "mail">
					 MailTo              = '#Form.MailTo#',
					 <cfif form.MailToDocumentId neq "">
					 MailToDocumentId    = '#Form.MailToDocumentId#',
					 </cfif>
					 MailPriority        = '#Form.MailPriority#', 
					 MailSubject         = '#Form.MailSubject#',
					 MailSubjectCustom   = '#Form.MailSubjectCustom#',
					 MailBody            = '#Form.MailBody#',
					 MailBodyCustom      = '#Form.MailBodyCustom#',
				 </cfif>
				 --->
				 <cfif form.fieldtype eq "Text" or form.fieldtype eq "List">
					 FieldLength          = '#Form.FieldLength#',
					 FieldSelectMultiple  = '#Form.FieldSelectMultiple#',
					 FieldValidation      = '#Form.FieldValidation#', 
					 FieldMask            = '#Form.FieldMask#',
					 FieldDefault         = '#Form.FieldDefault#',
					 LookupSelect         = '#Form.LookupSelect#',
					 LookupDatasource     = '#Form.LookupDataSource#',
					 LookupTable          = '#Form.LookupTable#',
					 LookupFieldKey       = '#Form.LookupFieldKey#', 				 
					 LookupFieldName      = '#Form.LookupFieldName#',
				 </cfif>
				 <cfif form.fieldtype eq "Rule">
				     MessageProcessor     = '#Form.MessageProcessor#',
					 MessageColor         = '#Form.MessageColor#', 
					 MessageAudit         = '#Form.MessageAuditor#',				 
				 </cfif>
				 <cfif form.fieldtype eq "Date">
				 	<cfif vToday eq 0>
					 	FieldDefault         = '#Form.DateDefault#',
					<cfelse>   
					 	FieldDefault         = 'now()',
				    </cfif>				 
				 </cfif>				 
				 <cfif url.type eq "Dialog">
				 	 LookupDatasource     = '#Form.LookupDataSource#', 
					 LookupTable          = '#Form.LookupTable#',
					 LookupFieldKey       = '#Form.LookupFieldKey#', 				 
					 LookupFieldName      = '#Form.LookupFieldName#', 
				 </cfif>
				 LogActionContent    = '#Form.LogActionContent#'
		  WHERE  DocumentCode = '#URL.ID2#'
		   AND   EntityCode = '#URL.EntityCode#' 
	</cfquery>
		
	<cf_LanguageInput
		TableCode       = "Ref_EntityDocument" 
		Mode            = "Save"
		Key1Value       = "#check.documentId#"
		Name1           = "DocumentDescription">			
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_EntityDocument
		WHERE    DocumentCode = '#Form.DocumentCode#'
		   AND   EntityCode = '#URL.EntityCode#' 
	</cfquery>
	
	<cfquery name="Recorded" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_EntityDocument
		WHERE    DocumentId  = '#url.documentid#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0" and recorded.recordcount eq "0">
			
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityDocument
			         (DocumentId,
					 EntityCode,
					 DocumentType,
					 DocumentCode,
					 DocumentDescription,
					 DocumentTemplate,
					 DocumentOrder,
					 DocumentStringList,
					 DocumentPassword, 
					 DocumentFramework,
					 DocumentOrientation,
					 DocumentEditor,
					 MarginTop,
					 MarginBottom,
					 Scale,
					 LogActionContent,
					
					 <cfif form.fieldtype eq "Text" or form.fieldtype eq "List">
					 	 FieldLength,
						 FieldSelectMultiple,
						 FieldValidation,
						 FieldMask,
						 FieldDefault,
						 LookupSelect,
					     LookupDatasource,
					     LookupTable,
					     LookupFieldKey, 
					     LookupFieldName,
				     </cfif>
					 <cfif form.fieldtype eq "Date">
					 	FieldDefault,
					 </cfif>					 
					 <cfif url.type eq "Dialog">
				 		 LookupDatasource,
						 LookupTable,  
						 LookupFieldKey,  				 
						 LookupFieldName,
				 	 </cfif>	
					 <cfif form.fieldtype eq "Rule">
				     MessageProcessor,
					 MessageColor, 
					 MessageAudit,				 
					 </cfif>				 
					 FieldRequired,
					 FieldType,
					 DocumentMode,
					 DocumentLayout,
					 Operational)
			      VALUES ('#url.documentid#',
				      '#Trim(URL.EntityCode)#',
				      '#URL.Type#',
				      '#Trim(Form.DocumentCode)#',
					  '#Form.DocumentDescription#',
					  '#Form.DocumentTemplate#',
					  '#Form.DocumentOrder#',
					  '#Form.DocumentStringList#',
					  '#Form.DocumentPassword#',
					  '#Form.DocumentFramework#',
					  '#Form.DocumentOrientation#',
					  '#Form.DocumentEditor#',
					  '#Form.MarginTop#',
				      '#Form.MarginBottom#',
				      '#Form.Scale#',
					  '#Form.LogActionContent#',
					  
					  <cfif form.fieldtype eq "Text" or form.fieldtype eq "List">
					      '#Form.FieldLength#',
						  '#Form.FieldSelectMultiple#',
						  '#Form.FieldValidation#',
						  '#Form.FieldMask#',
						  '#Form.FieldDefault#',
						  '#Form.LookupSelect#',
					      '#Form.LookupDatasource#',
					      '#Form.LookupTable#',
					      '#Form.LookupFieldKey#', 
					      '#Form.LookupFieldName#',
				      </cfif>
					 <cfif form.fieldtype eq "Date">
					 	<cfif vToday eq 0>
						   '#Form.DateDefault#',
						<cfelse>   
						   'now()',
					    </cfif> 
					 </cfif>					  
					  <cfif url.type eq "Dialog">
				 		  '#Form.LookupDatasource#',
					      '#Form.LookupTable#',
					      '#Form.LookupFieldKey#', 
					      '#Form.LookupFieldName#',
				 	 </cfif>	
					 <cfif form.fieldtype eq "Rule">
				      '#Form.MessageProcessor#',
					  '#Form.MessageColor#', 
					  '#Form.MessageAuditor#',				 
				     </cfif>		
					  '#Form.FieldRequired#',
					  '#form.FieldType#',
					  '#Form.DocumentMode#',
					  '#Form.FieldLayout#',
			      	  '#Form.Operational#')
			</cfquery>
			
			<cf_LanguageInput
						TableCode       = "Ref_EntityDocument" 
						Mode            = "Save"
						Key1Value       = "#documentid#"
						Name1           = "DocumentDescription">		
						
	<cfelseif Recorded.recordcount eq "1" and exist.recordcount eq "1">
			
		 <!--- updating record --->
		 	
		 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_EntityDocument
		  SET    DocumentCode        = '#Form.DocumentCode#',
		  		 Operational         = '#Form.Operational#',
 		         DocumentDescription = '#Form.DocumentDescription#',
				 DocumentTemplate    = '#Form.DocumentTemplate#',
				 DocumentMode        = '#Form.DocumentMode#',
 				 DocumentLayout      = '#Form.FieldLayout#',
 				 DocumentOrientation = '#Form.DocumentOrientation#',				 
				 DocumentStringList  = '#Form.DocumentStringList#',
				 FieldRequired       = '#Form.FieldRequired#',
				 DocumentPassword    = '#Form.DocumentPassword#',
				 DocumentOrder       = '#Form.DocumentOrder#',
				 FieldType           = '#Form.FieldType#', 
				 PortalShow          = '#Form.PortalShow#', 
				 <cfif url.type eq "mail">
					 MailTo              = '#Form.MailTo#',
					 <cfif form.MailToDocumentId neq "">
					 MailToDocumentId    = '#Form.MailToDocumentId#',
					 </cfif>
					 MailPriority        = '#Form.MailPriority#', 
					 MailSubject         = '#Form.MailSubject#',
					 MailSubjectCustom   = '#Form.MailSubjectCustom#',
					 MailBody            = '#Form.MailBody#',
					 MailBodyCustom      = '#Form.MailBodyCustom#',
				 </cfif>
				 <cfif form.fieldtype eq "Text" or form.fieldtype eq "List">
					 FieldLength          = '#Form.FieldLength#',
					 FieldSelectMultiple  = '#Form.FieldSelectMultiple#',
					 FieldValidation      = '#Form.FieldValidation#', 
					 FieldMask            = '#Form.FieldMask#',
					 FieldDefault         = '#Form.FieldDefault#',
					 LookupSelect         = '#Form.LookupSelect#',
					 LookupDatasource     = '#Form.LookupDataSource#',
					 LookupTable          = '#Form.LookupTable#',
					 LookupFieldKey       = '#Form.LookupFieldKey#', 				 
					 LookupFieldName      = '#Form.LookupFieldName#',
				 </cfif>
				 <cfif form.fieldtype eq "Date">
				 	<cfif vToday eq 0>
					 	FieldDefault         = '#Form.DateDefault#',
					<cfelse>   
					 	FieldDefault         = 'now()',
				    </cfif>		
				 </cfif>
				 <cfif url.type eq "Dialog">
				 	 LookupDatasource     = '#Form.LookupDataSource#', 
					 LookupTable          = '#Form.LookupTable#',
					 LookupFieldKey       = '#Form.LookupFieldKey#', 				 
					 LookupFieldName      = '#Form.LookupFieldName#', 
				 </cfif>
				 LogActionContent    = '#Form.LogActionContent#'
		  WHERE  DocumentId = '#URL.DocumentId#'
		</cfquery>			
		
		<cf_LanguageInput
						TableCode       = "Ref_EntityDocument" 
						Mode            = "Save"
						Key1Value       = "#documentid#"
						Name1           = "DocumentDescription">			
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #Form.DocumentCode# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>

<cfset url.id2 = "">
<cfinclude template="ObjectElement.cfm">
