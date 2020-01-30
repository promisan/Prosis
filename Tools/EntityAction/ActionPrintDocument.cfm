<cfparam name="URL.DocId"  default="">
<cfparam name="URL.Mode"   default="pdf">
<cfparam name="URL.Format" default="">



<cfquery name="Init" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#cgi.http_host#'		
</cfquery>

<cfset vDocumentpagesize = "#Init.ReportPageType#">


<cfif url.docid eq "">
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 SET TextSize 1000000
	 SELECT *, 
	       ActionMemo as DocumentContent
	 FROM  OrganizationObjectAction OA
	 WHERE ActionId = '#URL.ID#' 	
	</cfquery>
	
	<cfset documentheader       = "">
	<cfset documentfooter       = "">
	<cfset vDocumentmargintop    = "0">
	<cfset vDocumentmarginbottom = "0">	
	<cfset documentorientation  = "Vertical">

	<cfset documentName = "">
	<cfset vDocumentscale = "100">			


	
<cfelse>
	
	<cfquery name="Action" 
	 datasource="AppsOrganization">
	 SET TextSize 1000000  
	 SELECT OA.ActionCode, 
	        OA.OrgUnit, 
			OA.ActionPublishNo, 
			OAP.*
	 FROM  OrganizationObjectAction OA,
	       OrganizationObjectActionReport OAP
	 WHERE OA.ActionId = '#URL.ID#' 
	  AND  OA.ActionId = OAP.ActionId
	  AND  OAP.DocumentId = '#URL.DocId#' 	  	
	</cfquery>	

	<cfquery name="qDocument" 
	 datasource="AppsOrganization">
	  SELECT * 
	  FROM Ref_EntityDocument
	  WHERE DocumentId = '#URL.DocId#'
	 </cfquery>	
	 
 	<cfset documentorientation  = qDocument.DocumentOrientation>	 
	<cfset documentName = "#qDocument.DocumentDescription# /">
	
	<cfset vDocumentmargintop    = "#qDocument.MarginTop#">
	<cfset vDocumentmarginbottom = "#qDocument.MarginBottom#">		
	<cfset vDocumentscale = "#qDocument.Scale#">			
	
</cfif>

<cfquery name="qTitle" 
 datasource="AppsOrganization">
 SELECT TOP 1 OO.* 
 FROM   OrganizationObject OO INNER JOIN 
	    OrganizationObjectAction OA ON 
		OO.ObjectId = OA.ObjectId
 WHERE OA.ActionId = '#URL.ID#' 	
</cfquery>

<cfoutput>
	<title>#documentName# #qTitle.ObjectReference# #qTitle.ObjectReference2#</title>
</cfoutput>

<cfswitch expression="#documentorientation#">
	<cfcase value="Horizontal">
		<cfset documentorientation = "Landscape">
	</cfcase>
	<cfcase value="Vertical">
		<cfset documentorientation = "Portrait">
	</cfcase>	
</cfswitch>

<cfquery name="ActionFlow" 
 datasource="AppsOrganization">
	 SELECT ActionDescription
	 FROM   Ref_EntityActionPublish
	 WHERE  ActionPublishNo = '#Action.ActionPublishNo#' 
	 AND    ActionCode = '#Action.ActionCode#'
</cfquery>

<cfquery name="Entity" 
 datasource="AppsOrganization">
	 SELECT *
	 FROM  Ref_Entity R, 
	       Ref_EntityClassPublish P
	 WHERE R.EntityCode = P.EntityCode
	 AND   P.ActionPublishNo = '#Action.ActionPublishNo#' 
</cfquery>


<cfif URL.Format eq "">	
	<cfset URL.Format = Entity.DefaultFormat>
</cfif>

<cfquery name="Org" 
 datasource="AppsOrganization">
 SELECT *
 FROM Organization
 WHERE OrgUnit = '#Action.OrgUnit#' 
</cfquery>

<cfset FileNo = round(Rand()*1000)>

<cfif URL.Format eq "FlashPaper">
	<cfset attach = "document#FileNo#.swf">
<cfelse>
    <cfset attach = "document#FileNo#.pdf">
</cfif>	

<cfoutput query="Action">

<cfif DocumentContent eq "">

	<cf_message message="There is nothing to print" return="close">
	<cfabort>

</cfif>

<cfif url.mode eq "pdf" and url.format neq "HTML">

	<cfparam name="client.footer" default="">

    <!---
	<cfset text = replace("#DocumentContent#", "@pb", "<cfdocumentitem type = 'pagebreak'></cfdocumentitem>", "ALL")>
	--->
	
	<cfset text = replace("#DocumentContent#", "@pb", "<p style='page-break-after:always;'>&nbsp;</p>", "ALL")>
	
	<cfscript>
		matches = rematch("<footer>(.*)</footer>", text);
		results = "";
		for (match in matches)
		{
			found = rereplace(match, "<footer>(.*)</footer>", "\1");
		    results = results & found; 
			text = replace (text,found,"","ALL"); 
		
		}
	</cfscript>	

	<cfif DocumentFooter eq "">
		<cfset vDocumentFooter = results>
	<cfelse>
		<cfset vDocumentFooter = DocumentFooter>
	</cfif>
	
	<cfif vDocumentFooter neq "">
		<cfset vDocumentmarginbottom = vDocumentmarginbottom + 2>
	</cfif>
	
	<cftry>
			
				
	<cfdocument 
      format       = "#URL.Format#"
	  overwrite    = "yes"	  
      pagetype     = "#vDocumentpagesize#"
	  orientation  = "#documentorientation#"
      unit         = "cm"
      encryption   = "none"
	  margintop    = "#vDocumentmargintop#"
      marginbottom = "#vDocumentmarginbottom#"
      marginright  = "0"
      marginleft   = "0"
      fontembed    = "No"
      scale        = "#vDocumentscale#"
      backgroundvisible="Yes">	

			#text#
							  
		<cfif DocumentHeader neq "">
		
			<cfdocumentitem type="header">
				#DocumentHeader#
			</cfdocumentitem>
						
		</cfif>  

	
		<cfif vDocumentFooter neq "">
			<cfdocumentitem type="footer">			
				#vDocumentFooter#
			</cfdocumentitem>			
		</cfif>  
										
	</cfdocument>
	
	<cfcatch>
	
		<cfdocument 
	      format       = "#URL.Format#"
	      pagetype     = "#vDocumentpagesize#"
		  orientation  = "#documentorientation#"
	      unit         = "cm"
	      encryption   = "none"
		  margintop    = "#documentmargintop#"
	      marginbottom = "#documentmarginbottom#"
	      marginright  = "0"
	      marginleft   = "0"
	      fontembed    = "Yes"
	      scale        = "#documentscale#"
	      backgroundvisible="Yes">			  
			  Problem : document could not be created.
		  
		 </cfdocument> 	
	
	</cfcatch>
	
	</cftry>
	
<cfelse>

	<!--- added for NY --->
	<!---
	<cfheader name="Content-Disposition" value="inline; filename=timeframe.doc" >
    <cfcontent type="application/word"> 	
	--->
	
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">		
	<cfset text = replace("#DocumentContent#", "@pb", "<tr style='page-break-after: always;'></tr>", "ALL")>	
	<cfoutput>#Text#</cfoutput>
	
	<script>
	 window.print()
	</script>

</cfif>	

</cfoutput>


