
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css"  media="print">
</cfoutput>

<cfparam name="URL.textmode" default="read">

<cfoutput>

	<!--- provision for the listing ActionView.cfm mode only --->
	
	<script language="JavaScript">		
			 
		function docoutput(mode,id,docid) {		
		
			if (mode == "print") {
		    	  w = 1000;
			      h = #CLIENT.height# - 140;
			      window.open("#SESSION.root#/tools/entityaction/ActionPrint.cfm?mode="+mode+"&id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes")			
			  }
			  
			if (mode == "pdf") {
		    	  w = 1000;
			      h = #CLIENT.height# - 140;
			      window.open("#SESSION.root#/tools/entityaction/ActionPrint.cfm?mode="+mode+"&id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")			
			  }  
			  
			 if (mode == "mail") {	  
			     window.open("#SESSION.root#/tools/entityaction/ActionMail.cfm?id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=800, height=600 , toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		    }		
			
		 }
	
	</script>
	
<cfquery name="Document" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObjectActionReport A
	WHERE  A.ActionId IN
                 (SELECT     ActionId
                  FROM          OrganizationObjectAction
				WHERE  ObjectId = '#URL.ObjectId#') 
	AND    A.DocumentId = '#URL.DocumentId#'	
	AND    A.ActionId = '#URL.ActionId#'
</cfquery>
		 	 		
<cfloop query="document"> 
			
	<cfdiv bind="url:#SESSION.root#/tools/entityaction/ProcessActionDocumentTextContent.cfm?no=#currentrow#&textmode=#url.textmode#&memoactionid=#actionid#&documentid=#documentid#">
		
</cfloop> 

</cfoutput>
