
<cfparam name="URL.textmode" default="edit">

<cfoutput>

<cfif url.textmode eq "read">

	<cf_screentop height="100%" html="No" scroll="Vertical" jquery="Yes">
		
	<cf_textareascript>
    <cf_menuscript>

	<cfajaximport tags="cfform">

	<script language="JavaScript">		
			 
		function docoutput(mode,id,docid) {		
		
			if (mode == "print") {
		    	  w = 1000;
			      h = #CLIENT.height# - 140;
			      ptoken.open("ActionPrint.cfm?mode="+mode+"&id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=yes, status=yes, scrollbars=yes, resizable=yes")			
			  }
			  
			if (mode == "pdf") {
		    	  w = 1000;
			      h = #CLIENT.height# - 140;
			      ptoken.open("ActionPrint.cfm?mode="+mode+"&id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=yes, status=yes, scrollbars=no, resizable=yes")			
			  }  
			  
			 if (mode == "mail") {	  
			     ptoken.open("ActionMail.cfm?id="+id+"&docid="+docid,"_blank", "left=30, top=30, width=800, height=600 , toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		    }		
			
		 }
	
	</script>


</cfif>

</cfoutput>

<cfset md="tab">

<cfoutput>
	
<cfquery name="Document" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObjectActionReport A, 
	       Ref_EntityDocument D 
	WHERE  A.ActionId   = '#MemoActionId#' 
	AND    A.DocumentId = D.DocumentId	
</cfquery>
	
<cfif document.recordcount eq "0">

	<cfset ht = 320>	
	<cfparam name="URL.box" default="0">
	<cfoutput>
	<script>	   
	    try {
		frm = parent.document.getElementById("document#url.box#")
		frm.height = 200
		} catch(e) {}
	</script>
	</cfoutput>	
</cfif>		

<table style="width:100%;height:100%" align="center">

<tr><td valign="top" style="padding-left:6px">
	
	<table width="100%" style="width:95%;height:95%">
	
	<tr class="line">	
	
	<cfset lk = "">
	<cfset ht = "36">
	<cfset wd = "36">	
		 	 		
		<!--- 1. embedded documents only for read --->	
		
		<cfset itm = "0">	
	
		<cfif url.textmode eq "read" or url.textmode eq "prior">	
		
		<cfdiv id="MarginHold" class="hide">   <!--- dummy div to use for ColdFusion.navigate update of top margin --->
					  
		    <cfloop query="document"> 

				<cfif document.recordcount gt "4" and md eq "tab">
				
					<cfset l = len(DocumentDescription)>
				    <cfif l gt "24">
						<cfset tit = "#left(DocumentDescription,22)#..">
					<cfelse>
					    <cfset tit = DocumentDescription>
					</cfif>	
					
				<cfelse>
				
				   <cfset tit = DocumentDescription>
				   
				</cfif>
				
				<cfif currentrow eq "1">
				   <cfset sel              = "highlight">
				   <cfset lk               = "ProcessActionDocumentTextContent.cfm">
				   <cfset url.no           = currentrow>
				   <cfset url.memoactionid = memoactionid>	
				   <cfset url.documentid   = documentid>
				<cfelse>
				   <cfset sel = "regular"> 				   
				</cfif>
				
				<cfset itm = itm+1>
								
				<cf_menutab 
				   target 	  = "priordocument" 
				   targetitem = "1" 
				   base       = "subdoc" 
				   item       = "#itm#" 
			       iconsrc    = "Logos/System/Documents.png" 
				   iconwidth  = "#wd#" 
				   class      = "#sel#"						
				   iconheight = "#ht#" 
				   source     = "ProcessActionDocumentTextContent.cfm?no=#currentrow#&textmode=#url.textmode#&memoactionid=#memoactionid#&documentid=#documentid#"
				   name       = "#tit#">	
				  							
			</cfloop> 
				
		</cfif>
				
		<!--- 2. for notes/memo text only --->
				
		<cfif url.textmode eq "read">
											
			<cfquery name="Document" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 	 SELECT *
				 FROM   OrganizationObjectAction OA
				 WHERE  ActionId  = '#MemoActionId#' 
			 </cfquery>
			 
			 <cf_tl id="memo" var="mem">
			 			 
			 <cfif document.actionMemo neq "" and itm gte "1">
			 									 
			 	<cfset actionmemo = document.actionMemo>
				
				<cfset itm = itm+1>
				
				<cfif document.recordcount eq "0">
				
				 <cf_menutab target="priordocument" targetitem="1" 
				   base       = "subdoc"  
				   item       = "#itm#" 
			       iconsrc    = "Logos/System/Documents.png" 
				   iconwidth  = "#wd#" 
				   class      = "highlight"						
				   iconheight = "#ht#" 
				   source     = "ProcessActionMemo.cfm?no=0&textmode=#url.textmode#&memoactionid=#MemoActionid#"	
				   name       = "#mem#">	
				  				   
			    <cfelse>				
				
				 <cf_menutab target="priordocument" targetitem="1" 
				   base       = "subdoc" 
				   item       = "#itm#" 
			       iconsrc    = "Logos/System/Documents.png" 
				   iconwidth  = "#wd#" 				  				
				   iconheight = "#ht#" 
				   source     = "ProcessActionMemo.cfm?no=0&textmode=#url.textmode#&memoactionid=#MemoActionid#"	
				   name       = "#mem#">				
				
				</cfif>	   
			 				 
			 </cfif>
						 
			 <cfif lk eq "">
				  <cfset lk = "ProcessActionMemo.cfm">		
				  <cfset url.no           = "0">
				  <cfset url.memoactionid = memoactionid>			 
			 </cfif>
				
		<cfelse>
		
			<!--- is already embedded in ProcessAction8step dialog itself --->
				
		</cfif>	
		
		<td style="width:30%"></td>
				
		</tr>
		
	</table>	

</td></tr>

<tr><td valign="top" height="100%">
	
	<table width="100%" height="100%" align="center" bgcolor="white">
		
			 <cf_menucontainer name="priordocument" item="1" class="regular">				 				 
					 <cfinclude template="#lk#">		
			 </cf_menucontainer>	
			 
	</table>		 

</td></tr>

</table>

</cfoutput>
