
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset syncTemplateGroup="No">	

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify"
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ApplicationServer, ServerLocation, 
		ServerRole, HostName, NodeIP, VersionDate, DistributionEMail, 
		ReplicaPath, Created
		FROM  ParameterSite
		where ApplicationServer = '#Form.ApplicationServer#'
		ORDER BY ServerLocation
	</cfquery>
	
	   <cfif #Verify.recordCount# is 1>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this Application Server has been registered already!")
	     
	   </script>  
  
   <cfelse>
	  
	<cfquery name="Insert" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ParameterSite
	         (ApplicationServer, 
			  ServerLocation, 
			  ServerRole, 
			  OrgUnit,
			  Owner,
			  HostName, 
			  NodeIP, 
			  DistributionEMail, 
			  ReplicaPath, 
			  SourcePath,
			  DataBaseServer,
			  Created)
	  VALUES ('#replace(Form.ApplicationServer,' ','','ALL')#',
	          '#Form.ServerLocation#', 
			  '#Form.ServerRole#',
			  '#Form.OrgUnit0#',
			  '#Form.Owner#',
			  '#Form.HostName#',
			  '#Form.NodeIP#',
			  '#Form.DistributionEMail#',
			  '#Form.ReplicaPath#',
			  '#Form.SourcePath#',
			  '#Form.DatabaseServer#',			  
			  getDate())</cfquery>
		  
    </cfif>		
	
	<cfif Form.ServerRole eq "Production">
	
			<cfdirectory action="CREATE" 
			         directory="#SESSION.rootPath#/_Distribution/#form.ApplicationServer#">
	
	</cfif>
	
	<cfset syncTemplateGroup="Yes">	
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfparam name="form.operational" default="0">
	<cfparam name="form.enableBatchUpdate" default="1">

	<cfquery name="Update" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ParameterSite
	SET    ApplicationServer    = '#Form.ApplicationServer#',
		   ServerLocation       = '#Form.ServerLocation#', 
	  	   ServerRole           = '#Form.ServerRole#', 
		   Owner			    = '#Form.Owner#',
	   	   HostName             = '#Form.HostName#', 
	  	   NodeIP               = '#Form.NodeIP#', 
		   DistributionEMail    = '#Form.DistributionEmail#', 
	 	   ReplicaPath          = '#Form.ReplicaPath#',
		   SourcePath           = '#Form.SourcePath#',
		   DataBaseServer       = '#Form.DatabaseServer#',
		   EnableBatchUpdate    = '#Form.EnableBatchUpdate#',
		   OrgUnit              = '#Form.OrgUnit0#',
		   EnableCodeEncryption = '#Form.EnableCodeEncryption#',	
		   Operational          = '#Form.Operational#'		 
	WHERE  ApplicationServer    = '#Form.ApplicationServer#'
	</cfquery>
	
	<cfset syncTemplateGroup="Yes">	

</cfif>	

<cfquery name="ResetModule" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ParameterSiteGroup
	WHERE  ApplicationServer= '#Form.ApplicationServer#'
</cfquery>  

<cfif SyncTemplateGroup eq "Yes">

	<cfparam name="Form.TemplateGroup" type="any" default="">

	<cfloop index="Item" 
	        list="#Form.TemplateGroup#" 
	        delimiters="' ,">

		<cfquery name="InsertTemplateGroup" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ParameterSiteGroup
		         (ApplicationServer,
				 TemplateGroup)
		  VALUES ('#Form.ApplicationServer#', 
		      	  '#Item#')
		</cfquery>
				  			  
	</cfloop>		

</cfif>

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsControl" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM ref_templateContent
		WHERE ApplicationServer = '#Form.ApplicationServerOld#'
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Application Server is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ParameterSite
	WHERE ApplicationServer = '#FORM.ApplicationServerOld#'
    </cfquery>
	
	</cfif>
		
</cfif>	

<cfoutput>


<cfif ParameterExists(Form.Insert)> 	
		
	<script language="JavaScript">
	     
	     window.close()		
		 try { parent.opener.applyfilter('','','content') } catch(e) {}
		        
	</script>  

<cfelse>
	
	<script language="JavaScript">
	    
	     window.close()				
		 try { parent.opener.applyfilter('','','#FORM.ApplicationServerOld#') } catch(e) {}
		        
	</script>  

</cfif>

</cfoutput>
