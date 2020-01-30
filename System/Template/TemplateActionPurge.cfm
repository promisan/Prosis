

<!--- ----------------------------------------------- --->
<!--- --Remove a template from production/master ---- --->
<!--- ----------------------------------------------- --->

<!--- 
0.  pass fileid 
1.  remove copy from development
2.  remove entry from Ref_TemplateContent with master release date
--->

<cfquery name="Source" 
	  datasource="AppsControl">
      SELECT * 
	  FROM   ParameterSite
	  WHERE  ApplicationServer IN (SELECT ApplicationServer 
	                               FROM Ref_TemplateContent	
								   WHERE TemplateId = '#URL.ID#')
</cfquery>

<cfquery name="template" 
datasource="AppsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE  TemplateId = '#URL.id#'
</cfquery>	

<cfif template.pathname eq "[root]">
  <cfset path = "">
<cfelse>
  <cfset path = template.pathname>
</cfif>    	

<cftry>
	
	<cftransaction>	
	
	<cfquery name="CreateAction" 
		datasource="AppsControl">
			INSERT INTO Ref_TemplateAction
				(PathName, 
				 FileName, 
				 ActionType, 
				 Source, 	
				 TemplateSizeNEW, 
				 TemplateContentNEW,
				 TemplateSizeOLD, 
				 TemplateContentOLD,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
				('#template.pathname#',
				 '#template.filename#',
				 'Delete',
				 '#template.applicationserver#',		
				 '0',
				 '',	
				 '#template.templateSize#',
				 '#template.templateContent#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	</cfquery>											
		
	<cfquery name="delete" 
	datasource="AppsControl">
		DELETE FROM Ref_TemplateContent	
		WHERE TemplateId = '#URL.id#'
	</cfquery>	
		
	<cfif Source.ServerRole eq "QA">
			
		<!--- reset status is indeed the master is cleared of the file --->

		<cfquery name="Update" 
			datasource="AppsControl">
			UPDATE Ref_Template
			SET Operational = 0
	    	WHERE PathName = '#template.PathName#'
			  AND FileName = '#template.FileName#'
		</cfquery>
		
	</cfif>
			
	<cffile action="DELETE" 
		        file="#source.replicaPath#\#path#\#template.fileName#">		
				
	<font color="FF0000">Removed</font>			
				
	</cftransaction>						

<cfcatch>
	<font color="red">Failed</font>		
</cfcatch>

</cftry>




